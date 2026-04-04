local function ModFunction()
    print("----------- Mod Message Start --------------")
    print("|         Here is ModFunction              |")
    print("----------- Mod Message End --------------")
end

function ModMain()
    print("Here is Mod main")
    Test.HelloLua()
    return 1
end
