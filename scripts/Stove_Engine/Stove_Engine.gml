/// 

function LuaFunc () constructor {
    self.onEvent = undefined;
    self.helloLua = undefined;
} 

global.stove_system = {
    spatial_registry: new SpatialRegistry(),
    sprite_manager: new ModSpriteManager(),
    factory: new StoveFactory(),
    event_bus: new StoveEventBus(),
}

global.mod_engine = {
    _mod_engine_scope: new Scope(),
    is_ready: false,
    luaFunc: new LuaFunc(),
    /// @type {Struct.ASTChunk} 
    _ast: undefined,
    _sdk_ast: undefined,
    mod_cards: [],

    init: function() {
        show_debug_message("engine init")
        setGMLVariable(self._mod_engine_scope, "mode_engine", self)
        
        // load mod
        var _mod_ast = createLuaFromFile("mods/mod.lua", false)
        runLua(_mod_ast, _mod_engine_scope)
        var _test_ast = createLuaFromFile("mods/test.lua", false)
        runLua(_test_ast, _mod_engine_scope)

        show_debug_message("Mod Engine Init Finished")

        var modMain = getLuaVariable(_mod_engine_scope, "ModMain")
        modMain()

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

global.mod_engine.init();