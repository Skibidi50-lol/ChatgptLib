-- Modern Fancy Roblox UI Library
-- Inspired by Kavo, styled with rounded corners, hover animations, and dark themes

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local function Create(class, props)
    local inst = Instance.new(class)
    for prop, val in pairs(props) do
        if prop == "Parent" then
            inst.Parent = val
        else
            inst[prop] = val
        end
    end
    return inst
end

local function Tween(obj, props, time, style)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        TabBar = Color3.fromRGB(25, 25, 25),
        Content = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

function Library.CreateLib(title, themeName)
    local Theme = Themes[themeName] or Themes.Dark

    local ScreenGui = Create("ScreenGui", {
        Name = "FancyUILib",
        Parent = CoreGui,
        ResetOnSpawn = false
    })

    local Main = Create("Frame", {
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = Main })
    Create("UIStroke", { Color = Theme.Accent, Thickness = 1.2, Parent = Main })

    local TabBar = Create("Frame", {
        Size = UDim2.new(0, 140, 1, 0),
        BackgroundColor3 = Theme.TabBar,
        BorderSizePixel = 0,
        Parent = Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TabBar })

    local TabLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = TabBar
    })

    local ContentFrame = Create("Frame", {
        Size = UDim2.new(1, -150, 1, -20),
        Position = UDim2.new(0, 150, 0, 10),
        BackgroundColor3 = Theme.Content,
        BorderSizePixel = 0,
        Parent = Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = ContentFrame })

    local Tabs = {}

    local Lib = {}

    function Lib:NewTab(name)
        local TabButton = Create("TextButton", {
            Text = name,
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundColor3 = Theme.Content,
            TextColor3 = Theme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            AutoButtonColor = false,
            Parent = TabBar
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = TabButton })

        TabButton.MouseEnter:Connect(function()
            Tween(TabButton, {BackgroundColor3 = Theme.Accent}, 0.2)
        end)
        TabButton.MouseLeave:Connect(function()
            Tween(TabButton, {BackgroundColor3 = Theme.Content}, 0.2)
        end)

        local TabContent = Create("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 1, 0),
            BorderSizePixel = 0,
            ScrollBarThickness = 5,
            Visible = false,
            Parent = ContentFrame
        })
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = TabContent
        })
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            Parent = TabContent
        })

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Visible = false
            end
            TabContent.Visible = true
        end)

        Tabs[#Tabs + 1] = TabContent

        local SectionAPI = {}

        function SectionAPI:NewLabel(text)
            local lbl = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TabContent
            })
        end

        -- Additional controls like buttons, toggles, sliders etc. go here...

        return SectionAPI
    end

    function Lib:ToggleUI()
        Main.Visible = not Main.Visible
    end

    return Lib
end

return Library
