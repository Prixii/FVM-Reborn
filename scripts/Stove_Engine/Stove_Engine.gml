/// 

function Stove_Engine() constructor {
    self.test_mode = false
    self.is_ready = false
    /// @type {Struct.ASTChunk} 
    self.mod_cards = []
    static init = function() {
        show_debug_message("engine init")
        var _lua_manager_init_result = global.stove.lua_manager.init()
        if (_lua_manager_init_result.is_failed()) {
            throw( "lua manager init failed: " + _lua_manager_init_result.get_error_stack())
        }
        
    }

}

