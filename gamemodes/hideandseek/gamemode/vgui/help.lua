local PANEL = {}

local firstHelp = true
function PANEL:Init()
	self:SetSize(600,400)
	self:SetPos(25,ScrH()/4)
	self:SetTitle("Hide and Seek - Help")
	self:SetScreenLock(true)
	self:ShowCloseButton(false)
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	self:MakePopup()
	local sheet = self:Add("DPropertySheet")

	sheet:SetSize(580,326)
	sheet:SetPos(10,30)

	local buttonPlay = self:Add("DButton")
	buttonPlay:SetSize(200,30)
	buttonPlay:SetPos(10,360)
	buttonPlay:SetText("Let's play!")
	buttonPlay.DoClick = function()
		self:Close()
		if firstHelp then
			GAMEMODE:TeamSelect()
			firstHelp = false
		end
		surface.PlaySound("garrysmod/save_load3.wav")
	end

	local buttonOptions = self:Add("DButton")
	buttonOptions:SetSize(80,30)
	buttonOptions:SetPos(510,360)
	buttonOptions:SetText("Options")
	buttonOptions.DoClick = function()
		vgui.Create("HNS.Options")
		surface.PlaySound("garrysmod/ui_click.wav")
	end

	local tabWelcome = sheet:Add("HNS.Help.Welcome")

	local tabAchievements = sheet:Add("HNS.Help.Achievements")
	
	local tabHiding = sheet:Add("HNS.Help.Hiding")

	local tabSeeking = sheet:Add("HNS.Help.Seeking")
	
	local tabSpectating = sheet:Add("HNS.Help.Spectating")




	sheet:AddSheet("Welcome", tabWelcome, "icon16/cake.png", false, false, "1 - Welcome to Hide and Seek!")
	sheet:AddSheet("Achievements", tabAchievements, "icon16/medal_gold_3.png", false, false, "2 - About achievements.")
	sheet:AddSheet("Hiding", tabHiding, "icon16/user.png", false, false, "3 - About hiding players.")
	sheet:AddSheet("Seeking", tabSeeking, "icon16/user_red.png", false, false, "4 - About seeking players.")
	sheet:AddSheet("Spectating", tabSpectating, "icon16/camera.png", false, false, "5 - About spectating.")
end


vgui.Register("HNS.Help", PANEL, "DFrame")

