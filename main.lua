-- Define Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/UI-Libraries/main/Vynixius/Source.lua"))()

-- Cria a janela (Window)
local Window = Library:AddWindow({
    title = {"Vynixius", "UI Library"},
    theme = {
        Accent = Color3.fromRGB(0, 255, 0)
    },
    key = Enum.KeyCode.RightControl,
    default = true
})

-- Ajusta a janela para ter 35 de largura e 55 de altura
Window.Base.Size = UDim2.new(0, 35, 0, 55)  -- Largura de 35 e Altura de 55

-- Cria a aba
local Tab = Window:AddTab("Configurações ESP", {default = true})

-- Cria a seção para colocar os controles
local Section = Tab:AddSection("Configuração do ESP", {default = true})

-- Variáveis para controlar o ESP
local ESP = {
    Enabled = false,
    Distance = 500
}

-- Criação do Toggle para ativar/desativar o ESP
local ESPToggle = Section:AddToggle("Ativar ESP", {flag = "ESP_Enabled", default = false}, function(state)
    ESP.Enabled = state
    print("ESP Ativado:", ESP.Enabled)
end)

-- Criação da Caixa de Texto (Box) para definir a distância do ESP
local DistanceInput = Section:AddBox("Distância do ESP", {fireonempty = true}, function(text)
    local distance = tonumber(text)
    if distance then
        ESP.Distance = distance
        print("Distância do ESP:", ESP.Distance)
    else
        print("Por favor, insira um valor válido para a distância.")
    end
end)

-- Criação do Slider para ajustar a distância do ESP
local DistanceSlider = Section:AddSlider("Distância do ESP", 50, 1000, 500, {toggleable = true, default = false, flag = "ESP_Distance", fireontoggle = true, fireondrag = true, rounded = true}, function(value, bool)
    ESP.Distance = value
    print("Distância ajustada para:", ESP.Distance)
end)

-- Criação do Label para mostrar a distância configurada
local DistanceLabel = Section:AddLabel("Distância do ESP: " .. ESP.Distance)

-- Função para atualizar o ESP
local function UpdateESP()
    if ESP.Enabled then
        print("ESP Ativado com distância:", ESP.Distance)
        -- Aqui você pode colocar o código do ESP que usa a distância configurada (ESP.Distance)
    else
        print("ESP Desativado")
    end
end

-- Atualiza o ESP ao longo do tempo (quando o Toggle é alterado)
game:GetService("RunService").Heartbeat:Connect(function()
    UpdateESP()
end)
