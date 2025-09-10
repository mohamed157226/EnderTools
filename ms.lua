-- 🛰️ Brainrot Hub v1.0
-- Made by Mohammed | For [Steal a Brainrot]
-- GUI + Fly + Speed + Jump + NoClip + AutoCollect + AutoBuy + ESP + DoorLock

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Cleanup old GUI
pcall(function() PlayerGui.BrainrotHub:Destroy() end)

-- UI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "BrainrotHub"
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 420, 0, 400)
main.Position = UDim2.new(0.3, 0, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(15,15,25)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "🛰️ Brainrot Hub"
title.TextColor3 = Color3.fromRGB(0,255,180)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

-- Vars
local fly, noclip, autoCollect, fullbright = false,false,false,false
local speed, jump = 32, 70

-- Notify
local function notify(txt)
    local sg = Instance.new("ScreenGui", PlayerGui)
    sg.Name="BN_Notify"
    local l=Instance.new("TextLabel",sg)
    l.Size=UDim2.new(0,300,0,40)
    l.Position=UDim2.new(0.5,-150,0.1,0)
    l.BackgroundColor3=Color3.fromRGB(20,20,30)
    l.TextColor3=Color3.fromRGB(0,255,180)
    l.Font=Enum.Font.GothamBold
    l.TextSize=16
    l.Text=txt
    game:GetService("Debris"):AddItem(sg,3)
end

notify("✅ Brainrot Hub Loaded!")

-- Movement loop
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if fly then
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
        end
    end
end)

-- Buttons creator
local function makeBtn(text,pos,callback)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(1,-20,0,30)
    b.Position = UDim2.new(0,10,0,pos)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.BackgroundColor3 = Color3.fromRGB(30,30,40)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- Movement
makeBtn("Toggle Fly", 50, function() fly = not fly notify("Fly: "..tostring(fly)) end)
makeBtn("Toggle NoClip", 90, function() noclip = not noclip notify("NoClip: "..tostring(noclip)) end)

-- Auto Collect (for money/brainrot items)
makeBtn("Auto Collect", 130, function()
    autoCollect = not autoCollect
    if autoCollect then
        notify("AutoCollect ON")
        task.spawn(function()
            while autoCollect do
                task.wait(1)
                for _,obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():match("coin") or obj.Name:lower():match("brainrot")) then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                        task.wait()
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                    end
                end
            end
        end)
    else
        notify("AutoCollect OFF")
    end
end)

-- Door Control
makeBtn("Unlock Doors", 170, function()
    for _,d in pairs(workspace:GetDescendants()) do
        if d:IsA("BasePart") and d.Name:lower():match("door") then
            d.CanCollide = false
            d.Transparency = 0.5
        end
    end
    notify("Doors Unlocked")
end)

-- FullBright
makeBtn("Toggle FullBright", 210, function()
    fullbright = not fullbright
    if fullbright then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").Ambient = Color3.new(1,1,1)
        game:GetService("Lighting").OutdoorAmbient = Color3.new(1,1,1)
    else
        game:GetService("Lighting").Ambient = Color3.new(0,0,0)
    end
    notify("FullBright: "..tostring(fullbright))
end)

-- Auto Buy Pet (Example)
makeBtn("Buy Pet Example", 250, function()
    local args = {"Dog", 50}
    local ev = ReplicatedStorage:FindFirstChild("BuyPetEvent")
    if ev then
        ev:FireServer(unpack(args))
        notify("Tried to buy "..args[1])
    else
        notify("⚠️ Pet system not found in this game")
    end
end)
