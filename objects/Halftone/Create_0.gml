/// 
/// Shader：实心矩形 + 圆洞。direction 见 set_direction。

self.fade_height = 40
self.grid_step = 4
self.dot_color = c_white
self.curve_power = 1.1
self.radius_min = 0.5
self.radius_max = 11

self.offset_x = 0
self.offset_y = 0
self.width = 0
self.height = 0

/// 0=向下 +Y，1=向上 -Y，2=向右 +X，3=向左 -X（条带内渐变方向）
self.direction = 0

self.gl_frag_y_flip = 0
self.draw_self = false

var _sh = HalftoneShader
self.uni_gui = shader_get_uniform(_sh, "u_gui")
self.uni_origin = shader_get_uniform(_sh, "u_origin")
self.uni_gl_y_flip = shader_get_uniform(_sh, "u_gl_y_flip")
self.uni_band_size = shader_get_uniform(_sh, "u_band_size")
self.uni_radius_min = shader_get_uniform(_sh, "u_radius_min")
self.uni_radius_max = shader_get_uniform(_sh, "u_radius_max")
self.uni_curve = shader_get_uniform(_sh, "u_curve")
self.uni_direction = shader_get_uniform(_sh, "u_direction")
self.uni_rgb = shader_get_uniform(_sh, "u_rgb")

function set_position(_left, _top) {
    offset_x = _left
    offset_y = _top
    return self
}

function set_radius_min(_r) {
    radius_min = max(0, _r)
    return self
}

function set_radius_max(_r) {
    radius_max = max(radius_min, _r)
    return self
}

/// @param {real} _c 越大洞越早变大（shader 内用 1/c 作幂）；建议约 0.9～1.5
function set_curve_power(_c) {
    curve_power = max(0.05, _c)
    return self
}

/// @param {real} _dir 0 下 +Y | 1 上 -Y | 2 右 +X | 3 左 -X
function set_direction(_dir) {
    direction = clamp(_dir, 0, 3)
    return self
}

function set_size(_w, _h) {
    width = _w
    height = _h
    return self
}

function set_fade_height(_pixels) {
    fade_height = max(1, _pixels)
    return self
}

function set_dot_color(_color) {
    dot_color = _color
    return self
}

function set_draw_self(_enabled) {
    self.draw_self = _enabled
    visible = _enabled
    return self
}

function set_gl_frag_y_flip(_use_bottom_origin) {
    gl_frag_y_flip = _use_bottom_origin ? 1 : 0
    return self
}

function _shader_uniforms_ok() {
    return uni_gui != -1 && uni_origin != -1 && uni_gl_y_flip != -1 && uni_band_size != -1
        && uni_radius_min != -1 && uni_radius_max != -1 && uni_curve != -1
        && uni_direction != -1 && uni_rgb != -1
}

function _draw_band_shader(_left, _top, _w, _h, _direction) {
    var _sh = HalftoneShader
    if (!_shader_uniforms_ok() || !shader_is_compiled(_sh)) {
        return
    }

    shader_set(_sh)
    shader_set_uniform_f(uni_gui, display_get_gui_width(), display_get_gui_height())
    shader_set_uniform_f(uni_origin, _left, _top)
    shader_set_uniform_f(uni_gl_y_flip, gl_frag_y_flip)
    shader_set_uniform_f(uni_band_size, _w, _h)
    shader_set_uniform_f(uni_radius_min, radius_min)
    shader_set_uniform_f(uni_radius_max, radius_max)
    shader_set_uniform_f(uni_curve, curve_power)
    shader_set_uniform_f(uni_direction, clamp(_direction, 0, 3))

    var _cr = color_get_red(dot_color) / 255
    var _cg = color_get_green(dot_color) / 255
    var _cb = color_get_blue(dot_color) / 255
    shader_set_uniform_f(uni_rgb, _cr, _cg, _cb)

    draw_set_color(c_white)
    draw_set_alpha(1)
    draw_rectangle(_left, _top, _left + _w, _top + _h, false)

    shader_reset()
}

function on_draw_gui() {
    _draw_band_shader(offset_x, offset_y, width, height, direction)
}

function _on_draw_gui() {
    if (self.draw_self) {
        on_draw_gui()
    }
}