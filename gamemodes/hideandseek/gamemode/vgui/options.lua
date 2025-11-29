local PANEL = {}

local optionsOpen = false

function PANEL:Init()
    if optionsOpen then
        self:Remove()
        return
    end
    optionsOpen = true


    --self:SetSize(300,300)
    self:SetSize(350,400)
    self:SetPos(45,ScrH()/2.5)
    self:SetTitle("Hide and Seek - Options")
    self:SetScreenLock(true)
    self:ShowCloseButton(false)
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)
    self:MakePopup()



    local sheet = self:Add("DColumnSheet")
    sheet:Dock(FILL)




    local tabInterface = sheet:Add("DPanel")
    tabInterface:SetBackgroundColor( Color(50, 50, 50) )
    --tabInterface.Paint = function(this)
    --    surface.SetDrawColor(50, 50, 50, 255)
    --    surface.DrawRect(0, 0, this:GetWide(), this:GetTall())
    --end

    tabInterface:DockPadding(4, 4, 4, 4)
    tabInterface:Dock(FILL)





    local boxSpecCams = tabInterface:Add("DCheckBoxLabel")
    boxSpecCams:Dock(BOTTOM)

    boxSpecCams:SetText("Show spectators?")
    boxSpecCams:SetChecked(GAMEMODE.CVars.SpecCams:GetBool())




    local boxShowIDs = tabInterface:Add("DCheckBoxLabel")

    boxShowIDs:Dock(BOTTOM)

    boxShowIDs:SetText("Show other players' Steam IDs?")
    boxShowIDs:SetChecked(GAMEMODE.CVars.ShowID:GetBool())







    local tabPA = sheet:Add("DPanel")
    --tabGender:SetPaintBackground(false)
    tabPA:SetBackgroundColor( Color(50, 50, 50) )
    tabPA:DockPadding(4, 4, 4, 4)
    tabPA:Dock(FILL)


    local labelGender = tabPA:Add("DLabel")
    labelGender:SetText("Gender")
    labelGender:Dock(TOP)


    local listGender = tabPA:Add("DComboBox")
    listGender:Dock(TOP)
    listGender:AddChoice("Male")
    listGender:AddChoice("Female")
    listGender:ChooseOptionID(GAMEMODE.CVars.Gender:GetBool() and 2 or 1)

    listGender.OnMousePressed = function(this)
        if this:IsMenuOpen() then
            this:CloseMenu()
        else
            this:OpenMenu()
        end

        surface.PlaySound("garrysmod/ui_hover.wav")
    end
    listGender.OnSelect = function()
        surface.PlaySound("garrysmod/ui_click.wav")
    end






    local selectedColorHider = GAMEMODE.CVars.HiderColor:GetString()
    local selectedColorSeeker = GAMEMODE.CVars.SeekerColor:GetString()

    local function AddColor(panel, color)
        local buttonColor = panel:Add("DColorButton")
        buttonColor:Dock(LEFT)
        buttonColor:DockMargin(0, 0, 2, 0)
        buttonColor:SetSize(panel:GetTall(), panel:GetTall())
        
        buttonColor:SetColor(color)
    
        return buttonColor
    end

    local labelHider = tabPA:Add("DLabel")
    labelHider:SetText("Hider color (" .. selectedColorHider .. ")")
    labelHider:Dock(TOP)


    local panelHider = tabPA:Add("DPanel")
    panelHider:SetPaintBackground(false)
    panelHider:Dock(TOP)


    local buttonPreviewHider
    for name, color in pairs(GAMEMODE.HiderColors) do

        AddColor(panelHider, color).DoClick = function(this)
            selectedColorHider = name
            labelHider:SetText("Hider color (" .. name .. ")")
            buttonPreviewHider:SetColor(color)
        end
            
    end




    local labelSeeker = tabPA:Add("DLabel")
    labelSeeker:SetText("Seeker color (" .. selectedColorSeeker .. ")")
    labelSeeker:Dock(TOP)

    local panelSeeker = tabPA:Add("DPanel")
    panelSeeker:SetPaintBackground(false)
    panelSeeker:Dock(TOP)


    local buttonPreviewSeeker
    for name, color in pairs(GAMEMODE.SeekerColors) do

        AddColor(panelSeeker, color).DoClick = function(this)
            selectedColorSeeker = name
            labelSeeker:SetText("Seeker color (" .. name .. ")")
            buttonPreviewSeeker:SetColor(color)
        end

    end




    local labelPreview = tabPA:Add("DLabel")
    labelPreview:SetText("Selected:")
    labelPreview:Dock(TOP)

    buttonPreviewSeeker = labelPreview:Add("DColorButton")
    buttonPreviewSeeker:Dock(RIGHT)
    buttonPreviewSeeker:DockMargin(2, 0, 0, 0)
    buttonPreviewSeeker:SetSize(labelPreview:GetTall(), labelPreview:GetTall())

    buttonPreviewSeeker:SetColor( GAMEMODE.SeekerColors[selectedColorSeeker] or GAMEMODE.SeekerColors.Default )



    buttonPreviewHider = labelPreview:Add("DColorButton")
    buttonPreviewHider:Dock(RIGHT)
    buttonPreviewHider:DockMargin(2, 0, 0, 0)
    buttonPreviewHider:SetSize(labelPreview:GetTall(), labelPreview:GetTall())

    buttonPreviewHider:SetColor( GAMEMODE.HiderColors[selectedColorHider] or GAMEMODE.HiderColors.Default )






    sheet:AddSheet("Interface", tabInterface, "icon16/application_edit.png")
    sheet:AddSheet("Player", tabPA, "icon16/user.png")



    local panelButtons = self:Add("DPanel")
    panelButtons:SetPaintBackground(false)

    -- Separate from sheet by 4 pixels
    panelButtons:DockMargin(0, 4, 0, 0)
    panelButtons:Dock(BOTTOM)

    local buttonConfirm = panelButtons:Add("DButton")
    --buttonConfirm:SetSize(197,20)
    --buttonConfirm:SetPos(8,272)
    buttonConfirm:Dock(LEFT)
    buttonConfirm:SetText("Confirm")
    buttonConfirm.DoClick = function()
        GAMEMODE.CVars.SpecCams:SetBool(boxSpecCams:GetChecked())
        GAMEMODE.CVars.ShowID:SetBool(boxShowIDs:GetChecked())

        -- Syntax error for some reason
        --GAMEMODE.CVars.Gender:SetBool( {true, false}[listGender:GetSelectedID()] )

        GAMEMODE.CVars.Gender:SetBool( tobool(listGender:GetSelectedID() - 1) )

        if selectedColorHider ~= nil then
            GAMEMODE.CVars.HiderColor:SetString(selectedColorHider)
        end

        if selectedColorSeeker ~= nil then
            GAMEMODE.CVars.SeekerColor:SetString(selectedColorSeeker)
        end

        self:Close()
        surface.PlaySound("garrysmod/save_load3.wav")
    end

    local buttonCancel = panelButtons:Add("DButton")
    --buttonCancel:SetSize(77,20)
    --buttonCancel:SetPos(213,272)
    buttonCancel:Dock(RIGHT)
    buttonCancel:SetText("Cancel")
    buttonCancel.DoClick = function()
        self:Close()
        surface.PlaySound("garrysmod/ui_return.wav")
    end



end

function PANEL:OnClose()
    optionsOpen = false
end

vgui.Register("HNS.Options", PANEL, "DFrame")

