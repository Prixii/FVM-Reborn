--- 伤害纯数据：攻击力与标签等，不包含运动或检测逻辑。
-- @module damage

Damage = {}

--- 新建一份伤害数据（调用方应避免在共享实例上原地改表，需要时用 `Damage.Copy`）。
-- @tparam number attack 基础伤害值
-- @tparam[opt] table tags 标签表，如 `{ fire = true, physical = true }`
-- @tparam[opt] table attribution 归属信息占位，如 `{ owner_id = 1, skill_id = "pea" }`
-- @treturn table damage
function Damage.New(attack, tags, attribution)
    return {
        attack = attack or 0,
        tags = tags or {},
        attribution = attribution or {},
    }
end

--- 浅拷贝伤害数据（含 `tags`、`attribution` 的浅拷贝）。
-- @tparam table d `Damage.New` 返回的表
-- @treturn table copy
function Damage.Copy(d)
    local tags = {}
    for k, v in pairs(d.tags or {}) do
        tags[k] = v
    end
    local attribution = {}
    for k, v in pairs(d.attribution or {}) do
        attribution[k] = v
    end
    return {
        attack = d.attack,
        tags = tags,
        attribution = attribution,
    }
end
