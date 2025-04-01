local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Carrega a Elerium UI
local Elerium = loadstring(game:HttpGet("https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/main/Elerium%20%5BIMGUI%5D%20Lib/Elerium%20%5BIMGUI%5D%20Lib%20Source.lua"))()

-- Configurações do ESP
local ESP = {
    Enabled = false,
    Distance = 500,
    Objects = {}
}

-- Cria a janela compacta
local window = Elerium:AddWindow("ESP Mini", {
    main_color = Color3.fromRGB(41, 74, 122),
    min_size = Vector2.new(200, 60), -- Largura x Altura
    toggle_key = Enum.KeyCode.F -- Tecla para abrir/fechar
})

-- Adiciona uma única aba
local tab = window:AddTab("Config")

-- Sistema de ESP
local function UpdateESP()
    -- Limpa ESP antigo
    for _, obj in pairs(ESP.Objects) do
        if obj then obj:Destroy() end
    end
    ESP.Objects = {}

    if not ESP.Enabled then return end

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
tab:AddSwitch("Ativar ESP", function(state)
    ESP.Enabled = state
    UpdateESP()
end)

tab:AddSlider("Distância", function(value)
    ESP.Distance = value
    if ESP.Enabled then
        UpdateESP()
    end
end, {
    min = 50,
    max = 1000,
    default = 500
})

-- Atualização inicial
UpdateESP()
