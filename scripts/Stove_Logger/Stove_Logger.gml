/// 
function Stove_Logger() constructor {
    #macro CL_RESET  "\x1b[0m"
    #macro CL_RED    "\x1b[31m"
    #macro CL_YELLOW "\x1b[33m"
    #macro CL_CYAN   "\x1b[36m"
    #macro CL_GREEN  "\x1b[32m"

    /// @type {String} 
    self.log_file_path = undefined
    /// @param {String} _log_file_path 
    /// @returns {Struct.Result} 
    static init = function(_log_file_path = "stove/log") {
        self.log_file_path = _log_file_path
        return global.stove.file_utils.create_file_if_not_exist(_log_file_path)
    }

    static _log_base = function(_tag, _color, _message, _write) {
    show_debug_message(_color + _tag + CL_RESET + " " + _message);
    
    if (_write) {
        var _plain_text = _tag + " " + _message;
        global.stove.file_utils.append_data_to_file(self.log_file_path, _plain_text);
    }
}

    static log_e = function(_message, write = true) {
        _log_base("[ERROR]", CL_RED, _message, write);
    }

    static log_w = function(_message, write = true) {
        _log_base("[WARN] ", CL_YELLOW, _message, write);
    }

    static log_i = function(_message, write = true) {
        _log_base("[INFO] ", CL_CYAN, _message, write);
    }

    static log_d = function(_message, write = true) {
        _log_base("[DEBUG]", CL_GREEN, _message, write);
    }
    
}