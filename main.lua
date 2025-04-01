local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Carrega a Orion Lib (leve e customizável)
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Cria a janela MICRO (45x25)
local Window = OrionLib:MakeWindow({
    Name = "ESP Mini",
    HidePremium = true,
    SaveConfig = false,
    IntroEnabled = false,
    ConfigFolder = "OrionESP",
    Size = UDim2.new(0, 25, 0, 45), -- LARGURA x ALTURA
    Position = UDim2.new(0.5, -12, 0.1, 0) -- Centralizado
})

-- Variáveis do ESP
local ESPConfig = {
    Enabled = false,
    MaxDistance = 500
}

-- Sistema de ESP (versão compacta)
local espObjects = {}

local function updateESP()
    for _, obj in pairs(espObjects) do obj:Destroy() end
    espObjects = {}

    if not ESPConfig.Enabled then return end

    for _, item in pairs(workspace.Loot:GetChildren()) do
        local part = item:IsA("Model") and item.PrimaryPart or item:IsA("BasePart") and item
        if part then
            local distance = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
                and (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or math.huge
            
            if distance <= ESPConfig.MaxDistance then
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0, 100, 0, 20)
                billboard.Adornee = part
                billboard.Parent = part
                billboard.AlwaysOnTop = true

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

-- Conexões de eventos (otimizado)
workspace.Loot.ChildAdded:Connect(updateESP)
workspace.Loot.ChildRemoved:Connect(updateESP)

LocalPlayer.CharacterAdded:Connect(function()
    local root = LocalPlayer.Character:WaitForChild("HumanoidRootPart", 2)
    if root then root:GetPropertyChangedSignal("Position"):Connect(updateESP) end
end)

if LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Fire(LocalPlayer.Character)
end

-- Cria os controles MICRO
local Tab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://0", -- Ícone vazio para economizar espaço
    PremiumOnly = false
})

-- Toggle compacto
Tab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(Value)
        ESPConfig.Enabled = Value
        updateESP()
    end    
})

-- Slider ultra compacto
Tab:AddSlider({
    Name = "Distância",
    Min = 50,
    Max = 1000,
    Default = 500,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 50,
    Callback = function(Value)
        ESPConfig.MaxDistance = Value
        if ESPConfig.Enabled then updateESP() end
    end    
})

-- Inicia o ESP
OrionLib:Init()
updateESP()
