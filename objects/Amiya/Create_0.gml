/// 

event_inherited()

plant_id = "amiya"

current_level = 1
event_user(0)
state = CARD_STATE.IDLE

obj_type = object_index
current_frame = 0
total_frame = 18
image_xscale = 2.2
image_yscale = 2.2
plant_type = "normal"
idle_anim = 11
attack_anim_len = 7
flash_speed = 5
is_slowdown = false
self.is_frozen = false


self.sprite_manager = global.stove.sprite_manager

var idle_sprite_path = "mods/assets/amiya_idle.png"
var attack_sprite_path = "mods/assets/amiya_attack.png"
var idle_sprite_info = new SpriteSheetInfo(idle_sprite_path, 11, 40, 85)
var attack_sprite_info = new SpriteSheetInfo(attack_sprite_path, 7, 40, 85)

idle_sprite = sprite_manager.request_sprite(idle_sprite_info.key)
attack_sprite = sprite_manager.request_sprite(attack_sprite_info.key)

sprite_index = idle_sprite

attack_area = new LineAttackArea(LINE_DIRECTION.HORIZONTAL, 9, false, [ENEMY_LAYER.AIR, ENEMY_LAYER.GROUND])

var grid_pos = get_grid_position_from_world(x, y);
self.attack_area_mask = attack_area.calculate_attack_area_mask(grid_pos.col, grid_pos.row)

global.stove_utils.debug_print_spatial_bitmap(attack_area_mask)

self.attack_enemy_layer = [ENEMY_LAYER.AIR, ENEMY_LAYER.GROUND]
self.attack_enemy_layer_mask = global.stove_utils.enemy_layers_to_mask(attack_enemy_layer)
self.spatial_registry = global.stove.spatial_registry


self.max_bullet_count = 6
self.bullets = []
self.kinematic = new OrbitKinematic(150, -0.03)
shoot = function() {
    /// @type {Asset.GMObject.Stove_DamageMedia} 
    var _bullet = instance_create_depth(x + 20, y - 75, depth - 500, Stove_DamageMedia)
    _bullet.init(self.kinematic, self.atk, "normal", "normal", spr_sausage_bullet)
    array_push(self.bullets, _bullet)
}