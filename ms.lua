-- Brainrot Nexus — Steal a Brainrot Edition (Single-file, loadstring-ready)
-- by Mohammed
-- Usage: loadstring(game:HttpGet("RAW_RAW_RAW_LINK"))()

-- ====== safety wrappers & helpers ======
local OK, ERR = pcall, tostring
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ensure player present
if not LocalPlayer then
    return error("LocalPlayer not found. Run this in a client executor.")
end

-- simple logger
local function log(...) 
    local s = ""
    for i=1,select("#",...) do s = s .. tostring(select(i,...)) .. "\t" end
    print("[BrainrotNexus]", s)
end

-- Debounce / safe wait
local function swait(t) task.wait(t or 0.01) end

-- ====== persistent state & cleanup tables ======
local State = {
    gui = nil,
    connections = {},
    drawings = {},
    espBillboards = {},
    fly = false,
    noclip = false,
    autoCollect = false,
    afk = false,
    fullbright = false,
    speed = 30,
    jumpPower = 70,
    flySpeed = 60,
    autosettings = {},
    enabled = true,
}

local conns = {} -- store connection objects for cleanup per-character
local function addConn(c) table.insert(conns, c) end
local function clearConns()
    for _,c in ipairs(conns) do
        if c and c.Disconnect then
            pcall(function() c:Disconnect() end)
        elseif c and c.disconnect then
            pcall(function() c:disconnect() end)
        end
    end
    conns = {}
end

-- ====== Utilities: safe get character parts ======
local function waitForChar(timeout)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if timeout then
        local ok, c = pcall(function() return LocalPlayer.Character end)
        if not ok or not c then
            char = LocalPlayer.CharacterAdded:Wait()
        end
    end
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return char, hrp, hum
end

-- ====== Notifications (GUI toast) ======
local function toast(text, duration)
    duration = duration or 3
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end
    local sg = Instance.new("ScreenGui")
    sg.Name = "BN_Toaster_" .. tostring(math.random(1000,9999))
    sg.ResetOnSpawn = false
    sg.Parent = pg

    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 420, 0, 48)
    frame.Position = UDim2.new(0.5, -210, 0.07, 0)
    frame.BackgroundColor3 = Color3.fromRGB(18,18,26)
    frame.BorderSizePixel = 0
    frame.ZIndex = 9999
    frame.AnchorPoint = Vector2.new(0.5,0)
    local corner = Instance.new("UICorner", frame); corner.CornerRadius = UDim.new(0,8)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -24, 1, 0)
    label.Position = UDim2.new(0,12,0,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(160,255,220)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.32, Enum.EasingStyle.Sine), {Position = UDim2.new(0.5, -210, 0.07, 0)})
    frame.Position = UDim2.new(0.5, -210, -0.2, 0)
    pcall(function() tweenIn:Play() end)
    task.delay(duration, function()
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Sine), {Position = UDim2.new(0.5, -210, -0.2, 0)})
        pcall(function() tweenOut:Play() end)
        tweenOut.Completed:Wait()
        pcall(function() sg:Destroy() end)
    end)
end

-- ====== Create/Destroy GUI (rebuildable on respawn) ======
local function safeDestroyGui()
    if State.gui and State.gui.Parent then
        pcall(function() State.gui:Destroy() end)
    end
    State.gui = nil
    -- clear drawings and billboards
    for _,v in pairs(State.drawings or {}) do
        pcall(function() v:Remove() end)
    end
    State.drawings = {}
    for _,bb in pairs(State.espBillboards or {}) do
        pcall(function() bb:Destroy() end)
    end
    State.espBillboards = {}
end

-- small UI builder helpers
local function make(parent, class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

-- ====== ESP Implementation (tries Drawing, fallback BillboardGui) ======
local DrawingAvailable = (type(draw) == "function") or (type(Drawing) == "table")
local function createESPForPart(part)
    if not part then return end
    if DrawingAvailable then
        local line = Drawing.new("Text")
        line.Text = part.Name
        line.Size = 16
        line.Visible = true
        line.Color = Color3.new(0.8,1,0.8)
        table.insert(State.drawings, line)
        return line, "drawing"
    else
        local bb = Instance.new("BillboardGui")
        bb.Adornee = part
        bb.Size = UDim2.new(0, 100, 0, 30)
        bb.StudsOffset = Vector3.new(0,1.6,0)
        local txt = Instance.new("TextLabel", bb)
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.Text = part.Name
        txt.TextColor3 = Color3.fromRGB(160,255,220)
        txt.Font = Enum.Font.Gotham
        txt.TextSize = 12
        bb.Parent = State.gui
        table.insert(State.espBillboards, bb)
        return bb, "bb"
    end
end

local function updateESPs()
    if not State.gui then return end
    if DrawingAvailable then
        -- update drawing texts positions
        for i,drawObj in ipairs(State.drawings) do
            local part = drawObj._part
            if part and part.Parent then
                local cf = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if cf.Z > 0 then
                    drawObj.Position = Vector2.new(cf.X, cf.Y)
                    drawObj.Visible = true
                else
                    drawObj.Visible = false
                end
            else
                drawObj.Visible = false
            end
        end
    else
        -- BillboardGui handled by Roblox engine automatically
    end
end

local function refreshESP(targetNames)
    -- clear old
    for _,v in pairs(State.drawings or {}) do pcall(function() v:Remove() end) end
    State.drawings = {}
    for _,bb in pairs(State.espBillboards or {}) do pcall(function() bb:Destroy() end) end
    State.espBillboards = {}

    -- gather parts
    local parts = {}
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nm = (obj.Name or ""):lower()
            for _,tn in ipairs(targetNames) do
                if nm:find(tn) then
                    table.insert(parts, obj)
                end
            end
            if obj:GetAttribute("IsCollectable") then
                table.insert(parts, obj)
            end
        end
    end

    for _,p in ipairs(parts) do
        local dr, kind = createESPForPart(p)
        if dr and kind=="drawing" then dr._part = p end
    end
end

-- ====== Core Features ======

-- Fly: robust BodyGyro/BodyVelocity approach, cleaned on disable
local flyCon = nil
local flyBG, flyBV = nil, nil
local function toggleFly(enable)
    State.fly = enable
    local char, hrp, hum = waitForChar()
    if enable then
        if not hrp then return end
        if flyCon then pcall(function() flyCon:Disconnect() end) end
        flyBG = Instance.new("BodyGyro")
        flyBG.P = 9e4
        flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
        flyBG.Parent = hrp
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
        flyBV.Velocity = Vector3.new(0,0,0)
        flyBV.Parent = hrp

        flyCon = RunService.RenderStepped:Connect(function()
            if not State.fly then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            flyBG.CFrame = cam.CFrame
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
            if move.Magnitude > 0 then
                flyBV.Velocity = move.Unit * (State.flySpeed or 60)
            else
                flyBV.Velocity = Vector3.new(0,0,0)
            end
        end)
        toast("Fly enabled")
    else
        pcall(function()
            if flyCon then flyCon:Disconnect() end
            if flyBG and flyBG.Parent then flyBG:Destroy() end
            if flyBV and flyBV.Parent then flyBV:Destroy() end
        end)
        flyCon = nil; flyBG = nil; flyBV = nil
        toast("Fly disabled")
    end
end

-- NoClip: periodic set CanCollide = false
local noclipCon = nil
local function toggleNoClip(enable)
    State.noclip = enable
    if enable then
        if noclipCon then pcall(function() noclipCon:Disconnect() end) end
        noclipCon = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _,part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function() part.CanCollide = false end)
                    end
                end
            end
        end)
        toast("NoClip ON")
    else
        if noclipCon then pcall(function() noclipCon:Disconnect() end) end
        noclipCon = nil
        -- try to restore collisions
        local char = LocalPlayer.Character
        if char then
            for _,part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = true end)
                end
            end
        end
        toast("NoClip OFF")
    end
end

-- Speed & Jump apply on CharacterAdded and each render
local function applyMovementSettings()
    local char, hrp, hum = waitForChar()
    if hum then
        pcall(function() hum.WalkSpeed = State.speed or 30 end)
        pcall(function() hum.JumpPower = State.jumpPower or 70 end)
    end
end

-- AutoCollect: tries to be safe and server-friendly
local function collectPartServerSafe(part)
    if not part or not part:IsA("BasePart") then return end
    -- attempt to use Remote if exists
    local remote = ReplicatedStorage:FindFirstChild("RequestCollect") or ReplicatedStorage:FindFirstChild("CollectRequest")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer(part) end)
        return true
    end
    -- else try firetouchinterest if available (exploit function)
    if type(firetouchinterest) == "function" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 0)
            task.wait(0.06)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 1)
        end)
        return true
    end
    -- fallback: brief teleport near part (risky, might trigger anti-cheat)
    pcall(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local old = char.HumanoidRootPart.CFrame
            char.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0,3,0)
            task.wait(0.18)
            char.HumanoidRootPart.CFrame = old
        end
    end)
    return true
end

local autoCollectThread = nil
local function toggleAutoCollect(enable, targetNames)
    State.autoCollect = enable
    if enable then
        toast("AutoCollect ON")
        if autoCollectThread then pcall(function() autoCollectThread:Cancel() end) end
        autoCollectThread = coroutine.create(function()
            while State.autoCollect do
                local char, hrp, hum = waitForChar()
                if not hrp then task.wait(1) else
                    local found = {}
                    for _,obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            local nm = (obj.Name or ""):lower()
                            local isTarget = false
                            for _,tn in ipairs(targetNames) do
                                if nm:find(tn) then isTarget = true; break end
                            end
                            if obj:GetAttribute("IsCollectable") then isTarget = true end
                            if isTarget then
                                table.insert(found, obj)
                            end
                        end
                    end
                    table.sort(found, function(a,b)
                        local da = (a.Position - hrp.Position).Magnitude
                        local db = (b.Position - hrp.Position).Magnitude
                        return da < db
                    end)
                    for _,part in ipairs(found) do
                        if not State.autoCollect then break end
                        pcall(function() collectPartServerSafe(part) end)
                        task.wait(0.35)
                    end
                end
                task.wait(0.6)
            end
        end)
        coroutine.resume(autoCollectThread)
    else
        State.autoCollect = false
        toast("AutoCollect OFF")
    end
end

-- Anti-AFK: VirtualUser click
local afkThread = nil
local function toggleAFK(enable)
    State.afk = enable
    local vu = game:GetService("VirtualUser")
    if enable then
        toast("Anti-AFK ON")
        if afkThread then pcall(function() afkThread:Cancel() end) end
        afkThread = coroutine.create(function()
            while State.afk do
                pcall(function()
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new(0,0))
                end)
                task.wait(50)
            end
        end)
        coroutine.resume(afkThread)
    else
        State.afk = false
        toast("Anti-AFK OFF")
    end
end

-- FullBright toggle (local)
local prevLighting = {}
local function toggleFullBright(enable)
    State.fullbright = enable
    if enable then
        prevLighting.Brightness = Lighting.Brightness
        prevLighting.Ambient = Lighting.Ambient
        prevLighting.OutdoorAmbient = Lighting.OutdoorAmbient
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        toast("FullBright ON")
    else
        Lighting.Brightness = prevLighting.Brightness or 1
        Lighting.Ambient = prevLighting.Ambient or Color3.new(0,0,0)
        Lighting.OutdoorAmbient = prevLighting.OutdoorAmbient or Color3.new(0,0,0)
        toast("FullBright OFF")
    end
end

-- Toggle door by name (fires remote if server has event)
local function toggleDoor(doorName)
    local remote = ReplicatedStorage:FindFirstChild("ToggleDoorEvent")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer(doorName) end)
        toast("Requested door toggle: "..tostring(doorName))
        return
    end
    -- fallback: change workspace Doors
    local doors = workspace:FindFirstChild("Doors")
    if not doors then toast("No Doors folder found"); return end
    local door = doors:FindFirstChild(doorName)
    if not door then toast("Door not found: "..tostring(doorName)); return end
    local locked = door:FindFirstChild("Locked") or Instance.new("BoolValue", door)
    locked.Name = "Locked"
    locked.Value = not locked.Value
    local doorPart = door:FindFirstChild("DoorPart")
    if doorPart and doorPart:IsA("BasePart") then
        doorPart.Transparency = locked.Value and 0.5 or 0
        doorPart.CanCollide = not locked.Value
    end
    toast("Door "..doorName.." locked state: "..tostring(locked.Value))
end

-- AutoBuy: attempts to use a BuyPetEvent or BuyEvent remote
local function autoBuy(petName, price)
    local rem = ReplicatedStorage:FindFirstChild("BuyPetEvent") or ReplicatedStorage:FindFirstChild("BuyEvent")
    if rem and rem:IsA("RemoteEvent") then
        pcall(function() rem:FireServer(petName, price) end)
        toast("Attempted buy: "..tostring(petName).." for "..tostring(price))
    else
        toast("Buy remote not found")
    end
end

-- Teleport presets (user can add spots)
local Teleports = {
    ["Spawn"] = CFrame.new(0,5,0),
    -- add map-specific spots later
}
local function teleportTo(name)
    local char, hrp = waitForChar()
    if hrp and Teleports[name] then
        pcall(function() hrp.CFrame = Teleports[name] end)
        toast("Teleported to "..name)
    end
end

-- ====== GUI: Tabbed, Toggles, Sliders, Dropdowns ======
local function buildGui()
    safeDestroyGui()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return end
    local sg = Instance.new("ScreenGui", pg)
    sg.Name = "BrainrotNexusGUI"
    sg.ResetOnSpawn = false
    State.gui = sg

    local main = make(sg, "Frame", {
        Name = "Main",
        Size = UDim2.new(0, 720, 0, 480),
        Position = UDim2.new(0.16, 0, 0.12, 0),
        BackgroundColor3 = Color3.fromRGB(12,12,18),
        Active = true,
        Draggable = true,
    })
    make(main, "UICorner", {CornerRadius = UDim.new(0,12)})

    local header = make(main, "Frame", {Size = UDim2.new(1,0,0,64), BackgroundTransparency = 1})
    local title = make(header, "TextLabel", {
        Size = UDim2.new(0.6,0,1,0),
        Position = UDim2.new(0.02,0,0,0),
        BackgroundTransparency = 1,
        Text = "🛰️ Brainrot Nexus — Premium",
        TextColor3 = Color3.fromRGB(0,220,180),
        Font = Enum.Font.GothamBold,
        TextSize = 22,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local vtxt = make(header, "TextLabel", {
        Size = UDim2.new(0.2,0,1,0),
        Position = UDim2.new(0.78,0,0,0),
        BackgroundTransparency = 1,
        Text = "v1.2",
        TextColor3 = Color3.fromRGB(200,200,200),
        Font = Enum.Font.Gotham,
        TextSize = 14,
    })

    -- left tabs column
    local tabs = {"Movement","Farming","ESP","Misc","Settings"}
    local tabButtons = {}
    for i,name in ipairs(tabs) do
        local btn = make(main, "TextButton", {
            Size = UDim2.new(0, 140, 0, 44),
            Position = UDim2.new(0, 18, 0, 80 + (i-1)*52),
            Text = name,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            BackgroundColor3 = Color3.fromRGB(18,18,26),
            TextColor3 = Color3.fromRGB(220,220,220)
        })
        make(btn, "UICorner", {CornerRadius = UDim.new(0,8)})
        table.insert(tabButtons, btn)
    end

    local content = make(main, "Frame", {
        Size = UDim2.new(0, 520, 0, 360),
        Position = UDim2.new(0, 180, 0, 80),
        BackgroundTransparency = 1,
    })

    -- helper to clear content children
    local function clearContent()
        for _,c in ipairs(content:GetChildren()) do
            if not (c:IsA("UIListLayout")) then pcall(function() c:Destroy() end) end
        end
    end

    -- UI element makers inside content
    local function makeToggle(y, text, init, callback)
        local frame = make(content, "Frame", {Size = UDim2.new(1,0,0,40), Position = UDim2.new(0,0,0, y), BackgroundTransparency = 1})
        local label = make(frame, "TextLabel", {Size = UDim2.new(0.72,0,1,0), Position = UDim2.new(0,6,0,0), BackgroundTransparency = 1, Text = text, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.fromRGB(220,220,220)})
        local tbtn = make(frame, "TextButton", {Size = UDim2.new(0,86,0,26), Position = UDim2.new(1,-96,0,7), BackgroundColor3 = init and Color3.fromRGB(40,160,90) or Color3.fromRGB(60,60,80), Text = init and "ON" or "OFF", Font = Enum.Font.GothamBold, TextSize = 13})
        make(tbtn, "UICorner", {CornerRadius = UDim.new(0,6)})
        local state = init
        tbtn.MouseButton1Click:Connect(function()
            state = not state
            tbtn.BackgroundColor3 = state and Color3.fromRGB(40,160,90) or Color3.fromRGB(60,60,80)
            tbtn.Text = state and "ON" or "OFF"
            pcall(callback, state)
        end)
        return frame
    end

    local function makeSlider(y, text, minv, maxv, initv, callback)
        local frame = make(content, "Frame", {Size = UDim2.new(1,0,0,52), Position = UDim2.new(0,0,0,y), BackgroundTransparency = 1})
        local label = make(frame, "TextLabel", {Size=UDim2.new(0.7,0,0,20), Position=UDim2.new(0,6,0,4), BackgroundTransparency=1, Text=text, TextColor3=Color3.fromRGB(220,220,220), Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left})
        local valTxt = make(frame, "TextLabel", {Size=UDim2.new(0.28, -12, 0,20), Position=UDim2.new(0.72,6,0,4), BackgroundTransparency=1, Text=tostring(initv), TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Right})
        local bar = make(frame, "Frame", {Size=UDim2.new(1,-20,0,12), Position=UDim2.new(0,10,0,28), BackgroundColor3=Color3.fromRGB(36,36,44)})
        make(bar, "UICorner", {CornerRadius=UDim.new(0,6)})
        local fill = make(bar, "Frame", {Size=UDim2.new((initv-minv)/(maxv-minv),0,1,0), BackgroundColor3=Color3.fromRGB(0,200,150)})
        make(fill, "UICorner", {CornerRadius=UDim.new(0,6)})
        -- drag support
        local dragging = false
        bar.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        bar.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(inp)
            if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                local mx = UserInputService:GetMouseLocation().X
                local absPos = bar.AbsolutePosition.X
                local w = bar.AbsoluteSize.X
                local rel = math.clamp((mx - absPos) / w, 0, 1)
                fill.Size = UDim2.new(rel,0,1,0)
                local val = minv + (maxv - minv) * rel
                val = math.floor(val*10)/10
                valTxt.Text = tostring(val)
                pcall(callback, val)
            end
        end)
        return frame
    end

    local function makeButton(y, text, cb)
        local btn = make(content, "TextButton", {Size=UDim2.new(1, -20, 0, 36), Position=UDim2.new(0, 10, 0, y), Text=text, Font=Enum.Font.Gotham, TextSize=15, BackgroundColor3=Color3.fromRGB(30,30,40), TextColor3=Color3.fromRGB(240,240,240)})
        make(btn, "UICorner", {CornerRadius=UDim.new(0,8)})
        btn.MouseButton1Click:Connect(function() pcall(cb) end)
    end

    -- Tab content functions
    local function showMovement()
        clearContent()
        makeToggle(0, "Fly (F)", false, function(s) toggleFly(s) end)
        makeSlider(48, "Fly Speed", 10, 200, State.flySpeed, function(v) State.flySpeed = v end)
        makeSlider(108, "Walk Speed", 10, 200, State.speed, function(v) State.speed = v; applyMovementSettings() end)
        makeSlider(168, "Jump Power", 10, 250, State.jumpPower, function(v) State.jumpPower = v; applyMovementSettings() end)
        makeToggle(228, "NoClip", false, function(s) toggleNoClip(s) end)
    end

    local function showFarming()
        clearContent()
        makeToggle(0, "Auto Collect (Brainrot/Coin)", false, function(s)
            -- target names tuned for Steal a Brainrot
            local targets = {"brainrot","brain rot","coin","pickup","cash","loot"}
            toggleAutoCollect(s, targets)
        end)
        makeSlider(56, "Collect Delay (sec)", 0.1, 1.5, 0.6, function(v) State.autosettings.collectDelay = v end)
        makeButton(120, "Auto Buy Selected Pet", function()
            -- simple dropdown emulation: prompt via InputDialog (fallback)
            local petName = tostring(LocalPlayer.Name) -- placeholder
            -- attempt to buy first pet in ReplicatedStorage.Pets if any
            local pf = ReplicatedStorage:FindFirstChild("Pets")
            if pf and #pf:GetChildren() > 0 then
                local pet = pf:GetChildren()[1]
                autoBuy(pet.Name, 50)
            else
                toast("No Pets folder found")
            end
        end)
        makeToggle(168, "AFK Farm (Anti-AFK)", false, function(s) toggleAFK(s) end)
        makeButton(212, "Teleport to Spawn", function() teleportTo("Spawn") end)
    end

    local function showESP()
        clearContent()
        makeToggle(0, "ESP Items (Brainrots & Coins)", false, function(s)
            if s then
                refreshESP({"brainrot","coin","pickup","cash","loot"})
                toast("ESP enabled (items)")
            else
                refreshESP({})
                toast("ESP disabled")
            end
        end)
        makeToggle(56, "FullBright", false, function(s) toggleFullBright(s) end)
        makeToggle(112, "Tracers (offscreen)", false, function(s) toast("Tracers not implemented in lite") end)
        makeButton(168, "Refresh ESP Now", function() refreshESP({"brainrot","coin","pickup","cash","loot"}) end)
        makeButton(212, "Clear ESP", function() refreshESP({}) end)
    end

    local function showMisc()
        clearContent()
        makeButton(0, "Unlock All Doors", function()
            -- iterate workspace and set parts named door non-collide
            for _,d in ipairs(workspace:GetDescendants()) do
                if d:IsA("BasePart") and (tostring(d.Name):lower():find("door")) then
                    pcall(function() d.CanCollide = false; d.Transparency = 0.5 end)
                end
            end
            toast("Attempted unlock of doors")
        end)
        makeButton(56, "Toggle Door (Door1)", function() toggleDoor("Door1") end)
        makeButton(112, "Buy Example Pet", function() autoBuy("Dog", 50) end)
        makeButton(168, "Hide/Show GUI (RightShift)", function() 
            State.gui.Enabled = not State.gui.Enabled
        end)
        makeButton(220, "Unload Brainrot Nexus", function()
            -- cleanup
            State.enabled = false
            toggleFly(false)
            toggleNoClip(false)
            toggleAutoCollect(false, {})
            toggleAFK(false)
            toggleFullBright(false)
            safeDestroyGui()
            toast("Brainrot Nexus Unloaded")
        end)
    end

    local function showSettings()
        clearContent()
        makeSlider(0, "Accent / Noop", 0, 1, 0.5, function(v) end)
        makeButton(64, "Save Settings (session)", function() 
            -- save to player attribute as JSON session
            local ok, err = pcall(function()
                LocalPlayer:SetAttribute("BN_Settings", HttpService:JSONEncode({
                    speed = State.speed,
                    jumpPower = State.jumpPower,
                    flySpeed = State.flySpeed
                }))
            end)
            if ok then toast("Settings saved for this session") else toast("Save failed") end
        end)
        makeButton(120, "Load Settings (session)", function()
            local j = LocalPlayer:GetAttribute("BN_Settings")
            if j and j ~= "" then
                local ok, t = pcall(function() return HttpService:JSONDecode(j) end)
                if ok and type(t)=="table" then
                    State.speed = t.speed or State.speed
                    State.jumpPower = t.jumpPower or State.jumpPower
                    State.flySpeed = t.flySpeed or State.flySpeed
                    applyMovementSettings()
                    toast("Settings loaded")
                else toast("No saved settings") end
            else toast("No saved settings") end
        end)
        makeToggle(188, "Auto-load on Respawn", true, function(s) State.autosettings.reloadOnRespawn = s end)
    end

    -- connect tabs
    tabButtons[1].MouseButton1Click:Connect(showMovement)
    tabButtons[2].MouseButton1Click:Connect(showFarming)
    tabButtons[3].MouseButton1Click:Connect(showESP)
    tabButtons[4].MouseButton1Click:Connect(showMisc)
    tabButtons[5].MouseButton1Click:Connect(showSettings)

    -- show default
    showMovement()

    -- keybinds: F toggle fly, RightShift hide GUI
    addConn(UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == Enum.KeyCode.F then
            toggleFly(not State.fly)
        elseif inp.KeyCode == Enum.KeyCode.RightShift then
            State.gui.Enabled = not State.gui.Enabled
        end
    end))

    -- RenderStepped draw update
    addConn(RunService.RenderStepped:Connect(function()
        if not State.enabled then return end
        updateESPs()
        applyMovementSettings()
    end))
end

-- ====== Respawn handling: inject GUI & reapply settings ======
local function onCharacterAdded(char)
    task.wait(0.8)
    applyMovementSettings()
    if State.gui == nil then
        -- rebuild GUI after respawn
        buildGui()
    end
    -- reapply active features
    if State.fly then toggleFly(true) end
    if State.noclip then toggleNoClip(true) end
    if State.autoCollect then toggleAutoCollect(true, {"brainrot","coin","pickup","cash","loot"}) end
    if State.afk then toggleAFK(true) end
    if State.fullbright then toggleFullBright(true) end
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
-- if character exists already
if LocalPlayer.Character then
    task.spawn(function() onCharacterAdded(LocalPlayer.Character) end)
end

-- ====== init ======
buildGui()
toast("✅ Brainrot Nexus Injected — Ready", 3)

-- End of script
