/// 
self.mouse_enter = false
self.progress = 0.0
self.height = 30
self.width = 200
self.inactive_bg = c_white
self.active_bg = c_black
self.inactive_text = c_black
self.active_text = c_white

self.selected_color = c_yellow
self.is_selected = false
self.select_progress = 0

self.left = 0
self.top = 0
self.padding = 4
/// @type {function} 
self.on_click = undefined

self.text = "UNDEFINED"

self.auto_draw = true

/// @description Setup

function set_auto_draw(_enabled) {
    auto_draw = _enabled
    return self
}

function set_position(_left, _top) {
    left = _left
    top = _top
    return self
}

function set_size (_width, _height) {
    width = _width
    height = _height
    return self
}

/// @param {Bool} _value 
function select(_value) {
    is_selected = _value
    return self
}

function set_text(_text) {
    text = _text
    return self
}

/// @param {function} _func 
function set_on_click(_func) {
    on_click = _func
    return self
}

/// @description Step

function switch_state() {
    var _gui_x = device_mouse_x_to_gui(0);
    var _gui_y = device_mouse_y_to_gui(0);

    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    if (point_in_rectangle(_mx, _my, left, top, left+width, top+height)) {
        mouse_enter = true
    } else {
        mouse_enter = false
    }

    if (mouse_enter && mouse_check_button_released(mb_left)) {
        show_debug_message("click")
        if (on_click != undefined) {
            on_click()
        }
    }
}

function calc_data() {
    var _target = mouse_enter ? 1.0 : 0.0
    progress = lerp(progress, _target, 0.1)
    if (abs(progress - _target) < 0.001) {
        progress = _target
    }

    var _select_target = is_selected ? 1.0 : 0.0
    select_progress = lerp(select_progress, _select_target, 0.1)
    if (abs(select_progress - _select_target) < 0.001) {
        select_progress = _select_target
    }
}

function on_step() {
    switch_state()
    calc_data()
}

/// @description Draw GUI

function on_draw_gui() {
    var _active_width = (width - self.padding * 2) * progress

    
    draw_set_color(inactive_bg);
    draw_rectangle(left, top, left + width, top + height, false);

    if (_active_width > 5) {
        draw_set_color(active_bg);
        draw_rectangle(left + self.padding, top + self.padding, left + _active_width + self.padding, top + height - self.padding, false);
    }
    
    var _select_width = width * select_progress
    if (_select_width > 5 ) {
        draw_set_color(selected_color);
        draw_rectangle(left, top, left + _select_width, top + height, false);
    }

    if (mouse_enter == true && is_selected == false) {
        draw_set_color(active_text);
    } else {
        draw_set_color(inactive_text);
    }
    draw_set_font(-1)
    draw_text(left + 10, top + height / 2 - 10, text);
}