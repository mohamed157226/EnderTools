-- Brainrot Nexus - OneScript Edition
-- حط السكربت ده في ServerScriptService، وهو هيبني كل حاجة لوحده.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- ===[ Create RemoteEvents if missing ]===
local function ensureEvent(name)
    local ev = ReplicatedStorage:FindFirstChild(name)
    if not ev then
        ev = Instance.new("RemoteEvent")
        ev.Name = name
        ev.Parent = ReplicatedStorage
    end
    return ev
end

local BuyPetEvent = ensureEvent("BuyPetEvent")
local RequestCollect = ensureEvent("RequestCollect")
local ToggleDoorEvent = ensureEvent("ToggleDoorEvent")

-- Ensure Pets folder exists
local PetsFolder = ReplicatedStorage:FindFirstChild("Pets")
if not PetsFolder then
    PetsFolder = Instance.new("Folder", ReplicatedStorage)
    PetsFolder.Name = "Pets"
    PetsFolder.Parent = ReplicatedStorage
end

-- ===[ Server Side Logic ]===
Players.PlayerAdded:Connect(function(plr)
    if plr:GetAttribute("Coins") == nil then
        plr:SetAttribute("Coins", 0)
    end
    if plr:GetAttribute("BN_Settings") == nil then
        plr:SetAttribute("BN_Settings", "")
    end
end)

-- Buy Pet
BuyPetEvent.OnServerEvent:Connect(function(player, petName, price)
    if typeof(petName) ~= "string" or typeof(price) ~= "number" then return end
    local coins = player:GetAttribute("Coins") or 0
    if coins < price then
        BuyPetEvent:FireClient(player, false, "Not enough coins!")
        return
    end
    local pet = PetsFolder:FindFirstChild(petName)
    if not pet then
        BuyPetEvent:FireClient(player, false, "Pet not found!")
        return
    end
    player:SetAttribute("Coins", coins - price)
    local clone = pet:Clone()
    clone.Name = petName .. "_" .. player.UserId
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        clone:SetPrimaryPartCFrame(player.Character.HumanoidRootPart.CFrame * CFrame.new(3,0,0))
    end
    clone.Parent = workspace
    BuyPetEvent:FireClient(player, true, "Bought " .. petName .. "!")
end)

-- Collect Coin
RequestCollect.OnServerEvent:Connect(function(player, part)
    if not part or not part:IsA("BasePart") then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local dist = (player.Character.HumanoidRootPart.Position - part.Position).Magnitude
    if dist > 50 then return end
    if part.Name:lower():match("coin") or part:GetAttribute("IsCollectable") then
        local amt = part:GetAttribute("Value") or 10
        player:SetAttribute("Coins", (player:GetAttribute("Coins") or 0) + amt)
        pcall(function() part:Destroy() end)
        RequestCollect:FireClient(player, true, amt)
    end
end)

-- Toggle Door
ToggleDoorEvent.OnServerEvent:Connect(function(player, doorName)
    local doors = workspace:FindFirstChild("Doors")
    if not doors then return end
    local door = doors:FindFirstChild(doorName)
    if not door then return end
    local locked = door:FindFirstChild("Locked") or Instance.new("BoolValue", door)
    locked.Name = "Locked"
    locked.Value = not locked.Value
    local doorPart = door:FindFirstChild("DoorPart")
    if doorPart then
        doorPart.CanCollide = not locked.Value
        doorPart.Transparency = locked.Value and 0.5 or 0
    end
    ToggleDoorEvent:FireClient(player, true, locked.Value)
end)

-- ===[ Insert LocalScript to each player automatically ]===
local clientSource = [[
-- Brainrot Nexus Client Side GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local BuyPetEvent = ReplicatedStorage:WaitForChild("BuyPetEvent")
local RequestCollect = ReplicatedStorage:WaitForChild("RequestCollect")
local ToggleDoorEvent = ReplicatedStorage:WaitForChild("ToggleDoorEvent")
local PetsFolder = ReplicatedStorage:FindFirstChild("Pets")

-- Remove old
pcall(function() PlayerGui.BrainrotNexusGUI:Destroy() end)

-- Settings
local SETTINGS = {speed=30,jumpPower=70,flySpeed=60}
pcall(function()
    local saved = LocalPlayer:GetAttribute("BN_Settings")
    if saved ~= "" then
        local ok,t = pcall(function() return HttpService:JSONDecode(saved) end)
        if ok then SETTINGS = t end
    end
end)

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

-- GUI
local gui = Instance.new("ScreenGui",PlayerGui)
gui.Name="BrainrotNexusGUI"
local main = Instance.new("Frame",gui)
main.Size=UDim2.new(0,400,0,400)
main.Position=UDim2.new(0.2,0,0.2,0)
main.BackgroundColor3=Color3.fromRGB(18,18,26)
main.Active=true
main.Draggable=true

local title=Instance.new("TextLabel",main)
title.Size=UDim2.new(1,0,0,40)
title.Text="🛰️ Brainrot Nexus Premium"
title.TextColor3=Color3.fromRGB(0,255,180)
title.Font=Enum.Font.GothamBold
title.TextSize=18
title.BackgroundTransparency=1

-- Features
local fly,noclip,autoCollect=false,false,false

RunService.RenderStepped:Connect(function()
    local char=LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hum=char:FindFirstChildOfClass("Humanoid")
        if fly then
            char.HumanoidRootPart.Velocity=Vector3.new(0,SETTINGS.flySpeed,0)
        end
        if noclip then
            for _,p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end
        if hum then
            hum.WalkSpeed=SETTINGS.speed
            hum.JumpPower=SETTINGS.jumpPower
        end
    end
end)

local function makeBtn(txt,pos,func)
    local b=Instance.new("TextButton",main)
    b.Size=UDim2.new(1,-20,0,30)
    b.Position=UDim2.new(0,10,0,pos)
    b.Text=txt
    b.Font=Enum.Font.Gotham
    b.TextSize=14
    b.TextColor3=Color3.fromRGB(255,255,255)
    b.BackgroundColor3=Color3.fromRGB(30,30,40)
    b.MouseButton1Click:Connect(func)
end

makeBtn("Toggle Fly",50,function() fly=not fly notify("Fly: "..tostring(fly)) end)
makeBtn("Toggle NoClip",90,function() noclip=not noclip notify("NoClip: "..tostring(noclip)) end)
makeBtn("Auto Collect",130,function()
    autoCollect=not autoCollect
    if autoCollect then
        notify("AutoCollect ON")
        task.spawn(function()
            while autoCollect do
                task.wait(1)
                local coins=workspace:FindFirstChild("Coins")
                if coins then
                    for _,c in pairs(coins:GetChildren()) do
                        RequestCollect:FireServer(c)
                    end
                end
            end
        end)
    else notify("AutoCollect OFF") end
end)
makeBtn("Buy Random Pet",170,function()
    if PetsFolder and #PetsFolder:GetChildren()>0 then
        local pet=PetsFolder:GetChildren()[math.random(1,#PetsFolder:GetChildren())]
        BuyPetEvent:FireServer(pet.Name,50)
    end
end)
makeBtn("Toggle Door (Door1)",210,function()
    ToggleDoorEvent:FireServer("Door1")
end)

notify("✅ Brainrot Nexus Loaded!")
]]

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        local starterScript = Instance.new("LocalScript")
        starterScript.Name = "BrainrotClient"
        starterScript.Source = clientSource
        starterScript.Parent = plr:WaitForChild("PlayerGui")
    end)
end)
