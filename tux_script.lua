-- Tux Script 🐧 | Minecraft-Style Roblox Exploit GUI (Mobile & PC Responsive Edition)
-- Themes: Dark Glass, Neon Accents, Minecraft Cheat Columns (Celestial/Neverhook Style)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

---------------------------------------------------------
-- CLEANUP REGISTRY (For Full Script Unload)
---------------------------------------------------------
local Connections = {}
local InstancesToClean = {}
local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient
}

local function registerConn(conn)
    table.insert(Connections, conn)
    return conn
end

local function registerInst(inst)
    table.insert(InstancesToClean, inst)
    return inst
end

---------------------------------------------------------
-- STATE & CONFIG
---------------------------------------------------------
local State = {
    -- Player
    SpeedEnabled = false,
    WalkSpeed = 50,
    Fly = false,
    FlySpeed = 60,
    NoClip = false,
    NoFallDamage = false,
    InfJump = false,
    AntiAFK = false,
    
    -- Rage
    PunchEnabled = false,
    PunchMode = "Combined",
    HitboxEnabled = false,
    HitboxSize = 10,
    Spinbot = false,
    AntiFling = false,
    
    -- Fun
    ClickTP = false,
    TuxRide = false,
    RideSpeed = 70,
    Gravity = 196.2,
    ChatSpam = false,
    
    -- Visuals
    ESP = false,
    Tracers = false,
    Fullbright = false,
    
    -- Design
    Theme = "DarkTux",
    GuiVisible = true
}

---------------------------------------------------------
-- THEMES DICTIONARY
---------------------------------------------------------
local Themes = {
    DarkTux = {
        Header = Color3.fromRGB(30, 30, 46),
        Card = Color3.fromRGB(24, 24, 37),
        Accent = Color3.fromRGB(249, 226, 175),
        Text = Color3.fromRGB(205, 214, 244),
        Active = Color3.fromRGB(166, 227, 161)
    },
    NeonPurple = {
        Header = Color3.fromRGB(35, 20, 50),
        Card = Color3.fromRGB(25, 15, 38),
        Accent = Color3.fromRGB(203, 166, 247),
        Text = Color3.fromRGB(245, 224, 220),
        Active = Color3.fromRGB(243, 139, 168)
    },
    CyberCyan = {
        Header = Color3.fromRGB(15, 35, 45),
        Card = Color3.fromRGB(10, 25, 33),
        Accent = Color3.fromRGB(148, 226, 213),
        Text = Color3.fromRGB(227, 240, 245),
        Active = Color3.fromRGB(137, 220, 235)
    },
    Midnight = {
        Header = Color3.fromRGB(18, 18, 24),
        Card = Color3.fromRGB(12, 12, 16),
        Accent = Color3.fromRGB(137, 180, 250),
        Text = Color3.fromRGB(235, 238, 245),
        Active = Color3.fromRGB(166, 227, 161)
    }
}

local currentTheme = Themes.DarkTux

---------------------------------------------------------
-- TARGET GUI PARENT & CLEANUP
---------------------------------------------------------
local guiParent = game:GetService("CoreGui")
pcall(function()
    if not guiParent or not pcall(function() return guiParent.Name end) then
        guiParent = LocalPlayer:WaitForChild("PlayerGui")
    end
end)

if guiParent:FindFirstChild("TuxScriptMinecraftGUI") then
    guiParent.TuxScriptMinecraftGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TuxScriptMinecraftGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = guiParent
registerInst(ScreenGui)

---------------------------------------------------------
-- 1. BEAUTIFUL LOADER ANIMATION
---------------------------------------------------------
local LoaderFrame = Instance.new("Frame")
LoaderFrame.Name = "LoaderFrame"
LoaderFrame.Size = UDim2.new(0, 290, 0, 160)
LoaderFrame.Position = UDim2.new(0.5, -145, 0.5, -80)
LoaderFrame.BackgroundColor3 = currentTheme.Card
LoaderFrame.BorderSizePixel = 0
LoaderFrame.ClipsDescendants = true
LoaderFrame.Parent = ScreenGui

local LoaderCorner = Instance.new("UICorner")
LoaderCorner.CornerRadius = UDim.new(0, 14)
LoaderCorner.Parent = LoaderFrame

local LoaderStroke = Instance.new("UIStroke")
LoaderStroke.Color = currentTheme.Accent
LoaderStroke.Thickness = 2
LoaderStroke.Parent = LoaderFrame

local LoaderLogo = Instance.new("TextLabel")
LoaderLogo.Size = UDim2.new(1, 0, 0, 45)
LoaderLogo.Position = UDim2.new(0, 0, 0, 20)
LoaderLogo.BackgroundTransparency = 1
LoaderLogo.Text = "Tux Script 🐧"
LoaderLogo.TextColor3 = currentTheme.Accent
LoaderLogo.TextSize = 22
LoaderLogo.Font = Enum.Font.GothamBold
LoaderLogo.Parent = LoaderFrame

local LoaderStatus = Instance.new("TextLabel")
LoaderStatus.Size = UDim2.new(1, 0, 0, 25)
LoaderStatus.Position = UDim2.new(0, 0, 0, 65)
LoaderStatus.BackgroundTransparency = 1
LoaderStatus.Text = "Loading Mobile & PC Interface..."
LoaderStatus.TextColor3 = currentTheme.Text
LoaderStatus.TextSize = 12
LoaderStatus.Font = Enum.Font.Gotham
LoaderStatus.Parent = LoaderFrame

local ProgressBarBg = Instance.new("Frame")
ProgressBarBg.Size = UDim2.new(0.8, 0, 0, 6)
ProgressBarBg.Position = UDim2.new(0.1, 0, 0, 105)
ProgressBarBg.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
ProgressBarBg.BorderSizePixel = 0
ProgressBarBg.Parent = LoaderFrame

local ProgressBgCorner = Instance.new("UICorner")
ProgressBgCorner.CornerRadius = UDim.new(1, 0)
ProgressBgCorner.Parent = ProgressBarBg

local ProgressBarFill = Instance.new("Frame")
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = currentTheme.Accent
ProgressBarFill.BorderSizePixel = 0
ProgressBarFill.Parent = ProgressBarBg

local ProgressFillCorner = Instance.new("UICorner")
ProgressFillCorner.CornerRadius = UDim.new(1, 0)
ProgressFillCorner.Parent = ProgressBarFill

-- Animate Loader
local loaderTweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local progressTween = TweenService:Create(ProgressBarFill, loaderTweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
progressTween:Play()

progressTween.Completed:Connect(function()
    LoaderStatus.Text = "Welcome, LO! Ready 🚀"
    task.wait(0.3)
    local fadeOut = TweenService:Create(LoaderFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1})
    fadeOut:Play()
    for _, child in pairs(LoaderFrame:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("Frame") then
            TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            if child:IsA("TextLabel") then
                TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            end
        end
    end
    task.wait(0.4)
    LoaderFrame.Visible = false
end)

---------------------------------------------------------
-- 2. RESPONSIVE MAIN CONTAINER (Mobile & PC Support)
---------------------------------------------------------
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = UDim2.new(0.92, 0, 0.85, 0)
MainContainer.Position = UDim2.new(0.04, 0, 0.075, 0)
MainContainer.BackgroundTransparency = 1
MainContainer.Visible = true
MainContainer.Parent = ScreenGui

-- Max/Min Size Bounds for PC & Mobile
local SizeConstraint = Instance.new("UISizeConstraint")
SizeConstraint.MaxSize = Vector2.new(960, 520)
SizeConstraint.MinSize = Vector2.new(280, 260)
SizeConstraint.Parent = MainContainer

-- Top Header Bar
local HeaderBar = Instance.new("Frame")
HeaderBar.Name = "HeaderBar"
HeaderBar.Size = UDim2.new(1, 0, 0, 42)
HeaderBar.Position = UDim2.new(0, 0, 0, 0)
HeaderBar.BackgroundColor3 = currentTheme.Header
HeaderBar.BorderSizePixel = 0
HeaderBar.Active = true
HeaderBar.Parent = MainContainer

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = HeaderBar

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = currentTheme.Accent
HeaderStroke.Thickness = 2
HeaderStroke.Parent = HeaderBar

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(0.6, 0, 1, 0)
HeaderTitle.Position = UDim2.new(0, 12, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "TuxScript 🐧"
HeaderTitle.TextColor3 = currentTheme.Accent
HeaderTitle.TextSize = 15
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = HeaderBar

-- Header Buttons: Minimize & Full Close (Destroy)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -74, 0, 7)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = currentTheme.Text
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = HeaderBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(235, 87, 87)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = HeaderBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Draggable HeaderBar
local hDragging, hDragInput, hDragStart, hStartPos
HeaderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        hDragging = true
        hDragStart = input.Position
        hStartPos = MainContainer.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                hDragging = false
            end
        end)
    end
end)

HeaderBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        hDragInput = input
    end
end)

registerConn(UserInputService.InputChanged:Connect(function(input)
    if input == hDragInput and hDragging then
        local delta = input.Position - hDragStart
        MainContainer.Position = UDim2.new(hStartPos.X.Scale, hStartPos.X.Offset + delta.X, hStartPos.Y.Scale, hStartPos.Y.Offset + delta.Y)
    end
end))

-- HORIZONTAL SCROLLING FRAME FOR COLUMNS (Touch Swipe Support on Mobile!)
local ColumnsFrame = Instance.new("ScrollingFrame")
ColumnsFrame.Name = "ColumnsFrame"
ColumnsFrame.Size = UDim2.new(1, 0, 1, -48)
ColumnsFrame.Position = UDim2.new(0, 0, 0, 48)
ColumnsFrame.BackgroundTransparency = 1
ColumnsFrame.BorderSizePixel = 0
ColumnsFrame.ScrollBarThickness = 6
ColumnsFrame.ScrollBarImageColor3 = currentTheme.Accent
ColumnsFrame.ScrollBarImageTransparency = 0
ColumnsFrame.CanvasSize = UDim2.new(0, 950, 0, 0) -- Pre-allocated width for 5 columns
ColumnsFrame.ScrollingDirection = Enum.ScrollingDirection.X
ColumnsFrame.Active = true
ColumnsFrame.Selectable = true
ColumnsFrame.ScrollingEnabled = true
ColumnsFrame.ElasticBehavior = Enum.ElasticBehavior.Always
ColumnsFrame.Parent = MainContainer

local ColumnsLayout = Instance.new("UIListLayout")
ColumnsLayout.Parent = ColumnsFrame
ColumnsLayout.FillDirection = Enum.FillDirection.Horizontal
ColumnsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ColumnsLayout.Padding = UDim.new(0, 10)
ColumnsLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function updateColumnsCanvas()
    local totalX = 0
    for _, child in ipairs(ColumnsFrame:GetChildren()) do
        if child:IsA("GuiObject") and not child:IsA("UIListLayout") then
            totalX = totalX + child.Size.X.Offset + 10
        end
    end
    local winX = ColumnsFrame.AbsoluteWindowSize.X
    if winX <= 0 then winX = 600 end
    ColumnsFrame.CanvasSize = UDim2.new(0, math.max(totalX + 30, winX + 60), 0, 0)
end
ColumnsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateColumnsCanvas)
ColumnsFrame.ChildAdded:Connect(function() task.defer(updateColumnsCanvas) end)
task.defer(updateColumnsCanvas)

---------------------------------------------------------
-- MINECRAFT CATEGORY COLUMN BUILDER
---------------------------------------------------------
local categoryColumns = {}

-- Bulletproof Scroll Refresh: Guarantees scrollbar is ALWAYS drawn & active
local function refreshScroll(scroll)
    if not scroll or not scroll:IsA("ScrollingFrame") then return end
    local list = scroll:FindFirstChildOfClass("UIListLayout")
    local pad = list and list.Padding.Offset or 6
    local totalY = 0
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            local h = child.Size.Y.Offset
            if h <= 0 then h = child.AbsoluteSize.Y end
            if h <= 0 then h = 36 end
            totalY = totalY + h + pad
        end
    end
    if list and list.AbsoluteContentSize.Y > totalY then
        totalY = list.AbsoluteContentSize.Y
    end
    local winH = scroll.AbsoluteWindowSize.Y
    if winH <= 0 then winH = 260 end
    -- Guarantee Canvas is ALWAYS strictly taller than the window by at least 100px so scrollbar NEVER disappears
    scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(totalY + 36, winH + 100))
end

-- Helper to allow mouse wheel scrolling anywhere in the column
local function forwardMouseWheel(guiObj, targetScroll)
    guiObj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel and targetScroll and targetScroll:IsA("ScrollingFrame") then
            local delta = input.Position.Z * 45
            local maxScroll = targetScroll.CanvasSize.Y.Offset - targetScroll.AbsoluteWindowSize.Y
            if maxScroll <= 0 then maxScroll = 400 end
            local currentY = targetScroll.CanvasPosition.Y
            targetScroll.CanvasPosition = Vector2.new(0, math.clamp(currentY - delta, 0, maxScroll))
        end
    end)
end

local function createCategoryColumn(title, icon, layoutOrder)
    local col = Instance.new("Frame")
    col.Name = title .. "Column"
    col.Size = UDim2.new(0, 165, 0.98, 0)
    col.BackgroundColor3 = currentTheme.Card
    col.BorderSizePixel = 0
    col.LayoutOrder = layoutOrder
    col.Parent = ColumnsFrame

    local colCorner = Instance.new("UICorner")
    colCorner.CornerRadius = UDim.new(0, 10)
    colCorner.Parent = col

    local colStroke = Instance.new("UIStroke")
    colStroke.Color = currentTheme.Header
    colStroke.Thickness = 1.5
    colStroke.Parent = col

    -- Column Header
    local cHeader = Instance.new("TextLabel")
    cHeader.Size = UDim2.new(1, 0, 0, 34)
    cHeader.Position = UDim2.new(0, 0, 0, 0)
    cHeader.BackgroundColor3 = currentTheme.Header
    cHeader.Text = "  " .. icon .. "  " .. title
    cHeader.TextColor3 = currentTheme.Accent
    cHeader.TextSize = 12
    cHeader.Font = Enum.Font.GothamBold
    cHeader.TextXAlignment = Enum.TextXAlignment.Left
    cHeader.Parent = col

    local cHeaderCorner = Instance.new("UICorner")
    cHeaderCorner.CornerRadius = UDim.new(0, 10)
    cHeaderCorner.Parent = cHeader

    -- Scroll Area for Features inside Column (Accommodates dedicated Touch Thumb on right)
    local cScroll = Instance.new("ScrollingFrame")
    cScroll.Name = title .. "Scroll"
    cScroll.Size = UDim2.new(1, -26, 1, -38)
    cScroll.Position = UDim2.new(0, 3, 0, 36)
    cScroll.BackgroundTransparency = 1
    cScroll.BorderSizePixel = 0
    cScroll.ScrollBarThickness = 0 -- Dedicated touch-draggable "ползунок" handles scrolling
    cScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    cScroll.Active = true
    cScroll.Selectable = true
    cScroll.ScrollingEnabled = true
    cScroll.ClipsDescendants = true
    cScroll.ElasticBehavior = Enum.ElasticBehavior.Always
    cScroll.CanvasSize = UDim2.new(0, 0, 0, 650)
    cScroll.Parent = col

    local cLayout = Instance.new("UIListLayout")
    cLayout.Parent = cScroll
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.Padding = UDim.new(0, 6)
    cLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- =========================================================
    -- MOBILE TOUCH SCROLLBAR ("СПЕЦ ПОЛЗУНОК") 📱
    -- Tactile, visible, wide draggable handle designed specifically for phone screens!
    -- =========================================================
    local scrollTrack = Instance.new("Frame")
    scrollTrack.Name = "TouchScrollTrack"
    scrollTrack.Size = UDim2.new(0, 20, 1, -44)
    scrollTrack.Position = UDim2.new(1, -23, 0, 38)
    scrollTrack.BackgroundColor3 = Color3.fromRGB(24, 24, 38)
    scrollTrack.BorderSizePixel = 0
    scrollTrack.Parent = col

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 6)
    trackCorner.Parent = scrollTrack

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Color = Color3.fromRGB(55, 55, 78)
    trackStroke.Thickness = 1.2
    trackStroke.Parent = scrollTrack

    local scrollThumb = Instance.new("TextButton")
    scrollThumb.Name = "TouchScrollThumb"
    scrollThumb.Size = UDim2.new(1, 0, 0, 48)
    scrollThumb.Position = UDim2.new(0, 0, 0, 0)
    scrollThumb.BackgroundColor3 = currentTheme.Accent
    scrollThumb.Text = "≡"
    scrollThumb.TextColor3 = Color3.fromRGB(18, 18, 28)
    scrollThumb.TextSize = 13
    scrollThumb.Font = Enum.Font.GothamBold
    scrollThumb.AutoButtonColor = false
    scrollThumb.Parent = scrollTrack

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, 6)
    thumbCorner.Parent = scrollThumb

    local thumbStroke = Instance.new("UIStroke")
    thumbStroke.Color = Color3.fromRGB(255, 255, 255)
    thumbStroke.Thickness = 1
    thumbStroke.Transparency = 0.4
    thumbStroke.Parent = scrollThumb

    local isThumbDragging = false
    local thumbTouchStartY = 0
    local thumbStartOffset = 0

    local function applyThumbDrag(inputY)
        local deltaY = inputY - thumbTouchStartY
        local maxThumbY = math.max(1, scrollTrack.AbsoluteSize.Y - scrollThumb.AbsoluteSize.Y)
        local targetThumbY = math.clamp(thumbStartOffset + deltaY, 0, maxThumbY)
        scrollThumb.Position = UDim2.new(0, 0, 0, targetThumbY)

        local ratio = targetThumbY / maxThumbY
        local maxCanvasScroll = math.max(0, cScroll.CanvasSize.Y.Offset - cScroll.AbsoluteWindowSize.Y)
        cScroll.CanvasPosition = Vector2.new(0, ratio * maxCanvasScroll)
    end

    scrollThumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isThumbDragging = true
            thumbTouchStartY = input.Position.Y
            thumbStartOffset = scrollThumb.Position.Y.Offset
        end
    end)

    scrollTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isThumbDragging = true
            local clickRelY = input.Position.Y - scrollTrack.AbsolutePosition.Y
            local maxThumbY = math.max(1, scrollTrack.AbsoluteSize.Y - scrollThumb.AbsoluteSize.Y)
            local targetThumbY = math.clamp(clickRelY - (scrollThumb.AbsoluteSize.Y / 2), 0, maxThumbY)
            scrollThumb.Position = UDim2.new(0, 0, 0, targetThumbY)
            thumbTouchStartY = input.Position.Y
            thumbStartOffset = targetThumbY

            local ratio = targetThumbY / maxThumbY
            local maxCanvasScroll = math.max(0, cScroll.CanvasSize.Y.Offset - cScroll.AbsoluteWindowSize.Y)
            cScroll.CanvasPosition = Vector2.new(0, ratio * maxCanvasScroll)
        end
    end)

    registerConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isThumbDragging = false
        end
    end))

    registerConn(UserInputService.InputChanged:Connect(function(input)
        if isThumbDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            applyThumbDrag(input.Position.Y)
        end
    end))

    cScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if not isThumbDragging then
            local maxCanvasScroll = math.max(1, cScroll.CanvasSize.Y.Offset - cScroll.AbsoluteWindowSize.Y)
            local ratio = math.clamp(cScroll.CanvasPosition.Y / maxCanvasScroll, 0, 1)
            local maxThumbY = math.max(1, scrollTrack.AbsoluteSize.Y - scrollThumb.AbsoluteSize.Y)
            scrollThumb.Position = UDim2.new(0, 0, 0, ratio * maxThumbY)
        end
    end)

    -- =========================================================
    -- TAP-TO-SCROLL ARROWS IN HEADER (1-Tap Convenience) 🔼🔽
    -- =========================================================
    local downBtn = Instance.new("TextButton")
    downBtn.Name = "ScrollDownBtn"
    downBtn.Size = UDim2.new(0, 24, 0, 24)
    downBtn.Position = UDim2.new(1, -26, 0.5, -12)
    downBtn.BackgroundColor3 = Color3.fromRGB(44, 44, 62)
    downBtn.Text = "▼"
    downBtn.TextColor3 = currentTheme.Accent
    downBtn.TextSize = 11
    downBtn.Font = Enum.Font.GothamBold
    downBtn.Parent = cHeader

    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 5)
    downCorner.Parent = downBtn

    downBtn.MouseButton1Click:Connect(function()
        local maxCanvasScroll = math.max(0, cScroll.CanvasSize.Y.Offset - cScroll.AbsoluteWindowSize.Y)
        cScroll.CanvasPosition = Vector2.new(0, math.clamp(cScroll.CanvasPosition.Y + 80, 0, maxCanvasScroll))
    end)

    local upBtn = Instance.new("TextButton")
    upBtn.Name = "ScrollUpBtn"
    upBtn.Size = UDim2.new(0, 24, 0, 24)
    upBtn.Position = UDim2.new(1, -54, 0.5, -12)
    upBtn.BackgroundColor3 = Color3.fromRGB(44, 44, 62)
    upBtn.Text = "▲"
    upBtn.TextColor3 = currentTheme.Accent
    upBtn.TextSize = 11
    upBtn.Font = Enum.Font.GothamBold
    upBtn.Parent = cHeader

    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 5)
    upCorner.Parent = upBtn

    upBtn.MouseButton1Click:Connect(function()
        local maxCanvasScroll = math.max(0, cScroll.CanvasSize.Y.Offset - cScroll.AbsoluteWindowSize.Y)
        cScroll.CanvasPosition = Vector2.new(0, math.clamp(cScroll.CanvasPosition.Y - 80, 0, maxCanvasScroll))
    end)

    -- Full Touch Swipe Detection Over Column
    local touchSwipeStart = 0
    local touchSwipeOriginCanvas = 0
    local isSwiping = false

    local function onTouchSwipeStart(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            touchSwipeStart = input.Position.Y
            touchSwipeOriginCanvas = cScroll.CanvasPosition.Y
            isSwiping = true
        end
    end

    cScroll.InputBegan:Connect(onTouchSwipeStart)
    col.InputBegan:Connect(onTouchSwipeStart)

    registerConn(UserInputService.InputChanged:Connect(function(input)
        if isSwiping and input.UserInputType == Enum.UserInputType.Touch then
            local deltaY = input.Position.Y - touchSwipeStart
            local maxCanvasScroll = math.max(0, cScroll.CanvasSize.Y.Offset - cScroll.AbsoluteWindowSize.Y)
            cScroll.CanvasPosition = Vector2.new(0, math.clamp(touchSwipeOriginCanvas - deltaY, 0, maxCanvasScroll))
        end
    end))

    registerConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isSwiping = false
        end
    end))

    cLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() refreshScroll(cScroll) end)
    cScroll.ChildAdded:Connect(function() task.defer(function() refreshScroll(cScroll) end) end)
    cScroll.ChildRemoved:Connect(function() task.defer(function() refreshScroll(cScroll) end) end)
    cScroll:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() refreshScroll(cScroll) end)

    forwardMouseWheel(cScroll, cScroll)
    forwardMouseWheel(cHeader, cScroll)
    forwardMouseWheel(col, cScroll)

    categoryColumns[title] = cScroll
    return cScroll
end

-- Create the 5 Requested Minecraft Categories
local playerScroll  = createCategoryColumn("Player", "👤", 1)
local rageScroll    = createCategoryColumn("Rage", "⚡", 2)
local funScroll     = createCategoryColumn("Fun", "🎮", 3)
local visualsScroll = createCategoryColumn("Visuals", "👁️", 4)
local designScroll  = createCategoryColumn("Design", "🎨", 5)

---------------------------------------------------------
-- UI MODULE BUILDERS (Toggles, Sliders, Dropdowns)
---------------------------------------------------------

-- Create Module Toggle Button (supports customLayoutOrder)
local function addModuleToggle(parentScroll, name, defaultState, callback, customLayoutOrder)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Toggle"
    btn.Size = UDim2.new(0.96, 0, 0, 34)
    btn.BackgroundColor3 = defaultState and currentTheme.Active or Color3.fromRGB(38, 38, 55)
    btn.Text = name
    btn.TextColor3 = defaultState and Color3.fromRGB(17, 17, 27) or currentTheme.Text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11

    if customLayoutOrder then
        btn.LayoutOrder = customLayoutOrder
    else
        local count = 0
        for _, c in ipairs(parentScroll:GetChildren()) do
            if c:IsA("GuiObject") then count = count + 1 end
        end
        btn.LayoutOrder = count + 10
    end
    btn.Parent = parentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    -- Enable mouse wheel scrolling when cursor is over this toggle
    forwardMouseWheel(btn, parentScroll)

    local state = defaultState
    local touchMoved = false
    local touchStartY = 0
    local touchStartCanvasY = 0

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            touchMoved = false
            touchStartY = input.Position.Y
            touchStartCanvasY = parentScroll.CanvasPosition.Y
        end
    end)

    btn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            local deltaY = input.Position.Y - touchStartY
            if math.abs(deltaY) > 8 then
                touchMoved = true
                local maxCanvasScroll = math.max(0, parentScroll.CanvasSize.Y.Offset - parentScroll.AbsoluteWindowSize.Y)
                parentScroll.CanvasPosition = Vector2.new(0, math.clamp(touchStartCanvasY - deltaY, 0, maxCanvasScroll))
            end
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if touchMoved then
            touchMoved = false
            return
        end
        state = not state
        local targetColor = state and currentTheme.Active or Color3.fromRGB(38, 38, 55)
        local targetTextColor = state and Color3.fromRGB(17, 17, 27) or currentTheme.Text
        
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor, TextColor3 = targetTextColor}):Play()
        callback(state)
    end)

    refreshScroll(parentScroll)
    return btn
end

-- Create Module Slider (supports customLayoutOrder)
local function addModuleSlider(parentScroll, name, min, max, defaultVal, callback, customLayoutOrder)
    local frame = Instance.new("Frame")
    frame.Name = name .. "Slider"
    frame.Size = UDim2.new(0.96, 0, 0, 46)
    frame.BackgroundColor3 = Color3.fromRGB(32, 32, 48)

    if customLayoutOrder then
        frame.LayoutOrder = customLayoutOrder
    else
        local count = 0
        for _, c in ipairs(parentScroll:GetChildren()) do
            if c:IsA("GuiObject") then count = count + 1 end
        end
        frame.LayoutOrder = count + 10
    end
    frame.Parent = parentScroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    -- Enable mouse wheel scrolling when cursor is over this slider frame
    forwardMouseWheel(frame, parentScroll)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -10, 0, 20)
    titleLbl.Position = UDim2.new(0, 5, 0, 2)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = name .. ": " .. tostring(defaultVal)
    titleLbl.TextColor3 = currentTheme.Text
    titleLbl.Font = Enum.Font.Gotham
    titleLbl.TextSize = 10
    titleLbl.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.9, 0, 0, 6)
    sliderBg.Position = UDim2.new(0.05, 0, 0, 28)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    sliderBg.Parent = frame

    forwardMouseWheel(sliderBg, parentScroll)

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = sliderBg

    local fillPercent = math.clamp((defaultVal - min) / (max - min), 0, 1)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
    sliderFill.BackgroundColor3 = currentTheme.Accent
    sliderFill.Parent = sliderBg

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(1, 0)
    fCorner.Parent = sliderFill

    local sDragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        titleLbl.Text = name .. ": " .. tostring(val)
        callback(val)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDragging = true
            updateSlider(input)
        end
    end)

    registerConn(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDragging = false
        end
    end))

    registerConn(UserInputService.InputChanged:Connect(function(input)
        if sDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end))

    -- Mobile touch vertical swipe scroll across slider frame
    local fTouchStartY = 0
    local fTouchStartCanvasY = 0
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            fTouchStartY = input.Position.Y
            fTouchStartCanvasY = parentScroll.CanvasPosition.Y
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and not sDragging then
            local deltaY = input.Position.Y - fTouchStartY
            if math.abs(deltaY) > 8 then
                local maxCanvasScroll = math.max(0, parentScroll.CanvasSize.Y.Offset - parentScroll.AbsoluteWindowSize.Y)
                parentScroll.CanvasPosition = Vector2.new(0, math.clamp(fTouchStartCanvasY - deltaY, 0, maxCanvasScroll))
            end
        end
    end)

    refreshScroll(parentScroll)
    return frame
end

---------------------------------------------------------
-- 3. CATEGORY MODULES IMPLEMENTATION
---------------------------------------------------------

-- ==================== PLAYER CATEGORY ====================

-- Speedhack
addModuleToggle(playerScroll, "Speedhack ⚡", false, function(enabled)
    State.SpeedEnabled = enabled
end)
addModuleSlider(playerScroll, "Speed", 16, 200, 50, function(val)
    State.WalkSpeed = val
end)

registerConn(RunService.Stepped:Connect(function()
    if State.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = State.WalkSpeed
    end
end))

-- Fly (Upright CFrame)
local flyConn
addModuleToggle(playerScroll, "Fly 🕊️", false, function(enabled)
    State.Fly = enabled
    local char = LocalPlayer.Character
    if not char then return end

    if enabled then
        if flyConn then flyConn:Disconnect() end
        flyConn = registerConn(RunService.RenderStepped:Connect(function(dt)
            if not State.Fly or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if flyConn then flyConn:Disconnect() end
                return
            end

            local curChar = LocalPlayer.Character
            local curHrp = curChar:FindFirstChild("HumanoidRootPart")
            local curHum = curChar:FindFirstChildOfClass("Humanoid")

            if curHum then curHum.PlatformStand = false end

            if curHrp then
                curHrp.AssemblyLinearVelocity = Vector3.zero
                curHrp.AssemblyAngularVelocity = Vector3.zero

                local moveDir = Vector3.zero
                local camCF = Camera.CFrame

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                if curHum and curHum.MoveDirection.Magnitude > 0 and moveDir == Vector3.zero then
                    moveDir = (camCF:VectorToWorldSpace(curHum.MoveDirection)).Unit
                end

                if moveDir.Magnitude > 0 then
                    local yawCFrame = CFrame.Angles(0, math.atan2(-camCF.LookVector.X, -camCF.LookVector.Z), 0)
                    local nextPos = curHrp.Position + (moveDir.Unit * State.FlySpeed * dt)
                    curHrp.CFrame = CFrame.new(nextPos) * yawCFrame
                end
            end
        end))
    else
        if flyConn then flyConn:Disconnect() end
    end
end)

-- NoClip
registerConn(RunService.Stepped:Connect(function()
    if State.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end))
addModuleToggle(playerScroll, "NoClip 👻", false, function(enabled)
    State.NoClip = enabled
end)

-- No Fall Damage
local fallDamageConn
local function setupFallDamage(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 3) or char:FindFirstChildOfClass("Humanoid")
    if hum then
        local conn = hum.StateChanged:Connect(function(oldState, newState)
            if State.NoFallDamage and (newState == Enum.HumanoidStateType.Freefall or newState == Enum.HumanoidStateType.Landed) then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
        registerConn(conn)
    end
end

if LocalPlayer.Character then
    setupFallDamage(LocalPlayer.Character)
end
registerConn(LocalPlayer.CharacterAdded:Connect(setupFallDamage))

-- Extra safety net: neutralizes high downward fall velocity right before ground impact
registerConn(RunService.Stepped:Connect(function()
    if State.NoFallDamage and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
            if hrp.AssemblyLinearVelocity.Y < -50 then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -25, hrp.AssemblyLinearVelocity.Z)
            end
        end
    end
end))

addModuleToggle(playerScroll, "No Fall Damage 🪂", false, function(enabled)
    State.NoFallDamage = enabled
end)

-- Infinite Jump
registerConn(UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))
addModuleToggle(playerScroll, "Infinite Jump 🦘", false, function(enabled)
    State.InfJump = enabled
end)

-- Anti-AFK
local afkConn
addModuleToggle(playerScroll, "Anti-AFK ⏰", false, function(enabled)
    State.AntiAFK = enabled
    if enabled then
        local vu = game:GetService("VirtualUser")
        afkConn = registerConn(LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        end))
    else
        if afkConn then afkConn:Disconnect() end
    end
end)

-- ==================== RAGE CATEGORY ====================

-- Floating Action Button for Super Punch
local PunchActionGui = Instance.new("ScreenGui")
PunchActionGui.Name = "TuxPunchActionGui"
PunchActionGui.ResetOnSpawn = false
PunchActionGui.Enabled = false
PunchActionGui.Parent = guiParent
registerInst(PunchActionGui)

local PunchBtn = Instance.new("TextButton")
PunchBtn.Size = UDim2.new(0, 65, 0, 65)
PunchBtn.Position = UDim2.new(0.85, -33, 0.75, -33)
PunchBtn.BackgroundColor3 = currentTheme.Accent
PunchBtn.Text = "PUNCH\n🥊"
PunchBtn.TextColor3 = Color3.fromRGB(17, 17, 27)
PunchBtn.Font = Enum.Font.GothamBold
PunchBtn.TextSize = 12
PunchBtn.Parent = PunchActionGui

local pCorner = Instance.new("UICorner")
pCorner.CornerRadius = UDim.new(1, 0)
pCorner.Parent = PunchBtn

local pStroke = Instance.new("UIStroke")
pStroke.Color = Color3.fromRGB(255, 255, 255)
pStroke.Thickness = 2
pStroke.Parent = PunchBtn

-- Draggable Punch Action Button
local pDrag, pInput, pStart, pPos
PunchBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pDrag = true
        pStart = input.Position
        pPos = PunchBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then pDrag = false end
        end)
    end
end)

PunchBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        pInput = input
    end
end)

registerConn(UserInputService.InputChanged:Connect(function(input)
    if input == pInput and pDrag then
        local delta = input.Position - pStart
        PunchBtn.Position = UDim2.new(pPos.X.Scale, pPos.X.Offset + delta.X, pPos.Y.Scale, pPos.Y.Offset + delta.Y)
    end
end))

-- AUTHENTIC REPLICATED SUPER PUNCH (Anti-Cheat Proof, Zero Ground Damage, Massive Launch)
local isPunching = false
local function performSuperPunch()
    if isPunching then return end
    isPunching = true

    local success, err = pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart or char:FindFirstChild("Torso")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid or humanoid.Health <= 0 then return end

        -- 1. Arm Swing Animation (Single-play, clean stop)
        task.spawn(function()
            pcall(function()
                local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
                local anim = Instance.new("Animation")
                anim.AnimationId = char:FindFirstChild("UpperTorso") and "rbxassetid://507770453" or "rbxassetid://125750799"
                local track = animator:LoadAnimation(anim)
                track.Looped = false
                track:Play(0.05, 1, 2.5)
                task.delay(0.4, function()
                    pcall(function() track:Stop() end)
                end)
            end)

            local shoulder = char:FindFirstChild("Right Shoulder", true) or char:FindFirstChild("RightShoulder", true)
            if shoulder then
                local origC0 = shoulder.C0
                shoulder.C0 = origC0 * CFrame.Angles(math.rad(110), math.rad(-30), 0)
                task.wait(0.25)
                shoulder.C0 = origC0
            end
        end)

        -- 2. Detect Target Player (Camera Crosshair > Mouse Aim > Closest Player)
        local targetCharacter = nil
        local targetPart = nil
        local maxPunchDist = 65
        local closestDist = maxPunchDist

        local function findCharacterFromPart(part)
            if not part then return nil end
            local current = part
            while current and current ~= Workspace and current ~= game do
                if current:IsA("Model") and current:FindFirstChildOfClass("Humanoid") then
                    return current
                end
                current = current.Parent
            end
            return nil
        end

        local function getTargetRoot(character)
            if not character then return nil end
            return character:FindFirstChild("HumanoidRootPart")
                or character:FindFirstChild("UpperTorso")
                or character:FindFirstChild("Torso")
                or character:FindFirstChild("LowerTorso")
                or (character.PrimaryPart and character.PrimaryPart:IsA("BasePart") and character.PrimaryPart)
                or character:FindFirstChild("Head")
                or character:FindFirstChildWhichIsA("BasePart")
        end

        -- Priority 1: Screen Center / Crosshair Ray (Works perfectly even when tapping on-screen Punch button!)
        local cam = Workspace.CurrentCamera
        if cam then
            local centerRay = Ray.new(cam.CFrame.Position, cam.CFrame.LookVector * maxPunchDist)
            local hitPart, _ = Workspace:FindPartOnRayWithIgnoreList(centerRay, {char})
            if hitPart then
                local cChar = findCharacterFromPart(hitPart)
                if cChar then
                    local cPlayer = Players:GetPlayerFromCharacter(cChar)
                    if cPlayer and cPlayer ~= LocalPlayer then
                        local cHum = cChar:FindFirstChildOfClass("Humanoid")
                        local cRoot = getTargetRoot(cChar)
                        if cRoot and (not cHum or cHum.Health > 0) then
                            targetCharacter = cChar
                            targetPart = cRoot
                        end
                    end
                end
            end
        end

        -- Priority 2: Direct Mouse Pointer Aim
        if not targetCharacter and Mouse.Target then
            local mChar = findCharacterFromPart(Mouse.Target)
            if mChar then
                local mPlayer = Players:GetPlayerFromCharacter(mChar)
                if mPlayer and mPlayer ~= LocalPlayer then
                    local mHum = mChar:FindFirstChildOfClass("Humanoid")
                    local mRoot = getTargetRoot(mChar)
                    if mRoot and (not mHum or mHum.Health > 0) then
                        local dist = (mRoot.Position - hrp.Position).Magnitude
                        if dist <= maxPunchDist then
                            targetCharacter = mChar
                            targetPart = mRoot
                        end
                    end
                end
            end
        end

        -- Priority 3: Closest Player within range
        if not targetCharacter then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local tChar = player.Character
                    local tHum = tChar:FindFirstChildOfClass("Humanoid")
                    local tMainPart = getTargetRoot(tChar)

                    if tMainPart and (not tHum or tHum.Health > 0) then
                        local dist = (tMainPart.Position - hrp.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            targetCharacter = tChar
                            targetPart = tMainPart
                        end
                    end
                end
            end
        end

        -- 3. Execute High-Impact FE Fling Punch (Safe to Local Player, Explosive to Target)
        if targetCharacter and targetPart and targetCharacter.Parent and not targetPart.Anchored then
            local startPlayerPos = hrp.Position
            local initialTPos = targetPart.Position
            local toTarget = initialTPos - startPlayerPos
            local punchDir = Vector3.new(toTarget.X, 0, toTarget.Z)
            if punchDir.Magnitude > 0.1 then
                punchDir = punchDir.Unit
            else
                punchDir = hrp.CFrame.LookVector
            end

            -- A. GODMODE & COMPLETE FALL/IMPACT DAMAGE IMMUNITY
            local safeHealth = humanoid.Health
            local godConn = humanoid.HealthChanged:Connect(function(newHealth)
                if humanoid and humanoid.Parent and newHealth < safeHealth then
                    pcall(function() humanoid.Health = safeHealth end)
                end
            end)

            -- Disable client-side fall/ragdoll damage scripts
            for _, scriptName in ipairs({"FallDamage", "FallDamageScript", "Fall_Damage", "FallDamage_Client", "RagdollClient", "TouchDamage", "Damage"}) do
                pcall(function()
                    local s = char:FindFirstChild(scriptName, true) or (LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild(scriptName, true))
                    if s and s:IsA("LocalScript") then
                        s.Disabled = true
                    end
                end)
            end

            -- Keep local humanoid completely upright and stable
            pcall(function()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                if humanoid.Sit then humanoid.Sit = false end
            end)

            -- Automatically equip combat tool if available
            local activeTool = char:FindFirstChildOfClass("Tool")
            if not activeTool then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    local tool = backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        pcall(function() humanoid:EquipTool(tool) end)
                        activeTool = tool
                    end
                end
            end

            -- B. IMMUNITY TO GROUND TOUCHES & SENSORS
            local origCanTouch = {}
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    origCanTouch[p] = p.CanTouch
                    local isWeaponPart = (activeTool and p:IsDescendantOf(activeTool)) or p.Name == "RightHand" or p.Name == "Right Arm"
                    if not isWeaponPart then
                        pcall(function() p.CanTouch = false end)
                    end
                end
            end

            -- Heavy physical density on HRP for colossal impact mass
            local origPhysProps = hrp.CustomPhysicalProperties
            pcall(function()
                hrp.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 100, 1)
            end)

            -- Complete noclip on local character so ground/walls NEVER repel us into the stratosphere!
            local noclipConn = RunService.Stepped:Connect(function()
                if char and char.Parent then
                    for _, p in pairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                end
            end)

            -- C. BODY ANGULAR VELOCITY (Pure Y-Axis Centrifuge)
            -- MaxTorque is STRICTLY 0 on X and Z so local player can NEVER pitch, tilt, or flip into the floor!
            local bav = Instance.new("BodyAngularVelocity")
            bav.Name = "TuxPunchBAV"
            bav.MaxTorque = Vector3.new(0, math.huge, 0)
            bav.AngularVelocity = Vector3.new(0, 85000, 0)
            bav.P = math.huge
            bav.Parent = hrp

            -- Collect target parts for combat damage (tools, remotes, touches)
            local targetHitParts = {}
            for _, p in pairs(targetCharacter:GetChildren()) do
                if p:IsA("BasePart") and not p:IsA("Accessory") then
                    table.insert(targetHitParts, p)
                end
            end
            if #targetHitParts == 0 and targetPart then
                table.insert(targetHitParts, targetPart)
            end

            -- D. HIGH-OCTANE STRIKE LOOP (0.28s max or until enemy is blasted away)
            local strikeDuration = 0.28
            local strikeStart = tick()
            local lastKnownTargetPos = initialTPos
            local movel = 0.1

            while tick() - strikeStart < strikeDuration do
                if not targetCharacter or not targetCharacter.Parent or not targetPart or not targetPart.Parent then
                    break
                end

                local curTPos = targetPart.Position
                lastKnownTargetPos = curTPos

                -- If enemy is already launched > 45 studs away, mission accomplished!
                if (curTPos - initialTPos).Magnitude > 45 then
                    break
                end

                -- Target lead prediction for moving/sprinting enemies
                local curTVel = targetPart.AssemblyLinearVelocity or Vector3.zero
                local lead = (curTVel.Magnitude > 0.5) and (curTVel.Unit * math.min(curTVel.Magnitude * 0.04, 1.8)) or Vector3.zero
                local targetCenter = curTPos + lead

                -- Micro-oscillation directly inside target hitbox to trigger continuous physical collision manifolds
                local osc = math.sin(tick() * 60) * 0.3
                local attackPos = targetCenter + Vector3.new(punchDir.X * osc, 0, punchDir.Z * osc)

                -- Orient HRP firmly in punch direction
                hrp.CFrame = CFrame.lookAt(attackPos, attackPos + punchDir * 10)

                -- 1. Heartbeat Impulse Spike: transmit colossal fling momentum in punch direction and upward
                local launchVelocity = punchDir * 35000 + Vector3.new(0, 18000, 0)
                hrp.AssemblyLinearVelocity = launchVelocity

                -- 2. Tool Activation
                for _, item in pairs(char:GetChildren()) do
                    if item:IsA("Tool") then
                        pcall(function() item:Activate() end)
                        for _, r in pairs(item:GetDescendants()) do
                            if r:IsA("RemoteEvent") then
                                pcall(function() r:FireServer(targetCharacter, targetPart) end)
                                pcall(function() r:FireServer() end)
                            end
                        end
                    end
                end

                -- 3. Combat Remotes
                pcall(function()
                    local combatKeywords = {"punch", "attack", "hit", "damage", "swing", "slash", "combat", "melee", "m1"}
                    local rep = game:GetService("ReplicatedStorage")
                    for _, inst in pairs(rep:GetChildren()) do
                        if inst:IsA("RemoteEvent") then
                            local lName = string.lower(inst.Name)
                            for _, kw in ipairs(combatKeywords) do
                                if string.find(lName, kw) then
                                    pcall(function() inst:FireServer(targetCharacter, targetPart) end)
                                    pcall(function() inst:FireServer("Punch", targetCharacter) end)
                                    pcall(function() inst:FireServer() end)
                                    break
                                end
                            end
                        end
                    end
                end)

                -- 4. Multi-Hit Touch Interest (0 then 1 every frame for instant register)
                pcall(function()
                    if firetouchinterest then
                        local tool = char:FindFirstChildOfClass("Tool")
                        local weaponParts = {
                            tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")),
                            char:FindFirstChild("RightHand"),
                            char:FindFirstChild("Right Arm"),
                            char:FindFirstChild("LeftHand"),
                            char:FindFirstChild("Left Arm")
                        }
                        for _, wPart in ipairs(weaponParts) do
                            if wPart then
                                for _, tp in ipairs(targetHitParts) do
                                    if tp and tp.Parent then
                                        firetouchinterest(wPart, tp, 0)
                                        firetouchinterest(wPart, tp, 1)
                                    end
                                end
                            end
                        end
                    end
                end)

                -- Wait for RenderStepped and immediately neutralize local velocity so player & camera never fling!
                RunService.RenderStepped:Wait()
                if hrp and hrp.Parent then
                    hrp.AssemblyLinearVelocity = Vector3.zero
                end

                -- Micro-step to keep physics solver alive
                RunService.Stepped:Wait()
                if hrp and hrp.Parent then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, movel, 0)
                    movel = -movel
                end
            end

            -- E. CLEAN STOP & ZERO RECOIL - NO BACKWARD TELEPORTATION!
            pcall(function() bav:Destroy() end)
            noclipConn:Disconnect()

            -- Neutralize all velocities dead to zero
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            pcall(function()
                hrp.Velocity = Vector3.zero
                hrp.RotVelocity = Vector3.zero
                hrp.CustomPhysicalProperties = origPhysProps
            end)

            -- Plant player firmly and upright right where the punch landed, facing forward!
            local floorParams = RaycastParams.new()
            floorParams.FilterType = RaycastParamsType.Exclude
            floorParams.FilterDescendantsInstances = {char, targetCharacter}
            floorParams.IgnoreWater = true

            local stopPos = lastKnownTargetPos - punchDir * 1.5
            local floorRay = Workspace:Raycast(stopPos + Vector3.new(0, 4, 0), Vector3.new(0, -15, 0), floorParams)
            local floorY = floorRay and (floorRay.Position.Y + 3.0) or stopPos.Y
            hrp.CFrame = CFrame.lookAt(
                Vector3.new(stopPos.X, floorY, stopPos.Z),
                Vector3.new(stopPos.X + punchDir.X * 10, floorY, stopPos.Z + punchDir.Z * 10)
            )
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero

            -- Restore CanTouch on character parts
            for p, touch in pairs(origCanTouch) do
                if p and p.Parent then
                    pcall(function() p.CanTouch = touch end)
                end
            end

            -- Keep godmode active for 0.4s to prevent any delayed damage
            task.delay(0.4, function()
                if godConn then
                    godConn:Disconnect()
                    godConn = nil
                end
            end)
        end
    end)

    if not success and err then
        warn("TuxScript Super Punch Error: " .. tostring(err))
    end

    task.wait(0.12)
    isPunching = false
end

PunchBtn.MouseButton1Click:Connect(performSuperPunch)

-- Keybind support: Press F on PC to trigger Super Punch!
registerConn(UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and State.PunchEnabled and input.KeyCode == Enum.KeyCode.F then
        performSuperPunch()
    end
end))

addModuleToggle(rageScroll, "Super Punch 🥊", false, function(enabled)
    State.PunchEnabled = enabled
    PunchActionGui.Enabled = enabled
end)

-- Hitbox Expander (Supports custom avatars, R6, R15, and custom meshes)
addModuleToggle(rageScroll, "Hitbox Expander 📦", false, function(enabled)
    State.HitboxEnabled = enabled
end)
addModuleSlider(rageScroll, "Hitbox Size", 4, 25, 10, function(val)
    State.HitboxSize = val
end)

registerConn(RunService.RenderStepped:Connect(function()
    if State.HitboxEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local tChar = player.Character
                local targetP = tChar:FindFirstChild("HumanoidRootPart")
                    or tChar:FindFirstChild("Torso")
                    or tChar:FindFirstChild("UpperTorso")
                    or tChar:FindFirstChildOfClass("BasePart")

                if targetP then
                    targetP.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                    targetP.Transparency = 0.7
                    targetP.Color = currentTheme.Accent
                    targetP.Material = Enum.Material.ForceField
                    targetP.CanCollide = false
                end
            end
        end
    end
end))

-- Spinbot
addModuleToggle(rageScroll, "Spinbot 🌀", false, function(enabled)
    State.Spinbot = enabled
end)

registerConn(RunService.RenderStepped:Connect(function()
    if State.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
    end
end))

-- Anti-Fling Shield
addModuleToggle(rageScroll, "Anti-Fling Shield 🛡️", false, function(enabled)
    State.AntiFling = enabled
end)

registerConn(RunService.Heartbeat:Connect(function()
    if State.AntiFling and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.AssemblyLinearVelocity.Magnitude > 150 then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end
end))

-- ==================== FUN CATEGORY ====================

-- Click Teleport
addModuleToggle(funScroll, "Click Teleport 📍", false, function(enabled)
    State.ClickTP = enabled
end, 3)

registerConn(UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and State.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 then
        if Mouse.Target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end))

-- =========================================================
-- EMPEROR TUX RIDE MOUNT 🐧👑
-- Rideable 3D Emperor Penguin companion mount with saddle,
-- golden neck markings, reins, responsive WASD / joystick steering,
-- ground normal physics, high-speed ice belly-sliding with
-- snow roostertail particles, and dynamic procedural rider kinematics!
-- =========================================================
local rideModel = nil
local rideLoopConn = nil
local rideClickConns = {}
local rideCharAddedConn = nil
local rideSeat = nil
local isRiderMounted = false
local rideActionBtn = nil
local rideSprintBtn = nil
local rideTurboBtn = nil
local mobileSprintHeld = false
local mobileTurboActive = false

local function cleanupTuxRide()
    if rideLoopConn then
        pcall(function() rideLoopConn:Disconnect() end)
        rideLoopConn = nil
    end
    for _, c in ipairs(rideClickConns) do
        pcall(function() c:Disconnect() end)
    end
    rideClickConns = {}

    if rideActionBtn then
        pcall(function() rideActionBtn:Destroy() end)
        rideActionBtn = nil
    end
    if rideSprintBtn then
        pcall(function() rideSprintBtn:Destroy() end)
        rideSprintBtn = nil
    end
    if rideTurboBtn then
        pcall(function() rideTurboBtn:Destroy() end)
        rideTurboBtn = nil
    end
    mobileSprintHeld = false
    mobileTurboActive = false

    -- Safely unseat player and restore limbs
    if isRiderMounted and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum.Sit = false end)
        end
        for _, motor in ipairs(LocalPlayer.Character:GetDescendants()) do
            if motor:IsA("Motor6D") then
                pcall(function() motor.Transform = CFrame.new() end)
            end
        end
    end
    isRiderMounted = false
    rideSeat = nil

    if rideModel then
        pcall(function() rideModel:Destroy() end)
        rideModel = nil
    end
end

local function spawnEmperorTuxRide()
    cleanupTuxRide()

    local char = LocalPlayer.Character
    if not char then return end
    local playerHrp = char:FindFirstChild("HumanoidRootPart")
    if not playerHrp then return end

    -- Container model parented directly to Workspace
    rideModel = Instance.new("Model")
    rideModel.Name = "EmperorTuxRide"
    rideModel.Parent = Workspace
    registerInst(rideModel)

    -- Invisible root (centered at mount base)
    local root = Instance.new("Part")
    root.Name = "RideRoot"
    root.Size = Vector3.new(3.0, 4.4, 3.8)
    root.Transparency = 1
    root.CanCollide = false
    root.CanTouch = false
    root.CanQuery = false
    root.Massless = true
    root.Anchored = true
    root.CFrame = playerHrp.CFrame * CFrame.new(3.5, 0, 1)
    root.Parent = rideModel
    rideModel.PrimaryPart = root

    -- Helper to create guaranteed visual parts
    local function makePart(name, size, color, meshType, meshScale, material)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.Color = color
        p.Material = material or Enum.Material.SmoothPlastic
        p.CanCollide = false
        p.CanTouch = true
        p.CanQuery = true
        p.Massless = true
        p.Anchored = true
        p.CastShadow = false
        p.CFrame = root.CFrame
        p.Parent = rideModel

        if meshType then
            local m = Instance.new("SpecialMesh")
            m.MeshType = meshType
            if meshScale then
                m.Scale = meshScale
            end
            m.Parent = p
        end

        return p
    end

    -- Emperor Penguin Color Palette
    local colBlack = Color3.fromRGB(22, 24, 34)
    local colWhite = Color3.fromRGB(255, 255, 255)
    local colGold = Color3.fromRGB(255, 155, 20)
    local colYellow = Color3.fromRGB(255, 215, 45)
    local colCrown = Color3.fromRGB(255, 225, 30)
    local colBeak = Color3.fromRGB(255, 125, 20)
    local colBeakStripe = Color3.fromRGB(255, 65, 85)
    local colEyePupil = Color3.fromRGB(15, 15, 20)
    local colFeet = Color3.fromRGB(255, 130, 20)
    local colLeather = Color3.fromRGB(115, 60, 30)
    local colStirrup = Color3.fromRGB(255, 215, 60)
    local colReins = Color3.fromRGB(55, 30, 15)

    -- 1. Aerodynamic Elongated Emperor Body (Torso)
    local bodyPart = makePart("Body", Vector3.new(2.8, 3.8, 3.6), colBlack, Enum.MeshType.Sphere)

    -- 2. Crisp White Tuxedo Belly (Front)
    local bellyPart = makePart("Belly", Vector3.new(2.2, 3.2, 2.2), colWhite, Enum.MeshType.Sphere)

    -- 3. Golden-Yellow Throat Bib
    local chestGoldPart = makePart("ChestGold", Vector3.new(1.8, 1.4, 1.4), colYellow, Enum.MeshType.Sphere)

    -- 4. Emperor Neck & Auricular Patches (Left & Right)
    local neckPart = makePart("Neck", Vector3.new(1.8, 1.6, 1.8), colBlack, Enum.MeshType.Sphere)
    local neckGoldLeft = makePart("NeckGoldLeft", Vector3.new(0.55, 0.9, 0.7), colGold, Enum.MeshType.Sphere)
    local neckGoldRight = makePart("NeckGoldRight", Vector3.new(0.55, 0.9, 0.7), colGold, Enum.MeshType.Sphere)

    -- 5. Emperor Head (Forward at Z = -2.2, clearly ahead of rider)
    local headPart = makePart("Head", Vector3.new(1.9, 1.8, 2.2), colBlack, Enum.MeshType.Sphere)

    -- 6. Royal Golden Crown 👑
    local crownBase = makePart("CrownBase", Vector3.new(0.95, 0.45, 0.95), colCrown, Enum.MeshType.Cylinder, nil, Enum.Material.Neon)
    local crownSpike1 = makePart("CrownSpike1", Vector3.new(0.24, 0.45, 0.24), colCrown, Enum.MeshType.Wedge, nil, Enum.Material.Neon)
    local crownSpike2 = makePart("CrownSpike2", Vector3.new(0.2, 0.38, 0.2), colCrown, Enum.MeshType.Wedge, nil, Enum.Material.Neon)
    local crownSpike3 = makePart("CrownSpike3", Vector3.new(0.2, 0.38, 0.2), colCrown, Enum.MeshType.Wedge, nil, Enum.Material.Neon)

    -- 7. Emperor Beak & Coral Mandibular Stripe
    local beakPart = makePart("Beak", Vector3.new(0.55, 0.45, 1.6), colBeak, Enum.MeshType.Wedge)
    local beakStripePart = makePart("BeakStripe", Vector3.new(0.5, 0.18, 1.2), colBeakStripe, Enum.MeshType.Brick)

    -- 8. Expressive Eyes (Left & Right)
    local leftEyeWhite = makePart("LeftEyeWhite", Vector3.new(0.4, 0.45, 0.18), colWhite, Enum.MeshType.Sphere)
    local leftEyePupil = makePart("LeftEyePupil", Vector3.new(0.22, 0.26, 0.12), colEyePupil, Enum.MeshType.Sphere)
    local rightEyeWhite = makePart("RightEyeWhite", Vector3.new(0.4, 0.45, 0.18), colWhite, Enum.MeshType.Sphere)
    local rightEyePupil = makePart("RightEyePupil", Vector3.new(0.22, 0.26, 0.12), colEyePupil, Enum.MeshType.Sphere)

    -- 9. Hydrodynamic Flippers with White Inner Feathering
    local leftFlipper = makePart("LeftFlipper", Vector3.new(0.45, 3.0, 1.1), colBlack, Enum.MeshType.Sphere)
    local leftFlipperInner = makePart("LeftFlipperInner", Vector3.new(0.25, 2.6, 0.9), colWhite, Enum.MeshType.Sphere)
    local rightFlipper = makePart("RightFlipper", Vector3.new(0.45, 3.0, 1.1), colBlack, Enum.MeshType.Sphere)
    local rightFlipperInner = makePart("RightFlipperInner", Vector3.new(0.25, 2.6, 0.9), colWhite, Enum.MeshType.Sphere)

    -- 10. Webbed Orange Feet with Toe Details
    local leftFoot = makePart("LeftFoot", Vector3.new(0.95, 0.4, 1.6), colFeet, Enum.MeshType.Sphere)
    local rightFoot = makePart("RightFoot", Vector3.new(0.95, 0.4, 1.6), colFeet, Enum.MeshType.Sphere)

    -- 11. Rudder Tail (Behind Saddle at Z = +2.2)
    local tailPart = makePart("Tail", Vector3.new(0.9, 0.5, 1.2), colBlack, Enum.MeshType.Wedge)

    -- 12. Saddle, Pommel, Cantle, Stirrups & Reins (At Z = 0.4, Y = 1.65)
    local saddleBase = makePart("SaddleBase", Vector3.new(2.4, 0.45, 2.4), colLeather, Enum.MeshType.Brick)
    local saddleCantle = makePart("SaddleCantle", Vector3.new(2.1, 0.9, 0.4), colLeather, Enum.MeshType.Brick)
    local saddlePummel = makePart("SaddlePummel", Vector3.new(1.4, 0.75, 0.4), colLeather, Enum.MeshType.Brick)
    local leftStirrup = makePart("LeftStirrup", Vector3.new(0.18, 1.2, 0.22), colStirrup, Enum.MeshType.Brick)
    local rightStirrup = makePart("RightStirrup", Vector3.new(0.18, 1.2, 0.22), colStirrup, Enum.MeshType.Brick)
    local reinLeft = makePart("ReinLeft", Vector3.new(0.12, 0.12, 2.2), colReins, Enum.MeshType.Brick)
    local reinRight = makePart("ReinRight", Vector3.new(0.12, 0.12, 2.2), colReins, Enum.MeshType.Brick)

    -- 13. VehicleSeat for Rider (MaxSpeed = 100 so Roblox VehicleController works!)
    rideSeat = Instance.new("VehicleSeat")
    rideSeat.Name = "TuxRideSeat"
    rideSeat.Size = Vector3.new(2.2, 0.5, 2.2)
    rideSeat.Transparency = 1
    rideSeat.CanCollide = false
    rideSeat.CanTouch = true
    rideSeat.CanQuery = true
    rideSeat.Massless = true
    rideSeat.Anchored = true
    rideSeat.MaxSpeed = 100
    rideSeat.HeadsUpDisplay = false
    rideSeat.CFrame = root.CFrame * CFrame.new(0, 1.9, 0.4)
    rideSeat.Parent = rideModel

    -- 14. Particle Emitter for Ice Sliding
    local slideEmitter = Instance.new("ParticleEmitter")
    slideEmitter.Name = "RideIceParticles"
    slideEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    slideEmitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 250, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 225, 255))
    })
    slideEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 1.8)
    })
    slideEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    slideEmitter.Lifetime = NumberRange.new(0.35, 0.65)
    slideEmitter.Rate = 50
    slideEmitter.Speed = NumberRange.new(7, 16)
    slideEmitter.SpreadAngle = Vector2.new(55, 55)
    slideEmitter.Enabled = false
    slideEmitter.Parent = bodyPart

    -- 15. Overhead Status Badge
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RideBadge"
    billboard.Size = UDim2.new(0, 200, 0, 48)
    billboard.StudsOffset = Vector3.new(0, 3.8, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 75
    billboard.Adornee = headPart
    billboard.Parent = rideModel

    local badgeFrame = Instance.new("Frame")
    badgeFrame.Size = UDim2.new(1, 0, 1, 0)
    badgeFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
    badgeFrame.BackgroundTransparency = 0.25
    badgeFrame.BorderSizePixel = 0
    badgeFrame.Parent = billboard

    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 8)
    badgeCorner.Parent = badgeFrame

    local badgeStroke = Instance.new("UIStroke")
    badgeStroke.Color = currentTheme.Accent or Color3.fromRGB(255, 175, 45)
    badgeStroke.Thickness = 1.3
    badgeStroke.Transparency = 0.3
    badgeStroke.Parent = badgeFrame

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, 0, 0.52, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Text = "👑 Emperor Tux • LO's Mount"
    nameLbl.TextColor3 = Color3.fromRGB(255, 235, 170)
    nameLbl.TextSize = 12
    nameLbl.Parent = badgeFrame

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, 0, 0.48, 0)
    statusLbl.Position = UDim2.new(0, 0, 0.5, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Font = Enum.Font.Gotham
    statusLbl.Text = "Tap or [E] to Ride!"
    statusLbl.TextColor3 = Color3.fromRGB(190, 230, 255)
    statusLbl.TextSize = 10
    statusLbl.Parent = badgeFrame

    -- Forward declaration for mount/dismount functions
    local mountPlayer, dismountPlayer

    -- Helper functions for mount / dismount UI
    local function updateFloatingControls()
        if not rideActionBtn then return end
        if isRiderMounted then
            rideActionBtn.Text = "🐾 DISMOUNT"
            rideActionBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
            if rideSprintBtn then rideSprintBtn.Visible = true end
            if rideTurboBtn then rideTurboBtn.Visible = true end
        else
            rideActionBtn.Text = "🏇 RIDE TUX"
            rideActionBtn.BackgroundColor3 = Color3.fromRGB(30, 180, 80)
            if rideSprintBtn then rideSprintBtn.Visible = false end
            if rideTurboBtn then rideTurboBtn.Visible = false end
            mobileSprintHeld = false
            mobileTurboActive = false
        end
    end

    mountPlayer = function()
        local myChar = LocalPlayer.Character
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHum or not myHrp then return end

        isRiderMounted = true
        myHum.Sit = true
        myHrp.CFrame = root.CFrame * CFrame.new(0, 1.95, 0.4)
        myHrp.AssemblyLinearVelocity = Vector3.zero
        if rideSeat then
            rideSeat.MaxSpeed = 100
            pcall(function() rideSeat:Sit(myHum) end)
        end
        statusLbl.Text = "🐾 Riding • Joystick / Look to Steer"
        statusLbl.TextColor3 = Color3.fromRGB(180, 245, 180)
        updateFloatingControls()
        notify("Emperor Tux 👑", "Mounted! Use Joystick, pedals or camera to ride!", 3)
    end

    dismountPlayer = function()
        local myChar = LocalPlayer.Character
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        isRiderMounted = false
        if myHum then
            pcall(function() myHum.Sit = false end)
        end
        if myHrp and root and root.Parent then
            myHrp.CFrame = root.CFrame * CFrame.new(-3.5, 1.2, 0.4)
            myHrp.AssemblyLinearVelocity = Vector3.zero
        end
        if myChar then
            for _, motor in ipairs(myChar:GetDescendants()) do
                if motor:IsA("Motor6D") then
                    pcall(function() motor.Transform = CFrame.new() end)
                end
            end
        end
        statusLbl.Text = "Tap or [E] to Ride!"
        statusLbl.TextColor3 = Color3.fromRGB(190, 230, 255)
        updateFloatingControls()
    end

    -- 16. Floating Mobile Screen Button: "🏇 RIDE TUX"
    rideActionBtn = Instance.new("TextButton")
    rideActionBtn.Name = "TuxRideActionBtn"
    rideActionBtn.Size = UDim2.new(0, 115, 0, 46)
    rideActionBtn.Position = UDim2.new(0.82, -58, 0.72, 0)
    rideActionBtn.BackgroundColor3 = Color3.fromRGB(30, 180, 80)
    rideActionBtn.Text = "🏇 RIDE TUX"
    rideActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    rideActionBtn.Font = Enum.Font.GothamBold
    rideActionBtn.TextSize = 13
    rideActionBtn.ZIndex = 150
    rideActionBtn.Parent = ScreenGui

    local actCorner = Instance.new("UICorner")
    actCorner.CornerRadius = UDim.new(0, 12)
    actCorner.Parent = rideActionBtn

    local actStroke = Instance.new("UIStroke")
    actStroke.Color = Color3.fromRGB(255, 255, 255)
    actStroke.Thickness = 1.5
    actStroke.Parent = rideActionBtn

    table.insert(rideClickConns, rideActionBtn.MouseButton1Click:Connect(function()
        if isRiderMounted then
            dismountPlayer()
        else
            mountPlayer()
        end
    end))

    -- 16b. Mobile Forward Pedal Button: "▲ RUN"
    rideSprintBtn = Instance.new("TextButton")
    rideSprintBtn.Name = "TuxRideSprintBtn"
    rideSprintBtn.Size = UDim2.new(0, 95, 0, 42)
    rideSprintBtn.Position = UDim2.new(0.82, -48, 0.63, 0)
    rideSprintBtn.BackgroundColor3 = Color3.fromRGB(20, 140, 220)
    rideSprintBtn.Text = "▲ RUN"
    rideSprintBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    rideSprintBtn.Font = Enum.Font.GothamBold
    rideSprintBtn.TextSize = 13
    rideSprintBtn.ZIndex = 150
    rideSprintBtn.Visible = false
    rideSprintBtn.Parent = ScreenGui

    local spCorner = Instance.new("UICorner")
    spCorner.CornerRadius = UDim.new(0, 10)
    spCorner.Parent = rideSprintBtn

    local spStroke = Instance.new("UIStroke")
    spStroke.Color = Color3.fromRGB(255, 255, 255)
    spStroke.Thickness = 1.2
    spStroke.Parent = rideSprintBtn

    table.insert(rideClickConns, rideSprintBtn.MouseButton1Down:Connect(function()
        mobileSprintHeld = true
    end))
    table.insert(rideClickConns, rideSprintBtn.MouseButton1Up:Connect(function()
        mobileSprintHeld = false
    end))

    -- 16c. Mobile Belly-Slide Turbo Button: "⚡ SLIDE"
    rideTurboBtn = Instance.new("TextButton")
    rideTurboBtn.Name = "TuxRideTurboBtn"
    rideTurboBtn.Size = UDim2.new(0, 95, 0, 42)
    rideTurboBtn.Position = UDim2.new(0.82, -48, 0.54, 0)
    rideTurboBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 220)
    rideTurboBtn.Text = "⚡ SLIDE"
    rideTurboBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    rideTurboBtn.Font = Enum.Font.GothamBold
    rideTurboBtn.TextSize = 13
    rideTurboBtn.ZIndex = 150
    rideTurboBtn.Visible = false
    rideTurboBtn.Parent = ScreenGui

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 10)
    tbCorner.Parent = rideTurboBtn

    local tbStroke = Instance.new("UIStroke")
    tbStroke.Color = Color3.fromRGB(255, 255, 255)
    tbStroke.Thickness = 1.2
    tbStroke.Parent = rideTurboBtn

    table.insert(rideClickConns, rideTurboBtn.MouseButton1Click:Connect(function()
        mobileTurboActive = not mobileTurboActive
        if mobileTurboActive then
            rideTurboBtn.BackgroundColor3 = Color3.fromRGB(240, 120, 20)
            rideTurboBtn.Text = "⚡ SLIDING!"
        else
            rideTurboBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 220)
            rideTurboBtn.Text = "⚡ SLIDE"
        end
    end))

    -- 17. ClickDetectors on ALL major parts (Body, Saddle, Head)
    local clickBody = Instance.new("ClickDetector")
    clickBody.MaxActivationDistance = 30
    clickBody.Parent = bodyPart

    local clickSaddle = Instance.new("ClickDetector")
    clickSaddle.MaxActivationDistance = 30
    clickSaddle.Parent = saddleBase

    local clickHead = Instance.new("ClickDetector")
    clickHead.MaxActivationDistance = 30
    clickHead.Parent = headPart

    local function onToggleMount()
        if isRiderMounted then dismountPlayer() else mountPlayer() end
    end
    table.insert(rideClickConns, clickBody.MouseClick:Connect(onToggleMount))
    table.insert(rideClickConns, clickSaddle.MouseClick:Connect(onToggleMount))
    table.insert(rideClickConns, clickHead.MouseClick:Connect(onToggleMount))

    -- 18. ProximityPrompt for [E] / Tap
    local mountPrompt = Instance.new("ProximityPrompt")
    mountPrompt.Name = "MountPrompt"
    mountPrompt.ObjectText = "👑 Emperor Tux"
    mountPrompt.ActionText = "Ride / Tap"
    mountPrompt.HoldDuration = 0
    mountPrompt.MaxActivationDistance = 20
    mountPrompt.RequiresLineOfSight = false
    mountPrompt.Parent = bodyPart
    table.insert(rideClickConns, mountPrompt.Triggered:Connect(onToggleMount))

    -- 19. Auto-Mount on Walk-Into
    table.insert(rideClickConns, bodyPart.Touched:Connect(function(hit)
        local myChar = LocalPlayer.Character
        if hit and myChar and hit:IsDescendantOf(myChar) and not isRiderMounted then
            local myHrp = myChar:FindFirstChild("HumanoidRootPart")
            if myHrp and (myHrp.Position - root.Position).Magnitude < 4.0 then
                mountPlayer()
            end
        end
    end))

    -- Dismount Hook via Space Key
    table.insert(rideClickConns, UserInputService.InputBegan:Connect(function(input, gpe)
        if isRiderMounted and input.KeyCode == Enum.KeyCode.Space and not gpe then
            dismountPlayer()
        end
    end))

    -- Ground Raycasting System
    local rayParams = RaycastParams.new()
    rayParams.FilterType = RaycastFilterType.Exclude
    rayParams.IgnoreWater = true

    local function getGroundData(targetXZ, currentY, activeChar)
        rayParams.FilterDescendantsInstances = {activeChar or char, rideModel}
        local rayOrigin = Vector3.new(targetXZ.X, currentY + 5.0, targetXZ.Z)
        local rayDir = Vector3.new(0, -26.0, 0)
        local hit = Workspace:Raycast(rayOrigin, rayDir, rayParams)
        if hit and hit.Position and typeof(hit.Position) == "Vector3" then
            return hit.Position.Y + 2.0, hit.Normal
        else
            return currentY, Vector3.new(0, 1, 0)
        end
    end

    -- Direct 100% Reliable CFrame Transform Setter for Emperor Mount
    local function applyEmperorPose(rootCF, headAnim, lWingRot, rWingRot, lFootOffset, rFootOffset)
        root.CFrame = rootCF

        -- 1. Torso & Tuxedo Belly
        bodyPart.CFrame = rootCF * CFrame.new(0, 0, 0.2)
        bellyPart.CFrame = rootCF * CFrame.new(0, -0.3, -1.35)
        chestGoldPart.CFrame = rootCF * CFrame.new(0, 1.1, -1.4)

        -- 2. Neck & Auricular Patches
        neckPart.CFrame = rootCF * CFrame.new(0, 1.8, -1.5)
        neckGoldLeft.CFrame = rootCF * (CFrame.new(-0.85, 2.2, -1.9) * CFrame.Angles(0, math.rad(25), math.rad(20)))
        neckGoldRight.CFrame = rootCF * (CFrame.new(0.85, 2.2, -1.9) * CFrame.Angles(0, math.rad(-25), math.rad(-20)))

        -- 3. Head (Clear forward placement at Z = -2.2, Y = 2.5)
        local headCF = rootCF * (CFrame.new(0, 2.5, -2.2) * (headAnim or CFrame.new()))
        headPart.CFrame = headCF

        -- 4. Golden Crown 👑 with 3 Spikes
        crownBase.CFrame = headCF * (CFrame.new(0, 1.05, 0) * CFrame.Angles(0, 0, math.rad(90)))
        crownSpike1.CFrame = headCF * (CFrame.new(0, 1.35, -0.35) * CFrame.Angles(math.rad(15), 0, 0))
        crownSpike2.CFrame = headCF * (CFrame.new(-0.35, 1.3, 0) * CFrame.Angles(0, 0, math.rad(15)))
        crownSpike3.CFrame = headCF * (CFrame.new(0.35, 1.3, 0) * CFrame.Angles(0, 0, math.rad(-15)))

        -- 5. Beak & Mandibular Stripe
        beakPart.CFrame = headCF * (CFrame.new(0, -0.15, -1.4) * CFrame.Angles(math.rad(8), 0, 0))
        beakStripePart.CFrame = headCF * CFrame.new(0, -0.22, -1.25)

        -- 6. Eyes
        leftEyeWhite.CFrame = headCF * CFrame.new(-0.75, 0.25, -0.5)
        leftEyePupil.CFrame = headCF * CFrame.new(-0.77, 0.25, -0.58)
        rightEyeWhite.CFrame = headCF * CFrame.new(0.75, 0.25, -0.5)
        rightEyePupil.CFrame = headCF * CFrame.new(0.77, 0.25, -0.58)

        -- 7. Flippers with White Inner Feathering
        local lBase = CFrame.new(-1.65, 0.4, -0.3) * CFrame.Angles(math.rad(15), 0, math.rad(-22))
        local rBase = CFrame.new(1.65, 0.4, -0.3) * CFrame.Angles(math.rad(15), 0, math.rad(22))
        local curLWing = rootCF * (lBase * (lWingRot or CFrame.new()))
        local curRWing = rootCF * (rBase * (rWingRot or CFrame.new()))
        leftFlipper.CFrame = curLWing
        leftFlipperInner.CFrame = curLWing * CFrame.new(0.15, 0, 0)
        rightFlipper.CFrame = curRWing
        rightFlipperInner.CFrame = curRWing * CFrame.new(-0.15, 0, 0)

        -- 8. Webbed Orange Feet
        local lfBase = CFrame.new(-0.85, -1.8, 0.0)
        local rfBase = CFrame.new(0.85, -1.8, 0.0)
        leftFoot.CFrame = rootCF * (lfBase * (lFootOffset or CFrame.new()))
        rightFoot.CFrame = rootCF * (rfBase * (rFootOffset or CFrame.new()))

        -- 9. Rudder Tail (Behind Saddle at Z = +2.2)
        tailPart.CFrame = rootCF * (CFrame.new(0, -0.5, 2.2) * CFrame.Angles(math.rad(-30), 0, 0))

        -- 10. Saddle, Cantle, Pommel, Stirrups, Reins (At Z = 0.4, Y = 1.65)
        saddleBase.CFrame = rootCF * CFrame.new(0, 1.65, 0.4)
        saddleCantle.CFrame = rootCF * (CFrame.new(0, 2.05, 1.45) * CFrame.Angles(math.rad(15), 0, 0))
        saddlePummel.CFrame = rootCF * (CFrame.new(0, 1.95, -0.65) * CFrame.Angles(math.rad(-15), 0, 0))
        leftStirrup.CFrame = rootCF * CFrame.new(-1.35, 0.9, 0.4)
        rightStirrup.CFrame = rootCF * CFrame.new(1.35, 0.9, 0.4)
        reinLeft.CFrame = rootCF * (CFrame.new(-0.45, 1.9, -1.1) * CFrame.Angles(math.rad(16), math.rad(-8), 0))
        reinRight.CFrame = rootCF * (CFrame.new(0.45, 1.9, -1.1) * CFrame.Angles(math.rad(16), math.rad(8), 0))

        if rideSeat then
            rideSeat.CFrame = rootCF * CFrame.new(0, 1.9, 0.4)
        end
    end

    -- Dynamic Procedural Kinematics for Rider
    local function updateRiderPosture(steerVal, isSliding)
        local myChar = LocalPlayer.Character
        if not myChar then return end

        local rShoulder = myChar:FindFirstChild("RightShoulder", true) or myChar:FindFirstChild("Right Shoulder", true)
        local lShoulder = myChar:FindFirstChild("LeftShoulder", true) or myChar:FindFirstChild("Left Shoulder", true)
        local waist = myChar:FindFirstChild("Waist", true) or myChar:FindFirstChild("RootJoint", true)

        local reinArmRotR = CFrame.Angles(math.rad(62), math.rad(-16), math.rad(-8))
        local reinArmRotL = CFrame.Angles(math.rad(62), math.rad(16), math.rad(8))

        if isSliding then
            reinArmRotR = CFrame.Angles(math.rad(45), math.rad(-12), 0)
            reinArmRotL = CFrame.Angles(math.rad(45), math.rad(12), 0)
            if waist and waist:IsA("Motor6D") then
                pcall(function()
                    waist.Transform = CFrame.Angles(math.rad(38), 0, math.rad(-steerVal * 16))
                end)
            end
        else
            if waist and waist:IsA("Motor6D") then
                pcall(function()
                    waist.Transform = CFrame.Angles(math.rad(6), 0, math.rad(-steerVal * 14))
                end)
            end
        end

        if rShoulder and rShoulder:IsA("Motor6D") then
            pcall(function() rShoulder.Transform = reinArmRotR end)
        end
        if lShoulder and lShoulder:IsA("Motor6D") then
            pcall(function() lShoulder.Transform = reinArmRotL end)
        end
    end

    -- Physics & Animation Control Loop
    local currentRidePos = root.Position
    local _, initYaw, _ = playerHrp.CFrame:ToOrientation()
    local currentRideYaw = initYaw
    local currentSpeed = 0
    local walkClock = 0
    local idleClock = 0
    local lastTick = tick()

    -- Initial Frame 1 Pose Setter (Immediately renders Emperor Tux without 1-frame delay)
    applyEmperorPose(root.CFrame, CFrame.new(), CFrame.new(), CFrame.new(), CFrame.new(), CFrame.new())

    rideLoopConn = registerConn(RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = math.clamp(now - lastTick, 0, 0.1)
        lastTick = now

        if not State.TuxRide then
            cleanupTuxRide()
            return
        end

        -- Frame Guardian: If model was purged by any game script, respawn instantly
        if not rideModel or not rideModel.Parent or not rideModel:IsDescendantOf(Workspace) then
            spawnEmperorTuxRide()
            return
        end

        local currentChar = LocalPlayer.Character
        if not currentChar then return end
        local hrp = currentChar:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = currentChar:FindFirstChildOfClass("Humanoid")

        if isRiderMounted then
            -- Read user inputs across ALL sources: Mobile Touch Joystick, VehicleSeat, Keyboard & Mobile Buttons
            local throttle = 0
            local steer = 0

            -- 1. Mobile Virtual Thumbstick via PlayerModule ControlModule
            pcall(function()
                local PlayerModule = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
                if PlayerModule then
                    local controls = require(PlayerModule):GetControls()
                    if controls and controls.GetMoveVector then
                        local mv = controls:GetMoveVector()
                        if mv.Magnitude > 0.05 then
                            if mv.Z < -0.1 then throttle = 1 elseif mv.Z > 0.1 then throttle = -1 end
                            if mv.X < -0.1 then steer = -1 elseif mv.X > 0.1 then steer = 1 end
                        end
                    end
                end
            end)

            -- 2. VehicleSeat inputs
            if rideSeat and rideSeat:IsA("VehicleSeat") then
                if rideSeat.ThrottleFloat ~= 0 then throttle = rideSeat.ThrottleFloat
                elseif rideSeat.Throttle ~= 0 then throttle = rideSeat.Throttle end
                if rideSeat.SteerFloat ~= 0 then steer = rideSeat.SteerFloat
                elseif rideSeat.Steer ~= 0 then steer = rideSeat.Steer end
            end

            -- 3. Humanoid MoveDirection fallback
            if hum and hum.MoveDirection.Magnitude > 0.08 and throttle == 0 and steer == 0 then
                local tuxForward = Vector3.new(-math.sin(currentRideYaw), 0, -math.cos(currentRideYaw))
                local tuxRight = Vector3.new(math.cos(currentRideYaw), 0, -math.sin(currentRideYaw))
                local dotForward = hum.MoveDirection:Dot(tuxForward)
                local dotRight = hum.MoveDirection:Dot(tuxRight)

                if dotForward > 0.15 then throttle = 1 elseif dotForward < -0.15 then throttle = -1 end
                if dotRight > 0.15 then steer = 1 elseif dotRight < -0.15 then steer = -1 end
            end

            -- 4. Keyboard WASD / Arrows
            if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then throttle = 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then throttle = -1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then steer = -1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then steer = 1 end

            -- 5. Mobile On-Screen Buttons
            if mobileSprintHeld then throttle = 1 end

            local shiftHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) or mobileTurboActive
            local baseSpeed = State.RideSpeed or 70
            local isSliding = (math.abs(currentSpeed) > 42) or (shiftHeld and math.abs(currentSpeed) > 16)
            local targetSpeed = 0

            if throttle > 0.1 then
                targetSpeed = shiftHeld and (baseSpeed * 1.35) or baseSpeed
            elseif throttle < -0.1 then
                targetSpeed = -18
            else
                targetSpeed = 0
            end

            -- Smooth acceleration / deceleration
            currentSpeed = currentSpeed + (targetSpeed - currentSpeed) * math.clamp(dt * 6.5, 0, 1)

            -- Camera-Following Steering for Mobile: when moving forward without hard sideways steer, smoothly face camera view!
            local cam = Workspace.CurrentCamera
            if cam and (throttle > 0.1 or math.abs(currentSpeed) > 3) and math.abs(steer) < 0.25 then
                local camLook = cam.CFrame.LookVector
                local camYaw = math.atan2(-camLook.X, -camLook.Z)
                local diff = (camYaw - currentRideYaw + math.pi) % (2 * math.pi) - math.pi
                currentRideYaw = currentRideYaw + diff * math.clamp(dt * 5.5, 0, 1)
            end

            -- Manual Steering response (joystick or A/D keys)
            local turnSpeed = (isSliding and 2.4 or 3.2) * math.clamp(math.abs(currentSpeed) / 20, 0.4, 1.2)
            currentRideYaw = currentRideYaw - (steer * turnSpeed * dt)

            -- Movement translation vector
            local forwardVec = Vector3.new(-math.sin(currentRideYaw), 0, -math.cos(currentRideYaw))
            currentRidePos = currentRidePos + (forwardVec * (currentSpeed * dt))

            -- Ground raycast & slope alignment
            local targetGroundY, groundNormal = getGroundData(currentRidePos, currentRidePos.Y, currentChar)
            currentRidePos = Vector3.new(currentRidePos.X, currentRidePos.Y + (targetGroundY - currentRidePos.Y) * math.clamp(dt * 12, 0, 1), currentRidePos.Z)

            local pitch = math.asin(math.clamp(groundNormal.Z * math.cos(currentRideYaw) - groundNormal.X * math.sin(currentRideYaw), -0.85, 0.85))
            local roll = math.asin(math.clamp(groundNormal.X * math.cos(currentRideYaw) + groundNormal.Z * math.sin(currentRideYaw), -0.85, 0.85))
            local slopeRot = CFrame.Angles(pitch, 0, roll)
            local bankRoll = math.rad(-steer * (isSliding and 18 or 12))

            -- Animation Phase
            if isSliding and math.abs(currentSpeed) > 15 then
                slideEmitter.Enabled = true
                statusLbl.Text = "❄️ Belly-Sliding Turbo! ⚡"
                statusLbl.TextColor3 = Color3.fromRGB(140, 230, 255)

                local slideTilt = CFrame.Angles(math.rad(74), 0, 0)
                local slideLower = Vector3.new(0, -1.05, 0)
                local rootCF = CFrame.new(currentRidePos + slideLower) * CFrame.Angles(0, currentRideYaw, 0) * slopeRot * CFrame.Angles(0, 0, bankRoll) * slideTilt

                applyEmperorPose(rootCF,
                    CFrame.Angles(math.rad(-44), 0, 0),
                    CFrame.Angles(math.rad(-38), 0, math.rad(-26)),
                    CFrame.Angles(math.rad(-38), 0, math.rad(26)),
                    CFrame.Angles(math.rad(65), 0, 0),
                    CFrame.Angles(math.rad(65), 0, 0)
                )
                updateRiderPosture(steer, true)

            elseif math.abs(currentSpeed) > 1.2 then
                slideEmitter.Enabled = false
                walkClock = walkClock + dt * math.clamp(math.abs(currentSpeed) * 0.22, 5, 14)
                statusLbl.Text = "🐾 Trotting • Speed: " .. tostring(math.floor(math.abs(currentSpeed)))
                statusLbl.TextColor3 = Color3.fromRGB(180, 245, 180)

                local waddleRoll = CFrame.Angles(0, 0, math.sin(walkClock) * math.rad(11))
                local waddleBob = Vector3.new(0, math.abs(math.sin(walkClock)) * 0.22, 0)
                local rootCF = CFrame.new(currentRidePos + waddleBob) * CFrame.Angles(0, currentRideYaw, 0) * slopeRot * CFrame.Angles(0, 0, bankRoll) * waddleRoll

                local footStep = math.sin(walkClock) * math.rad(26)
                local lFoot = CFrame.Angles(footStep, 0, 0) * CFrame.new(0, math.max(0, -math.sin(walkClock) * 0.16), 0)
                local rFoot = CFrame.Angles(-footStep, 0, 0) * CFrame.new(0, math.max(0, math.sin(walkClock) * 0.16), 0)

                local wingFlap = math.sin(walkClock) * math.rad(24)
                local lWing = CFrame.Angles(0, 0, wingFlap)
                local rWing = CFrame.Angles(0, 0, -wingFlap)
                local headRoll = CFrame.Angles(0, 0, -math.sin(walkClock) * math.rad(6))

                applyEmperorPose(rootCF, headRoll, lWing, rWing, lFoot, rFoot)
                updateRiderPosture(steer, false)

            else
                slideEmitter.Enabled = false
                idleClock = idleClock + dt
                statusLbl.Text = "🐾 Mounted • Ready to Ride!"
                statusLbl.TextColor3 = Color3.fromRGB(255, 235, 170)

                local idleBreath = math.sin(idleClock * 2.2) * 0.04
                local headLook = CFrame.Angles(math.rad(-4), math.sin(idleClock * 1.4) * math.rad(8), 0)
                local rootCF = CFrame.new(currentRidePos + Vector3.new(0, idleBreath, 0)) * CFrame.Angles(0, currentRideYaw, 0) * slopeRot

                applyEmperorPose(rootCF, headLook, CFrame.new(), CFrame.new(), CFrame.new(), CFrame.new())
                updateRiderPosture(0, false)
            end

            -- Ensure rider stays firmly seated on saddle without clipping or falling off
            if hrp and hum then
                hum.Sit = true
                hrp.CFrame = root.CFrame * CFrame.new(0, 1.95, 0.4)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        else
            -- Unmounted: Emperor Tux rests nearby
            slideEmitter.Enabled = false
            idleClock = idleClock + dt

            local targetGroundY, groundNormal = getGroundData(currentRidePos, currentRidePos.Y, currentChar)
            currentRidePos = Vector3.new(currentRidePos.X, currentRidePos.Y + (targetGroundY - currentRidePos.Y) * math.clamp(dt * 10, 0, 1), currentRidePos.Z)

            local distToPlayer = (currentRidePos - hrp.Position).Magnitude
            if distToPlayer > 80 then
                -- Snap closer if player walked far away
                currentRidePos = hrp.Position + (-hrp.CFrame.LookVector * 4 + hrp.CFrame.RightVector * 3.5)
                local _, pYaw, _ = hrp.CFrame:ToOrientation()
                currentRideYaw = pYaw
            end

            local idleBreath = math.sin(idleClock * 2.0) * 0.03
            local headLook = CFrame.Angles(math.rad(-3), math.sin(idleClock * 1.2) * math.rad(10), 0)
            local rootCF = CFrame.new(currentRidePos + Vector3.new(0, idleBreath, 0)) * CFrame.Angles(0, currentRideYaw, 0)

            applyEmperorPose(rootCF, headLook, CFrame.new(), CFrame.new(), CFrame.new(), CFrame.new())
        end
    end))
end


-- Automatic respawn support so Emperor Tux never disappears on player death
if not rideCharAddedConn then
    rideCharAddedConn = registerConn(LocalPlayer.CharacterAdded:Connect(function(newChar)
        pcall(function() newChar:WaitForChild("HumanoidRootPart", 5) end)
        task.wait(0.4)
        if State.TuxRide then
            spawnEmperorTuxRide()
        end
    end))
end

addModuleToggle(funScroll, "Tux Ride 👑", false, function(enabled)
    State.TuxRide = enabled
    if enabled then
        spawnEmperorTuxRide()
        notify("Tux Ride 👑", "Emperor Tux spawned! Press [E] or click saddle to ride! 🐧", 3.5)
    else
        cleanupTuxRide()
    end
end, 1)

addModuleSlider(funScroll, "Ride Speed", 30, 150, 70, function(val)
    State.RideSpeed = val
end, 2)

-- Gravity Modifier
addModuleSlider(funScroll, "Gravity", 0, 196, 196, function(val)
    Workspace.Gravity = val
end, 4)

-- Chat Spammer
local spamConn
addModuleToggle(funScroll, "Tux Chat Spammer 💬", false, function(enabled)
    State.ChatSpam = enabled
    if enabled then
        spamConn = task.spawn(function()
            while State.ChatSpam do
                pcall(function()
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Tux Script 🐧 | Best Roblox Cheat Engine!", "All")
                end)
                task.wait(4)
            end
        end)
    end
end, 5)

-- ==================== VISUALS CATEGORY ====================

-- Highlight ESP
local espHighlights = {}
local function applyESP(player)
    if player == LocalPlayer then return end
    local function highlightChar(char)
        if not char then return end
        if not espHighlights[player] then
            local hl = Instance.new("Highlight")
            hl.Name = "TuxESP"
            hl.FillColor = currentTheme.Accent
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.4
            hl.Enabled = State.ESP
            hl.Parent = char
            espHighlights[player] = hl
            registerInst(hl)
        else
            espHighlights[player].Parent = char
            espHighlights[player].Enabled = State.ESP
        end
    end
    if player.Character then highlightChar(player.Character) end
    registerConn(player.CharacterAdded:Connect(highlightChar))
end

for _, plr in pairs(Players:GetPlayers()) do applyESP(plr) end
registerConn(Players.PlayerAdded:Connect(applyESP))

addModuleToggle(visualsScroll, "Highlight ESP 👁️", false, function(enabled)
    State.ESP = enabled
    for _, hl in pairs(espHighlights) do
        if hl then hl.Enabled = enabled end
    end
end)

-- Tracers ESP
local tracerLines = {}
addModuleToggle(visualsScroll, "Tracers 🎯", false, function(enabled)
    State.Tracers = enabled
end)

registerConn(RunService.RenderStepped:Connect(function()
    if State.Tracers then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                if onScreen then
                    local line = tracerLines[player]
                    if not line then
                        line = Drawing.new("Line")
                        line.Thickness = 1.5
                        line.Color = currentTheme.Accent
                        line.Transparency = 0.8
                        tracerLines[player] = line
                    end
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(screenPos.X, screenPos.Y)
                    line.Visible = true
                else
                    if tracerLines[player] then tracerLines[player].Visible = false end
                end
            else
                if tracerLines[player] then tracerLines[player].Visible = false end
            end
        end
    else
        for _, line in pairs(tracerLines) do
            line.Visible = false
        end
    end
end))

-- Fullbright
addModuleToggle(visualsScroll, "Fullbright ☀️", false, function(enabled)
    State.Fullbright = enabled
    if enabled then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        Lighting.Ambient = OriginalLighting.Ambient
    end
end)

-- ==================== DESIGN & CONTROL CATEGORY ====================

-- Theme Switches
local themeList = {"DarkTux", "NeonPurple", "CyberCyan", "Midnight"}
for _, themeName in ipairs(themeList) do
    addModuleToggle(designScroll, "Theme: " .. themeName, (State.Theme == themeName), function()
        State.Theme = themeName
        currentTheme = Themes[themeName]
        HeaderBar.BackgroundColor3 = currentTheme.Header
        HeaderStroke.Color = currentTheme.Accent
        HeaderTitle.TextColor3 = currentTheme.Accent
        LoaderStroke.Color = currentTheme.Accent
        ProgressBarFill.BackgroundColor3 = currentTheme.Accent
        PunchBtn.BackgroundColor3 = currentTheme.Accent
        ColumnsFrame.ScrollBarImageColor3 = currentTheme.Accent
        
        for _, col in pairs(ColumnsFrame:GetChildren()) do
            if col:IsA("Frame") then
                col.BackgroundColor3 = currentTheme.Card
                local cHead = col:FindFirstChildOfClass("TextLabel")
                if cHead then
                    cHead.BackgroundColor3 = currentTheme.Header
                    cHead.TextColor3 = currentTheme.Accent
                end
            end
        end
    end)
end

-- Full Unload Script (Destroys Everything Cleanly)
addModuleToggle(designScroll, "UNLOAD SCRIPT ❌", false, function()
    print("Unloading Tux Script 🐧...")
    
    for _, conn in ipairs(Connections) do
        pcall(function() conn:Disconnect() end)
    end
    
    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.ClockTime = OriginalLighting.ClockTime
    Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    Lighting.Ambient = OriginalLighting.Ambient

    for _, line in pairs(tracerLines) do
        pcall(function() line:Remove() end)
    end

    for _, inst in ipairs(InstancesToClean) do
        pcall(function() inst:Destroy() end)
    end

    ScreenGui:Destroy()
    print("Tux Script 🐧 cleanly unloaded!")
end)

---------------------------------------------------------
-- WINDOW CONTROLS & KEYBIND TOGGLE (RAlt / Mobile Toggle)
---------------------------------------------------------

-- Minimize Button
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    ColumnsFrame.Visible = not isMinimized
    MainContainer.Size = isMinimized and UDim2.new(0.92, 0, 0, 42) or UDim2.new(0.92, 0, 0.85, 0)
end)

-- Close Button (Unloads Script Completely)
CloseBtn.MouseButton1Click:Connect(function()
    for _, conn in ipairs(Connections) do pcall(function() conn:Disconnect() end) end
    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.ClockTime = OriginalLighting.ClockTime
    Lighting.GlobalShadows = OriginalLighting.GlobalShadows
    Lighting.Ambient = OriginalLighting.Ambient
    for _, line in pairs(tracerLines) do pcall(function() line:Remove() end) end
    ScreenGui:Destroy()
    print("Tux Script 🐧 cleanly unloaded via Close Button!")
end)

-- RAlt Keybind Toggle & Mobile Floating Toggle
registerConn(UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightAlt then
        State.GuiVisible = not State.GuiVisible
        MainContainer.Visible = State.GuiVisible
    end
end))

-- Floating Mobile GUI Toggle Button (For iOS/Android users without RAlt key)
local MobileToggleGui = Instance.new("ScreenGui")
MobileToggleGui.Name = "TuxMobileToggle"
MobileToggleGui.ResetOnSpawn = false
MobileToggleGui.Parent = guiParent
registerInst(MobileToggleGui)

local MobileBtn = Instance.new("TextButton")
MobileBtn.Size = UDim2.new(0, 48, 0, 48)
MobileBtn.Position = UDim2.new(0, 12, 0.35, 0)
MobileBtn.BackgroundColor3 = currentTheme.Header
MobileBtn.Text = "🐧"
MobileBtn.TextSize = 22
MobileBtn.Parent = MobileToggleGui

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(1, 0)
mCorner.Parent = MobileBtn

local mStroke = Instance.new("UIStroke")
mStroke.Color = currentTheme.Accent
mStroke.Thickness = 2
mStroke.Parent = MobileBtn

-- Make Mobile Toggle Button Draggable
local mDrag, mInput, mStart, mPos
MobileBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mDrag = true
        mStart = input.Position
        mPos = MobileBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then mDrag = false end
        end)
    end
end)

MobileBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mInput = input
    end
end)

registerConn(UserInputService.InputChanged:Connect(function(input)
    if input == mInput and mDrag then
        local delta = input.Position - mStart
        MobileBtn.Position = UDim2.new(mPos.X.Scale, mPos.X.Offset + delta.X, mPos.Y.Scale, mPos.Y.Offset + delta.Y)
    end
end))

MobileBtn.MouseButton1Click:Connect(function()
    State.GuiVisible = not State.GuiVisible
    MainContainer.Visible = State.GuiVisible
end)

-- Post-init refresh pass for all category columns to guarantee full scrollability
task.spawn(function()
    for _, t in ipairs({0.1, 0.4, 1.0, 2.0}) do
        task.wait(t)
        for _, scroll in pairs(categoryColumns) do
            pcall(function() refreshScroll(scroll) end)
        end
        pcall(function() refreshColumnsFrame() end)
    end
end)

print("Tux Script 🐧 Mobile & PC Minecraft GUI initialized successfully!")
