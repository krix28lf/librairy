local Library = {}

function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Custom UI"
    local themeColor = options.ThemeColor or Color3.fromRGB(255, 40, 40)

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLibrary"
    ScreenGui.Parent = game.CoreGui

    -- MainFrame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 800, 0, 540)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -270)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MainFrame.Parent = ScreenGui

    local UICornerMain = Instance.new("UICorner", MainFrame)
    UICornerMain.CornerRadius = UDim.new(0, 25)

    local UIStrokeMain = Instance.new("UIStroke", MainFrame)
    UIStrokeMain.Color = themeColor
    UIStrokeMain.Thickness = 4

    -- TitleBar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.Parent = MainFrame

    local UICornerTitleBar = Instance.new("UICorner", TitleBar)
    UICornerTitleBar.CornerRadius = UDim.new(0, 25)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = themeColor
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 20
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0.5, -20)
    CloseButton.Parent = TitleBar

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Side Menu
    local SideMenu = Instance.new("Frame")
    SideMenu.Size = UDim2.new(0, 200, 1, -50)
    SideMenu.Position = UDim2.new(0, 0, 0, 50)
    SideMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SideMenu.Parent = MainFrame

    local UICornerSideMenu = Instance.new("UICorner", SideMenu)
    UICornerSideMenu.CornerRadius = UDim.new(0, 25)

    -- Content Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -200, 1, -50)
    ContentFrame.Position = UDim2.new(0, 200, 0, 50)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.ScrollBarImageColor3 = themeColor
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame

    local UICornerContentFrame = Instance.new("UICorner", ContentFrame)
    UICornerContentFrame.CornerRadius = UDim.new(0, 25)

    return {
        MainFrame = MainFrame,
        SideMenu = SideMenu,
        ContentFrame = ContentFrame,
    }
end

-- Add Button to Side Menu
function Library:AddButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Text = text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 18
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    Button.Size = UDim2.new(1, -20, 0, 50)
    Button.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 60 + 10)
    Button.Parent = parent

    local UICornerButton = Instance.new("UICorner", Button)
    UICornerButton.CornerRadius = UDim.new(0, 12)

    Button.MouseButton1Click:Connect(callback)
end

-- Add Toggle Switch
function Library:AddToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 60)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.Parent = parent

    local UICornerFrame = Instance.new("UICorner", Frame)
    UICornerFrame.CornerRadius = UDim.new(0, 12)

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 16
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Parent = Frame

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 50, 0, 25)
    Toggle.Position = UDim2.new(0.75, 0, 0.5, -12.5)
    Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Toggle.Text = ""
    Toggle.Parent = Frame

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = UDim2.new(0, 2, 0.5, -10)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Toggle

    local UICornerToggle = Instance.new("UICorner", Toggle)
    UICornerToggle.CornerRadius = UDim.new(1, 0)

    local UICornerCircle = Instance.new("UICorner", Circle)
    UICornerCircle.CornerRadius = UDim.new(1, 0)

    local isActive = false
    Toggle.MouseButton1Click:Connect(function()
        isActive = not isActive
        Toggle.BackgroundColor3 = isActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
        Circle.Position = isActive and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        callback(isActive)
    end)
end

return Library
