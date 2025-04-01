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
    Acrylic = true,  -- O fundo borrado pode ser ativado ou desativado
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
    Distance = 500
}

-- Adicionando a seção de Configs Esp
Tabs.Main:AddParagraph({
        Title = "Esp",
        Content = "Settings"
    })
-- Toggle para ativar/desativar o ESP
local ESPToggle = Tabs.Main:AddToggle("OnESP", {Title="ESP", Default = false})
ESPToggle:OnChanged(function()
    ESP.Enabled = Options.ESPToggle.Value
end) -- Aqui está a chave de fechamento correta

Options.ESPToggle:SetValue(false)

-- Caixa de texto para definir a distância do ESP
local DistanceInput = Tabs.Main:AddInput("Distância do ESP", {
    Title = "Distância",
    Default = tostring(ESP.Distance),
    Numeric = true,
    Finished = true
}, function(value)
    local distance = tonumber(value)
    if distance then
        ESP.Distance = distance
        print("Distância do ESP:", ESP.Distance)
    else
        print("Por favor, insira um valor válido para a distância.")
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
        print("Distância ajustada para:", ESP.Distance)
    end
})

-- Função para atualizar o ESP
local function UpdateESP()
    if ESP.Enabled then
        print("ESP Ativado com distância:", ESP.Distance)
        -- Aqui você pode adicionar a lógica do ESP, utilizando a distância configurada
    else
        print("ESP Desativado")
    end
end

-- Atualiza o ESP constantemente
game:GetService("RunService").Heartbeat:Connect(function()
    UpdateESP()
end)

-- Adicionar uma notificação informando que o script foi carregado
Fluent:Notify({
    Title = "Fluent",
    Content = "O script foi carregado.",
    Duration = 8
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
