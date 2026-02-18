local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local RS = game:GetService("RunService")
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
local plr = game:GetService("Players").LocalPlayer
local WorldV = plr:WaitForChild("leaderstats"):WaitForChild("WORLD")
local OrbFolder = workspace.Map.Stages.Boosts

local farmLoop = nil
local farmPowerLoop = nil
local warpConn = nil
local autoWorldLoop = nil
local punchLoop = nil
local upgradePetLoop = nil

local function GetWorldT()
  return tonumber(Options.FarmWorld.Value)
end

local function GetHRP()
  local char = plr.Character
  return char and char:FindFirstChild("HumanoidRootPart")
end

local function FireWarp(dir)
  Remote:FireServer(unpack({ { "WarpPlrToOtherMap", dir } }))
end

local function StopAutoFarmPower()
  if farmPowerLoop then
    task.cancel(farmPowerLoop)
    farmPowerLoop = nil
  end
end

local function StartAutoFarmPower()
  if farmPowerLoop then return end
  farmPowerLoop = task.spawn(function()
    while Toggles.AutoFarmPower.Value do
      local WorldT = WorldV.Value
      local worldFolder = OrbFolder:FindFirstChild(tostring(WorldT))
      if worldFolder then
        for stage = 4, 1, -1 do
          if not Toggles.AutoFarmPower.Value then break end
          local map = worldFolder:FindFirstChild("MAP_" .. WorldT .. "_" .. stage)
          if map then
            for _, orb in ipairs(map:GetChildren()) do
              if not Toggles.AutoFarmPower.Value then break end
              local part = orb:IsA("BasePart") and orb
                or (orb:IsA("Model") and (orb.PrimaryPart or orb:FindFirstChildWhichIsA("BasePart")))
              local hrp = GetHRP()
              if part and hrp then
                if Options.FarmMode.Value == "Tp" then
                  hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                else
                  part.Touched:Fire(hrp)
                end
                task.wait(0.2)
              end
            end
          end
        end
      end
      task.wait(0.2)
    end
  end)
end

local function StopAutoOrb()
  if farmLoop then
    task.cancel(farmLoop)
    farmLoop = nil
  end
end

local function StartAutoOrb()
  if farmLoop then return end
  farmLoop = task.spawn(function()
    while Toggles.AutoOrb.Value do
      local WorldT = WorldV.Value
      local worldFolder = OrbFolder:FindFirstChild(tostring(WorldT))
      if worldFolder then
        for stage = 4, 1, -1 do
          if not Toggles.AutoOrb.Value then break end
          local map = worldFolder:FindFirstChild("MAP_" .. WorldT .. "_" .. stage)
          if map then
            for _, orb in ipairs(map:GetChildren()) do
              if not Toggles.AutoOrb.Value then break end
              local part = orb:IsA("BasePart") and orb
                or (orb:IsA("Model") and (orb.PrimaryPart or orb:FindFirstChildWhichIsA("BasePart")))
              local hrp = GetHRP()
              if part and hrp then
                if Options.FarmMode.Value == "Tp" then
                  hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                else
                  part.Touched:Fire(hrp)
                end
                task.wait(0.2)
              end
            end
          end
        end
      end
      task.wait(0.2)
    end
  end)
end

local function StopAutoWarp()
  if warpConn then
    warpConn:Disconnect()
    warpConn = nil
  end
end

local function StartAutoWarp()
  StopAutoWarp()
  local WorldT = GetWorldT()
  local current = WorldV.Value
  if current == WorldT then
    if Toggles.AutoOrb.Value then StartAutoOrb() end
    return
  end
  local dir = current < WorldT and "Next" or "Previous"
  warpConn = RS.Heartbeat:Connect(function()
    FireWarp(dir)
  end)
  WorldV.Changed:Connect(function(val)
    if val == WorldT then
      StopAutoWarp()
      if Toggles.AutoOrb.Value then StartAutoOrb() end
    end
  end)
end

local function StopAutoWorld()
  if autoWorldLoop then
    task.cancel(autoWorldLoop)
    autoWorldLoop = nil
  end
end

local function StartAutoWorld()
  if autoWorldLoop then return end
  autoWorldLoop = task.spawn(function()
    local lastWorld = WorldV.Value
    while Toggles.AutoWorld.Value do
      Remote:FireServer(unpack({ { "WarpPlrToOtherMap", "Next" } }))
      task.wait(2)
      local newWorld = WorldV.Value
      if newWorld ~= lastWorld then
        lastWorld = newWorld
        Options.FarmWorld:SetValue(tostring(newWorld))
        if Toggles.AutoOrb.Value then
          StopAutoFarmPower()
  StopAutoOrb()
          StartAutoOrb()
        end
      end
    end
  end)
end

local function StopAutoPunch()
  if punchLoop then
    punchLoop:Disconnect()
    punchLoop = nil
  end
end

local function StartAutoPunch()
  if punchLoop then return end
  punchLoop = RS.Heartbeat:Connect(function()
    local args = {
      {
        "Activate_Punch"
      }
    }
    Remote:FireServer(unpack(args))
  end)
end

local function StopAutoUpgradePet()
  if upgradePetLoop then
    upgradePetLoop:Disconnect()
    upgradePetLoop = nil
  end
end

local function StartAutoUpgradePet()
  if upgradePetLoop then return end
  upgradePetLoop = RS.Heartbeat:Connect(function()
    local args = {
      {
        "UpgradeCurrentPet"
      }
    }
    Remote:FireServer(unpack(args))
  end)
end

local AUTOEXEC_FILE = "kaitun_autoexec.lua"
local SCRIPT_URL = ".lua"

local function WriteAutoExec()
  writefile(AUTOEXEC_FILE, string.format([[
    loadstring(game:HttpGet("%s"))()
  ]], SCRIPT_URL))
end

local function ServerHop()
  local TS = game:GetService("TeleportService")
  local HttpService = game:GetService("HttpService")
  local placeId = game.PlaceId
  WriteAutoExec()
  local servers = HttpService:JSONDecode(game:HttpGet(
    "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
  ))
  for _, server in ipairs(servers.data) do
    if server.id ~= game.JobId and server.playing < server.maxPlayers then
      TS:TeleportToPlaceInstance(placeId, server.id, plr)
      return
    end
  end
  -- Se não achou servidor diferente, tenta de novo após 3s
  task.delay(3, ServerHop)
end

local function CollectAllOrbs()
  local WorldT = WorldV.Value
  local worldFolder = OrbFolder:FindFirstChild(tostring(WorldT))
  if not worldFolder then return end
  for stage = 4, 1, -1 do
    local map = worldFolder:FindFirstChild("MAP_" .. WorldT .. "_" .. stage)
    if map then
      for _, orb in ipairs(map:GetChildren()) do
        local part = orb:IsA("BasePart") and orb
          or (orb:IsA("Model") and (orb.PrimaryPart or orb:FindFirstChildWhichIsA("BasePart")))
        local hrp = GetHRP()
        if part and hrp then
          hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
        end
      end
    end
  end
end

local function StartKaitun()
  -- Ativa todos os toggles
  Toggles.AutoFarmPower:SetValue(true)
  Toggles.AutoWarp:SetValue(true)
  Toggles.AutoWorld:SetValue(true)
  Toggles.AutoPunch:SetValue(true)
  Toggles.AutoUpgradePet:SetValue(true)

  -- Coleta tudo de uma vez sem wait
  CollectAllOrbs()

  -- Espera chegar no destino do AutoWarp antes de ligar o AutoOrb
  task.spawn(function()
    local WorldT = GetWorldT()
    while WorldV.Value ~= WorldT do
      task.wait(0.5)
    end
    Toggles.AutoOrb:SetValue(true)
  end)

  -- Troca de servidor após coletar
  task.delay(2, function()
    ServerHop()
  end)
end


  Title = "Orb Farm",
  Footer = "v1.0",
  ShowCustomCursor = true,
  NotifySide = "Right",
})

local Tabs = {
  Main = Window:AddTab("Main", "home"),
  ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local FarmTabBox = Tabs.Main:AddLeftTabbox()
local Box = FarmTabBox:AddTab("Farm")
local AutoBox = FarmTabBox:AddTab("Auto")

local WorldValues = {}
for w = 1, 18 do table.insert(WorldValues, tostring(w)) end

Box:AddToggle("Kaitun", {
  Text = "Kaitun",
  Default = false,
  Tooltip = "Coleta tudo, ativa tudo e troca de servidor automaticamente",
  Callback = function(val)
    if val then StartKaitun() end
  end,
})

Box:AddToggle("AutoFarmPower", {
  Text = "Auto Farm Power",
  Default = false,
  Tooltip = "Farma power em loop no mundo atual",
  Callback = function(val)
    if val then StartAutoFarmPower() else StopAutoFarmPower() end
  end,
})

Box:AddDropdown("FarmMode", {
  Values = { "Tp", "Touch" },
  Default = 1,
  Multi = false,
  Text = "Farm Mode",
  Tooltip = "Tp: teleporta até a orb | Touch: dispara Touched na orb",
})

Box:AddDropdown("FarmWorld", {
  Values = WorldValues,
  Default = 18,
  Multi = false,
  Text = "World",
  Tooltip = "Mundo alvo para warpar",
})

Box:AddToggle("AutoOrb", {
  Text = "Auto Orb",
  Default = false,
  Tooltip = "Coleta as orbs do mundo atual",
  Callback = function(val)
    if val then StartAutoOrb() else StopAutoOrb() end
  end,
})

Box:AddToggle("AutoWarp", {
  Text = "Auto Warp",
  Default = false,
  Tooltip = "Vai automaticamente até o mundo selecionado",
  Callback = function(val)
    if val then StartAutoWarp() else StopAutoWarp() end
  end,
})

Box:AddToggle("AutoWorld", {
  Text = "Auto World",
  Default = false,
  Tooltip = "Sobe de estágio a cada 2s e atualiza o mundo automaticamente",
  Callback = function(val)
    if val then StartAutoWorld() else StopAutoWorld() end
  end,
})

AutoBox:AddToggle("AutoPunch", {
  Text = "Auto Punch",
  Default = false,
  Tooltip = "Usa o punch sem parar até desligar",
  Callback = function(val)
    if val then StartAutoPunch() else StopAutoPunch() end
  end,
})

AutoBox:AddToggle("AutoUpgradePet", {
  Text = "Auto Upgrade Pet",
  Default = false,
  Tooltip = "Faz upgrade do pet atual sem parar até desligar",
  Callback = function(val)
    if val then StartAutoUpgradePet() else StopAutoUpgradePet() end
  end,
})

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("ShowCustomCursor", {
  Text = "Custom Cursor",
  Default = true,
  Callback = function(v)
    Library.ShowCustomCursor = v
  end,
})

MenuGroup:AddLabel("Menu bind")
  :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
  StopAutoOrb()
  StopAutoWarp()
  StopAutoWorld()
  StopAutoPunch()
  StopAutoUpgradePet()
  Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("OrbFarm")
SaveManager:SetFolder("OrbFarm/configs")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
