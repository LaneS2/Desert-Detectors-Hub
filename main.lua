local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Carrega a Elerium UI
local Elerium = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/elerium-ui/main/src.lua"))()

-- Cria a janela flutuante minimalista
local window = Elerium:Window({
    text = "ESP PRO",
    position = UDim2.new(0.02, 0, 0.02, 0), -- Canto superior esquerdo
    size = UDim2.new(0, 120, 0, 30) -- Tamanho compacto
})

-- Variáveis de configuração
local ESP = {
    Active = false,
    Distance = 500,
    Objects = {}
}

-- Função principal do ESP
local function UpdateESP()
    -- Limpa ESP antigo
    for _, obj in pairs(ESP.Objects) do
        if obj then obj:Destroy() end
    end
    ESP.Objects = {}

    if not ESP.Active then return end

    -- Verifica se o jogador está no game
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Renderiza os itens
    for _, item in pairs(workspace.Loot:GetChildren()) do
        local part = item:IsA("Model") and item.PrimaryPart or item:IsA("BasePart") and item
        if part then
            local distance = (part.Position - root.Position).Magnitude
            if distance <= ESP.Distance then
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 100, 0, 20)
                billboard.Adornee = part
                billboard.Parent = part
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = item.Name
                label.TextColor3 = Color3.new(1, 1, 1)
                label.TextSize = 10
                label.Parent = billboard

                table.insert(ESP.Objects, billboard)
            end
        end
    end
end

-- Conexões de eventos
workspace.Loot.ChildAdded:Connect(UpdateESP)
workspace.Loot.ChildRemoved:Connect(UpdateESP)

LocalPlayer.CharacterAdded:Connect(function(c)
    local root = c:WaitForChild("HumanoidRootPart", 2)
    if root then
        root:GetPropertyChangedSignal("Position"):Connect(UpdateESP)
    end
end)

if LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Fire(LocalPlayer.Character)
end

-- Cria os controles na UI
window:Toggle({
    text = "Ativar ESP",
    flag = "esp_toggle",
    state = false,
    callback = function(state)
        ESP.Active = state
        UpdateESP()
    end
})

window:Slider({
    text = "Distância: "..ESP.Distance,
    flag = "esp_distance",
    min = 50,
    max = 1000,
    value = ESP.Distance,
    callback = function(value)
        ESP.Distance = value
        window:UpdateSlider("esp_distance", {text = "Distância: "..value})
        if ESP.Active then
            UpdateESP()
        end
    end
})

-- Notificação inicial
window:Notification({
    title = "ESP Carregado",
    text = "Pressione F para abrir/fechar",
    duration = 3
})

-- Atualização inicial
UpdateESP()
