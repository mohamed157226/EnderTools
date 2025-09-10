-- Brainrot Nexus - Xeno Friendly Lite
-- Features: inject notification, Fly, Speed, Super Jump, NoClip, AutoCollect, Anti-AFK
-- Paste this directly into Xeno executor (or host raw & loadstring it)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- helpers
local function waitForChar()
    local char = LocalPlayer.Character
    if not char then
        char = LocalPlayer.CharacterAdded:Wait()
    end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    return char, hrp, hum
end

-- remove old GUI if exists
pcall(function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local old = pg and pg:FindFirstChild("BrainrotNexus")
    if old then old:Destroy() end
end)

-- notification (in-game GUI toast)
local function notify(text, dur)
    dur = dur or 3
    local pg = LocalPlayer:WaitForChild("PlayerGui")
    local sg = Instance.new("ScreenGui")
    sg.Name = "BN_Notify"
    sg.Parent = pg

    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 320, 0, 50)
    frame.Position = UDim2.new(0.5, -160, 0.08, 0)
    frame.BackgroundTransparency = 0
    frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
    frame.AnchorPoint = Vector2.new(0.5,0)
    frame.BorderSizePixel = 0
    frame.ZIndex = 50
    frame.ClipsDescendants = true

    local uic = Instance.new("UICorner", frame)
    uic.CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -20, 1, 0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 255, 230)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 18
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    frame.Position = UDim2.new(0.5, -160, -0.2, 0)
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {Position = UDim2.new(0.5, -160, 0.08, 0)})
    tweenIn:Play()
    task.delay(dur, function()
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Sine), {Position = UDim2.new(0.5, -160, -0.2, 0)})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        pcall(function() sg:Destroy() end)
    end)
end

-- base GUI
local pg = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", pg)
ScreenGui.Name = "BrainrotNexus"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 340, 0, 420)
Main.Position = UDim2.new(0.28, 0, 0.18, 0)
Main.BackgroundColor3 = Color3.fromRGB(18,18,26)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
local corner = Instance.new("UICorner", Main); corner.CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,50)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "🛰️ Brainrot Nexus"
Title.TextColor3 = Color3.fromRGB(0, 220, 180)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- left column (tabs)
local tabs = {"🏃 Movement","👁️ ESP","💰 Farming","🎭 Misc"}
local buttons = {}
for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton", Main)
    btn.Position = UDim2.new(0, 12, 0, 60 + (i-1)*52)
    btn.Size = UDim2.new(0, 150, 0, 44)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(28,28,38)
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0,8)
    buttons[i] = btn
end

-- right panel (content)
local content = Instance.new("Frame", Main)
content.Position = UDim2.new(0, 174, 0, 60)
content.Size = UDim2.new(0, 154, 0, 340)
content.BackgroundTransparency = 1

local function clearContent()
    for _, v in pairs(content:GetChildren()) do
        if not (v:IsA("UIListLayout")) then
            v:Destroy()
        end
    end
end

-- utility to make toggle
local function makeToggle(y, label, initState, onToggle)
    local frame = Instance.new("Frame", content)
    frame.Position = UDim2.new(0, 0, 0, y)
    frame.Size = UDim2.new(1, 0, 0, 42)
    frame.BackgroundTransparency = 1

    local text = Instance.new("TextLabel", frame)
    text.Size = UDim2.new(0.7, 0, 1, 0)
    text.Position = UDim2.new(0, 6, 0, 0)
    text.Text = label
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(220,220,220)
    text.Font = Enum.Font.Gotham
    text.TextSize = 14
    text.TextXAlignment = Enum.TextXAlignment.Left

    local tbtn = Instance.new("TextButton", frame)
    tbtn.Size = UDim2.new(0, 60, 0, 28)
    tbtn.Position = UDim2.new(1, -68, 0, 7)
    tbtn.BackgroundColor3 = initState and Color3.fromRGB(40,160,90) or Color3.fromRGB(60,60,80)
    tbtn.Text = initState and "ON" or "OFF"
    tbtn.Font = Enum.Font.GothamBold
    tbtn.TextSize = 13
    local c = Instance.new("UICorner", tbtn); c.CornerRadius = UDim.new(0,6)

    local state = initState
    tbtn.MouseButton1Click:Connect(function()
        state = not state
        tbtn.BackgroundColor3 = state and Color3.fromRGB(40,160,90) or Color3.fromRGB(60,60,80)
        tbtn.Text = state and "ON" or "OFF"
        pcall(onToggle, state)
    end)
    return frame
end

-- === Feature implementations ===
-- persistent state & connections
local flyState, flyConn, flyBG, flyBV = false, nil, nil, nil
local speedState, origWalk = false, nil
local superJumpState, origJumpPower, origUseJumpPower = false, nil, nil
local noclipState, noclipConn = false, nil
local farmState = false
local afkState = false
local farmThread, afkThread

-- reapply on respawn
local function onCharacterAdded(char)
    task.delay(0.3, function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if speedState and origWalk then
                pcall(function() hum.WalkSpeed = 80 end)
            end
            if superJumpState and origJumpPower then
                pcall(function() hum.UseJumpPower = true; hum.JumpPower = 100 end)
            end
        end
    end)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Fly
local function toggleFly(enable)
    flyState = enable
    local ok, char, hrp, hum = pcall(function() return LocalPlayer.Character, LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end)
    if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end
    local char2, hrp2, hum2 = waitForChar()

    if enable then
        if flyConn then flyConn:Disconnect() end
        flyBG = Instance.new("BodyGyro")
        flyBG.P = 9e4
        flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
        flyBG.CFrame = hrp2.CFrame
        flyBG.Parent = hrp2

        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
        flyBV.Velocity = Vector3.new(0,0,0)
        flyBV.Parent = hrp2

        flyConn = RunService.RenderStepped:Connect(function()
            if not flyState or not hrp2.Parent then return end
            local cam = workspace.CurrentCamera
            flyBG.CFrame = cam.CFrame
            local move = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
            flyBV.Velocity = (move.Unit == move and move or Vector3.new()) * 60 -- speed
        end)
        notify("Fly enabled")
    else
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if flyBG and flyBG.Parent then flyBG:Destroy() end
        if flyBV and flyBV.Parent then flyBV:Destroy() end
        notify("Fly disabled")
    end
end

-- Speed
local function toggleSpeed(enable)
    speedState = enable
    local char, hrp, hum = waitForChar()
    if hum then
        if not origWalk then origWalk = hum.WalkSpeed end
        if enable then
            pcall(function() hum.WalkSpeed = 80 end)
            notify("Speed set to 80")
        else
            pcall(function() hum.WalkSpeed = origWalk or 16 end)
            notify("Speed restored")
        end
    end
end

-- Super Jump
local function toggleSuperJump(enable)
    superJumpState = enable
    local char, hrp, hum = waitForChar()
    if hum then
        if origJumpPower == nil then
            origUseJumpPower = hum.UseJumpPower
            origJumpPower = hum.JumpPower or 50
        end
        if enable then
            pcall(function() hum.UseJumpPower = true; hum.JumpPower = 100 end)
            notify("Super Jump ON")
        else
            pcall(function() hum.UseJumpPower = origUseJumpPower; hum.JumpPower = origJumpPower end)
            notify("Super Jump OFF")
        end
    end
end

-- NoClip
local function toggleNoClip(enable)
    noclipState = enable
    if enable then
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function() part.CanCollide = false end)
                    end
                end
            end
        end)
        notify("NoClip ON")
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = true end)
                end
            end
        end
        notify("NoClip OFF")
    end
end

-- Auto Collect (simple heuristic)
local function toggleAutoCollect(enable)
    farmState = enable
    if farmState then
        notify("AutoCollect ON")
        farmThread = task.spawn(function()
            while farmState do
                local char, hrp, hum = waitForChar()
                if not hrp then task.wait(1); continue end
                local found = {}
                for _, obj in pairs(workspace:GetDescendants()) do
                    if not obj:IsA("BasePart") then
                        if obj:IsA("Model") and obj.PrimaryPart then
                            obj = obj.PrimaryPart
                        else
                            continue
                        end
                    end
                    local name = (obj.Name or ""):lower()
                    if obj:FindFirstChild("TouchTransmitter") or name:match("coin") or name:match("cash") or name:match("pickup") or name:match("money") then
                        table.insert(found, obj)
                    end
                end
                table.sort(found, function(a,b) return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude end)
                for _, part in ipairs(found) do
                    if not farmState then break end
                    pcall(function()
                        -- try firetouchinterest if available
                        if type(firetouchinterest) == "function" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 0)
                            task.wait(0.05)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 1)
                        else
                            -- fallback: teleport near the part
                            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                        end
                        task.wait(0.25)
                    end)
                end
                task.wait(0.6)
            end
        end)
    else
        farmState = false
        notify("AutoCollect OFF")
    end
end

-- Anti-AFK
local function toggleAFK(enable)
    afkState = enable
    if afkState then
        notify("Anti-AFK ON")
        local vu = game:GetService("VirtualUser")
        afkThread = task.spawn(function()
            while afkState do
                pcall(function()
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new(0,0))
                end)
                task.wait(60)
            end
        end)
    else
        afkState = false
        notify("Anti-AFK OFF")
    end
end

-- === Tab contents ===
local function showMovement()
    clearContent()
    makeToggle(0, "✈️ Fly", false, toggleFly)
    makeToggle(52, "🦘 Super Jump", false, toggleSuperJump)
    makeToggle(104, "⚡ Speed", false, toggleSpeed)
    makeToggle(156, "🚪 NoClip", false, toggleNoClip)
    makeToggle(208, "⛓️ Auto Collect", false, toggleAutoCollect)
end

local function showESP()
    clearContent()
    makeToggle(0, "👥 ESP Players", false, function() notify("ESP not implemented in this lite build") end)
    makeToggle(52, "💰 ESP Items", false, function() notify("ESP not implemented in this lite build") end)
    makeToggle(104, "💡 FullBright", false, function() notify("FullBright not implemented") end)
    makeToggle(156, "🔍 X-Ray", false, function() notify("X-Ray not implemented") end)
    makeToggle(208, "➖ Tracers", false, function() notify("Tracers not implemented") end)
end

local function showFarm()
    clearContent()
    makeToggle(0, "💵 Auto Collect", false, toggleAutoCollect)
    makeToggle(52, "🛒 Auto Buy", false, function() notify("Auto Buy not supported here") end)
    makeToggle(104, "🗡️ Auto Equip", false, function() notify("Auto Equip not supported here") end)
    makeToggle(156, "🔄 Auto Rejoin", false, function(state) if state then notify("Auto Rejoin: use executor features") else notify("Auto Rejoin OFF") end end)
    makeToggle(208, "🌍 Server Hop", false, function() notify("Server Hop: use external tool") end)
end

local function showMisc()
    clearContent()
    makeToggle(0, "🛡️ Godmode (heal loop)", false, function(state)
        if state then
            notify("Godmode ON (heal loop)")
            task.spawn(function()
                while state do
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health < (hum.MaxHealth or 100) then
                            pcall(function() hum.Health = hum.MaxHealth end)
                        end
                    end
                    task.wait(0.7)
                end
            end)
        else
            notify("Godmode OFF")
        end
    end)
    makeToggle(52, "🖥️ Anti-Lag", false, function(state) notify("Anti-Lag toggled (manual)"); end)
    makeToggle(104, "⏳ Anti-AFK", false, toggleAFK)
    makeToggle(156, "🎉 Troll Features", false, function() notify("Troll features disabled in lite") end)
    makeToggle(208, "👂 Chat Spy", false, function() notify("Chat Spy disabled in lite") end)
end

-- connect tabs
buttons[1].MouseButton1Click:Connect(showMovement)
buttons[2].MouseButton1Click:Connect(showESP)
buttons[3].MouseButton1Click:Connect(showFarm)
buttons[4].MouseButton1Click:Connect(showMisc)

-- initial
notify("Brainrot Nexus Injected Successfully ✅", 3)
showMovement()
