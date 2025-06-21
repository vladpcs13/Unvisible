local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Определяем, является ли устройство мобильным
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Создаем основной ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomMenu"
screenGui.Parent = playerGui

-- Основной фрейм меню (изменены размеры для мобильных устройств)
local mainFrame = Instance.new("Frame")
mainFrame.Size = isMobile and UDim2.new(0.45, 0, 0.45, 0) or UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Offset/2, 0.5, -mainFrame.Size.Y.Offset/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.4
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true

-- Закругленные углы
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.8
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- Анимация появления
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tween = TweenService:Create(mainFrame, tweenInfo, {Size = isMobile and UDim2.new(0.45, 0, 0.45, 0) or UDim2.new(0, 300, 0, 400)})
tween:Play()

-- Кнопка закрытия (уменьшена для мобильных устройств)
local closeButton = Instance.new("TextButton")
closeButton.Size = isMobile and UDim2.new(0, 25, 0, 25) or UDim2.new(0, 30, 0, 30)
closeButton.Position = isMobile and UDim2.new(1, -30, 0, 5) or UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = isMobile and 14 or 16
closeButton.Parent = mainFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
    closeTween:Play()
    closeTween.Completed:Wait()
    screenGui:Destroy()
end)

-- Перетаскивание окна
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Вкладки (уменьшены для мобильных устройств)
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -10, 0, isMobile and 30 or 40)
tabFrame.Position = UDim2.new(0, 5, 0, 5)
tabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabFrame.BackgroundTransparency = 0.5
tabFrame.Parent = mainFrame
local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabFrame

local playerTabButton = Instance.new("TextButton")
playerTabButton.Size = UDim2.new(0.5, -5, 1, -5)
playerTabButton.Position = UDim2.new(0, 5, 0, 2.5)
playerTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
playerTabButton.Text = "Player"
playerTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTabButton.TextSize = isMobile and 12 or 16
playerTabButton.Parent = tabFrame
local playerTabCorner = Instance.new("UICorner")
playerTabCorner.CornerRadius = UDim.new(0, 6)
playerTabCorner.Parent = playerTabButton

local funTabButton = Instance.new("TextButton")
funTabButton.Size = UDim2.new(0.5, -5, 1, -5)
funTabButton.Position = UDim2.new(0.5, 0, 0, 2.5)
funTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
funTabButton.Text = "Fun"
funTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
funTabButton.TextSize = isMobile and 12 or 16
funTabButton.Parent = tabFrame
local funTabCorner = Instance.new("UICorner")
funTabCorner.CornerRadius = UDim.new(0, 6)
funTabCorner.Parent = funTabButton

-- Контейнеры для вкладок (уменьшены для мобильных устройств)
local playerTab = Instance.new("Frame")
playerTab.Size = UDim2.new(1, -10, 1, isMobile and -40 or -50)
playerTab.Position = UDim2.new(0, 5, 0, isMobile and 40 or 50)
playerTab.BackgroundTransparency = 1
playerTab.Parent = mainFrame

local funTab = Instance.new("Frame")
funTab.Size = UDim2.new(1, -10, 1, isMobile and -40 or -50)
funTab.Position = UDim2.new(0, 5, 0, isMobile and 40 or 50)
funTab.BackgroundTransparency = 1
funTab.Parent = mainFrame
funTab.Visible = false

-- Переключение вкладок
local function switchTab(tabToShow, tabToHide, buttonToHighlight, buttonToDim)
    tabToShow.Visible = true
    tabToHide.Visible = false
    buttonToHighlight.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    buttonToDim.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end

playerTabButton.MouseButton1Click:Connect(function()
    switchTab(playerTab, funTab, playerTabButton, funTabButton)
end)

funTabButton.MouseButton1Click:Connect(function()
    switchTab(funTab, playerTab, funTabButton, playerTabButton)
end)

-- Функция создания ползунка (адаптирована для мобильных устройств)
local function createSlider(parent, name, min, max, default, yPos, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.95, 0, 0, isMobile and 30 or 40)
    sliderFrame.Position = UDim2.new(0.025, 0, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = isMobile and 10 or 14
    label.BackgroundTransparency = 1
    label.Parent = sliderFrame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(0.6, 0, isMobile and 0.3 or 0.25, 0)
    slider.Position = UDim2.new(0.4, 0, isMobile and 0.35 or 0.375, 0)
    slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    slider.Text = ""
    slider.Parent = sliderFrame
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.Parent = slider
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = fill
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.2, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.8, 0, 0, 0)
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = isMobile and 10 or 14
    valueLabel.BackgroundTransparency = 1
    valueLabel.Parent = sliderFrame
    
    local draggingSlider = false
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relativeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * relativeX)
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
end

-- Вкладка Player: ползунки (уменьшены интервалы для мобильных устройств)
createSlider(playerTab, "Gravity", 50, 200, 196, isMobile and 5 or 10, function(value)
    workspace.Gravity = value
end)

createSlider(playerTab, "Speed", 16, 100, 16, isMobile and 40 or 60, function(value)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

createSlider(playerTab, "Jump", 50, 200, 50, isMobile and 75 or 110, function(value)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

-- Вкладка Player: кнопка Fast Reset (уменьшена для мобильных устройств)
local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0.95, 0, 0, isMobile and 25 or 40)
resetButton.Position = UDim2.new(0.025, 0, 0, isMobile and 110 or 160)
resetButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
resetButton.Text = "Fast Reset"
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.TextSize = isMobile and 12 or 16
resetButton.Parent = playerTab
local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = resetButton

resetButton.MouseButton1Click:Connect(function()
    if player.Character then
        player.Character:BreakJoints()
    end
end)

-- Вкладка Player: переключатель Noclip (уменьшен для мобильных устройств)
local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0.95, 0, 0, isMobile and 25 or 40)
noclipToggle.Position = UDim2.new(0.025, 0, 0, isMobile and 140 or 210)
noclipToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
noclipToggle.Text = "Noclip: OFF"
noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipToggle.TextSize = isMobile and 12 or 16
noclipToggle.Parent = playerTab
local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipToggle

local noclipEnabled = false

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    noclipToggle.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
    
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipEnabled
            end
        end
    end
end

noclipToggle.MouseButton1Click:Connect(toggleNoclip)

player.CharacterAdded:Connect(function(character)
    if noclipEnabled then
        task.wait(0.1)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Вкладка Fun: JerkTool (уменьшена для мобильных устройств)
local jerkButton = Instance.new("TextButton")
jerkButton.Size = UDim2.new(0.95, 0, 0, isMobile and 25 or 40)
jerkButton.Position = UDim2.new(0.025, 0, 0, isMobile and 5 or 10)
jerkButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
jerkButton.Text = "Get Jerk"
jerkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jerkButton.TextSize = isMobile and 12 or 16
jerkButton.Parent = funTab
local jerkCorner = Instance.new("UICorner")
jerkCorner.CornerRadius = UDim.new(0, 8)
jerkCorner.Parent = jerkButton

jerkButton.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.Name = "JerkTool"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack
    
    local animationId = "rbxassetid://148840371"
    local animation = Instance.new("Animation")
    animation.AnimationId = animationId
    
    tool.Activated:Connect(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    local track = animator:LoadAnimation(animation)
                    track.Priority = Enum.AnimationPriority.Action
                    track:Play()
                    task.wait(5)
                    track:Stop()
                end
            end
        end
    end)
end)

-- Вкладка Fun: переключатель Swim (уменьшен для мобильных устройств)
local swimToggle = Instance.new("TextButton")
swimToggle.Size = UDim2.new(0.95, 0, 0, isMobile and 25 or 40)
swimToggle.Position = UDim2.new(0.025, 0, 0, isMobile and 35 or 60)
swimToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
swimToggle.Text = "Swim: OFF"
swimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
swimToggle.TextSize = isMobile and 12 or 16
swimToggle.Parent = funTab
local swimCorner = Instance.new("UICorner")
swimCorner.CornerRadius = UDim.new(0, 8)
swimCorner.Parent = swimToggle

local swimEnabled = false
local bodyVelocity

local function updateSwimState()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = player.Character.Humanoid
        local rootPart = player.Character.HumanoidRootPart
        
        if swimEnabled then
            humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            if not bodyVelocity then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = rootPart
            end
        else
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
        end
    end
end

swimToggle.MouseButton1Click:Connect(function()
    swimEnabled = not swimEnabled
    swimToggle.Text = "Swim: " .. (swimEnabled and "ON" or "OFF")
    updateSwimState()
end)

-- Управление плаванием (Space и Ctrl)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if swimEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if input.KeyCode == Enum.KeyCode.Space then
            bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, 20, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, 20, 0)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if swimEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftControl then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

player.CharacterAdded:Connect(function()
    if swimEnabled then
        task.wait(0.1)
        updateSwimState()
    end
end)

-- Вкладка Fun: ползунок вращения (уменьшен для мобильных устройств)
local angularVelocity
createSlider(funTab, "Rotation Speed", 0, 100, 0, isMobile and 65 or 110, function(value)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        if not angularVelocity then
            angularVelocity = Instance.new("AngularVelocity")
            angularVelocity.MaxTorque = math.huge
            angularVelocity.Parent = rootPart
        end
        angularVelocity.AngularVelocity = Vector3.new(0, value * 0.1, 0)
    end
end)

-- Вкладка Fun: кнопка остановки вращения (уменьшена для мобильных устройств)
local stopRotationButton = Instance.new("TextButton")
stopRotationButton.Size = UDim2.new(0.95, 0, 0, isMobile and 25 or 40)
stopRotationButton.Position = UDim2.new(0.025, 0, 0, isMobile and 95 or 160)
stopRotationButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
stopRotationButton.Text = "Stop Rotation"
stopRotationButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopRotationButton.TextSize = isMobile and 12 or 16
stopRotationButton.Parent = funTab
local stopRotationCorner = Instance.new("UICorner")
stopRotationCorner.CornerRadius = UDim.new(0, 8)
stopRotationCorner.Parent = stopRotationButton

stopRotationButton.MouseButton1Click:Connect(function()
    if angularVelocity then
        angularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    end
end)

-- Вкладка Fun: ExplodeTool и Revert (уменьшены для мобильных устройств)
local explodedParts = {}

local explodeButton = Instance.new("TextButton")
explodeButton.Size = UDim2.new(0.95, 0, 0, isMobile and 25 or 40)
explodeButton.Position = UDim2.new(0.025, 0, 0, isMobile and 125 or 210)
explodeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
explodeButton.Text = "Explode Tool"
explodeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
explodeButton.TextSize = isMobile and 12 or 16
explodeButton.Parent = funTab
local explodeCorner = Instance.new("UICorner")
explodeCorner.CornerRadius = UDim.new(0, 8)
explodeCorner.Parent = explodeButton

explodeButton.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.Name = "ExplodeTool"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack
    
    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local target = mouse.Target
        if target and target:IsA("BasePart") and not target.Locked then
            local explosion = Instance.new("Explosion")
            explosion.Position = target.Position
            explosion.BlastRadius = 5
            explosion.Parent = workspace
            explodedParts[target] = {Parent = target.Parent, CFrame = target.CFrame}
            target.Parent = nil
        end
    end)
end)

local revertButton = Instance.new("TextButton")
revertButton.Size = UDim2.new(0.95, 0, 0, isMobile and 25 or 40)
revertButton.Position = UDim2.new(0.025, 0, 0, isMobile and 155 or 260)
revertButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
revertButton.Text = "Revert"
revertButton.TextColor3 = Color3.fromRGB(255, 255, 255)
revertButton.TextSize = isMobile and 12 or 16
revertButton.Parent = funTab
local revertCorner = Instance.new("UICorner")
revertCorner.CornerRadius = UDim.new(0, 8)
revertCorner.Parent = revertButton

revertButton.MouseButton1Click:Connect(function()
    for part, data in pairs(explodedParts) do
        part.Parent = data.Parent
        part.CFrame = data.CFrame
    end
    explodedParts = {}
end)
