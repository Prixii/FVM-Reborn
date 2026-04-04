/// 
enum EVENT_TYPE {
    FOOD_DEPLOY = 1,
    NEW_ENEMY_DEPLOYED = 2,
    FOOD_DESTROYED = 3,
    ENEMY_DESTROYED = 4,
}

/// @param {Enum.EVENT_TYPE} _type 
function StoveEvent(_type) constructor {
    self.type = _type
}

/// @param {Real} _card_id 
/// @param {Real} _grid_row 
/// @param {Real} _grid_col 
function FoodDeployEvent(_card_id, _grid_row, _grid_col): StoveEvent(EVENT_TYPE.FOOD_DEPLOY) constructor {
    self.card_id = _card_id
    self.grid_row = _grid_row
    self.grid_col = _grid_col
}