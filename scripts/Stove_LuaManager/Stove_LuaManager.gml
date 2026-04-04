/// 


function stove_global_test() {
    show_debug_message("stove_global_test")
    return 114
}

global.function_export_to_lua = {
    "stove_global_test" : stove_global_test,
};

function Stove_LuaManager() constructor {
    self.mod_engine_scope = new Scope()

    self.ast_map = {}
    self.variable_map = {}

    self.default_function_whitelist = [
        "stove_global_test",
        "irandom"
    ]

    static init = function() {
        show_debug_message("function index: " + string(asset_get_index("stove_global_test")));
        setFunctionNameList(default_function_whitelist, true)
        setGMLVariable(self.mod_engine_scope, "stove_lua_scope", self)
    }

    /// @param {String} _path 
    /// @param {Struct.ASTChunk} _ast 
    static _add_ast = function(_path, _ast) {
        self.ast_map[$ _path] = _ast
    }

    static _ast_exists = function(_path) {
        return !is_undefined(self.ast_map[$ _path])
    }

    /// @param {String} _path
    /// @param {String} _function_name
    /// @returns {Any|Undefined}
    static get_lua_variable = function(_path, _function_name) {
        var _ast = self.get_ast(_path)
        if (is_undefined(_ast)) {
            return undefined
        }

        return getLuaVariable(mod_engine_scope, _function_name)
    }

    
    /// @param {String} _path
    /// @param {String} _function_name
    /// @returns {Struct.Result} 
    static run_lua_function = function(_path, _function_name) {
        var _ast = self.get_ast(_path)
        if (is_undefined(_ast)) {
            return new Result().fail(STOVE_ERROR.CALL_LUA_FAILED, "Failed to find lua: " + _path)
        }
        var _func = getLuaVariable(mod_engine_scope, _function_name)
        if (is_undefined(_func)) {
            return new Result().fail(STOVE_ERROR.CALL_LUA_FAILED, "Failed to find lua function: " + _function_name)
        }
        _func()
        return new Result().success()
        
    }
    
    /// @param {String} _path 
    /// @returns {Struct.ASTChunk|Undefined} 
    static get_ast = function(_path) {
        return self.ast_map[$ _path]
    }

    /// @param {String} _path 
    /// @returns {Struct.Result}
    static load_lua = function(_path) {
        try {
            if (_ast_exists(_path)) {
                return new Result().success()
            }
            var _ast = createLuaFromFile(_path, false)
            runLua(_ast, self.mod_engine_scope)
            _add_ast(_path, _ast)
            return new Result().success()
        } catch (e) {
            return new Result().fail(STOVE_ERROR.LOAD_LUA_FAILED, "Failed to load lua: " + string(e))
        }
    }
    
}