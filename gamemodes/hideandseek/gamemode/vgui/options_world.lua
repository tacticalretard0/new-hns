local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor( Color(50, 50, 50) )
    self:DockPadding(4, 4, 4, 4)
    self:Dock(FILL)

    self.carry = GAMEMODE.CVars.CarryAngles:GetBool()
    local boxCarry = self:Add("DCheckBoxLabel")
    boxCarry:Dock(BOTTOM)

    boxCarry:SetText("Rotate props while carrying them?")
    boxCarry:SetChecked(self.carry)

    boxCarry.OnChange = function(this, newVal)
        self.carry = newVal
    end
end

vgui.Register("HNS.Options.World", PANEL, "DPanel")

