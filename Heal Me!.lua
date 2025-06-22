local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HealthSliderGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
local frameSize = isMobile and UDim2.new(0, 200, 0, 100) or UDim2.new(0, 300, 0, 150)
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0, 10, 0.5, -(isMobile and 50 or 75)) -- Middle-left spawn
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 1
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenSize = TweenService:Create(mainFrame, tweenInfo, {Size = frameSize})
local tweenTransparency = TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 0.5})
tweenSize:Play()
tweenTransparency:Play()

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, isMobile and 6 or 10)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(100, 100, 100)
uiStroke.Thickness = isMobile and 1 or 2
uiStroke.Parent = mainFrame

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0, isMobile and 18 or 30)
textLabel.Position = UDim2.new(0, 0, 0, isMobile and 3 or 5)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Health Slider by vladpcs13"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextStrokeTransparency = 0.8
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextSize = isMobile and 12 or 18
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextScaled = isMobile
textLabel.Parent = mainFrame

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, isMobile and -12 or -20, 0, isMobile and 20 or 30)
sliderFrame.Position = UDim2.new(0, isMobile and 6 or 10, 0, isMobile and 24 or 40)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderFrame.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, isMobile and 3 or 5)
sliderCorner.Parent = sliderFrame

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0, 0, 1, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderBar.Parent = sliderFrame

local sliderBarCorner = Instance.new("UICorner")
sliderBarCorner.CornerRadius = UDim.new(0, isMobile and 3 or 5)
sliderBarCorner.Parent = sliderBar

local sliderValueLabel = Instance.new("TextLabel")
sliderValueLabel.Size = UDim2.new(1, 0, 0, isMobile and 18 or 24)
sliderValueLabel.Position = UDim2.new(0, 0, 0, isMobile and 48 or 80)
sliderValueLabel.BackgroundTransparency = 1
sliderValueLabel.Text = "Health: 100"
sliderValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderValueLabel.TextSize = isMobile and 12 or 16
sliderValueLabel.Font = Enum.Font.SourceSansBold
sliderValueLabel.Parent = mainFrame

local function createButton(parent, size, bgColor, text, textSize, cornerRadius, strokeThickness)
    local button = Instance.new("TextButton")
    button.Size = size
    button.BackgroundColor3 = bgColor
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = textSize
    button.Font = Enum.Font.SourceSansBold
    button.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = button
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 100)
    stroke.Thickness = strokeThickness
    stroke.Parent = button
    return button
end

local applyButton = createButton(mainFrame, UDim2.new(0, isMobile and 60 or 100, 0, isMobile and 30 or 40), Color3.fromRGB(0, 200, 0), "Apply", isMobile and 12 or 16, isMobile and 5 or 8, isMobile and 0.5 or 1)
applyButton.Position = UDim2.new(0.5, -(isMobile and 30 or 50), 0, isMobile and 66 or 100) -- Centered horizontally, slightly higher

local closeButton = createButton(mainFrame, UDim2.new(0, isMobile and 30 or 40, 0, isMobile and 30 or 40), Color3.fromRGB(200, 0, 0), "X", isMobile and 16 or 20, isMobile and 5 or 8, isMobile and 0.5 or 1)
closeButton.Position = UDim2.new(1, -(isMobile and 36 or 46), 1, -(isMobile and 36 or 46)) -- Bottom-right

local isDraggingSlider = false
local isDraggingWindow = false
local dragStart = nil
local startPos = nil
local currentHealthValue = 100

local function updateSlider(input)
    if isDraggingSlider then
        local sliderWidth = sliderFrame.AbsoluteSize.X
        local sliderPos = sliderFrame.AbsolutePosition.X
        local mouseX = input.Position.X
        local newX = math.clamp(mouseX - sliderPos, 0, sliderWidth)
        local healthValue = math.floor((newX / sliderWidth) * 100)
        sliderBar.Size = UDim2.new(0, newX, 1, 0)
        sliderValueLabel.Text = "Health: " .. healthValue
        currentHealthValue = healthValue
    end
end

local function startDraggingSlider(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingSlider = true
        updateSlider(input)
    end
end

local function stopDraggingSlider()
    isDraggingSlider = false
end

local function startDraggingWindow(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local target = input.Target
        if target and (target == sliderFrame or target:IsDescendantOf(sliderFrame)) then
            return -- Prevent window dragging if clicking on slider
        end
        isDraggingWindow = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end

local function updateDraggingWindow(input)
    if isDraggingWindow then
        local delta = input.Position - dragStart
        local newPosX = startPos.X.Offset + delta.X
        local newPosY = startPos.Y.Offset + delta.Y
        local screenSize = game:GetService("Workspace").CurrentCamera.ViewportSize
        local frameSize = mainFrame.AbsoluteSize
        local safeArea = GuiService:GetGuiInset()
        newPosX = math.clamp(newPosX, safeArea.X, screenSize.X - frameSize.X - safeArea.X)
        newPosY = math.clamp(newPosY, safeArea.Y, screenSize.Y - frameSize.Y - safeArea.Y)
        mainFrame.Position = UDim2.new(0, newPosX, 0, newPosY)
    end
end

local function stopDraggingWindow()
    isDraggingWindow = false
end

local function applyHealth()
    if humanoid then
        humanoid.Health = currentHealthValue
    end
end

local function shutdownScript()
    if screenGui then screenGui:Destroy() end
end

local connections = {}

local function connectEvents()
    table.insert(connections, sliderFrame.InputBegan:Connect(startDraggingSlider))
    table.insert(connections, mainFrame.InputBegan:Connect(startDraggingWindow))
    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            pcall(updateSlider, input)
            pcall(updateDraggingWindow, input)
        end
    end))
    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            pcall(stopDraggingSlider)
            pcall(stopDraggingWindow)
        end
    end))
    table.insert(connections, applyButton.MouseButton1Click:Connect(function()
        pcall(applyHealth)
    end))
    table.insert(connections, closeButton.MouseButton1Click:Connect(function()
        pcall(shutdownScript)
    end))
    table.insert(connections, player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoid = character:WaitForChild("Humanoid")
    end))
end

local success, errorMsg = pcall(connectEvents)
if not success then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Error",
        Text = "Failed to initialize: " .. tostring(errorMsg),
        Duration = 5
    })
end
