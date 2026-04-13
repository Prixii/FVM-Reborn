/// 


function State() constructor {
    current_stage_id = 0
    /// @type {Asset.GMObject.SpriteDrawer} 
    sprite_drawer = noone
    /// @type {Asset.GMObject.Halftone} 
    drawer_halftone = noone
}
self.state = new State()

/// @type {Array<String>} 
self.stage_ids = []
self.stages = {}

function on_create() {
    global.menu_screen = false

    /// @type {Struct.Stove_StageManager} 
    var _mgr = global.stove.stage_manager
    self.stage_ids = _mgr.get_registered_stage_ids_sorted()
    for (var _i = 0; _i < array_length(self.stage_ids); _i++) {
        var _id = self.stage_ids[_i]
        var _data = _mgr.get_stage_data(_id)
        if (!is_struct(_data)) {
            var _meta = _mgr.get_stage_metadata(_id)
            if (is_struct(_meta)) {
                _mgr.factory.load_stage_metadata_assets(_meta)
                _data = _mgr.util.level_entry_from_stage_metadata(_meta, _i)
            }
        }
        if (is_struct(_data)) {
            variable_struct_set(self.stages, string(_id), _data)
        }
    }

    self.state.sprite_drawer = create_sprite_drawer()
    create_back_button()
    create_start_button()
    create_scrollable()
}


function create_back_button() {
    /// @type {Asset.GMObject.SelectableButton} 
    var _back_button = instance_create_layer(0, 0,"Instances", SelectableButton)
    _back_button.set_position(20, 20)
        .set_size(160, 30)
        .set_text("<BACK")
        .set_on_click(function() {
            global.menu_screen = true
            room_goto(room_menu)
        })
}

function start_stage() {
    var _manager = global.stove.stage_manager
    var prep_init = _manager.prepare_playable_level_from_registered_stage_index(state.current_stage_id)
    global.map_id = "stove_mod"
    global.map_name = "这是 MOD 关卡"
    room_goto(room_ready)
}

function create_start_button() {
    /// @type {Asset.GMObject.SelectableButton} 
    var _id_3 = instance_create_layer(0, 0,"Instances", SelectableButton)
    _id_3.set_position(room_width - 210, room_height - 70)
        .set_size(200, 60)
        .set_text("START")
        .set_on_click(method({state: state}, start_stage))
        
}

function build_stage_list() {
    var _list = []
    for (var _i = 0; _i < array_length(self.stage_ids); _i++) {
        /// @type {Asset.GMObject.SelectableButton} 
        var _row = instance_create_layer(0, 0, "Instances", SelectableButton)
        var _id = self.stage_ids[_i]
        /// @type {Struct.Stove_StageData} 
        var _stage = variable_struct_get(self.stages, string(_id))
        _row.set_size(400, 56)
            .set_text(is_struct(_stage) ? _stage.name : string(_id))
            .set_auto_draw(false)
            .set_on_click(method({idx: _i, state: state, list: _list}, function() {
                if (state.current_stage_id == idx) {
                    return
                }
                list[state.current_stage_id].select(false)
                state.current_stage_id = idx
                list[state.current_stage_id].select(true)
            }))
        array_push(_list, _row)
    }
    if (array_length(_list) > 0) {
        _list[0].select(true)
        state.current_stage_id = 0
    }
    return _list
}

function create_scrollable() {
    /// @type {Asset.GMObject.Scrollable} 
    var _scroll = instance_create_layer(0, 0, "Instances", Scrollable)
    _scroll.set_viewport(20, 70, 400, display_get_gui_height() - 100)
        .set_item_spacing(6)
        .set_padding(0, 40, 40)
        .set_wheel_step(36)
        .init()

    _scroll.set_items(build_stage_list())
    
    return _scroll
}

function create_sprite_drawer() {
    /// @type {Asset.GMObject.SpriteDrawer} 
    var _sprite_drawer = instance_create_layer(0, 0, "Instances", SpriteDrawer)
    _sprite_drawer.set_room_size(room_width, room_height)
        .set_offset(440, 0)
    /// @type {Asset.GMObject.Halftone} 
    var _drawer_mask = instance_create_layer(0, 0, "Instances", Halftone)
    _drawer_mask.set_position(440, 0)
        .set_size(120, display_get_gui_height())
        .set_direction(2)
        .set_dot_color(c_black)
        .set_draw_self(true)
        .set_radius_max(8)
    self.state.drawer_halftone = _drawer_mask
    return _sprite_drawer
}

function on_step() {
    if (array_length(self.stage_ids) <= 0) {
        return
    }
    var _sid = self.stage_ids[state.current_stage_id]
    var _st = variable_struct_get(self.stages, string(_sid))
    if (!is_struct(_st)) {
        return
    }
    self.state.sprite_drawer.set_sprite(_st.level_sprite)
}

function on_draw_gui() {
    if (array_length(self.stage_ids) <= 0) {
        return
    }
    var _sid = self.stage_ids[state.current_stage_id]
    var _st = variable_struct_get(self.stages, string(_sid))
    if (!is_struct(_st)) {
        return
    }
    var _title = _st.name
    draw_set_font(-1)
    draw_text_transformed(520, 20, _title, 2.2, 2.2, 0)
}


on_create()