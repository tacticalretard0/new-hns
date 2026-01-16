function GM:KeyPress(ply, key)
    if key == IN_ATTACK2 and ply:KeyDown(IN_SCORE) and IsValid(self.Scoreboard) and self.Scoreboard:IsVisible() then
        gui.EnableScreenClicker(true)
    end
end

function GM:ScoreboardShow()
    local classic = GAMEMODE.CVars.ScoreboardClassic:GetBool()


    if not IsValid(self.Scoreboard) then
        self.Scoreboard = vgui.Create(classic and "HNS.ScoreboardClassic" or "HNS.Scoreboard")
    end


    timer.Create("HNS.ScoreboardRefresh", 0.8, 0, function()
        self.Scoreboard:RefreshPlayers()
    end)


    self.Scoreboard:Show()

    if not classic then self.Scoreboard:UpdateDimentions() end

end

function GM:ScoreboardHide()
    if IsValid(self.Scoreboard) then
        -- Don't bother refreshing if the scoreboard isn't visible
        timer.Remove("HNS.ScoreboardRefresh")

        self.Scoreboard:Hide()

        gui.EnableScreenClicker(false)
    end
end

cvars.AddChangeCallback("has_scob_classic", function()
    if not IsValid(GAMEMODE.Scoreboard) then return end

    timer.Remove("HNS.ScoreboardRefresh")
    GAMEMODE.Scoreboard:Remove()
end)


local function ScoreboardReSort()
    if not IsValid(GAMEMODE.Scoreboard) or not GAMEMODE.Scoreboard:IsVisible() then return end

    if GAMEMODE.CVars.ScoreboardClassic:GetBool() then
        GAMEMODE.Scoreboard:RefreshPlayers()
    else
        GAMEMODE.Scoreboard:SortPlayers()
    end
end

cvars.AddChangeCallback("has_scob_sort_reversed", ScoreboardReSort, "HNS.ScoreboardUpdate")
cvars.AddChangeCallback("has_scob_sort", ScoreboardReSort, "HNS.ScoreboardUpdate")
cvars.AddChangeCallback("has_scob_ontop", ScoreboardReSort, "HNS.ScoreboardUpdate")


function GM:HASScoreboardMenu(menu, ply)
    local pnl = menu:AddOption("", function()
        ply:SetMuted(not ply:IsMuted())
    end)

    pnl:SetIcon(ply:IsMuted() and "icon16/sound_mute.png" or "icon16/sound.png")
    pnl:DockPadding(0, 0, 0, 20)
    pnl.Paint = function(this, w, h)
        derma.SkinHook("Paint", "MenuOption", this, h + 6, h)
    end

    pnl.Container = pnl:Add("DPanel")
    pnl.Container:SetPos(27, 0)
    pnl.Container:SetSize(140, 24)
    pnl.Container.Paint = function() end

    pnl.Volume = pnl.Container:Add("DNumSlider")
    pnl.Volume:Dock(FILL)
    pnl.Volume:SetMinMax(0, 100)
    pnl.Volume:SetValue(math.floor(ply:GetVoiceVolumeScale() * 100))
    pnl.Volume:SetDecimals(0)
    pnl.Volume:SetDark(true)
    pnl.Volume.Label:Hide()
    pnl.Volume.TextArea:SetWide(24)
    pnl.Volume.OnValueChanged = function(this, value)
        value = math.floor(value) / 100
        ply:SetVoiceVolumeScale(value)

        if value > 0 then
            pnl:SetIcon("icon16/sound.png")
            ply:SetMuted(false)
        else
            pnl:SetIcon("icon16/sound_mute.png")
        end
    end

    menu:AddPanel(pnl)

    menu:AddOption("Open Profile", function()
        ply:ShowProfile()
    end):SetIcon("icon16/user.png")



    menu:AddSpacer()

    menu:AddOption("Copy Name", function()
        SetClipboardText(ply:Name())
    end):SetIcon("icon16/shield.png")

    menu:AddOption("Copy Steam ID (" .. ply:Name() .. ")", function()
        SetClipboardText(ply:SteamID())
    end):SetIcon("icon16/shield.png")
end

