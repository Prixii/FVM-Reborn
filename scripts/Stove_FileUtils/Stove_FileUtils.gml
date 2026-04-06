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

    /// @description return full path of files with specific extension in the folder
    /// @param {String} _path 
    /// @param {String} _extension 
    /// @returns {Array<String>} full path of files
    static find_files_with_extension_recursively = function(_path, _extension) {
        var _files = [];
        
        if (string_char_at(_path, string_length(_path)) != "/") {
            _path += "/";
        }

        if (!directory_exists(_path)) return _files;

        var _temp_list = [];
        var _item = file_find_first(_path + "*.*", fa_directory | fa_archive | fa_readonly);
        
        while (_item != "") {
            if (_item != "." && _item != "..") {
                array_push(_temp_list, _item);
            }
            _item = file_find_next();
        }
        file_find_close(); 

        var _count = array_length(_temp_list);
        for (var i = 0; i < _count; i++) {
            var _name = _temp_list[i];
            var _full_path = _path + _name;

            if (directory_exists(_full_path)) {
                var _sub_results = self.find_files_with_extension_recursively(_full_path, _extension);
                _files = array_concat(_files, _sub_results);
            } else {
                if (string_ends_with(_name, _extension)) {
                    array_push(_files, _full_path);
                }
            }
        }

        return _files;
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