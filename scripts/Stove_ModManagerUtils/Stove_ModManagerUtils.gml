/// 
function Stove_ModManagerUtils() constructor {
    /// @returns {Struct.Result<Struct>} 
    static _parse_json = function(_raw_json) {
        try {
            var _json = json_parse(_raw_json)
            return new Result().success(_json)
        } catch (e) {
            return new Result().fail(STOVE_ERROR.JSON_PARSE_FAILED, "Failed to parse JSON: " + string(e))
        }
    }

    /// @param {Struct.Stove_ModManifest} _manifest
    static _is_mod_manifest_valid = function(_manifest) {
        if (!is_struct(_manifest)) return false
        if ((!struct_exists(_manifest, "entry_script"))
            || (!struct_exists(_manifest, "main_function"))
            || (!struct_exists(_manifest, "id"))) {
            return false
        }
        return true
    }

    /// @param {String} _path 
    /// @returns {Struct.Result<Struct>}
    static load_mod_manifest_and_parse = function(_path) {
        if (!file_exists(_path)) {
            return new Result().fail(STOVE_ERROR.NO_SUCH_FILE, "Mod manifest file not found: " + _path)
        }
        var _file = file_text_open_read(_path)
        var _raw_json = ""
        while (!file_text_eof(_file)) {
            _raw_json += file_text_read_string(_file)
        }
        var _json_result = self._parse_json(_raw_json)
        if (_json_result.is_failed) {
            return _json_result
        }
        if (!_is_mod_manifest_valid (_json_result.data)) {
            return new Result().fail(STOVE_ERROR.INVALID_MOD_MANIFEST, "Invalid mod manifest format: " + _path)
        }
        return _json_result
    }
}