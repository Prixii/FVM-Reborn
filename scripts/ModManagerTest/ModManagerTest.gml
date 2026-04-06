///
function mod_manager_test() {
    var _mod_manager = new Stove_ModManager()
    var _file_utils = new Stove_FileUtils()
    var _logger = new Stove_Logger()
    var _mod_folders = _file_utils.find_subfolders("mods\\")
    for (var i = 0; i < array_length(_mod_folders); i++) {
        var register_result = _mod_manager._register_mod(_mod_folders[i])
        if (register_result.is_failed()) {
            _logger.log_e("failed to register mod " + _mod_folders[i] + "\nError Stack: " + register_result.get_error_stack(), false)
        }
    }
    
}