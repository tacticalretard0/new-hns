
GM:AddHook(function(_, _, tabs)
    table.insert(tabs, {name = "Player", icon = "icon16/user.png"})

end, "HASOptionsTabs", {"HNS", "AddPlayerTab"})



GM:AddHook(function(_, _, panel, cvars)
    table.insert(cvars, "has_gender")
    local og = GAMEMODE.CVars.Gender:GetBool()


    local labelGender = panel:Add("DLabel")
    labelGender:SetText("Gender (updates on respawn)")
    labelGender:Dock(TOP)




    -- TODO: Make this be radio buttons like the thirdperson option in the Interface tab
    local listGender = panel:Add("DComboBox")
    listGender:Dock(TOP)

    -- We need to wrap the bool in a table because there's a bug on this line:
    -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dcombobox.lua#L142
    --
    -- It should be checking for nil-ness but instead it checks for truthiness, which means
    -- you can't add false as data
    listGender:AddChoice("Male", {female = false}, not og)
    listGender:AddChoice("Female", {female = true}, og)

    listGender.OnMousePressed = function(this)
        if this:IsMenuOpen() then
            this:CloseMenu()
        else
            this:OpenMenu()
        end

        surface.PlaySound("garrysmod/ui_hover.wav")
    end
    listGender.OnSelect = function(this, _, _, data)
        GAMEMODE.CVars.Gender:SetBool(data.female)

        surface.PlaySound("garrysmod/ui_click.wav")
    end


    panel:Add("HNS.Hr")
end, "HASOptions_Player", {"HNS", "FillPlayerTab", "Gender"})




GM:AddHook(function(_, _, panel, cvars)
    table.insert(cvars, "has_hidercolor")
    table.insert(cvars, "has_seekercolor")

    local ogColorHider = GAMEMODE.CVars.HiderColor:GetString()
    local ogColorSeeker = GAMEMODE.CVars.SeekerColor:GetString()


    local function AddColor(panel, color)
        local buttonColor = panel:Add("DColorButton")
        buttonColor:Dock(LEFT)
        buttonColor:DockMargin(0, 0, 2, 0)
        buttonColor:SetSize(panel:GetTall(), panel:GetTall())
        
        buttonColor:SetColor(color)
    
        return buttonColor
    end

    local labelHider = panel:Add("DLabel")
    labelHider:SetText("Hider color (" .. ogColorHider .. ")")
    labelHider:Dock(TOP)


    local panelHider = panel:Add("DPanel")
    panelHider:SetPaintBackground(false)
    panelHider:Dock(TOP)


    local buttonPreviewHider
    for name, color in pairs(GAMEMODE.HiderColors) do

        AddColor(panelHider, color).DoClick = function(this)
            GAMEMODE.CVars.HiderColor:SetString(name)

            labelHider:SetText("Hider color (" .. name .. ")")
            buttonPreviewHider:SetColor(color)
        end
            
    end




    local labelSeeker = panel:Add("DLabel")
    labelSeeker:SetText("Seeker color (" .. ogColorSeeker .. ")")
    labelSeeker:Dock(TOP)

    local panelSeeker = panel:Add("DPanel")
    panelSeeker:SetPaintBackground(false)
    panelSeeker:Dock(TOP)


    local buttonPreviewSeeker
    for name, color in pairs(GAMEMODE.SeekerColors) do

        AddColor(panelSeeker, color).DoClick = function(this)
            GAMEMODE.CVars.SeekerColor:SetString(name)

            labelSeeker:SetText("Seeker color (" .. name .. ")")
            buttonPreviewSeeker:SetColor(color)
        end

    end




    local labelPreview = panel:Add("DLabel")
    labelPreview:SetText("Selected:")
    labelPreview:Dock(TOP)

    buttonPreviewSeeker = labelPreview:Add("DColorButton")
    buttonPreviewSeeker:Dock(RIGHT)
    buttonPreviewSeeker:DockMargin(2, 0, 0, 0)
    buttonPreviewSeeker:SetSize(labelPreview:GetTall(), labelPreview:GetTall())

    buttonPreviewSeeker:SetColor( GAMEMODE.SeekerColors[ogColorSeeker] or GAMEMODE.SeekerColors.Default )



    buttonPreviewHider = labelPreview:Add("DColorButton")
    buttonPreviewHider:Dock(RIGHT)
    buttonPreviewHider:DockMargin(2, 0, 0, 0)
    buttonPreviewHider:SetSize(labelPreview:GetTall(), labelPreview:GetTall())

    buttonPreviewHider:SetColor( GAMEMODE.HiderColors[ogColorHider] or GAMEMODE.HiderColors.Default )


end, "HASOptions_Player", {"HNS", "FillPlayerTab", "Color"})


