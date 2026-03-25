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


