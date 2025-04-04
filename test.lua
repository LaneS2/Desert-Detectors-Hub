-- Define Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Cria janela Fluent
local Window = Fluent:CreateWindow({
    Title = "Coordinate Marker " .. Fluent.Version,
    SubTitle = "by SeuNome",
    TabWidth = 120,
    Size = UDim2.fromOffset(400, 200),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Cria aba principal
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" })
}

-- Função para criar marcador de coordenadas
local function createCoordinateMarker()
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        Fluent:Notify({
            Title = "Erro",
            Content = "Personagem não encontrado!",
            Duration = 3
        })
        return
    end

    local rootPart = character.HumanoidRootPart
    local position = rootPart.Position
    local coordinates = string.format("X: %.1f, Y: %.1f, Z: %.1f", position.X, position.Y, position.Z)

    -- Cria uma part para servir como base do billboard
    local markerPart = Instance.new("Part")
    markerPart.Anchored = true
    markerPart.CanCollide = false
    markerPart.Transparency = 1  -- Totalmente invisível
    markerPart.Size = Vector3.new(1, 1, 1)
    markerPart.Position = position
    markerPart.Parent = workspace

    -- Cria o billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Adornee = markerPart
    billboard.Parent = markerPart
    billboard.AlwaysOnTop = true

    -- Cria o label
    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 0.7
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextSize = 14
    label.Text = "Coordenadas:\n" .. coordinates
    label.Font = Enum.Font.SourceSansBold
    label.TextWrapped = true

    Fluent:Notify({
        Title = "Marcador Criado",
        Content = "Coordenadas marcadas: " .. coordinates,
        Duration = 5
    })

    return markerPart
end

-- Adiciona botão para criar marcador
Tabs.Main:AddButton({
    Title = "Marcar Coordenadas Atuais",
    Description = "Cria um marcador com suas coordenadas atuais",
    Callback = function()
        createCoordinateMarker()
    end
})

-- Notificação inicial
Fluent:Notify({
    Title = "Coordinate Marker",
    Content = "Pronto para marcar coordenadas!",
    Duration = 3
})
