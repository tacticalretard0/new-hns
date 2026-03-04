local PANEL = {}

-- TODO: Only allow one of these open at once, like with options

local achsOpen = false

function PANEL:Init()
    if achsOpens then
        self:Remove()
        return
    end
    achsOpen = true


    self:SetPos(45, ScrH()/2 - 300)
    self:SetSize(600, 600)
    self:SetTitle("Hide and Seek - Achievements")
    self:SetScreenLock(true)
    self:ShowCloseButton(false)
    self:MakePopup()


    local scroll = self:Add("DScrollPanel")
    scroll:SetPos(10, 33)
    scroll:SetSize(self:GetWide() - 20, self:GetTall() - 74)
    scroll.Paint = function()
        draw.RoundedBox(0, 0, 0, scroll:GetWide(), scroll:GetTall(), Color(50, 50, 50))
    end

    scroll:GetCanvas():DockPadding(8, 8, 8, 8)


    for achID, ach in pairs(GAMEMODE.Achievements) do
        local panelAch = scroll:Add("DPanel")
        panelAch:Dock(TOP)

        -- Note: the bottom margin doesn't seem to add any space under the last panelAch element, the top margin does though
        panelAch:DockMargin(0, 0, 0, 8)
        panelAch:SetSize(scroll:GetWide() - 74, 80)


        panelAch.Paint = function()
            if LocalPlayer().achsCompleted[achID] then
                draw.RoundedBox(4, 0, 0, panelAch:GetWide(), panelAch:GetTall(), Color(120, 180, 120))
            else
                draw.RoundedBox(4, 0, 0, panelAch:GetWide(), panelAch:GetTall(), Color(140, 140, 140))
            end
        end


        local path = "materials/has_achieve/icon_" .. string.lower(ach.ImageName) .. ".png"
        path = file.Exists(path, "GAME") and path or "icon64/tool.png"

        local image = panelAch:Add("DImage")
        image:SetPos(8, 8)
        image:SetImage(path)
        image:SizeToContents()

        local labelName = panelAch:Add("DLabel")
        labelName:SetPos(80, 8)
        labelName:SetColor(Color(255, 255, 255))
        labelName:SetFont("Trebuchet24")
        labelName:SetText(ach.Name)
        labelName:SizeToContents()

        local labelDesc = panelAch:Add("DLabel")
        labelDesc:SetPos(80, 34)
        labelDesc:SetColor(Color(255, 255, 255))
        labelDesc:SetFont("DermaDefault")
        labelDesc:SetText(ach.Desc)
        labelDesc:SizeToContents()

        if ach.Goal then
            --if v.times == nil then
            --    Error("'"..k..".times' is a nil value. See the achievements table for '"..k.."'")
            --    surface.PlaySound("common/warning.wav")
            --    return
            --end

            local labelProg = panelAch:Add("DLabel")
            labelProg:SetPos(80, 52)
            labelProg:SetColor(COLOR_WHITE)
            labelProg:SetFont("DermaDefault")

            local progress = ( LocalPlayer().achProgress[achID] or { ["progress"] = 0 } )["progress"]



            labelProg:SetText(progress .. "/" .. ach.Goal)
            labelProg:SizeToContents()

            local panelProgBar = panelAch:Add("DPanel")
            panelProgBar:SetPos(150, 52)
            panelProgBar:SetSize(panelAch:GetWide() - 200, 15)
            panelProgBar.Paint = function()
                draw.RoundedBox(0, 0, 0, panelProgBar:GetWide(), panelProgBar:GetTall(), Color(50, 50, 50))
                draw.RoundedBox(0, 0, 0, progress / ach.Goal * panelProgBar:GetWide(), panelProgBar:GetTall(), Color(200, 240, 200, 255))
            end
        end
    end

    local buttonExit = self:Add("DButton")
    buttonExit:SetPos(8, self:GetTall() - 34)
    buttonExit:SetSize(200, 26)
    buttonExit:SetText("Close")
    buttonExit.DoClick = function()
        self:Close()
        surface.PlaySound("garrysmod/ui_click.wav")
    end



    local numAchsCompleted = table.Count(LocalPlayer().achsCompleted)

    local labelInfo1 = self:Add("DLabel")
    labelInfo1:SetPos(218, self:GetTall() - 34)
    labelInfo1:SetColor(COLOR_WHITE)
    labelInfo1:SetFont("Trebuchet24")
    labelInfo1:SetText(numAchsCompleted .. "/" .. GAMEMODE.AchievementsCount)
    labelInfo1:SizeToContents()



    local colorProgBar = LocalPlayer().achMaster and Color(240, 240, 190) or Color(200, 240, 200)

    local panelProgBar = self:Add("DPanel")
    panelProgBar:SetPos(306, self:GetTall() - 30)
    panelProgBar:SetSize(self:GetWide() - 316, 15)
    panelProgBar.Paint = function()
        draw.RoundedBox(0, 0, 0, panelProgBar:GetWide(), panelProgBar:GetTall(), Color(50, 50, 50))
        draw.RoundedBox(0, 0, 0, numAchsCompleted / GAMEMODE.AchievementsCount * panelProgBar:GetWide(), panelProgBar:GetTall(), colorProgBar)
    end


    if LocalPlayer().achMaster then
        -- Yay
        local imageStar1 = self:Add("DImage")
        imageStar1:SetPos(labelInfo2:GetPos() - 6, self:GetTall() - 25)
        imageStar1:SetImage("icon16/star.png")
        imageStar1:SizeToContents()

        local imageStar2 = self:Add("DImage")
        imageStar2:SetPos(labelInfo2:GetPos() + labelInfo2:GetWide() - 10, self:GetTall() - 25)
        imageStar2:SetImage("icon16/star.png")
        imageStar2:SizeToContents()
    end


end

function PANEL:OnClose()
    achsOpen = false
end

vgui.Register("HNS.Achievements", PANEL, "DFrame")


