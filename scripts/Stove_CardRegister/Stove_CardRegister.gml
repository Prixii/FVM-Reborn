///// @deprecated this file is about to be deprecated
//
//
///// @param {Struct.FoodMetaData} _food_meta_data 
//function register_mod_food(_food_meta_data) {
//    register_card(
//        _food_meta_data.id, 
//        Stove_Food, 
//        array_map(_food_meta_data.shaped_card_datas, function(_data, _) {
//            return _data.get_register_card_data();
//        }))
//    register_plant_lite(
//        _food_meta_data.id,
//        array_map(_food_meta_data.shaped_card_datas, function(_data,_) {
//            return _data.get_register_card_lite_data()
//        }))
//    register_card_skill(
//        _food_meta_data.id, 
//        _food_meta_data.skill_info.key, 
//        _food_meta_data.skill_info.data)
//    register_card_info_island(
//        _food_meta_data.id, 
//        _food_meta_data.info_island_description)
//}
//
///// @param {String} _id
///// @param {Array<Struct.ShapedCardData>}   _shaped_card_datas
///// @param {String}   _info_island_description
///// @param {Struct.SkillInfo} _skill_info
//function FoodMetaData(
//        _id, _shaped_card_datas, 
//        _info_island_description, _skill_info) constructor {
//    self.id = _id
//    self.shaped_card_datas = _shaped_card_datas
//    self.info_island_description = _info_island_description
//    self.skill_info = _skill_info
//    self.idle_animation_clip = {}
//    self.attack_animation_clip = {}
//    /// @type {Struct.AttackArea} 
//    self.attack_area = new AttackArea(ATTACK_AREA_TYPE.CIRCULAR, [ENEMY_LAYER.ALL])
//    self.damage_media_metadatas = {}
//    self.attack_layers = {}
//    self.tags = {}
//}
//
///// @param {String} _name 
///// @param {Real}   _shape
///// @param {String} _description
///// @param {Real} _default_hp 
///// @param {Real} _default_cost 
///// @param {Real} _default_atk 
///// @param {Real} _default_cooldown 
///// @param {Real} _default_range 
///// @param {Real} _default_cycle
///// @param {Enum.PLANT_TYPE} _plant_type
///// @param {Enum.FEATURE_TYPE} _feature_type
///// @param {String} _target_card 
///// @param {Struct.SpriteSheetInfo} _sprite_sheet_info 
//function ShapedCardData (
//        _name, _shape, _description, _default_hp, 
//        _default_cost, _default_atk, _default_cooldown, 
//        _default_range, _default_cycle, _plant_type, 
//        _feature_type, _target_card, _sprite_sheet_info) constructor {
//    self.name = _name
//    self.shape = _shape
//    self.description = _description
//    self.hp = array_create(kMaxLevel, _default_hp)
//    self.cost = array_create(kMaxLevel, _default_cost)
//    self.atk = array_create(kMaxLevel, _default_atk)
//    self.cooldown = array_create(kMaxLevel, _default_cooldown)
//    self.range = array_create(kMaxLevel, _default_range)
//    self.cycle = array_create(kMaxLevel, _default_cycle)
//
//    self.plant_type = plant_type_name(_plant_type)
//    self.feature_type = feature_type_name(_feature_type)
//    self.target_card = _target_card
//    
//    self.sprite_sheet_info = _sprite_sheet_info
//    self.sprite = global.stove.sprite_manager.request_sprite(_sprite_sheet_info.key)
//
//
//    static get_register_card_data = function() {
//        return {
//            "shape": self.shape,
//            "sprite": self.sprite,
//            "cost": self.cost[0],
//            "cooldown": self.cooldown[0],
//            "description": self.description,
//            "plant_type": self.plant_type,
//            "feature_type": self.feature_type,
//            "target_card": self.target_card
//        }
//    }
//
//    static get_register_card_lite_data = function() {
//        return {
//            "name": self.name,
//            "shape": self.shape,
//            "description": self.description,
//            "hp": self.hp,
//            "cost": self.cost,
//            "atk": self.atk,
//            "range": self.range,
//            "cooldown": self.cooldown,
//            "cycle": self.cycle
//        }
//    }
//}
//
//
//
///// @param {String} _key 
///// @param {Array<Real>} _data 
//function SkillInfo(_key, _data) constructor {
//    self.key = _key
//    self.data = _data
//}

