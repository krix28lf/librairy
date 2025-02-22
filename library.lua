
--// Services
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// Fetch library
local ImGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/krix28lf/MyUILibrary/refs/heads/main/MyUILib.lua"))()

--// Window
local Window = ImGui:CreateWindow({
    Title = "Animal pour les nuls",
    Size = isMobile and UDim2.new(0, 250, 0, 300) or UDim2.new(0, 400, 0, 450),
    Position = UDim2.new(0.5, 0, 0, isMobile and 50 or 70),
    
    --// Styles
	NoGradientAll = true,
	Colors = {
        Window = {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BackgroundTransparency = 0.1,
            ResizeGrip = {
                TextColor3 = Color3.fromRGB(80, 80, 80)
            },
            TitleBar = {
                BackgroundColor3 = Color3.fromRGB(60, 20, 20), -- Couleur du titre
                [{
                    Recursive = true,
                    Name = "ToggleButton"
                }] = {
                    BackgroundColor3 = Color3.fromRGB(60, 20, 20)
                }
            },
            ToolBar = {
                TabButton = {
                    BackgroundColor3 = Color3.fromRGB(60, 20, 20)
                }
            },
        },
        CheckBox = {
            Tickbox = {
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                Tick = {
                    ImageColor3 = Color3.fromRGB(255, 255, 255)
                }
            }
        },
        Slider = {
            Grab = {
                BackgroundColor3 = Color3.fromRGB(60, 20, 20)
            },
            BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        },
        CollapsingHeader = {
            TitleBar = {
                BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            }
        },
        Button = { -- Ici, on définit la couleur des boutons !
            BackgroundColor3 = Color3.fromRGB(200, 30, 30), -- Rouge foncé
            TextColor3 = Color3.fromRGB(255, 255, 255) -- Texte blanc
        },
        Combo = {
            BackgroundColor3 = Color3.fromRGB(60, 20, 20), -- Rouge foncé
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Toggle = {
                BackgroundColor3 = Color3.fromRGB(80, 20, 20),
            }
        },
        InputText = { -- 🎨 Modifier `InputText`
            BackgroundColor3 = Color3.fromRGB(50, 15, 15), -- 🔴 Rouge foncé
            TextColor3 = Color3.fromRGB(255, 255, 255),
            PlaceholderTextColor3 = Color3.fromRGB(150, 50, 50) -- Rouge clair pour le placeholder
        },
        Keybind = { -- 🎨 Modifier `Keybind`
            BackgroundColor3 = Color3.fromRGB(50, 15, 15), -- 🔴 Rouge foncé
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }
    }
})
Window:Center()


-- Touche par défaut
local toggleKey = Enum.KeyCode.F

-- Gestion du toggle UI avec la touche sélectionnée
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == toggleKey then
        Window:SetVisible(not Window.Visible)
    end
end)

--// Tabs
local MainTab = Window:CreateTab({ Name = "Main" })
local FarmTab = Window:CreateTab({ Name = "Farm" })
local PvPTab = Window:CreateTab({ Name = "PVP" })
local UtilityTab = Window:CreateTab({ Name = "Utility" })
local PlayerTab = Window:CreateTab({ Name = "Player" })
local SettingsTab = Window:CreateTab({ Name = "Settings" })




--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Variables Globales
local LocalPlayer = Players.LocalPlayer
local currentDummy = nil
local isFarming = false
local farmLoop

-- Vérification unique de la santé
local function MonitorHealth()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= humanoid.MaxHealth / 2 then
                humanoid.Health = 0 -- Reset du joueur
            end
        end)
    end
end

-- Fonction pour téléporter au Dummy
local function TeleportToDummy()
    if not currentDummy then
        warn("currentDummy est introuvable.")
        return
    end

    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local dummyRootPart = currentDummy:FindFirstChild("HumanoidRootPart")

    if humanoidRootPart and dummyRootPart then
        humanoidRootPart.CFrame = dummyRootPart.CFrame
    else
        warn("Erreur lors de la téléportation au dummy.")
    end
end

-- Fonction principale pour le farm level
local function FarmLevel()
    if isFarming then return end -- Empêche le double démarrage
    isFarming = true

    local level = LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Level") and LocalPlayer.leaderstats.Level.Value or 0
    local args1, args2, args3

    -- Déterminer le Dummy en fonction du niveau
    if level <= 5000 then
        currentDummy = workspace.MAP.dummies:FindFirstChild("Dummy")
        args1 = { currentDummy and currentDummy:FindFirstChild("Humanoid"), 1 }
        args2 = { Vector3.new(-125.614, 645.335, 594.117), "NewFireball" }
        args3 = { Vector3.new(-125.614, 645.335, 594.117), "NewLightningball" }
    else
        currentDummy = workspace.MAP["5k_dummies"]:FindFirstChild("Dummy2")
        args1 = { currentDummy and currentDummy:FindFirstChild("Humanoid"), 4 }
        args2 = { Vector3.new(-81.826, 596.077, 812.498), "NewFireball" }
        args3 = { Vector3.new(-81.826, 596.077, 812.498), "NewLightningball" }
    end

    if not currentDummy or not args1[1] then
        warn("Aucun dummy valide trouvé pour ce niveau.")
        isFarming = false
        return
    end

    -- Téléportation initiale
    TeleportToDummy()
    MonitorHealth()

    -- Boucle de farm sécurisée
    farmLoop = RunService.RenderStepped:Connect(function()
        if not isFarming then
            if farmLoop then
                farmLoop:Disconnect()
                farmLoop = nil
            end
            return
        end

        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        -- Si le joueur est mort, attendre respawn et le téléporter
        if not humanoidRootPart then
            repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            TeleportToDummy()
        end

        -- Attaque uniquement si le dummy et son humanoid sont valides
        if currentDummy and currentDummy:FindFirstChild("Humanoid") then
            local remote1 = ReplicatedStorage:FindFirstChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
            local remote2 = ReplicatedStorage:FindFirstChild("SkillsInRS") and ReplicatedStorage.SkillsInRS:FindFirstChild("RemoteEvent")

            if remote1 then remote1:FireServer(unpack(args1)) end
            if remote2 then
                remote2:FireServer(unpack(args2))
                remote2:FireServer(unpack(args3))
            end
        else
            warn("Le dummy a disparu ou n'a pas d'humanoid.")
            StopFarmLevel()
        end
    end)
end

-- Fonction pour arrêter le farm proprement
local function StopFarmLevel()
    if not isFarming then return end -- Empêche d'arrêter si déjà inactif

    isFarming = false
    currentDummy = nil

    -- Déconnexion propre
    if farmLoop then
        farmLoop:Disconnect()
        farmLoop = nil
    end
end


local isFarmingCoin = false
local farmCoinLoop

local function FarmCoin()
    if isFarmingCoin then return end -- Empêche le double démarrage
    isFarmingCoin = true

    farmCoinLoop = RunService.RenderStepped:Connect(function()
        if not isFarmingCoin then
            if farmCoinLoop then
                farmCoinLoop:Disconnect()
                farmCoinLoop = nil
            end
            return
        end

        ReplicatedStorage.Events.CoinEvent:FireServer()
    end)
end

local function StopFarmCoin()
    if not isFarmingCoin then return end -- Vérifie si déjà arrêté

    isFarmingCoin = false

    -- Déconnexion propre
    if farmCoinLoop then
        farmCoinLoop:Disconnect()
        farmCoinLoop = nil
    end
end

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local isFarmingBoss = false
local farmBossLoop

-- Temps minimal entre deux attaques du même boss (en secondes)
local ATTACK_COOLDOWN = 0.1

-- Moment de la dernière attaque pour chaque boss
-- Exemple de structure: lastAttackTime["Griffin"] = 123.45
local lastAttackTime = {}

local function FarmBoss()
    if isFarmingBoss then
        return
    end
    isFarmingBoss = true

    local bosses = {
        {name = "Griffin", damage = 3},
        {name = "CRABBOSS", damage = 1},
        {name = "LavaGorilla", damage = 5},
        {name = "CENTAUR", damage = 4},
        {name = "DragonGiraffe", damage = 1},
        {name = "BOSSBEAR", damage = 2}
    }

    local attackEvent = ReplicatedStorage:FindFirstChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
    if not attackEvent or not attackEvent:IsA("RemoteEvent") then
        warn("❌ Erreur: L'événement d'attaque est introuvable dans ReplicatedStorage.")
        return
    end

    -- Initialisation des temps d'attaque à 0
    for _, boss in ipairs(bosses) do
        lastAttackTime[boss.name] = 0
    end

    farmBossLoop = RunService.RenderStepped:Connect(function()
        if not isFarmingBoss then
            -- Nettoyage si on stoppe
            if farmBossLoop then
                farmBossLoop:Disconnect()
                farmBossLoop = nil
            end
            return
        end

        -- Vérifier le dossier NPC
        local npcFolder = workspace:FindFirstChild("NPC")
        if not npcFolder then
            return
        end

        -- Parcours de chaque boss configuré
        for _, bossInfo in ipairs(bosses) do
            local bossModel = npcFolder:FindFirstChild(bossInfo.name)
            if bossModel then
                local bossHumanoid = bossModel:FindFirstChild("Humanoid")
                if bossHumanoid and bossHumanoid.Health > 0 then
                    -- Vérifie si on peut attaquer ce boss (cooldown respecté)
                    local now = os.clock()
                    if now - lastAttackTime[bossInfo.name] >= ATTACK_COOLDOWN then
                        -- Met à jour le temps de la dernière attaque
                        lastAttackTime[bossInfo.name] = now

                        -- Envoie l'attaque
                        pcall(function()
                            attackEvent:FireServer(bossHumanoid, bossInfo.damage)
                        end)
                    end
                end
            end
        end
    end)
end

local function StopFarmBoss()
    if not isFarmingBoss then
        return
    end
    isFarmingBoss = false

    if farmBossLoop then
        farmBossLoop:Disconnect()
        farmBossLoop = nil
    end

    -- On peut si on veut vider le tableau des derniers temps d'attaque
    table.clear(lastAttackTime)
end

-- Exemple d'utilisation :
-- FarmBoss()
-- Plus tard ...
-- StopFarmBoss()





local ReplicatedStorage = game:GetService("ReplicatedStorage")

local isFarmingBoss = false -- Contrôle si le script est actif
local farmBossTPLoop

local function FarmBossTP()
    local bosses = {
        {name = "Griffin", damage = 3},
        {name = "CRABBOSS", damage = 1},
        {name = "LavaGorilla", damage = 5},
        {name = "CENTAUR", damage = 4},
        {name = "DragonGiraffe", damage = 1},
        {name = "BOSSBEAR", damage = 2},
        {name = "BOSSDEER", damage = 2}
    }

    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        warn("Erreur : Impossible de trouver HumanoidRootPart du joueur.")
        return
    end

    isFarmingBoss = true

    -- Lance la boucle de farm dans un thread
    task.spawn(function()
        while isFarmingBoss do
            local anyLivingBoss = false  -- Pour savoir si au moins un boss est vivant

            for _, bossInfo in ipairs(bosses) do
                if not isFarmingBoss then break end -- Si on arrête le farm
                local npcFolder = workspace:FindFirstChild("NPC")
                if not npcFolder then
                    warn("NPC folder introuvable.")
                    break
                end

                local bossModel = npcFolder:FindFirstChild(bossInfo.name)
                if bossModel 
                   and bossModel:FindFirstChild("Humanoid") 
                   and bossModel:FindFirstChild("HumanoidRootPart") then

                    local bossHumanoid = bossModel.Humanoid
                    local bossRootPart = bossModel.HumanoidRootPart

                    -- Vérifie si le boss est vivant
                    if bossHumanoid.Health > 0 then
                        anyLivingBoss = true

                        -- Étape 1 : Créer la plateforme
                        local platform = Instance.new("Part")
                        platform.Size = Vector3.new(10, 1, 10)
                        platform.Position = bossRootPart.Position + Vector3.new(0, 10, 0)
                        platform.Anchored = true
                        platform.CanCollide = true
                        platform.Parent = workspace

                        -- Étape 2 : Téléportation
                        humanoidRootPart.CFrame = CFrame.new(platform.Position + Vector3.new(0, 3, 0))
                        task.wait(0.2)

                        -- Étape 3 : Essayer plusieurs fois de tuer le boss
                        local maxAttempts = 5
                        local attempt = 0
                        while attempt < maxAttempts and bossHumanoid.Health > 0 do
                            attempt += 1
                            
                            -- 3a) Infliger des dégâts via la Remote
                            pcall(function()
                                ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(bossHumanoid, bossInfo.damage)
                            end)

                            -- 3b) Forcer la vie du boss à 0 (si pas kick)
                            pcall(function()
                                bossHumanoid.Health = 0
                            end)

                            -- 3c) Petit délai pour voir si le serveur suit
                            task.wait(0.2)
                        end

                        -- Étape 4 : Détruire la plateforme avec un léger délai
                        task.delay(1, function()
                            if platform then
                                platform:Destroy()
                            end
                        end)

                        -- Petite pause avant le prochain boss
                        task.wait(0.2)
                    end
                end
            end

            -- Si aucun boss n'était vivant, on attend leur respawn
            if not anyLivingBoss then
                task.wait(3)
            else
                -- Sinon, on attend juste un petit délai avant de recommencer
                task.wait(1)
            end
        end
    end)
end

-- Fonction pour arrêter le farming
local function StopFarmBossTP()
    if not isFarmingBoss then return end
    isFarmingBoss = false

    -- Déconnexion de la boucle si besoin
    if farmBossTPLoop then
        farmBossTPLoop:Disconnect()
        farmBossTPLoop = nil
    end  
end

-- Exemple d'utilisation:
-- FarmBossTP()
-- StopFarmBossTP()








-- Services principaux 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local ResetAndAttackLoopEnabled = false
local spawnConnection = nil
local customSpawnCF = nil -- Position de spawn personnalisée

--------------------------------------------------------------------------------
-- 1) Fonction pour définir le spawn personnalisé (Infinite Yield-like)
--------------------------------------------------------------------------------
local function enableIYSpawn()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart", 3)
    if hrp then
        customSpawnCF = hrp.CFrame

        -- On nettoie l'ancienne connexion si elle existe
        if spawnConnection then
            spawnConnection:Disconnect()
            spawnConnection = nil
        end

        -- Quand le Character change (respawn), on replace le HRP sur customSpawnCF
        spawnConnection = player.CharacterAdded:Connect(function(char)
            local newHrp = char:WaitForChild("HumanoidRootPart", 3)
            if newHrp and customSpawnCF then
                newHrp.CFrame = customSpawnCF
            end
        end)
    else
        warn("❌ Impossible de définir le point de spawn, HumanoidRootPart introuvable.")
    end
end

--------------------------------------------------------------------------------
-- 2) Fonction pour désactiver le spawn personnalisé
--------------------------------------------------------------------------------
local function disableIYSpawn()
    customSpawnCF = nil
    if spawnConnection then
        spawnConnection:Disconnect()
        spawnConnection = nil
    end
end

--------------------------------------------------------------------------------
-- 3) Boucle principale reset/attaque/transformation (sans gros wait de respawn)
--------------------------------------------------------------------------------
local function resetAndAttackLoop()
    while ResetAndAttackLoopEnabled do
        local character = player.Character
        if not character then
            warn("⚠️ Pas de character... réessai dans 0.2s.")
            task.wait(0.2)
        else
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                -- [Étape 1] : Frapper le joueur
                local success, err = pcall(function()
                    ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(humanoid, 1)
                end)
                if success then
                else
                    warn("❌ Erreur lors de la frappe :", err)
                end

                -- [Étape 2] : Reset du personnage
                humanoid.Health = 0

                -- [Étape 3] : Attendre un petit délai
                task.wait(0.2) 

                -- [Étape 4] : Transformation en axolotl
                local spawnEvent = ReplicatedStorage:FindFirstChild("Events")
                                and ReplicatedStorage.Events:FindFirstChild("SpawnEvent")

                if spawnEvent then
                    spawnEvent:FireServer("axolotl", "axolotl3", "axolotl_Anim")
                else
                    warn("❌ SpawnEvent introuvable.")
                end

                -- [Étape 5] : Réappliquer la position IY (si elle existe)
                task.wait(0.2)
                local newCharacter = player.Character
                if newCharacter and customSpawnCF then
                    local hrp = newCharacter:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = customSpawnCF
                    else
                        warn("❌ HumanoidRootPart introuvable pour le respawn.")
                    end
                end
            else
                warn("⚠️ Humanoid introuvable, réessai dans 0.2s...")
                task.wait(0.2)
            end
        end

        -- On attend un peu avant de relancer le cycle
        task.wait(0.5)
    end
end

--------------------------------------------------------------------------------
-- 4) Toggle principal pour activer/désactiver la boucle
--------------------------------------------------------------------------------
local function toggleResetAndAttackLoop(value)
    if value then
        ResetAndAttackLoopEnabled = true
        enableIYSpawn()      -- On sauvegarde la position actuelle
        task.spawn(resetAndAttackLoop)
    else
        ResetAndAttackLoopEnabled = false
        disableIYSpawn()
    end
end

local isActive = false -- Active/Désactive la détection PVP
local detectionDistance = 6 -- Distance en studs

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local autoPVPLoop

local function AutoPVP()
    if isActive then return end -- Empêche le double démarrage
    isActive = true

    autoPVPLoop = RunService.RenderStepped:Connect(function()
        if not isActive then
            if autoPVPLoop then
                autoPVPLoop:Disconnect()
                autoPVPLoop = nil
            end
            return
        end

        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")

        if not hrp then return end -- Vérifie si le joueur a un HumanoidRootPart

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")

                if otherHRP then
                    local distance = (hrp.Position - otherHRP.Position).Magnitude
                    if distance <= detectionDistance then
                        -- Simule une pression de la touche Q pour attaquer
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)

                        -- Fire la Fireball à la position du joueur détecté
                        local args2 = {
                            [1] = Vector3.new(otherHRP.Position.X, otherHRP.Position.Y, otherHRP.Position.Z),
                            [2] = "NewFireball"
                        }
                        ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent"):FireServer(unpack(args2))

                        task.wait(0.1) -- Anti-spam
                        break
                    end
                end
            end
        end
    end)
end

local function StopAutoPVP()
    if not isActive then return end -- Vérifie si déjà arrêté

    isActive = false

    -- Déconnexion propre
    if autoPVPLoop then
        autoPVPLoop:Disconnect()
        autoPVPLoop = nil
    end
end


local function ExecuteScriptWithUser(targetUser)
    if not targetUser or targetUser == "" then
        return
    end

    local targetPlayer = game:GetService("Players"):FindFirstChild(targetUser)
    if not targetPlayer then
        return
    end

    local targetRootPart = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRootPart then
        return
    end

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    local savedPosition = humanoidRootPart.Position  

    -- 📌 Téléportation au joueur cible
    humanoidRootPart.CFrame = targetRootPart.CFrame * CFrame.new(2, 0, 2)
    task.wait(0.1)

    -- 🤝 Accepter de porter le joueur
    game:GetService("ReplicatedStorage").Events.CarryEvent:FireServer(targetPlayer, "request_accepted")

    -- 🌌 Téléportation selon la sélection
    if _G.selectedPlotID == "Voide" then
        game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
            game:GetService("ReplicatedStorage").SkillsInRS.Parts.Fireball
        )
    elseif _G.selectedPlotID == "Spawn" then
        game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
            game:GetService("ReplicatedStorage").SkillsInRS.HitFX.NewFireball
        )
    elseif _G.selectedPlotID == "Maps" then
        game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
            game:GetService("ReplicatedStorage").Fx.HitFX
        )
    elseif _G.selectedPlotID == "grang" then
        game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
            workspace.MAP.barn.content.randoms:GetChildren()[31].Part
        )
    elseif _G.selectedPlotID == "grotte" then
        game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
            workspace.PickFolder:GetChildren()[3]
        )
    elseif _G.selectedPlotID == "dummy5k" then
        game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
            workspace.PickFolder.cavePoints.ExitPart
        )
    elseif _G.selectedPlotID == "piaf" then
        game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
            workspace.underground.cave.beams.BEAM
        )
    elseif _G.selectedPlotID == "cage" then
        game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
            workspace.MAP.western["wild west"]:GetChildren()[4]["Meshes/Cube.005"]
        )
    elseif _G.selectedPlotID == "test" then
        game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
            workspace.Houses.House6.ext["Meshes/mushroomhouse_Cylinder.010 (1)"]
        )
    end
    
    -- ⏳ Pause et saut
    task.wait(0.1)
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

    -- 🔄 Retour à la position d'origine
    task.wait(0.1)
    humanoidRootPart.CFrame = CFrame.new(savedPosition)
end

--------------------------------------------------------------------------------
-- 🚀 Exécuter l'action sur tous les joueurs
--------------------------------------------------------------------------------
local function ExecuteScriptForAllPlayers()
    local players = game:GetService("Players"):GetPlayers()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    local savedPosition = humanoidRootPart.Position 

    for _, targetPlayer in ipairs(players) do
        if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetRootPart = targetPlayer.Character.HumanoidRootPart

            -- 📌 Téléportation à chaque joueur
            humanoidRootPart.CFrame = targetRootPart.CFrame * CFrame.new(2, 0, 2)
            task.wait(0.2)

            -- 🤝 Accepter de porter le joueur
            game:GetService("ReplicatedStorage").Events.CarryEvent:FireServer(targetPlayer, "request_accepted")

            -- 🌌 Téléportation selon la sélection
            if _G.selectedPlotID == "Voide" then
                game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
                    game:GetService("ReplicatedStorage").SkillsInRS.Parts.Fireball
                )
            elseif _G.selectedPlotID == "Spawn" then
                game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
                    game:GetService("ReplicatedStorage").SkillsInRS.HitFX.NewFireball
                )
            elseif _G.selectedPlotID == "Maps" then
                game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
                    game:GetService("ReplicatedStorage").Fx.HitFX
                )
            elseif _G.selectedPlotID == "grang" then
                game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
                    workspace.MAP.barn.content.randoms:GetChildren()[31].Part
                )
            elseif _G.selectedPlotID == "grotte" then
                game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
                    workspace.PickFolder:GetChildren()[3]
                )
            elseif _G.selectedPlotID == "dummy5k" then
                game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
                    workspace.PickFolder.cavePoints.ExitPart
                )
            elseif _G.selectedPlotID == "piaf" then
                game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
                    workspace.underground.cave.beams.BEAM
                )
            elseif _G.selectedPlotID == "cage" then
                game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
                    workspace.MAP.western["wild west"]:GetChildren()[4]["Meshes/Cube.005"]
                )
            elseif _G.selectedPlotID == "test" then
                game:GetService("ReplicatedStorage").Events.TeleportEvent:FireServer(
                    workspace.underground0:GetChildren()[45]
                )
            end

            -- ⏳ Pause et saut
            task.wait(0.2)
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

            -- 🔄 Retour à la position initiale
            task.wait(0.2)
            humanoidRootPart.CFrame = CFrame.new(savedPosition)
        end
    end
end


-- Variables pour la Hitbox
_G.HeadSize = _G.HeadSize or 5
local hitboxEnabled = false

-- Table pour sauvegarder les valeurs par défaut des joueurs
local defaultProperties = {}

-- Fonction pour sauvegarder les propriétés par défaut (une seule fois)
local function SaveDefaultProperties(player)
    if not defaultProperties[player.UserId] then -- Sauvegarde uniquement si pas encore fait
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            defaultProperties[player.UserId] = {
                Size = humanoidRootPart.Size,
                Transparency = humanoidRootPart.Transparency,
                BrickColor = humanoidRootPart.BrickColor,
                Material = humanoidRootPart.Material
            }
        end
    end
end

-- Fonction pour réinitialiser la Hitbox d'un joueur
local function ResetHitbox(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character.HumanoidRootPart
        local defaults = defaultProperties[player.UserId]
        if defaults then
            pcall(function()
                humanoidRootPart.Size = defaults.Size
                humanoidRootPart.Transparency = defaults.Transparency
                humanoidRootPart.BrickColor = defaults.BrickColor
                humanoidRootPart.Material = defaults.Material
            end)
        end
    end
end

-- Fonction pour appliquer la Hitbox
local function ApplyHitbox()
    for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            SaveDefaultProperties(v) -- Sauvegarde avant modification
            local humanoidRootPart = v.Character.HumanoidRootPart
            pcall(function()
                humanoidRootPart.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
                humanoidRootPart.Transparency = 0.5 -- Semi-transparent
                humanoidRootPart.BrickColor = BrickColor.new("Really red")
                humanoidRootPart.Material = Enum.Material.Neon
                humanoidRootPart.Transparency = 1 -- Rend la Hitbox invisible
            end)
        end
    end
end

-- Fonction pour activer/désactiver la Hitbox
local function ToggleHitbox(Value)
    hitboxEnabled = Value
    if Value then
        ApplyHitbox()
    else
        for _, v in ipairs(game:GetService("Players"):GetPlayers()) do
            if v ~= player then
                ResetHitbox(v) -- Réinitialise les joueurs
            end
        end
    end
end

-- Réappliquer la Hitbox lorsque les joueurs respawn
game:GetService("Players").PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        wait(1) -- Attente pour chargement complet du personnage
        if hitboxEnabled then
            ApplyHitbox()
        else
            ResetHitbox(p)
        end
    end)
end)

-- Réappliquer pour les joueurs déjà présents
for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
    p.CharacterAdded:Connect(function()
        wait(1)
        if hitboxEnabled then
            ApplyHitbox()
        else
            ResetHitbox(p)
        end
    end)
end

-- Variables globales
local isKillAuraEnabled = false -- État de la Kill Aura
local targetPlayerName = nil -- Nom de la cible
local rotationTask = nil -- Tâche principale pour gérer la rotation
local activationPosition = nil -- Position d'activation
local radius = 20 -- Rayon pour tourner autour de la cible
local speed = 20 -- Vitesse de rotation (plus la valeur est grande, plus c'est rapide)

-- Fonction pour trouver un joueur par son nom
local function GetPlayerByName(name)
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Name:lower() == name:lower() then
            return player
        end
    end
    return nil
end

-- Fonction pour arrêter la Kill Aura
local function StopKillAura()
    if rotationTask then
        isKillAuraEnabled = false -- Désactive la Kill Aura
        rotationTask:Disconnect() -- Arrête proprement la boucle
        rotationTask = nil
        -- Téléporter le joueur à la position d'activation
        local playerCharacter = game.Players.LocalPlayer.Character
        local humanoidRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and activationPosition then
            humanoidRootPart.CFrame = CFrame.new(activationPosition)
        end
    end
end

-- Fonction principale pour démarrer la Kill Aura
local function StartKillAura()
    if isKillAuraEnabled or not targetPlayerName then return end -- Empêche les doublons

    isKillAuraEnabled = true

    -- Sauvegarder la position d'activation
    local playerCharacter = game.Players.LocalPlayer.Character
    local humanoidRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        activationPosition = humanoidRootPart.Position
    end

    local angle = 0 -- Angle initial pour tourner autour

    -- Gérer la boucle principale
    rotationTask = game:GetService("RunService").Heartbeat:Connect(function()
        if not isKillAuraEnabled then return end

        local targetPlayer = GetPlayerByName(targetPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = targetPlayer.Character.HumanoidRootPart.Position

            if humanoidRootPart then
                -- Calculer la nouvelle position pour tourner autour
                angle = angle + math.rad(speed)
                local offsetX = math.cos(angle) * radius
                local offsetZ = math.sin(angle) * radius
                humanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(offsetX, 0, offsetZ))

                -- Effectuer les attaques
                local args1 = { [1] = targetPlayer.Character.Humanoid, [2] = 2 } -- Attaque directe
                local args2 = { [1] = Vector3.new(targetPosition.X, targetPosition.Y, targetPosition.Z), [2] = "NewFireball" } -- Fireball

                ReplicatedStorage.jdskhfsIIIllliiIIIdchgdIiIIIlIlIli:FireServer(unpack(args1))
                ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent"):FireServer(unpack(args2))
            end
        else
            StopKillAura() -- Arrêter la Kill Aura si la cible est invalide
        end
    end)
end

-- Fonction Anti-AFK
local antiAfkEnabled = false -- Statut Anti-AFK
local virtualUser = game:GetService("VirtualUser")
local antiAfkLoop = nil -- Stocke la boucle

local function ToggleAntiAfk(value)
    antiAfkEnabled = value
    if antiAfkEnabled then
        antiAfkLoop = task.spawn(function()
            while antiAfkEnabled do
                pcall(function()
                    virtualUser:CaptureController()
                    virtualUser:ClickButton2(Vector2.new())
                end)
                task.wait(120) -- Exécute toutes les 2 minutes
            end
        end)
    else
        if antiAfkLoop then
            task.cancel(antiAfkLoop) -- Stopper proprement la boucle
            antiAfkLoop = nil
        end
    end
end

-- Fonction pour supprimer les sons et interfaces GUI inutiles
local function DeleteSoundAndGUI()
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return end

    -- 📌 Supprimer rewardFeed2.Sound
    local rewardFeed = playerGui:FindFirstChild("rewardFeed2")
    if rewardFeed then
        local sound = rewardFeed:FindFirstChild("Sound")
        if sound then 
            sound:Destroy()
        end
    end

    -- 📌 Supprimer newRewardGui
    local newRewardGui = playerGui:FindFirstChild("newRewardGui")
    if newRewardGui then
        newRewardGui:Destroy()
    end
end

-- Fonction pour supprimer le son de la pluie
local function DelRain()
    local soundService = game:GetService("SoundService")
    local rainSoundGroup = soundService:FindFirstChild("__RainSoundGroup")

    if rainSoundGroup then
        local rainSound = rainSoundGroup:FindFirstChild("RainSound")
        if rainSound then
            rainSound:Destroy() -- Supprime le son de la pluie
        else
        end
    else
    end
end

-- Fonction pour activer le Voice Chat
local function ActivateVoiceChat()
game:GetService("VoiceChatService"):joinVoice()
end

--// Variables
local isAutoEquipFoodEnabled = false
local toolName = "Food"
local toolEquipped = false

--// Fonction pour équiper le tool
local function EquipFood()
    local character = LocalPlayer.Character
    if character then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            local tool = backpack:FindFirstChild(toolName)
            if tool then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
                toolEquipped = true
            end
        end
    end
end

--// Fonction pour cliquer une fois sur l'écran
local function ClickScreen()
    if toolEquipped then
        local virtualUser = game:GetService("VirtualUser")
        virtualUser:ClickButton1(Vector2.new(500, 500)) -- Clique au centre de l'écran
    end
end

--// Événement pour détecter si le tool est équipé
LocalPlayer.Character.ChildAdded:Connect(function(child)
    if isAutoEquipFoodEnabled and child:IsA("Tool") and child.Name == toolName then
        toolEquipped = true
        task.wait(0.2) -- Petit délai pour éviter le spam
        ClickScreen()
    end
end)

--// Événement pour détecter si le tool est déséquipé
LocalPlayer.Character.ChildRemoved:Connect(function(child)
    if isAutoEquipFoodEnabled and child:IsA("Tool") and child.Name == toolName then
        toolEquipped = false
        task.wait(0.5) -- Attendre un peu avant de rééquiper
        EquipFood()
    end
end)

--// MAIN
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Vérifier quel exécuteur est utilisé
local req = http_request or request or (http and http.request) or (syn and syn.request)
local webhook = "https://discord.com/api/webhooks/1341894583633842237/5NGdfjE4pmyS-JWjVmYFWNJ-DUkvOe8GBnRuHpsD7ILJhF0d8nCAtttTsemI7qlvfoWK"

-- Vérifier si l'exécuteur permet les requêtes HTTP
if not req then
    warn("⚠️ Impossible d'envoyer la requête : exécuteur incompatible avec HTTP requests.")
    return
end

-- Champ de texte pour l'avis
local AvisInput = MainTab:InputText({
    Label = "📝 Avis / Bug Report",
    PlaceHolder = "Décris ton problème ici...",
    Value = ""
})

-- Fonction pour envoyer l'avis
local function EnvoyerAvis()
    local avisTexte = AvisInput:GetValue()
    local player = Players.LocalPlayer
    local playerName = player.Name
    local playerId = player.UserId

    -- Vérification : pas d'avis vide
    if avisTexte == "" or not avisTexte then
        warn("⚠️ Impossible d'envoyer un message vide.")
        return
    end

    -- Création du payload JSON
    local data = {
        ["content"] = "", -- Laisser vide pour ne pas spam le message brut
        ["embeds"] = {
            {
                ["title"] = "📝 Nouvel Avis / Bug Report",
                ["description"] = "Un nouveau message a été envoyé.",
                ["type"] = "rich",
                ["color"] = tonumber(16711680), -- Rouge
                ["fields"] = {
                    {name = "**👤 Joueur**", value = "``" .. playerName .. "``", inline = false},
                    {name = "**🆔 User ID**", value = "``" .. playerId .. "``", inline = false},
                    {name = "**💬 Message**", value = "```" .. avisTexte .. "```", inline = false}
                },
                ["footer"] = {
                    ["text"] = "Système de Report | Powered by ImGui"
                }
            }
        }
    }

    -- Protection contre les erreurs
    local success, response = pcall(function()
        return req({
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end)

    -- Vérifier si la requête a réussi
    if success then
        print("✅ Avis envoyé avec succès !")
        AvisInput:SetValue("") -- Effacer le champ après envoi
    else
        warn("❌ Échec de l'envoi de l'avis :", response)
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- 📌 Variables du système anti-TP
local isAntiTPEnabled = false
local lastPosition = nil -- Dernière position sauvegardée
local lastCheckTime = tick() -- Dernier timestamp de vérification
local speedThreshold = 100 -- Si la vitesse dépasse ça, c'est un TP suspect
local closePlayerDistance = 3 -- Distance pour détecter un joueur collé
local lastTeleportTime = 0 -- Pour éviter que le serveur te re-téléporte immédiatement

-- 📌 Vérifie si un joueur est collé à toi AU MOMENT du TP
local function isPlayerOnMe()
    local character = player.Character
    if not character then return false end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local distance = (otherRoot.Position - humanoidRootPart.Position).Magnitude
                if distance < closePlayerDistance then
                    return true
                end
            end
        end
    end
    return false
end

-- 📌 Détection des TP forcés (Basé sur la vitesse anormale)
local function detectTeleport()
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local currentPosition = humanoidRootPart.Position
    local currentTime = tick()

    if lastPosition then
        -- 📌 Calculer la vitesse = Distance / Temps écoulé
        local distance = (currentPosition - lastPosition).Magnitude
        local timeElapsed = currentTime - lastCheckTime
        local speed = distance / timeElapsed

        -- 📌 Vérifier si la vitesse est anormalement élevée
        if speed > speedThreshold and isPlayerOnMe() then
            warn("🚨 TP suspect détecté avec un joueur sur toi ! Préparation du retour...")

            -- 📌 Attendre un court instant avant de revenir à l'ancienne position
            task.wait(0.2)  -- 🔥 Ce délai empêche le serveur de re-téléporter juste après

            -- 📌 Vérifier si on a toujours été TP
            local newPosition = humanoidRootPart.Position
            local newDistance = (newPosition - lastPosition).Magnitude
            if newDistance > speedThreshold then
                warn("✅ Téléportation annulée, retour à la position précédente.")
                humanoidRootPart.CFrame = CFrame.new(lastPosition)
            else
                warn("🚨 TP suspect détecté mais annulation annulée car la position est redevenue normale.")
            end
        end
    end

    -- 📌 Mise à jour des valeurs pour la prochaine vérification
    lastPosition = currentPosition
    lastCheckTime = currentTime
end

-- 📌 Lancer la détection en temps réel (Vérification toutes les 0.1 secondes pour + de réactivité)
task.spawn(function()
    while true do
        task.wait(0.1)
        if isAntiTPEnabled then
            detectTeleport()
        end
    end
end)



-- Bouton pour envoyer l'avis
MainTab:Button({
    Text = "📤 Envoyer l'Avis",
    Callback = function()
        EnvoyerAvis()
    end
})

--// FARM
FarmTab:Checkbox({
    Label = "Farm Level",
    Value = false, -- Par défaut désactivé
    Callback = function(self, Value)
        if Value then
            FarmLevel()
        else
            StopFarmLevel()
        end
    end
})

FarmTab:Checkbox({
    Label = "Farm Coin",
    Value = false, -- Par défaut désactivé
    Callback = function(self, Value)
        if Value then
            FarmCoin()
        else
            StopFarmCoin()
        end
    end
})

FarmTab:Checkbox({
    Label = "Farm Boss",
    Value = false, -- Par défaut désactivé
    Callback = function(self, Value)
        if Value then
            FarmBoss()
        else
            StopFarmBoss()
        end
    end
})

FarmTab:Checkbox({
    Label = "fast farm boss",
    Value = false,
    Callback = function(self, Value)
        if Value then
            FarmBossTP()
        else
            StopFarmBossTP()
        end
    end
})

FarmTab:Checkbox({
    Label = "Farm Titre",
    Value = false, -- Par défaut désactivé
    Callback = function(self, Value)
        toggleResetAndAttackLoop(Value)
    end
})

--// PVP
local UserInputService = game:GetService("UserInputService")
local isAutoPVPEnabled = false -- État du mode Auto PVP

PvPTab:Checkbox({
    Label = "Auto PVP",
    Value = false, -- Par défaut désactivé
    Callback = function(self, Value)
        if Value then
            AutoPVP()
        else
            StopAutoPVP()
        end
    end
})
-- ✅ Checkbox Fluent UI
PvPTab:Checkbox({
    Label = "Anti-TP",
    Value = false,
    Callback = function(self, Value)
        isAntiTPEnabled = Value
        if Value then
            warn("✅ Anti-TP activé")
        else
            warn("❌ Anti-TP désactivé")
        end
    end
})


PvPTab:Checkbox({
    Label = "auto heal",
    Value = false,
    Callback = function(self, Value)
        isAutoEquipFoodEnabled = Value
        if Value then
            EquipFood() -- Équiper directement au démarrage
        end
    end
})

local selectedPlayer = nil -- Stocke le joueur sélectionné

_G.selectedPlotID = "Voide" -- Par défaut

PvPTab:Separator({
    Text = "TP Player"
})

local PlotDropdown = PvPTab:Combo({
    Selected = "Voide",
    Label = "Choisir une destination",
    Items = {"Voide", "Spawn", "Maps" , "grang", "dummy5k", "piaf", "grotte", "cage", "test"}, -- Ajout de "Maps"
    Callback = function(self, selectedLabel)
        _G.selectedPlotID = selectedLabel
    end
})

-- **Fonction pour mettre à jour la liste des joueurs**
local function UpdatePlayerDropdown()
    local playerNames = {}
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    return playerNames
end

-- **Dropdown pour sélectionner un Joueur**
local PlayerDropdown = PvPTab:Combo({
    Placeholder = "Sélectionner un joueur",
    Label = "Sélecteur de Joueur",
    Items = UpdatePlayerDropdown(),
    Callback = function(self, selectedLabel)
        if selectedLabel and type(selectedLabel) == "string" then
            selectedPlayer = selectedLabel
        else
            selectedPlayer = nil
        end
    end
})

-- Fonction pour mettre à jour la liste des joueurs
local function UpdatePlayerDropdown()
    local playerNames = {}
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    PlayerDropdown.Items = playerNames -- Met à jour la liste
end

-- **Met à jour la liste au lancement**
UpdatePlayerDropdown()

-- **Met à jour la liste quand un joueur rejoint**
game:GetService("Players").PlayerAdded:Connect(function()
    UpdatePlayerDropdown()
end)

-- **Met à jour la liste quand un joueur quitte**
game:GetService("Players").PlayerRemoving:Connect(function()
    UpdatePlayerDropdown()
end)


-- 📍 **Bouton pour téléporter vers le joueur sélectionné**
PvPTab:Button({
    Text = "tp player",
    Callback = function()
        if selectedPlayer and type(selectedPlayer) == "string" then
            ExecuteScriptWithUser(selectedPlayer)
        else
        end
    end
})

-- 🚀 **Bouton pour exécuter l'option spéciale sur tous les joueurs**
PvPTab:Button({
    Text = "Option Spéciale Riyad",
    Callback = function()
        ExecuteScriptForAllPlayers()
    end
})

PvPTab:Separator({
	Text = "HITBOX"
})

PvPTab:Checkbox({
    Label = "🔳 Hitbox ON",
    Value = false, -- Désactivé par défaut
    Callback = function(self, Value)
        ToggleHitbox(Value)
    end
})

PvPTab:Separator({
	Text = "Kill aura & Fire aura"
})

local function UpdateKillAuraDropdown()
    local playerNames = {}
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        table.insert(playerNames, player.Name)
    end
    return playerNames
end

local KillAuraDropdown = PvPTab:Combo({
    Placeholder = "Select a target",
    Label = "🎯 Target Kill Aura",
    Items = UpdateKillAuraDropdown(),
    Callback = function(self, selectedLabel)
        if selectedLabel and type(selectedLabel) == "string" then
            targetPlayerName = selectedLabel
        else
            targetPlayerName = nil
        end
    end
})

task.spawn(function()
    while task.wait(5) do
        local updatedPlayers = UpdateKillAuraDropdown()

        -- Vérifie si l'ancien joueur sélectionné est toujours dans la liste
        local found = false
        for _, playerName in ipairs(updatedPlayers) do
            if playerName == targetPlayerName then
                found = true
                break
            end
        end

        -- Si le joueur sélectionné est toujours présent, on le garde, sinon on en sélectionne un nouveau
        if found then
            KillAuraDropdown:SetValue(targetPlayerName)
        else
            targetPlayerName = updatedPlayers[1] -- Sélectionne le premier joueur dispo
        end
    end
end)

PvPTab:Checkbox({
    Label = "🔪 Kill Aura ON",
    Value = false, -- Désactivé par défaut
    Callback = function(self, Value)
        if Value then
            if targetPlayerName then
                StartKillAura()
            else
            end
        else
            StopKillAura()
        end
    end
})

--// UTILITY
UtilityTab:Checkbox({
    Label = "🛑 Anti-AFK ON",
    Value = false, -- Désactivé par défaut
    Callback = function(self, Value)
        ToggleAntiAfk(Value)
    end
})

UtilityTab:Button({
    Text = "🗑️ Remove Boss Sounds and GUI",
    Callback = function()
        DeleteSoundAndGUI()
    end
})

UtilityTab:Button({
    Text = "🗑️ Remove Rain Sound",
    Callback = function()
        DelRain()
    end
})

UtilityTab:Button({
    Text = "🎤 Enable Voice Chat",
    Callback = function()
        ActivateVoiceChat()
    end
})

UtilityTab:Button({
    Text = "Free fire Balls",
    Callback = function()
        FreeFireball()
    end
})

--// SETTINGS
local Keybind = SettingsTab:Keybind({
    Label = "Touche pour Toggle UI",
    Value = toggleKey, -- Défaut: "F"
    Callback = function(self, keyCode)
        toggleKey = keyCode
    end,
})

print("GUI loaded successfully!")
Window:ShowTab(MainTab)
