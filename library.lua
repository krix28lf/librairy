local Library = {}

-- Fonction pour créer une fenêtre principale
function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Custom UI"
    local themeColor = options.ThemeColor or Color3.fromRGB(255, 40, 40)

    -- Création des éléments principaux
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TitleBar = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local MinimizeButton = Instance.new("TextButton")
    local SideMenu = Instance.new("Frame")
    local ContentFrame = Instance.new("ScrollingFrame")

    -- ScreenGui
    ScreenGui.Name = "CustomLibrary"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- MainFrame
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
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.Parent = MainFrame

    local UICornerTitleBar = Instance.new("UICorner", TitleBar)
    UICornerTitleBar.CornerRadius = UDim.new(0, 25)

    -- TitleLabel
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = themeColor
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- CloseButton
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

    -- MinimizeButton
    MinimizeButton.Text = "_"
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextSize = 20
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Position = UDim2.new(1, -90, 0.5, -20)
    MinimizeButton.Parent = TitleBar

    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- SideMenu
    SideMenu.Size = UDim2.new(0, 200, 1, -50)
    SideMenu.Position = UDim2.new(0, 0, 0, 50)
    SideMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SideMenu.Parent = MainFrame

    local UICornerSideMenu = Instance.new("UICorner", SideMenu)
    UICornerSideMenu.CornerRadius = UDim.new(0, 25)

    -- ContentFrame
    ContentFrame.Size = UDim2.new(1, -200, 1, -50)
    ContentFrame.Position = UDim2.new(0, 200, 0, 50)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.ScrollBarImageColor3 = themeColor
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame

    local UICornerContent = Instance.new("UICorner", ContentFrame)
    UICornerContent.CornerRadius = UDim.new(0, 25)

    -- Retourner les composants principaux
    return {
        MainFrame = MainFrame,
        SideMenu = SideMenu,
        ContentFrame = ContentFrame,
    }
end

-- Ajouter un bouton au menu latéral
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
    return Button
end

-- Ajouter un toggle
function Library:AddToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.Parent = parent

    local UICornerFrame = Instance.new("UICorner", Frame)
    UICornerFrame.CornerRadius = UDim.new(0, 12)

    local Label = Instance.new("TextLabel", Frame)
    Label.Text = text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 16
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1

    local ToggleButton = Instance.new("TextButton", Frame)
    ToggleButton.Text = ""
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(0.75, 0, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

    local isActive = false
    ToggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        ToggleButton.BackgroundColor3 = isActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
        callback(isActive)
    end)
end

return Library
