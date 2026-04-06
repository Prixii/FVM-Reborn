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
function Stove_ModMetadata(_manifest) constructor {
    self.manifest = _manifest
    
}