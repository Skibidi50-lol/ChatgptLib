-- Minimal UI Library for Roblox (single file, loadstring-ready)

local UI = {}
UI.__index = UI

function UI.new(title)
    local self = setmetatable({}, UI)
    
    -- Create main ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "SimpleUILib"
    self.screenGui.ResetOnSpawn = false
    self.screenGui.Parent = game:GetService("CoreGui") -- use CoreGui so it works in exploits (like Rayfield does)
    
    -- Main window frame
    self.window = Instance.new("Frame")
    self.window.Name = "Window"
    self.window.Size = UDim2.new(0, 400, 0, 300)
    self.window.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.window.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.window.BorderSizePixel = 0
    self.window.Parent = self.screenGui
    
    -- Title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = title or "UI Library"
    titleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.Parent = self.window
    
    -- Container for buttons/toggles/etc
    self.content = Instance.new("ScrollingFrame")
    self.content.Size = UDim2.new(1, 0, 1, -30)
    self.content.Position = UDim2.new(0, 0, 0, 30)
    self.content.BackgroundTransparency = 1
    self.content.BorderSizePixel = 0
    self.content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.content.ScrollBarThickness = 4
    self.content.Parent = self.window
    
    self.items = {}
    self.currentY = 0
    
    return self
end

function UI:addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, self.currentY + 5)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.AutoButtonColor = true
    btn.Parent = self.content
    
    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    self.currentY = self.currentY + 40
    self.content.CanvasSize = UDim2.new(0, 0, 0, self.currentY + 10)
    table.insert(self.items, btn)
    return btn
end

function UI:addToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, self.currentY + 5)
    frame.BackgroundTransparency = 1
    frame.Parent = self.content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(0.8, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(85, 170, 127) or Color3.fromRGB(70, 70, 70)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.Parent = frame
    
    local toggled = default or false
    
    local function updateToggle()
        if toggled then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 127)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
        if callback then callback(toggled) end
    end)
    
    updateToggle()
    
    self.currentY = self.currentY + 40
    self.content.CanvasSize = UDim2.new(0, 0, 0, self.currentY + 10)
    table.insert(self.items, frame)
    return frame
end

function UI:addSlider(text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.Position = UDim2.new(0, 10, 0, self.currentY + 5)
    frame.BackgroundTransparency = 1
    frame.Parent = self.content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 10)
    sliderBar.Position = UDim2.new(0, 10, 0, 22)
    sliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = frame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(85, 170, 127)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local dragging = false
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
            local percent = relativeX / sliderBar.AbsoluteSize.X
            local value = math.floor(min + percent * (max - min))
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. value
            if callback then callback(value) end
        end
    end)
    
    self.currentY = self.currentY + 50
    self.content.CanvasSize = UDim2.new(0, 0, 0, self.currentY + 10)
    table.insert(self.items, frame)
    return frame
end

function UI:addDropdown(text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.Position = UDim2.new(0, 10, 0, self.currentY + 5)
    frame.BackgroundTransparency = 1
    frame.Parent = self.content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local selectedValue = default or options[1]
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0.25, -10, 1, 0)
    dropdownBtn.Position = UDim2.new(0.75, 0, 0, 0)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Text = selectedValue
    dropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.TextSize = 14
    dropdownBtn.Parent = frame
    
    local dropdownOpen = false
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(0, dropdownBtn.AbsoluteSize.X, 0, 100)
    dropdownList.Position = UDim2.new(0.75, 0, 1, 0)
    dropdownList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropdownList.BorderSizePixel = 0
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropdownList.ScrollBarThickness = 4
    dropdownList.Visible = false
    dropdownList.Parent = frame
    
    local itemHeight = 25
    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, itemHeight)
        optionBtn.Position = UDim2.new(0, 0, 0, (i-1)*itemHeight)
        optionBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        optionBtn.BorderSizePixel = 0
        optionBtn.Text = option
        optionBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        optionBtn.Font = Enum.Font.Gotham
        optionBtn.TextSize = 14
        optionBtn.Parent = dropdownList
        
        optionBtn.MouseButton1Click:Connect(function()
            selectedValue = option
            dropdownBtn.Text = option
            dropdownList.Visible = false
            dropdownOpen = false
            if callback then callback(option) end
        end)
    end
    
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, #options * itemHeight)
    
    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        dropdownList.Visible = dropdownOpen
    end)
    
    self.currentY = self.currentY + 40
    self.content.CanvasSize = UDim2.new(0, 0, 0, self.currentY + 10)
    table.insert(self.items, frame)
    return frame
end

function UI:Destroy()
    self.screenGui:Destroy()
end

return UI
