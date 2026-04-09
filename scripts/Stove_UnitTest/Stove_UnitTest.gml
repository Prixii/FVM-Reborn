function test_assert_equal(_actual, _expected, _msg, _throw = true) {
    if (_actual != _expected) {
        var _err = "[⛔]" + _msg + " | expect: " + string(_expected) + " got: " + string(_actual);
        show_debug_message(_err);
        if (_throw) throw(_err); 
        return false;
    }
    show_debug_message("[✅]" + _msg);
    return true;
}

function run_stove_test() {
    show_debug_message("------------Stove Unit Test Start------------")
    lua_manager_test()
    gmlua_test()
    file_utils_test()
    mod_manager_test()
    show_debug_message("-------------Stove Unit Test End-------------")
}
