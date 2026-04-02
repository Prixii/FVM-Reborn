/// @description obj_card_parent 的防腐层
self.name = "undefined"
self.description = "undefined"
self.obj_type = object_index
self.plant_id = "undefined"
self.current_level = 1
self.plant_type = "normal"
self.target_card = "none"
self.target_type = "normal"
self.shape = 0
self.skill = 0

self.cost = 0
self.cooldown = 0
self.max_hp = 0
self.hp = self.max_hp

self.atk = 0
self.attack_type = ATTACK_TYPE.PRODUCER
self.attack_timer = 0
self.cycle = 0

self.state = CARD_STATE.IDLE
self.invincible = false
self.can_shovel_remove = true

self.ice_timer = 0
self.is_slowdown = false
self.frozen_timer = 0
self.is_frozen = false

self.awake_buff_timer = 0
self.grid_col = -1
self.grid_row = -1
self.depth_value = 0
self.depth_group = 0  // 0=前景, 1=中景, 2=背景

self.timer = 0
self.image_speed = 0
self.attack_anim_len = 0 // 原 attack_anim
self.idle_anim_len = 0  // 原 idle_anim
self.awake_anim_len = 0 // 原 awake_anim
self.flash_value = 0
self.tick_per_frame = 0 // 每一帧的持续时间，原 flash_speed


self.banding_star_obj = noone
self.banding_water_obj = noone
self.banding_sleep_obj = noone

// TODO: type
self.upgrade_data = {}

/// @description Stove Custom Attributes and Methods
/// 

self.spatial_registry = global.stove_system.spatial_registry
self.sprite_manager = global.stove_system.sprite_manager

self.attack_area_mask = 0
self.attack_enemy_layer_mask = 0

/// @type {Array<Struct.DamageMediaMetadata>} 
self.damage_media_metadatas = []

self.act_functions = {}
act_functions[CARD_STATE.IDLE ]=  function() {
    act_idle()
}
act_functions[CARD_STATE.ATTACK] = function() {
    act_attack()
}


init = function(
    _idle_sprite_info, _attack_sprite_info, _awake_sprite_info,
    _attack_area, _attack_enemy_layers, _damage_media_metadatas
    ) {
    // sprite
    idle_sprite = sprite_manager.request_sprite(_idle_sprite_info.key)
    attack_sprite = sprite_manager.request_sprite(_attack_sprite_info.key)
    awake_sprite = sprite_manager.request_sprite(_awake_sprite_info.key)

    sprite_index = idle_sprite

    // attack
    var _grid_pos = get_grid_position_from_world(x, y);
    attack_area_mask = _attack_area.calculate_attack_area_mask(_grid_pos.col, _grid_pos.row)
    attack_enemy_layer_mask = global.stove_utils.enemy_layers_to_mask(_attack_enemy_layers)
    damage_media_metadatas = _damage_media_metadatas

    upgrade_data = get_plant_data_with_skill(plant_id, shape, current_level, skill);

} 

/// @returns {Bool} 
should_exit = function() {
    return global.is_paused || is_frozen
}

// ----------- CREATE -------------
on_create = function() {
    self.origin_x = x
    self.origin_y = y
    self.spatial_registry = global.stove_system.spatial_registry
    self.stove_utils = global.stove_utils
}

// ----------- STEP -------------
on_step = function() {
    if (should_exit()) exit
    if (new_tick()){
        if (can_switch_state()) switch_state()
        if (can_act()) act()
    }
}

/// @returns {Bool} 
can_switch_state = function() {
    return true
}

/// @returns {Enum.CARD_STATE} old state 
switch_state = function() {
    var _old_state = state
	var _attack_target_mask = spatial_registry.should_attack(attack_area_mask, attack_enemy_layer_mask)

    if (_attack_target_mask != 0) {
        if (state != CARD_STATE.ATTACK) {
            sprite_index = attack_sprite
			image_index = 0
            state = CARD_STATE.ATTACK
        }
    } else {
        if (state != CARD_STATE.IDLE) {
            sprite_index = idle_sprite
			image_index = 0
            state = CARD_STATE.IDLE
        }
    }

    return _old_state
}

/// @returns {Bool} 
can_act = function() {
    return true
}

new_tick = function() {
    var _actual_tick_per_frame = tick_per_frame * (is_slowdown ? 2 : 1)
    if (timer < _actual_tick_per_frame - 1) {
        timer++;
        return false;
    }

    timer = 0;
    image_index++;

    cycle = upgrade_data[? "cycle"] * (is_slowdown ? 2 : 1)
    return true
}

act = function() {
    var _func = act_functions[state]
    if (_func != undefined) _func()
}

act_attack = function() {
    if (image_index mod attack_anim_len == 0) {
        shoot()
    }
}

shoot = function() {
    for (var i = 0; i < array_length(damage_media_metadatas); i++) {
        var _damage_media_metadata = damage_media_metadatas[i]
        var instance = global.stove_system.factory
                        .create_damage_media(_damage_media_metadata)
    }
}

// ----------- DRAW -------------
on_draw = function() {
    draw_self()
}

// ----------- DESTROY -------------
on_destroy = function() {
    if (hp < max_hp && !invincible){
        obj_task_manager.card_loss++
    }
    card_destroyed(id);
}


// --------- execute -----------

on_create()


