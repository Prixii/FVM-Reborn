/// 
function Stove_StageManager() constructor {
    self._stage_metadatas = {} // use struct instead of map to enable auto gc

    self.util = new Stove_StageManagerUtils()
    self.factory = new Stove_StageManagerFactory()
    
    /// @param {Struct.Stove_StageMetadata} _metadata 
    static _add_stage_metadata = function(_stage_metadata) {
        // 动态字符串键必须用 variable_struct_set；方括号访问会把键当数组下标并尝试 int64
        variable_struct_set(self._stage_metadatas, string(_stage_metadata.id), _stage_metadata)
    }

    /// @returns {Struct.Result} 
    static register_stage_metadata_from_lua_table = function(_lua_table) {
        var _stage_metadata_result = self.factory.create_stage_metadata_from_lua_table(_lua_table)
        if (_stage_metadata_result.is_failed()) {
            global.stove.logger.log_e("register_stage_metadata_from_lua_table: " + _stage_metadata_result.get_error_stack())
            return _stage_metadata_result
        }
        var _stage_metadata = _stage_metadata_result.data
        self._add_stage_metadata(_stage_metadata)

        return new Result().success()
    }

    /// @description After _stage_metadatas is populated: register one synthetic map into global.maps_map (same mechanism as maps_init / register_map).
    /// Map id is "stove_mod" — use global.maps_map[? "stove_mod"].levels_data for a tower-like Mod GUI.
    /// @returns {Struct.Result} 
    static register_mod_stages = function() {
        var _logger = global.stove.logger
        if (!variable_global_exists("maps_map") || !ds_exists(global.maps_map, ds_type_map)) {
            return new Result().fail(STOVE_ERROR.INVALID_METADATA, "register_mod_stages: global.maps_map missing — call after maps_init()")
        }

        var _ids = variable_struct_get_names(self._stage_metadatas)
        self.util.sort_string_ids_asc(_ids)
        var _n = array_length(_ids)
        var _levels_data = []
        for (var _i = 0; _i < _n; _i++) {
            var _id = _ids[_i]
            var _meta = variable_struct_get(self._stage_metadatas, _id)
            self.factory.load_stage_metadata_assets(_meta)
            array_push(_levels_data, self.util.level_entry_from_stage_metadata(_meta, _i))
        }

        if (_n == 0) {
            _logger.log_w("register_mod_stages: no stage metadata to register")
            return new Result().success()
        }

        var _map_data = {
            map_name: "Mod 关卡",
            map_sprite: spr_tower_cake_bg,
            levels_data: _levels_data
        }
        register_or_replace_map("stove_mod", _map_data)
        _logger.log_d("register_mod_stages: registered map 'stove_mod' with " + string(_n) + " level(s) into global.maps_map")
        return new Result().success()
    }

    /// @returns {Array<String>} 已注册关卡 id 升序（与 register_mod_stages 中 levels_data 顺序一致）
    static get_registered_stage_ids_sorted = function() {
        var _ids = variable_struct_get_names(self._stage_metadatas)
        self.util.sort_string_ids_asc(_ids)
        return _ids
    }

    /// 仅处理 self._stage_metadatas 中的关卡：写入 global.level_data / global.level_id / global.level_file，供 room_ready 后开战。
    /// @param {String} _stage_id 
    /// @param {Real} [_button_index] 与 level_entry_from_stage_metadata 中按钮布局一致，默认 0
    /// @returns {Struct.Result} 
    static prepare_playable_level_from_registered_stage = function(_stage_id, _button_index = 0) {
        var _sid = string(_stage_id)
        if (!variable_struct_exists(self._stage_metadatas, _sid)) {
            return new Result().fail(STOVE_ERROR.NO_SUCH_RESOURCE,
                "prepare_playable_level_from_registered_stage: id not in _stage_metadatas: " + _sid)
        }
        var _meta = variable_struct_get(self._stage_metadatas, _sid)
        return self._prepare_playable_level_from_metadata(_meta, _button_index)
    }

    /// 按 get_registered_stage_ids_sorted 的下标选关（0 .. n-1）。
    // var _manager = global.stove.stage_manager
    // var prep_init = _manager.prepare_playable_level_from_registered_stage_index(0)
    // global.map_id = "stove_mod"
    // global.map_name = "这是 MOD 关卡"
    // room_goto(room_ready)
    /// @param {Real} _index 
    /// @returns {Struct.Result} 
    static prepare_playable_level_from_registered_stage_index = function(_index) {
        var _ids = variable_struct_get_names(self._stage_metadatas)
        var _n = array_length(_ids)
        if (_n <= 0) {
            return new Result().fail(STOVE_ERROR.INVALID_METADATA,
                "prepare_playable_level_from_registered_stage_index: _stage_metadatas is empty")
        }
        self.util.sort_string_ids_asc(_ids)
        var _i = floor(real(_index))
        if (_i < 0 || _i >= _n) {
            return new Result().fail(STOVE_ERROR.INVALID_METADATA,
                "prepare_playable_level_from_registered_stage_index: index out of range: " + string(_index))
        }
        return self.prepare_playable_level_from_registered_stage(_ids[_i], _i)
    }

    /// @param {Struct.Stove_StageMetadata} _meta 
    /// @param {Real} _button_index 
    /// @returns {Struct.Result} 
    static _prepare_playable_level_from_metadata = function(_meta, _button_index) {
        /// @type {Struct.Stove_StageData} 
        var _level_data = self.util.level_entry_from_stage_metadata(_meta, _button_index)
        var _use_hard = false
        if (variable_global_exists("difficulty")) {
            _use_hard = global.difficulty >= 2
        }
        var _file_path = global.stove.file_utils.resolve_level_data_buffer_path(
            _level_data.level_file,
            _level_data.hard_level_file,
            _use_hard
        )
        if (!file_exists(_file_path)) {
            return new Result().fail(STOVE_ERROR.NO_SUCH_FILE, "prepare_playable_level: file not found: " + _file_path)
        }
        var _buffer = buffer_load(_file_path)
        if (!buffer_exists(_buffer)) {
            return new Result().fail(STOVE_ERROR.NO_SUCH_FILE, "prepare_playable_level: buffer_load failed: " + _file_path)
        }
        var _json_string = buffer_read(_buffer, buffer_string)
        buffer_delete(_buffer)

        var _parsed = undefined
        try {
            _parsed = json_parse(_json_string)
        } catch (_e) {
            return new Result().fail(STOVE_ERROR.JSON_PARSE_FAILED,
                "prepare_playable_level: json_parse: " + string(_e))
        }
        if (_parsed == -1 || (!is_struct(_parsed) && !is_array(_parsed))) {
            return new Result().fail(STOVE_ERROR.JSON_PARSE_FAILED,
                "prepare_playable_level: invalid json root: " + _file_path)
        }

        global.level_data = _level_data
        global.level_id = _level_data.id
        global.level_file = _parsed
        return new Result().success()
    }
}