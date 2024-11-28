local Library = {}

function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Custom UI"
    local themeColor = options.ThemeColor or Color3.fromRGB(255, 40, 40)

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLibrary"
    ScreenGui.Parent = game.CoreGui

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 800, 0, 540)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -270)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MainFrame.Parent = ScreenGui

    local UICornerMainFrame = Instance.new("UICorner")
    UICornerMainFrame.CornerRadius = UDim.new(0, 25)
    UICornerMainFrame.Parent = MainFrame

    local UIStrokeMainFrame = Instance.new("UIStroke")
    UIStrokeMainFrame.Color = themeColor
    UIStrokeMainFrame.Thickness = 4
    UIStrokeMainFrame.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 55)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.Parent = MainFrame

    local UICornerTitleBar = Instance.new("UICorner")
    UICornerTitleBar.CornerRadius = UDim.new(0, 25)
    UICornerTitleBar.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = themeColor
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -110, 1, 0)
    TitleLabel.Position = UDim2.new(0, 20, 0, 0)
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

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 12)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Side Menu
    local SideMenu = Instance.new("Frame")
    SideMenu.Size = UDim2.new(0, 200, 1, -55)
    SideMenu.Position = UDim2.new(0, 0, 0, 55)
    SideMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SideMenu.Parent = MainFrame

    local UICornerSideMenu = Instance.new("UICorner")
    UICornerSideMenu.CornerRadius = UDim.new(0, 25)
    UICornerSideMenu.Parent = SideMenu

    -- Content Frame
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -200, 1, -55)
    ContentFrame.Position = UDim2.new(0, 200, 0, 55)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.ScrollBarImageColor3 = themeColor
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame

    local UICornerContentFrame = Instance.new("UICorner")
    UICornerContentFrame.CornerRadius = UDim.new(0, 25)
    UICornerContentFrame.Parent = ContentFrame

    return {
        MainFrame = MainFrame,
        SideMenu = SideMenu,
        ContentFrame = ContentFrame,
    }
end

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

    local UICornerButton = Instance.new("UICorner")
    UICornerButton.CornerRadius = UDim.new(0, 12)
    UICornerButton.Parent = Button

    Button.MouseButton1Click:Connect(callback)
end

function Library:AddToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 60)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.Parent = parent

    local UICornerFrame = Instance.new("UICorner")
    UICornerFrame.CornerRadius = UDim.new(0, 12)
    UICornerFrame.Parent = Frame

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

    local UICornerToggle = Instance.new("UICorner")
    UICornerToggle.CornerRadius = UDim.new(1, 0)
    UICornerToggle.Parent = Toggle

    local UICornerCircle = Instance.new("UICorner")
    UICornerCircle.CornerRadius = UDim.new(1, 0)
    UICornerCircle.Parent = Circle

    local isActive = false
    Toggle.MouseButton1Click:Connect(function()
        isActive = not isActive
        Toggle.BackgroundColor3 = isActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
        Circle.Position = isActive and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        callback(isActive)
    end)
end

return Library
