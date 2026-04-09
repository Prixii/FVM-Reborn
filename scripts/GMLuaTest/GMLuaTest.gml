/// Lua getgmlfunction 白名单：将第一个参数原样返回（用于 Lua→GML→Lua 校验）
function gmlua_test_identity(_v) {
    return _v;
}

function _gmlua_test_prepare_lua_whitelist() {
    global.function_export_to_lua[$ "gmlua_test_identity"] = method(undefined, gmlua_test_identity);
    // 与 Stove_LuaManager.default_function_whitelist 保持同步，并追加测试用导出函数
    setFunctionNameList([
        "register_food_from_json",
        "stove_global_test",
        "gmlua_test_identity",
    ], true);
}

/// GML ↔ Lua 互传测试：Lua→GML 规范化见 global.stove_type_converter / LuaType()
/// 每种数据类型单独 try；类型内部每一步再各包 try/catch
function gmlua_test() {
    show_debug_message("------------ GMLua 互传测试 Start ------------");
    try {
        _gmlua_test_prepare_lua_whitelist();
    } catch (_ew) {
        show_debug_message("[⛔]GMLua「准备白名单」" + string(_ew));
    }

    var _lm = global.stove.lua_manager;

    try {
        var _load = _lm.load_lua("mods/test.lua");
        try {
            test_assert_equal(_load.is_succeed(), true, "GMLua[加载]: mods/test.lua", false);
        } catch (_ea) {
            show_debug_message("[⛔]GMLua[加载] 断言 " + string(_ea));
        }
    } catch (_e_load) {
        show_debug_message("[⛔]GMLua[加载] " + string(_e_load));
        show_debug_message("------------ GMLua 互传测试 End -------------");
        return;
    }

    var _scope = _lm.mod_engine_scope;
    var _Test = undefined;
    try {
        _Test = getLuaVariable(_scope, "Test");
        try {
            test_assert_equal(typeof(_Test), "struct", "GMLua[全局Test]: 类型为 struct", false);
        } catch (_eb) {
            show_debug_message("[⛔]GMLua[全局Test] 断言 " + string(_eb));
        }
    } catch (_e_test) {
        show_debug_message("[⛔]GMLua[全局Test] " + string(_e_test));
        show_debug_message("------------ GMLua 互传测试 End -------------");
        return;
    }

    // ---------- 原始类型 ----------
    try {
        var _echo_prim = variable_struct_get(_Test, "EchoPrimitives");
        var _prets = callFunction(_echo_prim, [42, "hello", true, undefined]);
        try {
            test_assert_equal(array_length(_prets), 4, "GMLua[原始类型]: 返回值个数", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[原始类型] 个数 " + string(_e));
        }
        try {
            test_assert_equal(_prets[0], 42, "GMLua[原始类型]: number", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[原始类型] number " + string(_e));
        }
        try {
            test_assert_equal(_prets[1], "hello", "GMLua[原始类型]: string", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[原始类型] string " + string(_e));
        }
        try {
            test_assert_equal(_prets[2], true, "GMLua[原始类型]: bool", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[原始类型] bool " + string(_e));
        }
        try {
            test_assert_equal(_prets[3], undefined, "GMLua[原始类型]: undefined/nil", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[原始类型] undefined " + string(_e));
        }
    } catch (_e) {
        show_debug_message("[⛔]GMLua[原始类型] 整段 " + string(_e));
    }

    // ---------- GML array → Lua ----------
    try {
        var _echo_arr = variable_struct_get(_Test, "EchoGmlArrayAsTable");
        var _ar = [7, 8, 9];
        var _aret = callFunction(_echo_arr, [_ar]);
        try {
            test_assert_equal(array_length(_aret), 3, "GMLua[GML数组]: 回传个数", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[GML数组] 个数 " + string(_e));
        }
        try {
            test_assert_equal(_aret[0], 7, "GMLua[GML数组]: [0]", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[GML数组] [0] " + string(_e));
        }
        try {
            test_assert_equal(_aret[1], 8, "GMLua[GML数组]: [1]", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[GML数组] [1] " + string(_e));
        }
        try {
            test_assert_equal(_aret[2], 9, "GMLua[GML数组]: [2]", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[GML数组] [2] " + string(_e));
        }
    } catch (_e) {
        show_debug_message("[⛔]GMLua[GML数组] 整段 " + string(_e));
    }

    // ---------- Lua 序列表 → GML（array 或 struct）----------
    try {
        var _build_num = variable_struct_get(_Test, "BuildNumericTableReturn");
        var _num_tbl = LuaType(callFunction(_build_num, []));
        try {
            test_assert_equal(global.stove_type_converter.seq_get(_num_tbl, 0), 100, "GMLua[Lua序列表]: 第1元素", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[Lua序列表] 元素0 " + string(_e));
        }
        try {
            test_assert_equal(global.stove_type_converter.seq_get(_num_tbl, 1), 200, "GMLua[Lua序列表]: 第2元素", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[Lua序列表] 元素1 " + string(_e));
        }
        try {
            test_assert_equal(global.stove_type_converter.seq_get(_num_tbl, 2), 300, "GMLua[Lua序列表]: 第3元素", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[Lua序列表] 元素2 " + string(_e));
        }
    } catch (_e) {
        show_debug_message("[⛔]GMLua[Lua序列表] 整段 " + string(_e));
    }

    // ---------- struct / 类 map ----------
    try {
        var _echo_struct = variable_struct_get(_Test, "EchoStruct");
        var _map = {
            alpha: 1,
            beta: "zeta",
        };
        var _map_back = LuaType(callFunction(_echo_struct, [_map]));
        try {
            test_assert_equal(global.stove_type_converter.struct_get_safe(_map_back, "alpha"), 1, "GMLua[map]: alpha", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[map] alpha " + string(_e));
        }
        try {
            test_assert_equal(global.stove_type_converter.struct_get_safe(_map_back, "beta"), "zeta", "GMLua[map]: beta", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[map] beta " + string(_e));
        }
    } catch (_e) {
        show_debug_message("[⛔]GMLua[map] 整段 " + string(_e));
    }

    // ---------- 简单结构体 ----------
    try {
        var _echo_point = variable_struct_get(_Test, "EchoPoint");
        var _pt = { x: 3.5, y: -1.25 };
        var _pt_back = LuaType(callFunction(_echo_point, [_pt]));
        try {
            test_assert_equal(global.stove_type_converter.struct_get_safe(_pt_back, "x"), 3.5, "GMLua[简单结构]: x", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[简单结构] x " + string(_e));
        }
        try {
            test_assert_equal(global.stove_type_converter.struct_get_safe(_pt_back, "y"), -1.25, "GMLua[简单结构]: y", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[简单结构] y " + string(_e));
        }
    } catch (_e) {
        show_debug_message("[⛔]GMLua[简单结构] 整段 " + string(_e));
    }

    // ---------- 复杂结构体 ----------
    try {
        var _echo_cx = variable_struct_get(_Test, "EchoComplex");
        var _inner_a = { tag: "a", v: 10 };
        var _inner_b = { tag: "b", v: 20 };
        var _cx = {
            id: "cx1",
            nested: { flag: false, depth: 2 },
            list: [_inner_a, _inner_b],
        };
        var _cx_back = LuaType(callFunction(_echo_cx, [_cx]));
        try {
            test_assert_equal(global.stove_type_converter.struct_get_safe(_cx_back, "id"), "cx1", "GMLua[复杂]: id", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[复杂] id " + string(_e));
        }

        var _nested = undefined;
        try {
            _nested = global.stove_type_converter.struct_get_safe(_cx_back, "nested");
        } catch (_e) {
            show_debug_message("[⛔]GMLua[复杂] 取 nested " + string(_e));
        }
        if (!is_undefined(_nested)) {
            try {
                test_assert_equal(global.stove_type_converter.struct_get_safe(_nested, "flag"), false, "GMLua[复杂]: nested.flag", false);
            } catch (_e) {
                show_debug_message("[⛔]GMLua[复杂] nested.flag " + string(_e));
            }
            try {
                test_assert_equal(global.stove_type_converter.struct_get_safe(_nested, "depth"), 2, "GMLua[复杂]: nested.depth", false);
            } catch (_e) {
                show_debug_message("[⛔]GMLua[复杂] nested.depth " + string(_e));
            }
        }

        var _list = undefined;
        try {
            _list = global.stove_type_converter.struct_get_safe(_cx_back, "list");
        } catch (_e) {
            show_debug_message("[⛔]GMLua[复杂] 取 list " + string(_e));
        }
        if (!is_undefined(_list)) {
            var _li1 = undefined;
            try {
                _li1 = global.stove_type_converter.child_at(_list, 0);
            } catch (_e) {
                show_debug_message("[⛔]GMLua[复杂] list[0] " + string(_e));
            }
            if (!is_undefined(_li1)) {
                try {
                    test_assert_equal(global.stove_type_converter.struct_get_safe(_li1, "tag"), "a", "GMLua[复杂]: list[0].tag", false);
                } catch (_e) {
                    show_debug_message("[⛔]GMLua[复杂] list[0].tag " + string(_e));
                }
                try {
                    test_assert_equal(global.stove_type_converter.struct_get_safe(_li1, "v"), 10, "GMLua[复杂]: list[0].v", false);
                } catch (_e) {
                    show_debug_message("[⛔]GMLua[复杂] list[0].v " + string(_e));
                }
            }
            var _li2 = undefined;
            try {
                _li2 = global.stove_type_converter.child_at(_list, 1);
            } catch (_e) {
                show_debug_message("[⛔]GMLua[复杂] list[1] " + string(_e));
            }
            if (!is_undefined(_li2)) {
                try {
                    test_assert_equal(global.stove_type_converter.struct_get_safe(_li2, "tag"), "b", "GMLua[复杂]: list[1].tag", false);
                } catch (_e) {
                    show_debug_message("[⛔]GMLua[复杂] list[1].tag " + string(_e));
                }
            }
        }
    } catch (_e) {
        show_debug_message("[⛔]GMLua[复杂] 整段 " + string(_e));
    }

    // ---------- 引用修改 ----------
    try {
        var _mut = variable_struct_get(_Test, "MutatePassedStruct");
        var _host = { before: "keep" };
        callFunction(_mut, [_host]);
        try {
            test_assert_equal(global.stove_type_converter.struct_get_safe(_host, "before"), "keep", "GMLua[引用]: before", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[引用] before " + string(_e));
        }
        try {
            test_assert_equal(global.stove_type_converter.struct_get_safe(_host, "mutated"), true, "GMLua[引用]: mutated", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[引用] mutated " + string(_e));
        }
        try {
            test_assert_equal(global.stove_type_converter.struct_get_safe(_host, "extra"), 42, "GMLua[引用]: extra", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[引用] extra " + string(_e));
        }
    } catch (_e) {
        show_debug_message("[⛔]GMLua[引用] 整段 " + string(_e));
    }

    // ---------- Lua → GML 回调 ----------
    try {
        var _call_id = variable_struct_get(_Test, "CallGmlIdentity");
        var _round = { k: 5, s: "lua→gml→lua" };
        var _round_back = LuaType(callFunction(_call_id, [_round]));
        try {
            test_assert_equal(typeof(_round_back), "struct", "GMLua[回调]: 返回 struct", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[回调] 类型断言 " + string(_e));
        }
        try {
            test_assert_equal(global.stove_type_converter.struct_get_safe(_round_back, "k"), 5, "GMLua[回调]: k", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[回调] k " + string(_e));
        }
        try {
            test_assert_equal(global.stove_type_converter.struct_get_safe(_round_back, "s"), "lua→gml→lua", "GMLua[回调]: s", false);
        } catch (_e) {
            show_debug_message("[⛔]GMLua[回调] s " + string(_e));
        }
    } catch (_e) {
        show_debug_message("[⛔]GMLua[回调] 整段 " + string(_e));
    }

    show_debug_message("------------ GMLua 互传测试 End -------------");
}
