/// 

function Stove_ModManager() constructor {
    self.mod_metadatas = {}
    /// @type {Array<String>} 
    self.mod_keys = []
    /// @type {Struct.Stove_LuaManager} 
    self.lua_manager = undefined
    /// @type {Struct.Stove_FileUtils} 
    self.file_utils = undefined
    /// @type {Struct.Stove_Logger}
    self.logger = undefined

    self.utils = new Stove_ModManagerUtils()

    /// @returns {Struct.Result<String>} key of mod
    static _register_mod = function(_mod_path) {
        var _manifest_path = _mod_path + "/manifest.json"
        var _manifest_load_result = utils.load_mod_manifest_and_parse(_manifest_path)
        if (_manifest_load_result.is_failed()) {
            return _manifest_load_result
        }
        var _manifest = _manifest_load_result.data
        var _mod_metadata = new Stove_ModMetadata(_manifest, _mod_path)
        self._add_mod_metadata(_manifest_path, _mod_metadata)
        return new Result().success(_manifest_path)
    }

    /// @param {String} _key (mod path)
    /// @param {Struct.Stove_ModMetadata} _mod_metadata 
    static _add_mod_metadata = function(_key, _mod_metadata) {
        self.mod_metadatas[$ _key] = _mod_metadata
    }

    /// @param {String} _mod_key 
    /// @returns {Struct.Stove_ModMetadata|Undefined} 
    static _get_mod_metadata = function(_mod_key) {
        return self.mod_metadatas[$ _mod_key]
    }

    /// @param {String} _mod_key 
    /// @returns {Struct.Result} 
    static _run_mod_entry_function = function(_mod_key) {
        var _mod_metadata = self._get_mod_metadata(_mod_key)
        if (_mod_metadata == undefined) {
            return
        }
        return lua_manager.run_lua_function(
            _mod_metadata.get_script_path(_mod_metadata.manifest.main_script), 
            _mod_metadata.manifest.entry_function)
    }

    /// @param {String} _mod_key 
    /// @returns {Struct.Result} 
    static _load_mod_lua_scripts = function(_mod_key) {
        var _mod_meta_data = _get_mod_metadata(_mod_key)
        if (is_undefined(_mod_meta_data)) {
            return new Result().fail(STOVE_ERROR.LOAD_RESOURCE_FAILED, "Mod not found: " + _mod_key)
        }

        var _scripts = global.stove.file_utils.find_files_with_extension_recursively(_mod_meta_data.folder_path, ".lua")
        for (var i = 0; i < array_length(_scripts); i++) {
            var _result = lua_manager.load_lua(_scripts[i])
            if (_result.is_failed()) {
                return _result
            }
        }
        return new Result().success()
    }

    static init = function() {
        self.lua_manager = global.stove.lua_manager
        self.file_utils = global.stove.file_utils
        self.logger = global.stove.logger
        self.lua_manager.init()
    }

    /// @param {String} _mod_parent_folder 
    static register_all_mods = function(_mod_parent_folder) {
        var _mod_folders = self.file_utils.find_sub_folders(_mod_parent_folder)
        for (var i = 0; i < array_length(_mod_folders); i++) {
            var _register_mod_result = self._register_mod(_mod_folders[i])
            if (_register_mod_result.is_failed()) {
                if (_register_mod_result.code == STOVE_ERROR.NO_SUCH_FILE) {
                    logger.log_w("No manifest.json in folder:[" + _mod_folders[i] + "] probably not a mod folder")
                } else {
                    return _register_mod_result
                }
            } else {
                logger.log_d("Registered mod: " + _mod_folders[i])
                array_push(self.mod_keys, _register_mod_result.data)
            }
        }
        return new Result().success()
    }

    /// @returns {Struct.Result} 
    static load_all_mods = function() {
        for (var i = 0; i < array_length(self.mod_keys); ++i) {
            var _result = _load_mod_lua_scripts(self.mod_keys[i])
            if (_result.is_failed()) {
                return _result
            }
        }
        return new Result().success()
    }

    /// @returns {Struct.Result} 
    static run_all_mods = function() {
        for (var i = 0; i < array_length(self.mod_keys); ++i) {
            var _result = _run_mod_entry_function(self.mod_keys[i])
            if (_result.is_failed()) {
                return _result
            }
        }
        return new Result().success()
    }

    /// @returns {Struct.Result} 
    static load_all_sprites = function() {
        var _bake_result = global.stove.sprite_manager.bake_all_sprites()
        if (_bake_result.is_failed()) {
            return _bake_result
        }
        global.stove.food_manager.load_all_sprites()
        return new Result().success()
    }
}