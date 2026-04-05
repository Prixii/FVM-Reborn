local function ModFunction()
    print("----------- Mod Message Start --------------")
    print("|         Here is ModFunction              |")
    print("----------- Mod Message End --------------")
end


function ModMain()
    print("Here is Mod main")
    Test.HelloLua()
    ModFunction()

    return 1
end

function TestCustomGmlFunc()
    local func = Stove.GetGmlFunction("stove_global_test")
    if (func ~= nil) then
        local result = func()
        print("function result from gml:", result)
        return 1
    else
        return 0
    end
end
