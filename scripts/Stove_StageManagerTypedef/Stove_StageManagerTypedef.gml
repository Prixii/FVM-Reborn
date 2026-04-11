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

function Stove_StageData() constructor {
    self.id = undefined
    self.name = undefined
    self.button_spr = undefined
    self.button_index = undefined
    self.button_x = undefined
    self.button_y = undefined
    self.level_file = undefined
    self.hard_level_file = undefined
    self.level_sprite = undefined
    self.pre_music = undefined
    self.elite_music = undefined
    self.boss_music = undefined
    self.player_level_require = undefined
    self.pre_level_require =undefined
}