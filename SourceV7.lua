-- SimpleDrawingUI.lua
-- Basic UI library for Roblox exploits using Drawing API

local SimpleDrawingUI = {}
SimpleDrawingUI.__index = SimpleDrawingUI

local UserInputService = game:GetService("UserInputService")

-- Utility function to create a drawing
local function newDrawing(class, properties)
    local d = Drawing.new(class)
    for k,v in pairs(properties or {}) do
        d[k] = v
    end
    return d
end

function SimpleDrawingUI.new(title)
    local self = setmetatable({}, SimpleDrawingUI)

    self.Window = {}
    self.Window.Title = title or "Simple UI"
    self.Window.Visible = true

    -- Window position & size
    self.Window.Position = Vector2.new(300, 200)
    self.Window.Size = Vector2.new(300, 400)

    -- Components container
    self.Components = {}

    -- Drag variables
    self.Dragging = false
    self.DragOffset = Vector2.new(0, 0)

    -- Draw the window frame and title bar
    self:CreateWindow()

    -- Input connections
    self.InputBeganConnection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local pos = Vector2.new(mousePos.X, mousePos.Y)
            -- Check if clicking on title bar for drag
            if pos.X > self.Window.Position.X and pos.X < self.Window.Position.X + self.Window.Size.X
            and pos.Y > self.Window.Position.Y and pos.Y < self.Window.Position.Y + 30 then
                self.Dragging = true
                self.DragOffset = pos - self.Window.Position
            end
        end
    end)

    self.InputEndedConnection = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)

    self.InputChangedConnection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and self.Dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local newPos = Vector2.new(mousePos.X, mousePos.Y) - self.DragOffset
            self.Window.Position = newPos
            self:UpdateWindow()
        end
    end)

    return self
end

function SimpleDrawingUI:CreateWindow()
    -- Window background
    self.Background = newDrawing("Square", {
        Color = Color3.fromRGB(30,30,30),
        Size = self.Window.Size,
        Position = self.Window.Position,
        Filled = true,
        Visible = self.Window.Visible,
        Thickness = 1,
    })

    -- Title bar background
    self.TitleBar = newDrawing("Square", {
        Color = Color3.fromRGB(45,45,45),
        Size = Vector2.new(self.Window.Size.X, 30),
        Position = self.Window.Position,
        Filled = true,
        Visible = self.Window.Visible,
        Thickness = 1,
    })

    -- Title text
    self.TitleText = newDrawing("Text", {
        Text = self.Window.Title,
        Color = Color3.new(1,1,1),
        Size = 18,
        Position = self.Window.Position + Vector2.new(10, 5),
        Visible = self.Window.Visible,
        Center = false,
        Outline = true,
        Font = 2, -- System font
    })
end

function SimpleDrawingUI:UpdateWindow()
    self.Background.Position = self.Window.Position
    self.TitleBar.Position = self.Window.Position
    self.TitleText.Position = self.Window.Position + Vector2.new(10, 5)

    -- Update components position
    local offsetY = 40
    for _, component in ipairs(self.Components) do
        component.Position = self.Window.Position + Vector2.new(10, offsetY)
        component:Update()
        offsetY = offsetY + component.Height + 10
    end
end

function SimpleDrawingUI:AddButton(text, callback)
    local button = {}
    button.Text = text
    button.Callback = callback
    button.Position = self.Window.Position + Vector2.new(10, 40)
    button.Width = self.Window.Size.X - 20
    button.Height = 30
    button.Hovered = false

    button.Background = newDrawing("Square", {
        Color = Color3.fromRGB(70, 70, 70),
        Size = Vector2.new(button.Width, button.Height),
        Position = button.Position,
        Filled = true,
        Visible = true,
    })

    button.TextDrawing = newDrawing("Text", {
        Text = button.Text,
        Color = Color3.new(1, 1, 1),
        Size = 16,
        Position = button.Position + Vector2.new(button.Width/2, button.Height/2 - 8),
        Center = true,
        Outline = true,
        Visible = true,
        Font = 2,
    })

    function button:Update()
        self.Background.Position = self.Position
        self.TextDrawing.Position = self.Position + Vector2.new(self.Width/2, self.Height/2 - 8)

        local mousePos = UserInputService:GetMouseLocation()
        local mouseVector = Vector2.new(mousePos.X, mousePos.Y)

        if mouseVector.X > self.Position.X and mouseVector.X < self.Position.X + self.Width
        and mouseVector.Y > self.Position.Y and mouseVector.Y < self.Position.Y + self.Height then
            if not self.Hovered then
                self.Hovered = true
                self.Background.Color = Color3.fromRGB(100, 100, 100)
            end
        else
            if self.Hovered then
                self.Hovered = false
                self.Background.Color = Color3.fromRGB(70, 70, 70)
            end
        end
    end

    -- Mouse click event
    self.InputBeganConnection:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local mVec = Vector2.new(mousePos.X, mousePos.Y)
            if mVec.X > button.Position.X and mVec.X < button.Position.X + button.Width
            and mVec.Y > button.Position.Y and mVec.Y < button.Position.Y + button.Height then
                button.Callback()
            end
        end
    end)

    table.insert(self.Components, button)
    self:UpdateWindow()
    return button
end

function SimpleDrawingUI:AddToggle(text, callback)
    local toggle = {}
    toggle.Text = text
    toggle.Callback = callback
    toggle.Position = self.Window.Position + Vector2.new(10, 40)
    toggle.Width = self.Window.Size.X - 20
    toggle.Height = 30
    toggle.Enabled = false
    toggle.Hovered = false

    toggle.Background = newDrawing("Square", {
        Color = Color3.fromRGB(70, 70, 70),
        Size = Vector2.new(toggle.Width, toggle.Height),
        Position = toggle.Position,
        Filled = true,
        Visible = true,
    })

    toggle.Box = newDrawing("Square", {
        Color = Color3.fromRGB(40,40,40),
        Size = Vector2.new(20, 20),
        Position = toggle.Position + Vector2.new(5, 5),
        Filled = true,
        Visible = true,
        Thickness = 1,
    })

    toggle.CheckMark = newDrawing("Text", {
        Text = "✓",
        Color = Color3.new(0,1,0),
        Size = 20,
        Position = toggle.Position + Vector2.new(5, 1),
        Visible = false,
        Center = true,
        Outline = true,
        Font = 2,
    })

    toggle.TextDrawing = newDrawing("Text", {
        Text = toggle.Text,
        Color = Color3.new(1, 1, 1),
        Size = 16,
        Position = toggle.Position + Vector2.new(30, 5),
        Center = false,
        Outline = true,
        Visible = true,
        Font = 2,
    })

    function toggle:Update()
        self.Background.Position = self.Position
        self.Box.Position = self.Position + Vector2.new(5, 5)
        self.CheckMark.Position = self.Position + Vector2.new(15, 13)
        self.TextDrawing.Position = self.Position + Vector2.new(30, 5)

        local mousePos = UserInputService:GetMouseLocation()
        local mouseVector = Vector2.new(mousePos.X, mousePos.Y)

        if mouseVector.X > self.Position.X and mouseVector.X < self.Position.X + self.Width
        and mouseVector.Y > self.Position.Y and mouseVector.Y < self.Position.Y + self.Height then
            if not self.Hovered then
                self.Hovered = true
                self.Background.Color = Color3.fromRGB(100, 100, 100)
            end
        else
            if self.Hovered then
                self.Hovered = false
                self.Background.Color = Color3.fromRGB(70, 70, 70)
            end
        end

        self.CheckMark.Visible = self.Enabled
    end

    self.InputBeganConnection:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local mVec = Vector2.new(mousePos.X, mousePos.Y)
            if mVec.X > toggle.Position.X and mVec.X < toggle.Position.X + toggle.Width
            and mVec.Y > toggle.Position.Y and mVec.Y < toggle.Position.Y + toggle.Height then
                toggle.Enabled = not toggle.Enabled
                toggle.Callback(toggle.Enabled)
            end
        end
    end)

    table.insert(self.Components, toggle)
    self:UpdateWindow()
    return toggle
end

function SimpleDrawingUI:Destroy()
    self.Background:Remove()
    self.TitleBar:Remove()
    self.TitleText:Remove()

    for _, comp in ipairs(self.Components) do
        comp.Background:Remove()
        if comp.TextDrawing then comp.TextDrawing:Remove() end
        if comp.Box then comp.Box:Remove() end
        if comp.CheckMark then comp.CheckMark:Remove() end
    end

    self.InputBeganConnection:Disconnect()
    self.InputEndedConnection:Disconnect()
    self.InputChangedConnection:Disconnect()
end

return SimpleDrawingUI
