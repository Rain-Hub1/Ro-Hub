local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Hub1/Ro-Lib/refs/heads/main/Test.lua"))()

local Win = Lib:Window({
  Title = "Ro Hub | [UPD] Chasing 🔪"
})

local MinWin = Win:MinimizeWin({
  Format = "Circle"
})

local espTab = Win:Tab({
  Name = "esp"
})

function new(c, p)
  local k = Instance.new(c)
    for pp, v in pairs(p or {}) do
      k[pp] = v
    end
  return k
end

local rs = game:GetService("RunService")
local plrs = game:GetService("Players")

local espKiller = nil
espTab:Toggle({
  Name = "Killer",
  Desc = "Highlight killer { Red }",
  Default = false,
  Callback = function(v)
    if v then
     espKiller = rs.Heartbeat:Connect(function()
      for _, p in pairs(plrs:GetPlayers()) do
       if p and p.Character and p.Character:FindFirstChild("_KillerEsp") then
        p.Character:FindFirstChild("_KillerEsp"):Destroy()
       end
       if p and p.Character and p.Character:FindFirstChild("_KillerWeapon") then
        local hl = new("Highlight", {
         Adornee = p.Character,
         FillColor = Color3.fromHex("#ff0000"),
         FillTransparency = 0.5,
         OutlineColor = Color3.fromHex("#000000"),
         Name = "_KillerEsp",
         Parent = p.Character
        })
       end
      end
     end)
    else
     for _, p in pairs(plrs:GetPlayers()) do
      if p and p.Character and p.Character:FindFirstChild("_KillerEsp") then
       p.Character:FindFirstChild("_KillerEsp"):Destroy()
      end
     end
     if espKiller then
      espKiller:Disconnect()
      espKiller = nil
     end
    end
  end
})

local espSurv = nil
espTab:Toggle({
  Name = "Survivor",
  Desc = "Highlight survivors { Green }",
  Default = false,
  Callback = function(v)
    if v then
     espSurv = rs.Heartbeat:Connect(function()
      for _, p in pairs(plrs:GetPlayers()) do
       if p and p.Character and p.Character:FindFirstChild("_SurvEsp") then
        p.Character:FindFirstChild("_SurvEsp"):Destroy()
       end
       if p and p.Character then
        local hl = new("Highlight", {
         Adornee = p.Character,
         FillColor = Color3.fromHex("#00ff0d"),
         FillTransparency = 0.5,
         OutlineColor = Color3.fromHex("#000000"),
         Name = "_SurvEsp",
         Parent = p.Character
        })
       end
      end
     end)
    else
     for _, p in pairs(plrs:GetPlayers()) do
      if p and p.Character and p.Character:FindFirstChild("_SurvEsp") then
       p.Character:FindFirstChild("_SurvEsp"):Destroy()
      end
     end
     if espSurv then
      espSurv:Disconnect()
      espSurv = nil
     end
    end
  end
})
