-- Brainrot Hub v5.0 — Ultimate Fly (Space hold)
-- Made by Mohammed
-- SINGLE FILE: loadstring-able
-- Usage (example): loadstring(game:HttpGet("RAW_LINK"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ---------- State ----------
local State = {
    gui = nil,
    enabled = true,
    flyMode = false,        -- master fly enabled (so keys control it)
    flyHold = false,        -- whether space is currently held
    flySpeed = 80,          -- flight speed multiplier
    walkSpeed = 30,
    jumpPower = 70,
    noclip = false,
    autoCollect = false,
    autoSteal = false,
    esp = false,
    fullbright = false,
    antiAFK = true,
    antiKnock = true,
    savedBaseCFrame = nil,
    autosettings = {},
    connections = {},
}

-- Settings storage (session or filesystem if available)
local SETTINGS_FILE = "BrainrotHub_v5.json"
local function saveSettings()
    local s = {
        flySpeed = State.flySpeed,
        walkSpeed = State.walkSpeed,
        jumpPower = State.jumpPower,
        noclip = State.noclip,
        esp = State.esp,
        fullbright = State.fullbright,
        antiKnock = State.antiKnock,
    }
    pcall(function()
        if writefile then
            writefile(SETTINGS_FILE, HttpService:JSONEncode(s))
        else
            LocalPlayer:SetAttribute("BN_Settings", HttpService:JSONEncode(s))
        end
    end)
end
local function loadSettings()
    pcall(function()
        if readfile and isfile and isfile(SETTINGS_FILE) then
            local j = readfile(SETTINGS_FILE)
            local ok, t = pcall(HttpService.JSONDecode, HttpService, j)
            if ok and type(t) == "table" then
                State.flySpeed = t.flySpeed or State.flySpeed
                State.walkSpeed = t.walkSpeed or State.walkSpeed
                State.jumpPower = t.jumpPower or State.jumpPower
                State.noclip = t.noclip or State.noclip
                State.esp = t.esp or State.esp
                State.fullbright = t.fullbright or State.fullbright
                State.antiKnock = t.antiKnock or State.antiKnock
            end
        else
            local j = LocalPlayer:GetAttribute("BN_Settings")
            if j and j ~= "" then
                local ok, t = pcall(HttpService.JSONDecode, HttpService, j)
                if ok and type(t) == "table" then
                    State.flySpeed = t.flySpeed or State.flySpeed
                    State.walkSpeed = t.walkSpeed or State.walkSpeed
                    State.jumpPower = t.jumpPower or State.jumpPower
                    State.noclip = t.noclip or State.noclip
                    State.esp = t.esp or State.esp
                    State.fullbright = t.fullbright or State.fullbright
                    State.antiKnock = t.antiKnock or State.antiKnock
                end
            end
        end
    end)
end
loadSettings()

-- ---------- Utilities ----------
local function safeNotify(text, duration)
    duration = duration or 3
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "BN_Toaster_"..tostring(math.random(1000,9999))
        sg.ResetOnSpawn = false
        sg.Parent = PlayerGui

        local frame = Instance.new("Frame", sg)
        frame.Size = UDim2.new(0, 420, 0, 48)
        frame.Position = UDim2.new(0.5, -210, 0.07, 0)
        frame.AnchorPoint = Vector2.new(0.5,0)
        frame.BackgroundColor3 = Color3.fromRGB(18,18,26)
        frame.BorderSizePixel = 0
        local corner = Instance.new("UICorner", frame); corner.CornerRadius = UDim.new(0,8)

        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(1, -24, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(160,255,220)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 16
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        spawn(function()
            task.wait(duration)
            pcall(function() sg:Destroy() end)
        end)
    end)
end

local function addConn(conn)
    table.insert(State.connections, conn)
    return conn
end
local function clearConns()
    for _,c in ipairs(State.connections) do
        pcall(function()
            if c.Disconnect then c:Disconnect() end
            if c.disconnect then c:disconnect() end
        end)
    end
    State.connections = {}
end

local function waitForCharacter()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    return char, hrp, hum
end

-- ---------- GUI builder ----------
local function destroyGui()
    pcall(function()
        if State.gui and State.gui.Parent then State.gui:Destroy() end
        State.gui = nil
    end)
end

local function make(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function buildGui()
    destroyGui()
    local sg = make("ScreenGui",{Name="BrainrotHub_v5", ResetOnSpawn=false, Parent=PlayerGui})
    State.gui = sg

    local main = make("Frame",{
        Name="Main", Parent=sg,
        Size=UDim2.new(0, 760, 0, 480),
        Position=UDim2.new(0.12,0,0.08,0),
        BackgroundColor3=Color3.fromRGB(12,12,18),
        Active=true, Draggable=true,
    })
    make("UICorner",{Parent=main, CornerRadius=UDim.new(0,12)})

    local header = make("Frame",{Parent=main, Size=UDim2.new(1,0,0,64), BackgroundTransparency=1})
    make("TextLabel",{Parent=header, Size=UDim2.new(0.6,0,1,0), Position=UDim2.new(0.02,0,0,0), BackgroundTransparency=1,
        Text="🛰️ Brainrot Hub v5.0", TextColor3=Color3.fromRGB(0,220,180), Font=Enum.Font.GothamBold, TextSize=24, TextXAlignment=Enum.TextXAlignment.Left})
    make("TextLabel",{Parent=header, Size=UDim2.new(0.2,0,1,0), Position=UDim2.new(0.78,0,0,0), BackgroundTransparency=1,
        Text="Premium", TextColor3=Color3.fromRGB(200,200,200), Font=Enum.Font.Gotham, TextSize=14})

    -- tabs column
    local tabs = make("Frame",{Parent=main, Size=UDim2.new(0,160,1,-64), Position=UDim2.new(0,0,0,64), BackgroundColor3=Color3.fromRGB(18,18,24)})
    make("UIListLayout",{Parent=tabs, Padding=UDim.new(0,6), FillDirection=Enum.FillDirection.Vertical})
    make("UIPadding",{Parent=tabs, PaddingLeft=UDim.new(0,8), PaddingTop=UDim.new(0,8)})

    -- content area
    local content = make("Frame",{Parent=main, Size=UDim2.new(1,-160,1,-64), Position=UDim2.new(0,160,0,64), BackgroundTransparency=1})
    make("UICorner",{Parent=content, CornerRadius=UDim.new(0,8)})

    -- helper to create panels
    local panels = {}
    local function newTab(name)
        local btn = make("TextButton",{Parent=tabs, Size=UDim2.new(1,-12,0,36), Text=name, Font=Enum.Font.Gotham, TextSize=16, TextColor3=Color3.fromRGB(230,230,230), BackgroundColor3=Color3.fromRGB(24,24,34)})
        make("UICorner",{Parent=btn, CornerRadius=UDim.new(0,6)})
        local panel = make("ScrollingFrame",{Parent=content, Size=UDim2.new(1,0,1,0), Visible=false, ScrollBarThickness=6})
        panel.CanvasSize = UDim2.new(0,0,0,0)
        panels[name] = panel
        btn.MouseButton1Click:Connect(function()
            for _,v in pairs(panels) do v.Visible = false end
            panel.Visible = true
        end)
        return panel
    end

    local function uiButton(parent, text, ycall)
        local btn = make("TextButton",{Parent=parent, Size=UDim2.new(1,-24,0,40), Position=UDim2.new(0,12,0,0), Text=text, Font=Enum.Font.Gotham, TextSize=16, BackgroundColor3=Color3.fromRGB(30,30,42)})
        make("UICorner",{Parent=btn, CornerRadius=UDim.new(0,8)})
        btn.MouseButton1Click:Connect(function() pcall(ycall) end)
        return btn
    end

    local function uiToggle(parent, label, init, cb)
        local frame = make("Frame",{Parent=parent, Size=UDim2.new(1,-24,0,42), BackgroundTransparency=1})
        local lbl = make("TextLabel",{Parent=frame, Size=UDim2.new(0.68,0,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=label, Font=Enum.Font.Gotham, TextSize=16, TextColor3=Color3.fromRGB(230,230,230), TextXAlignment=Enum.TextXAlignment.Left})
        local btn = make("TextButton",{Parent=frame, Size=UDim2.new(0,86,0,28), Position=UDim2.new(1,-98,0,7), Text=(init and "ON" or "OFF"), BackgroundColor3=(init and Color3.fromRGB(40,160,90) or Color3.fromRGB(60,60,80)), Font=Enum.Font.GothamBold, TextSize=14})
        make("UICorner",{Parent=btn, CornerRadius=UDim.new(0,6)})
        local st = init
        btn.MouseButton1Click:Connect(function()
            st = not st
            btn.BackgroundColor3 = st and Color3.fromRGB(40,160,90) or Color3.fromRGB(60,60,80)
            btn.Text = st and "ON" or "OFF"
            pcall(cb, st)
        end)
        return frame
    end

    local function uiSlider(parent, label, minv, maxv, initv, cb)
        local frame = make("Frame",{Parent=parent, Size=UDim2.new(1,-24,0,64), BackgroundTransparency=1})
        local lbl = make("TextLabel",{Parent=frame, Size=UDim2.new(0.66,0,0,20), Position=UDim2.new(0,6,0,6), BackgroundTransparency=1, Text=label, Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(220,220,220), TextXAlignment=Enum.TextXAlignment.Left})
        local val = make("TextLabel",{Parent=frame, Size=UDim2.new(0.3,-12,0,20), Position=UDim2.new(0.7,6,0,6), BackgroundTransparency=1, Text=tostring(initv), Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(200,200,200), TextXAlignment=Enum.TextXAlignment.Right})
        local bar = make("Frame",{Parent=frame, Size=UDim2.new(1,-32,0,14), Position=UDim2.new(0,16,0,34), BackgroundColor3=Color3.fromRGB(36,36,44)})
        make("UICorner",{Parent=bar, CornerRadius=UDim.new(0,6)})
        local fill = make("Frame",{Parent=bar, Size=UDim2.new((initv-minv)/(maxv-minv),0,1,0), BackgroundColor3=Color3.fromRGB(0,200,150)})
        make("UICorner",{Parent=fill, CornerRadius=UDim.new(0,6)})
        local dragging = false
        bar.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
        bar.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        addConn(UserInputService.InputChanged:Connect(function(inp)
            if not dragging then return end
            if inp.UserInputType==Enum.UserInputType.MouseMovement then
                local mx = UserInputService:GetMouseLocation().X
                local posX = bar.AbsolutePosition.X
                local w = bar.AbsoluteSize.X
                local rel = math.clamp((mx - posX) / w, 0, 1)
                fill.Size = UDim2.new(rel,0,1,0)
                local valnum = minv + (maxv - minv) * rel
                valnum = math.floor(valnum*10)/10
                val.Text = tostring(valnum)
                pcall(cb, valnum)
            end
        end))
        return frame
    end

    -- build tabs content
    local movementPanel = panels["Movement"] or newTab("Movement"); panels["Movement"] = movementPanel
    local farmingPanel = panels["Farming"] or newTab("Farming"); panels["Farming"] = farmingPanel
    local espPanel = panels["ESP"] or newTab("ESP"); panels["ESP"] = espPanel
    local tpPanel = panels["Teleports"] or newTab("Teleports"); panels["Teleports"] = tpPanel
    local miscPanel = panels["Misc"] or newTab("Misc"); panels["Misc"] = miscPanel
    local settingsPanel = panels["Settings"] or newTab("Settings"); panels["Settings"] = settingsPanel

    -- Movement UI
    uiToggle(movementPanel, "Enable Fly Mode (hold Space)", State.flyMode, function(s) State.flyMode = s end)
    uiSlider(movementPanel, "Flight Speed", 10, 250, State.flySpeed, function(v) State.flySpeed = v end)
    uiSlider(movementPanel, "Walk Speed", 8, 250, State.walkSpeed, function(v) State.walkSpeed = v end)
    uiSlider(movementPanel, "Jump Power", 10, 250, State.jumpPower, function(v) State.jumpPower = v end)
    uiToggle(movementPanel, "NoClip", State.noclip, function(s) State.noclip = s end)

    -- Farming UI
    uiToggle(farmingPanel, "Auto Collect (AutoSteal)", State.autoCollect, function(s)
        State.autoCollect = s
        if s then safeNotify("AutoCollect ON") end
    end)
    uiButton(farmingPanel, "Instant Steal (one pass)", function()
        local ok, char = pcall(function() return LocalPlayer.Character end)
        if not ok or not char or not char:FindFirstChild("HumanoidRootPart") then safeNotify("No character"); return end
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local nm = (obj.Name or ""):lower()
                if nm:find("brainrot") or nm:find("brain rot") or obj:GetAttribute("IsCollectable") then
                    pcall(function()
                        firetouchinterest(char.HumanoidRootPart, obj, 0)
                        task.wait(0.06)
                        firetouchinterest(char.HumanoidRootPart, obj, 1)
                    end)
                end
            end
        end
        safeNotify("Instant steal pass finished")
    end)
    uiToggle(farmingPanel, "Auto Steal (continuous)", State.autoSteal, function(s) State.autoSteal = s end)
    uiButton(farmingPanel, "Auto Buy Example (tries common remotes)", function()
        local rem = ReplicatedStorage:FindFirstChild("BuyPetEvent") or ReplicatedStorage:FindFirstChild("BuyEvent") or ReplicatedStorage:FindFirstChild("BuyUpgradeEvent")
        if rem and rem.FireServer then
            pcall(function() rem:FireServer("Example", 50) end)
            safeNotify("Tried to buy Example")
        else safeNotify("Buy remote not found") end
    end)

    -- ESP UI
    uiToggle(espPanel, "ESP (Players & Items)", State.esp, function(s) State.esp = s end)
    uiButton(espPanel, "Refresh ESP Now", function()
        -- will be handled in loop
        safeNotify("ESP refresh requested")
    end)
    uiToggle(espPanel, "FullBright (Local)", State.fullbright, function(s)
        State.fullbright = s
        if s then
            pcall(function()
                Lighting.Brightness = 2
                Lighting.Ambient = Color3.new(1,1,1)
                Lighting.OutdoorAmbient = Color3.new(1,1,1)
            end)
        else
            pcall(function()
                Lighting.Brightness = 1
                Lighting.Ambient = Color3.new(0,0,0)
            end)
        end
    end)

    -- Teleports UI
    uiButton(tpPanel, "Teleport to Nearest Brainrot", function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then safeNotify("No character"); return end
        local hrp = char.HumanoidRootPart
        local closest, dist = nil, 1e9
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local nm = (obj.Name or ""):lower()
                if nm:find("brainrot") or obj:GetAttribute("IsCollectable") then
                    local d = (obj.Position - hrp.Position).Magnitude
                    if d < dist then dist = d; closest = obj end
                end
            end
        end
        if closest then
            pcall(function() hrp.CFrame = closest.CFrame + Vector3.new(0,3,0) end)
            safeNotify("Teleported to nearest brainrot")
        else safeNotify("No brainrot found") end
    end)
    uiButton(tpPanel, "Teleport to Random Player", function()
        local pList = Players:GetPlayers()
        if #pList <= 1 then safeNotify("No other players"); return end
        local target = pList[math.random(1,#pList)]
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0) end)
            safeNotify("Teleported to "..target.Name)
        else safeNotify("Target invalid") end
    end)
    uiButton(tpPanel, "Set Current Position as Base", function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            State.savedBaseCFrame = char.HumanoidRootPart.CFrame
            safeNotify("Base saved")
        else safeNotify("No character") end
    end)
    uiButton(tpPanel, "Return to Base", function()
        if State.savedBaseCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = State.savedBaseCFrame end)
            safeNotify("Returned to Base")
        else
            if workspace:FindFirstChild("SpawnLocation") then
                pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame end)
                safeNotify("Returned to Spawn")
            else safeNotify("No base saved and no spawn found") end
        end
    end)

    -- Misc UI
    uiToggle(miscPanel, "Anti-Knockdown (soft)", State.antiKnock, function(s) State.antiKnock = s end)
    uiToggle(miscPanel, "Anti-AFK (auto)", State.antiAFK, function(s) State.antiAFK = s end)
    uiToggle(miscPanel, "No Key Required (Always ON)", true, function() end) -- cosmetic
    uiButton(miscPanel, "Hide/Show GUI (RightShift)", function()
        if State.gui then State.gui.Enabled = not State.gui.Enabled end
    end)
    uiButton(miscPanel, "Unload Hub (cleanup)", function()
        State.enabled = false
        State.autoCollect = false
        State.autoSteal = false
        destroyGui()
        clearConns()
        safeNotify("Brainrot Hub Unloaded")
    end)

    -- Settings UI
    uiButton(settingsPanel, "Save Settings (session/filesystem)", function()
        saveSettings()
        safeNotify("Settings saved")
    end)
    uiButton(settingsPanel, "Load Settings", function()
        loadSettings()
        safeNotify("Settings loaded")
    end)

    -- default open Movement tab
    for k,v in pairs(panels) do v.Visible=false end
    panels["Movement"].Visible = true
end

-- build GUI now
buildGui()
safeNotify("✅ Brainrot Hub v5 injected — Use RightShift to hide GUI")

-- ---------- Core loops & handlers ----------

-- Robust apply movement settings on character spawn
local function applyMovement()
    pcall(function()
        local char, hrp, hum = waitForCharacter()
        if hum then
            hum.WalkSpeed = State.walkSpeed
            hum.JumpPower = State.jumpPower
            hum.PlatformStand = false
        end
    end)
end

-- Re-apply on character added
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    applyMovement()
    -- ensure gui exists
    if not (State.gui and State.gui.Parent) then buildGui() end
end)

-- Anti-AFK handling
if State.antiAFK then
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new(0,0))
            safeNotify("Anti-AFK ping")
        end)
    end)
end

-- ESP: managed highlights
local highlights = {}
local function clearHighlights()
    for _,h in pairs(highlights) do pcall(function() h:Destroy() end) end
    highlights = {}
end
local function refreshHighlights()
    clearHighlights()
    if not State.esp then return end
    -- players
    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character.PrimaryPart and plr ~= LocalPlayer then
            local h = Instance.new("Highlight", plr.Character)
            h.FillTransparency = 1
            h.OutlineColor = Color3.fromRGB(0,255,120)
            table.insert(highlights, h)
        end
    end
    -- items
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nm = (obj.Name or ""):lower()
            if nm:find("brainrot") or obj:GetAttribute("IsCollectable") then
                local h = Instance.new("Highlight", obj)
                h.FillTransparency = 1
                h.OutlineColor = Color3.fromRGB(255,80,80)
                table.insert(highlights, h)
            end
        end
    end
end

-- safe collect routine
local function tryCollectNearby(part)
    pcall(function()
        -- prefer to use remote if exists
        local remote = ReplicatedStorage:FindFirstChild("RequestCollect") or ReplicatedStorage:FindFirstChild("CollectEvent")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(part)
        elseif type(firetouchinterest) == "function" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 0)
            task.wait(0.06)
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 1)
        else
            -- teleport near part real quick (risky)
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local old = char.HumanoidRootPart.CFrame
                char.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0,3,0)
                task.wait(0.12)
                char.HumanoidRootPart.CFrame = old
            end
        end
    end)
end

-- Auto loops
local collectingCoroutine = nil
local function startAutoCollect(targetNames)
    if collectingCoroutine then return end
    collectingCoroutine = coroutine.create(function()
        while State.autoCollect do
            local ok, char = pcall(function() return LocalPlayer.Character end)
            if not ok or not char or not char:FindFirstChild("HumanoidRootPart") then
                task.wait(0.6) 
            else
                local hrp = char.HumanoidRootPart
                local found = {}
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local nm = (obj.Name or ""):lower()
                        local match = false
                        for _,tn in ipairs(targetNames) do
                            if nm:find(tn) then match = true; break end
                        end
                        if obj:GetAttribute("IsCollectable") then match = true end
                        if match then table.insert(found, obj) end
                    end
                end
                table.sort(found, function(a,b)
                    return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
                end)
                for _,part in ipairs(found) do
                    if not State.autoCollect then break end
                    pcall(function() tryCollectNearby(part) end)
                    task.wait(0.3 + math.random()*0.2) -- slight randomness for anti-detect
                end
                task.wait(0.7 + math.random()*0.3)
            end
        end
        collectingCoroutine = nil
    end)
    coroutine.resume(collectingCoroutine)
end

-- Aimbot (light) - aim towards nearest player's head when active; small smoothing
local aimbotEnabled = false
local function doAimbot()
    if not aimbotEnabled then return end
    pcall(function()
        local cam = workspace.CurrentCamera
        local best, bestDist = nil, 1e9
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local pos, onScreen = cam:WorldToViewportPoint(plr.Character.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X,pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if dist < bestDist then bestDist = dist; best = plr end
                end
            end
        end
        if best and best.Character and best.Character:FindFirstChild("Head") then
            local headPos = best.Character.Head.Position
            -- move camera slightly toward target (only if executor allows camera manipulation)
            pcall(function()
                cam.CFrame = CFrame.new(cam.CFrame.Position, headPos)
            end)
        end
    end)
end

-- Fly implementation (press & hold space to ascend, ctrl to descend, WASD to move)
local flyConnection = nil
local function startFlightLoop()
    if flyConnection then return end
    flyConnection = RunService.RenderStepped:Connect(function()
        if not State.flyMode then return end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + (cam.CFrame.LookVector) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - (cam.CFrame.LookVector) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - (cam.CFrame.RightVector) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + (cam.CFrame.RightVector) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then State.flyHold = true else State.flyHold = false end
        local vertical = 0
        if State.flyHold then vertical = vertical + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vertical = vertical - 1 end
        -- compose final velocity
        local dir = (moveVec + Vector3.new(0, vertical, 0))
        if dir.Magnitude > 0 then
            local vel = dir.Unit * (State.flySpeed or 80)
            hrp.Velocity = Vector3.new(vel.X, vel.Y, vel.Z)
        else
            -- small servo to keep position
            hrp.Velocity = Vector3.new(0, (State.flyHold and State.flySpeed or 0), 0)
        end
    end)
end
local function stopFlightLoop()
    if flyConnection then
        pcall(function() flyConnection:Disconnect() end)
        flyConnection = nil
    end
end

-- NoClip loop
local noclipConnection = nil
local function startNoClip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        if not State.noclip then return end
        local c = LocalPlayer.Character
        if c then
            for _,p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
    end)
end
local function stopNoClip()
    if noclipConnection then pcall(function() noclipConnection:Disconnect() end) end
    noclipConnection = nil
end

-- main render loop
addConn(RunService.RenderStepped:Connect(function()
    if not State.enabled then return end
    -- maintain movement values
    pcall(function()
        local c = LocalPlayer.Character
        if c then
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = State.walkSpeed
                hum.JumpPower = State.jumpPower
                if State.antiKnock then pcall(function() hum.PlatformStand = false end) end
            end
        end
    end)

    -- apply fly or noclip
    if State.flyMode then startFlightLoop() else stopFlightLoop() end
    if State.noclip then startNoClip() else stopNoClip() end

    -- ESP refresh occasionally
    if State.esp then refreshHighlights() end

    -- Auto collect / auto steal jobs
    if State.autoCollect then
        startAutoCollect({"brainrot","brain rot","coin","cash","pickup","loot"})
    end

    -- aimbot
    if aimbotEnabled then doAimbot() end
end))

-- Respawn guarantee: rebuild GUI and reapply toggles if cleared
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.8)
    if not (State.gui and State.gui.Parent) then buildGui() end
    applyMovement()
    if State.esp then refreshHighlights() end
    if State.noclip then startNoClip() end
    if State.flyMode then startFlightLoop() end
    safeNotify("♻️ Hub reinitialized after respawn")
end)

-- toggles / keybinds
addConn(UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if State.gui then State.gui.Enabled = not State.gui.Enabled end
    elseif input.KeyCode == Enum.KeyCode.Z then
        -- quick teleport to base
        if State.savedBaseCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = State.savedBaseCFrame end)
            safeNotify("Returned to base")
        end
    end
end))

-- cleanup on unload (if want)
local function unload()
    State.enabled = false
    State.autoCollect = false
    State.autoSteal = false
    stopFlightLoop()
    stopNoClip()
    clearConns()
    destroyGui()
    clearHighlights()
    safeNotify("Brainrot Hub unloaded")
end

-- final notification
safeNotify("Brainrot Hub v5.0 ready — hold Space to rise, Ctrl to descend. RightShift to hide GUI.")
