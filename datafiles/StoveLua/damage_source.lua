--- 伤害源：负责检测时机并创建 `DamageMedia`（草稿：`should_emit` + `build_media` 两钩子）。
-- 依赖全局 `Damage`、`DamageMedia`（加载顺序：`damage.lua` → `damage_media.lua` → 本文件）。
-- @module damage_source

DamageSource = {}

--- 创建伤害源配置表。
-- @tparam table opts
-- @tparam[opt] function opts.should_emit 签名为 `function(source, context) return boolean`，默认恒为 true
-- @tparam function opts.build_media 签名为 `function(source, context) return table|nil`，应返回 `DamageMedia.New(...)` 或 nil
-- @tparam[opt] table opts.user 自定义字段，会原样挂在 `source.user` 上
-- @treturn table source
function DamageSource.New(opts)
    opts = opts or {}
    assert(type(opts.build_media) == "function", "DamageSource.New: opts.build_media is required")

    local source = {
        should_emit = opts.should_emit,
        build_media = opts.build_media,
        user = opts.user or {},
    }

    if source.should_emit == nil then
        function source.should_emit(_, _)
            return true
        end
    end

    return source
end

--- 若 `should_emit` 通过，则 `build_media` 生成载体；否则返回 nil。
-- @tparam table source `DamageSource.New` 的返回值
-- @tparam table context 任意上下文字段（位置、索敌结果等）
-- @treturn table|nil media
function DamageSource.TryEmit(source, context)
    if not source.should_emit(source, context) then
        return nil
    end
    return source.build_media(source, context)
end
