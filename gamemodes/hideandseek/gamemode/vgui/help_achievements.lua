local PANEL = {}

function PANEL:Init()
    self:SetPos(5,20)
    self:SetSize(570,281)
    self.Paint = function()
        surface.SetDrawColor(50,50,50,255)
        surface.DrawRect(0,0,self:GetWide(),self:GetTall())
    end

    local label1 = self:Add("DLabel")
    label1:SetPos(10, 10)
    label1:SetColor(COLOR_WHITE)
    label1:SetFont("DermaLarge")
    label1:SetText("Achievements!")
    label1:SizeToContents()

    local label2 = self:Add("DLabel")
    label2:SetPos(10, 50)
    label2:SetColor(COLOR_WHITE)
    label2:SetFont("DermaDefault")
    label2:SetText("Hide and Seek now has its own achievements!\nMore achievements are bound to be added at some point, so be prepared.\n\nNow this is where things can get interesting. As you play, you're able to earn achievements!\nThese achievements can give you personal goals and make rounds more exciting.\nWhy not try to get all of the achievements? It's possible, especially when\nyour achievements are saved cross-server! This means you don't need to stay on the\nsame server to earn all of the achievements!\n\nYou can see the achievement list by typing 'has_achievements' in the console.\nOr you can press the button below to view the list.")
    label2:SizeToContents()

    local label3 = self:Add("DButton")
    label3:SetSize(142, 25)
    label3:SetPos(10, 205)
    label3:SetText("View Achievements")
    label3.DoClick = function()
        local frameAchs = vgui.Create("HNS.Achievements")
        frameAchs:SetPlayer(LocalPlayer())

        surface.PlaySound("garrysmod/content_downloaded.wav")
    end


    -- TODO: create the help menu after the achievement data has been received, so we can know the count
    local numAchsCompleted = LocalPlayer().achsCompleted and table.Count(LocalPlayer().achsCompleted) or "?"


    local label4 = self:Add("DLabel")
    label4:SetPos(28, 245)
    label4:SetColor(COLOR_WHITE)
    label4:SetFont("DermaDefault")
    label4:SetText("Achievements earned: " .. numAchsCompleted .. "/" .. GAMEMODE.AchievementsCount)
    label4:SizeToContents()

    local label5 = self:Add("DImage")
    label5:SetPos(10, 244)
    label5:SetImage("icon16/medal_gold_2.png")
    label5:SizeToContents()
end

vgui.Register("HNS.Help.Achievements", PANEL, "DPanel")

