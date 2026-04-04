/// 
function lua_manager_test () {
    var lua_manager = new Stove_LuaManager()
    lua_manager.init()

    lua_manager.load_lua("mods/mod.lua")
    lua_manager.load_lua("mods/test.lua")

    show_debug_message("Mod Engine Init Finished")

    var result =  lua_manager.run_lua_function("mods/mod.lua", "ModMain")
    if (!result.is_succeed) {
        show_debug_message("ModMain failed: " + result.get_error_stack())
    }
    test_assert_equal(result.is_succeed(), true, "modMain should succeed");

    var result =  lua_manager.run_lua_function("mods/mod.lua", "TestCustomGmlFunc")
    if (!result.is_succeed) {
        show_debug_message("TestCustomGmlFunc failed: " + result.get_error_stack())
    }
    test_assert_equal(result.is_succeed(), true, "TestCustomGmlFunc should succeed");
}