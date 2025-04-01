-- Define Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Criação da janela do Fluent
local Window = Fluent:CreateWindow({
    Title = "Desert Detectors " .. Fluent.Version,
    SubTitle = "by LaneS2",
    TabWidth = 120,
    Size = UDim2.fromOffset(460, 320),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Criação das abas
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Variáveis para controlar o ESP
local ESP = {
    Enabled = false,
    Distance = 500,
    Objects = {}
}

-- Funções do ESP
local function createESP(part, text, color)
    if not part:IsDescendantOf(workspace) then return end
    
    local char = game.Players.LocalPlayer.Character
    local humanoidRootPart = char and char:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local distance = (part.Position - humanoidRootPart.Position).Magnitude
        if distance > ESP.Distance then return end
    end

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

    table.insert(ESP.Objects, billboard)
end

local function clearESP()
    for _, obj in pairs(ESP.Objects) do
        if obj then obj:Destroy() end
    end
    ESP.Objects = {}
end

local function updateESP()
    clearESP()
    
    if not ESP.Enabled then return end
    
    for _, item in pairs(workspace.Loot:GetChildren()) do
        if item:IsA("Model") then
            local primaryPart = item.PrimaryPart or item:FindFirstChildOfClass("BasePart")
            if primaryPart then
                createESP(primaryPart, item.Name, Color3.fromRGB(255, 255, 255))
            end
        elseif item:IsA("BasePart") then
            createESP(item, item.Name, Color3.fromRGB(255, 255, 255))
        end
    end
end

-- Conexões de eventos
workspace.Loot.ChildAdded:Connect(function(child)
    if ESP.Enabled then
        if child:IsA("Model") then
            local primaryPart = child.PrimaryPart or child:FindFirstChildOfClass("BasePart")
            if primaryPart then
                createESP(primaryPart, child.Name, Color3.fromRGB(255, 255, 255))
            end
        elseif child:IsA("BasePart") then
            createESP(child, child.Name, Color3.fromRGB(255, 255, 255))
        end
    end
end)

workspace.Loot.ChildRemoved:Connect(function(child)
    for i, obj in ipairs(ESP.Objects) do
        if obj.Adornee and (obj.Adornee == child or obj.Adornee:IsDescendantOf(child)) then
            obj:Destroy()
            table.remove(ESP.Objects, i)
            break
        end
    end
end)

-- Atualiza quando o jogador se move
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 3)
    if rootPart then
        rootPart:GetPropertyChangedSignal("Position"):Connect(updateESP)
    end
end)

if game.Players.LocalPlayer.Character then
    game.Players.LocalPlayer.CharacterAdded:Fire(game.Players.LocalPlayer.Character)
end

-- Adicionando a seção de Configs Esp
Tabs.Main:AddParagraph({
    Title = "Esp",
    Content = "Settings"
})

-- Toggle para ativar/desativar o ESP
local ESPToggle = Tabs.Main:AddToggle("OnESP", {
    Title = "ESP", 
    Default = ESP.Enabled
})

ESPToggle:OnChanged(function()
    if ESP.Enabled == true then
        ESP.Enabled = false
    else
    updateESP()
    Fluent:Notify({
        Title = "ESP",
        Content = "ESP Ativado",
        Duration = 2
    })
    end
end)

-- Slider para ajustar a distância do ESP
local DistanceSlider = Tabs.Main:AddSlider("Distância do ESP", {
    Title = "Distância",
    Description = "Ajuste a distância do ESP",
    Min = 50,
    Max = 1000,
    Default = ESP.Distance,
    Rounding = 1,
    Callback = function(value)
        ESP.Distance = value
        if ESP.Enabled then
            updateESP()
        end
        Fluent:Notify({
            Title = "ESP",
            Content = "Distância ajustada para: " .. value,
            Duration = 2
        })
    end
})

-- Atualização inicial
updateESP()

-- Adicionar uma notificação informando que o script foi carregado
Fluent:Notify({
    Title = "Fluent",
    Content = "O script foi carregado.",
    Duration = 5
})

-- SaveManager e InterfaceManager para salvar as configurações
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Configurações do SaveManager
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

-- Carregar a configuração automaticamente, se houver
SaveManager:LoadAutoloadConfig()
