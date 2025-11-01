local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Unvisible Rework",
    LoadingTitle = "Unvisible Rework",
    LoadingSubtitle = "by vladpcs13",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Rayfield Configs",
        FileName = "UnvisibleRework"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458) -- Новая вкладка

local invis_on = false
local fly_on = false
local connection
local flyConnection
local bodyVelocity
local bodyGyro
local keybind = "X"
local transparency_level = 0.5 -- По умолчанию

-- Мобильные контролы
local mobileFlyGui = nil
local isMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled

function toggleInvisibility()
    invis_on = not invis_on

    local character = game.Players.LocalPlayer.Character
    if not character then return end

    if invis_on then
        local savedpos = character.HumanoidRootPart.CFrame
        task.wait()
        character:MoveTo(Vector3.new(-25.95, 84, 3537.55))
        task.wait(0.15)
        local Seat = Instance.new('Seat', workspace)
        Seat.Anchored = false
        Seat.CanCollide = false
        Seat.Name = 'invischair'
        Seat.Transparency = 1
        Seat.Position = Vector3.new(-25.95, 84, 3537.55)
        local Weld = Instance.new("Weld", Seat)
        Weld.Part0 = Seat
        Weld.Part1 = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        task.wait()
        Seat.CFrame = savedpos
        
        Rayfield:Notify({
            Title = "Invisible On",
            Content = "",
            Duration = 1,
            Image = 4483362458
        })
        
        applyTransparency(transparency_level)
        updateToggleButton(true)
    else
        local chair = workspace:FindFirstChild('invischair')
        if chair then chair:Destroy() end
        
        Rayfield:Notify({
            Title = "Invisible Off",
            Content = "",
            Duration = 1,
            Image = 4483362458
        })
        
        applyTransparency(0)
        if fly_on then
            toggleFly()
        end
        updateToggleButton(false)
    end
end

function applyTransparency(level)
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = level
        elseif part:IsA("Decal") then
            part.Transparency = level
        end
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

        if isMobile then
            createMobileFlyControls()
        end

        updateFlyButton(true)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        bodyVelocity = nil
        bodyGyro = nil

        if mobileFlyGui then
            mobileFlyGui:Destroy()
            mobileFlyGui = nil
        end

        updateFlyButton(false)
    end
end

-- Мобильные кнопки для fly
function createMobileFlyControls()
    if mobileFlyGui then mobileFlyGui:Destroy() end

    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    mobileFlyGui = Instance.new("ScreenGui")
    mobileFlyGui.Name = "MobileFlyControls"
    mobileFlyGui.ResetOnSpawn = false
    mobileFlyGui.Parent = playerGui

    local buttons = {}
    local keys = {"W", "A", "S", "D", "Space", "LeftShift"}
    local positions = {
        W = UDim2.new(0.1, 0, 0.7, 0),
        A = UDim2.new(0.02, 0, 0.8, 0),
        S = UDim2.new(0.1, 0, 0.9, 0),
        D = UDim2.new(0.18, 0, 0.8, 0),
        Space = UDim2.new(0.8, 0, 0.8, 0),
        LeftShift = UDim2.new(0.8, 0, 0.9, 0),
    }

    for _, key in ipairs(keys) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 60)
        btn.Position = positions[key]
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = key == "Space" and "↑" or key == "LeftShift" and "↓" or key
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 24
        btn.Parent = mobileFlyGui
        buttons[key] = btn

        btn.MouseButton1Down:Connect(function()
            game:GetService("ContextActionService"):CallFunction("FlyInput", Enum.KeyCode[key], Enum.UserInputState.Begin)
        end)
        btn.MouseButton1Up:Connect(function()
            game:GetService("ContextActionService"):CallFunction("FlyInput", Enum.KeyCode[key], Enum.UserInputState.End)
        end)
    end
end

-- Fly логика (общая для ПК и мобильных)
flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
    if not fly_on or not bodyVelocity or not bodyGyro then return end

    local camera = workspace.CurrentCamera
    local move = Vector3.new(0, 0, 0)
    local UIS = game:GetService("UserInputService")

    -- ПК ввод
    if UIS:IsKeyDown(Enum.KeyCode.W) then move += camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then move -= camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then move -= camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then move += camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0, 1, 0) end

    -- Мобильный ввод через ContextActionService
    local mobileMove = game:GetService("ContextActionService"):GetCurrentLocalState("FlyInput")
    if mobileMove then
        if mobileMove[Enum.KeyCode.W] then move += camera.CFrame.LookVector end
        if mobileMove[Enum.KeyCode.S] then move -= camera.CFrame.LookVector end
        if mobileMove[Enum.KeyCode.A] then move -= camera.CFrame.RightVector end
        if mobileMove[Enum.KeyCode.D] then move += camera.CFrame.RightVector end
        if mobileMove[Enum.KeyCode.Space] then move += Vector3.new(0, 1, 0) end
        if mobileMove[Enum.KeyCode.LeftShift] then move -= Vector3.new(0, 1, 0) end
    end

    bodyVelocity.Velocity = move.Unit * 100
    bodyGyro.CFrame = camera.CFrame
end)

-- ContextActionService для мобильных
game:GetService("ContextActionService"):BindAction("FlyInput", function(name, state, input)
    return Enum.ContextActionResult.Pass
end, false, unpack({
    Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
    Enum.KeyCode.Space, Enum.KeyCode.LeftShift
}))

-- UI элементы
local InvisToggle, FlyToggle

local function updateToggleButton(state)
    if InvisToggle then InvisToggle:Set(state) end
end

local function updateFlyButton(state)
    if FlyToggle then FlyToggle:Set(state) end
end

-- Main Tab
local ControlSection = MainTab:CreateSection("Controls")

InvisToggle = MainTab:CreateToggle({
    Name = "Invisibility",
    CurrentValue = false,
    Flag = "InvisibilityToggle",
    Callback = function(Value)
        if Value ~= invis_on then
            toggleInvisibility()
        end
    end,
})

FlyToggle = MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        if invis_on and Value ~= fly_on then
            toggleFly()
        elseif not invis_on then
            FlyToggle:Set(false)
            Rayfield:Notify({
                Title = "Error",
                Content = "You must be invisible to use fly",
                Duration = 2,
                Image = 4483362458
            })
        end
    end,
})

MainTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        if character then
            if invis_on then toggleInvisibility() end
            if fly_on then toggleFly() end
            local chair = workspace:FindFirstChild('invischair')
            if chair then chair:Destroy() end
            character:BreakJoints()
            Rayfield:Notify({
                Title = "Character Reset",
                Content = "Your character has been reset",
                Duration = 2,
                Image = 4483362458
            })
        end
    end,
})

-- Settings Tab
local SettingsSection = SettingsTab:CreateSection("Keybinds")

local KeybindDropdown = SettingsTab:CreateDropdown({
    Name = "Invisibility Keybind",
    Options = {"X", "Z", "C", "V", "B", "F", "G", "H", "J", "K", "L"},
    CurrentOption = {keybind},
    MultipleOptions = false,
    Flag = "KeybindDropdown",
    Callback = function(Option)
        keybind = Option[1]
        if connection then connection:Disconnect() end
        setupKeybind()
    end,
})

function setupKeybind()
    if connection then connection:Disconnect() end
    connection = game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode[keybind] then
            toggleInvisibility()
        end
    end)
end

local InfoSection = SettingsTab:CreateSection("Information")
SettingsTab:CreateParagraph({
    Title = "Unvisible Rework",
    Content = "Use the invisibility toggle to become invisible. Fly can only be used while invisible. Use the keybind to quickly toggle invisibility."
})

-- Misc Tab - Прозрачность
local MiscSection = MiscTab:CreateSection("Appearance")

MiscTab:CreateSlider({
    Name = "Transparency Level",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = transparency_level,
    Flag = "TransparencySlider",
    Callback = function(Value)
        transparency_level = Value
        if invis_on then
            applyTransparency(Value)
        end
    end,
})

MiscTab:CreateParagraph({
    Title = "Note",
    Content = "Transparency only applies when invisible."
})

-- При респавне
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    invis_on = false
    fly_on = false
    updateToggleButton(false)
    updateFlyButton(false)
    if mobileFlyGui then
        mobileFlyGui:Destroy()
        mobileFlyGui = nil
    end
end)

-- Инициализация
setupKeybind()

Rayfield:Notify({
    Title = "Unvisible Rework Loaded",
    Content = "Press " .. keybind .. " to toggle invisibility" .. (isMobile and "\nFly controls appear on screen when active" or ""),
    Duration = 6,
    Image = 4483362458
})
