/// 

global.stove_utils = {
    /// @param {Real} _x 
    /// @param {Real} _y 
    /// @returns {Real} 
    get_grid_id: function(_x, _y) {
        // TODO: better bitmap
        var _actual_x = (_x < kMapWidth) ? _x : kMapWidth-1
        _actual_x = (_actual_x > 0) ? _actual_x : 0
        if (!self.is_valid_grid(_actual_x, _y)) {
            return kInvalidGridId
        }
        return _y * kMapWidth + _actual_x 
    },

    /// @param {Array<Enum.ENEMY_LAYER>} _layers 
    enemy_layers_to_mask: function(_layers) {
        var mask = 0;
        var len = array_length(_layers);
        
        for (var i = 0; i < len; i++) {
            mask |= _layers[i]; 
        }
        
        return mask;
    },

    /// @param {Real} _grid_id 
    /// @returns {Struct.Vector2} 
    get_grid_position: function(_grid_id) {
        return {
            x: _grid_id % kMapWidth,
            y: _grid_id div kMapWidth
        };
    },

    /// @param {Real} _x 
    /// @param {Real} _y 
    /// @returns {Bool} 
    is_valid_grid: function(_x, _y) {
        var tmp_x = (_x >= kMapWidth) ? kMapWidth : _x
        return ((tmp_x >= 0) &&
                (tmp_x < kMapWidth) &&
                (_y >= 0) &&
                (_y < kMapHeight))
    },

    /// @param {Array<Id.Instance>} _objects 
    /// @param {Real} _x 
    /// @param {Real} _y 
    /// @returns {Id.Instance} 
    find_nearest: function(_objects, _x, _y) {
        /// @type {Id.Instance} 
        var _target = noone 
        var _min_distance_sq = infinity
        for (var i = 0; i < array_length(_objects); ++i) {
            var _obj = _objects[i]
            if (!instance_exists(_obj)) continue;
            var _dx = _obj.x - _x 
            var _dy = _obj.y - _y
            var _dist_sq = _dx * _dx + _dy * _dy
            if (_dist_sq < _min_distance_sq) {
                _min_distance_sq = _dist_sq
                _target = _obj
            }
        }
        return _target
    },

    /// @desc 
    /// @param {Real} _bitmap
    debug_print_spatial_bitmap: function (_bitmap) {
        var _map_width = kMapWidth;
        var _map_height = kMapHeight;
        var _output = "\n--- Spatial Bitmap (9x7) ---\n";
        _output += "L: Top-Left (Bit 0) -> H: Bottom-Right (Bit 62)\n";
        _output += "   0 1 2 3 4 5 6 7 8 (X)\n";

        for (var _y = 0; _y < _map_height; _y++) {
            var _line = string(_y) + ": ";
            for (var _x = 0; _x < _map_width; _x++) {
                var _grid_id = _y * _map_width + _x; 
                
                var _bit_mask = int64(1) << _grid_id;
                
                if ((_bitmap & _bit_mask) != int64(0)) {
                    _line += "X ";
                } else {
                    _line += ". "; 
                }
            }
            _output += _line + "\n";
        }
        
        _output += "----------------------------";
        show_debug_message(_output);
    }
}