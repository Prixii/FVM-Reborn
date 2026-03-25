/// 



if (should_exit()) {
	exit
}

if (image_index_updated()) {
	check_bullet()
	check_state()
}


/// @returns {Bool} 
function should_exit() {
	return (global.is_paused) ||
		is_frozen
}

/// @returns {Bool} 
function image_index_updated() {
    var _multiplier = is_slowdown ? 2 : 1;
    var _target_flash_speed = flash_speed * _multiplier;

    if (timer < _target_flash_speed - 1) {
        timer++;
        return false;
    }

    timer = 0;
    image_index++;

    var _upgrade_data = get_plant_data_with_skill(plant_id, shape, current_level, skill);
    cycle = _upgrade_data[? "cycle"] * _multiplier;

    return true;
}

function check_bullet() {
	bullets = array_filter(bullets, function(_inst) {
		return instance_exists(_inst)
	})
}

function check_state() {
	var _attack_target_mask = spatial_registry.should_attack(attack_area_mask, attack_enemy_layer_mask)
	var _bullet_full = (array_length(bullets) == max_bullet_count)
	if (!_bullet_full && (_attack_target_mask != 0)) {
		if(state != CARD_STATE.ATTACK) {
			sprite_index = attack_sprite
			image_index = 0
			state = CARD_STATE.ATTACK
		}
		if (image_index mod attack_anim_len == 0) {
			shoot()
		}
	} else {
		if (state != CARD_STATE.IDLE) {
			sprite_index = idle_sprite
			image_index = 0
			state = CARD_STATE.IDLE
		}
		attack_timer = 0;
	}
}