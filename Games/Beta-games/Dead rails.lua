-- Ro Lib.
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Hub1/Ro-Lib/refs/heads/main/Test.lua"))()

local Win = Lib:Window({
  Title = "Ro Hub |"
})

local MinWin = Win:MinimizeWin({
  Format = "Circle"
})

local InfoTab = Win:Tab({
  Name = "Info"
})
local plr = game:GetService("Players").LocalPlayer

InfoTab:Label({
  Name = "Player name: " .. plr.Name
})

local exTab = Win:Tab({
  Name = "Executar"
})

exTab:Button({
  Name = "Auto bond",
  Desc = "Verificado: ❌",
  Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Auto-farm-bond-script-45922"))()
  end
})
