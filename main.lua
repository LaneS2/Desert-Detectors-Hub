local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Carrega uma UI Library simples para mobile
local MobileUILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/slqite/MobileUILib/main/MobileUILib.lua"))()

-- Cria a janela principal (tamanho reduzido para mobile)
local Window = MobileUILib:CreateWindow({
    Title = "ESP Mobile",
    Size = UDim2.new(0, 200, 0, 150), -- Tamanho compacto
    Position = UDim2.new(0.5, -100, 0.1, 0) -- Centralizado na parte superior
})

-- Adiciona uma única aba (como solicitado)
local MainTab = Window:AddTab("ESP Config")

-- Variáveis de configuração
local ESPConfig = {
    Enabled = false,
    MaxDistance = 500
}

-- Sistema de ESP
local espObjects = {}

local function createESP(part)
    if not part or not part.Parent then return end
    
    -- Verifica distância
    local char = LocalPlayer.Character
    local humanoidRootPart = char and char:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local distance = (humanoidRootPart.Position - part.Position).Magnitude
        if distance > ESPConfig.MaxDistance then return end
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
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.TextSize = 14
    label.Text = part.Parent.Name
    label.Font = Enum.Font.SourceSansBold

    table.insert(espObjects, billboard)
end

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj then obj:Destroy() end
    end
    espObjects = {}
end

local function updateESP()
    clearESP()
    
    if not ESPConfig.Enabled then return end
    
    for _, item in pairs(workspace.Loot:GetChildren()) do
        if item:IsA("Model") then
            local primaryPart = item.PrimaryPart or item:FindFirstChildOfClass("BasePart")
            if primaryPart then
                createESP(primaryPart)
            end
        elseif item:IsA("BasePart") then
            createESP(item)
        end
    end
end

-- Conexões de eventos
workspace.Loot.ChildAdded:Connect(function(child)
    if ESPConfig.Enabled then
        if child:IsA("Model") then
            local primaryPart = child.PrimaryPart or child:FindFirstChildOfClass("BasePart")
            if primaryPart then
                createESP(primaryPart)
            end
        elseif child:IsA("BasePart") then
            createESP(child)
        end
    end
end)

workspace.Loot.ChildRemoved:Connect(function(child)
    for i, obj in ipairs(espObjects) do
        if obj.Adornee and (obj.Adornee == child or obj.Adornee:IsDescendantOf(child)) then
            obj:Destroy()
            table.remove(espObjects, i)
            break
        end
    end
end)

-- Atualiza quando o jogador se move
LocalPlayer.CharacterAdded:Connect(function(character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 3)
    if rootPart then
        rootPart:GetPropertyChangedSignal("Position"):Connect(updateESP)
    end
end)

if LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Fire(LocalPlayer.Character)
end

-- Cria os controles na UI
MainTab:AddToggle("ESP Ativo", ESPConfig.Enabled, function(state)
    ESPConfig.Enabled = state
    updateESP()
end)

MainTab:AddSlider("Distância", {Min = 50, Max = 1000, Default = 500}, function(value)
    ESPConfig.MaxDistance = value
    if ESPConfig.Enabled then
        updateESP()
    end
end)

-- Inicialização
updateESP()
