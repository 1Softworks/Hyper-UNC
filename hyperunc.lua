local totalTests = 0
local passedTests = 0

local function printResult(testName, success)
    totalTests = totalTests + 1
    if success then 
        passedTests = passedTests + 1
        print("✅ " .. testName .. " passed!") 
    else 
        print("❌ " .. testName .. " failed!") 
    end
end

local function testBasicFunctions()
    printResult("Print Function", pcall(function() print("test") end))
    printResult("Warn Function", pcall(function() warn("test") end))
    printResult("Type Function", type("test") == "string")
    printResult("LoadString", pcall(function() loadstring("print('test')")() end))
    printResult("Assert", pcall(function() assert(true) end))
    printResult("Error Handling", pcall(function() error("test") end))
    printResult("Coroutine", pcall(function() coroutine.create(function() end) end))
    printResult("Table Functions", pcall(function() table.insert({}, 1) end))
    printResult("Math Functions", pcall(function() math.random() end))
    printResult("String Functions", pcall(function() string.format("%d", 1) end))
end

local function testRobloxBasics()
    printResult("Game Variable", typeof(game) == "Instance")
    printResult("Workspace", typeof(workspace) == "Instance")
    printResult("GetService", pcall(function() game:GetService("Players") end))
    printResult("FindFirstChild", pcall(function() game:FindFirstChild("Players") end))
    printResult("WaitForChild", pcall(function() game:WaitForChild("Players", 1) end))
    printResult("Instance Creation", pcall(function() Instance.new("Part") end))
    printResult("Instance Properties", pcall(function() Instance.new("Part").Size = Vector3.new(1,1,1) end))
    printResult("Instance Methods", pcall(function() Instance.new("Part"):Clone() end))
    printResult("Instance Events", pcall(function() Instance.new("Part").Changed:Connect(function() end) end))
    printResult("Instance Destroy", pcall(function() Instance.new("Part"):Destroy() end))
end

local function testEnvironmentFunctions()
    printResult("Getgenv", pcall(function() getgenv() end))
    printResult("Getrenv", pcall(function() getrenv() end))
    printResult("Getsenv", pcall(function() getsenv(script) end))
    printResult("GetfEnv", pcall(function() getfenv() end))
    printResult("SetfEnv", pcall(function() setfenv(function() end, {}) end))
    printResult("CheckCaller", pcall(function() checkcaller() end))
    printResult("NewCClosure", pcall(function() newcclosure(function() end) end))
    printResult("LoadLibrary", pcall(function() loadlibrary("RbxUtility") end))
    printResult("IsLuau", pcall(function() isluau() end))
    printResult("GetThreadIdentity", pcall(function() getthreadidentity() end))
end

local function testMemoryManipulation()
    printResult("GetRawMetatable", pcall(function() getrawmetatable(game) end))
    printResult("SetRawMetatable", pcall(function() setrawmetatable({}, {}) end))
    printResult("HookFunction", pcall(function() hookfunction(print, print) end))
    printResult("HookMetamethod", pcall(function() hookmetamethod(game, "__index", function() end) end))
    printResult("GetNamecallMethod", pcall(function() getnamecallmethod() end))
    printResult("SetNamecallMethod", pcall(function() setnamecallmethod("Test") end))
    printResult("GetGc", pcall(function() getgc() end))
    printResult("GetRegistry", pcall(function() getreg() end))
    printResult("GetConstants", pcall(function() getconstants(print) end))
    printResult("GetUpvalues", pcall(function() getupvalues(print) end))
end

local function testUIFunctions()
    printResult("Drawing New", pcall(function() Drawing.new("Square") end))
    printResult("Mouse", pcall(function() game:GetService("Players").LocalPlayer:GetMouse() end))
    printResult("UserInputService", pcall(function() game:GetService("UserInputService") end))
    printResult("GuiToMouse", pcall(function() game:GetService("GuiService"):GetGuiInset() end))
    printResult("ScreenGui", pcall(function() Instance.new("ScreenGui") end))
    printResult("TextLabel", pcall(function() Instance.new("TextLabel") end))
    printResult("Frame", pcall(function() Instance.new("Frame") end))
    printResult("Button", pcall(function() Instance.new("TextButton") end))
    printResult("ImageLabel", pcall(function() Instance.new("ImageLabel") end))
    printResult("ViewportFrame", pcall(function() Instance.new("ViewportFrame") end))
end

local function testNetworkFunctions()
    printResult("HttpGet", pcall(function() game:HttpGet("https://www.google.com") end))
    printResult("Request", pcall(function() request({ Url = "https://www.google.com" }) end))
    printResult("WebSocket", pcall(function() WebSocket.connect("wss://echo.websocket.org") end))
    printResult("Syn Request", pcall(function() syn.request({ Url = "https://www.google.com" }) end))
    printResult("Socket", pcall(function() syn.websocket.connect("wss://echo.websocket.org") end))
    printResult("QueueOnTeleport", pcall(function() queue_on_teleport("print('test')") end))
    printResult("IsTeleporting", pcall(function() game:GetService("TeleportService"):IsTeleporting() end))
    printResult("NetworkClient", pcall(function() game:GetService("NetworkClient") end))
    printResult("MarketplaceService", pcall(function() game:GetService("MarketplaceService") end))
    printResult("MessagingService", pcall(function() game:GetService("MessagingService") end))
end

local function testPhysicsFunctions()
    printResult("Physics", pcall(function() game:GetService("PhysicsService") end))
    printResult("Raycast", pcall(function() workspace:Raycast(Vector3.new(), Vector3.new()) end))
    printResult("CFrame", pcall(function() CFrame.new() end))
    printResult("Vector3", pcall(function() Vector3.new() end))
    printResult("Region3", pcall(function() Region3.new() end))
    printResult("BrickColor", pcall(function() BrickColor.new("Really red") end))
    printResult("Color3", pcall(function() Color3.fromRGB(255,255,255) end))
    printResult("TweenService", pcall(function() game:GetService("TweenService") end))
    printResult("Debris", pcall(function() game:GetService("Debris") end))
    printResult("RunService", pcall(function() game:GetService("RunService") end))
end

local function testSecurityFunctions()
    printResult("GetHui", pcall(function() gethui() end))
    printResult("ProtectGui", pcall(function() protect_gui(Instance.new("ScreenGui")) end))
    printResult("UnprotectGui", pcall(function() unprotect_gui(Instance.new("ScreenGui")) end))
    printResult("Secure Function", pcall(function() secure_call(function() end, game) end))
    printResult("Is_Synapse_Function", pcall(function() is_synapse_function(print) end))
    printResult("Set_Thread_Identity", pcall(function() set_thread_identity(2) end))
    printResult("Get_Thread_Context", pcall(function() get_thread_context() end))
    printResult("Set_Thread_Context", pcall(function() set_thread_context(2) end))
    printResult("Check_Crypt", pcall(function() syn.crypt.encrypt("test", "key") end))
    printResult("Set_Clipboard", pcall(function() setclipboard("test") end))
end

local function testDebugFunctions()
    printResult("Debug Info", pcall(function() debug.info(print, "n") end))
    printResult("Debug GetUpvalue", pcall(function() debug.getupvalue(print, 1) end))
    printResult("Debug SetUpvalue", pcall(function() debug.setupvalue(print, 1, nil) end))
    printResult("Debug GetProtos", pcall(function() debug.getprotos(print) end))
    printResult("Debug GetStack", pcall(function() debug.getstack(1) end))
    printResult("Debug GetLocal", pcall(function() debug.getlocal(1, 1) end))
    printResult("Debug SetLocal", pcall(function() debug.setlocal(1, 1, nil) end))
    printResult("Debug GetMetatable", pcall(function() debug.getmetatable({}) end))
    printResult("Debug SetMetatable", pcall(function() debug.setmetatable({}, {}) end))
    printResult("Debug GetFenv", pcall(function() debug.getfenv(print) end))
end

local function testMiscFunctions()
    printResult("Identifyexecutor", pcall(function() identifyexecutor() end))
    printResult("GetExecutorName", pcall(function() getexecutorname() end))
    printResult("IsDebuggerPresent", pcall(function() isdbgpresent() end))
    printResult("GetInstanceList", pcall(function() getinstancelist() end))
    printResult("GetLoadedModules", pcall(function() getloadedmodules() end))
    printResult("GetConnections", pcall(function() getconnections(Instance.new("Part").Changed) end))
    printResult("Mouse Lock", pcall(function() mousemoveabs(100, 100) end))
    printResult("Mouse Click", pcall(function() mouse1click() end))
    printResult("Key Press", pcall(function() keypress(0x41) end))
    printResult("Get Closest Point", pcall(function() getclosestpoint(Vector3.new()) end))
end

local function testAdditionalServices()
    printResult("SoundService", pcall(function() game:GetService("SoundService") end))
    printResult("Lighting", pcall(function() game:GetService("Lighting") end))
    printResult("ReplicatedStorage", pcall(function() game:GetService("ReplicatedStorage") end))
    printResult("StarterGui", pcall(function() game:GetService("StarterGui") end))
    printResult("StarterPack", pcall(function() game:GetService("StarterPack") end))
    printResult("StarterPlayer", pcall(function() game:GetService("StarterPlayer") end))
    printResult("Teams", pcall(function() game:GetService("Teams") end))
    printResult("Chat", pcall(function() game:GetService("Chat") end))
    printResult("LocalizationService", pcall(function() game:GetService("LocalizationService") end))
    printResult("TestService", pcall(function() game:GetService("TestService") end))
end

local function testExtraFunctions()
    printResult("FireSignal", pcall(function() firesignal(Instance.new("BindableEvent").Event) end))
    printResult("FireClickDetector", pcall(function() fireclickdetector(Instance.new("ClickDetector")) end))
    printResult("FireProximityPrompt", pcall(function() fireproximityprompt(Instance.new("ProximityPrompt")) end))
    printResult("FireTouchInterest", pcall(function() firetouchinterest(Instance.new("Part"), Instance.new("Part"), 0) end))
    printResult("IsA Function", pcall(function() game:IsA("DataModel") end))
    printResult("GetChildren", pcall(function() game:GetChildren() end))
    printResult("GetDescendants", pcall(function() game:GetDescendants() end))
    printResult("FindFirstAncestor", pcall(function() game:FindFirstAncestor("test") end))
    printResult("FindFirstDescendant", pcall(function() game:FindFirstDescendant("test") end))
    printResult("WaitForChildOfClass", pcall(function() game:WaitForChildOfClass("Workspace") end))
end

local function testAdvancedMemoryFunctions()
    printResult("GetProtos", pcall(function() getprotos(print) end))
    printResult("GetStacks", pcall(function() getstacks() end))
    printResult("GetStackVariables", pcall(function() getstackvar(1) end))
    printResult("GetClosures", pcall(function() getclosures(print) end))
    printResult("GetInfo", pcall(function() getinfo(print) end))
    printResult("GetLocals", pcall(function() getlocals(1) end))
    printResult("GetRegisters", pcall(function() getregisters(1) end))
    printResult("SetStack", pcall(function() setstack(1, {}) end))
    printResult("TableToString", pcall(function() tabletostring({}) end))
    printResult("LoadTable", pcall(function() loadtable("{}") end))
end

local function testFileSystemFunctions()
    printResult("ReadFile", pcall(function() readfile("test.txt") end))
    printResult("WriteFile", pcall(function() writefile("test.txt", "content") end))
    printResult("AppendFile", pcall(function() appendfile("test.txt", "content") end))
    printResult("LoadFile", pcall(function() loadfile("test.lua") end))
    printResult("ListFiles", pcall(function() listfiles("folder") end))
    printResult("IsFile", pcall(function() isfile("test.txt") end))
    printResult("IsFolder", pcall(function() isfolder("folder") end))
    printResult("MakeFolder", pcall(function() makefolder("newfolder") end))
    printResult("DeleteFile", pcall(function() delfile("test.txt") end))
    printResult("DeleteFolder", pcall(function() delfolder("folder") end))
end

local function testDrawingFunctions()
    printResult("DrawLine", pcall(function() return Drawing.new("Line") end))
    printResult("DrawCircle", pcall(function() return Drawing.new("Circle") end))
    printResult("DrawText", pcall(function() return Drawing.new("Text") end))
    printResult("DrawImage", pcall(function() return Drawing.new("Image") end))
    printResult("DrawTriangle", pcall(function() return Drawing.new("Triangle") end))
    printResult("DrawQuad", pcall(function() return Drawing.new("Quad") end))

    printResult("GetRenderProperty", pcall(function()
        local square = Drawing.new("Square")
        return square.Visible
    end))

    printResult("SetRenderProperty", pcall(function()
        local square = Drawing.new("Square")
        square.Visible = true
    end))

    printResult("GetDrawings", pcall(function() return Drawing.getDrawings() end))
end


print("Starting Hyper UNC Executor Test")
print("=============================================")

testBasicFunctions()
testRobloxBasics()
testEnvironmentFunctions()
testMemoryManipulation()
testUIFunctions()
testNetworkFunctions()
testPhysicsFunctions()
testSecurityFunctions()
testDebugFunctions()
testMiscFunctions()
testAdditionalServices()
testExtraFunctions()
testAdvancedMemoryFunctions()
testFileSystemFunctions() 
testDrawingFunctions()

print("=============================================")
print("🏁 Hyper UNC Test Completed! 🏁")
print("📊 Final Score: " .. passedTests .. "/" .. totalTests .. " tests passed (" .. math.floor((passedTests/totalTests)*100) .. "%)")
if passedTests == totalTests then
    print("🌟 Perfect Score! All tests passed! 🌟")
elseif passedTests >= totalTests * 0.8 then
    print("🎉 Great Score! Most tests passed! 🎉")
elseif passedTests >= totalTests * 0.5 then
    print("⚠️ Average Score. Some features might be missing. ⚠️")
else
    print("❗ Low Score. Many features are not supported. ❗")
end
