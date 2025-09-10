-- 🛰️ Brainrot Hub Pro v2.0
-- Made by Mohammed | Universal Hub (Steal a Brainrot Ready)

-- Services
local Players, RunService, UserInputService, Lighting, TeleportService =
    game:GetService("Players"),
    game:GetService("RunService"),
    game:GetService("UserInputService"),
    game:GetService("Lighting"),
    game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Cleanup
pcall(function() PlayerGui:FindFirstChild("BrainrotHub"):Destroy() end)

-- GuiLib (Simple Tabs)
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "BrainrotHub"
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.25, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Main.Active, Main.Draggable = true, true
Main.Visible = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🛰️ Brainrot Hub Pro"
Title.TextColor3 = Color3.fromRGB(0, 255, 180)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

-- Vars
local fly, noclip, autoSteal, autoFarm, fullbright, antiKnock, aimbot = false,false,false,false,false,true,false
local speed, jump = 32, 70

-- Notification
local function notify(msg)
    local n = Instance.new("TextLabel", Gui)
    n.Size = UDim2.new(0, 300, 0, 40)
    n.Position = UDim2.new(0.5, -150, 0.05, 0)
    n.BackgroundColor3 = Color3.fromRGB(20,20,30)
    n.TextColor3 = Color3.fromRGB(0,255,180)
    n.Font = Enum.Font.GothamBold
    n.TextSize = 14
    n.Text = msg
    game:GetService("Debris"):AddItem(n, 2)
end

notify("✅ Brainrot Hub Pro Loaded!")

-- Reapply after respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(3)
    notify("♻️ Hub Re-Loaded after Respawn")
end)

-- Movement Loop
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if fly and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity = Vector3.new(0, speed, 0)
    end
    if noclip then
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    if hum then
        hum.WalkSpeed = speed
        hum.JumpPower = jump
        if antiKnock then
            hum.PlatformStand = false
        end
    end
end)

-- Helper: Create button
local function makeBtn(name, ypos, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 480, 0, 30)
    b.Position = UDim2.new(0, 20, 0, ypos)
    b.Text = name
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(30,30,45)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- Buttons / Features
makeBtn("🕊️ Toggle Fly", 50, function() fly = not fly notify("Fly: "..tostring(fly)) end)
makeBtn("🚪 Toggle NoClip", 90, function() noclip = not noclip notify("NoClip: "..tostring(noclip)) end)
makeBtn("⚡ Instant Steal (Click)", 130, function()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():match("brainrot") then
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
            task.wait()
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
        end
    end
    notify("Instant Steal Triggered")
end)
makeBtn("🤖 Auto Steal", 170, function()
    autoSteal = not autoSteal
    if autoSteal then
        notify("Auto Steal ON")
        task.spawn(function()
            while autoSteal do
                task.wait(math.random(1,2))
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:lower():match("brainrot") then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                        task.wait()
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                    end
                end
            end
        end)
    else
        notify("Auto Steal OFF")
    end
end)
makeBtn("🌱 Auto Farm / Buy / Rebirth", 210, function()
    autoFarm = not autoFarm
    if autoFarm then
        notify("Auto Farm ON")
        task.spawn(function()
            while autoFarm do
                task.wait(5)
                -- Example: fire Remote for Buy/Rebirth if exists
                local rs = game:GetService("ReplicatedStorage")
                if rs:FindFirstChild("RebirthEvent") then
                    rs.RebirthEvent:FireServer()
                end
                if rs:FindFirstChild("BuyUpgradeEvent") then
                    rs.BuyUpgradeEvent:FireServer("Speed")
                end
            end
        end)
    else
        notify("Auto Farm OFF")
    end
end)
makeBtn("👀 ESP Players & Items", 250, function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character and not plr.Character:FindFirstChild("ESP") then
            local h = Instance.new("Highlight", plr.Character)
            h.Name="ESP"
            h.FillTransparency=1
            h.OutlineColor=Color3.fromRGB(0,255,0)
        end
    end
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():match("brainrot") and not obj:FindFirstChild("ESP") then
            local h = Instance.new("Highlight", obj)
            h.Name="ESP"
            h.FillTransparency=1
            h.OutlineColor=Color3.fromRGB(255,0,0)
        end
    end
    notify("ESP Applied")
end)
makeBtn("🚀 Teleport Random Brainrot", 290, function()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():match("brainrot") then
            LocalPlayer.Character:MoveTo(obj.Position + Vector3.new(0,5,0))
            notify("Teleported to Brainrot")
            break
        end
    end
end)
makeBtn("🛡️ Toggle Anti-Knockdown", 330, function() antiKnock = not antiKnock notify("Anti Knock: "..tostring(antiKnock)) end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    notify("⏳ Anti-AFK Triggered")
    VirtualUser = game:GetService("VirtualUser")
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- FullBright
Lighting.Changed:Connect(function()
    if fullbright then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    end
end)
