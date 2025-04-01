-- Configurações (ajustáveis)
local MAX_DISTANCE = 300 -- Distância máxima em studs
local TEXT_COLOR = Color3.new(1, 1, 1) -- Cor do texto (branco)
local TOGGLE_KEY = Enum.KeyCode.F -- Tecla para ligar/desligar (F)

-- Serviços
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LOCAL_PLAYER = Players.LocalPlayer
local ObjectsFolder = ReplicatedStorage:FindFirstChild("Objects")

if not ObjectsFolder then
    warn("⚠ Pasta 'Objects' não encontrada!")
    return
end

-- Variáveis de controle
local enabled = false
local nameTags = {} -- Armazena as tags criadas

-- Cria um BillboardGui para mostrar o nome
local function createNameTag(model)
    if nameTags[model] then return end -- Evita duplicar

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_NameTag"
    billboard.Adornee = model:IsA("Model") and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")) or model
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.Parent = model

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = model.Name
    textLabel.TextColor3 = TEXT_COLOR
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard

    nameTags[model] = billboard -- Guarda a referência
end

-- Remove todas as tags
local function clearNameTags()
    for model, tag in pairs(nameTags) do
        tag:Destroy()
        nameTags[model] = nil
    end
end

-- Atualiza as tags (mostra/esconde conforme a distância)
local function updateNameTags()
    if not enabled then return end

    local character = LOCAL_PLAYER.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    for _, model in ipairs(ObjectsFolder:GetChildren()) do
        if model:IsA("Model") then
            local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if primaryPart then
                local distance = (primaryPart.Position - rootPart.Position).Magnitude
                if distance <= MAX_DISTANCE then
                    createNameTag(model)
                else
                    if nameTags[model] then
                        nameTags[model]:Destroy()
                        nameTags[model] = nil
                    end
                end
            end
        end
    end
end

-- Liga/desliga com a tecla
UIS.InputBegan:Connect(function(input, _)
    if input.KeyCode == TOGGLE_KEY then
        enabled = not enabled
        if not enabled then
            clearNameTags()
        end
        print("ESP " .. (enabled and "LIGADO" or "DESLIGADO"))
    end
end)

-- Atualiza a cada frame
RunService.Heartbeat:Connect(updateNameTags)

print("✅ Script carregado! Pressione " .. TOGGLE_KEY.Name .. " para ligar/desligar."
