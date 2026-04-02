function HelloLua()
    print("Hello, this is an external lua function")
end

function OnEvent(event)
    print(event .. " occurred!")
end

TestStruct = {}

TestStruct["a"] = "b"
