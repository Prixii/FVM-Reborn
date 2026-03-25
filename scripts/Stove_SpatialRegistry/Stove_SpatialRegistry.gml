/// 

/// @param {Real} _grid_x 
/// @param {Real} _grid_y 
/// @param {Id.Instance} _object 
/// @param {Enum.ENEMY_LAYER} _layer 
function BitmapChange(_grid_x, _grid_y, _object, _layer) constructor {
    self.grid_id = global.stove_utils.get_grid_id(_grid_x, _grid_y)
    self.object = _object
    self.layer = _layer
}

// TODO 实际索敌范围应该比地图大，需要多个 int 存储
function SpatialRegistry() constructor {
    /// 位图，每一格中是否存在敌人，加速检测
    self.enemy_bitmap = int64(0)
    /// 位图，全局中不同种类的敌人的存在性
    self.enemy_layer_bitmap = int64(0)
    /// 数量，维护位图辅助
    self.ground_enemy_count = 0
    self.air_enemy_count = 0
    self.underground_enemy_count = 0
    self.enemy_count_in_grid = array_create(kMaxMapSize, 0)
    /// @type {Array<Array<Id.Instance>>} 敌人查询
    self.enemies_in_grid = array_create(kMaxMapSize);
    for (var i = 0; i < kMaxMapSize; i++) {
        self.enemies_in_grid[i] = [];
    }

    reset = function() {
        self.enemy_bitmap = int64(0)
        self.enemy_layer_bitmap = int64(0)
        self.ground_enemy_count = 0
        self.air_enemy_count = 0
        self.underground_enemy_count = 0
       
        for (var i = 0; i < kMaxMapSize; i++) {
            self.enemies_in_grid[i] = [];
            self.enemy_count_in_grid[i] = 0;
        }
    }

    /// @param {Real} _attack_area_mask
    /// @param {Real} _target_layer_mask 
    /// @returns {Real} enemy_spatial_index, 0: no enemy
    should_attack = function(_attack_area_mask, _target_layer_mask) {
        var enemy_spatial_index = enemy_bitmap & _attack_area_mask;
        if ( enemy_spatial_index == 0) {
            return 0;
        } 
        
        if ((_target_layer_mask & enemy_layer_bitmap) != 0) {
            return enemy_spatial_index
        }

        return 0
    }

    /// @param {Real} _current_grid_id
    /// @param {Real} _target_layer_mask 
    /// @returns {Bool} enemy_spatial_index, 0: no enemy
    collided = function(_current_grid_id, _target_layer_mask) {
        return should_attack(_current_grid_id, _target_layer_mask) != 0 
    }

    /// @param {Real} _current_grid_id
    /// @returns {Array<Id.Instance>} 
    get_enemies_in_grid = function(_current_grid_id) {
        return enemies_in_grid[_current_grid_id]
    }

    /// @param {Struct.BitmapChange} _change 
    enter = function(_change) {
        var _idx = _change.grid_id;
        var _layer = _change.layer;
        var _inst = _change.object;

        if (_idx == kInvalidGridId) return

        if (self.enemy_count_in_grid[_idx]++ == 0) {
            self.enemy_bitmap |= (int64(1) << _idx);
        }

        if (_layer == ENEMY_LAYER.GROUND) {
            if (self.ground_enemy_count++ == 0) self.enemy_layer_bitmap |= ENEMY_LAYER.GROUND;
        } else if (_layer == ENEMY_LAYER.AIR) {
            if (self.air_enemy_count++ == 0) self.enemy_layer_bitmap |= ENEMY_LAYER.AIR;
        } else if (_layer == ENEMY_LAYER.UNDERGROUND) {
            if (self.underground_enemy_count++ == 0) self.enemy_layer_bitmap |= ENEMY_LAYER.UNDERGROUND;
        }

        array_push(self.enemies_in_grid[_idx], _inst);
        global.stove_utils.debug_print_spatial_bitmap(enemy_bitmap)
    }

    /// @param {Struct.BitmapChange} _change
    leave = function(_change) {
        var _idx = _change.grid_id;
        var _layer = _change.layer;
        var _inst = _change.object;

        if (_idx == kInvalidGridId) return

        // 1. remove from enemies_in_grid
        var _arr = self.enemies_in_grid[_idx];
        var _p = array_get_index(_arr, _inst);
        if (_p != -1) array_delete(_arr, _p, 1);

        // 2. update enemy_count bitmap
        if (--self.enemy_count_in_grid[_idx] <= 0) {
            self.enemy_bitmap &= ~(int64(1) << _idx);
            self.enemy_count_in_grid[_idx] = 0;
        }

        // 3. update bitmap
        if (_layer == ENEMY_LAYER.GROUND) {
            if (--self.ground_enemy_count <= 0) {
                self.enemy_layer_bitmap &= ~ENEMY_LAYER.GROUND;
                self.ground_enemy_count = 0;
            }
        } else if (_layer == ENEMY_LAYER.AIR) {
            if (--self.air_enemy_count <= 0) {
                self.enemy_layer_bitmap &= ~ENEMY_LAYER.AIR;
                self.air_enemy_count = 0;
            }
        } else if (_layer == ENEMY_LAYER.UNDERGROUND) {
            if (--self.underground_enemy_count <= 0) {
                self.enemy_layer_bitmap &= ~ENEMY_LAYER.UNDERGROUND;
                self.underground_enemy_count = 0;
            }
        }
    }
}
