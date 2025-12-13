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




    local tabInterface = sheet:Add("HNS.Options.Interface")
    --tabInterface.Paint = function(this)
    --    surface.SetDrawColor(50, 50, 50, 255)
    --    surface.DrawRect(0, 0, this:GetWide(), this:GetTall())
    --end

    local tabPlayer = sheet:Add("HNS.Options.Player")
    local tabWorld = sheet:Add("HNS.Options.World")


    sheet:AddSheet("Interface", tabInterface, "icon16/application_edit.png")
    sheet:AddSheet("Player", tabPlayer, "icon16/user.png")
    sheet:AddSheet("World", tabWorld, "icon16/world.png")



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
        -- With most of the other options, we change the CVar while the user
        -- is in the menu, keeping the changes if they click Confirm and resetting them
        -- if they click Cancel. We don't do that with these options because
        -- you can't really see changes to them while you're still in the menu
        --
        -- (Gender only updates on player respawn)

        -- Player
        GAMEMODE.CVars.Gender:SetBool(tabPlayer.female)

        -- World
        GAMEMODE.CVars.CarryAngles:SetBool(tabWorld.carry)

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

        -- Interface
        GAMEMODE.CVars.ShowSpeed:SetBool(tabInterface.ogShowSpeed)
        GAMEMODE.CVars.SpeedX:SetInt(tabInterface.ogSpeedX)
        GAMEMODE.CVars.SpeedY:SetInt(tabInterface.ogSpeedY)


        GAMEMODE.CVars.HUD:SetInt(tabInterface.ogHUD)
        GAMEMODE.CVars.HUDScale:SetFloat(tabInterface.ogHUDScale)

        GAMEMODE.CVars.ThirdpersonMode:SetInt(tabInterface.ogSelected3p)

        GAMEMODE.CVars.SpecCams:SetBool(tabInterface.ogSpecCams)
        GAMEMODE.CVars.ShowID:SetBool(tabInterface.ogShowIDs)


        -- Player
        GAMEMODE.CVars.HiderColor:SetString(tabPlayer.ogColorHider)
        GAMEMODE.CVars.SeekerColor:SetString(tabPlayer.ogColorSeeker)


        self:Close()
        surface.PlaySound("garrysmod/ui_return.wav")
    end



end

function PANEL:OnClose()
    optionsOpen = false
end

vgui.Register("HNS.Options", PANEL, "DFrame")

