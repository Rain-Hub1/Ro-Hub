local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/Utils/Icons.lua"))()

local Window = OrionLib:MakeWindow({
    Name = "Ro Hub | Flee The Facility",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "Ro Hub Config",
    IntroEnabled = true,
    IntroText = "By rain / May contain bugs. / Pode conter bugs."
})

local InfoTab = Window:MakeTab({
	Name = "Info",
	Icon = Icons.user,
	PremiumOnly = false
})

local InfoSLP = InfoTab:AddSection({
	Name = "Info | LocalPlayer"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local LInfoLPN = InfoTab:AddLabel("Hello " .. LocalPlayer.Name .. "!")

local SettingsTab = Window:MakeTab({
	Name = "Settings",
	Icon = Icons.settings,
	PremiumOnly = false
})

OrionLib:MakeNotification({
	Name = "Ro Hub | Info",
	Content = "Hub loaded 100%",
	Image = "rbxassetid://4483345998",
	Time = 5
})
