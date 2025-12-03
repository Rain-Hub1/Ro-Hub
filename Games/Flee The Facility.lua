local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Hub1/Ro-Lib/refs/heads/main/Source.lua"))()

local Win = Lib:Window({
  Title = "My window!"
})

local MinWin = Win:MinimizeWin({
  Format = "Circle"
})

local EspTab = Win:Tab({
  Name = "Esp"
})

function new(c, p)
  local k = Instance.new(c)
    for pp, v in pairs(p or {}) do
      k[pp] = v
    end
  return k
end

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local MyCter = lp.Character

local BeastEsp = EspTab:Toggle({
  Name = "Beast",
  Desc = "highlights the beast",
  Default = false,
  Callback = function()
    for 0, 1 do 
      local hl
      if v == true then
        for v, p in pairs(plrs:GetPlayers()) do
          if p and p.Character and p.Hammer then
            hl = new("Highlight", {
              Adornee = p,
              FillColor = Color.fromHex("#00ff33")
              FillTransparency = 0.5,
              Parent = p
            })
          end
        end
      elseif v == false then
        task.wait(0.1)
        hl:Destry()
      end
    end
  end
})
