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
    JSON_PARSE_FAILED = 0x1004,
    CREATE_FILE_FAILED = 0x1005,
    
    // mod_loader
    INVALID_METADATA = 0x2001,
    LOAD_LUA_FAILED = 0x2002,
    CALL_LUA_FAILED = 0x2003,
    GET_LUA_VARIABLE_FAILED = 0x2004,
    SET_LUA_VARIABLE_FAILED = 0x2005,
    GET_LUA_FUNCTION_FAILED = 0x2006,
    SET_LUA_FUNCTION_FAILED = 0x2007,
    GET_LUA_PROPERTY_FAILED = 0x2008,
    INVALID_TYPE = 0x2009,
}

enum ASSET_SOURCE {
    IN_GAME = 0x00,
    EXTERNAL = 0x01
}

enum ORIGINAL_MUSIC {
    DELICIOUS_TOWER_PRE = 0x2000,
    DELICIOUS_TOWER_ELITE = 0x2001,
    DELICIOUS_TOWER_BOSS = 0x2002,
    VOLCANIC_TOWER_PRE = 0x2010,
    VOLCANIC_TOWER_ELITE = 0x2011,
    VOLCANIC_TOWER_BOSS = 0x2012,

}

enum ORIGINAL_SPRITE {
    SALAD_ISLAND_LAND = 0x1000,
    SALAD_ISLAND_WATER = 0x1001,
    COOKIE_ISLAND = 0x1002,
    MOUSSE_ISLAND = 0x1003,
    CHAMPAGNE_ISLAND_LAND = 0x1004,
    CHAMPAGNE_ISLAND_WATER = 0x1005,
    TEMPLE = 0x1006,
    PUDDING_ISLAND_DAYTIME = 0x1007,
    PUDDING_ISLAND_NIGHT = 0x1008,
    COCOA_ISLAND_DAYTIME = 0x1009,
    COCOA_ISLAND_NIGHT = 0x100A,
    CURRY_ISLAND_DAYTIME = 0x100B,
    CURRY_ISLAND_NIGHT = 0x100C,
    ABYSS = 0x100D,
}

/// @description Resolve Lua interop numeric id (ORIGINAL_SPRITE) to a built-in sprite asset.
/// @param {Real|Enum.ORIGINAL_SPRITE} _id  Value from Stove_Asset.gml_asset_name when using ORIGINAL_SPRITE ids.
/// @returns {Asset.GMSprite}  Sprite handle, or -1 if unknown.
function stove_original_sprite_from_enum(_id) {
    switch (_id) {
        case ORIGINAL_SPRITE.SALAD_ISLAND_LAND: return spr_salad_island_land
        case ORIGINAL_SPRITE.SALAD_ISLAND_WATER: return spr_salad_island_water
        case ORIGINAL_SPRITE.COOKIE_ISLAND: return spr_cookie_island
        case ORIGINAL_SPRITE.MOUSSE_ISLAND: return spr_mousse_island
        case ORIGINAL_SPRITE.CHAMPAGNE_ISLAND_LAND: return spr_champagne_island_land
        case ORIGINAL_SPRITE.CHAMPAGNE_ISLAND_WATER: return spr_champagne_island_water
        case ORIGINAL_SPRITE.TEMPLE: return spr_temple
        case ORIGINAL_SPRITE.PUDDING_ISLAND_DAYTIME: return spr_pudding_island_daytime
        case ORIGINAL_SPRITE.PUDDING_ISLAND_NIGHT: return spr_pudding_island_night
        case ORIGINAL_SPRITE.COCOA_ISLAND_DAYTIME: return spr_cocoa_island_daytime
        case ORIGINAL_SPRITE.COCOA_ISLAND_NIGHT: return spr_cocoa_island_night
        case ORIGINAL_SPRITE.CURRY_ISLAND_DAYTIME: return spr_curry_island_daytime
        case ORIGINAL_SPRITE.CURRY_ISLAND_NIGHT: return spr_curry_island_night
        case ORIGINAL_SPRITE.ABYSS: return spr_abyss
        default: return -1
    }
}

/// @description Resolve Lua interop numeric id (ORIGINAL_MUSIC) to a built-in sound asset.
/// @param {Real|Enum.ORIGINAL_MUSIC} _id  Value from Stove_Asset.gml_asset_name when using ORIGINAL_MUSIC ids.
/// @returns {Asset.GMSound}  Sound handle, or -1 if unknown.
function stove_original_music_from_enum(_id) {
    switch (_id) {
        case ORIGINAL_MUSIC.DELICIOUS_TOWER_PRE: return mus_delicious_tower_pre
        case ORIGINAL_MUSIC.DELICIOUS_TOWER_ELITE: return mus_delicious_tower_elite
        case ORIGINAL_MUSIC.DELICIOUS_TOWER_BOSS: return mus_delicious_tower_boss
        case ORIGINAL_MUSIC.VOLCANIC_TOWER_PRE: return mus_volcanic_tower_pre
        case ORIGINAL_MUSIC.VOLCANIC_TOWER_ELITE: return mus_volcanic_tower_elite
        case ORIGINAL_MUSIC.VOLCANIC_TOWER_BOSS: return mus_volcanic_tower_boss
        default: return -1
    }
}