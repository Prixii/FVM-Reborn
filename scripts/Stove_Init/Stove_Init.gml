/// 
global.stove = {
    mod_manager: new Stove_ModManager(),
    engine: new Stove_Engine(),
    spatial_registry: new SpatialRegistry(),
    sprite_manager: new ModSpriteManager(),
    factory: new StoveFactory(),
    event_bus: new StoveEventBus(),
    lua_manager: new Stove_LuaManager(),
    food_manager: new Stove_FoodManager(),
    file_utils: new Stove_FileUtils(),
    logger: new Stove_Logger(),
    utils: new Stove_Utils(),
    food_manager_utils: new Stove_FoodManagerUtils(),
    stage_manager: new Stove_StageManager()
}
