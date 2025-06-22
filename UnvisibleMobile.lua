local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

print("Starting GhostScript...") -- Отладка: начало скрипта

local player = Players.LocalPlayer
print("Player found:", player.Name) -- Отладка: игрок найден

-- Ждем, пока персонаж и PlayerGui будут готовы
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
local playerGui = player:WaitForChild("PlayerGui", 5)
local camera = workspace.CurrentCamera

if not humanoidRootPart or not playerGui then
    warn("Failed to find HumanoidRootPart or PlayerGui")
    return
end

print("Character and PlayerGui initialized") -- Отладка: персонаж и GUI готовы

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
print("Is mobile:", isMobile) -- Отладка: определение устройства

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GhostScriptGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
print("ScreenGui created and parented to PlayerGui") -- Отладка: GUI создан

local mainFrame = Instance.new("Frame")
local frameSize = isMobile and UDim2.new(0, 220, 0, 60) or UDim2.new(0, 420, 0, 100)
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(1, -(isMobile and 230 or 430), 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 1
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
print("MainFrame created") -- Отладка: основной фрейм создан

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenSize = TweenService:Create(mainFrame, tweenInfo, {Size = frameSize})
local tweenTransparency = TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 0.5})
tweenSize:Play()
tweenTransparency:Play()
print("Tweens started") -- Отладка: анимации запущены

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
textLabel.TextScaled = isMobile
textLabel.Parent = mainFrame
print("TextLabel created") -- Отладка: текстовый лейбл создан

local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, isMobile and -8 or -16, 0, isMobile and 36 or 60)
buttonFrame.Position = UDim2.new(0, isMobile and 4 or 8, 0, isMobile and 24 or 40)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.Padding = UDim.new(0, isMobile and 4 or 6)
uiListLayout.Parent = buttonFrame
print("ButtonFrame and UIListLayout created") -- Отладка: фрейм кнопок создан

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

local buttonSize = isMobile and UDim2.new(0, 40, 0, 30) or UDim2.new(0, 80, 0, 50)
local closeButton = createButton(buttonFrame, UDim2.new(0, isMobile and 30 or 40, 0, isMobile and 30 or 40), Color3.fromRGB(200, 0, 0), "X", isMobile and 16 or 24, isMobile and 5 or 8, isMobile and 0.5 or 1)
local extraButton = createButton(buttonFrame, buttonSize, Color3.fromRGB(0, 200, 0), "Extra", isMobile and 12 or 18, isMobile and 5 or 8, isMobile and 0.5 or 1)
local invisibleButton = createButton(buttonFrame, buttonSize, Color3.fromRGB(0, 170, 255), "Hide/Show", isMobile and 12 or 18, isMobile and 5 or 8, isMobile and 0.5 or 1)
local revertButton = createButton(buttonFrame, buttonSize, Color3.fromRGB(255, 165, 0), "Revert", isMobile and 12 or 18, isMobile and 5 or 8, isMobile and 0.5 or 1)
local flyButton = createButton(buttonFrame, buttonSize, Color3.fromRGB(128, 0, 128), "Fly Mode", isMobile and 12 or 18, isMobile and 5 or 8, isMobile and 0.5 or 1)
print("Buttons created") -- Отладка: кнопки созданы

local joystickOuter, joystickInner
local joystickActive = false
local joystickOrigin = nil
local joystickInput = Vector2.new(0, 0)
local isFlyMode = false
local ghostPart = nil
local platform = nil
local isGhostMode = false
local lastPosition = nil
local connections = {}
local isDragging = false
local dragStart = nil
local startPos = nil

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
    print("Joystick created for mobile") -- Отладка: джойстик создан
end

local function createPlatform(position)
    if platform then platform:Destroy() end
    platform = Instance.new("Part")
    platform.Name = "PlayerPlatform"
    platform.Size = Vector3.new(10, 1, 10)
    platform.Position = position - Vector3.new(0, 3.5, 0)
    platform.Anchored = true
    platform.BrickColor = BrickColor.new("Really black")
    platform.Parent = workspace
    print("Platform created at", position) -- Отладка: платформа создана
end

local function createGhostPart(position)
    if ghostPart then ghostPart:Destroy() end
    ghostPart = Instance.new("Part")
    ghostPart.Name = "GhostPart"
    ghostPart.Size = Vector3.new(2, 2, 2)
    ghostPart.Position = position.Position + Vector3.new(0, 2, 0)
    ghostPart.Transparency = 0.5
    ghostPart.BrickColor = BrickColor.new("Really white")
    ghostPart.CanCollide = not isFlyMode
    ghostPart.Anchored = false
    ghostPart.Parent = workspace

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "GhostVelocity"
    bodyVelocity.MaxForce = isFlyMode and Vector3.new(math.huge, math.huge, math.huge) or Vector3.new(math.huge, 0, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = ghostPart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "GhostGyro"
    bodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyGyro.CFrame = CFrame.new(ghostPart.Position)
    bodyGyro.Parent = ghostPart

    camera.CameraSubject = ghostPart
    camera.CameraType = Enum.CameraType.Follow
    print("GhostPart created at", position.Position) -- Отладка: призрак создан
end

local function updateGhostPartMovement()
    if not isGhostMode or not ghostPart then return end
    local moveDirection = Vector3.new(0, 0, 0)
    local speed = 60
    local cameraCFrame = camera.CFrame

    if isMobile and joystickActive then
        local inputVector = joystickInput / 40
        moveDirection = cameraCFrame:VectorToWorldSpace(Vector3.new(inputVector.X, isFlyMode and inputVector.Y or 0, inputVector.Y)) * speed
    else
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += cameraCFrame.LookVector * speed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= cameraCFrame.LookVector * speed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= cameraCFrame.RightVector * speed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += cameraCFrame.RightVector * speed end
        if isFlyMode then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, speed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection -= Vector3.new(0, speed, 0) end
        end
    end

    local bodyVelocity = ghostPart:FindFirstChild("GhostVelocity")
    if bodyVelocity then
        bodyVelocity.Velocity = isFlyMode and moveDirection or Vector3.new(moveDirection.X, 0, moveDirection.Z)
    end
end

local function makeGhostPartJump(input, gameProcessed)
    if gameProcessed or not isGhostMode or not ghostPart or isFlyMode then return end
    if input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.Space then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyVelocity.Parent = ghostPart
        task.wait(0.2)
        bodyVelocity:Destroy()
        print("GhostPart jumped") -- Отладка: прыжок призрака
    end
end

local function revertToOriginalPosition()
    if not isGhostMode then return end
    humanoidRootPart.CFrame = lastPosition or CFrame.new(0, 100, 0)
    character.Humanoid.WalkSpeed = 16
    character.Humanoid.JumpPower = 50
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = 0
        end
    end
    camera.CameraSubject = character.Humanoid
    camera.CameraType = Enum.CameraType.Follow
    if ghostPart then ghostPart:Destroy() ghostPart = nil end
    if platform then platform:Destroy() platform = nil end
    isGhostMode = false
    isFlyMode = false
    print("Reverted to original position") -- Отладка: возврат к исходной позиции
end

local function teleportAndGhost()
    if isGhostMode then
        humanoidRootPart.CFrame = ghostPart and CFrame.new(ghostPart.Position + Vector3.new(0, 3, 0)) or CFrame.new(0, 100, 0)
        character.Humanoid.WalkSpeed = 16
        character.Humanoid.JumpPower = 50
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        camera.CameraSubject = character.Humanoid
        camera.CameraType = Enum.CameraType.Follow
        if ghostPart then ghostPart:Destroy() ghostPart = nil end
        if platform then platform:Destroy() platform = nil end
        isGhostMode = false
        isFlyMode = false
        print("Ghost mode deactivated") -- Отладка: режим призрака выключен
    else
        lastPosition = humanoidRootPart.CFrame
        local teleportPosition = Vector3.new(math.random(-1000, 1000), 100, math.random(-1000, 1000))
        createPlatform(teleportPosition)
        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
        createGhostPart(lastPosition)
        character.Humanoid.WalkSpeed = 0
        character.Humanoid.JumpPower = 0
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            elseif part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        isGhostMode = true
        print("Ghost mode activated") -- Отладка: режим призрака включен
    end
end

local function toggleFlyMode()
    isFlyMode = not isFlyMode
    flyButton.BackgroundColor3 = isFlyMode and Color3.fromRGB(200, 0, 200) or Color3.fromRGB(128, 0, 128)
    if isGhostMode and ghostPart then
        ghostPart.CanCollide = not isFlyMode
        local bodyVelocity = ghostPart:FindFirstChild("GhostVelocity")
        if bodyVelocity then
            bodyVelocity.MaxForce = isFlyMode and Vector3.new(math.huge, math.huge, math.huge) or Vector3.new(math.huge, 0, math.huge)
        end
    end
    print("Fly mode:", isFlyMode and "Enabled" or "Disabled") -- Отладка: режим полета
end

local function loadScript(url)
    local success, result = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load script:", result)
    end
    print("Script loaded from", url, "Success:", success) -- Отладка: загрузка скрипта
    return success, result
end

local function createExtraMenu()
    local extraFrame = Instance.new("Frame")
    extraFrame.Size = UDim2.new(0, isMobile and 180 or 300, 0, isMobile and 120 or 200)
    extraFrame.Position = UDim2.new(0.5, -(isMobile and 90 or 150), 0.5, -(isMobile and 60 or 100))
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

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, isMobile and 20 or 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Extra Scripts"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = isMobile and 14 or 18
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = extraFrame

    local closeButton = createButton(extraFrame, UDim2.new(0, isMobile and 20 or 30, 0, isMobile and 20 or 30), Color3.fromRGB(200, 0, 0), "X", isMobile and 14 or 18, 5, 1)
    closeButton.Position = UDim2.new(1, -(isMobile and 25 or 35), 0, 5)

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -(isMobile and 40 or 60))
    scrollFrame.Position = UDim2.new(0, 5, 0, isMobile and 30 or 40)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.Parent = extraFrame

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = scrollFrame

    local scripts = {
        {Name = "Infinite Yield", Url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", Color = Color3.fromRGB(0, 100, 0)},
        {Name = "Fuck HUB", Url = "https://protected-roblox-scripts.onrender.com/2219bf48b54cd405ed94c32097f07c21", Color = Color3.fromRGB(100, 0, 100)},
        {Name = "SFun by vladpcs13", Url = "https://raw.githubusercontent.com/vladpcs13/Unvisible/refs/heads/main/SFun%20by%20vladpcs13.lua", Color = Color3.fromRGB(0, 100, 100)},
        {Name = "Heal Me! by vladpcs13", Url = "https://raw.githubusercontent.com/vladpcs13/Unvisible/refs/heads/main/Heal%20Me!.lua", Color = Color3.fromRGB(0, 150, 150)}
    }

    for _, scriptData in ipairs(scripts) do
        local button = createButton(scrollFrame, UDim2.new(1, 0, 0, isMobile and 25 or 35), scriptData.Color, scriptData.Name, isMobile and 12 or 16, 5, 1)
        button.MouseButton1Click:Connect(function()
            loadScript(scriptData.Url)
            extraFrame:Destroy()
        end)
    end

    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end)

    closeButton.MouseButton1Click:Connect(function()
        extraFrame:Destroy()
    end)
    print("Extra menu created") -- Отладка: меню дополнительных скриптов создано
end

local function shutdownScript()
    if isGhostMode then
        character.Humanoid.WalkSpeed = 16
        character.Humanoid.JumpPower = 50
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        camera.CameraSubject = character.Humanoid
        camera.CameraType = Enum.CameraType.Follow
        isGhostMode = false
        isFlyMode = false
    end
    if ghostPart then ghostPart:Destroy() end
    if platform then platform:Destroy() end
    if screenGui then screenGui:Destroy() end
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    connections = {}
    print("Script shutdown") -- Отладка: скрипт выключен
    script:Destroy()
end

local function startDragging(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        print("Dragging started") -- Отладка: начало перетаскивания
    end
end

local function updateDragging(input)
    if isDragging then
        local delta = input.Position - dragStart
        local newPosX = startPos.X.Offset + delta.X
        local newPosY = startPos.Y.Offset + delta.Y
        local screenSize = camera.ViewportSize
        local frameSize = mainFrame.AbsoluteSize
        local safeArea = GuiService:GetGuiInset()
        newPosX = math.clamp(newPosX, safeArea.X, screenSize.X - frameSize.X - safeArea.X)
        newPosY = math.clamp(newPosY, safeArea.Y, screenSize.Y - frameSize.Y - safeArea.Y)
        mainFrame.Position = UDim2.new(0, newPosX, 0, newPosY)
    end
end

local function stopDragging()
    isDragging = false
    print("Dragging stopped") -- Отладка: конец перетаскивания
end

local function startJoystick(input)
    if isMobile and input.UserInputType == Enum.UserInputType.Touch then
        joystickActive = true
        joystickOrigin = input.Position
        joystickInner.Position = UDim2.new(0.5, -20, 0.5, -20)
        print("Joystick started") -- Отладка: джойстик активирован
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
        print("Joystick stopped") -- Отладка: джойстик деактивирован
    end
end

local function connectEvents()
    print("Connecting events...") -- Отладка: подключение событий
    table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.X then
            pcall(teleportAndGhost)
        elseif input.KeyCode == Enum.KeyCode.Space or input.UserInputType == Enum.UserInputType.Touch then
            pcall(makeGhostPartJump, input, gameProcessed)
        end
    end))

    table.insert(connections, RunService.Heartbeat:Connect(function()
        pcall(updateGhostPartMovement)
    end))

    table.insert(connections, player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        if isGhostMode then
            isGhostMode = false
            isFlyMode = false
            if ghostPart then ghostPart:Destroy() ghostPart = nil end
            if platform then platform:Destroy() platform = nil end
            camera.CameraSubject = character.Humanoid
            camera.CameraType = Enum.CameraType.Follow
            character.Humanoid.WalkSpeed = 16
            character.Humanoid.JumpPower = 50
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = 0
                end
            end
            print("Character respawned, resetting ghost mode") -- Отладка: респавн персонажа
        end
    end))

    table.insert(connections, closeButton.MouseButton1Click:Connect(function()
        pcall(shutdownScript)
    end))

    table.insert(connections, invisibleButton.MouseButton1Click:Connect(function()
        pcall(teleportAndGhost)
    end))

    table.insert(connections, revertButton.MouseButton1Click:Connect(function()
        pcall(revertToOriginalPosition)
    end))

    table.insert(connections, extraButton.MouseButton1Click:Connect(function()
        pcall(createExtraMenu)
    end))

    table.insert(connections, flyButton.MouseButton1Click:Connect(function()
        pcall(toggleFlyMode)
    end))

    table.insert(connections, mainFrame.InputBegan:Connect(startDragging))

    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            pcall(updateDragging, input)
        end
    end))

    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            pcall(stopDragging)
        end
    end))

    if isMobile then
        table.insert(connections, joystickOuter.InputBegan:Connect(startJoystick))
        table.insert(connections, UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                pcall(updateJoystick, input)
            end
        end))
        table.insert(connections, UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                pcall(stopJoystick)
            end
        end))
    end
    print("Events connected") -- Отладка: события подключены
end

local success, errorMsg = pcall(connectEvents)
if not success then
    warn("Failed to initialize events:", errorMsg)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Error",
        Text = "Failed to initialize: " .. tostring(errorMsg),
        Duration = 5
    })
else
    print("Script initialized successfully") -- Отладка: скрипт успешно инициализирован
end
