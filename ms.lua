-- الخدمات والمتغيرات الأساسية
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("User InputService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- تحميل مكتبة Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- المتغيرات الأساسية للشخصية والكاميرا
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
LocalPlayer.CharacterAdded:Connect(function(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
    humanoid = c:WaitForChild("Humanoid")
end)
local camera = Workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

-- ============================
-- واجهة GUI بسيطة (xcv hub)
-- ============================
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "SpeedAndJumpGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 370)
frame.Position = UDim2.new(0.5, -150, 0.5, -185)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Active = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "xcv hub"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.BorderSizePixel = 0

local speedTextBox = Instance.new("TextBox", frame)
speedTextBox.Size = UDim2.new(0.8, 0, 0, 40)
speedTextBox.Position = UDim2.new(0.1, 0, 0.15, 0)
speedTextBox.PlaceholderText = "Enter Speed"
speedTextBox.Text = ""
speedTextBox.TextScaled = true
speedTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedTextBox.Font = Enum.Font.Gotham
speedTextBox.BorderSizePixel = 0

local jumpTextBox = Instance.new("TextBox", frame)
jumpTextBox.Size = UDim2.new(0.8, 0, 0, 40)
jumpTextBox.Position = UDim2.new(0.1, 0, 0.35, 0)
jumpTextBox.PlaceholderText = "Enter JumpPower"
jumpTextBox.Text = ""
jumpTextBox.TextScaled = true
jumpTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpTextBox.Font = Enum.Font.Gotham
jumpTextBox.BorderSizePixel = 0

local speedButton = Instance.new("TextButton", frame)
speedButton.Size = UDim2.new(0.8, 0, 0, 40)
speedButton.Position = UDim2.new(0.1, 0, 0.55, 0)
speedButton.Text = "Set Speed"
speedButton.TextScaled = true
speedButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.GothamBold
speedButton.BorderSizePixel = 0

local jumpButton = Instance.new("TextButton", frame)
jumpButton.Size = UDim2.new(0.8, 0, 0, 40)
jumpButton.Position = UDim2.new(0.1, 0, 0.75, 0)
jumpButton.Text = "Set JumpPower"
jumpButton.TextScaled = true
jumpButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpButton.Font = Enum.Font.GothamBold
jumpButton.BorderSizePixel = 0

-- NoClip Button
local NoClipBtn = Instance.new("TextButton", frame)
NoClipBtn.Size = UDim2.new(0, 250, 0, 30)
NoClipBtn.Position = UDim2.new(0, 25, 0, 310)
NoClipBtn.Text = "NoClip: OFF"
NoClipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NoClipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoClipBtn.Font = Enum.Font.SourceSansBold
NoClipBtn.TextSize = 16

-- Close Button
local CloseBtn = Instance.new("TextButton", frame)
CloseBtn.Size = UDim2.new(0, 250, 0, 30)
CloseBtn.Position = UDim2.new(0, 25, 0, 350)
CloseBtn.Text = "CLOSE"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16

-- Smooth Dragging
local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

User InputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- تحديث السرعة
local function updateSpeed()
    local speed = tonumber(speedTextBox.Text)
    if speed and speed > 0 then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = speed
        print("Speed set to: " .. speed)
    else
        warn("Invalid speed entered. Please enter a valid positive number.")
    end
end

-- تحديث قوة القفز
local function updateJumpPower()
    local jumpPower = tonumber(jumpTextBox.Text)
    if jumpPower and jumpPower > 0 then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.JumpPower = jumpPower
        print("JumpPower set to: " .. jumpPower)
    else
        warn("Invalid JumpPower entered. Please enter a valid positive number.")
    end
end

speedButton.MouseButton1Click:Connect(updateSpeed)
jumpButton.MouseButton1Click:Connect(updateJumpPower)

-- NoClip متغير وحالة
local noclipEnabled = false

-- وظيفة NoClip
local function toggleNoClip()
    noclipEnabled = not noclipEnabled
    NoClipBtn.Text = noclipEnabled and "NoClip: ON" or "NoClip: OFF"
end

NoClipBtn.MouseButton1Click:Connect(toggleNoClip)

-- تنفيذ NoClip في كل إطار
RunService.Stepped:Connect(function()
    if noclipEnabled and hrp then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    elseif hrp then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide == false then
                part.CanCollide = true
            end
        end
    end
end)

-- زر إغلاق الواجهة
CloseBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ============================
-- نظام Aimbot و Anti-Aim و Misc (Rayfield)
-- ============================

-- (يمكنك دمج كود الـ Aimbot والـ Anti-Aim والمميزات الأخرى من الكود السابق هنا إذا أردت)

-- ============================
-- نظام ESP باستخدام Drawing
-- ============================

local ESPs = {}

local function createESP(plr)
    if not plr or plr == LocalPlayer then return end
    if ESPs[plr] then return end

    local successBox, box = pcall(function() return Drawing.new("Square") end)
    local successLine, line = pcall(function() return Drawing.new("Line") end)
    ESPs[plr] = {
        Box = successBox and box or nil,
        Line = successLine and line or nil
    }

    if ESPs[plr].Box then
        ESPs[plr].Box.Visible = false
        ESPs[plr].Box.Thickness = 1
        ESPs[plr].Box.Filled = false
        ESPs[plr].Box.Color = Color3.new(1, 0, 0)
    end
    if ESPs[plr].Line then
        ESPs[plr].Line.Visible = false
        ESPs[plr].Line.Thickness = 1
        ESPs[plr].Line.Color = Color3.new(1, 0, 0)
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(createESP)

Players.PlayerRemoving:Connect(function(plr)
    local data = ESPs[plr]
    if data then
        if data.Box then pcall(function() data.Box:Remove() end) end
        if data.Line then pcall(function() data.Line:Remove() end) end
        ESPs[plr] = nil
    end
end)

-- تحديث ESP في كل إطار
RunService.RenderStepped:Connect(function()
    for plr, espData in pairs(ESPs) do
        local character = plr.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp and espData.Box and espData.Line then
            local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local size = Vector3.new(4, 6, 1) -- حجم الصندوق (يمكن تعديله)
                local topLeft = Vector2.new(pos.X - 50, pos.Y - 75)
                local bottomRight = Vector2.new(pos.X + 50, pos.Y + 75)

                espData.Box.Position = topLeft
                espData.Box.Size = Vector2.new(bottomRight.X - topLeft.X, bottomRight.Y - topLeft.Y)
                espData.Box.Visible = true

                espData.Line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                espData.Line.To = Vector2.new(pos.X, pos.Y)
                espData.Line.Visible = true
            else
                espData.Box.Visible = false
                espData.Line.Visible = false
            end
        else
            if espData.Box then espData.Box.Visible = false end
            if espData.Line then espData.Line.Visible = false end
        end
    end
end)
