/// 

function Stove_ModManifest() constructor {
    self.name = ""
    self.id = ""
    self.version = ""
    self.description = ""
    self.author = ""
    self.main_script = ""
    self.entry_function = ""
    self.dispose_function = ""
}

/// @param {Struct.Stove_ModManifest} _manifest 
/// @param {String} _folder_path
function Stove_ModMetadata(_manifest, _folder_path) constructor {
    self.manifest = _manifest
    self.folder_path = _folder_path

    /// @param {String} _script 
    /// @returns {String} 
    static get_script_path = function(_script) {
        return self.folder_path + "/" + _script
    }
}