-- Define Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local activeESP = true
local espObjects = {}

-- Function Esp
local function createESP(part, text, color)
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

    table.insert(espObjects, billboard)
end

local function updateESP()
    -- Limpiar los antiguos ESP
    for _, obj in pairs(espObjects) do
        obj:Destroy()
    end
    espObjects = {}

    if not activeESP then return end

    -- Mostrar todos los ítems sin filtrar por rareza
    for _, item in pairs(workspace.Loot:GetChildren()) do
        if item:IsA("Model") or item:IsA("BasePart") then
            createESP(item, item.Name, Color3.fromRGB(255, 255, 255)) -- Puedes ajustar el color si lo deseas
        end
    end
end

-- Detectar nuevos ítems cuando se agregan a la carpeta 'Loot'
workspace.Loot.ChildAdded:Connect(function(child)
    if child:IsA("Model") or child:IsA("BasePart") then
        createESP(child, child.Name, Color3.fromRGB(255, 255, 255)) -- Crear ESP cuando se añaden nuevos ítems
    end
end)

-- Actualiza el ESP cuando el script inicia
updateESP()

-- Create Fluent window
local Window = Fluent:CreateWindow({
    Title = "Desert Detectors " .. Fluent.Version,
    SubTitle = "by LaneS2",
    TabWidth = 120,
    Size = UDim2.fromOffset(460, 320),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Create tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Add ESP section
Tabs.Main:AddParagraph({
    Title = "Esp",
    Content = "Settings"
})

-- Toggle for ESP
local ESPToggle = Tabs.Main:AddToggle("ESPToggle", {
    Title = "ESP",
    Default = false
})

ESPToggle:OnChanged(function()
    activeESP = not activeESP
    updateESP()
end)

-- Initialize
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:SetFolder("DesertDetectors")
SaveManager:SetFolder("DesertDetectors/settings")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

-- Load autosave config
SaveManager:LoadAutoloadConfig()

-- Notification
Fluent:Notify({
    Title = "Desert Detectors",
    Content = "Script loaded successfully!",
    Duration = 5
})
