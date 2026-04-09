Test = {}

Test.HelloLua = function()
    print("Hello, this is an external lua function")
end

--- GML → Lua → GML：多返回值（GML 侧收到为 array）
Test.EchoPrimitives = function(n, s, b, u)
    return n, s, b, u
end

--- GML 数组经 GMLToLua 后下标为字符串 "1","2","3"
Test.EchoGmlArrayAsTable = function(t)
    return t["1"], t["2"], t["3"]
end

--- Lua 字面量数组在 GML struct 上为 Number_1, Number_2 …
Test.BuildNumericTableReturn = function()
    return { 100, 200, 300 }
end

--- struct / 类 map 字段回传
Test.EchoStruct = function(s)
    return s
end

--- 简单结构：坐标
Test.EchoPoint = function(p)
    return p
end

--- 复杂结构：嵌套 + 由 GML 数组转来的子表（键 "1","2"）
Test.EchoComplex = function(c)
    return c
end

--- Lua 侧改写字段，验证 table 与 GML struct 引用一致
Test.MutatePassedStruct = function(s)
    s.mutated = true
    s.extra = 42
    return s
end

--- Lua → GML → Lua：调用白名单中的 GML 函数
Test.CallGmlIdentity = function(x)
    local f = Stove.GetGmlFunction("gmlua_test_identity")
    if f == nil then
        return nil
    end
    return f(x)
end
