-- AdminClient (StarterPlayerScripts) - runs on player
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Remote refs
local BuyPet = ReplicatedStorage:WaitForChild("BuyPet")
local RequestCollect = ReplicatedStorage:WaitForChild("RequestCollect")
local ToggleDoor = ReplicatedStorage:WaitForChild("ToggleDoor")
local PetsFolder = ReplicatedStorage:FindFirstChild("Pets")

-- small helper
local function make(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do obj[k] = v end
    return obj
end

-- keep GUI in CoreGui if allowed (prevents disappearing on respawn in some setups)
local parentGui = PlayerGui  -- Default
-- build GUI
local sg = make("ScreenGui",{Name="AdminHubGUI", ResetOnSpawn=false, Parent=parentGui})
local main = make("Frame",{Parent=sg, Size=UDim2.new(0,760,0,480), Position=UDim2.new(0.12,0,0.08,0), BackgroundColor3=Color3.fromRGB(14,14,18)})
make("UICorner",{Parent=main, CornerRadius=UDim.new(0,12)})
-- header
make("TextLabel",{Parent=main, Size=UDim2.new(1,0,0,56), BackgroundTransparency=1, Text="🛰️ Admin Tools", Font=Enum.Font.GothamBold, TextSize=22, TextColor3=Color3.fromRGB(0,220,180), TextXAlignment=Enum.TextXAlignment.Left, Position=UDim2.new(0,12,0,8)})
-- tabs column
local tabsFrame = make("Frame",{Parent=main, Size=UDim2.new(0,180,1,-80), Position=UDim2.new(0,0,0,80), BackgroundColor3=Color3.fromRGB(18,18,24)})
make("UIListLayout",{Parent=tabsFrame, Padding=UDim.new(0,6), FillDirection=Enum.FillDirection.Vertical})
local content = make("Frame",{Parent=main, Size=UDim2.new(1,-180,1,-80), Position=UDim2.new(0,180,0,80), BackgroundTransparency=1})

-- panels holder
local panels = {}
local function newTab(name)
    local btn = make("TextButton",{Parent=tabsFrame, Size=UDim2.new(1,-12,0,40), Text=name, Font=Enum.Font.Gotham, TextSize=16, BackgroundColor3=Color3.fromRGB(30,30,40)})
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

local function uiButton(parent, text, cb)
    local btn = make("TextButton",{Parent=parent, Size=UDim2.new(1,-24,0,40), Position=UDim2.new(0,12,0,parent.CanvasSize.Y.Offset+12), Text=text, Font=Enum.Font.Gotham, TextSize=15, BackgroundColor3=Color3.fromRGB(36,36,44)})
    make("UICorner",{Parent=btn, CornerRadius=UDim.new(0,8)})
    btn.MouseButton1Click:Connect(function() pcall(cb) end)
    parent.CanvasSize = UDim2.new(0,0,0,parent.CanvasSize.Y.Offset + 52)
    return btn
end

local function uiToggle(parent, label, init, cb)
    local frame = make("Frame",{Parent=parent, Size=UDim2.new(1,-24,0,46), Position=UDim2.new(0,12,0,parent.CanvasSize.Y.Offset+12), BackgroundTransparency=1})
    local lbl = make("TextLabel",{Parent=frame, Size=UDim2.new(0.68,0,1,0), Text=label, BackgroundTransparency=1, Font=Enum.Font.Gotham, TextSize=15, TextColor3=Color3.fromRGB(230,230,230), TextXAlignment=Enum.TextXAlignment.Left})
    local tbtn = make("TextButton",{Parent=frame, Size=UDim2.new(0,86,0,28), Position=UDim2.new(1,-98,0,9), Text=(init and "ON" or "OFF"), BackgroundColor3=(init and Color3.fromRGB(40,160,90) or Color3.fromRGB(60,60,80)), Font=Enum.Font.GothamBold, TextSize=14})
    make("UICorner",{Parent=tbtn, CornerRadius=UDim.new(0,6)})
    local state = init
    tbtn.MouseButton1Click:Connect(function()
        state = not state
        tbtn.BackgroundColor3 = state and Color3.fromRGB(40,160,90) or Color3.fromRGB(60,60,80)
        tbtn.Text = state and "ON" or "OFF"
        pcall(cb, state)
    end)
    parent.CanvasSize = UDim2.new(0,0,0,parent.CanvasSize.Y.Offset + 58)
    return frame
end

local function uiSlider(parent, label, minv, maxv, initv, cb)
    local frame = make("Frame",{Parent=parent, Size=UDim2.new(1,-24,0,72), Position=UDim2.new(0,12,0,parent.CanvasSize.Y.Offset+12), BackgroundTransparency=1})
    local lbl = make("TextLabel",{Parent=frame, Size=UDim2.new(0.7,0,0,20), Position=UDim2.new(0,0,0,0), BackgroundTransparency=1, Text=label, Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(220,220,220), TextXAlignment=Enum.TextXAlignment.Left})
    local val = make("TextLabel",{Parent=frame, Size=UDim2.new(0.28,0,0,20), Position=UDim2.new(0.72,0,0,0), BackgroundTransparency=1, Text=tostring(initv), Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(200,200,200), TextXAlignment=Enum.TextXAlignment.Right})
    local bar = make("Frame",{Parent=frame, Size=UDim2.new(1,0,0,14), Position=UDim2.new(0,0,0,36), BackgroundColor3=Color3.fromRGB(36,36,44)})
    make("UICorner",{Parent=bar, CornerRadius=UDim.new(0,6)})
    local fill = make("Frame",{Parent=bar, Size=UDim2.new((initv-minv)/(maxv-minv),0,1,0), BackgroundColor3=Color3.fromRGB(0,200,150)})
    make("UICorner",{Parent=fill, CornerRadius=UDim.new(0,6)})
    -- drag logic
    local dragging = false
    bar.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    bar.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement then
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
    end)
    parent.CanvasSize = UDim2.new(0,0,0,parent.CanvasSize.Y.Offset + 82)
    return frame
end

-- create tabs
local movementPanel = newTab("Movement")
local farmPanel = newTab("Farming")
local miscPanel = newTab("Misc")

-- Movement UI
uiToggle(movementPanel, "Enable Fly Mode (hold Space)", false, function(s)
    LocalPlayer:SetAttribute("FlyModeEnabled", s)
end)
uiSlider(movementPanel, "Flight Speed", 10, 250, 80, function(v)
    LocalPlayer:SetAttribute("FlySpeed", v)
end)
uiSlider(movementPanel, "Walk Speed", 8, 250, 30, function(v)
    LocalPlayer:SetAttribute("WalkSpeed", v)
end)
uiSlider(movementPanel, "Jump Power", 10, 250, 70, function(v)
    LocalPlayer:SetAttribute("JumpPower", v)
end)
uiToggle(movementPanel, "NoClip", false, function(s)
    LocalPlayer:SetAttribute("NoClip", s)
end)

-- Farming UI
local petThreshold = 10000000
uiSlider(farmPanel, "Pet Threshold (buy above)", 1000000, 100000000, petThreshold, function(v) petThreshold = v end)
uiToggle(farmPanel, "Auto Collect Pets (>= threshold)", false, function(s)
    LocalPlayer:SetAttribute("AutoCollectPets", s)
end)
uiToggle(farmPanel, "Auto Buy Pets (>= threshold)", false, function(s)
    LocalPlayer:SetAttribute("AutoBuyPets", s)
end)
uiButton(farmPanel, "Instant Collect Nearby", function()
    -- ask server to collect nearby objects (server validates admin)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    -- client finds nearby collectables and asks server to collect them
    for _,o in pairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") then
            local nm = (o.Name or ""):lower()
            if nm:find("collect") or nm:find("coin") or nm:find("brainrot") or o:GetAttribute("IsCollectable") then
                RequestCollect:FireServer(o)
            end
        end
    end
end)

-- Misc UI
uiToggle(miscPanel, "Lock/Unlock Base", false, function(s)
    -- Toggle server-side door with name "BaseDoor" (change if different)
    ToggleDoor:FireServer("BaseDoor")
end)
uiButton(miscPanel, "Save Current Position as Base", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local cf = char.HumanoidRootPart.CFrame
        local tbl = {x=cf.Position.X, y=cf.Position.Y, z=cf.Position.Z}
        LocalPlayer:SetAttribute("SavedBaseCFrame", HttpService:JSONEncode(tbl))
        safeNotify("Base saved")
    end
end)
uiButton(miscPanel, "Return to Saved Base", function()
    local json = LocalPlayer:GetAttribute("SavedBaseCFrame")
    if json and json ~= "" then
        local ok, t = pcall(HttpService.JSONDecode, HttpService, json)
        if ok and t and t.x then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(t.x, t.y, t.z) + Vector3.new(0,3,0)
            end
        end
    end
end)

-- Prevent GUI from disappearing on respawn: it was created with ResetOnSpawn=false
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.8)
    -- reapply attributes to local character movement
    local char = LocalPlayer.Character
    if char then
        if LocalPlayer:GetAttribute("WalkSpeed") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = LocalPlayer:GetAttribute("WalkSpeed") end
        end
    end
end)

-- Client-side fly implementation (only if player attribute FlyModeEnabled true and player is admin)
local flyRunning = false
local function startFlyLoop()
    if flyRunning then return end
    flyRunning = true
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not flyRunning then conn:Disconnect(); return end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        if not LocalPlayer:GetAttribute("FlyModeEnabled") then return end
        local hrp = char.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        local vertical = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vertical = vertical + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vertical = vertical - 1 end
        move = move + Vector3.new(0, vertical, 0)
        local speed = LocalPlayer:GetAttribute("FlySpeed") or 80
        if move.Magnitude > 0 then
            hrp.Velocity = move.Unit * speed
        else
            hrp.Velocity = Vector3.new(0, (UserInputService:IsKeyDown(Enum.KeyCode.Space) and speed or 0), 0)
        end
    end)
end

-- auto loops controlled by attributes (polling)
spawn(function()
    while true do
        task.wait(0.8)
        -- Auto collect pets if enabled
        if LocalPlayer:GetAttribute("AutoCollectPets") then
            for _,o in pairs(workspace:GetDescendants()) do
                if o:IsA("BasePart") then
                    local nm = (o.Name or ""):lower()
                    if (nm:find("collect") or nm:find("coin") or nm:find("brainrot") or o:GetAttribute("IsCollectable")) then
                        RequestCollect:FireServer(o)
                        task.wait(0.12)
                    end
                end
            end
        end
        -- Auto buy pets if enabled (client requests server to buy; server validates)
        if LocalPlayer:GetAttribute("AutoBuyPets") then
            local pf = PetsFolder
            if pf then
                for _,pet in pairs(pf:GetChildren()) do
                    local cost = pet:GetAttribute("Cost") or (pet:FindFirstChild("Cost") and tonumber(pet.Cost.Value)) or 0
                    if cost and cost >= (petThreshold or 10000000) then
                        BuyPet:FireServer(pet.Name)
                        task.wait(0.15)
                    end
                end
            end
        end
        -- Fly loop control
        if LocalPlayer:GetAttribute("FlyModeEnabled") then
            startFlyLoop()
        end
    end
end)

-- small helper notify
function safeNotify(txt)
    local sg = Instance.new("ScreenGui", PlayerGui)
    sg.ResetOnSpawn = false
    local lbl = Instance.new("TextLabel", sg)
    lbl.Size = UDim2.new(0,300,0,40)
    lbl.Position = UDim2.new(0.5,-150,0.08,0)
    lbl.BackgroundColor3 = Color3.fromRGB(20,20,30)
    lbl.TextColor3 = Color3.fromRGB(0,255,180)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.Text = txt
    game:GetService("Debris"):AddItem(sg, 2)
end

-- feedback from server events
BuyPet.OnClientEvent:Connect(function(success, msg)
    if success then safeNotify("Bought pet: "..tostring(msg)) else safeNotify("Buy failed: "..tostring(msg)) end
end)
RequestCollect.OnClientEvent:Connect(function(ok, val)
    if ok then safeNotify("Collected: "..tostring(val)) end
end)
ToggleDoor.OnClientEvent:Connect(function(ok, state)
    if ok then safeNotify("Door toggled, locked = "..tostring(state)) end
end)
