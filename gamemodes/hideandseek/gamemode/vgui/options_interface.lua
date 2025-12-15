local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor( Color(50, 50, 50) )

    self:DockPadding(4, 4, 4, 4)
    self:Dock(FILL)




    self.ogShowSpeed = GAMEMODE.CVars.ShowSpeed:GetBool()

    local boxShowSpeed = self:Add("DCheckBoxLabel")
    boxShowSpeed:SetConVar("has_showspeed")

    boxShowSpeed:SetText("Show movement speed?")
    boxShowSpeed:Dock(TOP)




    local labelSpeedPos = self:Add("DLabel")
    labelSpeedPos:SetText("Speed position (X, Y)")
    labelSpeedPos:Dock(TOP)






    local panelSpeedPos = self:Add("DPanel")
    panelSpeedPos:SetPaintBackground(false)
    panelSpeedPos:Dock(TOP)


    self.ogSpeedX = GAMEMODE.CVars.SpeedX:GetInt()
    self.ogSpeedY = GAMEMODE.CVars.SpeedY:GetInt()


    local wangSpeedX = panelSpeedPos:Add("DNumberWang")
    local wangSpeedY = panelSpeedPos:Add("DNumberWang")

    wangSpeedX:Dock(LEFT)
    wangSpeedY:Dock(LEFT)


    wangSpeedX:SetMinMax(45, ScrW() - 45)
    wangSpeedY:SetMinMax(30, ScrH() - 30)


    -- The DCheckBoxLabel shows the right value because of the SetConVar call.
    -- That doesn't seem to work here though
    wangSpeedX:SetValue(self.ogSpeedX)
    wangSpeedY:SetValue(self.ogSpeedY)

    wangSpeedX:SetConVar("has_speedx")
    wangSpeedY:SetConVar("has_speedy")





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
    boxSpecCams:SetConVar("has_spec_cams")





    self.ogShowIDs = GAMEMODE.CVars.ShowID:GetBool()

    local boxShowIDs = self:Add("DCheckBoxLabel")
    boxShowIDs:Dock(BOTTOM)

    boxShowIDs:SetText("Show other players' Steam IDs?")
    boxShowIDs:SetConVar("has_showid")




    self.ogOnTop = GAMEMODE.CVars.ShowOnTop:GetBool()

    local boxOnTop = self:Add("DCheckBoxLabel")
    boxOnTop:Dock(BOTTOM)

    boxOnTop:SetText("Put yourself first on the scoreboard?")
    boxOnTop:SetConVar("has_scob_ontop")




end

vgui.Register("HNS.Options.Interface", PANEL, "DPanel")

