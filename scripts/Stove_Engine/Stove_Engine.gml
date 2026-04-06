/// 

function Stove_Engine() constructor {
    self.is_ready = false
    /// @type {Struct.ASTChunk} 
    self.mod_cards = []

    static init = function() {
        show_debug_message("engine init")
        
        var skill_info = new SkillInfo("cost", array_create(kMaxLevel, 0))
        var sprite_sheet = new SpriteSheetInfo("mods/assets/amiya_idle.png", 11, 40, 85)
        var amiya_shape = new ShapedCardData("阿米娅", 0, "罗德岛 CEO", 500, 0, 500, 300, 10, 78, PLANT_TYPE.NORMAL, FEATURE_TYPE.NORMAL, "none", sprite_sheet)
        var amiya = new FoodMetaData("amiya", [amiya_shape], "这是罗德岛尊贵的 CEO", skill_info)

        array_push(self.mod_cards, amiya)
    }

    static init_card = function() {
        array_foreach(self.mod_cards, function (_card, _) {register_mod_food(_card)})
    }
}

