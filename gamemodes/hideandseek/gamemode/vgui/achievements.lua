local PANEL = {}

-- TODO: Only allow one of these open at once, like with options

local achsOpen = false

function PANEL:Init()
    if achsOpens then
        self:Remove()
        return
    end
    achsOpen = true


    self:SetPos(45,ScrH()/2-300)
    self:SetSize(600,600)
    self:SetTitle("Hide and Seek - Achievements")
    self:SetScreenLock(true)
    self:ShowCloseButton(false)
    self:MakePopup()


    local AchieveLListing = self:Add("DPanel")
    AchieveLListing:SetPos(10,33)
    AchieveLListing:SetSize(self:GetWide()-20,self:GetTall()-74)
    AchieveLListing.Paint = function()
        draw.RoundedBox(0,0,0,AchieveLListing:GetWide(),AchieveLListing:GetTall(),Color(50,50,50,255))
    end
    local AchieveLPanel = AchieveLListing:Add("DPanel")
    AchieveLPanel:SetPos(5,5)
    AchieveLPanel:SetSize(AchieveLListing:GetWide()-26,3000)
    AchieveLPanel.Paint = function()
        draw.RoundedBox(0,0,0,AchieveLPanel:GetWide(),AchieveLPanel:GetTall(),Color(0,0,0,0))
    end
    local _ = 0
    local achtotal = table.Count(LocalPlayer().achsCompleted)
    for achID, ach in pairs(GAMEMODE.Achievements) do
        local AchieveLArea = AchieveLPanel:Add("DPanel")
        AchieveLArea:SetPos(24,24+(88*_))
        AchieveLArea:SetSize(AchieveLListing:GetWide()-74,80)

        AchieveLArea.Paint = function()
            --if LocalPlayer():GetPData("HAS_ACH_EARNED_"..k) == "true" then
            if LocalPlayer().achsCompleted[achID] then
                draw.RoundedBox(4,0,0,AchieveLArea:GetWide(),AchieveLArea:GetTall(),Color(120,180,120,255))
            else
                draw.RoundedBox(4,0,0,AchieveLArea:GetWide(),AchieveLArea:GetTall(),Color(140,140,140,255))
            end
        end

        local AchieveImage = (file.Exists("materials/has_achieve/icon_"..string.lower(ach.ImageName)..".png","GAME")) and "has_achieve/icon_"..string.lower(ach.ImageName)..".png" or "icon64/tool.png"

        local AchieveLLine1 = AchieveLArea:Add("DImage")
        AchieveLLine1:SetPos(8,8)
        AchieveLLine1:SetImage(AchieveImage)
        AchieveLLine1:SizeToContents()
        local AchieveLLine2a = AchieveLArea:Add("DLabel")
        AchieveLLine2a:SetPos(80,8)
        AchieveLLine2a:SetColor(Color(255,255,255,255))
        AchieveLLine2a:SetFont("Trebuchet24")
        AchieveLLine2a:SetText(ach.Name)
        AchieveLLine2a:SizeToContents()
        local AchieveLLine2b = AchieveLArea:Add("DLabel")
        AchieveLLine2b:SetPos(80,34)
        AchieveLLine2b:SetColor(Color(255,255,255,255))
        AchieveLLine2b:SetFont("DermaDefault")
        AchieveLLine2b:SetText(ach.Desc)
        AchieveLLine2b:SizeToContents()
        if ach.Goal then
            --if v.times == nil then
            --    Error("'"..k..".times' is a nil value. See the achievements table for '"..k.."'")
            --    surface.PlaySound("common/warning.wav")
            --    return
            --end

            local AchieveLLine3a = AchieveLArea:Add("DLabel")
            AchieveLLine3a:SetPos(80,52)
            AchieveLLine3a:SetColor(Color(255,255,255,255))
            AchieveLLine3a:SetFont("DermaDefault")
            --AchieveLLine3a:SetText(math.Clamp(tonumber(LocalPlayer():GetPData("HAS_ACH_PROGRESS_"..k)),0,ach.Goal).."/"..ach.Goal)

            local progress = ( LocalPlayer().achProgress[achID] or { ["progress"] = 0 } )["progress"]



            AchieveLLine3a:SetText(progress .. "/" .. ach.Goal)
            AchieveLLine3a:SizeToContents()
            local AchieveLLine3b = AchieveLArea:Add("DPanel")
            AchieveLLine3b:SetPos(150,52)
            AchieveLLine3b:SetSize(AchieveLArea:GetWide()-200,15)
            AchieveLLine3b.Paint = function()
                draw.RoundedBox(0,0,0,AchieveLLine3b:GetWide(),AchieveLLine3b:GetTall(),Color(50,50,50,255))
                --draw.RoundedBox(0,0,0,(math.Clamp(tonumber(LocalPlayer():GetPData("HAS_ACH_PROGRESS_"..k)),0,v.times)/v.times*100)*(AchieveLLine3b:GetWide()/100),AchieveLLine3b:GetTall(),Color(200,240,200,255))
                draw.RoundedBox(0,0,0,(progress / ach.Goal*100)*(AchieveLLine3b:GetWide()/100),AchieveLLine3b:GetTall(),Color(200,240,200,255))
            end
        end
        _ = _+1
    end
    local AchieveLScroller = AchieveLListing:Add("DVScrollBar")
    AchieveLScroller:SetPos(AchieveLListing:GetWide()-18,2)
    AchieveLScroller:SetSize(16,AchieveLListing:GetTall()-4)
    AchieveLScroller:SetUp(1,(48+(88*_))-AchieveLListing:GetTall())
    AchieveLScroller:SetEnabled(true)
    AchieveLScroller.Think = function()
        AchieveLPanel:SetPos(5,AchieveLScroller:GetOffset()+2)
    end
    local AchieveLExit = self:Add("DButton")
    AchieveLExit:SetPos(8,self:GetTall()-34)
    AchieveLExit:SetSize(200,26)
    AchieveLExit:SetText("Close")
    AchieveLExit.DoClick = function()
        self:Close()
        surface.PlaySound("garrysmod/ui_click.wav")
    end
    local AchieveLInfo1 = self:Add("DLabel")
    AchieveLInfo1:SetPos(218,self:GetTall()-34)
    AchieveLInfo1:SetColor(Color(255,255,255,255))
    AchieveLInfo1:SetFont("Trebuchet24")
    AchieveLInfo1:SetText(achtotal.."/"..table.Count(GAMEMODE.Achievements))
    AchieveLInfo1:SizeToContents()
    local cmbar = (LocalPlayer().IsAchMaster == true) and Color(240,240,190,255) or Color(200,240,200,255)
    local AchieveLInfo2 = self:Add("DPanel")
    AchieveLInfo2:SetPos(306,self:GetTall()-30)
    AchieveLInfo2:SetSize(self:GetWide()-316,15)
    AchieveLInfo2.Paint = function()
        draw.RoundedBox(0,0,0,AchieveLInfo2:GetWide(),AchieveLInfo2:GetTall(),Color(50,50,50,255))
        draw.RoundedBox(0,0,0,(achtotal/table.Count(GAMEMODE.Achievements)*100)*(AchieveLInfo2:GetWide()/100),AchieveLInfo2:GetTall(),cmbar)
    end
    if LocalPlayer().IsAchMaster == true then
        local AchieveLGoodie1 = self:Add("DImage")
        AchieveLGoodie1:SetPos(AchieveLInfo2:GetPos()-6,self:GetTall()-25)
        AchieveLGoodie1:SetImage("icon16/star.png")
        AchieveLGoodie1:SizeToContents()
        local AchieveLGoodie2 = self:Add("DImage")
        AchieveLGoodie2:SetPos((AchieveLInfo2:GetPos()+AchieveLInfo2:GetWide())-10,self:GetTall()-25)
        AchieveLGoodie2:SetImage("icon16/star.png")
        AchieveLGoodie2:SizeToContents()
    end


end

function PANEL:OnClose()
    achsOpen = false
end

vgui.Register("HNS.Achievements", PANEL, "DFrame")


