/// 
function Stove_StageManagerUtils() constructor {

    /// @param {Struct.Stove_Asset|Undefined} _asset 
    /// @returns {Real}  asset index, or -1
    static asset_to_game_index = function(_asset) {
        if (!is_struct(_asset)) {
            return -1
        }
        if (_asset.source == ASSET_SOURCE.EXTERNAL) {
            return -1
        }
        if (_asset.gml_asset_name == undefined) {
            return -1
        }
        var n = _asset.gml_asset_name
        if (is_string(n)) {
            return asset_get_index(n)
        }
        if (is_real(n)) {
            var _spr = stove_original_sprite_from_enum(n)
            if (_spr != -1) {
                return _spr
            }
            var _snd = stove_original_music_from_enum(n)
            if (_snd != -1) {
                return _snd
            }
        }
        return -1
    }

    /// @param {Struct.Stove_StageMetadata} _meta 
    /// @param {Real} _button_index 
    /// @returns {Struct}  One entry compatible with global.maps_map levels_data (see maps_init)
    static level_entry_from_stage_metadata = function(_meta, _button_index) {
        var lf = string_replace_all(string(_meta.json_path), "\\", "/")
        var hf = lf
        var spr_ix = asset_to_game_index(_meta.background)
        if (spr_ix == -1) {
            spr_ix = spr_cookie_island
        }
        var pre_ix = asset_to_game_index(_meta.pre_music)
        if (pre_ix == -1) {
            pre_ix = mus_readyroom
        }
        var elite_ix = asset_to_game_index(_meta.elite_music)
        if (elite_ix == -1) {
            elite_ix = pre_ix
        }
        var boss_ix = asset_to_game_index(_meta.boss_music)
        if (boss_ix == -1) {
            boss_ix = pre_ix
        }
        var bx = 200 + (_button_index mod 5) * 140
        var by = 280 + (_button_index div 5) * 100
        return {
            id: _meta.id,
            name: _meta.name,
            button_spr: spr_levelselect_button,
            button_index: _button_index,
            button_x: bx,
            button_y: by,
            level_file: lf,
            hard_level_file: hf,
            level_sprite: spr_ix,
            pre_music: pre_ix,
            elite_music: elite_ix,
            boss_music: boss_ix,
            player_level_require: 1,
            pre_level_require: []
        }
    }

    /// @param {Array<String>} _ids 
    static sort_string_ids_asc = function(_ids) {
        var n = array_length(_ids)
        for (var a = 0; a < n - 1; a++) {
            for (var b = 0; b < n - 1 - a; b++) {
                if (_ids[b] > _ids[b + 1]) {
                    var t = _ids[b]
                    _ids[b] = _ids[b + 1]
                    _ids[b + 1] = t
                }
            }
        }
    }
}
