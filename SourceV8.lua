-- Minimal Exploit UI with drag and button

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Drawing = Drawing -- Drawing API is global in most exploits

-- Window properties
local windowPos = Vector2.new(300, 200)
local windowSize = Vector2.new(300, 350)
local dragging = false
local dragOffset = Vector2.new()

-- Draw window background
local windowBackground = Drawing.new("Square")
windowBackground.Color = Color3.fromRGB(30, 30, 30)
windowBackground.Filled = true
windowBackground.Size = windowSize
windowBackground.Position = windowPos
windowBackground.ZIndex = 1

-- Draw title bar
local titleBar = Drawing.new("Square")
titleBar.Color = Color3.fromRGB(50, 50, 50)
titleBar.Filled = true
titleBar.Size = Vector2.new(windowSize.X, 30)
titleBar.Position = windowPos
titleBar.ZIndex = 2

-- Draw title text
local titleText = Drawing.new("Text")
titleText.Text = "Minimal Exploit UI"
titleText.Size = 18
titleText.Color = Color3.new(1, 1, 1)
titleText.Position = windowPos + Vector2.new(10, 5)
titleText.Outline = true
titleText.Font = 2
titleText.ZIndex = 3

-- Button properties
local buttonPos = windowPos + Vector2.new(10, 50)
local buttonSize = Vector2.new(windowSize.X - 20, 30)

local buttonBackground = Drawing.new("Square")
buttonBackground.Color = Color3.fromRGB(70, 70, 70)
buttonBackground.Filled = true
buttonBackground.Size = buttonSize
buttonBackground.Position = buttonPos
buttonBackground.ZIndex = 3

local buttonText = Drawing.new("Text")
buttonText.Text = "Click Me!"
buttonText.Size = 16
buttonText.Color = Color3.new(1, 1, 1)
buttonText.Position = buttonPos + Vector2.new(buttonSize.X / 2, 5)
buttonText.Center = true
buttonText.Outline = true
buttonText.Font = 2
buttonText.ZIndex = 4

-- Function to check if mouse is in rectangle
local function isMouseInRect(mousePos, pos, size)
    return mousePos.X >= pos.X and mousePos.X <= (pos.X + size.X) and
           mousePos.Y >= pos.Y and mousePos.Y <= (pos.Y + size.Y)
end

-- Mouse input events
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()

        -- Check if clicking title bar (for drag)
        if isMouseInRect(mousePos, windowPos, Vector2.new(windowSize.X, 30)) then
            dragging = true
            dragOffset = Vector2.new(mousePos.X, mousePos.Y) - windowPos
        end

        -- Check if clicking button
        if isMouseInRect(mousePos, buttonPos, buttonSize) then
            print("Button clicked!")
            -- Put your callback here
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local mousePos = UserInputService:GetMouseLocation()
        windowPos = Vector2.new(mousePos.X, mousePos.Y) - dragOffset

        -- Update positions
        windowBackground.Position = windowPos
        titleBar.Position = windowPos
        titleText.Position = windowPos + Vector2.new(10, 5)
        buttonPos = windowPos + Vector2.new(10, 50)
        buttonBackground.Position = buttonPos
        buttonText.Position = buttonPos + Vector2.new(buttonSize.X / 2, 5)
    end
end)

-- Main update loop (optional, for hover effects)
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()

    -- Button hover effect
    if isMouseInRect(mousePos, buttonPos, buttonSize) then
        buttonBackground.Color = Color3.fromRGB(100, 100, 100)
    else
        buttonBackground.Color = Color3.fromRGB(70, 70, 70)
    end
end)
