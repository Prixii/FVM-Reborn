/// 

function test_spatial_registry_suite() {
    show_debug_message("=== 开始运行 SpatialRegistry 单元测试 ===");
    
    var _registry = new SpatialRegistry();
    
    // 模拟数据 (假设你的 grid_id 计算逻辑已经通过 stove_utils 测试)
    var _mock_grid_id = 5; 
    var _change_ground = { grid_id: _mock_grid_id, layer: ENEMY_LAYER.GROUND, object: 10001 };
    var _change_air = { grid_id: _mock_grid_id, layer: ENEMY_LAYER.AIR, object: 10002 };

    // --- 测试用例 1: 初始状态 ---
    test_assert_equal(_registry.enemy_bitmap, int64(0), "初始位图应为 0");

    // --- 测试用例 2: 敌人进入 ---
    _registry.enter(_change_ground);
    test_assert_equal(_registry.enemy_count_in_grid[_mock_grid_id], 1, "网格计数应为 1");
    test_assert_equal(real(_registry.enemy_bitmap & (int64(1) << _mock_grid_id)) != 0, true, "位图对应位应被置 1");
    test_assert_equal(real(_registry.enemy_layer_bitmap & ENEMY_LAYER.GROUND) != 0, true, "层级位图应包含 GROUND");

    // --- 测试用例 3: 相同位置不同层级进入 ---
    _registry.enter(_change_air);
    test_assert_equal(_registry.enemy_count_in_grid[_mock_grid_id], 2, "网格计数应累加至 2");
    test_assert_equal(real(_registry.enemy_layer_bitmap & ENEMY_LAYER.AIR) != 0, true, "层级位图应包含 AIR");

    // --- 测试用例 4: 离开逻辑 (部分离开) ---
    _registry.leave(_change_ground);
    test_assert_equal(_registry.enemy_count_in_grid[_mock_grid_id], 1, "部分离开后计数应为 1");
    test_assert_equal(real(_registry.enemy_bitmap & (int64(1) << _mock_grid_id)) != 0, true, "位图位仍应保持开启");
    test_assert_equal(real(_registry.enemy_layer_bitmap & ENEMY_LAYER.GROUND) == 0, true, "GROUND 层级位图应已关闭");

    // --- 测试用例 5: 完全离开 ---
    _registry.leave(_change_air);
    test_assert_equal(_registry.enemy_count_in_grid[_mock_grid_id], 0, "全部离开后计数应为 0");
    test_assert_equal(_registry.enemy_bitmap, int64(0), "所有位图位应已复位");

    // --- 测试用例 6: 重置功能 ---
    _registry.enter(_change_ground);
    _registry.reset();
    test_assert_equal(_registry.enemy_bitmap, int64(0), "Reset 后位图应清空");
    test_assert_equal(array_length(_registry.enemies_in_grid[_mock_grid_id]), 0, "Reset 后列表应清空");

    show_debug_message("=== 测试运行结束 ===");
    game_end()
}

function SpatialRegistryDeepTest() constructor {
    self.registry = new SpatialRegistry();
    self.enemies = [];
    
    // 1. 初始化大量敌人
    static setup = function(_count = 1000) {
        self.registry.reset();
        self.enemies = array_create(_count);
        for (var i = 0; i < _count; i++) {
            var _e = {
                object: 200000 + i,
                grid_id: irandom(kMaxMapSize - 1),
                layer: choose(ENEMY_LAYER.GROUND, ENEMY_LAYER.AIR)
            };
            self.enemies[i] = _e;
            self.registry.enter(_e);
        }
        show_debug_message("--- 准备完毕: " + string(_count) + " 个敌人已入库 ---");
    }

    // 2. 模拟高频索敌 (Complex Search)
    static run_search_test = function(_search_count = 5000) {
        var _hits = 0;
        var _skipped = 0;
        var _t0 = get_timer();

        repeat(_search_count) {
            // 模拟一个覆盖 4 个随机网格的攻击掩码
            var _start_bit = irandom(kMaxMapSize - 5);
            var _area_mask = int64(0xF) << _start_bit; 
            var _target_layer = ENEMY_LAYER.GROUND;

            // 执行优化后的检测
            var _spatial_index = self.registry.should_attack(_area_mask, _target_layer);
            
            if (_spatial_index != 0) {
                // 如果位图报告有敌人，进入精细遍历逻辑
                _hits++;
                // 遍历被掩码覆盖的位
                for (var j = 0; j < 4; j++) {
                    var _idx = _start_bit + j;
                    var _list = self.registry.enemies_in_grid[_idx];
                    var _len = array_length(_list);
                    // 模拟实际的距离计算或伤害处理
                    for (var k = 0; k < _len; k++) {
                        var _inst = _list[k];
                        // 命中处理逻辑...
                    }
                }
            } else {
                _skipped++; // 位图成功跳过了无效运算
            }
        }

        var _t1 = get_timer();
        show_debug_message("--- 索敌测试完成 ---");
        show_debug_message("总索敌次数: " + string(_search_count));
        show_debug_message("位图拦截率: " + string((_skipped / _search_count) * 100) + "%");
        show_debug_message("总耗时: " + string(_t1 - _t0) + "us");
    }

    // 3. 模拟动态位移 (Dynamic Movement)
    // 模拟所有敌人随机移动到相邻网格，验证位图更新是否产生残留
    static run_movement_test = function() {
        show_debug_message("--- 开始模拟大规模移动 ---");
        for (var i = 0; i < array_length(self.enemies); i++) {
            var _e = self.enemies[i];
            self.registry.leave(_e);
            _e.grid_id = clamp(_e.grid_id + choose(-1, 1), 0, kMaxMapSize - 1);
            self.registry.enter(_e);
        }
        var _total_count = 0;
        for(var j=0; j<kMaxMapSize; j++) _total_count += self.registry.enemy_count_in_grid[j];
        test_assert_equal(self.enemies,_total_count, "移动一致性校验通过。")
    }
}