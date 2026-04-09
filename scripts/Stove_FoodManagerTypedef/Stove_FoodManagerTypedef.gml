/// 

/// @param {Struct.FoodMetaData} _foodMetaData 
function register_mod_food(_foodMetaData) {
    register_card(
        _foodMetaData.id, 
        Stove_Food, 
        array_map(_foodMetaData.shapedCardDatas, function(_data, _) {
            return global.stove.food_manager_utils.get_register_card_data(_data);
        }))
    register_plant_lite(
        _foodMetaData.id,
        array_map(_foodMetaData.shapedCardDatas, function(_data,_) {
            return global.stove.food_manager_utils.get_register_card_lite_data(_data)
        }))
    register_card_skill(
        _foodMetaData.id, 
        _foodMetaData.skillInfo.key, 
        _foodMetaData.skillInfo.data)
    register_card_info_island(
        _foodMetaData.id, 
        _foodMetaData.infoIslandDescription)
}

/// @param {String} _id
/// @param {Array<Struct.ShapedCardData>} _shapedCardDatas
/// @param {String} _infoIslandDescription
/// @param {Struct.SkillInfo} _skillInfo
function FoodMetaData(_id, _shapedCardDatas, _infoIslandDescription, _skillInfo) constructor {
    self.id = _id
    self.shapedCardDatas = _shapedCardDatas
    self.infoIslandDescription = _infoIslandDescription
    self.skillInfo = _skillInfo
    self.tags = (argument_count > 4) ? argument[4] : []
}

/// @param {String} _path
/// @param {Real} _frameCount
function SpriteSheet(_path, _frameCount) constructor {
    self.path = _path
    self.frameCount = _frameCount
}

/// 对应 Lua AnimationClip；内含 SpriteSheet 引用与帧区间（GML 使用 camelCase 字段名）。
/// @param {Struct.SpriteSheet} _spriteSheet
/// @param {Real} _startFrame
/// @param {Real} _endFrame
function FoodAnimationClip(_spriteSheet, _startFrame, _endFrame) constructor {
    self.spriteSheet = _spriteSheet
    self.startFrame = _startFrame
    self.endFrame = _endFrame
}

/// @param {Struct.FoodAnimationClip} _idleAnimation
/// @param {Struct.FoodAnimationClip} _attackAnimation
function FoodAnimatable(_idleAnimation, _attackAnimation) constructor {
    self.idleAnimation = _idleAnimation
    self.attackAnimation = _attackAnimation
}

/// @param {String} _type
/// @param {Real} _atk
function Damage(_type, _atk) constructor {
    self.type = _type
    self.atk = _atk
}

/// @param {Real} _speed
/// @param {String} _direction
function FoodKinematic(_speed, _direction) constructor {
    self.speed = _speed
    self.direction = _direction
}

/// @param {Struct.Damage} _damage
/// @param {Struct.FoodKinematic} _kinematic
/// @param {Array<String>} _tags
function Bullet(_damage, _kinematic, _tags) constructor {
    self.damage = _damage
    self.kinematic = _kinematic
    self.tags = _tags
}

/// 与 Lua AttackArea 对应的数据描述（勿与战斗用的 AttackArea 混淆）。
/// @param {String} _type
/// @param {String} _direction
/// @param {Real} _distance
function FoodAttackArea(_type, _direction, _distance) constructor {
    self.type = _type
    self.direction = _direction
    self.distance = _distance
}

/// @param {Array<String>} _attackLayer
/// @param {Array<Struct.Bullet>} _defaultBullets
/// @param {Struct.FoodAttackArea} _attackArea
/// @param {Real} _defaultCycle
function FoodAttackable(_attackLayer, _defaultBullets, _attackArea, _defaultCycle) constructor {
    self.attackLayer = _attackLayer
    self.defaultBullets = _defaultBullets
    self.attackArea = _attackArea
    self.defaultCycle = _defaultCycle
}

/// @param {String} _name
/// @param {Real} _shape
/// @param {String} _description
/// @param {Real} _defaultHp
/// @param {Real} _defaultCost
/// @param {Real} _defaultCooldown
/// @param {String} _foodType
/// @param {String} _featureType
/// @param {String} _targetFood
function FoodBasicInfo(
        _name, _shape, _description, _defaultHp, _defaultCost, _defaultCooldown,
        _foodType, _featureType, _targetFood) constructor {
    self.name = _name
    self.shape = _shape
    self.description = _description
    self.defaultHp = _defaultHp
    self.defaultCost = _defaultCost
    self.defaultCooldown = _defaultCooldown
    self.foodType = _foodType
    self.featureType = _featureType
    self.targetFood = _targetFood
}

/// @param {Struct.FoodBasicInfo} _basicInfo
/// @param {Struct.FoodAnimatable} _animatable
/// @param {Struct.FoodAttackable} _attackable
function ShapedCardData(_basicInfo, _animatable, _attackable) constructor {
    self.basicInfo = _basicInfo
    self.animatable = _animatable
    self.attackable = _attackable

    self.hp = array_create(kMaxLevel, _basicInfo.defaultHp)
    self.cost = array_create(kMaxLevel, _basicInfo.defaultCost)
    self.cooldown = array_create(kMaxLevel, _basicInfo.defaultCooldown)

    var _atk_val = 0
    if (array_length(_attackable.defaultBullets) > 0) {
        _atk_val = _attackable.defaultBullets[0].damage.atk
    }
    self.atk = array_create(kMaxLevel, _atk_val)

    var _range_val = _attackable.attackArea.distance
    self.range = array_create(kMaxLevel, _range_val)

    self.cycle = array_create(kMaxLevel, _attackable.defaultCycle)

    var _idle_sheet = _animatable.idleAnimation.spriteSheet
    var _sprite_sheet_info = new SpriteSheetInfo(_idle_sheet.path, _idle_sheet.frameCount)
    self.sprite = global.stove.sprite_manager.request_sprite(_sprite_sheet_info.key)
}



/// @param {String} _key 
/// @param {Array<Real>} _data 
function SkillInfo(_key, _data) constructor {
    self.key = _key
    self.data = _data
}


function food_lua_plain_get(_s, _key) {
    var _def = (argument_count > 2) ? argument[2] : undefined;
    if (typeof(_s) != "struct") {
        return _def;
    }
    if (!variable_struct_exists(_s, _key)) {
        return _def;
    }
    return variable_struct_get(_s, _key);
}

function food_sprite_sheet_from_lua_plain(_s) {
    return new SpriteSheet(food_lua_plain_get(_s, "path"), food_lua_plain_get(_s, "frameCount"));
}

function food_animation_clip_from_lua_plain(_s) {
    return new FoodAnimationClip(
        food_sprite_sheet_from_lua_plain(food_lua_plain_get(_s, "spriteSheet")),
        food_lua_plain_get(_s, "startFrame"),
        food_lua_plain_get(_s, "endFrame"));
}

function food_animatable_from_lua_plain(_s) {
    return new FoodAnimatable(
        food_animation_clip_from_lua_plain(food_lua_plain_get(_s, "idleAnimation")),
        food_animation_clip_from_lua_plain(food_lua_plain_get(_s, "attackAnimation")));
}

function food_damage_from_lua_plain(_s) {
    return new Damage(food_lua_plain_get(_s, "type"), food_lua_plain_get(_s, "atk"));
}

function food_kinematic_from_lua_plain(_s) {
    return new FoodKinematic(food_lua_plain_get(_s, "speed"), food_lua_plain_get(_s, "direction"));
}

function food_bullet_from_lua_plain(_s) {
    var _tags = food_lua_plain_get(_s, "tags");
    if (typeof(_tags) != "array") {
        _tags = is_undefined(_tags) ? [] : [_tags];
    }
    return new Bullet(
        food_damage_from_lua_plain(food_lua_plain_get(_s, "damage")),
        food_kinematic_from_lua_plain(food_lua_plain_get(_s, "kinematic")),
        _tags);
}

function food_default_bullets_from_lua_plain(_v) {
    if (is_undefined(_v)) {
        return [];
    }
    var _t = typeof(_v);
    if (_t == "array") {
        var _n = array_length(_v);
        var _out = array_create(_n, undefined);
        for (var _i = 0; _i < _n; _i++) {
            _out[_i] = food_bullet_from_lua_plain(_v[_i]);
        }
        return _out;
    }
    if (_t == "struct") {
        if (array_length(variable_struct_get_names(_v)) == 0) {
            return [];
        }
        if (variable_struct_exists(_v, "damage")) {
            return [food_bullet_from_lua_plain(_v)];
        }
    }
    return [];
}

function food_attack_area_from_lua_plain(_s) {
    return new FoodAttackArea(
        food_lua_plain_get(_s, "type"),
        food_lua_plain_get(_s, "direction"),
        food_lua_plain_get(_s, "distance"));
}

function food_attackable_from_lua_plain(_s) {
    var _layer = food_lua_plain_get(_s, "attackLayer");
    if (typeof(_layer) != "array") {
        _layer = is_undefined(_layer) ? [] : [_layer];
    }
    return new FoodAttackable(
        _layer,
        food_default_bullets_from_lua_plain(food_lua_plain_get(_s, "defaultBullets")),
        food_attack_area_from_lua_plain(food_lua_plain_get(_s, "attackArea")),
        food_lua_plain_get(_s, "defaultCycle"));
}

function food_basic_info_from_lua_plain(_s) {
    return new FoodBasicInfo(
        food_lua_plain_get(_s, "name"),
        food_lua_plain_get(_s, "shape"),
        food_lua_plain_get(_s, "description"),
        food_lua_plain_get(_s, "defaultHp"),
        food_lua_plain_get(_s, "defaultCost"),
        food_lua_plain_get(_s, "defaultCooldown"),
        food_lua_plain_get(_s, "foodType"),
        food_lua_plain_get(_s, "featureType"),
        food_lua_plain_get(_s, "targetFood"));
}

function shaped_card_data_from_lua_plain(_s) {
    return new ShapedCardData(
        food_basic_info_from_lua_plain(food_lua_plain_get(_s, "basicInfo")),
        food_animatable_from_lua_plain(food_lua_plain_get(_s, "animatable")),
        food_attackable_from_lua_plain(food_lua_plain_get(_s, "attackable")));
}

function skill_info_from_lua_plain(_s) {
    var _data = food_lua_plain_get(_s, "data");
    if (typeof(_data) != "array") {
        _data = [];
    }
    return new SkillInfo(food_lua_plain_get(_s, "key"), _data);
}

/// @param {Struct} _lua_typed 已由 LuaType() 规范化过的食物元数据 struct
/// @returns {Struct.FoodMetaData}
function FoodMetaDataFromLuaPlain(_lua_typed) {
    var _cards_raw = food_lua_plain_get(_lua_typed, "shapedCardDatas");
    if (typeof(_cards_raw) != "array") {
        _cards_raw = [];
    }
    var _n = array_length(_cards_raw);
    var _cards = array_create(_n, undefined);
    for (var _j = 0; _j < _n; _j++) {
        _cards[_j] = shaped_card_data_from_lua_plain(_cards_raw[_j]);
    }
    var _tags = food_lua_plain_get(_lua_typed, "tags");
    if (typeof(_tags) != "array") {
        _tags = is_undefined(_tags) ? [] : [_tags];
    }
    return new FoodMetaData(
        food_lua_plain_get(_lua_typed, "id"),
        _cards,
        food_lua_plain_get(_lua_typed, "infoIslandDescription"),
        skill_info_from_lua_plain(food_lua_plain_get(_lua_typed, "skillInfo")),
        _tags);
}

