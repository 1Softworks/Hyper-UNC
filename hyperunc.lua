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
    printResult("Print Function", pcall(function() 
        print("test", 123, true, {key = "value"}, function() end)
    end))

    printResult("Warn Function", pcall(function()
        warn("[ERROR]", debug.traceback("test warning", 2))
    end))

    printResult("Type Function", type("test") == "string" 
        and type(123) == "number" 
        and type(true) == "boolean"
        and type({}) == "table"
        and type(function() end) == "function")

    printResult("LoadString", pcall(function()
        local x = 10
        assert(loadstring("local y = ... return y + 5")(x) == 15)
    end))

    printResult("Assert", pcall(function()
        assert(type(1) == "number" and 1 > 0, "Invalid number")
        assert(type("test") == "string" and #"test" > 0, "Invalid string")
    end))

    printResult("Error Handling", pcall(function()
        local success, result = xpcall(
            function() error({code = 500, message = "test error"}) end,
            function(err) return err end
        )
        assert(not success and result.code == 500)
    end))

    printResult("Coroutine", pcall(function()
        local co = coroutine.create(function(x)
            local y = coroutine.yield(x + 1)
            return y * 2
        end)
        local _, first = coroutine.resume(co, 5)
        local _, result = coroutine.resume(co, first)
        assert(result == 12)
    end))

    printResult("Table Functions", pcall(function()
        local t = {1, 2, 3}
        table.insert(t, 2, 4)
        table.sort(t)
        assert(table.concat(t, ",") == "1,2,3,4")
    end))

    printResult("Math Functions", pcall(function()
        assert(math.abs(math.sin(math.pi/2) - 1) < 0.0001)
        assert(math.floor(math.log(math.exp(5))) == 5)
        assert(math.min(math.random(), 1) <= 1)
    end))

    printResult("String Functions", pcall(function()
        local str = "Hello World"
        assert(string.format("%q %d %.2f", str, 42, math.pi) == '"Hello World" 42 3.14')
        assert(string.match(str:lower(), "^h%w+") == "hello")
        assert(string.gsub(str, "(%w)(%w+)", "%1.") == "H. W.")
    end))
end

local function testRobloxBasics()
    printResult("Game Hierarchy", pcall(function()
        assert(game.Parent == nil and game:IsA("DataModel"))
        assert(typeof(game:GetDescendants()[1]) == "Instance")
    end))

    printResult("Workspace Physics", pcall(function()
        local part = Instance.new("Part")
        part.Anchored = false
        part.Position = Vector3.new(0, 100, 0)
        part.Parent = workspace
        task.wait(0.1)
        assert(part.Position.Y < 100) 
        part:Destroy()
    end))

    printResult("Service Interaction", pcall(function()
        local players = game:GetService("Players")
        local lighting = game:GetService("Lighting")
        local runService = game:GetService("RunService")
        assert(players and lighting and runService)
        assert(players:IsA("Players") and lighting:IsA("Lighting"))
    end))

    printResult("Instance Manipulation", pcall(function()
        local model = Instance.new("Model")
        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 3, 4)
        part.CFrame = CFrame.new(5, 5, 5) * CFrame.Angles(math.rad(45), 0, 0)
        part.Material = Enum.Material.Neon
        part.Parent = model
        assert(model:FindFirstChild("Part") == part)
        assert(part.Size == Vector3.new(2, 3, 4))
    end))

    printResult("Event Handling", pcall(function()
        local part = Instance.new("Part")
        local connections = {}
        local eventsFired = {changed = false, touched = false}
        
        table.insert(connections, part.Changed:Connect(function(property)
            eventsFired.changed = property == "Position"
        end))
        
        table.insert(connections, part.Touched:Connect(function(hit)
            eventsFired.touched = hit:IsA("BasePart")
        end))
        
        part.Position = Vector3.new(10, 10, 10)
        assert(eventsFired.changed)
        
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        part:Destroy()
    end))
end

local function testEnvironmentFunctions()
    printResult("Getgenv", pcall(function()
        local env = getgenv()
        env.testVar = "test"
        assert(env.testVar == "test")
    end))
    
    printResult("Getrenv", pcall(function()
        local renv = getrenv()
        assert(type(renv) == "table")
        assert(renv._G)
    end))
    
    printResult("Getsenv", pcall(function()
        local senv = getsenv(script)
        assert(type(senv) == "table")
        assert(senv.printResult)
    end))
    
    printResult("GetfEnv", pcall(function()
        local fenv = getfenv(2)
        assert(type(fenv) == "table")
        assert(fenv.script)
    end))
    
    printResult("SetfEnv", pcall(function()
        local newEnv = {
            print = print,
            assert = assert
        }
        local testFunc = function() return _ENV end
        setfenv(testFunc, newEnv)
        assert(getfenv(testFunc) == newEnv)
    end))
    
    printResult("CheckCaller", pcall(function()
        local result = checkcaller()
        assert(type(result) == "boolean")
    end))
    
    printResult("NewCClosure", pcall(function()
        local wrapped = newcclosure(function(x) return x * 2 end)
        assert(wrapped(5) == 10)
    end))
    
    printResult("LoadLibrary", pcall(function()
        local util = loadlibrary("RbxUtility")
        assert(type(util) == "userdata")
    end))
    
    printResult("IsLuau", pcall(function()
        local luauEnabled = isluau()
        assert(type(luauEnabled) == "boolean")
    end))
    
    printResult("GetThreadIdentity", pcall(function()
        local identity = getthreadidentity()
        assert(type(identity) == "number")
        assert(identity >= 0)
    end))
end

local function testMemoryManipulation()
    printResult("GetRawMetatable", pcall(function()
        local mt = getrawmetatable(game)
        assert(type(mt) == "table")
        assert(mt.__index)
    end))
    
    printResult("SetRawMetatable", pcall(function()
        local tbl = {}
        local mt = {
            __index = function(t,k) return k.."_modified" end,
            __newindex = function(t,k,v) rawset(t,k.."_protected",v) end
        }
        setrawmetatable(tbl, mt)
        assert(tbl.test == "test_modified")
    end))
    
    printResult("HookFunction", pcall(function()
        local original = print
        local callCount = 0
        hookfunction(print, function(...)
            callCount = callCount + 1
            return original(...)
        end)
        print("test")
        assert(callCount == 1)
    end))
    
    printResult("HookMetamethod", pcall(function()
        local original = game.__index
        hookmetamethod(game, "__index", function(self, key)
            if key == "HookedProperty" then return "Hooked" end
            return original(self, key)
        end)
        assert(game.HookedProperty == "Hooked")
    end))
    
    printResult("GetNamecallMethod", pcall(function()
        local method = getnamecallmethod()
        assert(type(method) == "string")
    end))
    
    printResult("SetNamecallMethod", pcall(function()
        setnamecallmethod("FireServer")
        assert(getnamecallmethod() == "FireServer")
    end))
    
    printResult("GetGc", pcall(function()
        local gc = getgc(true)
        assert(type(gc) == "table")
        assert(#gc > 0)
    end))
    
    printResult("GetRegistry", pcall(function()
        local reg = getreg()
        assert(type(reg) == "table")
        assert(#reg > 0)
    end))
    
    printResult("GetConstants", pcall(function()
        local constants = getconstants(print)
        assert(type(constants) == "table")
    end))
    
    printResult("GetUpvalues", pcall(function()
        local upvalues = getupvalues(print)
        assert(type(upvalues) == "table")
    end))
end

local function testUIFunctions()
    printResult("Drawing Complex", pcall(function()
        local square = Drawing.new("Square")
        square.Size = Vector2.new(100, 100)
        square.Position = Vector2.new(200, 200)
        square.Color = Color3.fromRGB(255, 0, 0)
        square.Filled = true
        square.Transparency = 0.5
        square.Visible = true
    end))
    
    printResult("Mouse Tracking", pcall(function()
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        mouse.Move:Connect(function()
            return mouse.X, mouse.Y, mouse.Hit
        end)
    end))
    
    printResult("Input Handling", pcall(function()
        local UIS = game:GetService("UserInputService")
        UIS.InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == Enum.KeyCode.Space then
                return "Space Pressed"
            end
        end)
    end))
    
    printResult("Dynamic GUI", pcall(function()
        local screenGui = Instance.new("ScreenGui")
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 200, 0, 200)
        frame.Position = UDim2.new(0.5, -100, 0.5, -100)
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -20, 0, 30)
        textLabel.Position = UDim2.new(0, 10, 0, 10)
        textLabel.Text = "Dynamic GUI Test"
        textLabel.Parent = frame
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 100, 0, 30)
        button.Position = UDim2.new(0.5, -50, 0.5, -15)
        button.Text = "Click Me"
        button.Parent = frame
        
        frame.Parent = screenGui
    end))
    
    printResult("Viewport Manipulation", pcall(function()
        local viewport = Instance.new("ViewportFrame")
        local camera = Instance.new("Camera")
        local part = Instance.new("Part")
        
        viewport.Size = UDim2.new(0, 300, 0, 300)
        viewport.Position = UDim2.new(0.5, -150, 0.5, -150)
        viewport.CurrentCamera = camera
        
        part.Size = Vector3.new(5, 5, 5)
        part.CFrame = CFrame.new(0, 0, -10)
        part.Parent = viewport
        
        camera.CFrame = CFrame.new(0, 0, -15) * CFrame.lookAt(Vector3.new(0,0,-15), Vector3.new(0,0,-10))
    end))
end

local function testNetworkFunctions()
    printResult("Advanced HTTP", pcall(function()
        local response = game:HttpGet("https://api.github.com/users/github")
        local success = response:find("login") ~= nil
        
        local postResponse = request({
            Url = "https://httpbin.org/post",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = game:GetService("HttpService"):JSONEncode({
                test = "data",
                number = 123
            })
        })
        return success and postResponse.Success
    end))
    
    printResult("WebSocket Handler", pcall(function()
        local ws = WebSocket.connect("wss://echo.websocket.org")
        ws.OnMessage:Connect(function(msg)
            if msg == "ping" then
                ws:Send("pong")
            end
        end)
        ws:Send("ping")
    end))
    
    printResult("Network Monitoring", pcall(function()
        local NetworkClient = game:GetService("NetworkClient")
        local MarketplaceService = game:GetService("MarketplaceService")
        local MessagingService = game:GetService("MessagingService")
        
        MessagingService:SubscribeAsync("TestChannel", function(message)
            return message.Data
        end)
        
        MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
            return {player = player, gamePassId = gamePassId, purchased = wasPurchased}
        end)
    end))
    
    printResult("Teleport Handler", pcall(function()
        game:GetService("TeleportService").TeleportInitiated:Connect(function(teleportData)
            queue_on_teleport([[
                local data = ...
                print("Teleported with data:", data)
            ]])
        end)
    end))
end

local function testPhysicsFunctions()
    printResult("Physics Service Configuration", pcall(function()
        local PhysicsService = game:GetService("PhysicsService")
        local collisionGroupId = PhysicsService:CreateCollisionGroup("TestGroup")
        PhysicsService:CollisionGroupSetCollidable("TestGroup", "Default", false)
        return collisionGroupId ~= nil
    end))
    
    printResult("Advanced Raycast", pcall(function()
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
        local result = workspace:Raycast(
            Vector3.new(0, 100, 0), 
            Vector3.new(0, -200, 0), 
            raycastParams
        )
        return result and result.Position
    end))
    
    printResult("Complex CFrame Operations", pcall(function()
        local cf = CFrame.new(10, 20, 30) * CFrame.Angles(math.rad(45), math.rad(90), math.rad(180))
        local inverse = cf:Inverse()
        local lookAt = CFrame.lookAt(Vector3.new(0,5,0), Vector3.new(10,5,10))
        return cf:ToObjectSpace(lookAt)
    end))
    
    printResult("Vector3 Mathematics", pcall(function()
        local v1 = Vector3.new(1, 2, 3)
        local v2 = Vector3.new(4, 5, 6)
        local cross = v1:Cross(v2)
        local dot = v1:Dot(v2)
        local lerp = v1:Lerp(v2, 0.5)
        return cross.Magnitude > 0
    end))
    
    printResult("Region3 Intersection", pcall(function()
        local region = Region3.new(
            Vector3.new(-10, -10, -10),
            Vector3.new(10, 10, 10)
        )
        local parts = workspace:FindPartsInRegion3(region, nil, math.huge)
        return #parts > 0
    end))
    
    printResult("Color Operations", pcall(function()
        local color = Color3.fromHSV(0.5, 1, 1)
        local lerped = color:Lerp(Color3.new(1,0,0), 0.5)
        local h, s, v = color:ToHSV()
        return h >= 0 and s <= 1 and v <= 1
    end))
    
    printResult("Advanced Tweening", pcall(function()
        local TweenService = game:GetService("TweenService")
        local info = TweenInfo.new(
            2,                     
            Enum.EasingStyle.Bounce,
            Enum.EasingDirection.InOut,
            2,                    
            true,                 
            0.1                   
        )
        return TweenService:Create(Instance.new("Part"), info, {
            Size = Vector3.new(5,5,5),
            CFrame = CFrame.new(0,10,0)
        })
    end))
    
    printResult("Debris Management", pcall(function()
        local Debris = game:GetService("Debris")
        local part = Instance.new("Part")
        Debris:AddItem(part, 5)
        return Debris:GetUnreplicatedInstances()
    end))
    
    printResult("RunService Binding", pcall(function()
        local RunService = game:GetService("RunService")
        local connection = RunService.Heartbeat:Connect(function() end)
        local stepped = RunService.Stepped:Connect(function() end)
        connection:Disconnect()
        stepped:Disconnect()
        return RunService:IsStudio()
    end))
end

local function testSecurityFunctions()
    printResult("Protected GUI Hierarchy", pcall(function()
        local gui = Instance.new("ScreenGui")
        local frame = Instance.new("Frame", gui)
        frame.Size = UDim2.new(1, 0, 1, 0)
        protect_gui(gui)
        return gui.Parent ~= nil
    end))
    
    printResult("Secure Environment", pcall(function()
        local env = getfenv(0)
        local protected = secure_call(function()
            return env._G ~= nil
        end, game)
        return protected
    end))
    
    printResult("Thread Management", pcall(function()
        local originalIdentity = get_thread_context()
        set_thread_identity(7)
        local success = pcall(function()
            return game:GetService("MarketplaceService")
        end)
        set_thread_identity(originalIdentity)
        return success
    end))
    
    printResult("Cryptography", pcall(function()
        local data = "Sensitive information"
        local key = syn.crypt.random(32)
        local encrypted = syn.crypt.encrypt(data, key)
        local decrypted = syn.crypt.decrypt(encrypted, key)
        return data == decrypted
    end))
    
    printResult("Clipboard Integration", pcall(function()
        local data = {
            timestamp = os.time(),
            random = math.random(),
            info = "Test data"
        }
        setclipboard(game:GetService("HttpService"):JSONEncode(data))
        return true
    end))
end

local function testDebugFunctions()
    printResult("Debug Info", pcall(function()
        local info = debug.info(print, "slnfa")
        assert(type(info) == "table")
        assert(info.source and info.linedefined and info.name)
    end))

    printResult("Debug GetUpvalue", pcall(function()
        local closure = function() local x = 1; return function() return x end end
        local innerFunc = closure()
        local name, value = debug.getupvalue(innerFunc, 1)
        assert(name == "x" and value == 1)
    end))

    printResult("Debug SetUpvalue", pcall(function()
        local closure = function() local x = 1; return function() return x end end
        local innerFunc = closure()
        debug.setupvalue(innerFunc, 1, 100)
        assert(innerFunc() == 100)
    end))

    printResult("Debug GetProtos", pcall(function()
        local function test()
            local function inner1() end
            local function inner2() end
            return inner1, inner2
        end
        local protos = debug.getprotos(test)
        assert(#protos == 2)
    end))

    printResult("Debug GetStack", pcall(function()
        local function deep3() return debug.getstack(3) end
        local function deep2() return deep3() end
        local function deep1() return deep2() end
        local stack = deep1()
        assert(type(stack) == "table")
    end))

    printResult("Debug GetLocal", pcall(function()
        local testVar = "test"
        local name, value = debug.getlocal(1, 1)
        assert(name == "testVar" and value == "test")
    end))

    printResult("Debug SetLocal", pcall(function()
        local testVar = "old"
        debug.setlocal(1, 1, "new")
        assert(testVar == "new")
    end))

    printResult("Debug GetMetatable", pcall(function()
        local t = setmetatable({}, {__index = function() return true end})
        local mt = debug.getmetatable(t)
        assert(type(mt.__index) == "function")
    end))

    printResult("Debug SetMetatable", pcall(function()
        local t = {}
        local mt = {__index = function() return "intercepted" end}
        debug.setmetatable(t, mt)
        assert(t.anything == "intercepted")
    end))

    printResult("Debug GetFenv", pcall(function()
        local function test() end
        local env = debug.getfenv(test)
        assert(type(env) == "table")
        assert(env._G == getgenv())
    end))
end

local function testMiscFunctions()
    printResult("Executor Information", pcall(function()
        local executor = identifyexecutor()
        local name = getexecutorname()
        local debugger = isdbgpresent()
        return {executor = executor, name = name, debugger = debugger}
    end))

    printResult("Instance Analysis", pcall(function()
        local instances = getinstancelist()
        local modules = getloadedmodules()
        local filtered = {}
        for _, inst in ipairs(instances) do
            if inst:IsA("BasePart") then
                table.insert(filtered, inst)
            end
        end
        return #filtered > 0 and #modules > 0
    end))

    printResult("Event Handling", pcall(function()
        local part = Instance.new("Part")
        local connections = getconnections(part.Changed)
        for _, connection in ipairs(connections) do
            connection:Enable()
            connection:Fire()
            connection:Disable() 
        end
        return #connections
    end))

    printResult("Input Simulation", pcall(function()
      
        for i = 1, 5 do
            mousemoveabs(100 + i * 50, 100 + math.sin(i) * 30)
            task.wait(0.1)
        end
        
      
        mouse1click()
        mouse2click()
        mouse1press()
        task.wait(0.1)
        mouse1release()
        
      
        keypress(0x11)
        keypress(0x41)
        task.wait(0.1)
        keyrelease(0x11)
        keyrelease(0x41)
    end))

    printResult("Spatial Analysis", pcall(function()
        local points = {
            Vector3.new(0, 0, 0),
            Vector3.new(10, 5, 3),
            Vector3.new(-5, 2, 8)
        }
        local closest = nil
        local minDist = math.huge
        
        for _, point in ipairs(points) do
            local dist = getclosestpoint(point).Magnitude
            if dist < minDist then
                minDist = dist
                closest = point
            end
        end
        return closest
    end))
end

local function testAdditionalServices()
    printResult("SoundService", pcall(function()
        local soundService = game:GetService("SoundService")
        soundService.RespectFilteringEnabled = false
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/victory.ogg"
        sound.Volume = 0.5
        sound.Parent = soundService
        sound:Play()
        return sound.IsPlaying
    end))

    printResult("Lighting", pcall(function()
        local lighting = game:GetService("Lighting")
        lighting.Brightness = 2
        lighting.ClockTime = 14.5
        lighting.FogEnd = 100
        lighting.GlobalShadows = true
        
        local blur = Instance.new("BlurEffect")
        blur.Size = 24
        blur.Parent = lighting
        return lighting.ClockTime
    end))

    printResult("ReplicatedStorage", pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local folder = Instance.new("Folder")
        folder.Name = "SharedAssets"
        
        local remoteEvent = Instance.new("RemoteEvent")
        remoteEvent.Name = "DataSync"
        remoteEvent.Parent = folder
        
        folder.Parent = rs
        return #rs:GetChildren()
    end))

    printResult("StarterGui", pcall(function()
        local sg = game:GetService("StarterGui")
        sg:SetCore("SendNotification", {
            Title = "Test",
            Text = "Advanced StarterGui Test",
            Duration = 5
        })
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.ResetOnSpawn = false
        screenGui.Parent = sg
        return screenGui.Parent == sg
    end))

    printResult("StarterPack", pcall(function()
        local sp = game:GetService("StarterPack")
        local tool = Instance.new("Tool")
        tool.Name = "TestTool"
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Parent = tool
        
        tool.Parent = sp
        return tool.Parent == sp
    end))

    printResult("StarterPlayer", pcall(function()
        local splayer = game:GetService("StarterPlayer")
        splayer.AutoJumpEnabled = false
        splayer.CameraMaxZoomDistance = 100
        splayer.DevComputerCameraMovementMode = Enum.DevComputerCameraMovementMode.UserChoice
        splayer.DevTouchCameraMovementMode = Enum.DevTouchCameraMovementMode.Classic
        return splayer.AutoJumpEnabled == false
    end))

    printResult("Teams", pcall(function()
        local teams = game:GetService("Teams")
        local team1 = Instance.new("Team")
        team1.Name = "Red Team"
        team1.TeamColor = BrickColor.new("Really red")
        team1.AutoAssignable = true
        team1.Parent = teams
        
        local team2 = Instance.new("Team")
        team2.Name = "Blue Team"
        team2.TeamColor = BrickColor.new("Really blue")
        team2.AutoAssignable = true
        team2.Parent = teams
        return #teams:GetChildren() >= 2
    end))

    printResult("Chat", pcall(function()
        local chat = game:GetService("Chat")
        chat:FilterStringAsync("Test message", game.Players.LocalPlayer.UserId)
        chat.BubbleChatEnabled = true
        chat.LoadDefaultChat = true
        return chat.BubbleChatEnabled
    end))

    printResult("LocalizationService", pcall(function()
        local localization = game:GetService("LocalizationService")
        local translator = localization:GetTranslatorForPlayer(game.Players.LocalPlayer)
        translator:Translate(workspace, "Hello World", "en")
        return translator ~= nil
    end))

    printResult("TestService", pcall(function()
        local testService = game:GetService("TestService")
        testService:Message("Running advanced tests")
        testService.AutoRuns = true
        testService:Check(true, "Condition check passed")
        return testService.AutoRuns
    end))
end

local function testExtraFunctions()
    printResult("FireSignal", pcall(function()
        local bindableEvent = Instance.new("BindableEvent")
        local triggered = false
        bindableEvent.Event:Connect(function(data)
            triggered = data.test == "success"
        end)
        firesignal(bindableEvent.Event, {test = "success"})
        return triggered
    end))

    printResult("FireClickDetector", pcall(function()
        local clickDetector = Instance.new("ClickDetector")
        local part = Instance.new("Part")
        clickDetector.Parent = part
        local clicked = false
        clickDetector.MouseClick:Connect(function()
            clicked = true
        end)
        fireclickdetector(clickDetector, 10)
        return clicked
    end))

    printResult("FireProximityPrompt", pcall(function()
        local prompt = Instance.new("ProximityPrompt")
        prompt.ActionText = "Test Action"
        prompt.ObjectText = "Test Object"
        prompt.KeyboardKeyCode = Enum.KeyCode.E
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = 10
        
        local triggered = false
        prompt.Triggered:Connect(function()
            triggered = true
        end)
        fireproximityprompt(prompt)
        return triggered
    end))

    printResult("FireTouchInterest", pcall(function()
        local part1 = Instance.new("Part")
        local part2 = Instance.new("Part")
        local touched = false
        part1.Touched:Connect(function(hit)
            if hit == part2 then
                touched = true
            end
        end)
        firetouchinterest(part1, part2, 0)
        task.wait(0.1)
        firetouchinterest(part1, part2, 1)
        return touched
    end))

    printResult("Advanced Instance Operations", pcall(function()
        local success = true
        success = success and game:IsA("DataModel")
        
        local children = game:GetChildren()
        success = success and #children > 0
        
        local descendants = game:GetDescendants()
        success = success and #descendants > #children
        
        local workspace = game:FindFirstAncestor("Workspace") or game:WaitForChildOfClass("Workspace")
        success = success and workspace:IsA("Workspace")
        
        local firstScript = game:FindFirstDescendant("Script")
        if firstScript then
            success = success and firstScript:IsA("LuaSourceContainer")
        end
        
        return success
    end))
end

local function testAdvancedMemoryFunctions()
    printResult("GetProtos", pcall(function()
        local function testFunc()
            local function inner1() end
            local function inner2() end
            return function() inner1(); inner2() end
        end
        local protos = getprotos(testFunc)
        assert(#protos == 3)
        return protos
    end))

    printResult("GetStacks", pcall(function()
        local function deep3() return getstacks() end
        local function deep2() return deep3() end
        local function deep1() return deep2() end
        local stacks = deep1()
        assert(#stacks >= 3)
        return stacks
    end))

    printResult("GetStackVariables", pcall(function()
        local testVar1, testVar2 = "test1", {key = "value"}
        local vars = getstackvar(1)
        assert(vars.testVar1 == "test1" and vars.testVar2.key == "value")
        return vars
    end))

    printResult("GetClosures", pcall(function()
        local function genClosures()
            local x = 1
            return function() x = x + 1 end,
                   function() return x end
        end
        local closures = getclosures(genClosures)
        assert(#closures == 2)
        return closures
    end))

    printResult("GetInfo", pcall(function()
        local info = getinfo(print)
        assert(info.source and info.linedefined and info.what == "C")
        return info
    end))

    printResult("GetLocals", pcall(function()
        local complex = {nested = {value = 123}}
        local locals = getlocals(1)
        assert(locals.complex.nested.value == 123)
        return locals
    end))

    printResult("GetRegisters", pcall(function()
        local function testRegisters()
            local a, b = 1, 2
            return a + b
        end
        local regs = getregisters(testRegisters)
        assert(#regs > 0)
        return regs
    end))

    printResult("SetStack", pcall(function()
        local original = {value = 1}
        local new = {value = 2}
        setstack(1, new)
        assert(original.value == 2)
        return true
    end))

    printResult("TableToString", pcall(function()
        local complexTable = {
            nested = {array = {1,2,3}},
            func = function() end,
            thread = coroutine.create(function() end)
        }
        local str = tabletostring(complexTable)
        assert(type(str) == "string" and #str > 0)
        return str
    end))

    printResult("LoadTable", pcall(function()
        local tableStr = [[{
            number = 123,
            string = "test",
            array = {1,2,3},
            nested = {key = "value"}
        }]]
        local loaded = loadtable(tableStr)
        assert(loaded.number == 123 and loaded.nested.key == "value")
        return loaded
    end))
end

local function testFileSystemFunctions()
    printResult("File Operations", pcall(function()
    
        makefolder("testRoot")
        makefolder("testRoot/subFolder")
        

        local testData = {
            timestamp = os.time(),
            array = {1,2,3},
            nested = {key = "value"}
        }
        local jsonData = game:GetService("HttpService"):JSONEncode(testData)
        writefile("testRoot/data.json", jsonData)
        
       
        for i = 1, 3 do
            appendfile("testRoot/log.txt", 
                string.format("[%s] Log entry %d\n", 
                os.date(), i))
        end
        
        local readJson = game:GetService("HttpService"):JSONDecode(
            readfile("testRoot/data.json"))
        assert(readJson.timestamp == testData.timestamp)
        
        local files = listfiles("testRoot")
        assert(#files >= 2) 
        
        writefile("testRoot/script.lua", [[
            return function(x) return x * 2 end
        ]])
        local fn = loadfile("testRoot/script.lua")()
        assert(fn(5) == 10)
        
        delfile("testRoot/data.json")
        delfile("testRoot/log.txt")
        delfile("testRoot/script.lua")
        delfolder("testRoot/subFolder")
        delfolder("testRoot")
        
        return true
    end))
end

local function testDrawingFunctions()
    printResult("Advanced Line Drawing", pcall(function()
        local line = Drawing.new("Line")
        line.Visible = true
        line.From = Vector2.new(100, 100)
        line.To = Vector2.new(300, 300)
        line.Color = Color3.fromRGB(255, 0, 0)
        line.Thickness = 2
        line.Transparency = 0.5
        return line.From.X == 100 and line.To.Y == 300
    end))

    printResult("Dynamic Circle", pcall(function()
        local circle = Drawing.new("Circle")
        circle.Visible = true
        circle.Position = Vector2.new(200, 200)
        circle.Radius = 50
        circle.Color = Color3.fromHSV(0, 1, 1)
        circle.NumSides = 32
        circle.Filled = true
        
        for i = 1, 10 do
            circle.Radius = 50 + math.sin(i) * 10
            task.wait(0.1)
        end
        return circle.NumSides == 32
    end))

    printResult("Animated Text", pcall(function()
        local text = Drawing.new("Text")
        text.Visible = true
        text.Position = Vector2.new(150, 150)
        text.Size = 24
        text.Center = true
        text.Outline = true
        text.Font = Drawing.Fonts.UI
        
        local messages = {"Hello", "World", "Testing", "Drawing"}
        for _, msg in ipairs(messages) do
            text.Text = msg
            text.Color = Color3.fromRGB(
                math.random(0, 255),
                math.random(0, 255),
                math.random(0, 255)
            )
            task.wait(0.2)
        end
        return text.Size == 24
    end))

    printResult("Complex Image Manipulation", pcall(function()
        local image = Drawing.new("Image")
        image.Visible = true
        image.Position = Vector2.new(400, 100)
        image.Size = Vector2.new(200, 200)
        image.Data = game:HttpGet("https://example.com/test.png")
        image.Rounding = 8
        
        for i = 0, 1, 0.1 do
            image.Transparency = i
            task.wait(0.1)
        end
        return image.Rounding == 8
    end))

    printResult("Interactive Triangle", pcall(function()
        local triangle = Drawing.new("Triangle")
        triangle.Visible = true
        triangle.PointA = Vector2.new(100, 100)
        triangle.PointB = Vector2.new(200, 300)
        triangle.PointC = Vector2.new(300, 100)
        triangle.Color = Color3.fromRGB(0, 255, 0)
        triangle.Filled = true
        triangle.Transparency = 0.8
        
        local function rotateTri(angle)
            local center = Vector2.new(200, 200)
            local function rotatePoint(point)
                local x = point.X - center.X
                local y = point.Y - center.Y
                return Vector2.new(
                    x * math.cos(angle) - y * math.sin(angle) + center.X,
                    x * math.sin(angle) + y * math.cos(angle) + center.Y
                )
            end
            
            triangle.PointA = rotatePoint(triangle.PointA)
            triangle.PointB = rotatePoint(triangle.PointB)
            triangle.PointC = rotatePoint(triangle.PointC)
        end
        
        for i = 0, math.pi * 2, 0.2 do
            rotateTri(i)
            task.wait(0.05)
        end
        return true
    end))

    printResult("Dynamic Quad Effects", pcall(function()
        local quad = Drawing.new("Quad")
        quad.Visible = true
        quad.PointA = Vector2.new(400, 100)
        quad.PointB = Vector2.new(600, 100)
        quad.PointC = Vector2.new(600, 300)
        quad.PointD = Vector2.new(400, 300)
        quad.Filled = true
        
        local function pulseQuad()
            for i = 0, math.pi * 2, 0.2 do
                local scale = 1 + math.sin(i) * 0.2
                quad.PointA = Vector2.new(400 * scale, 100 * scale)
                quad.PointB = Vector2.new(600 * scale, 100 * scale)
                quad.PointC = Vector2.new(600 * scale, 300 * scale)
                quad.PointD = Vector2.new(400 * scale, 300 * scale)
                quad.Color = Color3.fromHSV(i / (math.pi * 2), 1, 1)
                task.wait(0.05)
            end
        end
        
        pulseQuad()
        return true
    end))

    printResult("Drawing Layer Management", pcall(function()
        local drawings = {}
        for i = 1, 5 do
            local circle = Drawing.new("Circle")
            circle.Visible = true
            circle.Position = Vector2.new(300, 300)
            circle.Radius = i * 20
            circle.Color = Color3.fromHSV(i/5, 1, 1)
            circle.Transparency = 0.2
            circle.ZIndex = i
            table.insert(drawings, circle)
        end
        
        local allDrawings = Drawing.getDrawings()
        for _, drawing in ipairs(drawings) do
            drawing:Remove()
        end
        return #allDrawings >= 5
    end))
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
