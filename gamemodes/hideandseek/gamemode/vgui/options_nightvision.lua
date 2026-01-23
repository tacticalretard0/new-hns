
GM:AddHook(function(_, _, tabs)
    if not GAMEMODE.CVars.HiderNV:GetBool() then return end

    table.insert(tabs, {name = "Night Vision", icon = "icon16/find.png"})
    --table.insert(tabs, {name = "Night Vision", icon = "icon16/eye.png"})
    --table.insert(tabs, {name = "Night Vision", icon = "icon16/lightbulb.png"})
    --table.insert(tabs, {name = "Night Vision", icon = "icon16/webcam.png"})

end, "HASOptionsTabs", {"HNS", "AddWorldTab"})




GM:AddHook(function(_, _, panel, cvars)
    table.insert(cvars, "has_nightvis_preferred")

    local boxNV = panel:Add("DCheckBoxLabel")

    boxNV:SetText("Use night vision instead of flashlight?")
    boxNV:SetConVar("has_nightvis_preferred")

    boxNV:Dock(TOP)


    panel:Add("HNS.Hr")

end, "HASOptions_Night Vision", {"HNS", "FillNVTab", "NVPreferred"})




-- TODO: make the slider snap like the HUD scale slider
GM:AddHook(function(_, _, panel, cvars)
    table.insert(cvars, "has_nightvis_contrast")


    local sliderContrast = panel:Add("DNumSlider")
    sliderContrast:SetText("Contrast")

    sliderContrast:SetConVar("has_nightvis_contrast")

    -- Why does SetConVar not do this automatically
    local cv = GAMEMODE.CVars.NVContrast
    sliderContrast:SetMinMax(cv:GetMin(), cv:GetMax())


    sliderContrast:Dock(TOP)


    panel:Add("HNS.Hr")

end, "HASOptions_Night Vision", {"HNS", "FillNVTab", "NVContrast"})



-- Whether or not to emit dynamic light, and its radius
GM:AddHook(function(_, _, panel, cvars)
    table.insert(cvars, "has_nightvis_dynlight")
    table.insert(cvars, "has_nightvis_dynlight_size")

    --table.insert(cvars, "has_")

    local boxDynLight = panel:Add("DCheckBoxLabel")
    boxDynLight:SetText("Use dynamic light?")

    boxDynLight:SetConVar("has_nightvis_dynlight")

    boxDynLight:Dock(TOP)





    local sliderSize = panel:Add("DNumSlider")
    sliderSize:SetText("Light size")

    sliderSize:SetConVar("has_nightvis_dynlight_size")

    local cv = GAMEMODE.CVars.NVDynLightSize
    sliderSize:SetMinMax(cv:GetMin(), cv:GetMax())


    sliderSize:Dock(TOP)



    panel:Add("HNS.Hr")

end, "HASOptions_Night Vision", {"HNS", "FillNVTab", "NVDynamicLight"})


GM:AddHook(function(_, _, panel, cvars)
    table.insert(cvars, "has_nightvis_r")
    table.insert(cvars, "has_nightvis_g")
    table.insert(cvars, "has_nightvis_b")


    local labelColor = panel:Add("DLabel")
    labelColor:SetText("Color")

    labelColor:Dock(TOP)


    local mixerColor = panel:Add("DColorMixer")
    mixerColor:SetAlphaBar(false)

    mixerColor:SetConVarR("has_nightvis_r")
    mixerColor:SetConVarG("has_nightvis_g")
    mixerColor:SetConVarB("has_nightvis_b")


    mixerColor:SetTall(mixerColor:GetTall() / 1.5)


    mixerColor:Dock(TOP)

end, "HASOptions_Night Vision", {"HNS", "FillNVTab", "NVColor"})

