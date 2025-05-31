-- ExploitUIDrawLib.lua
local ExploitUIDrawLib = {}

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Drawing = Drawing -- global

-- Store windows and controls
ExploitUIDrawLib.Windows = {}

-- Helper to create drawing objects
local function newDrawing(class, props)
    local d = Drawing.new(class)
    for k,v in pairs(props) do
        d[k] = v
    end
    return d
end

-- Create a new window
function ExploitUIDrawLib:CreateWindow(title, pos, size)
    local window = {}
    window.Position = pos or Vector2.new(300, 200)
    window.Size = size or Vector2.new(300, 400)
    window.Title = title or "Window"
    window.Dragging = false
    window.DragOffset = Vector2.new()

    -- Draw objects
    window.Background = newDrawing("Square", {
        Color = Color3.fromRGB(30, 30, 30),
        Filled = true,
        Size = window.Size,
        Position = window.Position,
        ZIndex = 1,
    })

    window.TitleBar = newDrawing("Square", {
        Color = Color3.fromRGB(50, 50, 50),
        Filled = true,
        Size = Vector2.new(window.Size.X, 30),
        Position = window.Position,
        ZIndex = 2,
    })

    window.TitleText = newDrawing("Text", {
        Text = window.Title,
        Size = 18,
        Color = Color3.new(1, 1, 1),
        Position = window.Position + Vector2.new(10, 5),
        Outline = true,
        Font = 2,
        ZIndex = 3,
    })

    -- Store controls
    window.Controls = {}

    -- Dragging logic
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            if mousePos.X >= window.Position.X and mousePos.X <= (window.Position.X + window.Size.X) and
               mousePos.Y >= window.Position.Y and mousePos.Y <= (window.Position.Y + 30) then
                window.Dragging = true
                window.DragOffset = Vector2.new(mousePos.X, mousePos.Y) - window.Position
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            window.Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and window.Dragging then
            local mousePos = UserInputService:GetMouseLocation()
            window.Position = Vector2.new(mousePos.X, mousePos.Y) - window.DragOffset
            window.Background.Position = window.Position
            window.TitleBar.Position = window.Position
            window.TitleText.Position = window.Position + Vector2.new(10, 5)
            -- Update control positions
            local yOffset = 40
            for _, ctrl in ipairs(window.Controls) do
                ctrl.Position = window.Position + Vector2.new(10, yOffset)
                ctrl.Background.Position = ctrl.Position
                ctrl.Text.Position = ctrl.Position + Vector2.new(ctrl.Background.Size.X/2, 5)
                yOffset = yOffset + ctrl.Background.Size.Y + 10
            end
        end
    end)

    -- Update function for hover effects
    RunService.RenderStepped:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        for _, ctrl in ipairs(window.Controls) do
            if mousePos.X >= ctrl.Position.X and mousePos.X <= (ctrl.Position.X + ctrl.Background.Size.X) and
               mousePos.Y >= ctrl.Position.Y and mousePos.Y <= (ctrl.Position.Y + ctrl.Background.Size.Y) then
                ctrl.Background.Color = Color3.fromRGB(100, 100, 100)
            else
                ctrl.Background.Color = Color3.fromRGB(70, 70, 70)
            end
        end
    end)

    table.insert(self.Windows, window)
    return window
end

-- Add a button to a window
function ExploitUIDrawLib:AddButton(window, text, callback)
    local btnSize = Vector2.new(window.Size.X - 20, 30)
    local btnPos = window.Position + Vector2.new(10, 40 + #window.Controls * (btnSize.Y + 10))

    local button = {}
    button.Position = btnPos
    button.Background = newDrawing("Square", {
        Color = Color3.fromRGB(70, 70, 70),
        Filled = true,
        Size = btnSize,
        Position = btnPos,
        ZIndex = 3,
    })
    button.Text = newDrawing("Text", {
        Text = text,
        Size = 16,
        Color = Color3.new(1,1,1),
        Position = btnPos + Vector2.new(btnSize.X / 2, 5),
        Center = true,
        Outline = true,
        Font = 2,
        ZIndex = 4,
    })
    button.Callback = callback

    -- Connect click
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            if mousePos.X >= button.Position.X and mousePos.X <= (button.Position.X + button.Background.Size.X) and
               mousePos.Y >= button.Position.Y and mousePos.Y <= (button.Position.Y + button.Background.Size.Y) then
                if button.Callback then
                    button.Callback()
                end
            end
        end
    end)

    table.insert(window.Controls, button)
    return button
end

return ExploitUIDrawLib
