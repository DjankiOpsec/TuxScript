-- TuxScript
-- Roblox Studio LocalScript: GUI with Fly toggle

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local playerGui = player:WaitForChild("PlayerGui")

-- State
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local renderConn = nil

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    if flying then
        stopFly()
    end
end)

local function startFly()
    if flying or not rootPart or not humanoid then return end
    flying = true
    humanoid.PlatformStand = true

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = rootPart

    renderConn = RunService.RenderStepped:Connect(function()
        if not flying or not rootPart then return end
        local camera = workspace.CurrentCamera
        local moveDir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        bodyGyro.CFrame = camera.CFrame
        if moveDir.Magnitude > 0 then
            bodyVelocity.Velocity = moveDir.Unit * flySpeed
        else
            bodyVelocity.Velocity = Vector3.zero
        end
    end)
end

local function stopFly()
    flying = false
    if humanoid then
        humanoid.PlatformStand = false
    end
    if renderConn then
        renderConn:Disconnect()
        renderConn = nil
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TuxScriptGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "TuxScript"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = frame

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyToggle"
flyButton.Size = UDim2.new(0.8, 0, 0, 36)
flyButton.Position = UDim2.new(0.1, 0, 0.45, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
flyButton.Text = "Fly: OFF"
flyButton.TextColor3 = Color3.fromRGB(220, 80, 80)
flyButton.Font = Enum.Font.GothamSemibold
flyButton.TextSize = 14
flyButton.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = flyButton

flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyButton.Text = "Fly: OFF"
        flyButton.TextColor3 = Color3.fromRGB(220, 80, 80)
    else
        startFly()
        flyButton.Text = "Fly: ON"
        flyButton.TextColor3 = Color3.fromRGB(80, 220, 120)
    end
end)
