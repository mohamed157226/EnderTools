-- Brainrot Hub v5.1 — Ultimate Fly & More (Space hold)
-- Modified by Assistant for full features & UI improvements
-- No key required, instant & auto steal, fly, noclip, aimbot, anti ragdoll, ESP, teleport, base control, discord link, and more!

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("User InputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ---------- State ----------
local State = {
    gui = nil,
    enabled = true,
    flyMode = false,
    flyHold = false,
    flySpeed = 80,
    walkSpeed = 30,
    jumpPower = 70,
    noclip = false,
    autoCollect = false,
    autoSteal = false,
    esp = false,
    fullbright = false,
    antiAFK = true,
    antiKnock = true,
    merciless = false,
    aimbot = false,
    savedBaseCFrame = nil,
    autoBuy = false,
    autoRebirth = false,
    connections = {},
}

-- Settings file name
local SETTINGS_FILE = "BrainrotHub_v5.json"

-- Save & Load Settings
local function saveSettings()
    local s = {
        flySpeed = State.flySpeed,
        walkSpeed = State.walkSpeed,
        jumpPower = State.jumpPower,
        noclip = State.noclip,
        esp = State.esp,
        fullbright = State.fullbright,
        antiKnock = State.antiKnock,
        merciless = State.merciless,
        aimbot = State.aimbot,
        autoCollect = State.autoCollect,
        autoSteal = State.autoSteal,
        autoBuy = State.autoBuy,
        autoRebirth = State.autoRebirth,
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
                for k,v in pairs(t) do
                    if State[k] ~= nil then State[k] = v end
                end
            end
        else
            local j = LocalPlayer:GetAttribute("BN_Settings")
            if j and j ~= "" then
                local ok, t = pcall(HttpService.JSONDecode, HttpService, j)
                if ok and type(t) == "table" then
                    for k,v in pairs(t) do
                        if State[k] ~= nil then State[k] = v end
                    end
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
        frame.BackgroundColor3 = Color3.fromRGB(25, 40, 70)
        frame.BorderSizePixel = 0
        local corner = Instance.new("UICorner", frame); corner.CornerRadius = UDim.new(0,14)

        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(1, -24, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(120, 255, 200)
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 20
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

    -- Background Image (Map Icon)
    local bgImage = make("ImageLabel", {
        Parent = sg,
        Size = UDim2.new(1,0,1,0),
        Position = UDim2.new(0,0,0,0),
        Image = "rbxassetid://180DAY-2c80b25b40d200f99b1d085120972eff", -- your map image link
        BackgroundTransparency = 1,
        ZIndex = 0,
        ScaleType = Enum.ScaleType.Fit,
        ImageTransparency = 0.85,
    })

    local main = make("Frame",{
        Name="Main", Parent=sg,
        Size=UDim2.new(0, 780, 0, 520),
        Position=UDim2.new(0.12,0,0.08,0),
        BackgroundColor3=Color3.fromRGB(15, 25, 45),
        BackgroundTransparency = 0.15,
        Active=true, Draggable=true,
        BorderSizePixel = 0,
        ZIndex = 10,
    })
    make("UICorner",{Parent=main, CornerRadius=UDim.new(0,18)})

    local header = make("Frame",{Parent=main, Size=UDim2.new(1,0,0,64), BackgroundTransparency=1, ZIndex=11})
    make("TextLabel",{Parent=header, Size=UDim2.new(0.6,0,1,0), Position=UDim2.new(0.02,0,0,0), BackgroundTransparency=1,
        Text="🛰️ Brainrot Hub v5.1", TextColor3=Color3.fromRGB(0,255,180), Font=Enum.Font.GothamBlack, TextSize=28, TextXAlignment=Enum.TextXAlignment.Left})
    make("TextLabel",{Parent=header, Size=UDim2.new(0.2,0,1,0), Position=UDim2.new(0.78,0,0,0), BackgroundTransparency=1,
        Text="Premium", TextColor3=Color3.fromRGB(180,180,180), Font=Enum.Font.GothamBold, TextSize=16})

    -- tabs column
    local tabs = make("Frame",{Parent=main, Size=UDim2.new(0,180,1,-64), Position=UDim2.new(0,0,0,64), BackgroundColor3=Color3.fromRGB(20, 30, 50), ZIndex=11})
    make("UIListLayout",{Parent=tabs, Padding=UDim.new(0,10), FillDirection=Enum.FillDirection.Vertical})
    make("UIPadding",{Parent=tabs, PaddingLeft=UDim.new(0,16), PaddingTop=UDim.new(0,16)})

    -- content area
    local content = make("Frame",{Parent=main, Size=UDim2.new(1,-180,1,-64), Position=UDim2.new(0,180,0,64), BackgroundTransparency=1, ZIndex=11})
    make("UICorner",{Parent=content, CornerRadius=UDim.new(0,14)})

    -- helper to create panels
    local panels = {}
    local function newTab(name)
        local btn = make("TextButton",{Parent=tabs, Size=UDim2.new(1,-24,0,44), Text=name, Font=Enum.Font.GothamBold, TextSize=20, TextColor3=Color3.fromRGB(200,200,255), BackgroundColor3=Color3.fromRGB(30,40,60)})
        make("UICorner",{Parent=btn, CornerRadius=UDim.new(0,10)})
        local panel = make("ScrollingFrame",{Parent=content, Size=UDim2.new(1,0,1,0), Visible=false, ScrollBarThickness=8, BackgroundColor3=Color3.fromRGB(10,15,25)})
        panel.CanvasSize = UDim2.new(0,0,0,0)
        panels[name] = panel
        btn.MouseButton1Click:Connect(function()
            for _,v in pairs(panels) do v.Visible = false end
            panel.Visible = true
        end)
        return panel
    end

    local function uiButton(parent, text, ycall)
        local btn = make("TextButton",{Parent=parent, Size=UDim2.new(1,-24,0,44), Position=UDim2.new(0,12,0,0), Text=text, Font=Enum.Font.GothamBold, TextSize=18, BackgroundColor3=Color3.fromRGB(40,60,90), TextColor3=Color3.fromRGB(220,220,255)})
        make("UICorner",{Parent=btn, CornerRadius=UDim.new(0,10)})
        btn.MouseButton1Click:Connect(function() pcall(ycall) end)
        return btn
    end

    local function uiToggle(parent, label, init, cb)
        local frame = make("Frame",{Parent=parent, Size=UDim2.new(1,-24,0,44), BackgroundTransparency=1})
        local lbl = make("TextLabel",{Parent=frame, Size=UDim2.new(0.7,0,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text=label, Font=Enum.Font.GothamBold, TextSize=18, TextColor3=Color3.fromRGB(220,220,255), TextXAlignment=Enum.TextXAlignment.Left})
        local btn = make("TextButton",{Parent=frame, Size=UDim2.new(0,90,0,32), Position=UDim2.new(1,-102,0,6), Text=(init and "ON" or "OFF"), BackgroundColor3=(init and Color3.fromRGB(50,200,120) or Color3.fromRGB(80,80,100)), Font=Enum.Font.GothamBold, TextSize=16, TextColor3=Color3.fromRGB(240,240,240)})
        make("UICorner",{Parent=btn, CornerRadius=UDim.new(0,8)})
        local st = init
        btn.MouseButton1Click:Connect(function()
            st = not st
            btn.BackgroundColor3 = st and Color3.fromRGB(50,200,120) or Color3.fromRGB(80,80,100)
            btn.Text = st and "ON" or "OFF"
            pcall(cb, st)
        end)
        return frame
    end

    local function uiSlider(parent, label, minv, maxv, initv, cb)
        local frame = make("Frame",{Parent=parent, Size=UDim2.new(1,-24,0,64), BackgroundTransparency=1})
        local lbl = make("TextLabel",{Parent=frame, Size=UDim2.new(0.66,0,0,20), Position=UDim2.new(0,6,0,6), BackgroundTransparency=1, Text=label, Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(200,200,220), TextXAlignment=Enum.TextXAlignment.Left})
        local val = make("TextLabel",{Parent=frame, Size=UDim2.new(0.3,-12,0,20), Position=UDim2.new(0.7,6,0,6), BackgroundTransparency=1, Text=tostring(initv), Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(180,180,200), TextXAlignment=Enum.TextXAlignment.Right})
        local bar = make("Frame",{Parent=frame, Size=UDim2.new(1,-32,0,14), Position=UDim2.new(0,16,0,34), BackgroundColor3=Color3.fromRGB(50,50,70)})
        make("UICorner",{Parent=bar, CornerRadius=UDim.new(0,8)})
        local fill = make("Frame",{Parent=bar, Size=UDim2.new((initv-minv)/(maxv-minv),0,1,0), BackgroundColor3=Color3.fromRGB(0,220,160)})
        make("UICorner",{Parent=fill, CornerRadius=UDim.new(0,8)})
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

    -- Build tabs content

    -- Movement Tab
    local movementPanel = panels["Movement"] or newTab("Movement"); panels["Movement"] = movementPanel
    uiToggle(movementPanel, "Enable Fly Mode (hold Space)", State.flyMode, function(s) State.flyMode = s end)
    uiSlider(movementPanel, "Flight Speed", 10, 250, State.flySpeed, function(v) State.flySpeed = v end)
    uiSlider(movementPanel, "Walk Speed", 8, 250, State.walkSpeed, function(v) State.walkSpeed = v end)
    uiSlider(movementPanel, "Jump Power", 10, 250, State.jumpPower, function(v) State.jumpPower = v end)
    uiToggle(movementPanel, "NoClip", State.noclip, function(s) State.noclip = s end)
    uiToggle(movementPanel, "Merciless Mode (No Damage/Death)", State.merciless, function(s) State.merciless = s end)
    uiToggle(movementPanel, "Aimbot (Light)", State.aimbot, function(s) State.aimbot = s end)

    -- Farming Tab
    local farmingPanel = panels["Farming"] or newTab("Farming"); panels["Farming"] = farmingPanel
    uiToggle(farmingPanel, "Auto Collect (AutoSteal)", State.autoCollect, function(s)
        State.autoCollect = s
        if s then safeNotify("AutoCollect ON") end
    end)
    uiToggle(farmingPanel, "Auto Buy Upgrades", State.autoBuy, function(s)
        State.autoBuy = s
        if s then safeNotify("Auto Buy ON") end
    end)
    uiToggle(farmingPanel, "Auto Rebirth", State.autoRebirth, function(s)
        State.autoRebirth = s
        if s then safeNotify("Auto Rebirth ON") end
    end)
    uiButton(farmingPanel, "Instant Steal [🛰️] Steal a Brainrot", function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then safeNotify("No character"); return end
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
    uiToggle(farmingPanel, "Auto Steal (
        
