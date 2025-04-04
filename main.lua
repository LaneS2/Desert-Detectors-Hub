-- Define Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

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

-- Variables for ESP control
local ESP = {
    Enabled = false, -- Default to false
    Distance = 500,
    ActiveESP = false,
    ScreenGui = nil,
    ESPObjects = {}
}

-- Add ESP section
Tabs.Main:AddParagraph({
    Title = "Esp",
    Content = "Settings"
})

-- Toggle for ESP
local ESPToggle = Tabs.Main:AddToggle("ESPToggle", {
    Title = "ESP",
    Default = ESP.Enabled
})

ESPToggle:OnChanged(function(value)
    ESP.Enabled = value
    if ESP.Enabled then
        EnableESP()
    else
        DisableESP()
    end
end)

-- Distance input
local DistanceInput = Tabs.Main:AddInput("DistanceInput", {
    Title = "Distance",
    Default = tostring(ESP.Distance),
    Numeric = true,
    Finished = true,
    Callback = function(text)
        local distance = tonumber(text)
        if distance and distance >= 50 and distance <= 1000 then
            ESP.Distance = distance
            Options.DistanceSlider:SetValue(distance)
            UpdateESP()
        end
    end
})

-- Distance slider
local DistanceSlider = Tabs.Main:AddSlider("DistanceSlider", {
    Title = "Distance",
    Description = "Adjust ESP distance",
    Min = 50,
    Max = 1000,
    Default = ESP.Distance,
    Rounding = 1,
    Callback = function(value)
        ESP.Distance = value
        Options.DistanceInput:SetValue(tostring(value))
        UpdateESP()
    end
})

-- Function to create ESP GUI
local function CreateESPGUI()
    if ESP.ScreenGui then ESP.ScreenGui:Destroy() end
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGui then return end

    ESP.ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ESP.ScreenGui.ResetOnSpawn = false

    local Frame = Instance.new("Frame", ESP.ScreenGui)
    Frame.Size = UDim2.new(0, 200, 0, 30)
    Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true

    local ToggleButton = Instance.new("TextButton", Frame)
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.Text = "ESP: ON"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleButton.BorderSizePixel = 0

    ToggleButton.MouseButton1Click:Connect(function()
        ESP.ActiveESP = not ESP.ActiveESP
        ToggleButton.Text = "ESP: " .. (ESP.ActiveESP and "ON" or "OFF")
        UpdateESP()
    end)
end

-- Function to create ESP for a part
local function CreateESP(part)
    if not part:IsA("BasePart") and not part:IsA("Model") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Adornee = part
    billboard.Parent = ESP.ScreenGui
    billboard.AlwaysOnTop = true
    billboard.Enabled = ESP.ActiveESP

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextSize = 10
    label.Text = part.Name

    table.insert(ESP.ESPObjects, billboard)
end

-- Function to update ESP
local function UpdateESP()
    if not ESP.Enabled or not ESP.ScreenGui then return end
    
    -- Clear old ESP objects
    for _, obj in pairs(ESP.ESPObjects) do
        obj:Destroy()
    end
    ESP.ESPObjects = {}

    if not ESP.ActiveESP then return end

    -- Create ESP for all loot within distance
    local character = game:GetService("Players").LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    for _, item in pairs(workspace.Loot:GetChildren()) do
        if (item:IsA("Model") or item:IsA("BasePart")) and item:FindFirstChildOfClass("BasePart") then
            local itemPart = item:IsA("Model") and item.PrimaryPart or item
            if (rootPart.Position - itemPart.Position).Magnitude <= ESP.Distance then
                CreateESP(item)
            end
        end
    end
end

-- Function to enable ESP
local function EnableESP()
    CreateESPGUI()
    ESP.ActiveESP = true
    
    -- Connect to child added event
    workspace.Loot.ChildAdded:Connect(function(child)
        if ESP.Enabled and ESP.ActiveESP then
            wait(0.1) -- Wait for the item to fully load
            if (child:IsA("Model") or child:IsA("BasePart")) and child:FindFirstChildOfClass("BasePart") then
                CreateESP(child)
            end
        end
    end)
    
    UpdateESP()
end

-- Function to disable ESP
local function DisableESP()
    if ESP.ScreenGui then
        ESP.ScreenGui:Destroy()
        ESP.ScreenGui = nil
    end
    ESP.ActiveESP = false
    ESP.ESPObjects = {}
end

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
