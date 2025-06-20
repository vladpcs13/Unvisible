local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем основной ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomMenu"
screenGui.Parent = playerGui

-- Основной фрейм меню с полупрозрачным фоном
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.4
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true

-- Добавляем закругленные углы
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Добавляем тень
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
local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 320, 0, 420)})
tween:Play()

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
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

-- Делаем фрейм перетаскиваемым
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Вкладки
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -10, 0, 40)
tabFrame.Position = UDim2.new(0, 5, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabFrame.BackgroundTransparency = 0.5
tabFrame.Parent = mainFrame
local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabFrame

local playerTabButton = Instance.new("TextButton")
playerTabButton.Size = UDim2.new(0.5, -2.5, 1, -5)
playerTabButton.Position = UDim2.new(0, 2.5, 0, 2.5)
playerTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
playerTabButton.Text = "Player"
playerTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTabButton.TextSize = 16
playerTabButton.Parent = tabFrame
local playerTabCorner = Instance.new("UICorner")
playerTabCorner.CornerRadius = UDim.new(0, 6)
playerTabCorner.Parent = playerTabButton

local funTabButton = Instance.new("TextButton")
funTabButton.Size = UDim2.new(0.5, -2.5, 1, -5)
funTabButton.Position = UDim2.new(0.5, 2.5, 0, 2.5)
funTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
funTabButton.Text = "Fun"
funTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
funTabButton.TextSize = 16
funTabButton.Parent = tabFrame
local funTabCorner = Instance.new("UICorner")
funTabCorner.CornerRadius = UDim.new(0, 6)
funTabCorner.Parent = funTabButton

-- Контейнеры для вкладок
local playerTab = Instance.new("Frame")
playerTab.Size = UDim2.new(1, -10, 1, -90)
playerTab.Position = UDim2.new(0, 5, 0, 85)
playerTab.BackgroundTransparency = 1
playerTab.Parent = mainFrame

local funTab = Instance.new("Frame")
funTab.Size = UDim2.new(1, -10, 1, -90)
funTab.Position = UDim2.new(0, 5, 0, 85)
funTab.BackgroundTransparency = 1
funTab.Parent = mainFrame
funTab.Visible = false

-- Функция переключения вкладок
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

-- Вкладка Player
local function createSlider(name, min, max, default, yPos, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(0.95, 0, 0, 40)
	sliderFrame.Position = UDim2.new(0.025, 0, 0, yPos)
	sliderFrame.BackgroundTransparency = 1
	sliderFrame.Parent = playerTab
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.4, 0, 1, 0)
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 14
	label.BackgroundTransparency = 1
	label.Parent = sliderFrame
	
	local slider = Instance.new("TextButton")
	slider.Size = UDim2.new(0.6, 0, 0.25, 0)
	slider.Position = UDim2.new(0.4, 0, 0.375, 0)
	slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	slider.Text = ""
	slider.Parent = sliderFrame
	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(0, 4)
	sliderCorner.Parent = slider
	
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(default/max, 0, 1, 0)
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
	valueLabel.TextSize = 14
	valueLabel.BackgroundTransparency = 1
	valueLabel.Parent = sliderFrame
	
	local draggingSlider = false
	
	slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = true
		end
	end)
	
	slider.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSlider = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
			local relativeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
			local value = math.floor(min + (max - min) * relativeX)
			fill.Size = UDim2.new(relativeX, 0, 1, 0)
			valueLabel.Text = tostring(value)
			callback(value)
		end
	end)
end

-- Ползунки
createSlider("Gravity", 50, 200, 196, 10, function(value)
	workspace.Gravity = value
end)

createSlider("Speed", 16, 100, 16, 60, function(value)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = value
	end
end)

createSlider("Jump", 50, 200, 50, 110, function(value)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.JumpPower = value
	end
end)

-- Кнопка Fast Reset
local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0.95, 0, 0, 40)
resetButton.Position = UDim2.new(0.025, 0, 0, 160)
resetButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
resetButton.Text = "Fast Reset"
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.TextSize = 16
resetButton.Parent = playerTab
local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = resetButton

resetButton.MouseButton1Click:Connect(function()
	if player.Character then
		player.Character:BreakJoints()
	end
end)

-- Вкладка Fun
local jerkButton = Instance.new("TextButton")
jerkButton.Size = UDim2.new(0.95, 0, 0, 40)
jerkButton.Position = UDim2.new(0.025, 0, 0, 10)
jerkButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
jerkButton.Text = "Get Jerk"
jerkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jerkButton.TextSize = 16
jerkButton.Parent = funTab
local jerkCorner = Instance.new("UICorner")
jerkCorner.CornerRadius = UDim.new(0, 8)
jerkCorner.Parent = jerkButton

jerkButton.MouseButton1Click:Connect(function()
	local tool = Instance.new("Tool")
	tool.Name = "JerkTool"
	tool.RequiresHandle = false
	tool.Parent = player.Backpack
	
	local animationId = "rbxassetid://148840371" -- Замените на ваш AnimationId
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
					-- Останавливаем анимацию через 5 секунд
					task.wait(5)
					track:Stop()
				else
					warn("Animator not found in Humanoid")
				end
			else
				warn("Humanoid not found in Character")
			end
		else
			warn("Character not found")
		end
	end)
end)

-- Переключатель Swim
local swimToggle = Instance.new("TextButton")
swimToggle.Size = UDim2.new(0.95, 0, 0, 40)
swimToggle.Position = UDim2.new(0.025, 0, 0, 60)
swimToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
swimToggle.Text = "Swim: OFF"
swimToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
swimToggle.TextSize = 16
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
			-- Управление движением
			UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement and swimEnabled then
					local moveVector = humanoid.MoveDirection * 20
					bodyVelocity.Velocity = moveVector
				end
			end)
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

-- Обновление при возрождении персонажа
player.CharacterAdded:Connect(function()
	if swimEnabled then
		task.wait(0.1) -- Даем время на загрузку персонажа
		updateSwimState()
	end
end)
