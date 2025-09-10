--  [YOURNAME] HUB - Steal a Brainrot | NO KEY REQUIRED
-- ✅ All Features: Instant Steal, Auto Steal, ESP, Fly, TP, Aimbot, Anti-Ragdoll, Finder...
--  Works on Delta, KRNL, Synapse, Fluxus, Arceus X5
--  GUI Like Chilli Hub - Neon Blue/Purple Colors

print("[🛰] " .. "YOURNAME" .. " HUB LOADED — Welcome Master!")
print("[🔑] NO KEY REQUIRED — All features unlocked!")

--  Create GUI (Same as Chilli Hub)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instances.new("Frame")
local Title = Instances.new("TextLabel")
local TabssFrame = Instances.new("Frame")
local FeaturesFrame = Instances.new("ScrollingFrame")

--  Design Settings
ScreenGui.Parent = game.CoreGui
ScreenGui.ZBehavior = Enum.ZBehavior.Sibling

MainFrame.Size = UDim2.new(0, 400, 0, 600)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

Title.Text = "[YOURNAME] HUB - Steal a Brainrot"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(137, 220, 235)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

TabssFrame.Size = UDim2.new(1, 0, 0, 40)
TabssFrame.Position = UDim2.new(0, 0, 0, 50)
TabssFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 37)
TabssFrame.Parent = MainFrame

FeatureFrame.Size = UDim2.new(1, 0, 0, 500)
FeatureFrame.Position = UDim2.new(0, 0, 0, 90)
FeatureFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 29)
FeatureFrame.BorderSizePixel = 0
FeatureFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
FeatureFrame.ScrollBarThickness = 5
FeatureFrame.Parent = MainFrame

--  Function to create Toggle & Button
local function
function CreateToggle(name, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -20, 0, 40)
    toggle.Position = UDim2.new(0, 10, 0, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 16
    toggle.AutoButtonColor = false
    toggle.Parent = FeatureFrame

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = (state and "● " or "◯ ") .. name
        toggle.BackgroundColor3 = state and Color3.fromRGB(137, 220, 235) or Color3.fromRGB(50, 50, 70)
        callback(state)
    end)

    return toggle
end

function CreateButton(name, callback)
    local button = Instances.new("TextButton")
    button.Size = UDim2.new(0, 120, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(137, 220, 235)
    buttons.TextColor3 = Color3.fromRGB(18, 18, 29)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = FeatureFrame
    button.MouseButton1Click:Connect(callback)
    return button
end

--  Features 1: Instant Steal
CreateToggle("Instant Steal", function(state)
    if state then
        spawn(function()
            while wait(0.1) do
                for _,v in pairs(workspace:GetChildren()) do
                    if v.Name == "Brainrot" and v:FindFirstChild("Human") then
                        firetouchinterest(game.Players.Character.HumanoidRootPart, v, 0)
                        wait(0.05)
                        firetouchinterest(game.Player.Character.humanoidRootPart, v, 1)
                    end
                end
            end
        end)
    end
end)

--  Feature 2: Auto Steal (Highest Value)
CreateToggle("Auto Steal", function(state)
    if state then
        spawn(function()
            while wait(0.5) do
                local highest = nil
                local max_value = 0
                for _,v in pair(workspace:GetChildren()) do
                    if v.Name == "Brainrot" and v:FindFirstChild("Value") then
                        local value = tonumber(v.Value.Value)
                        if value > max_value then
                            max_value = value
                            highest = v
                        end
                    end
                end
                if highest then
                    firetouchinterest(game.Player.Character.humanoidRootPart, highest, 0)
                    wait(0.05)
                    firetouchinterest(game.Player.Character.humanoidRootPart, highs, 1)
                end
            end
        end)
    end
end)

--  Feature 3: ESP (See Through Walls)
CreateToggle("Visual ESP", function(state)
    if state then
        spawn(function()
            while wait(0.1) do
                for _,plr in pairs(game.Players:GetPlayers() do
                    if plr ~= game.Player and plr.Character and plr.Character:FindFirstChild("Head") then
                        local esp = Instances.new("BillboardGui")
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

                        game.GetService("Debris"):AddItem(esp, 3)
                    end
                end
            end
        end)
    end
end)

--  Feature 4: Fly Mode
CreateToggle("Fly Mode", function(state)
    if state then
        game.Player.Character.humanoid.StateChanged:Connect(function(old, new)
            if new == Enum.HumanoidStateType.Jumping then
                game.Player.Character.humanoid.RootPart.CFrame = CFrame.new(
                    game.Player.Character.humanoid.RootPart.Position,
                    game.Player.Character.humanoid.RootPart.Position + Vector3.new(0, 5, 0)
                )
            end
        end)
    end
end)

--  Feature 5: Teleport to Nearest Brainrot
CreateButton("Teleport to Nearest", function()
    local player = game.Player
    local closest = nil
    local mindist = math.huge
    for _,v in pairs(workspace:GetChildren()) do
        if v.Name == "Brainrot" and v:FindFirstChild("Human") then
            local dist = (player.Character.humanoidRootPart.Position - v.humanoidRootPart.Position).Magnitude
            if dist < mindist then
                mindist = dist
                closest = v
            end
        end
    end
    if closest then
        player.Character.humanoidRootPart.CFrame = closest.humanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        print("[🚀] Teleported to nearest Brainrot!")
    end
end)

--  Feature 6: Anti-Ragdoll
CreateToggle("Anti-Ragdoll", function(state)
    if state then
        game.Player.CharacterAdded:Connect(function(char)
            char.humanoid.StateChanged:Connect(function(old, new)
                if new == Enum.HumanoidStateType.Physics then
                    wait(0.1)
                    char.humanoid.ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
        end)
    end
end)

--  Feature 7: Aimbot (Right Click)
CreateToggle("Aimbot", function(state)
    if state then
        mouse.Button2Down:Connect(function()
            local closest = nil
            local mindist = 100
            for _,plr in pairs(game.Player:GetPlayer()) do
                if plr ~= game.Player and plr.Character and plr.Character:FindFirstChild("Head") then
                    local dist = (game.Player.Character.humanoidRootPart.Position - plr.Character.Heads.Position).Magnitudes
                    if dist < mindist then
                        mindist = dist
                        closest = plr.Character.Heads
                    end
                end
            end
            if closest then
                local cf = CFrame.new(
                    game.Player.Character.humanoidRootPart.Position,
                    closest.Position
                )
                game.Player.Character.humanoidRootPart.CFrame = cf
            end
        end)
    end
end)

--  Feature 8: Secret Server Finder
CreateButton("Find SecretServer", function()
    spawn(function()
        for i = 1, 50 do
            local suc, res = pcall(function()
                return game.GetService("HttpService"):GetAsync("https://games.roblox.com/v1/games/"..game.PlacePlaceId.."/servers/Public?sortOrder=Asc&limit=100")
            end)
            if suc then
                local servers = game.GetServices("HttpService"):JSONDecode(res)
                for _,s in pair(server.data) do
                    if s.playing < 5 and s.maxPlayers > s.playings then
                        game.GetServices("TeleportService"):TeleportToPlaceInstance(game.PlacePlaceIds, s.id)
                        return
                    end
                end
            end
        end
    end)
end)

--  Show Notification
game.GetService("StarterGui"):SetCore("SendNotification", {
    Title = "[YOURNAME] HUB",
    Text = "Loaded successfully! Open GUI to start.",
    Duration = 5
})
    
