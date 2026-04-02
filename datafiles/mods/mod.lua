local function ModFunction()
    print("----------- Mod Message Start --------------")
    print("|         Here is ModFunction              |")
    print("----------- Mod Message End --------------")
end

function ModMain()
    local myFuncId = ModSdk.RegisterFunction(ModFunction)
    print("Registered function with ID: " .. myFuncId)
end
