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
    label1:SetText("Spectating!")
    label1:SizeToContents()

    local label2 = self:Add("DLabel")
    label2:SetPos(10,50)
    label2:SetColor(Color(255,255,255,255))
    label2:SetFont("DermaDefault")
    label2:SetText("Spectating is for when you want to take a break and want to stay in the server.\nIn some servers, you would have to spectate when you're caught and\nwait for the next round to start playing again.\n\nWhile spectating, you can... I don't know... think about future hiding spots?\nBut don't ghost for other players. Because that's a silly move...\n\nYou are able to see other spectators if you have 'Show spectators?' ticked\nin your settings menu. You can access it by clicking 'Options' below or by \nrunning 'has_options' in the console.")
    label2:SizeToContents()

    local model = self:Add("DModelPanel")
    model:SetSize(250,250)
    model:SetPos(360,8)
    model:SetModel("models/tools/camera/camera.mdl")
    model:SetCamPos(Vector(25,25,0))
    model:SetLookAt(Vector(0,0,0))

    function model:LayoutEntity() end
end

vgui.Register("HNS.Help.Spectating", PANEL, "DPanel")

