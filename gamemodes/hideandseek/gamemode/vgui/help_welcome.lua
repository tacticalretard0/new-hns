local PANEL = {}

function PANEL:Init()
    self:SetPos(5,20)
    self:SetSize(570,281)
    self.Paint = function()
        surface.SetDrawColor(50,50,50,255)
        surface.DrawRect(0,0,self:GetWide(),self:GetTall())
    end

    local label1 = self:Add("DLabel")
    label1:SetPos(10,10)
    label1:SetColor(Color(255,255,255,255))
    label1:SetFont("DermaLarge")
    label1:SetText("Welcome to Hide and Seek!")
    label1:SizeToContents()

    local label2 = self:Add("DLabel")
    label2:SetPos(10,50)
    label2:SetColor(Color(255,255,255,255))
    label2:SetFont("DermaDefault")
    --label2:SetText("You've probably heard of the classic game of 'Hide and Seek', right? It's pretty much those very same rules!\n\nThere are two teams, the hiders and the seekers.\nHiding players have to hide away from the seekers while seeking players have to find the hiding\nplayers, simple! Now go play some good old Hide and Seek.\n\n\nHide and Seek buttons -\nF1 = Opens this help-box, click other tabs for more help!\nF2 = Opens team select.\nRELOAD = Taunt.\n\nPossible requirements -\n'Team Fortress 2' to fully hear gamemode audio.\n'Counter-Strike: Source' for maps that servers could host.\n'Left 4 Dead' to have a nice landing sound, not so important.")
    label2:SetText("You've probably heard of the classic game of 'Hide and Seek', right? It's pretty much those very same rules!\n\nThere are two teams, the hiders and the seekers.\nHiding players have to hide away from the seekers while seeking players have to find the hiding\nplayers, simple! Now go play some good old Hide and Seek.\n\n\nHide and Seek buttons -\nF1 = Opens this help-box, click other tabs for more help!\nF2 = Opens team select.\nRELOAD = Taunt.\n\nPossible requirements -\n'Team Fortress 2' to fully hear gamemode audio.\n'Counter-Strike: Source' for maps that servers could host.")
    label2:SizeToContents()
end

vgui.Register("HNS.Help.Welcome", PANEL, "DPanel")


