--- 伤害载体：由 Kinematic（此处为简单 vx,vy 积分）运动，并在时机成熟时把 `Damage` 交给目标；可登记子载体。
-- 依赖全局 `Damage`（见 `damage.lua`）。
-- @module damage_media

DamageMedia = {}

local function shallow_copy_pending(list)
    local out = {}
    for i = 1, #list do
        out[i] = list[i]
    end
    return out
end

--- 创建一个伤害载体实例（草稿：平面运动 + 可选存活时间 + 待生成子载体队列）。
-- @tparam table opts
-- @tparam table opts.damage 必填，`Damage.New` 的返回值
-- @tparam[opt] number opts.x 初始 x，默认 0
-- @tparam[opt] number opts.y 初始 y，默认 0
-- @tparam[opt] number opts.vx 水平速度，默认 0
-- @tparam[opt] number opts.vy 垂直速度，默认 0
-- @tparam[opt] number opts.lifetime 存活秒数，`nil` 表示不自动销毁
-- @tparam[opt] function opts.should_apply 签名为 `function(media, target) return boolean`，默认恒为 true
-- @treturn table media
function DamageMedia.New(opts)
    opts = opts or {}
    assert(opts.damage ~= nil, "DamageMedia.New: opts.damage is required")

    local media = {
        x = opts.x or 0,
        y = opts.y or 0,
        vx = opts.vx or 0,
        vy = opts.vy or 0,
        damage = opts.damage,
        lifetime = opts.lifetime,
        age = 0,
        dead = false,
        should_apply = opts.should_apply,
        _pending_children = {},
    }

    if media.should_apply == nil then
        function media.should_apply(_, _)
            return true
        end
    end

    return media
end

--- 简单运动积分（草稿 Kinematic）。
-- @tparam table media `DamageMedia.New` 的返回值
-- @tparam number dt 秒
function DamageMedia.Step(media, dt)
    if media.dead then
        return
    end
    media.x = media.x + media.vx * dt
    media.y = media.y + media.vy * dt
    media.age = media.age + dt
    if media.lifetime ~= nil and media.age >= media.lifetime then
        media.dead = true
    end
end

--- 对单个目标尝试结算伤害（草稿：不修改 `media.damage`，由游戏层读取数值）。
-- @tparam table media
-- @tparam table target 任意表，需有 `TakeDamage` 时可在回调里接 `Damage`
-- @treturn boolean applied 是否认为已应用（用于子类/连段去重时可扩展）
function DamageMedia.ApplyToTarget(media, target)
    if media.dead then
        return false
    end
    if not media.should_apply(media, target) then
        return false
    end
    if type(target.TakeDamage) == "function" then
        target.TakeDamage(media.damage, media)
    end
    return true
end

--- 登记一个子载体，通常在 `Step` 或命中逻辑里调用，由外层统一 `FlushPendingChildren` 入库。
-- @tparam table parent
-- @tparam table child `DamageMedia.New` 的返回值
function DamageMedia.QueueChild(parent, child)
    table.insert(parent._pending_children, child)
end

--- 取出并清空 `parent` 上排队的子载体（浅拷贝列表）。
-- @tparam table parent
-- @treturn table children
function DamageMedia.FlushPendingChildren(parent)
    local list = shallow_copy_pending(parent._pending_children)
    parent._pending_children = {}
    return list
end
