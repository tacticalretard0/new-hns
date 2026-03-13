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
    label1:SetText("Seeking!")
    label1:SizeToContents()

    local label2 = self:Add("DLabel")
    label2:SetPos(10,50)
    label2:SetColor(Color(255,255,255,255))
    label2:SetFont("DermaDefault")
    --label2:SetText("Seeking players are marked with red name tags and red clothes.\nFellow seekers will also have red markers over their heads!\nYou can catch hiders by running into them or clicking them while close!\n\nCheck simple hiding spots as well as hard-to-reach places!\nUse your sprint when you're chasing hiders!\nWatch your teammates' arrows, if they are all in one spot,\nthey could be chasing someone! Team up with other seekers to quickly cover an area!\nDon't give up on chasing someone, you have a slight speed advantage over hiders!\n\n\nLanding after jumping will cause a short slowdown. But be careful, falling a\ngreat height will make you let out a yelp, letting hiders know you're close!\nFalling from even bigger heights will affect your stamina too!\nYou are also able to use a flashlight to find hiders in dark places.")
    label2:SetText("Seeking players are marked with red name tags and red clothes.\nFellow seekers will also have red markers over their heads!\nYou can catch hiders by running into them or clicking them while close!\n\nCheck simple hiding spots as well as hard-to-reach places!\nUse your sprint when you're chasing hiders!\nWatch your teammates' arrows, if they are all in one spot,\nthey could be chasing someone! Team up with other seekers to quickly cover an area!\nDon't give up on chasing someone, you have a slight speed advantage over hiders!\n\n\nBe careful, falling a great height will make you let out a yelp, letting hiders know you're close!\nFalling from even bigger heights will affect your stamina too!\nYou are also able to use a flashlight to find hiders in dark places.")
    label2:SizeToContents()

    local model = self:Add("DModelPanel")
    model:SetSize(250,250)
    model:SetPos(360,8)
    model:SetModel("models/player/group01/male_0"..math.random(1,9)..".mdl")
    model:SetAnimated(true)
    model:SetAnimSpeed(1)

    function model:LayoutEntity() self:RunAnimation() end
    function model.Entity:GetPlayerColor() return Vector(0.6,0.2,0) end
end

vgui.Register("HNS.Help.Seeking", PANEL, "DPanel")

