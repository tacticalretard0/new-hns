local PANEL = {}

local optionsOpen = false

function PANEL:Init()
    if optionsOpen then
        self:Remove()
        return
    end
    optionsOpen = true


    self:SetSize(300,300)
    self:SetPos(45,ScrH()/2.5)
    self:SetTitle("Hide and Seek - Options")
    self:SetScreenLock(true)
    self:ShowCloseButton(false)
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(true)
    self:MakePopup()

    local imageGender = self:Add("DImage")
    imageGender:SetPos(10,29)
    imageGender:SetImage("icon16/user.png")
    imageGender:SizeToContents()

    local labelGender = self:Add("DLabel")
    labelGender:SetPos(28,30)
    labelGender:SetColor(Color(255,255,255,255))
    labelGender:SetFont("DermaDefault")
    labelGender:SetText("Gender:")
    labelGender:SizeToContents()

    local listGender = self:Add("DComboBox")
    listGender:SetPos(8,45)
    listGender:SetSize(65,20)
    listGender:AddChoice("Male")
    listGender:AddChoice("Female")
    listGender:ChooseOptionID(GAMEMODE.CVars.Gender:GetBool() and 2 or 1)
    listGender.OnMousePressed = function()
        if listGender:IsMenuOpen() then
            listGender:CloseMenu()
        else
            listGender:OpenMenu()
        end

        surface.PlaySound("garrysmod/ui_hover.wav")
    end
    listGender.OnSelect = function()
        surface.PlaySound("garrysmod/ui_click.wav")
    end
    
    -- TODO: Use a DCheckBoxLabel?
    local boxSpecCams = self:Add("DCheckBox")
    boxSpecCams:SetPos(8,216)
    boxSpecCams:SetChecked(GAMEMODE.CVars.SpecCams:GetBool())

    local labelSpecCams = self:Add("DLabel")
    labelSpecCams:SetPos(28,217)
    labelSpecCams:SetColor(Color(255,255,255,255))
    labelSpecCams:SetFont("DermaDefault")
    labelSpecCams:SetText("Show spectators?")
    labelSpecCams:SizeToContents()

    local buttonConfirm = self:Add("DButton")
    buttonConfirm:SetSize(197,20)
    buttonConfirm:SetPos(8,272)
    buttonConfirm:SetText("Confirm")
    buttonConfirm.DoClick = function()
        GAMEMODE.CVars.SpecCams:SetBool(boxSpecCams:GetChecked())

        -- Syntax error for some reason
        --GAMEMODE.CVars.Gender:SetBool( {true, false}[listGender:GetSelectedID()] )

        GAMEMODE.CVars.Gender:SetBool( tobool(listGender:GetSelectedID() - 1) )

        --OptionsOpen = false
        --local genderf = (genderchoice == nil) and file.Read("hideandseek/gender.txt","DATA") or DermaList1:GetOptionText(genderchoice)
        --local soundf = (soundchoice == nil) and file.Read("hideandseek/notifsound.txt","DATA") or soundchoice
        --local colorf = (tstam == 0) and DermaColorM:GetColor() or "DEFAULT"
        --file.Write("hideandseek/gender.txt",genderf)
        --file.Write("hideandseek/notifsound.txt",soundf)
        --if tstam == 0 then
        --    file.Write("hideandseek/staminacol.txt",colorf.r..","..colorf.g..","..colorf.b)
        --else
        --    file.Write("hideandseek/staminacol.txt",colorf)
        --end
        --file.Write("hideandseek/visual.txt",tostring(showcams))
        self:Close()
        surface.PlaySound("garrysmod/save_load3.wav")
        --net.Start("PLYOption_Change")
        --net.SendToServer()
    end

    local buttonCancel = self:Add("DButton")
    buttonCancel:SetSize(77,20)
    buttonCancel:SetPos(213,272)
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

