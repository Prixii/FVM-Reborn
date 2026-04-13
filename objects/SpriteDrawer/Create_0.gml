/// 

self.sprite_index = -1
self.updated = false
self.room_width = 0
self.room_height = 0
self.offset_x = 0
self.offset_y = 0

self.current_offset_y = 256
self.y_velocity = 0.1
self.alpha = 0

function set_room_size(_width, _height) {
    room_width = _width
    room_height = _height
    return self
}

function set_offset(_x, _y) {
    offset_x = _x
    offset_y = _y
    return self
}

/// @param {Asset.GMSprite} _sprite 
function set_sprite(_sprite) {
    if (_sprite == sprite_index) {
        return
    }
    self.current_offset_y = 256
    self.alpha = 0
    self.sprite_index = _sprite
    self.updated = true
    return self
}

function on_step() {
    if (self.current_offset_y != self.offset_y) {
        var _offset_y = lerp(self.current_offset_y, self.offset_y, self.y_velocity)
        var _alpha = lerp(self.alpha, 1, 0.02)
        if (abs(_offset_y - self.offset_y) < 1) {
            _offset_y = self.offset_y
        }
        if (abs(_alpha - 1) < 0.01) {
            _alpha = 1
        }
        self.current_offset_y = _offset_y
        self.alpha = _alpha
    }
}

function on_draw() {
    if (sprite_index == -1) {
        return
    }
    var _sprite_height = sprite_get_height(sprite_index)
    var _scale = room_height / _sprite_height

    draw_sprite_ext(sprite_index, 0, offset_x, self.current_offset_y, _scale, _scale, 0, c_white, self.alpha)

}