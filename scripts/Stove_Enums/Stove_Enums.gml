/// 
enum FOOD_TYPE {
    NORMAL,
    UPGRADE,
}

enum ATTACK_AREA_TYPE {
    LINE,
    RECTANGLE,  
    MANHATTAN,    
    COMPOSITE,  
    // low performance
    FREE_LINE,  
    CIRCULAR
}

enum LINE_DIRECTION {
    HORIZONTAL,
    VERTICAL,
    LB_RT,
    LT_RB,
}

enum FEATURE_TYPE {
    NORMAL,
    LOW,
    DWARF,
    WATER,
    AMPHI,
    UPGRADE,
}

/// @param {Enum.FEATURE_TYPE} _feature_type 
/// @returns {String} 
function feature_type_name(_feature_type) {
    if (_feature_type == FEATURE_TYPE.NORMAL) return "normal"
    if (_feature_type == FEATURE_TYPE.LOW) return "low"
    if (_feature_type == FEATURE_TYPE.DWARF) return "dwarf"
    if (_feature_type == FEATURE_TYPE.WATER) return "water"
    if (_feature_type == FEATURE_TYPE.AMPHI) return "amphi"
    if (_feature_type == FEATURE_TYPE.UPGRADE) return "upgrade"
    return "none"
}


enum PLANT_TYPE {
    NORMAL
}

/// @param {Enum.PLANT_TYPE} _plant_type 
/// @returns {String} 
function plant_type_name(_plant_type) {
    if (_plant_type == PLANT_TYPE.NORMAL) return "normal"
    return "none"
}

enum ENEMY_LAYER {
    NONE = 0,
    GROUND = 0x1,
    AIR = 0x10,
    UNDERGROUND = 0x100,

    ALL = 0x111,
}


enum TARGET_TYPE {
    NORMAL
}

enum DEPTH_GROUP {
    FOREGROUND = 0,
    MIDGROUND = 1,
    BACKGROUND = 2,
}

enum STOVE_ERROR {
    NO_SUCH_FILE = 0x1001,
    NO_SUCH_RESOURCE = 0x1002,
    LOAD_RESOURCE_FAILED = 0x1003,
}