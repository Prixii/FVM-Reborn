/// 
function Stove_ModManagerUtils() constructor {
    /// @param {Struct.Stove_ModManifest} _manifest
    static _is_mod_manifest_valid = function(_manifest) {
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
        var _json_result = global.stove.file_utils.load_json_from_path(_path)
        if (_json_result.is_failed) {
            return _json_result
        }
        if (!_is_mod_manifest_valid (_json_result.data)) {
            return new Result().fail(STOVE_ERROR.INVALID_METADATA, "Invalid mod manifest format: " + _path)
        }
        return _json_result
    }

}