/// 

#macro Stove global.stove_system
#macro kInvalidGridId -1

function Vector2() constructor {
    self.x = 0
    self.y = 0
}

/// @param {Real} _offset_x 
/// @param {Real} _offset_y 
/// @param {Real} _damage 
/// @param {Real} _move_speed 
/// @param {Real} _row 
/// @param {Real} _depth_offset
function BulletConfig(_offset_x, _offset_y, _damage, _move_speed, 
        _row, _depth_offset = -500) constructor {
    self.offset_x = _offset_x
    self.offset_y = _offset_y
    self.depth_offset = _depth_offset
    self.damage = _damage
    self.move_speed = _move_speed
    self.row = _row
}

function BulletInstance() constructor {
    self.damage = 0
    self.move_speed = 0
    self.row = 0
}



/// @param {Struct.BulletConfig} _bullet_config 
function CardConfig(_bullet_config) constructor {
    self.bullet_config = _bullet_config
}

function Result() constructor {
    self.code = 0
    self.message = ""
    /// @type {Any|Undefined} 
    self.data = undefined
    /// @type {Array<Enum.STOVE_ERROR>} 
    self.code_stack = []
    /// @type {Array<String>} 
    self.message_stack = []

    /// @returns {Bool} 
    static is_success = function() {
        return self.code == 0
    }

    /// @returns {Bool} 
    static is_failed = function() {
        return self.code != 0
    }

    /// @template {T}  
    /// @param {T|Undefined} _data 
    /// @returns {Struct.Result} 
    static ok = function(_data = undefined) {
        var _result = new Result()
        _result.code = 0
        _result.data = _data
        return _result
    }

    /// @param {Enum.STOVE_ERROR} _code 
    /// @param {String} _message 
    /// @returns {Struct.Result} 
    static fail = function(_code, _message) {
        var _result = new Result()
        _result.code = _code
        _result.message = _message
        return _result
    }

    /// @param {Enum.STOVE_ERROR} _code 
    /// @param {String} _message 
    /// @returns {Struct.Result} 
    static wrap = function(_code, _message) {
        array_push(self.code_stack, _code)
        array_push(self.message_stack, _message)
        return self
    }

    /// @returns {String} 
    static get_error_stack = function() {
        var _stack = ""
        for (var i = array_length(self.code_stack) - 1; i >= 0; i--) {
            _stack += "Code: " + string(self.code_stack[i]) + ", Message: " + self.message_stack[i] + "\n"
        }
        _stack += "Final Code: " + string(self.code) + ", Final Message: " + self.message + "\n"
        return _stack
    }
}