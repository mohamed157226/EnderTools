-- ✨ Grow a Garden 🌶️ Ultimate GUI Script
loadstring([[
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
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0,10)
UIListLayout.Parent = Frame

-- Helper function to create buttons
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

-- Speed
local Speed = 100
createButton("Set Speed", function()
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

    local shovel = Instance.new("Tool")
    shovel.Name = "Super Shovel"
    shovel.Parent = backpack

    local wateringCan = Instance.new("Tool")
    wateringCan.Name = "Watering Can"
    wateringCan.Parent = backpack

    local superSeeds = Instance.new("Tool")
    superSeeds.Name = "Super Seeds"
    superSeeds.Parent = backpack
end)

-- AutoFarm (مثال: يحركك ويجمع كل الأدوات)
createButton("AutoFarm", function()
    print("AutoFarm started! 🌱 (Needs game-specific positions to fully work)")
end)

-- Teleport (مثال)
createButton("Teleport to Garden", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,10,0)
    end
en
