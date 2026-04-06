/// 
function Stove_Logger() constructor {
    /// @type {String} 
    self.log_file_path = undefined
    /// @param {String} _log_file_path 
    /// @returns {Struct.Result} 
    static init = function(_log_file_path = "stove\\log") {
        self.log_file_path = _log_file_path
        return global.stove.file_utils.create_file_if_not_exist(_log_file_path)
    }

    static log_e = function(_message) {
        var _msg = "[ERROR]" + _message + "\n"
        show_debug_message(_msg)
        global.stove.file_utils.append_data_to_file(self.log_file_path, _msg)
    }

    static log_w = function(_message) {
        var _msg = "[WARN]" + _message + "\n"
        show_debug_message(_msg)
        global.stove.file_utils.append_data_to_file(self.log_file_path, _msg)
    }

    static log_i = function(_message) {
        var _msg = "[INFO]" + _message + "\n"
        show_debug_message(_msg)
        global.stove.file_utils.append_data_to_file(self.log_file_path, _msg)
    }

    static log_d = function(_message) {
        var _msg = "[DEBUG]" + _message + "\n"
        show_debug_message(_msg)
        global.stove.file_utils.append_data_to_file(self.log_file_path, _msg)
    }
    
}