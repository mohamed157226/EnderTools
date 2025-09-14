 local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")

    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystemUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.BorderSizePixel = 0
    shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Font = Enum.Font.GothamBold
    title.Text = "KEY SYSTEM"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.TextStrokeTransparency = 0.8
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 0, 0, 20)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Parent = mainFrame

    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "Get access to nullptr hub"
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    subtitle.TextSize = 14
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.new(0, 0, 0, 50)
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Parent = mainFrame

    local keyBox = Instance.new("TextBox")
    keyBox.Name = "KeyBox"
    keyBox.Font = Enum.Font.Gotham
    keyBox.PlaceholderText = "Enter your key here..."
    keyBox.Text = ""
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.TextSize = 16
    keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    keyBox.BorderSizePixel = 0
    keyBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    keyBox.Size = UDim2.new(0.8, 0, 0, 40)
    keyBox.Parent = mainFrame

    local keyBoxCorner = Instance.new("UICorner")
    keyBoxCorner.CornerRadius = UDim.new(0, 8)
    keyBoxCorner.Parent = keyBox

    local keyBoxPadding = Instance.new("UIPadding")
    keyBoxPadding.PaddingLeft = UDim.new(0, 10)
    keyBoxPadding.PaddingRight = UDim.new(0, 10)
    keyBoxPadding.Parent = keyBox

    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Name = "GetKeyButton"
    getKeyButton.Font = Enum.Font.GothamBold
    getKeyButton.Text = "GET KEY"
    getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyButton.TextSize = 16
    getKeyButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Position = UDim2.new(0.1, 0, 0.45, 0)
    getKeyButton.Size = UDim2.new(0.8, 0, 0, 40)
    getKeyButton.Parent = mainFrame

    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 8)
    getKeyCorner.Parent = getKeyButton

    local discordButton = Instance.new("TextButton")
    discordButton.Name = "DiscordButton"
    discordButton.Font = Enum.Font.GothamBold
    discordButton.Text = "DISCORD"
    discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordButton.TextSize = 16
    discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordButton.BorderSizePixel = 0
    discordButton.Position = UDim2.new(0.1, 0, 0.6, 0)
    discordButton.Size = UDim2.new(0.8, 0, 0, 40)
    discordButton.Parent = mainFrame

    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 8)
    discordCorner.Parent = discordButton

    local checkKeyButton = Instance.new("TextButton")
    checkKeyButton.Name = "CheckKeyButton"
    checkKeyButton.Font = Enum.Font.GothamBold
    checkKeyButton.Text = "CHECK KEY"
    checkKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkKeyButton.TextSize = 16
    checkKeyButton.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
    checkKeyButton.BorderSizePixel = 0
    checkKeyButton.Position = UDim2.new(0.1, 0, 0.75, 0)
    checkKeyButton.Size = UDim2.new(0.8, 0, 0, 40)
    checkKeyButton.Parent = mainFrame

    local checkKeyCorner = Instance.new("UICorner")
    checkKeyCorner.CornerRadius = UDim.new(0, 8)
    checkKeyCorner.Parent = checkKeyButton

    local function showNotification(message, color)
        local notification = Instance.new("TextLabel")
        notification.Name = "Notification"
        notification.Font = Enum.Font.GothamBold
        notification.Text = message
        notification.TextColor3 = Color3.fromRGB(255, 255, 255)
        notification.TextSize = 14
        notification.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
        notification.BorderSizePixel = 0
        notification.Position = UDim2.new(0.1, 0, 0.9, 0)
        notification.Size = UDim2.new(0.8, 0, 0, 30)
        notification.Parent = mainFrame
        
        local notificationCorner = Instance.new("UICorner")
        notificationCorner.CornerRadius = UDim.new(0, 8)
        notificationCorner.Parent = notification
        
        local notificationPadding = Instance.new("UIPadding")
        notificationPadding.PaddingLeft = UDim.new(0, 10)
        notificationPadding.PaddingRight = UDim.new(0, 10)
        notificationPadding.Parent = notification
        
        delay(3, function()
            if notification and notification.Parent then
                notification:Destroy()
            end
        end)
    end

    local function animateButton(button)
        local originalSize = button.Size
        local originalColor = button.BackgroundColor3
        
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize + UDim2.new(0, 5, 0, 5)}):Play()
            TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = originalColor:Lerp(Color3.fromRGB(255, 255, 255), 0.1)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize}):Play()
            TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = originalColor}):Play()
        end)
        
        button.MouseButton1Down:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize - UDim2.new(0, 5, 0, 5)}):Play()
        end)
        
        button.MouseButton1Up:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize}):Play()
        end)
    end

    animateButton(getKeyButton)
    animateButton(discordButton)
    animateButton(checkKeyButton)

    local function isValidKey(key)
        return key == "TESTKEY123" or string.match(key, "^KEY%-[A-Z0-9]+$")
    end

    getKeyButton.MouseButton1Click:Connect(function() -- tet
        local key = "https://ads.luarmor.net/get_key?for=-ouxUMfiLIJEG"
        keyBox.Text = key
        setclipboard(key)
        showNotification("Link copied to clipboard!", Color3.fromRGB(80, 120, 255))
    end)

    discordButton.MouseButton1Click:Connect(function()
        local discordLink = "https://discord.gg/nullptroff"
        setclipboard(discordLink)
        showNotification("Discord link copied!", Color3.fromRGB(88, 101, 242))
    end)

    checkKeyButton.MouseButton1Click:Connect(function()

        local enteredKey = keyBox.Text
        local status = api.check_key(enteredKey)
        note = status.data.note
        if (status.code == "KEY_VALID") then         
            key = key -- SET THE KEY BEFORE LOADSTRINGING.

            showNotification("Key accepted! Welcome!", Color3.fromRGB(50, 180, 100))
            wait(1)
            gui:Destroy()

            api.load_script(); -- Executes the script, based on the script_id you put above.
            return
            
        elseif (status.code == "KEY_HWID_LOCKED") then
            showNotification("HWID LOCKED", Color3.fromRGB(255, 100, 100))
            return
        elseif (status.code == "KEY_INCORRECT") then
            showNotification("Invalid key, please try again", Color3.fromRGB(255, 100, 100))
            return    
        else
            showNotification("Invalid key, please try again", Color3.fromRGB(255, 100, 100))
        end
    end)

    if UserInputService.TouchEnabled then
        mainFrame.Size = UDim2.new(0.8, 0, 0.6, 0)
        keyBox.TextSize = 14
        getKeyButton.TextSize = 14
        discordButton.TextSize = 14
        checkKeyButton.TextSize = 14
    end
end
