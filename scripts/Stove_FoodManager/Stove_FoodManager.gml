/// 

function Stove_FoodManager() constructor {
    self._food_meta_datas = {}



    /// @param {Struct.FoodMetaData} _food_meta_data 
    static register_food = function (_food_meta_data) {
        self._food_meta_datas[$ _food_meta_data.id] = _food_meta_data
    }
    
    /// @param {String} _food_id 
    /// @returns {Struct.FoodMetaData|Undefined} 
    static get_food_meta_data = function(_food_id) {
        return self._food_meta_datas[$ _food_id]
    }
}