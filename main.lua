-- Carrega a PPHud UI
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/refs/heads/main/PPHud%20Lib/PPHud%20Lib%20Source.lua'))()
local Flags = Library.Flags

-- Configurações do ESP
local ESP = {
    Enabled = false,
    Distance = 500,
    Objects = {}
}

-- Cria a janela usando a PPHud Library
local Window = Library:Window({
    Text = "ESP Mini"
})

-- Adiciona uma aba para as configurações
local Tab = Window:Tab({
    Text = "Config"
})

-- Sistema de ESP
local function UpdateESP()
    -- Limpa ESP antigo
    for _, obj in pairs(ESP.Objects) do
        if obj then obj:Destroy() end
    end
    ESP.Objects = {}

    if not ESP.Enabled then return end

    -- Verifica se o jogador está no jogo
    local character = game.Players.LocalPlayer.Character
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

game.Players.LocalPlayer.CharacterAdded:Connect(function(c)
    local root = c:WaitForChild("HumanoidRootPart", 2)
    if root then
        root:GetPropertyChangedSignal("Position"):Connect(UpdateESP)
    end
end)

if game.Players.LocalPlayer.Character then
    game.Players.LocalPlayer.CharacterAdded:Fire(game.Players.LocalPlayer.Character)
end

-- Cria os controles na UI usando a PPHud Library
local Section = Tab:Section({
    Text = "ESP Settings"
})

Section:Check({
    Text = "Ativar ESP",
    Flag = "ESPEnabled",
    Callback = function(state)
        ESP.Enabled = state
        UpdateESP()
    end
})

Section:Slider({
    Text = "Distância",
    Minimum = 50,
    Maximum = 1000,
    Default = 500,
    Postfix = "m",
    Callback = function(value)
        ESP.Distance = value
        if ESP.Enabled then
            UpdateESP()
        end
    end
})

-- Atualização inicial
UpdateESP()
