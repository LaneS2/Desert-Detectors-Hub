local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ObjectsFolder = ReplicatedStorage:WaitForChild("Objects")

local function highlightObject(obj) -- Destaca objetos novos (opcional)
    if obj:IsA("BasePart") then
        obj.BrickColor = BrickColor.new("Bright red")
        obj.Material = Enum.Material.Neon
    end
end

local function listObjects()
    print("\n=== LISTA DE OBJETOS ===")
    for _, obj in pairs(ObjectsFolder:GetChildren()) do
        print("-> " .. obj.Name)
    end
    print("=======================")
end

-- Monitora adições/remoções
local function startMonitoring()
    listObjects() -- Lista inicial
    
    ObjectsFolder.ChildAdded:Connect(function(newObj)
        print("[+] NOVO OBJETO: " .. newObj.Name)
        highlightObject(newObj) -- Destaca se for uma parte
        listObjects() -- Atualiza lista
    end)

    ObjectsFolder.ChildRemoved:Connect(function(removedObj)
        print("[-] OBJETO REMOVIDO: " .. removedObj.Name)
        listObjects() -- Atualiza lista
    end)
end

-- Inicia o monitoramento
startMonitoring()

-- Opção para parar o script (útil se estiver em loop)
print("\nPressione **F** para parar o monitoramento.")
local stopKey = "F" -- Altere para a tecla desejada

local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, _)
    if input.KeyCode == Enum.KeyCode[stopKey] then
        print("\n[!] MONITORAMENTO PARADO!")
        getgenv().STOP_MONITORING = true -- Para loops externos
    end
end)

-- Loop infinito (opcional, mas útil para manter o script ativo)
while wait(1) and not getgenv().STOP_MONITORING do
    -- Pode adicionar verificações extras aqui
end
