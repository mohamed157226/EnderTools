local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService, RunService, TeleportService, players, wrk = game:GetService("HttpService"), game:GetService("RunService"), game:GetService("TeleportService"), game:GetService("Players"), game:GetService("Workspace")
local plr, hrp, humanoid = players.LocalPlayer, players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), players.LocalPlayer.Character:FindFirstChild("Humanoid")
plr.CharacterAdded:Connect(function(c) hrp = c:WaitForChild("HumanoidRootPart"); humanoid = c:WaitForChild("Humanoid") end)
if plr.Character then hrp, humanoid = plr.Character:FindFirstChild("HumanoidRootPart"), plr.Character:FindFirstChild("Humanoid") end
local camera, mouse = wrk.CurrentCamera, plr:GetMouse()
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local hue, rainbowFov, rainbowSpeed, aimFov, aimParts, aiming, predictionStrength, smoothing = 0, false, 0.005, 100, {"Head"}, false, 0.065, 0.05
local aimbotEnabled, wallCheck, stickyAimEnabled, teamCheck, healthCheck, minHealth = false, true, false, false, false, 0
local antiAim, antiAimAmountX, antiAimAmountY, antiAimAmountZ, antiAimMethod, randomVeloRange = false, 0, -100, 0, "Reset Velo", 100
local spinBot, spinBotSpeed = false, 20
local circleColor, targetedCircleColor = Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0)
local aimViewerEnabled, ignoreSelf = false, true
local currentTarget, currentTargetPart

local Window = Rayfield:CreateWindow({Name="Obsidian", LoadingTitle="Obsidian", LoadingSubtitle="by char", ConfigurationSaving={Enabled=true, FolderName="obsidian", FileName="char"}})
local Aimbot, AntiAim, Misc = Window:CreateTab("Aimbot"), Window:CreateTab("Anti-Aim"), Window:CreateTab("Misc")

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness, fovCircle.Radius, fovCircle.Filled, fovCircle.Color, fovCircle.Visible = 2, aimFov, false, circleColor, false

local function checkTeam(p) return teamCheck and p.Team==plr.Team end
local function checkWall(c) local t=c:FindFirstChild("Head"); if not t then return true end; local r=wrk:Raycast(camera.CFrame.Position,(t.Position-camera.CFrame.Position).unit*(t.Position-camera.CFrame.Position).magnitude,{FilterDescendantsInstances={plr.Character,c}, FilterType=Enum.RaycastFilterType.Blacklist}) return r and r.Instance~=nil end
local function getClosestPart(c) local cp, scd = nil, aimFov; for _,pn in ipairs(aimParts) do local p=c:FindFirstChild(pn); if p then local sp = camera:WorldToViewportPoint(p.Position); local d = (Vector2.new(sp.X,sp.Y)-Vector2.new(mouse.X,mouse.Y)).Magnitude; if d<scd and sp.Z>0 then cp,scd=p,d end end end return cp end
local function getTarget() local np, cp, scd=nil,nil,aimFov; for _,p in ipairs(players:GetPlayers()) do if p~=plr and p.Character and not checkTeam(p) and (p.Character.Humanoid.Health>=minHealth or not healthCheck) then local tp=getClosestPart(p.Character); if tp then local sp=camera:WorldToViewportPoint(tp.Position); local d=(Vector2.new(sp.X,sp.Y)-Vector2.new(mouse.X,mouse.Y)).Magnitude; if d<scd and (not wallCheck or not checkWall(p.Character)) then np,tp,scd=p,tp,d end end end end return np,cp end
local function predict(p,part) return p and part and part.Position + (p.Character.HumanoidRootPart.Velocity*predictionStrength) end
local function smooth(from,to) return from:Lerp(to,smoothing) end
local function aimAt(p,part) local pp=predict(p,part); if pp and (p.Character.Humanoid.Health>=minHealth or not healthCheck) then camera.CFrame=smooth(camera.CFrame,CFrame.new(camera.CFrame.Position,pp)) end end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + 50)
        fovCircle.Color = rainbowFov and Color3.fromHSV((hue+hue+rainbowSpeed)%1,1,1) or (aiming and currentTarget and targetedCircleColor or circleColor)
        if rainbowFov then hue=(hue+rainbowSpeed)%1 end
        if aiming then
            if stickyAimEnabled and currentTarget then
                local sp=camera:WorldToViewportPoint(currentTarget.Character.Head.Position); if (Vector2.new(sp.X,sp.Y)-Vector2.new(mouse.X,mouse.Y)).Magnitude>aimFov or (wallCheck and checkWall(currentTarget.Character)) or checkTeam(currentTarget) then currentTarget=nil end
            end
            if not stickyAimEnabled or not currentTarget then currentTarget,currentTargetPart=getTarget() end
            if currentTarget and currentTargetPart then aimAt(currentTarget,currentTargetPart) end
        else currentTarget=nil end
    end
end)

RunService.Heartbeat:Connect(function()
    if antiAim then
        if antiAimMethod=="Reset Velo" then local v=hrp.Velocity; hrp.Velocity=Vector3.new(antiAimAmountX,antiAimAmountY,antiAimAmountZ); RunService.RenderStepped:Wait(); hrp.Velocity=v
        elseif antiAimMethod=="Reset Pos [BROKEN]" then local p=hrp.CFrame; hrp.Velocity=Vector3.new(antiAimAmountX,antiAimAmountY,antiAimAmountZ); RunService.RenderStepped:Wait(); hrp.CFrame=p
        elseif antiAimMethod=="Random Velo" then local v=hrp.Velocity; hrp.Velocity=Vector3.new(math.random(-randomVeloRange,randomVeloRange),math.random(-randomVeloRange,randomVeloRange),math.random(-randomVeloRange,randomVeloRange)); RunService.RenderStepped:Wait(); hrp.Velocity=v end
    end
end)

mouse.Button2Down:Connect(function() if aimbotEnabled then aiming=true end end)
mouse.Button2Up:Connect(function() if aimbotEnabled then aiming=false end end)

local function CreateToggle(tab,name,flag,cb,def) tab:CreateToggle({Name=name,CurrentValue=def or false,Flag=flag,Callback=cb}) end
local function CreateSlider(tab,name,range,inc,cur,flag,cb) tab:CreateSlider({Name=name,Range=range,Increment=inc,CurrentValue=cur,Flag=flag,Callback=cb}) end
local function CreateDropdown(tab,name,opt,cur,flag,cb) tab:CreateDropdown({Name=name,Options=opt,CurrentOption=cur,Flag=flag,Callback=cb}) end
local function CreateColor(tab,name,col,cb) tab:CreateColorPicker({Name=name,Color=col,Callback=cb}) end

CreateToggle(Aimbot,"Aimbot","Aimbot",function(v) aimbotEnabled=v; fovCircle.Visible=v end,false)
CreateDropdown(Aimbot,"Aim Part",{"Head","HumanoidRootPart","Left Arm","Right Arm","Torso","Left Leg","Right Leg"},{"Head"}, "AimPart",function(opt) aimParts=opt end)
CreateSlider(Aimbot,"Smoothing",{0,100},1,5,"Smoothing",function(v) smoothing=1-(v/100) end)
CreateSlider(Aimbot,"Prediction Strength",{0,0.2},0.001,0.065,"PredictionStrength",function(v) predictionStrength=v end)
CreateToggle(Aimbot,"Fov Visibility","FovVisibility",function(v) fovCircle.Visible=v end,true)
CreateSlider(Aimbot,"Aimbot Fov",{0,1000},1,100,"AimbotFov",function(v) aimFov=v; fovCircle.Radius=v end)
CreateToggle(Aimbot,"Wall Check","WallCheck",function(v) wallCheck=v end,true)
CreateToggle(Aimbot,"Sticky Aim","StickyAim",function(v) stickyAimEnabled=v end,false)
CreateToggle(Aimbot,"Team Check","TeamCheck",function(v) teamCheck=v end,false)
CreateToggle(Aimbot,"Health Check","HealthCheck",function(v) healthCheck=v end,false)
CreateSlider(Aimbot,"Min Health",{0,100},1,0,"MinHealth",function(v) minHealth=v end)
CreateColor(Aimbot,"Fov Color",circleColor,function(c) circleColor=c; fovCircle.Color=c end)
CreateColor(Aimbot,"Targeted Fov Color",targetedCircleColor,function(c) targetedCircleColor=c end)
CreateToggle(Aimbot,"Rainbow Fov","RainbowFov",function(v) rainbowFov=v end,false)

CreateToggle(AntiAim,"Anti-Aim","AntiAim",function(v) antiAim=v; Rayfield:Notify({Title="Anti-Aim",Content=v and "Enabled!" or "Disabled!",Duration=1,Image=4483362458}) end,false)
CreateDropdown(AntiAim,"Anti-Aim Method",{"Reset Velo","Random Velo","Reset Pos [BROKEN]"},"Reset Velo","AntiAimMethod",function(opt) antiAimMethod=type(opt)=="table" and opt[1] or opt end)
CreateSlider(AntiAim,"Anti-Aim Amount X",{-1000,1000},10,0,"AntiAimAmountX",function(v) antiAimAmountX=v end)
CreateSlider(AntiAim,"Anti-Aim Amount Y",{-1000,1000},10,-100,"AntiAimAmountY",function(v) antiAimAmountY=v end)
CreateSlider(AntiAim,"Anti-Aim Amount Z",{-1000,1000},10,0,"AntiAimAmountZ",function(v) antiAimAmountZ=v end)
CreateSlider(AntiAim,"Random Velo Range",{0,1000},10,100,"RandomVeloRange",function(v) randomVeloRange=v end)

CreateToggle(Misc,"Spin-Bot","SpinBot",function(v)
    spinBot=v; for _,c in pairs(hrp:GetChildren()) do if c.Name=="Spinning" then c:Destroy() end end
    plr.Character.Humanoid.AutoRotate=not v
    if v then local s=Instance.new("BodyAngularVelocity"); s.Name="Spinning"; s.Parent=hrp; s.MaxTorque=Vector3.new(0,math.huge,0); s.AngularVelocity=Vector3.new(0,spinBotSpeed,0); Rayfield:Notify({Title="Spin Bot",Content="Enabled!",Duration=1,Image=4483362458}) else Rayfield:Notify({Title="Spin Bot",Content="Disabled!",Duration=1,Image=4483362458}) end
end,false)

CreateSlider(Misc,"Spin-Bot Speed",{0,1000},1,20,"SpinBotSpeed",function(v)
    spinBotSpeed=v
    if spinBot then for _,c in pairs(hrp:GetChildren()) do if c.Name=="Spinning" then c:Destroy() end end; local s=Instance.new("BodyAngularVelocity"); s.Name="Spinning"; s.Parent=hrp; s.MaxTorque=Vector3.new(0,math.huge,0); s.AngularVelocity=Vector3.new(0,v,0) end
end)

Misc:CreateButton({Name="Server Hop", Callback=function()
    if httprequest then
        local servers={}
        local body=HttpService:JSONDecode(httprequest({Url=string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",game.PlaceId)}).Body)
        if body and body.data then for _,v in next,body.data do if type(v)=="table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing<v.maxPlayers and v.id~=game.JobId then table.insert(servers,1,v.id) end end end
        if #servers>0 then TeleportService:TeleportToPlaceInstance(game.PlaceId,servers[math.random(1,#servers)],plr) else Rayfield:Notify({Title="Server Hop",Content="Couldn't find a valid server!!!",Duration=1,Image=4483362458}) end
    else Rayfield:Notify({Title="Server Hop",Content="Your executor is ass!",Duration=1,Image=4483362458}) end
end})
