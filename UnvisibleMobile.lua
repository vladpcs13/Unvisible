local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Проверка, является ли устройство мобильным
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Создание GUI для надписи и кнопок
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GhostScriptGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")
print("ScreenGui created")

-- Создание фрейма для интерфейса (размеры зависят от устройства)
local mainFrame = Instance.new("Frame")
local frameSize = isMobile and UDim2.new(0, 200, 0, 60) or UDim2.new(0, 387, 0, 100)
mainFrame.Size = frameSize
mainFrame.Position = UDim2.new(1, - (isMobile and 210 or 390), 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.5
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Анимация запуска
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundTransparency = 1
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenSize = TweenService:Create(mainFrame, tweenInfo, {Size = frameSize})
local tweenTransparency = TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 0.5})
tweenSize:Play()
tweenTransparency:Play()
print("Startup animation played")

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
textLabel.Text = "Unvisible by vladpcs13 | t.me/idkbutjustvlad"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextStrokeTransparency = 0.8
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextSize = isMobile and 12 or 18
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextScaled = isMobile -- Масштабирование текста для мобильных
textLabel.Parent = mainFrame
print("TextLabel created")

local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, isMobile and -12 or -20, 0, isMobile and 36 or 60)
buttonFrame.Position = UDim2.new(0, isMobile and 6 or 10, 0, isMobile and 24 or 40)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
uiListLayout.Padding = UDim.new(0, isMobile and 4 or 6)
uiListLayout.Parent = buttonFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, isMobile and 30 or 50, 0, isMobile and 30 or 50)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = isMobile and 16 or 24
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = buttonFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, isMobile and 5 or 8)
closeCorner.Parent = closeButton
local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(100, 100, 100)
closeStroke.Thickness = isMobile and 0.5 or 1
closeStroke.Parent = closeButton
print("CloseButton created")

local extraButton = Instance.new("TextButton")
extraButton.Size = UDim2.new(0, isMobile and 60 or 100, 0, isMobile and 30 or 50)
extraButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
extraButton.Text = "Extra"
extraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
extraButton.TextSize = isMobile and 12 or 18
extraButton.Font = Enum.Font.SourceSansBold
extraButton.Parent = buttonFrame
local extraCorner = Instance.new("UICorner")
extraCorner.CornerRadius = UDim.new(0, isMobile and 5 or 8)
extraCorner.Parent = extraButton
local extraStroke = Instance.new("UIStroke")
extraStroke.Color = Color3.fromRGB(100, 100, 100)
extraStroke.Thickness = isMobile and 0.5 or 1
extraStroke.Parent = extraButton
print("ExtraButton created")

local invisibleButton = Instance.new("TextButton")
invisibleButton.Size = UDim2.new(0, isMobile and 60 or 100, 0, isMobile and 30 or 50)
invisibleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
invisibleButton.Text = "Hide/Show"
invisibleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisibleButton.TextSize = isMobile and 12 or 18
invisibleButton.Font = Enum.Font.SourceSansBold
invisibleButton.Parent = buttonFrame
local invisibleCorner = Instance.new("UICorner")
invisibleCorner.CornerRadius = UDim.new(0, isMobile and 5 or 8)
invisibleCorner.Parent = invisibleButton
local invisibleStroke = Instance.new("UIStroke")
invisibleStroke.Color = Color3.fromRGB(100, 100, 100)
invisibleStroke.Thickness = isMobile and 0.5 or 1
invisibleStroke.Parent = invisibleButton
print("InvisibleButton created")

local revertButton = Instance.new("TextButton")
revertButton.Size = UDim2.new(0, isMobile and 60 or 100, 0, isMobile and 30 or 50)
revertButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
revertButton.Text = "Revert"
revertButton.TextColor3 = Color3.fromRGB(255, 255, 255)
revertButton.TextSize = isMobile and 12 or 18
revertButton.Font = Enum.Font.SourceSansBold
revertButton.Parent = buttonFrame
local revertCorner = Instance.new("UICorner")
revertCorner.CornerRadius = UDim.new(0, isMobile and 5 or 8)
revertCorner.Parent = revertButton
local revertStroke = Instance.new("UIStroke")
revertStroke.Color = Color3.fromRGB(100, 100, 100)
revertStroke.Thickness = isMobile and 0.5 or 1
revertStroke.Parent = revertButton
print("RevertButton created")

-- Джойстик для мобильных устройств
local joystickOuter = nil
local joystickInner = nil
local joystickActive = false
local joystickOrigin = nil
local joystickInput = Vector2.new(0, 0)

if isMobile then
    joystickOuter = Instance.new("Frame")
    joystickOuter.Size = UDim2.new(0, 80, 0, 80)
    joystickOuter.Position = UDim2.new(0, 30, 1, -110)
    joystickOuter.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    joystickOuter.BackgroundTransparency = 0.5
    joystickOuter.Parent = screenGui
    local joystickOuterCorner = Instance.new("UICorner")
    joystickOuterCorner.CornerRadius = UDim.new(0.5, 0)
    joystickOuterCorner.Parent = joystickOuter

    joystickInner = Instance.new("Frame")
    joystickInner.Size = UDim2.new(0, 40, 0, 40)
    joystickInner.Position = UDim2.new(0.5, -20, 0.5, -20)
    joystickInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    joystickInner.BackgroundTransparency = 0.2
    joystickInner.Parent = joystickOuter
    local joystickInnerCorner = Instance.new("UICorner")
    joystickInnerCorner.CornerRadius = UDim.new(0.5, 0)
    joystickInnerCorner.Parent = joystickInner

    print("Joystick created for mobile")
end

-- Переменные
local ghostPart = nil
local platform = nil
local isGhostMode = false
local lastPosition = nil
local connections = {}
local isDragging = false
local dragStart = nil
local startPos = nil

-- Функция для создания платформы
local function createPlatform(position)
    if platform then
        platform:Destroy()
        print("Old platform destroyed")
    end
    platform = Instance.new("Part")
    platform.Name = "PlayerPlatform"
    platform.Size = Vector3.new(10, 1, 10)
    platform.Position = position - Vector3.new(0, 3.5, 0)
    platform.Anchored = true
    platform.BrickColor = BrickColor.new("Really black")
    platform.Parent = workspace
    print("Platform created at:", platform.Position)
end

-- Функция для создания призрачного куба
local function createGhostPart(position)
    if ghostPart then
        ghostPart:Destroy()
        print("Old ghost part destroyed")
    end
    print("Creating ghost part...")
    ghostPart = Instance.new("Part")
    ghostPart.Name = "GhostPart"
    ghostPart.Size = Vector3.new(2, 2, 2)
    ghostPart.Position = position.Position + Vector3.new(0, 2, 0)
    ghostPart.Transparency = 0.5
    ghostPart.BrickColor = BrickColor.new("Really white")
    ghostPart.CanCollide = true
    ghostPart.Anchored = false
    ghostPart.Parent = workspace
    print("Ghost part created at:", ghostPart.Position)
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "GhostVelocity"
    bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = ghostPart
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "GhostGyro"
    bodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyGyro.CFrame = CFrame.new(ghostPart.Position)
    bodyGyro.Parent = ghostPart
    
    camera.CameraSubject = ghostPart
    camera.CameraType = Enum.CameraType.Follow
    print("Camera set to ghost part at:", ghostPart.Position)
end

-- Функция для управления кубом
local function updateGhostPartMovement()
    if not isGhostMode or not ghostPart then return end
    local moveDirection = Vector3.new(0, 0, 0)
    local speed = 60
    local cameraCFrame = camera.CFrame
    
    if isMobile and joystickActive then
        -- Управление джойстиком
        local inputVector = joystickInput / 40 -- Нормализация (радиус внешнего круга = 40)
        moveDirection = cameraCFrame:VectorToWorldSpace(Vector3.new(inputVector.X, 0, inputVector.Y)) * speed
    else
        -- Управление клавишами
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + cameraCFrame.LookVector * speed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - cameraCFrame.LookVector * speed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - cameraCFrame.RightVector * speed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + cameraCFrame.RightVector * speed
        end
    end
    
    local bodyVelocity = ghostPart:FindFirstChild("GhostVelocity")
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(moveDirection.X, 0, moveDirection.Z)
    end
end

-- Функция для прыжка куба
local function makeGhostPartJump(input, gameProcessed)
    if gameProcessed or not isGhostMode or not ghostPart then return end
    if input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.Space then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyVelocity.Parent = ghostPart
        print("Ghost part jumped")
        wait(0.2)
        bodyVelocity:Destroy()
    end
end

-- Функция для возврата к исходной позиции
local function revertToOriginalPosition()
    if not isGhostMode then
        print("Not in ghost mode, no revert needed")
        return
    end
    print("Reverting to original position...")
    if lastPosition then
        humanoidRootPart.CFrame = lastPosition
        print("Player reverted to original position:", lastPosition.Position)
    else
        warn("No original position stored, teleporting to default position")
        humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    end
    character.Humanoid.WalkSpeed = 16
    character.Humanoid.JumpPower = 50
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        elseif part:IsA("Decal") then
            part.Transparency = 0
        end
    end
    camera.CameraSubject = character.Humanoid
    camera.CameraType = Enum.CameraType.Follow
    if ghostPart then
        ghostPart:Destroy()
        ghostPart = nil
        print("Ghost part destroyed")
    end
    if platform then
        platform:Destroy()
        platform = nil
        print("Platform destroyed")
    end
    isGhostMode = false
    print("Revert completed")
end

-- Функция для телепортации
local function teleportAndGhost()
    if isGhostMode then
        print("Exiting ghost mode, teleporting to ghost part...")
        if ghostPart then
            humanoidRootPart.CFrame = CFrame.new(ghostPart.Position + Vector3.new(0, 3, 0))
            print("Player teleported to ghost part at:", ghostPart.Position)
        else
            warn("No ghost part to teleport to!")
            humanoidRootPart.CFrame = CFrame.new(0, 100, 0)
        end
        character.Humanoid.WalkSpeed = 16
        character.Humanoid.JumpPower = 50
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            elseif part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        camera.CameraSubject = character.Humanoid
        camera.CameraType = Enum.CameraType.Follow
        if ghostPart then
            ghostPart:Destroy()
            ghostPart = nil
            print("Ghost part destroyed")
        end
        if platform then
            platform:Destroy()
            platform = nil
            print("Platform destroyed")
        end
        isGhostMode = false
    else
        print("Entering ghost mode...")
        lastPosition = humanoidRootPart.CFrame
        print("Last player position saved:", lastPosition.Position)
        
        local teleportPosition = Vector3.new(math.random(-1000, 1000), 100, math.random(-1000, 1000))
        print("Generated teleport position:", teleportPosition)
        
        createPlatform(teleportPosition)
        
        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
        print("Player teleported to:", teleportPosition)
        
        createGhostPart(lastPosition)
        
        character.Humanoid.WalkSpeed = 0
        character.Humanoid.JumpPower = 0
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            elseif part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        isGhostMode = true
    end
end

-- Функция для загрузки Infinite Yield
local function loadInfiniteYield()
    print("Loading Infinite Yield...")
    local success, result = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
    if success then
        print("Infinite Yield loaded successfully")
    else
        warn("Failed to load Infinite Yield:", result)
    end
end

-- Функция для загрузки Fuck HUB
local function loadFuckHub()
    print("Loading Fuck HUB...")
    local success, result = pcall(function()
        loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/2219bf48b54cd405ed94c32097f07c21"))()
    end)
    if success then
        print("Fuck HUB loaded successfully")
    else
        warn("Failed to load Fuck HUB:", result)
    end
end

-- Функция для загрузки SFun
local function loadSFun()
    print("Loading SFun by vladpcs13...")
    local success, result = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vladpcs13/Unvisible/refs/heads/main/SFun%20by%20vladpcs13.lua"))()
    end)
    if success then
        print("SFun loaded successfully")
    else
        warn("Failed to load SFun:", result)
    end
end

-- Функция для создания меню Extra
local function createExtraMenu()
    -- Создаем фрейм для меню
    local extraFrame = Instance.new("Frame")
    extraFrame.Size = UDim2.new(0, isMobile and 180 or 300, 0, isMobile and 120 or 200)
    extraFrame.Position = UDim2.new(0.5, - (isMobile and 90 or 150), 0.5, - (isMobile and 60 or 100))
    extraFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    extraFrame.BackgroundTransparency = 0.2
    extraFrame.BorderSizePixel = 0
    extraFrame.Parent = screenGui
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = extraFrame
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(100, 100, 100)
    uiStroke.Thickness = 2
    uiStroke.Parent = extraFrame
    
    -- Заголовок
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, isMobile and 20 or 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Extra Scripts"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = isMobile and 14 or 18
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = extraFrame
    
    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, isMobile and 20 or 30, 0, isMobile and 20 or 30)
    closeButton.Position = UDim2.new(1, - (isMobile and 25 or 35), 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = isMobile and 14 or 18
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = extraFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    -- Список скриптов
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, - (isMobile and 40 or 60))
    scrollFrame.Position = UDim2.new(0, 5, 0, isMobile and 30 or 40)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.Parent = extraFrame
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = scrollFrame
    
    -- Infinite Yield Button
    local iyButton = Instance.new("TextButton")
    iyButton.Size = UDim2.new(1, 0, 0, isMobile and 25 or 35)
    iyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    iyButton.Text = "Infinite Yield"
    iyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    iyButton.TextSize = isMobile and 12 or 16
    iyButton.Font = Enum.Font.SourceSansBold
    iyButton.Parent = scrollFrame
    
    local iyCorner = Instance.new("UICorner")
    iyCorner.CornerRadius = UDim.new(0, 5)
    iyCorner.Parent = iyButton
    
    -- Fuck HUB Button
    local fhButton = Instance.new("TextButton")
    fhButton.Size = UDim2.new(1, 0, 0, isMobile and 25 or 35)
    fhButton.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
    fhButton.Text = "Fuck HUB"
    fhButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fhButton.TextSize = isMobile and 12 or 16
    fhButton.Font = Enum.Font.SourceSansBold
    fhButton.Parent = scrollFrame
    
    local fhCorner = Instance.new("UICorner")
    fhCorner.CornerRadius = UDim.new(0, 5)
    fhCorner.Parent = fhButton
    
    -- SFun Button
    local sfButton = Instance.new("TextButton")
    sfButton.Size = UDim2.new(1, 0, 0, isMobile and 25 or 35)
    sfButton.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
    sfButton.Text = "SFun by vladpcs13"
    sfButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sfButton.TextSize = isMobile and 12 or 16
    sfButton.Font = Enum.Font.SourceSansBold
    sfButton.Parent = scrollFrame
    
    local sfCorner = Instance.new("UICorner")
    sfCorner.CornerRadius = UDim.new(0, 5)
    sfCorner.Parent = sfButton
    
    -- Обновление размера контента
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end)
    
    -- Подключение событий
    closeButton.MouseButton1Click:Connect(function()
        extraFrame:Destroy()
    end)
    
    iyButton.MouseButton1Click:Connect(function()
        loadInfiniteYield()
        extraFrame:Destroy()
    end)
    
    fhButton.MouseButton1Click:Connect(function()
        loadFuckHub()
        extraFrame:Destroy()
    end)
    
    sfButton.MouseButton1Click:Connect(function()
        loadSFun()
        extraFrame:Destroy()
    end)
end

-- Функция для закрытия скрипта
local function shutdownScript()
    print("Shutting down...")
    if isGhostMode then
        character.Humanoid.WalkSpeed = 16
        character.Humanoid.JumpPower = 50
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            elseif part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        camera.CameraSubject = character.Humanoid
        camera.CameraType = Enum.CameraType.Follow
        isGhostMode = false
    end
    
    if ghostPart then
        ghostPart:Destroy()
        print("Ghost part destroyed")
    end
    if platform then
        platform:Destroy()
        print("Platform destroyed")
    end
    if screenGui then
        screenGui:Destroy()
        print("ScreenGui destroyed")
    end
    
    for _, connection in ipairs(connections) do
        connection:Disconnect()
        print("Event disconnected")
    end
    connections = {}
    
    script:Destroy()
    print("Script destroyed")
end

-- Функция для перетаскивания GUI
local function startDragging(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        print("Started dragging GUI")
    end
end

local function updateDragging(input)
    if isDragging then
        local delta = input.Position - dragStart
        local newPosX = startPos.X.Offset + delta.X
        local newPosY = startPos.Y.Offset + delta.Y
        
        -- Получаем размеры экрана и безопасную зону
        local screenSize = camera.ViewportSize
        local frameSize = mainFrame.AbsoluteSize
        local safeArea = GuiService:GetGuiInset()
        
        -- Ограничиваем позицию, чтобы GUI не выходил за пределы экрана
        newPosX = math.clamp(newPosX, safeArea.X, screenSize.X - frameSize.X - safeArea.X)
        newPosY = math.clamp(newPosY, safeArea.Y, screenSize.Y - frameSize.Y - safeArea.Y)
        
        mainFrame.Position = UDim2.new(0, newPosX, 0, newPosY)
    end
end

local function stopDragging()
    if isDragging then
        isDragging = false
        print("Stopped dragging GUI")
    end
end

-- Функции для управления джойстиком
local function startJoystick(input)
    if isMobile and input.UserInputType == Enum.UserInputType.Touch then
        joystickActive = true
        joystickOrigin = input.Position
        joystickInner.Position = UDim2.new(0.5, -20, 0.5, -20)
        print("Joystick activated")
    end
end

local function updateJoystick(input)
    if joystickActive and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - joystickOrigin
        local maxRadius = 40
        local magnitude = delta.Magnitude
        if magnitude > maxRadius then
            delta = delta.Unit * maxRadius
        end
        joystickInput = delta
        joystickInner.Position = UDim2.new(0.5, delta.X - 20, 0.5, delta.Y - 20)
    end
end

local function stopJoystick()
    if joystickActive then
        joystickActive = false
        joystickInput = Vector2.new(0, 0)
        joystickInner.Position = UDim2.new(0.5, -20, 0.5, -20)
        print("Joystick deactivated")
    end
end

-- Подключение событий
local inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    print("Input detected:", input.UserInputType, input.KeyCode)
    if input.KeyCode == Enum.KeyCode.X then
        teleportAndGhost()
    elseif input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
        makeGhostPartJump(input, gameProcessed)
    end
end)
table.insert(connections, inputConnection)

local heartbeatConnection = RunService.Heartbeat:Connect(function()
    updateGhostPartMovement()
end)
table.insert(connections, heartbeatConnection)

local characterAddedConnection = player.CharacterAdded:Connect(function(newCharacter)
    print("Character respawned, resetting...")
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    if isGhostMode then
        isGhostMode = false
        if ghostPart then
            ghostPart:Destroy()
            ghostPart = nil
        end
        if platform then
            platform:Destroy()
            platform = nil
        end
        camera.CameraSubject = character.Humanoid
        camera.CameraType = Enum.CameraType.Follow
        character.Humanoid.WalkSpeed = 16
        character.Humanoid.JumpPower = 50
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            elseif part:IsA("Decal") then
                part.Transparency = 0
            end
        end
    end
end)
table.insert(connections, characterAddedConnection)

local closeButtonConnection = closeButton.MouseButton1Click:Connect(function()
    shutdownScript()
end)
table.insert(connections, closeButtonConnection)

local invisibleButtonConnection = invisibleButton.MouseButton1Click:Connect(function()
    teleportAndGhost()
end)
table.insert(connections, invisibleButtonConnection)

local revertButtonConnection = revertButton.MouseButton1Click:Connect(function()
    print("Revert button clicked")
    revertToOriginalPosition()
end)
table.insert(connections, revertButtonConnection)

local extraButtonConnection = extraButton.MouseButton1Click:Connect(function()
    createExtraMenu()
end)
table.insert(connections, extraButtonConnection)

-- Подключение событий для перетаскивания
local dragStartConnection = mainFrame.InputBegan:Connect(startDragging)
table.insert(connections, dragStartConnection)

local dragUpdateConnection = UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        updateDragging(input)
    end
end)
table.insert(connections, dragUpdateConnection)

local dragEndConnection = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        stopDragging()
    end
end)
table.insert(connections, dragEndConnection)

-- Подключение событий для джойстика
if isMobile then
    local joystickStartConnection = joystickOuter.InputBegan:Connect(startJoystick)
    table.insert(connections, joystickStartConnection)

    local joystickUpdateConnection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            updateJoystick(input)
        end
    end)
    table.insert(connections, joystickUpdateConnection)

    local joystickEndConnection = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            stopJoystick()
        end
    end)
    table.insert(connections, joystickEndConnection)
end

print("Script initialized")
