/// 
self.items = []
self.scroll_y = 0
self.scroll_target_y = 0
self.scroll_lerp = 0.2
self.item_spacing = 4
self.viewport_left = 0
self.viewport_top = 0
self.viewport_width = 200
self.viewport_height = 300
self.wheel_step = 10
self.padding_left = 0
self.padding_top = 0
self.padding_bottom = 0

/// @type {Asset.GMObject.Halftone} 
self.fade_halftone_top = noone
/// @type {Asset.GMObject.Halftone} 
self.fade_halftone_bottom = noone

/// @description Setup

function set_viewport(_left, _top, _width, _height) {
    viewport_left = _left
    viewport_top = _top
    viewport_width = _width
    viewport_height = _height
    clamp_scroll_bounds()
    return self
}

function init() {
    fade_halftone_top = instance_create_layer(x, y, "Instances", Halftone)
    fade_halftone_top.set_dot_color(c_black)
        .set_direction(0)
        .set_size(viewport_width, 40)
        .set_position(viewport_left, viewport_top)
        .set_radius_max(6)

    fade_halftone_bottom = instance_create_layer(x, y + viewport_height, "Instances", Halftone)
    fade_halftone_bottom.set_dot_color(c_black)
        .set_direction(1)
        .set_size(viewport_width, 40)
        .set_position(viewport_left, viewport_top + viewport_height - 40)
        .set_radius_max(6)
}

function set_item_spacing(_spacing) {
    item_spacing = _spacing
    return self
}

function set_padding(_left, _top, _bottom) {
    padding_left = _left
    padding_top = _top
    padding_bottom = _bottom
    return self
}

function set_wheel_step(_pixels) {
    wheel_step = _pixels
    return self
}

/// @param {real} _k
function set_scroll_lerp(_k) {
    scroll_lerp = clamp(_k, 0.01, 1)
    return self
}

function set_halftone_fade_height(_pixels) {
    if (instance_exists(fade_halftone_top)) {
        fade_halftone_top.set_fade_height(_pixels)
    }
    return self
}

/// @param {array} _instances 
function set_items(_instances) {
    items = _instances
    clamp_scroll_bounds()
    return self
}

function get_item_height(_inst) {
    if (!instance_exists(_inst)) {
        return 0
    }
    if (variable_instance_exists(_inst, "height")) {
        return _inst.height
    }
    return 0
}

function get_content_height() {
    var n = array_length(items)
    if (n <= 0) {
        return 0
    }
    var sum = 0
    for (var i = 0; i < n; i++) {
        sum += get_item_height(items[i])
    }
    return sum + max(0, n - 1) * item_spacing + padding_bottom + padding_top
}

function get_max_scroll() {
    return max(0, get_content_height() - viewport_height)
}

function clamp_scroll_bounds() {
    var _max = get_max_scroll()
    scroll_target_y = clamp(scroll_target_y, 0, _max)
    scroll_y = clamp(scroll_y, 0, _max)
}

function smooth_scroll_y() {
    clamp_scroll_bounds()
    var _k = scroll_lerp
    scroll_y = lerp(scroll_y, scroll_target_y, _k)
    if (abs(scroll_y - scroll_target_y) < 0.35) {
        scroll_y = scroll_target_y
    }
}

function is_mouse_over_viewport() {
    var _mx = device_mouse_x_to_gui(0)
    var _my = device_mouse_y_to_gui(0)
    return point_in_rectangle(
        _mx, _my,
        viewport_left, viewport_top,
        viewport_left + viewport_width, viewport_top + viewport_height
    )
}

function apply_wheel() {
    if (!is_mouse_over_viewport()) {
        return
    }
    if (mouse_wheel_up()) {
        scroll_target_y -= wheel_step
    }
    if (mouse_wheel_down()) {
        scroll_target_y += wheel_step
    }
    clamp_scroll_bounds()
}

function layout_items() {
    var _y = padding_top
    var n = array_length(items)
    for (var i = 0; i < n; i++) {
        var inst = items[i]
        if (!instance_exists(inst)) {
            continue
        }
        inst.left = viewport_left + padding_left
        inst.top = viewport_top + _y - scroll_y
        _y += get_item_height(inst)
        if (i < n - 1) {
            _y += item_spacing
        }
    }
}

/// @description Begin Step — layout + scroll before child Step

function on_begin_step() {
    apply_wheel()
    smooth_scroll_y()
    layout_items()
}

/// @description Draw GUI

function on_draw_gui() {
    var n = array_length(items)
    if (n <= 0) {
        return
    }

    var _prev_scissor = gpu_get_scissor()
    gpu_set_scissor(
        floor(viewport_left),
        floor(viewport_top),
        floor(viewport_width),
        floor(viewport_height)
    )

    for (var i = 0; i < n; i++) {
        var inst = items[i]
        if (!instance_exists(inst)) {
            continue
        }
        if (variable_instance_exists(inst, "auto_draw") && inst.auto_draw) {
            continue
        }
        if (!variable_instance_exists(inst, "on_draw_gui")) {
            continue
        }
        inst.on_draw_gui()
    }
    gpu_set_scissor(_prev_scissor)
    fade_halftone_top.on_draw_gui()
    fade_halftone_bottom.on_draw_gui()
}


