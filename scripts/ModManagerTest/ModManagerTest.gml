///
function mod_manager_test() {
    var _mod_manager = new Stove_ModManager()
    var _file_utils = new Stove_FileUtils()
    var _logger = new Stove_Logger()
    _mod_manager.init()
    var _register_result = _mod_manager.register_all_mods("mods/")
    if (_register_result.is_failed()) {
        _logger.log_e(_register_result.get_error_stack())
    }
    test_assert_equal(_register_result.is_succeed(), true, "注册所有模组成功")
    var _load_result = _mod_manager.load_all_mods()
    if (_load_result.is_failed()) {
        _logger.log_e(_load_result.get_error_stack())
    }
    test_assert_equal(_load_result.is_succeed(), true, "加载所有模组成功")
    var _run_result = _mod_manager.run_all_mods()
    if (_run_result.is_failed()) {
        _logger.log_e(_run_result.get_error_stack())
    }
    test_assert_equal(_run_result.is_succeed(), true, "运行所有模组成功")

}