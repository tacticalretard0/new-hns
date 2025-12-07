local PANEL = {}

function PANEL:Init()
    self:SetBackgroundColor( Color(50, 50, 50) )
    self:DockPadding(4, 4, 4, 4)
    self:Dock(FILL)


    local labelGender = self:Add("DLabel")
    labelGender:SetText("Gender (updates on respawn)")
    labelGender:Dock(TOP)


    self.female = GAMEMODE.CVars.Gender:GetBool()

    -- TODO: Make this be radio buttons like the thirdperson option in the Interface tab
    local listGender = self:Add("DComboBox")
    listGender:Dock(TOP)

    -- We need to wrap the bool in a table because there's a bug on this line:
    -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dcombobox.lua#L142
    --
    -- It should be checking for nil-ness but instead it checks for truthiness, which means
    -- you can't add false as data
    listGender:AddChoice("Male", {female = false}, not self.female)
    listGender:AddChoice("Female", {female = true}, self.female)

    listGender.OnMousePressed = function(this)
        if this:IsMenuOpen() then
            this:CloseMenu()
        else
            this:OpenMenu()
        end

        surface.PlaySound("garrysmod/ui_hover.wav")
    end
    listGender.OnSelect = function(this, _, data)
        self.female = data.female
        surface.PlaySound("garrysmod/ui_click.wav")
    end






    self.ogColorHider = GAMEMODE.CVars.HiderColor:GetString()
    self.ogColorSeeker = GAMEMODE.CVars.SeekerColor:GetString()

    local function AddColor(panel, color)
        local buttonColor = panel:Add("DColorButton")
        buttonColor:Dock(LEFT)
        buttonColor:DockMargin(0, 0, 2, 0)
        buttonColor:SetSize(panel:GetTall(), panel:GetTall())
        
        buttonColor:SetColor(color)
    
        return buttonColor
    end

    local labelHider = self:Add("DLabel")
    labelHider:SetText("Hider color (" .. self.ogColorHider .. ")")
    labelHider:Dock(TOP)


    local panelHider = self:Add("DPanel")
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




    local labelSeeker = self:Add("DLabel")
    labelSeeker:SetText("Seeker color (" .. self.ogColorSeeker .. ")")
    labelSeeker:Dock(TOP)

    local panelSeeker = self:Add("DPanel")
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




    local labelPreview = self:Add("DLabel")
    labelPreview:SetText("Selected:")
    labelPreview:Dock(TOP)

    buttonPreviewSeeker = labelPreview:Add("DColorButton")
    buttonPreviewSeeker:Dock(RIGHT)
    buttonPreviewSeeker:DockMargin(2, 0, 0, 0)
    buttonPreviewSeeker:SetSize(labelPreview:GetTall(), labelPreview:GetTall())

    buttonPreviewSeeker:SetColor( GAMEMODE.SeekerColors[self.ogColorSeeker] or GAMEMODE.SeekerColors.Default )



    buttonPreviewHider = labelPreview:Add("DColorButton")
    buttonPreviewHider:Dock(RIGHT)
    buttonPreviewHider:DockMargin(2, 0, 0, 0)
    buttonPreviewHider:SetSize(labelPreview:GetTall(), labelPreview:GetTall())

    buttonPreviewHider:SetColor( GAMEMODE.HiderColors[self.ogColorHider] or GAMEMODE.HiderColors.Default )

end

vgui.Register("HNS.Options.Player", PANEL, "DPanel")

