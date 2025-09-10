-- 🛰️ Brainrot Hub Ultimate v4.0
-- Made by Mohammed | Optimized for Steal a Brainrot

local Players, RunService, UserInputService, Lighting, ReplicatedStorage, TeleportService =
    game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"),
    game:GetService("Lighting"), game:GetService("ReplicatedStorage"), game:GetService("TeleportService")

local LocalPlayer, PlayerGui = Players.LocalPlayer, Players.LocalPlayer:WaitForChild("PlayerGui")

-- Clean up old
pcall(function() PlayerGui:FindFirstChild("BrainrotHub"):Destroy() end)

-- Settings
local Settings = {
    Fly = false, NoClip = false, AutoSteal = false, AutoFarm = false, ESP = false,
    Speed = 32, Jump = 70, FullBright = false, AntiKnock = true
}

-- Save/Load
local function saveSettings()
    if isfile and writefile then
        writefile("BrainrotHub.json", game:GetService("HttpService"):JSONEncode(Settings))
    end
end
local function loadSettings()
    if isfile and readfile and isfile("BrainrotHub.json") then
        local data = game:GetService("HttpService"):JSONDecode(readfile("BrainrotHub.json"))
        for k,v in pairs(data) do Settings[k]=v end
    end
end
loadSettings()

-- Notify
local function notify(msg)
    local sg = Instance.new("ScreenGui", PlayerGui)
    sg.Name = "BN_Notify"
    local lbl = Instance.new("TextLabel", sg)
    lbl.Size, lbl.Position = UDim2.new(0, 300, 0, 40), UDim2.new(0.5, -150, 0.1, 0)
    lbl.BackgroundColor3, lbl.TextColor3 = Color3.fromRGB(20,20,30), Color3.fromRGB(0,255,180)
    lbl.Font, lbl.TextSize, lbl.Text = Enum.Font.GothamBold, 16, msg
    game:GetService("Debris"):AddItem(sg, 3)
end

notify("✅ Brainrot Hub Ultimate v4.0 Loaded!")

-- GUI
local hub, main = Instance.new("ScreenGui", PlayerGui), Instance.new("Frame")
hub.Name = "BrainrotHub"
main.Parent, main.Size, main.Position, main.BackgroundColor3 =
    hub, UDim2.new(0, 600, 0, 400), UDim2.new(0.25, 0, 0.2, 0), Color3.fromRGB(15, 15, 25)
main.Active, main.Draggable = true, true

-- Tabs
local tabs, content = Instance.new("Frame", main), Instance.new("Frame", main)
tabs.Size, tabs.Position, tabs.BackgroundColor3 = UDim2.new(0, 120, 1, -40), UDim2.new(0,0,0,40), Color3.fromRGB(25,25,35)
content.Size, content.Position, content.BackgroundColor3 = UDim2.new(1,-120,1,-40), UDim2.new(0,120,0,40), Color3.fromRGB(20,20,30)

local function newTab(name)
    local btn = Instance.new("TextButton", tabs)
    btn.Size, btn.Text = UDim2.new(1,0,0,30), name
    btn.Font, btn.TextSize, btn.TextColor3, btn.BackgroundColor3 = Enum.Font.Gotham, 14, Color3.fromRGB(255,255,255), Color3.fromRGB(30,30,45)
    local frame = Instance.new("ScrollingFrame", content)
    frame.Size, frame.Visible, frame.ScrollBarThickness = UDim2.new(1,0,1,0), false, 6
    btn.MouseButton1Click:Connect(function() for _,v in pairs(content:GetChildren()) do v.Visible=false end frame.Visible=true end)
    return frame
end

local function makeBtn(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size, b.Position = UDim2.new(1,-20,0,30), UDim2.new(0,10,0,#parent:GetChildren()*35)
    b.Text, b.Font, b.TextSize, b.TextColor3, b.BackgroundColor3 = text, Enum.Font.Gotham, 14, Color3.fromRGB(255,255,255), Color3.fromRGB(35,35,50)
    b.MouseButton1Click:Connect(callback)
end

-- Tabs
local movementTab, farmTab, espTab, tpTab, miscTab, settingsTab =
    newTab("Movement"), newTab("Farming"), newTab("ESP"), newTab("Teleports"), newTab("Misc"), newTab("Settings")

-- Movement
makeBtn(movementTab,"🕊️ Toggle Fly",function() Settings.Fly=not Settings.Fly notify("Fly: "..tostring(Settings.Fly)) saveSettings() end)
makeBtn(movementTab,"🚪 Toggle NoClip",function() Settings.NoClip=not Settings.NoClip notify("NoClip: "..tostring(Settings.NoClip)) saveSettings() end)

-- Farming
makeBtn(farmTab,"⚡ Instant Steal",function()
    local char = LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then
        for _,obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():match("brainrot") then
                firetouchinterest(char.HumanoidRootPart,obj,0) task.wait() firetouchinterest(char.HumanoidRootPart,obj,1)
            end
        end
    end
end)

makeBtn(farmTab,"🤖 Auto Steal",function()
    Settings.AutoSteal=not Settings.AutoSteal
    if Settings.AutoSteal then
        task.spawn(function()
            while Settings.AutoSteal do task.wait(1)
                pcall(function()
                    local char = LocalPlayer.Character
                    for _,obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj.Name:lower():match("brainrot") then
                            firetouchinterest(char.HumanoidRootPart,obj,0) task.wait() firetouchinterest(char.HumanoidRootPart,obj,1)
                        end
                    end
                end)
            end
        end)
    end
    saveSettings()
end)

makeBtn(farmTab,"🌱 Auto Farm/Buy/Rebirth",function()
    Settings.AutoFarm=not Settings.AutoFarm
    if Settings.AutoFarm then
        task.spawn(function()
            while Settings.AutoFarm do task.wait(5)
                pcall(function()
                    if ReplicatedStorage:FindFirstChild("RebirthEvent") then ReplicatedStorage.RebirthEvent:FireServer() end
                    if ReplicatedStorage:FindFirstChild("BuyUpgradeEvent") then ReplicatedStorage.BuyUpgradeEvent:FireServer("Speed") end
                end)
            end
        end)
    end
    saveSettings()
end)

-- ESP
makeBtn(espTab,"👀 Toggle ESP",function() Settings.ESP=not Settings.ESP notify("ESP: "..tostring(Settings.ESP)) saveSettings() end)

-- Teleports
makeBtn(tpTab,"🏠 Return to Base",function()
    if workspace:FindFirstChild(LocalPlayer.Name.."_Base") then
        LocalPlayer.Character:PivotTo(workspace[LocalPlayer.Name.."_Base"].PrimaryPart.CFrame)
    else
        LocalPlayer.Character:PivotTo(workspace.SpawnLocation.CFrame)
    end
end)

makeBtn(tpTab,"🛰️ Teleport to Brainrots",function()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():match("brainrot") then
            LocalPlayer.Character:PivotTo(obj.CFrame+Vector3.new(0,3,0))
            break
        end
    end
end)

makeBtn(tpTab,"👥 Teleport to Random Player",function()
    local plrs=Players:GetPlayers()
    local target=plrs[math.random(1,#plrs)]
    if target and target.Character then LocalPlayer.Character:PivotTo(target.Character:GetPivot()) end
end)

-- Misc
makeBtn(miscTab,"💡 Toggle FullBright",function() Settings.FullBright=not Settings.FullBright saveSettings() end)
makeBtn(miscTab,"🛡️ Toggle Anti Knock",function() Settings.AntiKnock=not Settings.AntiKnock saveSettings() end)
makeBtn(miscTab,"🔄 Server Hop",function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)

-- Respawn Auto Reinjection
LocalPlayer.CharacterAdded:Connect(function() task.wait(3) notify("♻️ Hub Re-Loaded After Respawn") loadSettings() end)

-- Loops
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if Settings.Fly and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.Velocity=Vector3.new(0,Settings.Speed,0) end
    if Settings.NoClip then for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
    if hum then hum.WalkSpeed, hum.JumpPower, hum.PlatformStand = Settings.Speed, Settings.Jump, not Settings.AntiKnock end
    if Settings.FullBright then Lighting.Ambient=Color3.new(1,1,1) Lighting.Brightness=2 end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function() local vu=game:GetService("VirtualUser") vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame) end)
