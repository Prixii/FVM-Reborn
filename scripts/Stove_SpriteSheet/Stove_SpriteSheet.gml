/// 

/// 1. collect all SpriteSheetInfo and AnimationClip
/// 2. register SpriteSheetInfo and collect them into surfaces
/// 3. for each AnimationClip, get the target surface and other info
///
/// 烘焙流程（可行性）：sprite_add 加载 → 画入 atlas surface → 记录 baked_layout → unload 动态 sprite。
/// 运行时绘制：AnimationClip 用 draw_surface_part；兼容 draw_self 可走 request_sprite（从 surface 重建多帧 sprite，结果缓存在 sprite_pool）。

/// @param {String} _path 
/// @param {Real} _frame_count 
function SpriteSheetInfo(_path, _frame_count) constructor {
    self.path = _path
    self.key = string_replace_all(string_lower(_path), "\\", "/");
    
    self.frame_count = _frame_count
    /// @type {Real|Undefined} 
    self.frame_width = undefined
    /// @type {Real|Undefined} 
    self.frame_height = undefined
    /// @type {Real|Undefined} 
    self.texture_width = undefined  
    /// @type {Real|Undefined} 
    self.texture_height = undefined 

    /// @type {Asset.GMSprite|Undefined} 
    self.sprite_index = undefined

    /// @returns {Struct.Result} 
    static load_sprite = function() {
        if (self.sprite_index != undefined && sprite_exists(self.sprite_index)) {
            return new Result().success()
        }

        var _sprite = sprite_add(self.path, self.frame_count, false, false, 0, 0)
        if (_sprite == -1) {
            return new Result().fail(
                STOVE_ERROR.LOAD_RESOURCE_FAILED, 
                "Failed to load sprite from path: " + self.path)
        }

        self.sprite_index = _sprite
        self.texture_width = sprite_get_width(_sprite)
        self.texture_height = sprite_get_height(_sprite)

        self.frame_width = self.texture_width / self.frame_count
        self.frame_height = self.texture_height

        return new Result().success()
    }

    static unload_sprite = function() {
        if (self.sprite_index != undefined && sprite_exists(self.sprite_index)) {
            sprite_delete(self.sprite_index)
        }
        self.sprite_index = undefined
    }
}

/// 烘焙后在 atlas surface 上的布局（与 ModSpriteManager.baked_layout 条目一一对应）
/// @param {String} _surface_key 
/// @param {Real} _x 
/// @param {Real} _y 
/// @param {Real} _frame_w 
/// @param {Real} _frame_h 
/// @param {Real} _frame_count 
function StoveBakedLayout(_surface_key, _x, _y, _frame_w, _frame_h, _frame_count) constructor {
    self.surface_key = _surface_key
    self.x = _x
    self.y = _y
    self.frame_w = _frame_w
    self.frame_h = _frame_h
    self.frame_count = _frame_count
}

function AnimationClip(_sprite_sheet_key, _start_frame, _frame_count) constructor {
    self.sprite_sheet_key = _sprite_sheet_key 
    self.start_frame = _start_frame
    self.frame_count = _frame_count
    /// @type {Id.Surface|Undefined} 
    self.surface_id = undefined
    /// @type {Real|Undefined} 
    self.frame_width = undefined
    /// @type {Real|Undefined} 
    self.frame_height = undefined
    /// @type {String|Undefined} 
    self.surface_key = undefined
    /// @type {Real}  在 atlas surface 上的像素原点 X（整张贴图条带左上角）
    self._atlas_x = 0
    /// @type {Real}  在 atlas surface 上的像素原点 Y
    self._atlas_y = 0


    /// @returns {Struct.Result} 
    static get_sprite_in_surface = function() {
        var _get_surface_key_result = global.stove.sprite_manager.get_surface_key_by_sprite_sheet_key(self.sprite_sheet_key)
        if (_get_surface_key_result.is_failed()) {
            return _get_surface_key_result
        }

        self.surface_key = _get_surface_key_result.data
        self.surface_id = global.stove.sprite_manager.get_surface_id(self.surface_key)
        var _layout = global.stove.sprite_manager.get_baked_layout(self.sprite_sheet_key)
        
        if (is_undefined(self.surface_id) || !surface_exists(self.surface_id) || is_undefined(_layout)) {
            return new Result().fail(
                STOVE_ERROR.NO_SUCH_RESOURCE, 
                "Baked layout or surface not found for key: " + self.sprite_sheet_key)
        }

        self.frame_width = _layout.frame_w
        self.frame_height = _layout.frame_h
        self._atlas_x = _layout.x
        self._atlas_y = _layout.y
        return new Result().success()
    }
        
    /// @param {Real} _frame  相对本 clip 的帧（0 .. frame_count-1）
    static draw = function(_frame, _x, _y, _scale_x = 1, _scale_y = 1) {
        if (is_undefined(surface_id) || !surface_exists(surface_id)) {
            return
        }
        var _layout = global.stove.sprite_manager.get_baked_layout(sprite_sheet_key)
        if (is_undefined(_layout)) {
            return
        }

        var _fi = clamp(floor(_frame), 0, max(0, frame_count - 1))
        var _abs = start_frame + _fi
        _abs = clamp(_abs, 0, max(0, _layout.frame_count - 1))

        var _sx = _atlas_x + _abs * frame_width
        var _sy = _atlas_y
        draw_surface_part_ext(
            surface_id,
            _sx, _sy, frame_width, frame_height,
            _x, _y, _scale_x, _scale_y,
            c_white, 1)
    }
}

function ModSpriteManager() constructor {
    self.sprite_pool = {}
    self.sprite_meta_datas = {}                 /// @description sprite_sheet_key -> SpriteSheetInfo
    /// sprite_sheet_key -> 所在分页的 surface_key（字符串）
    self.surface_sprite_info_key_map = {}
    self.surface_key_to_id = {}                 /// @description surface_key -> Id.Surface
    self.surface_counter = 0

    /// @description sprite_sheet_key -> 烘焙后在 atlas 上的矩形与分页信息
    self.baked_layout = {}

    /// @description 当前分页打包游标（多 surface 分页）
    self.pack_surface_id = undefined
    self.pack_surface_key = undefined
    self.pack_x = 0
    self.pack_y = 0
    self.pack_row_h = 0

    static get_surface_id = function(_surface_key) {
        if (variable_struct_exists(surface_key_to_id, _surface_key)) {
            return surface_key_to_id[$ _surface_key]
        }
        return undefined
    }

    /// @param {String} _sprite_sheet_key 
    /// @returns {Struct.StoveBakedLayout|Undefined} 
    static get_baked_layout = function(_sprite_sheet_key) {
        if (variable_struct_exists(baked_layout, _sprite_sheet_key)) {
            return baked_layout[$ _sprite_sheet_key]
        }
        return undefined
    }

    static get_surface_key = function(counter) {
        return "surface_" + string(counter)
    }

    /// @param {Struct.SpriteSheetInfo} _info 
    static register_sprite = function(_info) {
        if (!variable_struct_exists(sprite_meta_datas, _info.key)) {
            sprite_meta_datas[$ _info.key] = _info
        }
    }

    // TODO: 启用 surface 落盘后，从文件恢复分页纹理；当前可行性阶段不使用。
    /// @param {String} _surface_key
    /// @returns {Struct.Result<Id.Surface>} 
    static restore_surfaces = function(_surface_key) {
        if (!file_exists(_surface_key)) {
            return new Result().fail(
                STOVE_ERROR.NO_SUCH_FILE, 
                "Surface file not found for surface id: " + _surface_key)
        }
        var _temp_sprite = sprite_add(_surface_key, 1, false, false, 0, 0)
        if (_temp_sprite == -1) {
            return new Result().fail(
                STOVE_ERROR.LOAD_RESOURCE_FAILED, 
                "Failed to load surface from file: " + _surface_key)
        }
        var _new_surface = surface_create(kSurfaceSize, kSurfaceSize)
        if (_new_surface == -1) {
            sprite_delete(_temp_sprite)
            return new Result().fail(
                STOVE_ERROR.LOAD_RESOURCE_FAILED, 
                "Failed to create new surface with size: " + string(kSurfaceSize) + "x" + string(kSurfaceSize))
        }
        surface_set_target(_new_surface)
        draw_clear_alpha(c_black, 0)
        gpu_set_blendenable(false)
        draw_sprite(_temp_sprite, 0, 0, 0)
        gpu_set_blendenable(true)
        surface_reset_target()
        
        sprite_delete(_temp_sprite)

        surface_key_to_id[$ _surface_key] = _new_surface
        return new Result().success(_new_surface)
    }

    /// @param {String} _sprite_sheet_info_key 
    /// @returns {Struct.Result<String>}  分页 surface 的逻辑 key（非句柄）
    static get_surface_key_by_sprite_sheet_key = function(_sprite_sheet_info_key) {
        if (!variable_struct_exists(surface_sprite_info_key_map, _sprite_sheet_info_key)) {
            return new Result().fail(
                STOVE_ERROR.NO_SUCH_RESOURCE, 
                "Surface page not mapped for sprite sheet key: " + _sprite_sheet_info_key)
        }
        var _page_key = surface_sprite_info_key_map[$ _sprite_sheet_info_key]
        var _sid = get_surface_id(_page_key)
        if (is_undefined(_sid) || !surface_exists(_sid)) {
            return new Result().fail(
                STOVE_ERROR.NO_SUCH_RESOURCE, 
                "Surface page missing or freed: " + _page_key)
        }
        return new Result().success(_page_key)
    }

    /// @param {String} _sprite_sheet_info_key 
    /// @returns {Struct.SpriteSheetInfo|Undefined} 
    static get_sprite_sheet_info = function(_sprite_sheet_info_key) {
        if (variable_struct_exists(sprite_meta_datas, _sprite_sheet_info_key)) {
            return sprite_meta_datas[$ _sprite_sheet_info_key]
        }
        return undefined
    }

    // TODO: 与 surface_save 落盘流程对接；当前可行性阶段可忽略。
    /// @param {String} _surface_key 
    /// @returns {Struct.Result} 
    static cache_and_create_new_surface = function(_surface_key) {
        if (!is_undefined(_surface_key)) {
            var _surface_id = surface_key_to_id[$ _surface_key]
            if (is_undefined(_surface_id)) {
                return new Result().fail(
                    STOVE_ERROR.NO_SUCH_RESOURCE, 
                    "Surface not found for key: " + _surface_key)
            }
            surface_save(_surface_id, _surface_key)
        }
        var _new_id = surface_create(kSurfaceSize, kSurfaceSize)
        if (_new_id == -1) {
            return new Result().fail(
                STOVE_ERROR.LOAD_RESOURCE_FAILED, 
                "Failed to create new surface with size: " + string(kSurfaceSize) + "x" + string(kSurfaceSize))
        }
        var _new_key = get_surface_key(surface_counter)
        surface_counter++
        surface_key_to_id[$ _new_key] = _new_id
        return new Result().success(_new_id)
    }

    /// @returns {Struct.Result<Struct>}  data: { surface_key, surface_id }
    static _create_surface_page = function() {
        var _key = get_surface_key(surface_counter)
        surface_counter++
        var _sid = surface_create(kSurfaceSize, kSurfaceSize)
        if (_sid == -1) {
            return new Result().fail(
                STOVE_ERROR.LOAD_RESOURCE_FAILED,
                "Failed to create atlas surface " + _key)
        }
        surface_key_to_id[$ _key] = _sid
        surface_set_target(_sid)
        draw_clear_alpha(c_black, 0)
        surface_reset_target()
        return new Result().success({ surface_key: _key, surface_id: _sid })
    }

    /// @description 释放 request_sprite 生成的运行时 sprite（不释放 atlas surface）
    static clear_sprite_pool = function() {
        var _names = variable_struct_get_names(sprite_pool)
        for (var i = 0; i < array_length(_names); i++) {
            var _k = _names[i]
            var _spr = sprite_pool[$ _k]
            if (sprite_exists(_spr)) {
                sprite_delete(_spr)
            }
        }
        sprite_pool = {}
    }

    // TODO: 重新烘焙前释放所有 atlas surface（surface_free）并清空 baked_layout / 映射
    static clear_atlas_surfaces = function() {
        var _keys = variable_struct_get_names(surface_key_to_id)
        for (var j = 0; j < array_length(_keys); j++) {
            var _sk = _keys[j]
            var _id = surface_key_to_id[$ _sk]
            if (!is_undefined(_id) && surface_exists(_id)) {
                surface_free(_id)
            }
        }
        surface_key_to_id = {}
        baked_layout = {}
        surface_sprite_info_key_map = {}
        pack_surface_id = undefined
        pack_surface_key = undefined
        pack_x = 0
        pack_y = 0
        pack_row_h = 0
        surface_counter = 0
    }

    /// @param {Struct.SpriteSheetInfo} _info  须已 load_sprite 且 sprite 有效
    /// @returns {Struct.Result<Real>}  当前分页 surface 句柄（便于链式烘焙）
    static add_sprite_to_surface = function(_info) {
        if (!sprite_exists(_info.sprite_index)) {
            return new Result().fail(
                STOVE_ERROR.LOAD_RESOURCE_FAILED,
                "Invalid sprite when baking: " + _info.key)
        }

        var _strip_w = _info.frame_width * _info.frame_count
        var _strip_h = _info.frame_height

        if (_strip_w > kSurfaceSize || _strip_h > kSurfaceSize) {
            return new Result().fail(
                STOVE_ERROR.LOAD_RESOURCE_FAILED,
                "Sprite strip larger than atlas page: " + _info.key)
        }

        if (is_undefined(pack_surface_id) || !surface_exists(pack_surface_id)) {
            var _page = _create_surface_page()
            if (_page.is_failed()) {
                return _page
            }
            pack_surface_id = _page.data.surface_id
            pack_surface_key = _page.data.surface_key
            pack_x = 0
            pack_y = 0
            pack_row_h = 0
        }

        if (pack_x + _strip_w > kSurfaceSize) {
            pack_x = 0
            pack_y += pack_row_h
            pack_row_h = 0
        }
        if (pack_y + _strip_h > kSurfaceSize) {
            var _page2 = _create_surface_page()
            if (_page2.is_failed()) {
                return _page2
            }
            pack_surface_id = _page2.data.surface_id
            pack_surface_key = _page2.data.surface_key
            pack_x = 0
            pack_y = 0
            pack_row_h = 0
        }

        surface_set_target(pack_surface_id)
        gpu_set_blendenable(false)
        for (var _f = 0; _f < _info.frame_count; _f++) {
            draw_sprite(_info.sprite_index, _f, pack_x + _f * _info.frame_width, pack_y)
        }
        gpu_set_blendenable(true)
        surface_reset_target()

        baked_layout[$ _info.key] = new StoveBakedLayout(
            pack_surface_key,
            pack_x,
            pack_y,
            _info.frame_width,
            _info.frame_height,
            _info.frame_count)
        surface_sprite_info_key_map[$ _info.key] = pack_surface_key

        pack_x += _strip_w
        if (_strip_h > pack_row_h) {
            pack_row_h = _strip_h
        }

        return new Result().success(pack_surface_id)
    }

    /// @description 烘焙完成后从 surface 生成可与 draw_self 配合的多帧 sprite；结果缓存在 sprite_pool。
    /// @param {String} _key  与 SpriteSheetInfo.key 一致
    /// @returns {Asset.GMSprite} 
    static request_sprite = function(_key) {
        if (variable_struct_exists(sprite_pool, _key)) {
            return sprite_pool[$ _key]
        }
        var _layout = get_baked_layout(_key)
        if (is_undefined(_layout)) {
            show_debug_message("Stove ModSpriteManager: key not baked, call bake_all_sprites first: " + string(_key))
            return -1
        }
        var _sid = get_surface_id(_layout.surface_key)
        if (is_undefined(_sid) || !surface_exists(_sid)) {
            return -1
        }

        var _fw = _layout.frame_w
        var _fh = _layout.frame_h
        var _fc = _layout.frame_count
        var _spr = sprite_create_from_surface(_sid, _layout.x, _layout.y, _fw, _fh, false, false, 0, 0)
        if (_spr == -1) {
            return -1
        }
        for (var _i = 1; _i < _fc; _i++) {
            sprite_add_from_surface(_spr, _sid, _layout.x + _i * _fw, _layout.y, _fw, _fh, false, false)
        }
        sprite_pool[$ _key] = _spr
        return _spr
    }

    /// @returns {Struct.Result} 
    static bake_all_sprites = function() {
        clear_sprite_pool()
        clear_atlas_surfaces()

        var _names = variable_struct_get_names(sprite_meta_datas)
        for (var i = 0; i < array_length(_names); i++) {
            var _sheet_key = _names[i]
            var _info = get_sprite_sheet_info(_sheet_key)

            var _result = _info.load_sprite()
            if (_result.is_failed()) {
                return _result.wrap(
                    STOVE_ERROR.LOAD_RESOURCE_FAILED, 
                    "Failed to load sprite sheet for key: " + _sheet_key)
            }
            
            var _bake_result = add_sprite_to_surface(_info)
            if (_bake_result.is_failed()) {
                return _bake_result.wrap(
                    STOVE_ERROR.LOAD_RESOURCE_FAILED, 
                    "Failed to bake sprite sheet to surface for key: " + _sheet_key)
            }

            _info.unload_sprite()
        }
        return new Result().success()
    }

}
