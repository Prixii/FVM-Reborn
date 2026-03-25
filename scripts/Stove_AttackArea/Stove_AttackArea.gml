/// 

///  (0,0) ---- x 
///    |
///    |
///    |
///    y

/// @param {Enum.ATTACK_AREA_TYPE} _type 
/// @param {Array<Enum.ENEMY_LAYER>} _enemy_layers 
function AttackArea(_type, _enemy_layers) constructor {
    self.type = _type
    self.enemy_layers = _enemy_layers  

    /// @param {Real} _grid_x 
    /// @param {Real} _grid_y 
    /// @returns {Real} 
    static calculate_attack_area_mask = function(_grid_x, _grid_y) {
        return int64(0);
    }
}

/// @param {Enum.LINE_DIRECTION} _direction
/// @param {Real} _distance 
/// @param {Bool} _reverse 
/// @param {Array<Enum.ENEMY_LAYER>} _enemy_layers 
function LineAttackArea(_direction, _distance, _reverse, _enemy_layers): AttackArea(ATTACK_AREA_TYPE.LINE, _enemy_layers) constructor {
    self.direction = _direction
    self.distance = _distance
    self.reverse = _reverse

    /// @param {Real} _grid_x 
    /// @param {Real} _grid_y 
    /// @returns {Real} 
    static calculate_attack_area_mask = function(_grid_x, _grid_y) {
        var _mask = int64(0);
        var _current_grid_id = global.stove_utils.get_grid_id(_grid_x, _grid_y)
        _mask |=  (int64(1) << _current_grid_id)  // 作为放置处的 xy 不可能溢出

        var _delta_x = 0;
        var _delta_y = 0;

        if (direction == LINE_DIRECTION.HORIZONTAL) {
            _delta_x = reverse ? -1 : 1
        } else if (direction == LINE_DIRECTION.VERTICAL) {
            _delta_y = reverse ? 1 : -1
        } else if (direction == LINE_DIRECTION.LB_RT) {
            _delta_x = reverse ? -1 : 1
            _delta_y = reverse ? 1 : -1
        } else if (direction == LINE_DIRECTION.LT_RB) {
            _delta_x = reverse ? -1 : 1
            _delta_y = reverse ? -1 : 1
        }
        var _current_x = _grid_x;
        var _current_y = _grid_y;
        for (var i = 0; i < distance; i++) {
            _current_x += _delta_x
            _current_y += _delta_y
            if (!global.stove_utils.is_valid_grid(_current_x, _current_y)) {
                break
            }
            _current_grid_id = global.stove_utils.get_grid_id(_current_x, _current_y)
            _mask |= (int64(1) << _current_grid_id);
        }

        return _mask;
    }
}

/// @param {Struct.Position} _left_top 
/// @param {Struct.Position} _right_bottom 
/// @param {Array<Enum.ENEMY_LAYER>} _enemy_layers 
function RectangleAttackArea(_left_top, _right_bottom, _enemy_layers): AttackArea(ATTACK_AREA_TYPE.RECTANGLE, _enemy_layers) constructor {
    self.left_top = _left_top  
    self.right_bottom = _right_bottom  
}

///// @param {Array<Enum.ENEMY_LAYER>} _enemy_layers 
// function ManhattanAttackArea(_distance, _enemy_layers, _enemy_layers) constructor {
// }

///// @param {Array<Enum.ENEMY_LAYER>} _enemy_layers 
// function FreeLineAttackArea(_direction, _distance, _enemy_layers, _enemy_layers) constructor {
// }

///// @param {Array<Enum.ENEMY_LAYER>} _enemy_layers 
// function CompositeAttackArea(_grids, _enemy_layers, _enemy_layers) constructor {
// }

///// @param {Array<Enum.ENEMY_LAYER>} _enemy_layers 
// function CircularAttackArea(_radius, _enemy_layers, _enemy_layers) constructor {
// }