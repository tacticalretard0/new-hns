-- Like the <hr> element in HTML

local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor( Color(127, 127, 127) )
    self:SetHeight(1)

    self:DockMargin(0, 4, 0, 4)
    self:Dock(TOP)
end



vgui.Register("HNS.Hr", PANEL, "DPanel")

