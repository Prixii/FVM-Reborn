/// 

/// @param {Struct.Kinematic} _kinematic 
/// @param {Real} _damage 
/// @param {String} _damage_type 
/// @param {String} _target_type 
/// @param {Asset.GMSprite} _sprite 
init = function (_kinematic, _damage, _damage_type, _target_type, _sprite) {
    self.kinematic = _kinematic
    self.damage = _damage
    self.damage_type = _damage_type
    self.target_type = _target_type
    sprite_index = _sprite
    self.init_t = global.total_time
    self.burnt = 0
    update_grid_id()
}

update_grid_id = function() {
    self.grid = get_grid_position_from_world(x,y)
    self.grid.row++
    self.grid_id = stove_utils.get_grid_id(grid.col, grid.row)
    self.grid_mask = int64(1) << self.grid_id
    self.position_offset = {x: 0, y: 0}
}

on_create = function() {
    self.origin_x = x
    self.origin_y = y
    self.spatial_registry = global.stove.spatial_registry
    self.stove_utils = global.stove_utils
}

on_step = function() {
    if (global.is_paused) {
        exit
    }
    if (x < -128 || x > room_width + 128 || y < -128 || y > room_height + 128) {
        instance_destroy();
        exit;
    }

    self.kinematic.get_position(global.total_time - self.init_t, self.position_offset)
    self.x = self.origin_x + self.position_offset.x
    self.y = self.origin_y + self.position_offset.y
    update_grid_id()
    
    var _in_enemy_grid = spatial_registry.collided(self.grid_mask, ENEMY_LAYER.ALL)
    if (!_in_enemy_grid) {
        exit
    }

    var _enemies_in_grid = spatial_registry.get_enemies_in_grid(self.grid_id)
    /// @type {Id.Instance.obj_enemy_parent} 
    var _nearest_enemy = stove_utils.find_nearest(_enemies_in_grid, x, y)
    if (_nearest_enemy == noone) {
        exit
    }
    if (instance_exists(_nearest_enemy) && position_meeting(x, y, _nearest_enemy)) {
        if (_nearest_enemy.hp > 0 && can_hit(self.target_type, _nearest_enemy.target_type)) {
            audio_play_sound(_nearest_enemy.hit_sound,0,0)
            _nearest_enemy.damage_amount = self.damage
            _nearest_enemy.damage_type = self.damage_type

            with(_nearest_enemy) {
                event_user(0)
            }

            instance_destroy();
        }
    }
}

on_draw = function() {
    draw_self()
    draw_set_color(c_red);
    draw_circle(x, y, 4, false);
    draw_set_color(c_white);
}

on_destroy = function() {
}

// --------- execute -----------
on_create()
