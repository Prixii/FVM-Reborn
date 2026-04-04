/// 

function LuaFunc () constructor {
    self.onEvent = undefined;
    self.helloLua = undefined;
} 

global.stove_system = {
    spatial_registry: undefined,
    sprite_manager: undefined,
    factory: undefined,
    event_bus: undefined,
    lua_manager: undefined,
}

global.mod_engine = {
    is_ready: false,
    luaFunc: new LuaFunc(),
    /// @type {Struct.ASTChunk} 
    _ast: undefined,
    _sdk_ast: undefined,
    mod_cards: [],

    init: function() {

        global.stove_system.spatial_registry = new SpatialRegistry()
        global.stove_system.sprite_manager = new ModSpriteManager()
        global.stove_system.factory = new StoveFactory()
        global.stove_system.event_bus = new StoveEventBus()
        global.stove_system.lua_manager = new Stove_LuaManager()

        show_debug_message("engine init")
        
        var skill_info = new SkillInfo("cost", array_create(kMaxLevel, 0))
        var sprite_sheet = new SpriteSheetInfo("mods/assets/amiya_idle.png", 11, 40, 85)
        var amiya_shape = new ShapedCardData("阿米娅", 0, "罗德岛 CEO", 500, 0, 500, 300, 10, 78, PLANT_TYPE.NORMAL, FEATURE_TYPE.NORMAL, "none", sprite_sheet)
        var amiya = new CardMetaData("amiya", [amiya_shape], "这是罗德岛尊贵的 CEO", skill_info)

        array_push(self.mod_cards, amiya)
    },

    init_card: function() {
        array_foreach(self.mod_cards, function (_card, _) {register_mod_card(_card)})
    }
}
