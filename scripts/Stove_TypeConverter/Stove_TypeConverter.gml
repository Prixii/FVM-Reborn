/// Lua ↔ GML 桥接后的类型规范化（切面：callFunction / getLuaVariable 等到 GML 后的形态）
/// 注意：不能用 constructor 上的 static 做点访问（会报 Type does not allow dot accessors），故用 global struct 作模块

function stove_tc_unwrap_singleton_array(_v) {
    if (typeof(_v) == "array" && array_length(_v) == 1) {
        return _v[0];
    }
    return _v;
}

/// @param {String} _key
/// @returns {Real} 从 1 起的下标；无法解析则 -1
function stove_tc_parse_sequence_index(_key) {
    if (string_length(_key) >= 8 && string_copy(_key, 1, 7) == "Number_") {
        var _tail = string_delete(_key, 1, 7);
        if (string_length(_tail) < 1) {
            return -1;
        }
        for (var _i = 1; _i <= string_length(_tail); _i++) {
            var _c = string_ord_at(_tail, _i);
            if (_c < ord("0") || _c > ord("9")) {
                return -1;
            }
        }
        return real(_tail);
    }
    if (string_length(_key) < 1) {
        return -1;
    }
    for (var _j = 1; _j <= string_length(_key); _j++) {
        var _c2 = string_ord_at(_key, _j);
        if (_c2 < ord("0") || _c2 > ord("9")) {
            return -1;
        }
    }
    return real(_key);
}

/// 是否为由 Lua 序列表映射来的 struct：仅含 Number_1…Number_n 或 "1"…"n"，且连续无重复
function stove_tc_is_lua_sequence_struct(_s) {
    if (typeof(_s) != "struct") {
        return false;
    }
    var _names = variable_struct_get_names(_s);
    var _n = array_length(_names);
    if (_n == 0) {
        return false;
    }
    var _seen = {};
    var _max = 0;
    for (var _i = 0; _i < _n; _i++) {
        var _idx = stove_tc_parse_sequence_index(_names[_i]);
        if (_idx < 1) {
            return false;
        }
        var _sk = string(_idx);
        if (variable_struct_exists(_seen, _sk)) {
            return false;
        }
        variable_struct_set(_seen, _sk, true);
        _max = max(_max, _idx);
    }
    return _max == _n;
}

function stove_tc_lua_sequence_struct_to_array(_s) {
    var _names = variable_struct_get_names(_s);
    var _n = array_length(_names);
    var _arr = array_create(_n, undefined);
    for (var _i = 0; _i < _n; _i++) {
        var _idx = stove_tc_parse_sequence_index(_names[_i]);
        _arr[_idx - 1] = variable_struct_get(_s, _names[_i]);
    }
    return _arr;
}

/// 递归：序列表 struct → array；其它 struct 深拷贝并递归字段；array 递归元素
function stove_tc_normalize_from_lua_deep(_v) {
    var _t = typeof(_v);
    if (_t == "struct") {
        if (stove_tc_is_lua_sequence_struct(_v)) {
            var _seq = stove_tc_lua_sequence_struct_to_array(_v);
            var _len = array_length(_seq);
            for (var _i = 0; _i < _len; _i++) {
                _seq[_i] = stove_tc_normalize_from_lua_deep(_seq[_i]);
            }
            return _seq;
        }
        var _names = variable_struct_get_names(_v);
        var _out = {};
        for (var _j = 0; _j < array_length(_names); _j++) {
            var _kn = _names[_j];
            variable_struct_set(_out, _kn, stove_tc_normalize_from_lua_deep(variable_struct_get(_v, _kn)));
        }
        return _out;
    }
    if (_t == "array") {
        var _alen = array_length(_v);
        var _outa = array_create(_alen, undefined);
        for (var _k = 0; _k < _alen; _k++) {
            _outa[_k] = stove_tc_normalize_from_lua_deep(_v[_k]);
        }
        return _outa;
    }
    return _v;
}

/// 单元素 array 剥壳 + 深度序列表→数组（Lua→GML 默认入口）
function stove_tc_normalize_from_lua(_v) {
    return stove_tc_normalize_from_lua_deep(stove_tc_unwrap_singleton_array(_v));
}

function stove_tc_call_function_normalized(_lua_fn, _args) {
    return stove_tc_normalize_from_lua(callFunction(_lua_fn, _args));
}

function stove_tc_seq_get(_v, _i) {
    var _t = typeof(_v);
    if (_t == "array") {
        if (_i < 0 || _i >= array_length(_v)) {
            return undefined;
        }
        return _v[_i];
    }
    if (_t == "struct") {
        var _nk = "Number_" + string(_i + 1);
        if (variable_struct_exists(_v, _nk)) {
            return variable_struct_get(_v, _nk);
        }
        var _sk = string(_i + 1);
        if (variable_struct_exists(_v, _sk)) {
            return variable_struct_get(_v, _sk);
        }
    }
    return undefined;
}

function stove_tc_struct_get_safe(_s, _key) {
    if (typeof(_s) != "struct") {
        return undefined;
    }
    if (!variable_struct_exists(_s, _key)) {
        return undefined;
    }
    return variable_struct_get(_s, _key);
}

function stove_tc_child_at(_parent, _i) {
    return stove_tc_normalize_from_lua(stove_tc_seq_get(_parent, _i));
}

global.stove_type_converter = {
    unwrap_singleton_array: method(undefined, stove_tc_unwrap_singleton_array),
    normalize_from_lua: method(undefined, stove_tc_normalize_from_lua),
    normalize_from_lua_deep: method(undefined, stove_tc_normalize_from_lua_deep),
    is_lua_sequence_struct: method(undefined, stove_tc_is_lua_sequence_struct),
    call_function_normalized: method(undefined, stove_tc_call_function_normalized),
    seq_get: method(undefined, stove_tc_seq_get),
    struct_get_safe: method(undefined, stove_tc_struct_get_safe),
    child_at: method(undefined, stove_tc_child_at),
};

/// 自动转换从 Lua 经桥接进入 GML 的值（单元素 array 剥壳 + 深度序列表→array）
/// @param {Any} _v
/// @returns {Any}
function LuaType(_v) {
    return global.stove_type_converter.normalize_from_lua(_v);
}

/// 占位构造函数：与其它 Stove_* 命名一致（无实例状态）
function Stove_TypeConverter() constructor {
}
