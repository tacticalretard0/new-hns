local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor( Color(50, 50, 50) )

    self:DockPadding(4, 4, 4, 4)
    self:Dock(FILL)

    self.ogSelected3p = GAMEMODE.CVars.ThirdpersonMode:GetInt()
    if GAMEMODE.CVars.ThirdpersonAllowed:GetBool() then

        local label3p = self:Add("DLabel")
        label3p:SetText("Third person mode")
        label3p:Dock(TOP)

        local panel3p = self:Add("DPanel")
        panel3p:SetPaintBackground(false)
        panel3p:Dock(TOP)

        local button3pSelected
        for i, text in ipairs( {"Left", "Center", "Right"} ) do
            local button3p = panel3p:Add("DButton")
            button3p:SetText(text)
            button3p:DockMargin(0, 0, 1, 0)
            button3p:Dock(LEFT)

            if i == self.ogSelected3p then
                button3pSelected = button3p
                button3p:SetToggle(true)
            end


            button3p.DoClick = function(this)
                button3pSelected:SetToggle(false)
                button3pSelected = this
                GAMEMODE.CVars.ThirdpersonMode:SetInt(i)

                this:SetToggle(true)
            end
        end

    end



    self.ogSpecCams = GAMEMODE.CVars.SpecCams:GetBool()

    local boxSpecCams = self:Add("DCheckBoxLabel")
    boxSpecCams:Dock(BOTTOM)

    boxSpecCams:SetText("Show spectators?")
    boxSpecCams:SetChecked(self.ogSpecCams)

    boxSpecCams.OnChange = function(this, newVal)
        GAMEMODE.CVars.SpecCams:SetBool(newVal)
    end




    self.ogShowIDs = GAMEMODE.CVars.ShowID:GetBool()

    local boxShowIDs = self:Add("DCheckBoxLabel")

    boxShowIDs:Dock(BOTTOM)

    boxShowIDs:SetText("Show other players' Steam IDs?")
    boxShowIDs:SetChecked(self.ogShowIDs)

    boxShowIDs.OnChange = function(this, newVal)
        GAMEMODE.CVars.ShowID:SetBool(newVal)
    end


end

vgui.Register("HNS.Options.Interface", PANEL, "DPanel")

