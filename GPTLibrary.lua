
-- AdvancedUILib_REAL.lua
-- Beautiful, real, full-featured Roblox UI library with no filler

local UILib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

UILib.Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    Foreground = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(0, 170, 255),
    Button = Color3.fromRGB(40, 40, 40),
    Hover = Color3.fromRGB(70, 70, 70),
    Font = Enum.Font.Gotham
}

local function roundify(obj, radius)
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, radius)
    uic.Parent = obj
end

function UILib:CreateWindow(title)
    local gui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "AdvancedUILib"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 400)
    frame.Position = UDim2.new(0.5, -250, 0.5, -200)
    frame.BackgroundColor3 = self.Theme.Background
    frame.BorderSizePixel = 0
    frame.Name = "MainFrame"
    frame.Parent = gui
    roundify(frame, 12)

    local titleBar = Instance.new("TextLabel", frame)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1
    titleBar.Text = title or "Advanced UI"
    titleBar.Font = self.Theme.Font
    titleBar.TextSize = 20
    titleBar.TextColor3 = self.Theme.Foreground
    titleBar.TextXAlignment = Enum.TextXAlignment.Left
    titleBar.Position = UDim2.new(0, 10, 0, 0)

    return frame
end

function UILib:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 40)
    button.Position = UDim2.new(0, 10, 0, 50)
    button.Text = text
    button.Font = self.Theme.Font
    button.TextColor3 = self.Theme.Foreground
    button.BackgroundColor3 = self.Theme.Button
    button.TextSize = 16
    button.AutoButtonColor = false
    button.Parent = parent
    roundify(button, 8)

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = self.Theme.Hover
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = self.Theme.Button
    end)
    button.MouseButton1Click:Connect(callback)

    return button
end

function UILib:CreateToggle(parent, text, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -20, 0, 40)
    toggle.Position = UDim2.new(0, 10, 0, 100)
    toggle.Text = text .. ": " .. (default and "ON" or "OFF")
    toggle.Font = self.Theme.Font
    toggle.TextColor3 = self.Theme.Foreground
    toggle.BackgroundColor3 = self.Theme.Button
    toggle.TextSize = 16
    toggle.AutoButtonColor = false
    toggle.Parent = parent
    roundify(toggle, 8)

    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = text .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)

    return toggle
end

function UILib:CreateSlider(parent, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 40)
    sliderFrame.Position = UDim2.new(0, 10, 0, 150)
    sliderFrame.BackgroundColor3 = self.Theme.Button
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    roundify(sliderFrame, 8)

    local sliderBar = Instance.new("Frame", sliderFrame)
    sliderBar.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    sliderBar.BackgroundColor3 = self.Theme.Accent
    sliderBar.BorderSizePixel = 0

    local dragging = false
    sliderFrame.InputBegan:Connect(function(input)
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
            local pos = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            sliderBar.Size = UDim2.new(pos, 0, 1, 0)
            local value = math.floor((min + (max - min) * pos) + 0.5)
            callback(value)
        end
    end)

    return sliderFrame
end

function UILib:CreateDropdown(parent, labelText, options, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, -20, 0, 40)
    dropdownFrame.Position = UDim2.new(0, 10, 0, 200)
    dropdownFrame.BackgroundColor3 = self.Theme.Button
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = parent
    roundify(dropdownFrame, 8)

    local label = Instance.new("TextLabel")
    label.Text = labelText or "Select"
    label.Font = self.Theme.Font
    label.TextSize = 16
    label.TextColor3 = self.Theme.Foreground
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 30, 1, 0)
    button.Position = UDim2.new(1, -30, 0, 0)
    button.Text = "▼"
    button.Font = self.Theme.Font
    button.TextSize = 16
    button.TextColor3 = self.Theme.Foreground
    button.BackgroundTransparency = 1
    button.Parent = dropdownFrame

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, #options * 30)
    list.Position = UDim2.new(0, 0, 1, 5)
    list.BackgroundColor3 = self.Theme.Button
    list.BorderSizePixel = 0
    list.Visible = false
    list.Parent = dropdownFrame
    roundify(list, 8)

    local layout = Instance.new("UIListLayout", list)
    layout.Padding = UDim.new(0, 2)

    for _, opt in ipairs(options) do
        local item = Instance.new("TextButton")
        item.Text = opt
        item.Size = UDim2.new(1, 0, 0, 30)
        item.BackgroundColor3 = self.Theme.Button
        item.TextColor3 = self.Theme.Foreground
        item.Font = self.Theme.Font
        item.TextSize = 14
        item.Parent = list
        roundify(item, 6)

        item.MouseButton1Click:Connect(function()
            label.Text = opt
            list.Visible = false
            callback(opt)
        end)
    end

    button.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)

    return dropdownFrame
end

function UILib:Notify(text, duration)
    local gui = Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AdvancedUILib")
    if not gui then return end

    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(0, 300, 0, 50)
    note.Position = UDim2.new(1, -310, 1, -60)
    note.BackgroundColor3 = self.Theme.Accent
    note.Text = text
    note.TextColor3 = Color3.new(1, 1, 1)
    note.TextSize = 16
    note.Font = self.Theme.Font
    note.TextWrapped = true
    note.Parent = gui
    roundify(note, 10)

    local tweenIn = TweenService:Create(note, TweenInfo.new(0.3), {Position = UDim2.new(1, -310, 1, -110)})
    tweenIn:Play()
    tweenIn.Completed:Wait()

    task.delay(duration or 2, function()
        local tweenOut = TweenService:Create(note, TweenInfo.new(0.3), {Position = UDim2.new(1, -310, 1, -60)})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        note:Destroy()
    end)
end

return UILib
