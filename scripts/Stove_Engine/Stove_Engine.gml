/// 

function Stove_Engine() constructor {
    self.is_ready = false
    /// @type {Struct.ASTChunk} 
    self.mod_cards = []

    static init = function() {
        show_debug_message("engine init")
        global.stove.lua_manager.init()
        
    }

}

