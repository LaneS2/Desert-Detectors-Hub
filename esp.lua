local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
if not PlayerGui then return end -- Asegura que el jugador tiene GUI

-- 📌 Crear GUI Principal
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true -- Hacer la GUI arrastrable

local ToggleButton = Instance.new("TextButton", Frame)
ToggleButton.Size = UDim2.new(1, 0, 0, 30)
ToggleButton.Position = UDim2.new(0, 0, 0, 0)
ToggleButton.Text = "Toggle ESP (ON)"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- 🌟 Sistema de ESP sin rarezas
local activeESP = true

-- 🏷️ Crear ESP en los objetos
local espObjects = {}

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

-- 🎛️ Botón para activar/desactivar ESP
ToggleButton.MouseButton1Click:Connect(function()
    activeESP = not activeESP
    ToggleButton.Text = "Toggle ESP (" .. (activeESP and "ON" or "OFF") .. ")"
    updateESP()
end)
