local Library = {}

-- Initialisation d'une nouvelle interface
function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Custom UI"
    local themeColor = options.ThemeColor or Color3.fromRGB(255, 40, 40)

    -- Création de l'écran principal
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLibrary"
    ScreenGui.Parent = game.CoreGui

    -- Fenêtre principale
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 800, 0, 540)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -270)
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MainFrame.Parent = ScreenGui

    local UICornerMain = Instance.new("UICorner")
    UICornerMain.CornerRadius = UDim.new(0, 25)
    UICornerMain.Parent = MainFrame

    local UIStrokeMain = Instance.new("UIStroke")
    UIStrokeMain.Color = themeColor
    UIStrokeMain.Thickness = 4
    UIStrokeMain.Parent = MainFrame

    -- Barre de titre
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 20
    TitleLabel.TextColor3 = themeColor
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Bouton de fermeture
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

    -- Menu latéral
    local SideMenu = Instance.new("Frame")
    SideMenu.Size = UDim2.new(0, 200, 1, -50)
    SideMenu.Position = UDim2.new(0, 0, 0, 50)
    SideMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SideMenu.Parent = MainFrame

    local UICornerMenu = Instance.new("UICorner")
    UICornerMenu.CornerRadius = UDim.new(0, 25)
    UICornerMenu.Parent = SideMenu

    -- Conteneur principal
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -200, 1, -50)
    ContentFrame.Position = UDim2.new(0, 200, 0, 50)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentFrame.Parent = MainFrame

    local UICornerContent = Instance.new("UICorner")
    UICornerContent.CornerRadius = UDim.new(0, 25)
    UICornerContent.Parent = ContentFrame

    -- Retourner l'interface créée
    return {
        MainFrame = MainFrame,
        SideMenu = SideMenu,
        ContentFrame = ContentFrame
    }
end

-- Ajouter un bouton dans le menu latéral
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

    return Button
end

-- Ajouter un toggle switch
function Library:AddToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 50)
    ToggleFrame.Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 60 + 10)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleFrame.Parent = parent

    local UICornerToggleFrame = Instance.new("UICorner")
    UICornerToggleFrame.CornerRadius = UDim.new(0, 12)
    UICornerToggleFrame.Parent = ToggleFrame

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Text = text
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextSize = 16
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Text = ""
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleButton.Size = UDim2.new(0.2, 0, 0.6, 0)
    ToggleButton.Position = UDim2.new(0.75, 0, 0.2, 0)
    ToggleButton.Parent = ToggleFrame

    local UICornerToggleButton = Instance.new("UICorner")
    UICornerToggleButton.CornerRadius = UDim.new(1, 0)
    UICornerToggleButton.Parent = ToggleButton

    local isActive = false
    ToggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        ToggleButton.BackgroundColor3 = isActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(60, 60, 60)
        callback(isActive)
    end)
end

return Library
