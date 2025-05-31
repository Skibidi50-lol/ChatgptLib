-- Fancy UI Library with toggle & slider support

local UserInputService = game:GetService("UserInputService")

local UI = {}

-- Helper to create UICorner
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

-- Helper to add hover effect on buttons/toggles
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = button.BackgroundColor3:Lerp(Color3.fromRGB(100, 180, 140), 0.3)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = button._defaultColor or button.BackgroundColor3
    end)
end

-- Draggable function for GUI frames
local function makeDraggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

function UI.new(title)
    local self = {}

    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FancyUILibrary"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui") -- For testing; change to PlayerGui in actual game

    -- Main window frame
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 450, 0, 500)
    window.Position = UDim2.new(0.5, -225, 0.5, -250)
    window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    window.BorderSizePixel = 0
    window.Parent = screenGui
    createUICorner(window, 8)

    -- Draggable top bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 35)
    topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    topBar.BorderSizePixel = 0
    topBar.Parent = window
    createUICorner(topBar, 8)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Fancy UI"
    titleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    makeDraggable(topBar)

    -- Content holder (scrolling frame)
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, -35)
    content.Position = UDim2.new(0, 0, 0, 35)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 6
    content.Parent = window

    -- UIListLayout inside content for vertical stacking
    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 12)

    -- Section creator
    function self:addSection(name)
        local section = {}

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 30)
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        frame.BorderSizePixel = 0
        frame.Parent = content
        frame.ClipsDescendants = true
        createUICorner(frame, 6)

        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Size = UDim2.new(1, 0, 0, 30)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Text = name or "Section"
        sectionTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.TextSize = 16
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = frame

        local contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1, 0, 0, 0)
        contentFrame.Position = UDim2.new(0, 0, 0, 30)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = frame
        createUICorner(contentFrame)

        local yPos = 0

        -- Helpers to create UI elements
        local function addLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 0, 25)
            lbl.Position = UDim2.new(0, 10, 0, yPos)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = contentFrame

            yPos = yPos + 30
            contentFrame.Size = UDim2.new(1, 0, 0, yPos)
            frame.Size = UDim2.new(1, -20, 0, 30 + yPos)
        end

        local function addButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Position = UDim2.new(0, 10, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(75, 160, 115)
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(240, 240, 240)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 15
            btn.Parent = contentFrame
            createUICorner(btn, 6)

            btn._defaultColor = btn.BackgroundColor3
            addHoverEffect(btn)

            btn.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)

            yPos = yPos + 40
            contentFrame.Size = UDim2.new(1, 0, 0, yPos)
            frame.Size = UDim2.new(1, -20, 0, 30 + yPos)
        end

        local function addToggle(text, defaultValue, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -10, 0, 30)
            toggleFrame.Position = UDim2.new(0, 10, 0, yPos)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = contentFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 1, 0)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(180, 180, 180)
            label.Font = Enum.Font.Gotham
            label.TextSize = 15
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = toggleFrame

            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 40, 0, 20)
            toggleBtn.Position = UDim2.new(1, -45, 0, 5)
            toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(75, 160, 115) or Color3.fromRGB(80, 80, 80)
            toggleBtn.BorderSizePixel = 0
            toggleBtn.Text = ""
            toggleBtn.Parent = toggleFrame
            createUICorner(toggleBtn, 6)

            toggleBtn._defaultColor = toggleBtn.BackgroundColor3
            addHoverEffect(toggleBtn)

            local toggled = defaultValue or false

            local function updateToggle()
                toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(75, 160, 115) or Color3.fromRGB(80, 80, 80)
            end
            updateToggle()

            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
                if callback then callback(toggled) end
            end)

            yPos = yPos + 35
            contentFrame.Size = UDim2.new(1, 0, 0, yPos)
            frame.Size = UDim2.new(1, -20, 0, 30 + yPos)
        end

        local function addSlider(text, min, max, defaultValue, step, callback)
            step = step or 1
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -10, 0, 50)
            sliderFrame.Position = UDim2.new(0, 10, 0, yPos)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = contentFrame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text .. ": " .. tostring(defaultValue)
            label.TextColor3 = Color3.fromRGB(180, 180, 180)
            label.Font = Enum.Font.Gotham
            label.TextSize = 15
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame

            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, -20, 0, 10)
            sliderBar.Position = UDim2.new(0, 10, 0, 30)
            sliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            sliderBar.BorderSizePixel = 0
            sliderBar.Parent = sliderFrame
            createUICorner(sliderBar, 6)

            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(75, 160, 115)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBar
            createUICorner(sliderFill, 6)

            local sliderHandle = Instance.new("Frame")
            sliderHandle.Size = UDim2.new(0, 18, 0, 18)
            sliderHandle.Position = UDim2.new(0, 0, 0.5, -9)
            sliderHandle.BackgroundColor3 = Color3.fromRGB(60, 140, 100)
            sliderHandle.BorderSizePixel = 0
            sliderHandle.Parent = sliderBar
            createUICorner(sliderHandle, 9)

            local dragging = false
            local function updateSlider(inputPosX)
                local relativeX = math.clamp(inputPosX - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
                local scale = relativeX / sliderBar.AbsoluteSize.X
                local valueRange = max - min
                local steppedValue = math.floor((min + scale * valueRange) / step + 0.5) * step
                steppedValue = math.clamp(steppedValue, min, max)

                local fillScale = (steppedValue - min) / valueRange
                sliderFill.Size = UDim2.new(fillScale, 0, 1, 0)
                sliderHandle.Position = UDim2.new(fillScale, -9, 0.5, -9)

                label.Text = string.format("%s: %.2f", text, steppedValue)
                if callback then callback(steppedValue) end
            end

            sliderHandle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input.Position.X)
                end
            end)

            -- Wait for AbsolutePosition and AbsoluteSize to be valid before initial update
            sliderBar:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                if sliderBar.AbsolutePosition.X ~= 0 then
                    updateSlider(sliderBar.AbsolutePosition.X + (defaultValue - min) / (max - min) * sliderBar.AbsoluteSize.X)
                end
            end)

            sliderBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if sliderBar.AbsoluteSize.X ~= 0 then
                    updateSlider(sliderBar.AbsolutePosition.X + (defaultValue - min) / (max - min) * sliderBar.AbsoluteSize.X)
                end
            end)

            -- Also try initial update (in case AbsolutePosition already valid)
            task.defer(function()
                if sliderBar.AbsoluteSize.X > 0 then
                    updateSlider(sliderBar.AbsolutePosition.X + (defaultValue - min) / (max - min) * sliderBar.AbsoluteSize.X)
                end
            end)

            yPos = yPos + 55
            contentFrame.Size = UDim2.new(1, 0, 0, yPos)
            frame.Size = UDim2.new(1, -20, 0, 30 + yPos)
        end

        -- Attach methods
        section.frame = frame
        section.content = contentFrame
        section.addLabel = addLabel
        section.addButton = addButton
        section.addToggle = addToggle
        section.addSlider = addSlider

        return section
    end

    function self:Destroy()
        screenGui:Destroy()
    end

    return self
end
