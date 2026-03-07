
GM:AddHook(function(_, _, tabs)
    table.insert(tabs, {name = "Interface", icon = "icon16/application_edit.png"})

end, "HASOptionsTabs", {"HNS", "AddInterfaceTab"})



GM:AddHook(function(gm, _, panel, cvars)
    if not gm.CVars.ThirdpersonAllowed:GetBool() then return end

    table.insert(cvars, "has_thirdperson_mode")
    local og = gm.CVars.ThirdpersonMode:GetInt()


    local label3p = panel:Add("DLabel")
    label3p:SetText("Third person mode")
    label3p:Dock(TOP)

    local panel3p = panel:Add("DPanel")
    panel3p:SetPaintBackground(false)
    panel3p:Dock(TOP)

    local button3pSelected
    for i, text in ipairs( {"Left", "Center", "Right"} ) do
        local button3p = panel3p:Add("DButton")
        button3p:SetText(text)
        button3p:DockMargin(0, 0, 1, 0)
        button3p:Dock(LEFT)

        if i == og then
            button3pSelected = button3p
            button3p:SetToggle(true)
        end


        button3p.DoClick = function(this)
            button3pSelected:SetToggle(false)
            button3pSelected = this
            gm.CVars.ThirdpersonMode:SetInt(i)

            this:SetToggle(true)
        end
    end


    panel:Add("HNS.Hr")
end, "HASOptions_Interface", {"HNS", "FillInterfaceTab", "ThirdpersonMode"})




GM:AddHook(function(gm, _, panel, cvars)
    table.insert(cvars, "has_hud")
    table.insert(cvars, "has_hud_scale")

    local ogHUD = gm.CVars.HUD:GetInt()


    local labelHUD = panel:Add("DLabel")
    labelHUD:SetText("HUD style")
    labelHUD:Dock(TOP)


    local listHUD = panel:Add("DComboBox")
    listHUD:Dock(TOP)

    for i, hud in ipairs(gm.HUDs) do
        listHUD:AddChoice(hud.Name, i, i == ogHUD)
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
        gm.CVars.HUD:SetInt(data)
        surface.PlaySound("garrysmod/ui_click.wav")
    end





    local ogScale = gm.CVars.HUDScale:GetFloat()


    local labelHUDScale = panel:Add("DLabel")
    labelHUDScale:SetText("HUD scale")
    labelHUDScale:Dock(TOP)
    
    local sliderHUDScale = panel:Add("DNumSlider")
    sliderHUDScale.Label:Hide()
    sliderHUDScale:SetMinMax(1, 6)
    sliderHUDScale:SetDecimals(2)
    sliderHUDScale:SetValue(ogScale)
    sliderHUDScale:Dock(TOP)

    sliderHUDScale.OnValueChanged = function(this, newVal)
        -- Change in intervals of 0.25
        newVal = 0.25 * math.Round(newVal / 0.25)
        this:SetValue(newVal)

        gm.CVars.HUDScale:SetFloat(newVal)
    end


    panel:Add("HNS.Hr")
end, "HASOptions_Interface", {"HNS", "FillInterfaceTab", "HUD"})




GM:AddHook(function(gm, _, panel, cvars)
    --local og = gm.CVars.ShowSpeed:GetBool()
    table.insert(cvars, "has_showspeed")
    table.insert(cvars, "has_speedx")
    table.insert(cvars, "has_speedy")


    local boxShowSpeed = panel:Add("DCheckBoxLabel")
    boxShowSpeed:SetConVar("has_showspeed")

    boxShowSpeed:SetText("Show movement speed?")

    boxShowSpeed:Dock(TOP)





    local ogX = gm.CVars.SpeedX:GetInt()
    local ogY = gm.CVars.SpeedY:GetInt()



    local labelSpeedPos = panel:Add("DLabel")
    labelSpeedPos:SetText("Speed position (X, Y)")
    labelSpeedPos:Dock(TOP)


    local panelSpeedPos = panel:Add("DPanel")
    panelSpeedPos:SetPaintBackground(false)
    panelSpeedPos:Dock(TOP)




    local wangSpeedX = panelSpeedPos:Add("DNumberWang")
    local wangSpeedY = panelSpeedPos:Add("DNumberWang")

    wangSpeedX:Dock(LEFT)
    wangSpeedY:Dock(LEFT)


    wangSpeedX:SetMinMax(45, ScrW() - 45)
    wangSpeedY:SetMinMax(30, ScrH() - 30)


    -- The DCheckBoxLabel for ShowSpeed shows the right value because of the SetConVar call.
    -- That doesn't seem to work here though
    wangSpeedX:SetValue(ogX)
    wangSpeedY:SetValue(ogY)

    wangSpeedX:SetConVar("has_speedx")
    wangSpeedY:SetConVar("has_speedy")


    panel:Add("HNS.Hr")
end, "HASOptions_Interface", {"HNS", "FillInterfaceTab", "Speed"})




GM:AddHook(function(gm, _, panel, cvars)
    --local og = gm.CVars.ScoreboardClassic:GetBool()
    table.insert(cvars, "has_scob_classic")

    local boxScoreboard = panel:Add("DCheckBoxLabel")
    boxScoreboard:Dock(TOP)

    boxScoreboard:SetText("Use classic scoreboard style?")
    boxScoreboard:SetConVar("has_scob_classic")



    --local og = gm.CVars.ShowOnTop:GetBool()
    table.insert(cvars, "has_scob_ontop")

    local boxOnTop = panel:Add("DCheckBoxLabel")
    boxOnTop:Dock(TOP)

    boxOnTop:SetText("Put yourself first on the scoreboard?")
    boxOnTop:SetConVar("has_scob_ontop")




    table.insert(cvars, "has_avatarframes")

    local boxFrames = panel:Add("DCheckBoxLabel")
    boxFrames:Dock(TOP)

    boxFrames:SetText("Show Steam avatar frames?")
    boxFrames:SetConVar("has_avatarframes")


    panel:Add("HNS.Hr")
end, "HASOptions_Interface", {"HNS", "FillInterfaceTab", "Scoreboard"})





GM:AddHook(function(gm, _, panel, cvars)
    --local og = gm.CVars.SpecCams:GetBool()
    table.insert(cvars, "has_spec_cams")

    local boxSpecCams = panel:Add("DCheckBoxLabel")
    boxSpecCams:Dock(TOP)

    boxSpecCams:SetText("Show spectator cameras?")
    boxSpecCams:SetConVar("has_spec_cams")


    panel:Add("HNS.Hr")
end, "HASOptions_Interface", {"HNS", "FillInterfaceTab", "SpecCams"})





GM:AddHook(function(gm, _, panel, cvars)
    --local og = gm.CVars.ShowID:GetBool()
    table.insert(cvars, "has_showid")

    local boxShowIDs = panel:Add("DCheckBoxLabel")
    boxShowIDs:Dock(TOP)

    boxShowIDs:SetText("Show other players' Steam IDs?")
    boxShowIDs:SetConVar("has_showid")

end, "HASOptions_Interface", {"HNS", "FillInterfaceTab", "ShowID"})


