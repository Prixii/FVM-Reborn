/// 
global.stove.mod_manager = {
    utils: new Stove_ModManagerUtils(),
}

function Stove_ModManager() constructor {
    self.mod_metadatas = {}

    /// @param {String} _mod_parent_folder 
    static init = function(_mod_parent_folder) {
        var _mod_foders = global.stove.file_utils.find_subfolders(_mod_parent_folder)
        for (var i = 0; i < ds_list_size(_mod_foders); i++) {
            var _register_mod_result = self._register_mod(_mod_foders[i])
            if (_register_mod_result.is_failed()) {
                
            }
        }
    }


    /// @returns {Struct.Result<String>} key of mod
    static _register_mod = function(_mod_path) {
        var _manifest_path = _mod_path + "\\manifest.json"
        var _manifest_load_result = global.stove.mod_manager.utils.load_mod_manifest_and_parse(_manifest_path)
        if (_manifest_load_result.is_failed()) {
            return _manifest_load_result
        }
        var _manifest = _manifest_load_result.data
        var _mod_metadata = new Stove_ModMetadata(_manifest)
        self._add_mod_metadata(_mod_metadata)
        return new Result().success(_manifest_path)
    }

    /// @param {Struct.Stove_ModMetadata} _mod_metadata 
    static _add_mod_metadata = function(_mod_metadata) {
        self.mod_metadatas[$ _mod_metadata.manifest.id] = _mod_metadata
    }

    /// @param {String} _mod_key 
    /// @returns {Stove_ModMetadata|Undefined} 
    static get_mod_metadata = function(_mod_key) {
        return self.mod_metadatas[$ _mod_key]
    }

}