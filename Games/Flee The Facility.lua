local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

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
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local InfoSLP = InfoTab:AddSection({
	Name = "Info | LocalPlayer"
})

local PInfoLPN = InfoTab:AddParagraph("Hello " .. PlayerName .. "!", "")

OrionLib:MakeNotification({
	Name = "Ro Hub | Info",
	Content = "Hub loaded 100%",
	Image = "rbxassetid://4483345998",
	Time = 5
})
