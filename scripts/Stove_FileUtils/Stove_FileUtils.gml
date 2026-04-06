/// 
function Stove_FileUtils() constructor {
    /// @param {String} _path 
    /// @returns {Array<String>} 
    static find_subfolders = function(_path) {
        var _subfolders = []
        if (!directory_exists(_path)) {
            return _subfolders
        }
        show_debug_message("Find subfolders at: " + _path);
        var _folder_name = file_find_first(_path + "*", fa_directory)
        while (_folder_name != "") {
            if (directory_exists(_path + _folder_name)) {
                if (_folder_name == "." || _folder_name == "..") {
                    continue
                }
                array_push(_subfolders, _path + _folder_name)
            }
            _folder_name = file_find_next()
        }
        file_find_close()
        return _subfolders
    }

    /// @param {String} _path 
    /// @param {String} _data 
    static append_data_to_file = function(_path, _data) {
        try {
            var _file = file_text_open_append(_path);
            if (_file == -1) {
                return new Result().fail(STOVE_ERROR.CREATE_FILE_FAILED, "Failed to create file: " + _path);
            }
            file_text_write_string(_file, _data + "\n");
            file_text_close(_file);
        } catch (e) {
            return new Result().fail(STOVE_ERROR.CREATE_FILE_FAILED, "Failed to create file: " + _path + "\n" + string(e));
        }
        return new Result().success();
    }

    /// @returns {Struct.Result} 
    static create_file_if_not_exist = function(_path) {
        try {
            if (file_exists(_path)) {
                return new Result().success()
            }
            var _dir = filename_dir(_path);
            if (_dir != "" && !directory_exists(_dir)) {
                directory_create(_dir);
            }

            var _file = file_text_open_write(_path);
            
            if (_file == -1) {
                return new Result().fail(STOVE_ERROR.CREATE_FILE_FAILED, "Failed to create file: " + _path);
            }
            file_text_close(_file);
            if (!file_exists(_path)) {
                return new Result().fail(STOVE_ERROR.CREATE_FILE_FAILED, "Failed to create file: " + _path);
            }
        } catch (e) {
            return new Result().fail(STOVE_ERROR.CREATE_FILE_FAILED, "Failed to create file: " + _path + "\n" + string(e));
        }
        return new Result().success();
    }
}