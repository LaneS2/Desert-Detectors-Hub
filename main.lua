local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Carregar a UI Lib do Criminality
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/UI-Libraries/main/Vynixius/Source.lua"))()

-- Criar a janela principal
local Window = Library:AddWindow({
    title = {"ESP Config", "v1.0"},
    theme = {
        Accent = Color3.fromRGB(255, 0, 0)
    },
    key = Enum.KeyCode.RightControl, -- Tecla para abrir/fechar
    default = true
})

-- Adicionar aba principal
local MainTab = Window:AddTab("Configurações", {default = true})

-- Adicionar seção para o ESP
local ESPSection = MainTab:AddSection("ESP Settings", {default = false})

-- Variáveis de configuração
local ESPConfig = {
    Enabled = true,
    MaxDistance = 500,
    ShowNames = true
}

-- Sistema de ESP
local espObjects = {}

local function createESP(part, text, color)
    if not part:IsDescendantOf(workspace) then return end
    
    local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
        and (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude 
        or math.huge
    
    if distance > ESPConfig.MaxDistance then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Adornee = part
    billboard.Parent = part
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = ESPConfig.MaxDistance

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextSize = 10
    label.Text = ESPConfig.ShowNames and text or "Item"

    table.insert(espObjects, billboard)
end

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj then
            obj:Destroy()
        end
    end
    espObjects = {}
end

local function updateESP()
    clearESP()
    
    if not ESPConfig.Enabled then return end
    
    for _, item in pairs(workspace.Loot:GetChildren()) do
        if (item:IsA("Model") or item:IsA("BasePart")) and item:FindFirstChildOfClass("BasePart") then
            local primaryPart = item:IsA("Model") and item.PrimaryPart or item
            if primaryPart then
                createESP(primaryPart, item.Name, Color3.fromRGB(255, 255, 255))
            end
        end
    end
end

-- Conexões de eventos
workspace.Loot.ChildAdded:Connect(function(child)
    if ESPConfig.Enabled and (child:IsA("Model") or child:IsA("BasePart")) and child:FindFirstChildOfClass("BasePart") then
        local primaryPart = child:IsA("Model") and child.PrimaryPart or child
        if primaryPart then
            createESP(primaryPart, child.Name, Color3.fromRGB(255, 255, 255))
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

-- Atualizar ESP quando o jogador se move
local function onCharacterAdded(character)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if rootPart then
        rootPart:GetPropertyChangedSignal("Position"):Connect(function()
            if ESPConfig.Enabled then
                updateESP()
            end
        end)
    end
end

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Elementos da UI
ESPSection:AddToggle("Ativar ESP", {flag = "esp_enabled", default = true}, function(val)
    ESPConfig.Enabled = val
    updateESP()
end)

ESPSection:AddSlider("Distância Máxima", {min = 50, max = 1000, default = 500, flag = "esp_distance"}, function(val)
    ESPConfig.MaxDistance = val
    updateESP()
end)

ESPSection:AddToggle("Mostrar Nomes", {flag = "esp_names", default = true}, function(val)
    ESPConfig.ShowNames = val
    updateESP()
end)

-- Atualização inicial
updateESP()
