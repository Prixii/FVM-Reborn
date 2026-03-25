/// 
/// @param {String} _path 
/// @param {Real} _frame_count
/// @param {Real} _offset_x 
/// @param {Real} _offset_y 
/// @param {Bool} _auto_register     
function SpriteSheetInfo(_path, _frame_count, _offset_x, _offset_y, _auto_register = true) constructor {
    self.path = _path
    self.frame_count = _frame_count
    self.key = string_replace_all(string_lower(_path), "\\", "/");
    self.offset_x = _offset_x
    self.offset_y = _offset_y

    if (_auto_register) {
        global.stove_system.sprite_manager.register_sprite(self)
    }
}

function ModSpriteManager() constructor {
    self.sprite_pool = {}
    self.sprite_meta_datas = {}


    /// @param {Struct.SpriteSheetInfo} _info 
    static register_sprite = function(_info) {
        if (!variable_struct_exists(sprite_meta_datas, _info.key)) {
            sprite_meta_datas[$ _info.key] = _info
        }
    }

    /// @param {String} key 
    /// @returns {Asset.GMSprite}
    static request_sprite = function(_key) {
        if (!variable_struct_exists(sprite_meta_datas, _key)) return -1;

        if (variable_struct_exists(sprite_pool, _key)) {
            return sprite_pool[$ _key];
        }

        var _meta = sprite_meta_datas[$ _key];
        var _new_spr = sprite_add(
            _meta.path, 
            _meta.frame_count, 
            true, true, 
            _meta.offset_x, _meta.offset_y)
        
        if (_new_spr != -1) {
            sprite_pool[$ _key] = _new_spr;
            return _new_spr;
        }

        return -1
    }

    static release_all_sprites = function() {
        var _names = variable_struct_get_names(sprite_pool);
        for (var i = 0; i < array_length(_names); i++) {
            var _spr = sprite_pool[$ _names[i]];
            if (sprite_exists(_spr)) sprite_delete(_spr);
        }
        self.sprite_pool = {};
    }
}
