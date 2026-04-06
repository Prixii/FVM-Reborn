/// 
function file_utils_test () {
    var file_util = new Stove_FileUtils()
    var result = file_util.create_file_if_not_exist(working_directory + "test.txt")
    test_assert_equal(result.is_succeed(), true, "create_file_if_not_exist should succeed");
    result = file_util.append_data_to_file( working_directory + "test.txt", "test")
    test_assert_equal(result.is_succeed(), true, "append_data_to_file should succeed");
    var _sub_folders = file_util.find_subfolders("mods\\")
    test_assert_equal(array_length(_sub_folders) > 0, true, "find_subfolders should return a list")
    for (var i = 0; i < array_length(_sub_folders); i++) {
        show_debug_message(_sub_folders[i])
    }

    var logger = new Stove_Logger()
    logger.init(working_directory + "stove_logger.txt")
    logger.log_e("error")
    logger.log_w("warn")
    logger.log_i("info")
    logger.log_d("debug")
}