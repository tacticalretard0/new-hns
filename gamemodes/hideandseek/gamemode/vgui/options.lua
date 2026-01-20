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




    local tabs = {}
    hook.Run("HASOptionsTabs", tabs)


    local cvarsToSave = {}

    for _, tab in ipairs(tabs) do

        local panel = self:Add("DPanel")

        panel:SetBackgroundColor( Color(50, 50, 50) )
        panel:DockPadding(4, 4, 4, 4)
        panel:Dock(FILL)


        hook.Run("HASOptions_" .. tab.name, panel, cvarsToSave)


        sheet:AddSheet(tab.name, panel, tab.icon)
    end


    local ogCVars = {}
    for _, cvar in ipairs(cvarsToSave) do
        ogCVars[cvar] = GetConVar(cvar):GetString()
    end




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

        self:Close()
        surface.PlaySound("garrysmod/save_load3.wav")
    end

    local buttonCancel = panelButtons:Add("DButton")
    --buttonCancel:SetSize(77,20)
    --buttonCancel:SetPos(213,272)
    buttonCancel:Dock(RIGHT)
    buttonCancel:SetText("Cancel")
    buttonCancel.DoClick = function()
        -- Reset CVars

        for cvar, og in pairs(ogCVars) do
            GetConVar(cvar):SetString(og)
        end

        self:Close()
        surface.PlaySound("garrysmod/ui_return.wav")
    end



end

function PANEL:OnClose()
    optionsOpen = false
end

vgui.Register("HNS.Options", PANEL, "DFrame")

