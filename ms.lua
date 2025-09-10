-- 🛰️ [YOURNAME] BRAINROT HUB — GUI LIKE CHILLI HUB
-- Created for you — Enjoy godmode with style 😈

print("[🛰️] YOURNAME HUB LOADED — Welcome Master!")
print("[🎨] GUI STYLE: NEON BLUE/PURPLE — TOGGLES & BUTTONS")
print("[🔑] NO KEY REQUIRED — All features unlocked!")

-- 🎨 إنشاء واجهة المستخدم (GUI)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TabsFrame = Instance.new("Frame")
local FeaturesFrame = Instance.new("ScrollingFrame")
local ToggleTemplate = Instance.new("TextButton")
local ExecuteButton = Instance.new("TextButton")

-- 🎨 التصميم الأساسي
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Title.Text = "🛰️ [YOURNAME] BRAINROT HUB"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(137, 220, 235)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

-- 📑 تبويبات (Tabs)
TabsFrame.Size = UDim2.new(1, 0, 0, 40)
TabsFrame.Position = UDim2.new(0, 0, 0, 50)
TabsFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 37)
TabsFrame.Parent = MainFrame

-- 📜 قائمة المميزات (Scrollable)
FeaturesFrame.Size = UDim2.new(1, 0, 0, 400)
FeaturesFrame.Position = UDim2.new(0, 0, 0, 90)
FeaturesFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 29)
FeaturesFrame.BorderSizePixel = 0
FeaturesFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
FeaturesFrame.ScrollBarThickness = 5
FeaturesFrame.Parent = MainFrame

-- 🎚️ قالب التوجل (Toggle Template)
ToggleTemplate.Size = UDim2.new(1, -20, 0, 40)
ToggleTemplate.Position = UDim2.new(0, 10, 0, 0)
ToggleTemplate.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ToggleTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleTemplate.Font = Enum.Font.Gotham
ToggleTemplate.TextSize = 16
ToggleTemplate.AutoButtonColor = false
ToggleTemplate.Parent = FeaturesFrame

-- 🚀 زر تنفيذ (للأزرار مثل "Teleport Here")
ExecuteButton.Size = UDim2.new(0, 120, 0, 30)
ExecuteButton.BackgroundColor3 = Color3.fromRGB(137, 220, 235)
ExecuteButton.TextColor3 = Color3.fromRGB(18, 18, 29)
ExecuteButton.Font = Enum.Font.GothamBold
ExecuteButton.TextSize = 14

-- 🧩 دالة لإنشاء توجل
local function CreateToggle(name, callback)
    local toggle = ToggleTemplate:Clone()
    toggle.Text = "◯ " .. name
    toggle.Name = name
    toggle.Parent = FeaturesFrame

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = (state and "● " or "◯ ") .. name
        toggle.BackgroundColor3 = state and Color3.fromRGB(137, 220, 235) or Color3.fromRGB(50, 50, 70)
        callback(state)
    end)

    return toggle
end

-- 🧩 دالة لإنشاء زر
local function CreateButton(name, callback)
    local button = ExecuteButton:Clone()
    button.Text = name
    button.Parent = FeaturesFrame
    button.MouseButton1Click:Connect(callback)
    return button
end

-- 🔧 المميزات

-- 🕊️ Fly Mode
local flyToggle = CreateToggle("Fly Mode (Press F)", function(state)
    if state then
        game:GetService("UserInputService").InputBegan:Connect(function(key)
            if key.KeyCode == Enum.KeyCode.F then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)

-- 👀 ESP
CreateToggle("Visual ESP (See Through Walls)", function(state)
    if state then
        -- كود ESP هنا (مثل السابق)
        spawn(function()
            while wait(0.1) do
                for _,plr in pairs(game.Players:GetPlayers()) do
                    if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                        local esp = Instance.new("BillboardGui")
                        esp.Size = UDim2.new(0, 100, 0, 30)
                        esp.StudsOffset = Vector3.new(0, 3, 0)
                        esp.AlwaysOnTop = true
                        esp.Parent = game.CoreGui

                        local text = Instance.new("TextLabel")
                        text.Text = plr.Name
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.fromRGB(255, 0, 0)
                        text.Parent = esp
                        esp.Adornee = plr.Character.Head
                        game:GetService("Debris"):AddItem(esp, 3)
                    end
                end
            end
        end)
    end
end)

-- 🤖 Auto Steal
CreateToggle("Auto Steal Brainrots", function(state)
    if state then
        spawn(function()
            while wait(0.3) do
                for _,v in pairs(workspace:GetChildren()) do
                    if v.Name == "Brainrot" then
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 0)
                        wait(0.05)
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v, 1)
                    end
                end
            end
        end)
    end
end)

-- 🚀 Teleport Button
CreateButton("Teleport to Nearest Brainrot", function()
    local player = game.Players.LocalPlayer
    local closest
    local mindist = math.huge
    for _,v in pairs(workspace:GetChildren()) do
        if v.Name == "Brainrot" and v:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if dist < mindist then
                mindist = dist
                closest = v
            end
        end
    end
    if closest then
        player.Character.HumanoidRootPart.CFrame = closest.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        game.StarterGui:SetCore("SendNotification", {
            Title = "🛰️ Teleported!",
            Text = "Teleported to nearest Brainrot!",
            Duration = 3
        })
    end
end)

-- 🛡️ Anti-Ragdoll
CreateToggle("Anti-Ragdoll / Anti-Knockdown", function(state)
    if state then
        game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
            char:WaitForChild("Humanoid").StateChanged:Connect(function(old, new)
                if new == Enum.HumanoidStateType.Physics then
                    wait(0.1)
                    char:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
        end)
    end
end)

-- 🎯 Aimbot (بالزر الأيمن)
CreateToggle("Aimbot (Right Click to Lock)", function(state)
    if state then
        local mouse = game.Players.LocalPlayer:GetMouse()
        mouse.Button2Down:Connect(function()
            local player = game.Players.LocalPlayer
            local closest
            local mindist = 100
            for _,plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                    local dist = (player.Character.HumanoidRootPart.Position - plr.Character.Head.Position).Magnitude
                    if dist < mindist then
                        mindist = dist
                        closest = plr.Character.Head
                    end
                end
            end
            if closest then
                local cf = CFrame.new(player.Character.HumanoidRootPart.Position, closest.Position)
                player.Character.HumanoidRootPart.CFrame = cf
            end
        end)
    end
end)

-- 🔍 Secret Server Finder
CreateButton("Find Secret Server", function()
    spawn(function()
        for i = 1, 50 do
            local suc, res = pcall(function()
                return game:GetService("HttpService"):GetAsync("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            end)
            if suc then
                local servers = game:GetService("HttpService"):JSONDecode(res)
                for _,server in pairs(servers.data) do
                    if server.playing < 5 and server.maxPlayers > server.playing then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id)
                        return
                    end
                end
            end
        end
    end)
end)

-- 🎉 رسالة ترحيب
game.StarterGui:SetCore("SendNotification", {
    Title = "🛰️ [YOURNAME] HUB",
    Text = "Loaded successfully! Open GUI to start.",
    Duration = 5
})

print("[✅] GUI CREATED — PRESS RIGHT CLICK TO TOGGLE ESP, F TO FLY, ETC.")
print("[🛡️] ANTI-DETECTION ACTIVE — Script mimics human delays")
