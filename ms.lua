local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedControlGUI"
screenGui.Parent = playerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "SpeedFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false -- Start hidden
mainFrame.Parent = screenGui

-- Add corner rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Create title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Speed Control"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Create speed input label
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(0.6, 0, 0, 25)
speedLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed:"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

-- Create speed input box
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Size = UDim2.new(0.35, 0, 0, 25)
speedInput.Position = UDim2.new(0.6, 0, 0.35, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedInput.BorderSizePixel = 0
speedInput.Text = "16"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextScaled = true
speedInput.Font = Enum.Font.Gotham
speedInput.PlaceholderText = "16"
speedInput.Parent = mainFrame

-- Add corner to input box
local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = speedInput

-- Create apply button
local applyButton = Instance.new("TextButton")
applyButton.Name = "ApplyButton"
applyButton.Size = UDim2.new(0.8, 0, 0, 30)
applyButton.Position = UDim2.new(0.1, 0, 0.65, 0)
applyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
applyButton.BorderSizePixel = 0
applyButton.Text = "Apply Speed"
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyButton.TextScaled = true
applyButton.Font = Enum.Font.GothamBold
applyButton.Parent = mainFrame

-- Add corner to button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = applyButton

-- Create toggle button (always visible)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 100, 0, 35)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Speed GUI"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

-- Add corner to toggle button
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Animation tweens
local showTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 250, 0, 120)}
)

local hideTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    {Size = UDim2.new(0, 0, 0, 0)}
)

-- Toggle functionality
local isVisible = false

toggleButton.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    
    if isVisible then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        showTween:Play()
        toggleButton.Text = "Hide GUI"
        toggleButton.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
    else
        hideTween:Play()
        toggleButton.Text = "Speed GUI"
        toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        hideTween.Completed:Connect(function()
            if not isVisible then
                mainFrame.Visible = false
            end
        end)
    end
end)

-- Speed application functionality
local function applySpeed()
    local speedValue = tonumber(speedInput.Text)
    
    if speedValue and speedValue >= 0 and speedValue <= 1000 then
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = speedValue
            
            -- Visual feedback
            applyButton.Text = "Applied!"
            applyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            
            wait(1)
            
            applyButton.Text = "Apply Speed"
            applyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        end
    else
        -- Error feedback
        applyButton.Text = "Invalid!"
        applyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        wait(1)
        
        applyButton.Text = "Apply Speed"
        applyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    end
end

-- Connect apply button
applyButton.MouseButton1Click:Connect(applySpeed)

-- Apply speed when Enter is pressed in the input box
speedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        applySpeed()
    end
end)

-- Keyboard shortcut (F key) to toggle GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleButton.MouseButton1Click:Fire()
    end
end)
