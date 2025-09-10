-- 🛰️ Brainrot Nexus Hub
-- Made by Mohammed
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- ✅ إشعار عند الدخول
StarterGui:SetCore("SendNotification", {
    Title = "Brainrot Nexus",
    Text = "Injected Successfully ✅",
    Duration = 5
})

-- 🖥️ GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "BrainrotNexus"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 330, 0, 420)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "🛰️ Brainrot Nexus"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- ✅ زر رئيسي
local function makeMainButton(name, y)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 25, 0, y)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    return btn
end

-- ✅ إطار فرعي
local function createSubFrame(title)
    local frame = Instance.new("Frame", ScreenGui)
    frame.Size = UDim2.new(0, 260, 0, 320)
    frame.Position = UDim2.new(0.65, 0, 0.25, 0)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    frame.BorderSizePixel = 0
    frame.Visible = false

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, 0, 0, 40)
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(0, 255, 200)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 20
    lbl.BackgroundTransparency = 1

    return frame
end

-- ✅ زر فرعي
local function makeSubButton(frame, name, y, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 220, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, y)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)
end

-- Dummy test
local function activated(feature)
    StarterGui:SetCore("SendNotification", {
        Title = "Brainrot Nexus",
        Text = feature .. " Activated!",
        Duration = 3
    })
end

--------------------------------------------------
-- Tabs
local movementBtn = makeMainButton("🏃 Movement", 60)
local espBtn      = makeMainButton("👁️ ESP & Vision", 110)
local farmBtn     = makeMainButton("💰 Farming", 160)
local miscBtn     = makeMainButton("🎭 Misc / Protection", 210)

-- Frames
local movementFrame = createSubFrame("🏃 Movement")
local espFrame      = createSubFrame("👁️ ESP & Vision")
local farmFrame     = createSubFrame("💰 Farming")
local miscFrame     = createSubFrame("🎭 Misc / Protection")

--------------------------------------------------
-- 🏃 Movement
makeSubButton(movementFrame, "✈️ Fly", 50, function() activated("Fly") end)
makeSubButton(movementFrame, "🦘 Super Jump", 90, function() activated("Super Jump") end)
makeSubButton(movementFrame, "⚡ Speed", 130, function() activated("Speed") end)
makeSubButton(movementFrame, "🚪 NoClip", 170, function() activated("NoClip") end)
makeSubButton(movementFrame, "🌌 Gravity Control", 210, function() activated("Gravity Control") end)

-- 👁️ ESP
makeSubButton(espFrame, "👥 ESP Players", 50, function() activated("ESP Players") end)
makeSubButton(espFrame, "💰 ESP Items", 90, function() activated("ESP Items") end)
makeSubButton(espFrame, "💡 FullBright", 130, function() activated("FullBright") end)
makeSubButton(espFrame, "🔍 X-Ray", 170, function() activated("X-Ray") end)
makeSubButton(espFrame, "➖ Tracers", 210, function() activated("Tracers") end)

-- 💰 Farming
makeSubButton(farmFrame, "💵 Auto Collect", 50, function() activated("Auto Collect") end)
makeSubButton(farmFrame, "🛒 Auto Buy", 90, function() activated("Auto Buy") end)
makeSubButton(farmFrame, "🗡️ Auto Equip", 130, function() activated("Auto Equip") end)
makeSubButton(farmFrame, "🔄 Auto Rejoin", 170, function() activated("Auto Rejoin") end)
makeSubButton(farmFrame, "🌍 Server Hop", 210, function() activated("Server Hop") end)

-- 🎭 Misc
makeSubButton(miscFrame, "🛡️ Godmode", 50, function() activated("Godmode") end)
makeSubButton(miscFrame, "🖥️ Anti-Lag", 90, function() activated("Anti-Lag") end)
makeSubButton(miscFrame, "⏳ Anti-AFK", 130, function() activated("Anti-AFK") end)
makeSubButton(miscFrame, "🎉 Troll", 170, function() activated("Troll Features") end)
makeSubButton(miscFrame, "👂 Chat Spy", 210, function() activated("Chat Spy") end)

--------------------------------------------------
-- Switching tabs
local function hideAll()
    movementFrame.Visible = false
    espFrame.Visible = false
    farmFrame.Visible = false
    miscFrame.Visible = false
end

movementBtn.MouseButton1Click:Connect(function()
    hideAll()
    movementFrame.Visible = true
end)

espBtn.MouseButton1Click:Connect(function()
    hideAll()
    espFrame.Visible = true
end)

farmBtn.MouseButton1Click:Connect(function()
    hideAll()
    farmFrame.Visible = true
end)

miscBtn.MouseButton1Click:Connect(function()
    hideAll()
    miscFrame.Visible = true
end)
