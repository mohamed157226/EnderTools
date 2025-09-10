-- ✨ Grow a Garden 🌶️ Super Ultimate + Loadstring
loadstring([[
-- تحميل السكربت الخارجي من GitHub
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/mohamed157226/EnderTools/refs/heads/main/ms.lua"))()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrowGardenGUI"
ScreenGui.Parent = playerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 500)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0,10)
UIListLayout.Parent = Frame

-- Helper functions
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Text = text
    btn.Parent = Frame
    btn.MouseButton1Click:Connect(callback)
end

local function createSlider(text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
    sliderFrame.Parent = Frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5,0,1,0)
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18
    label.Parent = sliderFrame

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(0.5,0,1,0)
    slider.Position = UDim2.new(0.5,0,0,0)
    slider.BackgroundColor3 = Color3.fromRGB(120,120,120)
    slider.Text = ""
    slider.Parent = sliderFrame

    local value = default
    slider.MouseButton1Down:Connect(function()
        value = math.clamp(value + 10, min, max)
        label.Text = text .. ": " .. value
        callback(value)
    end)
end

-- Speed
local Speed = 50
createSlider("Speed", 16, 500, Speed, function(val)
    Speed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Speed
    end
end)

-- Fly
local flying = false
createButton("Toggle Fly", function()
    if not LocalPlayer.Character then return end
    local character = LocalPlayer.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    flying = not flying
    if flying then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(400000,400000,400000)
        bodyVelocity.Parent = humanoidRootPart
    else
        if humanoidRootPart:FindFirstChild("FlyVelocity") then
            humanoidRootPart.FlyVelocity:Destroy()
        end
    end
end)

-- Give Tools
createButton("Give Tools", function()
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local function addTool(name)
        local tool = Instance.new("Tool")
        tool.Name = name
        tool.Parent = backpack
    end
    addTool("Super Shovel")
    addTool("Watering Can")
    addTool("Super Seeds")
end)

-- AutoFarm / Harvest
local autoFarmEnabled = false
createButton("Toggle AutoFarm", function()
    autoFarmEnabled = not autoFarmEnabled
end)

RunService.RenderStepped:Connect(function()
    if autoFarmEnabled then
        print("🌱 AutoFarm running... (يمكنك إضافة مواقع اللعبة الخاصة هنا)")
    end
end)

-- Teleport
createButton("Teleport to Garden", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,10,0)
    end
end)

-- Spawn Tools
createButton("Spawn Super Tool", function()
    local backpack = LocalPlayer:WaitForChild("Backpack")
    local tool = Instance.new("Tool")
    tool.Name = "Mega Tool"
    tool.Parent = backpack
end)

print("✨ Grow a Garden 🌶️ Super Ultimate Script Loaded! GUI ready at top-left.")
]])()
