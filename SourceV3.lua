-- Fancy Minimal Roblox UI Library (Compact & Modern)
-- Optimized for elegance, smooth animations, and clean design

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local function Create(class, props)
    local inst = Instance.new(class)
    for prop, val in pairs(props) do
        inst[prop] = val
    end
    return inst
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 20),
        TabBar = Color3.fromRGB(25, 25, 25),
        Content = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

function Library.CreateLib(title, themeName)
    local Theme = Themes[themeName] or Themes.Dark
    local gui = Create("ScreenGui", { Name = "MiniFancyUI", ResetOnSpawn = false, Parent = CoreGui })

    local Main = Create("Frame", {
        Size = UDim2.new(0, 450, 0, 300),
        Position = UDim2.new(0.5, -225, 0.5, -150),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = gui
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })

    local TabBar = Create("Frame", {
        Size = UDim2.new(0, 110, 1, 0),
        BackgroundColor3 = Theme.TabBar,
        BorderSizePixel = 0,
        Parent = Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabBar })

    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = TabBar
    })

    local Content = Create("Frame", {
        Size = UDim2.new(1, -120, 1, -16),
        Position = UDim2.new(0, 115, 0, 8),
        BackgroundColor3 = Theme.Content,
        BorderSizePixel = 0,
        Parent = Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Content })

    local Tabs = {}

    local Lib = {}

    function Lib:NewTab(name)
        local Button = Create("TextButton", {
            Text = name,
            Size = UDim2.new(1, -8, 0, 28),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundColor3 = Theme.Content,
            TextColor3 = Theme.Text,
            Font = Enum.Font.GothamSemibold,
            TextSize = 13,
            AutoButtonColor = false,
            Parent = TabBar
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Button })

        Button.MouseEnter:Connect(function()
            Tween(Button, {BackgroundColor3 = Theme.Accent}, 0.2)
        end)
        Button.MouseLeave:Connect(function()
            Tween(Button, {BackgroundColor3 = Theme.Content}, 0.2)
        end)

        local Frame = Create("ScrollingFrame", {
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 2, 0),
            ScrollBarThickness = 4,
            Visible = false,
            Parent = Content
        })
        Create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Frame })
        Create("UIPadding", { PaddingLeft = UDim.new(0, 5), PaddingTop = UDim.new(0, 5), Parent = Frame })

        Button.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do t.Visible = false end
            Frame.Visible = true
        end)

        Tabs[#Tabs + 1] = Frame

        local Tab = {}

        function Tab:NewLabel(text)
            Create("TextLabel", {
                Text = text,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Frame
            })
        end

        function Tab:NewButton(text, callback)
            local Button = Create("TextButton", {
                Text = text,
                Size = UDim2.new(1, -10, 0, 28),
                BackgroundColor3 = Theme.TabBar,
                TextColor3 = Theme.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                AutoButtonColor = false,
                Parent = Frame
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Button })

            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Accent}, 0.2)
            end)
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.TabBar}, 0.2)
            end)

            Button.MouseButton1Click:Connect(function()
                if callback then
                    pcall(callback)
                end
            end)
        end

        function Tab:NewToggle(text, callback)
            local toggled = false
            local ToggleBtn = Tab:NewButton("[OFF] " .. text, function()
                toggled = not toggled
                ToggleBtn.Text = (toggled and "[ON] " or "[OFF] ") .. text
                callback(toggled)
            end)
            return ToggleBtn
        end

        function Tab:NewSlider(text, min, max, callback)
            local Label = Tab:NewLabel(text .. ": 0")
            local Slider = Create("TextButton", {
                Size = UDim2.new(1, -10, 0, 24),
                BackgroundColor3 = Theme.TabBar,
                Text = "",
                Parent = Frame
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Slider })

            local bar = Create("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Parent = Slider
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = bar })

            Slider.MouseButton1Down:Connect(function()
                local conn
                conn = game:GetService("RunService").RenderStepped:Connect(function()
                    local mouse = UserInputService:GetMouseLocation().X
                    local rel = mouse - Slider.AbsolutePosition.X
                    local pct = math.clamp(rel / Slider.AbsoluteSize.X, 0, 1)
                    bar.Size = UDim2.new(pct, 0, 1, 0)
                    local val = math.floor((min + (max - min) * pct) + 0.5)
                    Label.Text = text .. ": " .. val
                    callback(val)
                end)
                UserInputService.InputEnded:Wait()
                conn:Disconnect()
            end)
        end

        function Tab:NewKeybind(text, defaultKey, callback)
            local Label = Tab:NewLabel(text .. ": " .. defaultKey.Name)
            UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and input.KeyCode == defaultKey then
                    callback()
                end
            end)
        end

        function Tab:NewDropdown(text, list, callback)
            local DropBtn = Tab:NewButton(text .. " ▼", function() end)
            local Open = false
            local FrameDrop = Create("Frame", {
                Size = UDim2.new(1, -10, 0, #list * 22),
                BackgroundColor3 = Theme.TabBar,
                Visible = false,
                Parent = Frame
            })
            Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = FrameDrop })
            for _, opt in pairs(list) do
                Tab:NewButton(opt, function()
                    DropBtn.Text = text .. ": " .. opt
                    callback(opt)
                end).Parent = FrameDrop
            end
            DropBtn.MouseButton1Click:Connect(function()
                Open = not Open
                FrameDrop.Visible = Open
            end)
        end

        function Tab:NewColorPicker(text, defaultColor, callback)
            local btn = Tab:NewButton(text, function() end)
            local color = defaultColor or Color3.new(1, 1, 1)
            btn.BackgroundColor3 = color
            btn.MouseButton1Click:Connect(function()
                color = Color3.fromHSV(math.random(), 1, 1)
                btn.BackgroundColor3 = color
                callback(color)
            end)
        end

        return Tab
    end

    function Lib:ToggleUI()
        Main.Visible = not Main.Visible
    end

    return Lib
end

return Library
