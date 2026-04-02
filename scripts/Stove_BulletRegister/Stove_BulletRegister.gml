/// 

enum KINEMATIC_TYPE {
    UNKNOWN,
    STRAIT,
    ORBIT,
    PARABOLA,
    STEERING,
    COMPOSITE,
}

/// @param {Enum.KINEMATIC_TYPE} _type 
function Kinematic(_type) constructor {
    self.type = _type
    
    /// @param {Real} _delta_t frame
    /// @param {Struct.Vector2} _out 
    static get_position = function(_delta_t, _out) {
    }
}

/// @param {Real} _velocity_x 
/// @param {Real} _velocity_y 
function StraitKinematic(_velocity_x, _velocity_y): Kinematic(KINEMATIC_TYPE.STRAIT) constructor {
    self.velocity_x = _velocity_x
    self.velocity_y = _velocity_y

    /// @param {Real} _delta_t frame
    /// @param {Struct.Vector2} _out 
    /// @returns {Struct.Vector2} 
    static get_position = function(_delta_t, _out) {
        _out.x = _delta_t * self.velocity_x
        _out.y = _delta_t * self.velocity_y
    }
}

// TODO instrumental variable rad_per_frame
/// @param {Real} _radius 半径
/// @param {Real} _angular_velocity 角速度（弧度/帧）
function OrbitKinematic(_radius, _angular_velocity) : Kinematic(KINEMATIC_TYPE.ORBIT) constructor {
    self.radius = _radius;
    self.angular_velocity = _angular_velocity;
    
    static get_position = function(_delta_t, _out) {
        var _theta = self.angular_velocity * _delta_t;
        _out.x = self.radius * cos(_theta);
        _out.y = self.radius * sin(_theta);
    }
}

// /// @param {Real} _velocity_x 
// /// @param {Real} _velocity_y 
// /// @param {Real} _gravity
// /// @param {Real} _origin_x 
// /// @param {Real} _origin_y 
// /// @param {Real} _t
// function ParabolaKinematic(_velocity, _gravity, _origin_x, _origin_y, _t): Kinematic(KINEMATIC_TYPE.PARABOLA, _origin_x, _origin_y, _t) constructor {
//     self.gravity = _gravity
//     self.velocity = _velocity
// }

// /// @param {Real} _velocity_x 
// /// @param {Real} _velocity_y 
// /// @param {Real} _acceleration 
// /// @param {Struct.Position} _target 
// /// @param {Real} _origin_x 
// /// @param {Real} _origin_y 
// /// @param {Real} _t
// function SteeringKinematic(_velocity, _acceleration, _target, _origin_x, _origin_y, _t): Kinematic(KINEMATIC_TYPE.STEERING, _origin_x, _origin_y, _t) constructor {
//     self.velocity = _velocity
//     self.acceleration = _acceleration
//     self.target = _target
// }