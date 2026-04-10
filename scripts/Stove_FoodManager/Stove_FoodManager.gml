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

    static load_all_sprites = function() {
        var _food_ids = variable_struct_get_names(self._food_meta_datas)
        global.stove.logger.log_d("load_all_sprites, food count: " + string(array_length(_food_ids)))
        for (var i = 0; i < array_length(_food_ids); i++) {
            /// @type {Struct.FoodMetaData} 
            var _meta_data = self._food_meta_datas[$ _food_ids[i]]
            global.stove.logger.log_d("load for food " + string(_meta_data.id))
            var _shaped_data = _meta_data.shapedCardDatas
            for (var j = 0; j < array_length(_shaped_data); j++) {
                set_static_preview(_shaped_data[j])
            }
        }
    }
}