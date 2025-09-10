-- 🌿 GROW A GARDEN ULTIMATE SCRIPT 🌿
-- ✅ طيران - سبيد - نو كلد ون - فتح شوب - صوتيات - واجهة وردية - يعمل بأي ماب
-- 📅 2025 - By Your Request

-- 🧩 تحميل مكتبة الواجهة الجميلة
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Lib/main/uilib.lua"))()
local win = Library:CreateWindow("🌺 GARDEN GOD MODE 🌺", Color3.fromRGB(255, 182, 193)) -- وردي لطيف 💖
local tab = win:CreateTab("الرئيسية 💫")

-- 🎨 ألوان مخصصة
local pink = Color3.fromRGB(255, 105, 180)
local green = Color3.fromRGB(60, 179, 113)
local dark = Color3.fromRGB(25, 25, 35)

-- 🎵 تحميل صوت حصاد من رابط خارجي (Roblox Asset)
local harvestSoundId = "rbxassetid://6923089226" -- صوت "Cha-Ching!" مثلاً
local function playHarvestSound()
    local sound = Instance.new("Sound")
    sound.SoundId = harvestSoundId
    sound.Volume = 0.8
    sound.Parent = workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 3)
end

-- ✈️ ========== الطيران ==========
local flying = false
local flyBtn = tab:CreateButton("✈️ الطيران: ❌", function()
    flying = not flying
    flyBtn.Text = flying and "✈️ الطيران: ✅" or "✈️ الطيران: ❌"
    
    if flying then
        spawn(function()
            while flying and wait(0.05) do
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local moveVector = Vector3.new(mouse.Hit.X - hrp.Position.X, 0, mouse.Hit.Z - hrp.Position.Z).Unit * 50
                    if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        hrp.Velocity = Vector3.new(moveVector.X, 50, moveVector.Z)
                    elseif game.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        hrp.Velocity = Vector3.new(moveVector.X, -50, moveVector.Z)
                    else
                        hrp.Velocity = Vector3.new(moveVector.X, 0, moveVector.Z)
                    end
                end
            end
        end)
    end
end)

-- 🚀 ========== السرعة (Speed) ==========
local speedEnabled = false
local speedBtn = tab:CreateButton("🚀 السرعة: ❌", function()
    speedEnabled = not speedEnabled
    speedBtn.Text = speedEnabled and "🚀 السرعة: ✅" or "🚀 السرعة: ❌"
    
    local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = speedEnabled and 60 or 16
end)

-- ❄️ ========== نو كولد ون (No Cooldown) ==========
local noCooldownEnabled = false
local noCooldownBtn = tab:CreateButton("⏱️ نو كولد ون: ❌", function()
    noCooldownEnabled = not noCooldownEnabled
    noCooldownBtn.Text = noCooldownEnabled and "⏱️ نو كولد ون: ✅" or "⏱️ نو كولد ون: ❌"

    if noCooldownEnabled then
        for _, child in ipairs(getgc()) do
            if typeof(child) == "function" and debug.getinfo(child).name == nil then
                hookfunction(child, function(...)
                    return ...
                end)
            end
        end
        -- أو بديل أبسط: تعطيل كل التايمرات في اللعبة
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("NumberValue") and (obj.Name == "Cooldown" or obj.Name:find("CD") or obj.Name:find("Timer")) then
                obj.Changed:Connect(function()
                    obj.Value = 0
                end)
            end
        end
        print("✅ تم تعطيل كل الكولد ون!")
    end
end)

-- 🛒 ========== فتح الشوب تلقائي ==========
tab:CreateButton("🛍️ فتح الشوب دايماً", function()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BoolValue") and (obj.Name == "ShopOpen" or obj.Name:find("Shop")) then
            obj.Value = true
            print("✅ الشوب مفتوح!")
        end
        if obj:IsA("RemoteEvent") and obj.Name:find("Shop") then
            pcall(function() obj:FireServer() end)
        end
    end
end)

-- 💰 ========== فلوس لا نهائية ==========
tab:CreateButton("💰 فلوس × مليون", function()
    for i=1, 50 do
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") and (obj.Name:find("Money") or obj.Name:find("Coin") or obj.Name:find("Cash")) then
                pcall(function() obj:FireServer(99999) end)
            end
            if obj:IsA("IntValue") and (obj.Name == "Money" or obj.Name == "Coins" or obj.Name == "Cash") then
                obj.Value = 9999999
            end
        end
        wait(0.1)
    end
    print("🎉 حسابك مليان فلوس!")
end)

-- 🍓 ========== حصاد تلقائي + صوت ==========
local autoHarvestEnabled = false
local autoHarvestBtn = tab:CreateButton("🍓 حصاد تلقائي: ❌", function()
    autoHarvestEnabled = not autoHarvestEnabled
    autoHarvestBtn.Text = autoHarvestEnabled and "🍓 حصاد تلقائي: ✅" or "🍓 حصاد تلقائي: ❌"
    
    if autoHarvestEnabled then
        spawn(function()
            while autoHarvestEnabled and wait(2) do
                for _, plant in pairs(workspace:GetChildren()) do
                    if plant:IsA("Model") and plant:FindFirstChild("Growth") then
                        local growth = plant.Growth
                        if growth:IsA("NumberValue") and growth.Value >= 100 then
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, plant, 0)
                            wait(0.1)
                            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, plant, 1)
                            playHarvestSound()
                            print("✅ حصدت: " .. plant.Name)
                        end
                    end
                end
            end
        end)
    end
end)

-- 🌈 ========== تغيير ألوان النباتات عشوائي ==========
tab:CreateButton("🌈 تلوين النباتات", function()
    for _, plant in pairs(workspace:GetChildren()) do
        if plant:IsA("Model") then
            for _, part in pairs(plant:GetChildren()) do
                if part:IsA("BasePart") and not part.Name:match("Soil") then
                    part.Color = Color3.fromHSV(math.random(), 0.7, 1)
                end
            end
        end
    end
    print("🎨 تم تلوين الحديقة!")
end)

-- ⚡ ========== زر تشغيل كل الحاجات دفعة وحدة ==========
tab:CreateButton("⚡ شغل كلشي دفعة وحدة!", function()
    flying = true; flyBtn.Text = "✈️ الطيران: ✅"
    speedEnabled = true; speedBtn.Text = "🚀 السرعة: ✅"; game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 60
    noCooldownEnabled = true; noCooldownBtn.Text = "⏱️ نو كولد ون: ✅"
    autoHarvestEnabled = true; autoHarvestBtn.Text = "🍓 حصاد تلقائي: ✅"
    -- شغل الطيران
    spawn(function()
        while flying and wait(0.05) do
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local mouse = game.Players.LocalPlayer:GetMouse()
                local moveVector = Vector3.new(mouse.Hit.X - hrp.Position.X, 0, mouse.Hit.Z - hrp.Position.Z).Unit * 50
                if game.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.Velocity = Vector3.new(moveVector.X, 50, moveVector.Z)
                elseif game.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    hrp.Velocity = Vector3.new(moveVector.X, -50, moveVector.Z)
                else
                    hrp.Velocity = Vector3.new(moveVector.X, 0, moveVector.Z)
                end
            end
        end
    end)
    -- شغل الحصاد
    spawn(function()
        while autoHarvestEnabled and wait(2) do
            for _, plant in pairs(workspace:GetChildren()) do
                if plant:IsA("Model") and plant:FindFirstChild("Growth") then
                    local growth = plant.Growth
                    if growth:IsA("NumberValue") and growth.Value >= 100 then
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, plant, 0)
                        wait(0.1)
                        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, plant, 1)
                        playHarvestSound()
                    end
                end
            end
        end
    end)
    -- تعطيل الكولد ون
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("NumberValue") and (obj.Name == "Cooldown" or obj.Name:find("CD") or obj.Name:find("Timer")) then
            obj.Changed:Connect(function() obj.Value = 0 end)
        end
    end
    print("🌟 كل الميزات شُغلت! استمتع يا معلم!")
end)

-- 🛑 ========== زر إيقاف كلشي ==========
tab:CreateButton("🛑 إيقاف كلشي", function()
    flying = false; flyBtn.Text = "✈️ الطيران: ❌"
    speedEnabled = false; speedBtn.Text = "🚀 السرعة: ❌"; game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    autoHarvestEnabled = false; autoHarvestBtn.Text = "🍓 حصاد تلقائي: ❌"
    print("⏹️ تم إيقاف كل الوظائف.")
end)

-- 💌 رسالة ترحيب
tab:CreateLabel("🌸 تم صنع هذا السكربت خصيصاً لك!")
tab:CreateLabel("🚀 استخدم زر 'شغل كلشي' لتبدأ المغامرة!")

print("🌺 GARDEN GOD MODE LOADED SUCCESSFULLY — ENJOY YOUR FLIGHT & HARVEST! 🌺")
