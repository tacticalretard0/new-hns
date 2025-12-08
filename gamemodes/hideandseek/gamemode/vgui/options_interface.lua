local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor( Color(50, 50, 50) )

    self:DockPadding(4, 4, 4, 4)
    self:Dock(FILL)




    self.ogHUD = GAMEMODE.CVars.HUD:GetInt()

    local labelHUD = self:Add("DLabel")
    labelHUD:SetText("HUD style")
    labelHUD:Dock(TOP)


    local listHUD = self:Add("DComboBox")
    listHUD:Dock(TOP)

    for i, hud in ipairs(GAMEMODE.HUDs) do
        listHUD:AddChoice(hud.Name, i, i == self.ogHUD)
    end

    listHUD.OnMousePressed = function(this)
        if this:IsMenuOpen() then
            this:CloseMenu()
        else
            this:OpenMenu()
        end

        surface.PlaySound("garrysmod/ui_hover.wav")
    end
    listHUD.OnSelect = function(this, _, _, data)
        GAMEMODE.CVars.HUD:SetInt(data)
        surface.PlaySound("garrysmod/ui_click.wav")
    end



    

    self.ogHUDScale = GAMEMODE.CVars.HUDScale:GetFloat()

    local labelHUDScale = self:Add("DLabel")
    labelHUDScale:SetText("HUD scale")
    labelHUDScale:Dock(TOP)
    
    local sliderHUDScale = self:Add("DNumSlider")
    sliderHUDScale.Label:Hide()
    sliderHUDScale:SetMinMax(1, 6)
    sliderHUDScale:SetDecimals(2)
    sliderHUDScale:SetValue(self.ogHUDScale)
    sliderHUDScale:Dock(TOP)

    sliderHUDScale.OnValueChanged = function(this, newVal)
        -- Change in intervals of 0.25
        newVal = 0.25 * math.Round(newVal / 0.25)
        this:SetValue(newVal)

        GAMEMODE.CVars.HUDScale:SetFloat(newVal)
    end





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

    boxSpecCams:SetText("Show spectator cameras?")
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

