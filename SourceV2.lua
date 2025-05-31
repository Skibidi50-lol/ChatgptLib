-- Fancy Minimal Roblox UI Library (Compact & Modern)
-- Optimized for elegance, smooth animations, and clean design

local Library = {}
local TweenService = game:GetService("TweenService")
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

        return Tab
    end

    function Lib:ToggleUI()
        Main.Visible = not Main.Visible
    end

    return Lib
end

return Library
