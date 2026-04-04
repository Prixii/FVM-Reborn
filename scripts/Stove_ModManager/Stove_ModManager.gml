/// 
global.stove_system.mod_manager = {
    utils: new Stove_ModManagerUtils(),
}

function Stove_ModManager() constructor {
    self.mod_manifests = {}

    static register_mod = function(_mod_path) {

    }

    /// @param {Struct.Stove_ModManifest} _mod_manifest 
    static add_mod_manifest = function(_mod_manifest) {
        self.mod_manifests[_mod_manifest.id] = _mod_manifest
    }

    /// @param {String} _mod_id 
    /// @returns {Struct.Stove_ModManifest|Undefined} 
    static get_mod_manifest = function(_mod_id) {
        return self.mod_manifests[_mod_id]
    }
}