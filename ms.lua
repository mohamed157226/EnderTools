-- 🌱 Garden Hub v3
-- Full functional interactive hub

repeat task.wait() until game:GetService("Players").LocalPlayer
local player = game.Players.LocalPlayer

-- Notification
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "✅ Garden Hub Loaded!";
        Text = "Welcome " .. player.Name .. " 🌱";
        Duration = 6;
    })
end)

-- Default settings
local settings = {
    FlySpeed = 50,
    AnimalCount = 3,
    PlantColorMode = "Random", -- "Random" or "Green"
}

-- Screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GardenHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 360, 0, 400)
main.Position = UDim2.new(0.33, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(35,35,35)
local uiCorner = Instance.new("UICorner", main)
uiCorner.CornerRadius = UDim.new(0,10)

-- Title
local title = Instance.new("TextLabel", main)
title.Text = "🌿 Garden Hub v3"
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

-- Tabs
local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1,0,0,30)
tabFrame.Position = UDim2.new(0,0,0,40)
tabFrame.BackgroundTransparency = 1

local contentFrame = Instance.new("Frame", main)
contentFrame.Size = UDim2.new(1,0,1,-70)
contentFrame.Position = UDim2.new(0,0,0,70)
contentFrame.BackgroundTransparency = 1

local tabs = {}
local function createTab(name)
    local btn = Instance.new("TextButton", tabFrame)
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16

    local page = Instance.new("Frame", contentFrame)
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.Visible = false

    btn.MouseButton1Click:Connect(function()
        for _,t in pairs(tabs) do
            t.page.Visible = false
            t.btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
    end)

    table.insert(tabs, {btn=btn,page=page})
    if #tabs == 1 then
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
    end
    return page
end

-- Main Tab
local mainPage = createTab("Main")
local settingsPage = createTab("Settings")
local funPage = createTab("Fun")

-- Helper function: buttons
local function createButton(parent,text,pos,callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9,0,0,35)
    btn.Position = UDim2.new(0.05,0,0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(70,130,180)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.MouseButton1Click:Connect(callback)
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0,8)
end

-- === Main Buttons ===
createButton(mainPage, "🌱 Grow Plant", 10, function()
    local part = Instance.new("Part")
    part.Size = Vector3.new(2,math.random(3,6),2)
    part.Anchored = true
    part.Color = settings.PlantColorMode == "Random" 
        and Color3.fromRGB(math.random(50,255), math.random(100,255), math.random(50,255))
        or Color3.fromRGB(34,139,34)
    part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-6,6),0,math.random(-6,6))
    part.Parent = workspace
end)

createButton(mainPage, "🐄 Spawn Animals", 50, function()
    local animals = {"Cow","Chicken","Sheep","Rabbit"}
    for i=1, settings.AnimalCount do
        local chosen = animals[math.random(1,#animals)]
        local part = Instance.new("Part")
        part.Size = Vector3.new(3,3,3)
        part.Anchored = true
        part.Shape = Enum.PartType.Ball
        part.Color = Color3.fromRGB(math.random(50,255), math.random(50,255), math.random(50,255))
        part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-8,8),3,math.random(-8,8))
        part.Parent = workspace

        local billboard = Instance.new("BillboardGui", part)
        billboard.Size = UDim2.new(0,100,0,30)
        billboard.AlwaysOnTop = true
        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.Text = chosen.." 🐾"
        label.TextColor3 = Color3.new(1,1,1)
        label.TextScaled = true
    end
end)

createButton(mainPage, "🏠 Teleport Base", 90, function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,5,0))
    end
end)

createButton(mainPage, "🕊️ Fly Mode Toggle", 130, function()
    flying = not flying
    game.StarterGui:SetCore("SendNotification", {
        Title = flying and "Fly Mode Activated" or "Fly Mode Deactivated",
        Text = "Use WASD to move",
        Duration = 3
    })
end)

-- === Settings Tab ===
local flyLabel = Instance.new("TextLabel", settingsPage)
flyLabel.Text = "Fly Speed:"
flyLabel.Position = UDim2.new(0.05,0,0,10)
flyLabel.Size = UDim2.new(0.3,0,0,30)
flyLabel.BackgroundTransparency = 1
flyLabel.TextColor3 = Color3.new(1,1,1)

local flyBox = Instance.new("TextBox", settingsPage)
flyBox.Position = UDim2.new(0.4,0,0,10)
flyBox.Size = UDim2.new(0.2,0,0,30)
flyBox.Text = tostring(settings.FlySpeed)
flyBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
flyBox.TextColor3 = Color3.new(1,1,1)
flyBox.FocusLost:Connect(function()
    local val = tonumber(flyBox.Text)
    if val then settings.FlySpeed = val end
end)

local animalLabel = Instance.new("TextLabel", settingsPage)
animalLabel.Text = "Animal Count:"
animalLabel.Position = UDim2.new(0.05,0,0,50)
animalLabel.Size = UDim2.new(0.3,0,0,30)
animalLabel.BackgroundTransparency = 1
animalLabel.TextColor3 = Color3.new(1,1,1)

local animalBox = Instance.new("TextBox", settingsPage)
animalBox.Position = UDim2.new(0.4,0,0,50)
animalBox.Size = UDim2.new(0.2,0,0,30)
animalBox.Text = tostring(settings.AnimalCount)
animalBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
animalBox.TextColor3 = Color3.new(1,1,1)
animalBox.FocusLost:Connect(function()
    local val = tonumber(animalBox.Text)
    if val then settings.AnimalCount = val end
end)

local colorBtn = Instance.new("TextButton", settingsPage)
colorBtn.Position = UDim2.new(0.05,0,0,90)
colorBtn.Size = UDim2.new(0.5,0,0,30)
colorBtn.Text = "Toggle Plant Color"
colorBtn.BackgroundColor3 = Color3.fromRGB(80,120,80)
colorBtn.TextColor3 = Color3.new(1,1,1)
colorBtn.MouseButton1Click:Connect(function()
    settings.PlantColorMode = settings.PlantColorMode == "Random" and "Green" or "Random"
    colorBtn.Text = "Plant Color: " .. settings.PlantColorMode
end)

-- === Fun Tab ===
createButton(funPage, "🌈 Magical Plant", 10, function()
    local part = Instance.new("Part")
    part.Size = Vector3.new(2,math.random(3,6),2)
    part.Anchored = true
    part.Shape = Enum.PartType.Cylinder
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromHSV(math.random(),1,1)
    part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-6,6),0,math.random(-6,6))
    part.Parent = workspace
    local tweenService = game:GetService("TweenService")
    local goal = {Position = part.Position + Vector3.new(0,math.random(3,6),0)}
    local tween = tweenService:Create(part,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),goal)
    tween:Play()
end)

createButton(funPage, "🌦️ Random Weather", 50, function()
    local weather = {"Fog","Bright","Dark"}
    local choice = weather[math.random(1,#weather)]
    if choice == "Fog" then
        workspace.FogStart = 0
        workspace.FogEnd = 100
        workspace.FogColor = Color3.fromRGB(200,200,200)
    elseif choice == "Bright" then
        workspace.FogEnd = 1000
        workspace.FogColor = Color3.fromRGB(255,255,255)
    elseif choice == "Dark" then
        workspace.FogEnd = 1000
        workspace.FogColor = Color3.fromRGB(30,30,30)
    end
    game.StarterGui:SetCore("SendNotification", {
        Title = "Weather Changed",
        Text = choice,
        Duration = 3
    })
end)

-- === Fly Mode Implementation ===
local flying = false
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
uis.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        game.StarterGui:SetCore("SendNotification", {
            Title = flying and "Fly Mode Activated" or "Fly Mode Deactivated",
            Text = "Use WASD to move",
            Duration = 3
        })
    end
end)

rs.RenderStepped:Connect(function(delta)
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local dir = Vector3.new()
        if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if dir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + dir.Unit * settings.FlySpeed * delta
        end
    end
end)
