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
