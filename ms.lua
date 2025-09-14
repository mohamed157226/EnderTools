local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZokadaXPremium"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(0, 450, 0, 400)
mainContainer.Position = UDim2.new(0.5, -225, 0.5, -200)
mainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainContainer.BorderSizePixel = 0
mainContainer.ClipsDescendants = true
mainContainer.Parent = screenGui

local containerStroke = Instance.new("UIStroke")
containerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
containerStroke.Color = Color3.fromRGB(80, 80, 80)
containerStroke.Thickness = 2
containerStroke.Parent = mainContainer

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainContainer

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 200, 1, 0)
titleText.Position = UDim2.new(0.5, -100, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ZOKADA X PREMIUM"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.Gotham
closeButton.TextSize = 14
closeButton.Parent = titleBar

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainContainer

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, 0, 0, 40)
keyBox.Position = UDim2.new(0, 0, 0, 20)
keyBox.PlaceholderText = "Enter Your Key Here"
keyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.TextXAlignment = Enum.TextXAlignment.Center
keyBox.Parent = contentFrame

local checkButton = Instance.new("TextButton")
checkButton.Size = UDim2.new(1, 0, 0, 40)
checkButton.Position = UDim2.new(0, 0, 0, 70)
checkButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
checkButton.BorderSizePixel = 0
checkButton.Text = "CHECK KEY"
checkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
checkButton.Font = Enum.Font.GothamBold
checkButton.TextSize = 14
checkButton.Parent = contentFrame
