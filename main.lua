-- Cria a UI personalizada com 55 de altura e 35 de largura
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame principal da UI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 35, 0, 55)  -- Largura: 35, Altura: 55
MainFrame.Position = UDim2.new(0.5, -17.5, 0.5, -27.5)  -- Posiciona no meio da tela
MainFrame.BackgroundColor3 = Color3.fromRGB(41, 74, 122)
MainFrame.Parent = ScreenGui

-- Título da UI
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 15)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ESP Mini"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.TextAlignment = Enum.TextAlignment.Center
Title.Parent = MainFrame

-- Checkbox para ativar o ESP
local ESPCheckbox = Instance.new("TextButton")
ESPCheckbox.Size = UDim2.new(0, 30, 0, 15)
ESPCheckbox.Position = UDim2.new(0, 2, 0, 17)
ESPCheckbox.BackgroundColor3 = Color3.fromRGB(50, 90, 150)
ESPCheckbox.Text = "Ativar ESP"
ESPCheckbox.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPCheckbox.TextSize = 10
ESPCheckbox.Parent = MainFrame

-- Variável para armazenar se o ESP está ativado ou não
local ESPEnabled = false

ESPCheckbox.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ESPCheckbox.Text = "Desativar ESP"
    else
        ESPCheckbox.Text = "Ativar ESP"
    end
end)

-- Input box para a distância do ESP
local DistanceInput = Instance.new("TextBox")
DistanceInput.Size = UDim2.new(0, 30, 0, 15)
DistanceInput.Position = UDim2.new(0, 2, 0, 32)
DistanceInput.BackgroundColor3 = Color3.fromRGB(50, 90, 150)
DistanceInput.Text = "500"
DistanceInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DistanceInput.TextSize = 10
DistanceInput.TextAlign = Enum.TextAlign.Center
DistanceInput.ClearTextOnFocus = false
DistanceInput.Parent = MainFrame

-- Variável para armazenar a distância do ESP
local ESPDistance = 500

DistanceInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local distance = tonumber(DistanceInput.Text)
        if distance then
            ESPDistance = distance
        else
            -- Se o valor não for um número válido, manter o valor antigo
            DistanceInput.Text = tostring(ESPDistance)
        end
    end
end)

-- Função para ativar/desativar o ESP
local function UpdateESP()
    -- Lógica para ativar ou desativar o ESP com base no estado do checkbox e na distância
    if ESPEnabled then
        print("ESP Ativado com distância: " .. ESPDistance)
        -- Aqui você pode colocar o código de ESP que usa a distância configurada (ESPDistance)
    else
        print("ESP Desativado")
        -- Lógica para desativar o ESP
    end
end

-- Atualiza o ESP quando o checkbox for clicado ou a distância for alterada
game:GetService("RunService").Heartbeat:Connect(function()
    UpdateESP()
end)
