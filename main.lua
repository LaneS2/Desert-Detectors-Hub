-- Define Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variáveis globais
local activeESP = false -- Começa desligado
local espObjects = {}
local lootConnection = nil -- Para controlar o evento ChildAdded

-- Função para criar ESP
local function createESP(part, text, color)
    if not activeESP then return end -- Verifica distância e toggle
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Adornee = part
    billboard.Parent = part
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextSize = 10
    label.Text = text

    table.insert(espObjects, billboard)
end

-- Função para atualizar ESP
local function updateESP()
    -- Limpa ESPs antigos
    for _, obj in pairs(espObjects) do
        obj:Destroy()
    end
    espObjects = {}

    if not activeESP then return end

    -- Cria ESP para todos os itens no Loot
    for _, item in pairs(workspace.Loot:GetChildren()) do
        if item:IsA("Model") or item:IsA("BasePart") then
            createESP(item, item.Name, Color3.fromRGB(255, 255, 255))
        end
    end
end

-- Função para ativar/desativar o evento ChildAdded
local function toggleLootConnection(enable)
    if lootConnection then
        lootConnection:Disconnect()
        lootConnection = nil
    end
    
    if enable then
        lootConnection = workspace.Loot.ChildAdded:Connect(function(child)
            if child:IsA("Model") or child:IsA("BasePart") then
                createESP(child, child.Name, Color3.fromRGB(255, 255, 255))
            end
        end)
    end
end


-- Cria janela Fluent
local Window = Fluent:CreateWindow({
    Title = "Desert Detectors " .. Fluent.Version,
    SubTitle = "by LaneS2",
    TabWidth = 120,
    Size = UDim2.fromOffset(460, 320),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Cria abas
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "house" }),
    Player = Window:AddTab({ Title = "Player", Icon = "users-round"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "bolt" })
}

local Options = Fluent.Options

-- Adiciona seção ESP
Tabs.Main:AddParagraph({
    Title = "ESP",
    Content = "Esp Item's"
})

-- Toggle para ESP
local ESPToggle = Tabs.Main:AddToggle("ESPToggle", {
    Title = "ESP",
    Default = false
})
-- Button Get Money
local MoneyBtn = Tabs.Main:AddButton({
        Title = "100K Money",
        Description = "Get 100k money on clicked",
        Callback = function()
            local args = {
                [1] = -10
            }
            game:GetService("ReplicatedStorage").Purchase_Legendary_Crate:FireServer(unpack(args))
            Fluent:Notify({
                Title = "100K Money",
                Content = "100K Added to your account",
                Duration = 5
            })
        end
        })

ESPToggle:OnChanged(function(value)
    activeESP = value
    toggleLootConnection(activeESP)
    updateESP()
end)

-- Inicializa SaveManager e InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("DesertDetectors")
SaveManager:SetFolder("DesertDetectors/settings")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

-- Carrega configuração automática
SaveManager:LoadAutoloadConfig()

-- Notificação
Fluent:Notify({
    Title = "Desert Detectors",
    Content = "Creator: lane_viana discord)",
    Duration = 5
})

-- Atualização contínua do ESP
game:GetService("RunService").Heartbeat:Connect(function()
    if activeESP then
        updateESP()
    end
end)
