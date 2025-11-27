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
    label1:SetText("Hiding!")
    label1:SizeToContents()

    local label2 = self:Add("DLabel")
    label2:SetPos(10,50)
    label2:SetColor(Color(255,255,255,255))
    label2:SetFont("DermaDefault")
    label2:SetText("Hiding players are marked with blue name tags and blue clothes. Fellow hiders\nwill also have blue markers over their heads, but only when you're close\nenough to them!\n\nUse clever spots to keep out of seekers' sights!\nWhen choosing open hiding spots, think about your escape routes!\nTry not to waste your sprint when escaping seekers!\nTry to trick seekers that are chasing you as they can run slightly faster than you!\n\n\nLanding after jumping will cause a short slowdown. But be careful, falling a\ngreat height will make you let out a yelp, giving seekers an idea of your position!\nFalling from even bigger heights will affect your stamina too!")
    label2:SizeToContents()

    local model = self:Add("DModelPanel")
    model:SetSize(250,250)
    model:SetPos(360,8)
    model:SetModel("models/player/group01/male_0"..math.random(1,9)..".mdl")
    model:SetAnimated(true)
    model:SetAnimSpeed(1)

    function model:LayoutEntity() self:RunAnimation() end
    function model.Entity:GetPlayerColor() return Vector(0,0.2,0.6) end

end

vgui.Register("HNS.Help.Hiding", PANEL, "DPanel")

