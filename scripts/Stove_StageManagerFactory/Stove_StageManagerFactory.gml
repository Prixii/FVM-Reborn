/// 
function Stove_StageManagerFactory() constructor {
    /// @param {Struct} _s 
    /// @param {String} _camel 
    /// @param {String} [_snake] 
    static _stage_struct_get = function(_s, _camel, _snake = undefined) {
        if (!is_struct(_s)) {
            return undefined
        }
        if (struct_exists(_s, _camel)) {
            return variable_struct_get(_s, _camel)
        }
        if (_snake != undefined && struct_exists(_s, _snake)) {
            return variable_struct_get(_s, _snake)
        }
        return undefined
    }

    /// @param {String} _mod_root 
    /// @param {String} _json_path 
    /// @returns {String} 
    static _resolve_stage_json_path = function(_mod_root, _json_path) {
        var jp = string(_json_path)
        jp = string_replace_all(jp, "\\", "/")
        var root = string_replace_all(string(_mod_root), "\\", "/")
        while (string_length(root) > 0 && string_char_at(root, string_length(root)) == "/") {
            root = string_delete(root, string_length(root), 1)
        }
        if (string_length(jp) >= 2 && string_char_at(jp, 2) == ":") {
            return jp
        }
        if (string_length(jp) >= 1 && string_char_at(jp, 1) == "/") {
            return jp
        }
        if (root == "") {
            return jp
        }
        return root + "/" + jp
    }

    /// 关卡 JSON 常与 level_data 一致、根级无 id；用于 StageManager 键与 level_entry。
    /// @param {String} _json_path 
    /// @returns {String} 
    static _stage_id_fallback_from_json_path = function(_json_path) {
        var p = string(_json_path)
        p = string_replace_all(p, "\\", "/")
        var fn = filename_name(p)
        var dot = string_pos(".", fn)
        if (dot > 1) {
            return string_copy(fn, 1, dot - 1)
        }
        return (fn != "") ? fn : "mod_stage"
    }

    /// Lua / JSON 常用 camelCase「gmlAsset」（推荐 GML 资源名字符串，如 spr_xxx / mus_xxx）；GML 侧 Stove_Asset 使用 gml_asset_name。
    /// @param {Struct|Undefined} _raw 
    /// @returns {Struct.Stove_Asset|Undefined} 
    static _normalize_stage_asset = function(_raw) {
        if (_raw == undefined || !is_struct(_raw)) {
            return undefined
        }
        var _out = new Stove_Asset()
        var _src = food_lua_plain_get(_raw, "source")
        _out.source = (_src == undefined) ? ASSET_SOURCE.IN_GAME : _src
        var _gml = food_lua_plain_get(_raw, "gmlAsset")
        if (_gml == undefined) {
            _gml = food_lua_plain_get(_raw, "gml_asset_name")
        }
        _out.gml_asset_name = _gml
        var _path = food_lua_plain_get(_raw, "path")
        if (_path != undefined) {
            _out.path = string(_path)
        }
        return _out
    }

    /// @param {Struct.Stove_Asset|Undefined} _asset 
    static _is_asset_valid = function(_asset) {
        if (!is_struct(_asset)) {
            return false
        }
        return (_asset.source == ASSET_SOURCE.IN_GAME && _asset.gml_asset_name != undefined) ||
            (_asset.source == ASSET_SOURCE.EXTERNAL && string_length(string(_asset.path)) > 0)
    }

    /// @param {Struct.Stove_StageMetadata} _metadata 
    static _is_metadata_valid = function(_metadata) {
        var _assets_valid = _is_asset_valid(_metadata.pre_music) &&
            _is_asset_valid(_metadata.elite_music) &&
            _is_asset_valid(_metadata.boss_music) &&
            _is_asset_valid(_metadata.background)
        var _have_json_path = string_length(string(_metadata.json_path)) > 0
        return _assets_valid && _have_json_path
    }

    /// @param {Struct.Stove_StageMetadata} _metadata 
    /// @returns {Struct.Result} 
    static init_stage_metadata = function(_metadata) {
        var _json_parse_result = global.stove.file_utils.load_json_from_path(string(_metadata.json_path))
        if (_json_parse_result.is_failed()) {
            return _json_parse_result
        }
        var _json = _json_parse_result.data
        if (struct_exists(_json, "id")) {
            _metadata.id = string(_json.id)
        } else {
            _metadata.id = _stage_id_fallback_from_json_path(_metadata.json_path)
        }
        return new Result().success()
    }

    static load_stage_metadata_assets = function(_metadata) {
        // TODO: this function will load assets
    }

    /// @returns {Struct.Result<Struct.Stove_StageMetadata>} 
    static create_stage_metadata_from_lua_table = function(_lua_table) {
        var stage_metadata = new Stove_StageMetadata()
        var _nm = food_lua_plain_get(_lua_table, "name")
        stage_metadata.name = _nm == undefined ? "" : string(_nm)
        var _desc = food_lua_plain_get(_lua_table, "description")
        stage_metadata.description = _desc == undefined ? "" : string(_desc)
        stage_metadata.pre_music = _normalize_stage_asset(food_lua_plain_get(_lua_table, "preMusic"))
        stage_metadata.elite_music = _normalize_stage_asset(food_lua_plain_get(_lua_table, "eliteMusic"))
        stage_metadata.boss_music = _normalize_stage_asset(food_lua_plain_get(_lua_table, "bossMusic"))
        stage_metadata.background = _normalize_stage_asset(food_lua_plain_get(_lua_table, "background"))
        var _auth = food_lua_plain_get(_lua_table, "author")
        stage_metadata.author = _auth == undefined ? "" : string(_auth)
        var _jp_raw = food_lua_plain_get(_lua_table, "jsonPath")
        if (_jp_raw == undefined) {
            stage_metadata.json_path = ""
        } else {
            var _mod_root = ""
            var _mm = global.stove.mod_manager
            if (!is_undefined(_mm) && is_string(_mm._active_mod_folder)) {
                _mod_root = _mm._active_mod_folder
            }
            if (_mod_root != "") {
                stage_metadata.json_path = _resolve_stage_json_path(_mod_root, string(_jp_raw))
            } else {
                stage_metadata.json_path = string(_jp_raw)
            }
        }

        if (!_is_metadata_valid(stage_metadata)) {
            return new Result().fail(STOVE_ERROR.INVALID_METADATA, "Invalid stage metadata")
        }

        var _init_result = init_stage_metadata(stage_metadata)
        if (_init_result.is_failed()) {
            return _init_result
        }

        return new Result().success(stage_metadata)
    }

    /// @param {Struct} _struct  Plain struct (e.g. from stages.json), same keys as Lua registration.
    /// @param {String} [_mod_root]  Mod folder path; relative jsonPath is resolved under this root.
    /// @returns {Struct.Result<Struct.Stove_StageMetadata>} 
    static create_stage_metadata_from_struct = function(_struct, _mod_root = "") {
        var stage_metadata = new Stove_StageMetadata()
        var _n = _stage_struct_get(_struct, "name", undefined)
        stage_metadata.name = _n == undefined ? "" : string(_n)
        var _d = _stage_struct_get(_struct, "description", undefined)
        stage_metadata.description = _d == undefined ? "" : string(_d)
        stage_metadata.pre_music = _normalize_stage_asset(_stage_struct_get(_struct, "preMusic", "pre_music"))
        stage_metadata.elite_music = _normalize_stage_asset(_stage_struct_get(_struct, "eliteMusic", "elite_music"))
        stage_metadata.boss_music = _normalize_stage_asset(_stage_struct_get(_struct, "bossMusic", "boss_music"))
        stage_metadata.background = _normalize_stage_asset(_stage_struct_get(_struct, "background", undefined))
        var _a = _stage_struct_get(_struct, "author", undefined)
        stage_metadata.author = _a == undefined ? "" : string(_a)
        var _jp = _stage_struct_get(_struct, "jsonPath", "json_path")
        if (_jp == undefined) {
            stage_metadata.json_path = ""
        } else if (_mod_root != "") {
            stage_metadata.json_path = _resolve_stage_json_path(_mod_root, string(_jp))
        } else {
            stage_metadata.json_path = string(_jp)
        }

        if (!_is_metadata_valid(stage_metadata)) {
            return new Result().fail(STOVE_ERROR.INVALID_METADATA, "Invalid stage metadata (struct)")
        }

        var _init_result = init_stage_metadata(stage_metadata)
        if (_init_result.is_failed()) {
            return _init_result
        }

        return new Result().success(stage_metadata)
    }

}