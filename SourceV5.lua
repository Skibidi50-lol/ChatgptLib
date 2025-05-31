-- Fancy Roblox UI Library (single file, loadstring ready)
local UI = {}
UI.__index = UI

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Helper: Make frame draggable
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Create rounded corner UI element
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

-- Create hover effect for buttons
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = button.BackgroundColor3:Lerp(Color3.fromRGB(100, 170, 140), 0.6)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = button._defaultColor or button.BackgroundColor3
    end)
end

-- UI Constructor
function UI.new(title)
    local self = setmetatable({}, UI)

    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "FancyUILib"
    self.screenGui.ResetOnSpawn = false
    self.screenGui.Parent = game:GetService("CoreGui")

    -- Main window frame
    self.window = Instance.new("Frame")
    self.window.Name = "Window"
    self.window.Size = UDim2.new(0, 420, 0, 360)
    self.window.Position = UDim2.new(0.5, -210, 0.5, -180)
    self.window.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.window.BorderSizePixel = 0
    self.window.Parent = self.screenGui
    createUICorner(self.window, 12)

    makeDraggable(self.window)

    -- Title bar
    self.titleBar = Instance.new("Frame")
    self.titleBar.Size = UDim2.new(1, 0, 0, 38)
    self.titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.titleBar.BorderSizePixel = 0
    self.titleBar.Parent = self.window
    createUICorner(self.titleBar, 12)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Fancy UI Library"
    titleLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.titleBar

    -- Content scrolling frame
    self.content = Instance.new("ScrollingFrame")
    self.content.Size = UDim2.new(1, 0, 1, -38)
    self.content.Position = UDim2.new(0, 0, 0, 38)
    self.content.BackgroundTransparency = 1
    self.content.BorderSizePixel = 0
    self.content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.content.ScrollBarThickness = 5
    self.content.Parent = self.window

    self.sections = {}
    self.currentY = 10

    return self
end

-- Add a section container
function UI:addSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, 80) -- start small, will grow with content
    section.Position = UDim2.new(0, 10, 0, self.currentY)
    section.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    section.BorderSizePixel = 0
    section.Parent = self.content
    createUICorner(section, 8)

    -- Section title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 28)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Section"
    titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = section

    -- Content container inside section
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -50)
    content.Position = UDim2.new(0, 10, 0, 40)
    content.BackgroundTransparency = 1
    content.Parent = section

    -- Track current Y inside section for items
    local sec = {
        frame = section,
        content = content,
        currentY = 0,
        addLabel = function(self, text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Position = UDim2.new(0, 0, 0, self.currentY)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(180, 180, 180)
            label.Font = Enum.Font.Gotham
            label.TextSize = 15
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = self.content

            self.currentY = self.currentY + 25
            -- Resize section frame to fit content
            self.frame.Size = UDim2.new(self.frame.Size.X.Scale, self.frame.Size.X.Offset, 0, self.currentY + 50)
        end,
        addButton = function(self, text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, self.currentY)
            btn.BackgroundColor3 = Color3.fromRGB(75, 160, 115)
            btn.BorderSizePixel = 0
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(230, 230, 230)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 16
            btn.Parent = self.content
            createUICorner(btn, 6)
            btn._defaultColor = btn.BackgroundColor3
            addHoverEffect(btn)

            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)

            self.currentY = self.currentY + 35
            self.frame.Size = UDim2.new(self.frame.Size.X.Scale, self.frame.Size.X.Offset, 0, self.currentY + 50)
        end,
    }

    table.insert(self.sections, sec)
    self.currentY = self.currentY + section.Size.Y.Offset + 10
    self.content.CanvasSize = UDim2.new(0, 0, 0, self.currentY + 10)

    return sec
end

-- Optional: Destroy UI
function UI:Destroy()
    if self.screenGui then
        self.screenGui:Destroy()
    end
end

return UI
