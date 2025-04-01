local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Carrega a Fluent UI (leve e responsiva)
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/Source.lua"))()

-- Configuração da janela compacta
local Window = Fluent:CreateWindow({
    Title = "Micro ESP",
    SubTitle = "by github.com",
    TabWidth = 80,
    Size = UDim2.fromOffset(100, 60), -- Tamanho ultra compacto
    Acrylic = false, -- Desativa efeitos para melhor performance
    Theme = "Dark"
})

-- Cria uma única aba (como solicitado)
local Tab = Window:AddTab({
    Title = "ESP",
    Icon = ""
})

-- Variáveis de configuração
local ESPConfig = {
    Enabled = false,
    MaxDistance = 500
}

-- Sistema de ESP otimizado
local espObjects = {}

local function updateESP()
    -- Limpa ESP antigo
    for _, obj in pairs(espObjects) do
        if obj then obj:Destroy() end
    end
    espObjects = {}

    if not ESPConfig.Enabled then return end

    -- Verifica se o jogador tem character
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Cria ESP para cada item dentro da distância
    for _, item in pairs(workspace.Loot:GetChildren()) do
        local primaryPart = item:IsA("Model") and item.PrimaryPart or item:IsA("BasePart") and item
        if primaryPart then
            local distance = (primaryPart.Position - rootPart.Position).Magnitude
            if distance <= ESPConfig.MaxDistance then
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 100, 0, 20)
                billboard.Adornee = primaryPart
                billboard.Parent = primaryPart
                billboard.AlwaysOnTop = true
                billboard.LightInfluence = 0

                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = item.Name
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextSize = 10

                table.insert(espObjects, billboard)
            end
        end
    end
end

-- Conexões de eventos otimizadas
workspace.Loot.ChildAdded:Connect(updateESP)
workspace.Loot.ChildRemoved:Connect(updateESP)

local function onCharacterAdded(character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 2)
    if rootPart then
        rootPart:GetPropertyChangedSignal("Position"):Connect(updateESP)
    end
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
    task.spawn(onCharacterAdded, LocalPlayer.Character)
end

-- Cria os controles MÍNIMOS
Tab:AddToggle("EspToggle", {
    Title = "ESP Ativo",
    Default = ESPConfig.Enabled,
    Callback = function(value)
        ESPConfig.Enabled = value
        updateESP()
    end
})

Tab:AddSlider("DistanceSlider", {
    Title = "Distância: "..ESPConfig.MaxDistance,
    Min = 50,
    Max = 1000,
    Default = ESPConfig.MaxDistance,
    Rounding = 0,
    Callback = function(value)
        ESPConfig.MaxDistance = value
        Tab:UpdateSlider("DistanceSlider", {
            Title = "Distância: "..value
        })
        if ESPConfig.Enabled then
            updateESP()
        end
    end
})

-- Inicialização
Window:SelectTab(1)
Fluent:Notify({
    Title = "Micro ESP",
    Content = "Script carregado!",
    Duration = 3
})

updateESP()
