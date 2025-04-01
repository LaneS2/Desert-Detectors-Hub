-- Carrega a PPHud UI
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/refs/heads/main/PPHud%20Lib/PPHud%20Lib%20Source.lua'))()
local Flags = Library.Flags

-- Cria a janela usando a PPHud Library
local Window = Library:Window({
    Text = "ESP Mini"
})

-- Adiciona uma aba para as configurações
local Tab = Window:Tab({
    Text = "Config"
})
