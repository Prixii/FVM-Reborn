/// Stove StageManager：枚举与路径工具；关卡 JSON 由模组在 RegisterModStage 流程中加载，此处只校验是否已有注册结果。
/// 须在 maps_init 之后、且 mod_manager_test（run_all_mods）之后调用。
function stage_manager_test() {
    var _sm = global.stove.stage_manager
    var _fu = global.stove.file_utils
    var _logger = global.stove.logger

    test_assert_equal(stove_original_sprite_from_enum(ORIGINAL_SPRITE.COOKIE_ISLAND), spr_cookie_island, "stove_original_sprite_from_enum: COOKIE_ISLAND", false)
    test_assert_equal(stove_original_sprite_from_enum(99999), -1, "stove_original_sprite_from_enum: unknown → -1", false)
    test_assert_equal(stove_original_music_from_enum(ORIGINAL_MUSIC.DELICIOUS_TOWER_PRE), mus_delicious_tower_pre, "stove_original_music_from_enum: DELICIOUS_TOWER_PRE", false)
    test_assert_equal(stove_original_music_from_enum(99999), -1, "stove_original_music_from_enum: unknown → -1", false)

    var _bg_name = new Stove_Asset()
    _bg_name.gml_asset_name = "spr_pudding_island_night"
    test_assert_equal(_sm.util.asset_to_game_index(_bg_name), spr_pudding_island_night, "asset_to_game_index: gml_asset_name 为资源名字符串", false)

    test_assert_equal(_fu.resolve_level_data_buffer_path("cookie_island.json", "cookie_island_hard.json", false), "level_data/cookie_island.json", "resolve_level_data_buffer_path: normal", false)
    test_assert_equal(_fu.resolve_level_data_buffer_path("cookie_island.json", "cookie_island_hard.json", true), "level_data/cookie_island_hard.json", "resolve_level_data_buffer_path: hard", false)

    var _ids = variable_struct_get_names(_sm._stage_metadatas)
    var _n = array_length(_ids)
    if (_n <= 0) {
        _logger.log_w("stage_manager_test: _stage_metadatas 为空，请确认模组入口已调用 Stove.RegisterModStage")
        test_assert_equal(false, true, "应至少存在 1 条由模组注册的关卡元数据", false)
        return
    }

    _sm.util.sort_string_ids_asc(_ids)
    var _meta = variable_struct_get(_sm._stage_metadatas, _ids[0])
    test_assert_equal(string(_meta.id) != "", true, "关卡元数据 id 非空", false)
    test_assert_equal(string_length(string(_meta.json_path)) > 0, true, "关卡元数据 jsonPath 非空", false)

    var _entry = _sm.util.level_entry_from_stage_metadata(_meta, 0)
    test_assert_equal(_entry.id, _meta.id, "level_entry_from_stage_metadata: id", false)
    var _lf = string_replace_all(string(_meta.json_path), "\\", "/")
    test_assert_equal(_entry.level_file, _lf, "level_entry_from_stage_metadata: level_file", false)

    var _prep = _sm.prepare_playable_level_from_registered_stage(_ids[0], 0)
    test_assert_equal(_prep.is_succeed(), true, "prepare_playable_level_from_registered_stage 成功", false)
    test_assert_equal(string(global.level_id), string(_meta.id), "prepare 后 global.level_id", false)
    test_assert_equal(is_struct(global.level_file), true, "prepare 后 global.level_file 为 struct", false)
}
