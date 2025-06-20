local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Создание GUI для надписи и кнопок
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GhostScriptGui"
screenGui.ResetOnSpawn = false -- Prevent GUI from resetting on character respawn
screenGui.Parent = player:WaitForChild("PlayerGui")
print("ScreenGui created")

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0, 50)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Unvisible by vladpcs13       t.me/idkbutjustvlad"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextStrokeTransparency = 0
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextSize = 20
textLabel.Font = Enum.Font.SourceSansBold
textLabel.Parent = screenGui
print("TextLabel created")

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -60, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = screenGui
print("CloseButton created")

local invisibleButton = Instance.new("TextButton")
invisibleButton.Size = UDim2.new(0, 100, 0, 50)
invisibleButton.Position = UDim2.new(1, -170, 0, 10) -- Positioned to the left of closeButton
invisibleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
invisibleButton.Text = "Invicible"
invisibleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisibleButton.TextSize = 20
invisibleButton.Font = Enum.Font.SourceSansBold
invisibleButton.Parent = screenGui
print("InvisibleButton created")

-- Переменные
local ghostPart = nil
local platform = nil
local isGhostMode = false
local connections = {}

-- Функция для создания платформы
local function createPlatform(position)
    if platform then
        platform:Destroy()
        print("Old platform destroyed")
    end
    platform = Instance.new("Part")
    platform.Name = "PlayerPlatform"
    platform.Size = Vector3.new(10, 1, 10)
    platform.Position = position - Vector3.new(0, 3.5, 0) -- Под ногами игрока
    platform.Anchored = true
    platform.BrickColor = BrickColor.new("Really black")
    platform.Parent = workspace
    print("Platform created at:", platform.Position)
end

-- Функция для создания призрачного куба
local function createGhostPart(lastPosition)
    if ghostPart then
        ghostPart:Destroy()
        print("Old ghost part destroyed")
    end
    print("Creating ghost part...")
    ghostPart = Instance.new("Part")
    ghostPart.Name = "GhostPart"
    ghostPart.Size = Vector3.new(2, 2, 2)
    ghostPart.Position = lastPosition.Position + Vector3.new(0, 2, 0)
    ghostPart.Transparency = 0.5
    ghostPart.BrickColor = BrickColor.new("Really white")
    ghostPart.CanCollide = true
    ghostPart.Anchored = false
    ghostPart.Parent = workspace
    print("Ghost part created at:", ghostPart.Position)
    
    -- Добавляем BodyVelocity для движения
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "GhostVelocity"
    bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = ghostPart
    
    -- Добавляем BodyGyro для стабилизации
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "GhostGyro"
    bodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyGyro.CFrame = CFrame.new(ghostPart.Position)
    bodyGyro.Parent = ghostPart
    
    -- Привязываем камеру
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
    
    local bodyVelocity = ghostPart:FindFirstChild("GhostVelocity")
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(moveDirection.X, 0, moveDirection.Z)
    end
end

-- Функция для прыжка куба
local function makeGhostPartJump(input, gameProcessed)
    if gameProcessed or not isGhostMode or not ghostPart then return end
    if input.KeyCode == Enum.KeyCode.Space then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        bodyVelocity.Parent = ghostPart
        print("Ghost part jumped")
        wait(0.2)
        bodyVelocity:Destroy()
    end
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
        local lastPosition = humanoidRootPart.CFrame
        print("Last player position saved:", lastPosition.Position)
        
        -- Генерируем случайную позицию
        local teleportPosition = Vector3.new(math.random(-1000, 1000), 100, math.random(-1000, 1000))
        print("Generated teleport position:", teleportPosition)
        
        -- Создаем платформу
        createPlatform(teleportPosition)
        
        -- Телепортируем игрока
        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
        print("Player teleported to:", teleportPosition)
        
        -- Создаем куб
        createGhostPart(lastPosition)
        
        -- Делаем игрока невидимым и неподвижным
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

-- Подключение событий
local inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    print("Input detected:", input.KeyCode)
    if input.KeyCode == Enum.KeyCode.X then
        teleportAndGhost()
    elseif input.KeyCode == Enum.KeyCode.Space then
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

print("Script initialized")
