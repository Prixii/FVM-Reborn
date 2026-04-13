#ifdef GL_ES
precision mediump float;
#endif

//
// u_direction：渐变方向（洞半径随「沿该轴在条带内的位置」变化）
//   0 = 向下（+Y）：条带顶 y=0 洞小，底 y=h 洞大
//   1 = 向上（-Y）：顶洞大，底洞小
//   2 = 向右（+X）：左 x=0 洞小，右 x=w 洞大
//   3 = 向左（-X）：左洞大，右洞小
//

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_gui;
uniform vec2 u_origin;
uniform vec2 u_band_size;
uniform float u_gl_y_flip;
uniform float u_radius_min;
uniform float u_radius_max;
uniform float u_curve;
uniform float u_direction;
uniform vec3 u_rgb;

void main()
{
    vec2 frag_coord = gl_FragCoord.xy;
    float y_gui = mix(frag_coord.y, u_gui.y - frag_coord.y, u_gl_y_flip);
    vec2 gui = vec2(frag_coord.x, y_gui);
    vec2 p = gui - u_origin;

    vec2 size = vec2(max(u_band_size.x, 0.0001), max(u_band_size.y, 0.0001));
    vec2 p_cell = clamp(p, vec2(0.0), size);

    vec2 gv = floor(p_cell / u_radius_max);
    vec2 cell_center = gv * u_radius_max + vec2(0.5 * u_radius_max);

    float dist = distance(p_cell, cell_center);

    float py_n = clamp(p.y, 0.0, size.y);
    float px_n = clamp(p.x, 0.0, size.x);

    float grad_t;
    if (u_direction < 0.5) {
        grad_t = py_n / size.y;
    } else if (u_direction < 1.5) {
        grad_t = 1.0 - py_n / size.y;
    } else if (u_direction < 2.5) {
        grad_t = px_n / size.x;
    } else {
        grad_t = 1.0 - px_n / size.x;
    }

    grad_t = clamp(grad_t, 0.0, 1.0);
    grad_t = pow(grad_t, 1.0 / max(u_curve, 0.05));
    float r = mix(u_radius_min, u_radius_max, grad_t);

    float af_width = fwidth(dist);
    float mask = smoothstep(r - af_width, r + af_width, dist);

    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(u_rgb * tex.rgb, tex.a * mask) * v_vColour;
}
