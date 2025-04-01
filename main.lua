local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ObjectsFolder = ReplicatedStorage:WaitForChild("Objects")

-- Função para verificar e destacar objetos
local function checkAndHighlight(obj)
    if obj:IsA("BasePart") then
        print("-> " .. obj.Name .. " (Tipo: Part)")
        obj.BrickColor = BrickColor.new("Bright red")
        obj.Material = Enum.Material.Neon
    elseif obj:IsA("Model") then
        print("-> " .. obj.Name .. " (Tipo: Model)")
    elseif obj:IsA("MeshPart") then
        print("-> " .. obj.Name .. " (Tipo: MeshPart)")
    elseif obj:IsA("UnionOperation") then
        print("-> " .. obj.Name .. " (Tipo: UnionOperation)")
    else
        print("-> " .. obj.Name .. " (Tipo: " .. obj.ClassName .. ")")
    end
end

-- Lista todos os objetos e seus tipos
local function listObjects()
    print("\n=== OBJETOS EM 'Objects' ===")
    for _, obj in pairs(ObjectsFolder:GetChildren()) do
        checkAndHighlight(obj)
    end
    print("===========================")
end

-- Monitora novos objetos
local function startMonitoring()
    listObjects() -- Lista inicial
    
    ObjectsFolder.ChildAdded:Connect(function(newObj)
        print("\n[+] NOVO OBJETO DETECTADO!")
        checkAndHighlight(newObj)
    end)

    ObjectsFolder.ChildRemoved:Connect(function(removedObj)
        print("\n[-] OBJETO REMOVIDO: " .. removedObj.Name .. " (Tipo: " .. removedObj.ClassName .. ")")
    end)
end

-- Inicia o monitoramento
startMonitoring()

-- Opção para parar o script (tecla F)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, _)
    if input.KeyCode == Enum.KeyCode.F then
        print("\n[!] MONITORAMENTO PARADO!")
        getgenv().STOP_MONITORING = true
    end
end)

-- Loop infinito (opcional)
while wait(1) and not getgenv().STOP_MONITORING do
    -- Pode adicionar mais verificações aqui
end
