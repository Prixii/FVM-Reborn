/// 
function Stove_FoodManagerUtils() constructor {
    /// @param {Struct.ShapedCardData} _data 
    static get_register_card_data = function(_data) {
        try {
            return {
                "shape": _data.basicInfo.shape,
                "sprite": _data.sprite,
                "cost": _data.cost[0],
                "cooldown": _data.cooldown[0],
                "description": _data.basicInfo.description,
                "plant_type": _data.basicInfo.foodType,
                "feature_type": _data.basicInfo.featureType,
                "target_card": _data.basicInfo.targetFood
            }
        } catch (e) {
            global.stove.logger.log_e("failed to parse", string(_data))
            throw(e)
        }
    }

    /// @param {Struct.ShapedCardData} _data 
    static get_register_card_lite_data = function(_data) {
        return {
            "name": _data.basicInfo.name,
            "shape": _data.basicInfo.shape,
            "description": _data.basicInfo.description,
            "hp": _data.hp,
            "cost": _data.cost,
            "atk": _data.atk,
            "range": _data.range,
            "cooldown": _data.cooldown,
            "cycle": _data.cycle
        }
    }
}