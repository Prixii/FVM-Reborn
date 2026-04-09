/// 

function Stove_FoodManager() constructor {
    self._food_meta_datas = {}

    /// @param {Struct.FoodMetaData} _food_meta_data 
    static register_food = function (_food_meta_data) {
        if (_food_meta_data == undefined) {
            return new Result().fail(STOVE_ERROR.INVALID_TYPE, "food_meta_data is undefined")
        }
        global.stove.logger.log_d("register_food " + string(_food_meta_data))
        self._food_meta_datas[$ _food_meta_data.id] = _food_meta_data
        register_mod_food(_food_meta_data)
        return new Result().success()
    }

    /// @param {String} _food_id 
    /// @returns {Struct.FoodMetaData|Undefined} 
    static get_food_meta_data = function(_food_id) {
        return self._food_meta_datas[$ _food_id]
    }

}