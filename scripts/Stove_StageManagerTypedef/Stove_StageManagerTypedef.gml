/// 
function Stove_Asset() constructor {
    self.source = ASSET_SOURCE.IN_GAME
    self.path = ""
    self.gml_asset_name = undefined
}

function Stove_StageMetadata() constructor {
    /// @description Data directly from lua
    self.name = ""
    self.description = ""

    /// @type {Struct.Stove_Asset} 
    self.pre_music = undefined
    /// @type {Struct.Stove_Asset} 
    self.elite_music = undefined
    /// @type {Struct.Stove_Asset} 
    self.boss_music = undefined

    /// @type {Struct.Stove_Asset} 
    self.background = undefined
    self.author = ""

    /// @type {String}
    self.json_path = ""

    /// @description Data parsed from json（与 Lua 一致，一律 string）
    self.id = ""
    
}