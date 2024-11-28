-- Librairie GUI Minimaliste et Fonctionnelle
local Library = {}
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local SideMenu = Instance.new("Frame")
local ContentFrame = Instance.new("ScrollingFrame")

-- Initialisation de l'interface principale
function Library:Init(title)
    ScreenGui.Name = "CustomLibraryGui"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Fenêtre principale
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)

    local UICornerMainFrame = Instance.new("UICorner")
    UICornerMainFrame.CornerRadius = UDim.new(0, 15)
    UICornerMainFrame.Parent = MainFrame

    -- Barre de titre
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.Size = UDim2.new(1, 0, 0, 50)

    Title.Name = "Title"
    Title.Parent = TitleBar
    Title.Text = title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Bouton fermer
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 20
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    CloseButton.Size = UDim2.new(0, 40, 0, 30)
    CloseButton.Position = UDim2.new(1, -50, 0.2, 0)

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Menu latéral
    SideMenu.Name = "SideMenu"
    SideMenu.Parent = MainFrame
    SideMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SideMenu.Size = UDim2.new(0, 150, 1, -50)
    SideMenu.Position = UDim2.new(0, 0, 0, 50)

    local UICornerSideMenu = Instance.new("UICorner")
    UICornerSideMenu.CornerRadius = UDim.new(0, 15)
    UICornerSideMenu.Parent = SideMenu

    -- Content Frame
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ContentFrame.Size = UDim2.new(1, -160, 1, -50)
    ContentFrame.Position = UDim2.new(0, 160, 0, 50)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
    ContentFrame.ScrollBarThickness = 5
end

-- Ajouter un bouton dans le menu
function Library:AddMenuButton(name, callback)
    local MenuButton = Instance.new("TextButton")
    MenuButton.Parent = SideMenu
    MenuButton.Text = name
    MenuButton.Font = Enum.Font.GothamBold
    MenuButton.TextSize = 18
    MenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MenuButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    MenuButton.Size = UDim2.new(1, -20, 0, 40)
    MenuButton.Position = UDim2.new(0, 10, 0, (#SideMenu:GetChildren() - 1) * 45)

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = MenuButton

    MenuButton.MouseButton1Click:Connect(callback)
end

-- Ajouter un Toggle Switch dans le ContentFrame
function Library:AddToggle(name, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = ContentFrame
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    ToggleFrame.Size = UDim2.new(1, -20, 0, 50)
    ToggleFrame.Position = UDim2.new(0, 10, 0, (#ContentFrame:GetChildren() - 1) * 55)

    local ToggleText = Instance.new("TextLabel")
    ToggleText.Parent = ToggleFrame
    ToggleText.Text = name
    ToggleText.Font = Enum.Font.GothamBold
    ToggleText.TextSize = 16
    ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleText.BackgroundTransparency = 1
    ToggleText.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleText.Position = UDim2.new(0, 10, 0, 0)

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.Text = ""
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleButton.Size = UDim2.new(0, 50, 0, 30)
    ToggleButton.Position = UDim2.new(1, -60, 0.5, -15)

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Parent = ToggleButton
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
    ToggleCircle.Position = UDim2.new(0, 5, 0.5, -10)

    local isActive = false
    ToggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        callback(isActive)
        if isActive then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            ToggleCircle.Position = UDim2.new(1, -25, 0.5, -10)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ToggleCircle.Position = UDim2.new(0, 5, 0.5, -10)
        end
    end)
end

-- Ajuster le défilement
function Library:AdjustScrolling()
    local totalHeight = 0
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + 10
        end
    end
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, ContentFrame.AbsoluteSize.Y))
end

return Library
