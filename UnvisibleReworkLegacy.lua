local key = Enum.KeyCode.X
local invis_on = false
local fly_on = false
local connection
local flyConnection
local bodyVelocity
local bodyGyro

function onKeyPress(inputObject, chat)
    if chat then return end
    if inputObject.KeyCode == key then
        toggleInvisibility()
    end
end

function toggleInvisibility()
    invis_on = not invis_on

    local character = game.Players.LocalPlayer.Character
    if not character then return end

    if invis_on then
        local savedpos = character.HumanoidRootPart.CFrame
        wait()
        character:MoveTo(Vector3.new(-25.95, 84, 3537.55))
        wait(.15)
        local Seat = Instance.new('Seat', workspace)
        Seat.Anchored = false
        Seat.CanCollide = false
        Seat.Name = 'invischair'
        Seat.Transparency = 1
        Seat.Position = Vector3.new(-25.95, 84, 3537.55)
        local Weld = Instance.new("Weld", Seat)
        Weld.Part0 = Seat
        Weld.Part1 = character:FindFirstChild("Torso") or character.UpperTorso
        wait()
        Seat.CFrame = savedpos
        game.StarterGui:SetCore("SendNotification", {
            Title = "Invisivble On";
            Duration = 1;
            Text = "";
        })
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 0.5
            elseif part:IsA("Decal") then
                part.Transparency = 0.5
            end
        end
        updateGUI(true)
    else
        local chair = workspace:FindFirstChild('invischair')
        if chair then chair:Destroy() end
        game.StarterGui:SetCore("SendNotification", {
            Title = "Invisible Off";
            Duration = 1;
            Text = "";
        })
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 0
            elseif part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        if fly_on then
            toggleFly()
        end
        updateGUI(false)
    end
end

function toggleFly()
    fly_on = not fly_on
    local character = game.Players.LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if fly_on then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        bodyVelocity.Parent = root

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 20000
        bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
        bodyGyro.CFrame = root.CFrame
        bodyGyro.Parent = root

        updateFlyButton(true)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        bodyVelocity = nil
        bodyGyro = nil
        updateFlyButton(false)
    end
end

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InvisToggleGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 110)
frame.Position = UDim2.new(0, 15, 0, 15)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.7
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -25, 0, 25)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Unvisible Rework"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local invisButton = Instance.new("TextButton")
invisButton.Size = UDim2.new(0, 140, 0, 35)
invisButton.Position = UDim2.new(0.5, -70, 0, 30)
invisButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
invisButton.Text = "OFF"
invisButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invisButton.Font = Enum.Font.GothamBold
invisButton.TextSize = 18
invisButton.AutoButtonColor = false
invisButton.Parent = frame

local invisCorner = Instance.new("UICorner")
invisCorner.CornerRadius = UDim.new(0, 8)
invisCorner.Parent = invisButton

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 140, 0, 30)
flyButton.Position = UDim2.new(0.5, -70, 1, -40)
flyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
flyButton.Text = "FLY OFF"
flyButton.TextColor3 = Color3.fromRGB(200, 200, 200)
flyButton.Font = Enum.Font.Gotham
flyButton.TextSize = 14
flyButton.AutoButtonColor = false
flyButton.Parent = frame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyButton

function updateGUI(state)
    if state then
        invisButton.Text = "ON"
        invisButton.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        invisButton.Text = "OFF"
        invisButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        flyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        flyButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        flyButton.Text = "FLY OFF"
    end
end

function updateFlyButton(state)
    if state then
        flyButton.Text = "FLY ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(50, 180, 220)
    else
        flyButton.Text = "FLY OFF"
        flyButton.BackgroundColor3 = invis_on and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(100, 100, 100)
    end
end

invisButton.MouseButton1Click:Connect(function()
    toggleInvisibility()
end)

flyButton.MouseButton1Click:Connect(function()
    if not invis_on then return end
    toggleFly()
end)

closeButton.MouseButton1Click:Connect(function()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    screenGui:Destroy()
    local chair = workspace:FindFirstChild('invischair')
    if chair then chair:Destroy() end
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 0
            elseif part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end)

local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

connection = game:GetService("UserInputService").InputBegan:Connect(onKeyPress)

flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
    if fly_on and bodyVelocity and bodyGyro then
        local camera = workspace.CurrentCamera
        local move = Vector3.new(0, 0, 0)
        local UIS = game:GetService("UserInputService")

        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end

        bodyVelocity.Velocity = move * 100
        bodyGyro.CFrame = camera.CFrame
    end
end)

updateGUI(false)
