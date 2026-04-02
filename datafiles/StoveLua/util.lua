Util = {}

Util.CreateEnum = function(tbl)
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(_, key, _)
            error("Attempt to modify read-only enum field: " .. tostring(key))
        end,
        __metatable = false -- 防止元表被修改
    })
end
