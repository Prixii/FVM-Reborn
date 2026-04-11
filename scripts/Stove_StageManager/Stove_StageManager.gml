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
}