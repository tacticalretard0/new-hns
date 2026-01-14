local PANEL = {}

local function Hide()
    surface.PlaySound("garrysmod/content_downloaded.wav")
    GAMEMODE:ScoreboardHide()
end


function PANEL:Init()

    local specs = {}




    self:SetPos(0,0)
    self:SetSize(ScrW(),ScrH())
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:SetDraggable(false)



    self.Paint = function()
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,0))
    end


    local frameHead = self:Add("DFrame")
    frameHead:SetPos(ScrW()/2-400,80)
    frameHead:SetSize(800,40)
    frameHead:SetTitle("")
    frameHead:ShowCloseButton(false)
    frameHead:SetDraggable(false)

    frameHead.Paint = function()
        draw.RoundedBox(16,0,0,frameHead:GetWide(),frameHead:GetTall(),Color(0,0,0,200))
    end

    local labelHNS = frameHead:Add("DLabel")
    labelHNS:SetPos(612,6)
    labelHNS:SetColor(Color(255,255,255,255))
    labelHNS:SetFont("DermaLarge")
    labelHNS:SetText("Hide and Seek")
    labelHNS:SizeToContents()


    local labelHost = frameHead:Add("DLabel")
    labelHost:SetPos(12,5)
    labelHost:SetColor(Color(255,255,255,255))
    labelHost:SetFont("DermaDefault")
    labelHost:SetText(GetHostName())
    labelHost:SizeToContents()


    local labelMap = frameHead:Add("DLabel")
    labelMap:SetPos(12,20)
    labelMap:SetColor(Color(255,255,255,255))
    labelMap:SetFont("DermaDefault")
    labelMap:SetText(game.GetMap())
    labelMap:SizeToContents()


    local labelVersion = frameHead:Add("DLabel")
    labelVersion:SetPos(575,20)
    labelVersion:SetColor(Color(255,255,255,255))
    labelVersion:SetFont("DermaDefault")
    labelVersion:SetText("v1.2b")
    labelVersion:SizeToContents()


    local labelNumPlayers = frameHead:Add("DLabel")
    labelNumPlayers:SetPos(495,20)
    labelNumPlayers:SetColor(Color(255,255,255,255))
    labelNumPlayers:SetFont("DermaDefault")
    labelNumPlayers:SetText(#player.GetAll().." / "..game.MaxPlayers())
    labelNumPlayers:SizeToContents()


    local imageVersion = frameHead:Add("DImage")
    imageVersion:SetPos(555,19)
    imageVersion:SetImage("icon16/server_uncompressed.png")
    imageVersion:SizeToContents()


    local imageNumPlayers = frameHead:Add("DImage")
    imageNumPlayers:SetPos(475,19)
    imageNumPlayers:SetImage("icon16/status_offline.png")
    imageNumPlayers:SizeToContents()


    local buttonHNS = frameHead:Add("DButton")
    buttonHNS:SetSize(173,26)
    buttonHNS:SetPos(612,6)
    buttonHNS:SetText("")
    buttonHNS.Paint = function() end

    buttonHNS.DoClick = function()
        --RunConsoleCommand("has_help")
        vgui.Create("HNS.Help")
        Hide()
    end

    buttonHNS.DoRightClick = function()
        local menuHead = DermaMenu()
        self:HeadMenu(menuHead)
        menuHead:Open()

        surface.PlaySound("garrysmod/ui_click.wav")
    end



    local sortTab = player.GetAll()
    if GAMEMODE.CVars.Sort:GetInt() == 3 then
        table.sort(sortTab, function(a,b) return a:Name() < b:Name() end)

    elseif GAMEMODE.CVars.Sort:GetInt() == 2 then
        table.sort(sortTab, function(a,b) return a:Frags() > b:Frags() end)
    end


    if GAMEMODE.CVars.ShowOnTop:GetBool() then
        table.RemoveByValue(sortTab, LocalPlayer())
        table.insert(sortTab, 1, LocalPlayer())
    end


    local n = 0
    for _, ply in ipairs(sortTab) do
        if ply:Team() == TEAM_SPECTATOR then
            table.insert(specs, ply)
            continue
        end

        n = n+1
        local size = (team.NumPlayers(TEAM_SPECTATOR) > 0 and n < 5) and 550 or 724

        local framePly = self:Add("DFrame")
        framePly:SetPos(ScrW()/2-365,84+(38*n))
        framePly:SetSize(size,36)
        framePly:SetTitle("")
        framePly:ShowCloseButton(false)
        framePly:SetDraggable(false)





        -- TODO: Make achievements stuff work
        framePly.Think = function()
            local achflash = (math.sin(CurTime()*2.5)*12)+55
            local acol = (ply.IsAchMaster == true) and Color(achflash,achflash*0.8,0,200) or Color(0,0,0,200)
            framePly.Paint = function()
                draw.RoundedBox(4,0,0,framePly:GetWide(),framePly:GetTall(),acol)
            end
        end
        if ply.IsAchMaster == true then
            for i=0,2 do
                local q = (i == 1) and 113 or 111
                local imageStars = self:Add("DImage")
                imageStars:SetPos(ScrW()/2-352+(i*15),q+(38*n))
                imageStars:SetSize(9,9)
                imageStars:SetImage("icon16/star.png")
            end
        end





        local avatarPly = framePly:Add("AvatarImage")
        avatarPly:SetSize(32,32)
        avatarPly:SetPos(2,2)
        avatarPly:SetPlayer(ply,32)

        local buttonPlyAv = framePly:Add("DButton")
        buttonPlyAv:SetSize(32,32)
        buttonPlyAv:SetPos(2,2)
        buttonPlyAv:SetText("")
        buttonPlyAv.Paint = function()
            draw.RoundedBox(0,0,0,buttonPlyAv:GetWide(),buttonPlyAv:GetTall(),Color(0,0,0,0))
        end
        buttonPlyAv.DoClick = function(DermaButton)
            ply:ShowProfile()
            Hide()
        end
        buttonPlyAv.DoRightClick = function()
            -- NOTE: Maybe use DermaMenu() like line 506 of vgui/scoreboard.lua
            local menu = DermaMenu()
            hook.Run("HASScoreboardMenu", menu, ply)
            menu:Open()

            surface.PlaySound("garrysmod/ui_click.wav")
        end

        local labelPlyName = framePly:Add("DLabel")
        labelPlyName:SetPos(40,4)
        if ply:SteamID() == "STEAM_0:0:33106902" then labelPlyName:SetColor(Color(245,210,125,255)) else labelPlyName:SetColor(Color(255,255,255,255)) end
        labelPlyName:SetFont("DermaDefaultBold")
        labelPlyName:SetText(ply:Name())
        labelPlyName:SizeToContents()

        local labelPlyScore = framePly:Add("DLabel")
        labelPlyScore:SetPos(40,18)
        labelPlyScore:SetColor(Color(255,255,255,255))
        labelPlyScore:SetFont("DermaDefault")
        labelPlyScore:SetText("Score: "..ply:Frags())
        labelPlyScore:SizeToContents()

        local labelPlyPing = framePly:Add("DLabel")
        labelPlyPing:SetPos(framePly:GetWide()-24,11)
        labelPlyPing:SetColor(Color(255,255,255,255))
        labelPlyPing:SetFont("DermaDefault")
        labelPlyPing:SetText(ply:Ping())
        labelPlyPing:SizeToContents()

        local imagePlyPing = framePly:Add("DImage")
        imagePlyPing:SetPos(framePly:GetWide()-44,10)
        if ply:Ping() > 5 then imagePlyPing:SetImage("icon16/transmit_blue.png") else imagePlyPing:SetImage("icon16/server_connect.png") end
        imagePlyPing:SizeToContents()




        if ply:GetFriendStatus() != "none" then
            local imagePlyFriend = framePly:Add("DImage")
            imagePlyFriend:SetPos(framePly:GetWide()-72,10)
            if ply:GetFriendStatus() == "blocked" then imagePlyFriend:SetImage("icon16/exclamation.png") else imagePlyFriend:SetImage("icon16/user_add.png") end
            imagePlyFriend:SizeToContents()
        end



        if ply == LocalPlayer() then
            local imagePlyMe = framePly:Add("DImage")
            imagePlyMe:SetPos(framePly:GetWide()-72,10)
            imagePlyMe:SetImage("icon16/asterisk_orange.png")
            imagePlyMe:SizeToContents()
        end


        if ply:IsMuted() then
            local imagePlyMuted = framePly:Add("DImage")
            imagePlyMuted:SetPos(framePly:GetWide()-100,10)
            imagePlyMuted:SetImage("icon16/sound_mute.png")
            imagePlyMuted:SizeToContents()
        end


        --if LocalPlayer():Team() != TEAM_HIDE then
        if GAMEMODE.SeekerBlinded or LocalPlayer():Team() ~= TEAM_SEEK then
            local imagePlyTeam = framePly:Add("DImage")
            imagePlyTeam:SetPos(255,10)
            if ply:Team() == TEAM_HIDE then imagePlyTeam:SetImage("icon16/flag_blue.png") end
            if ply:Team() == TEAM_SEEK then imagePlyTeam:SetImage("icon16/flag_red.png") end


            -- For the "Caught" team which exists in the original hns
            --if v:Team() == 4 and LocalPlayer():Team() != 2 then ScoBPlyPT:SetImage("icon16/camera_delete.png") end
            imagePlyTeam:SizeToContents()
        end
    end


    if team.NumPlayers(TEAM_SPECTATOR) > 0 then
        local frameSpec = self:Add("DFrame")
        frameSpec:SetPos(ScrW()/2+187,122)
        frameSpec:SetSize(172,150)
        frameSpec:SetTitle("")
        frameSpec:ShowCloseButton(false)
        frameSpec:SetDraggable(false)
        frameSpec.Paint = function()
            draw.RoundedBox(4,0,0,frameSpec:GetWide(),frameSpec:GetTall(),Color(0,0,0,200))
        end


        local imageSpectators = frameSpec:Add("DImage")
        imageSpectators:SetPos(8,4)
        imageSpectators:SetImage("icon16/camera_go.png")
        imageSpectators:SizeToContents()


        local labelSpectators = frameSpec:Add("DLabel")
        labelSpectators:SetPos(30,4)
        labelSpectators:SetColor(Color(255,255,255,255))
        labelSpectators:SetFont("DermaDefaultBold")
        labelSpectators:SetText("Spectators:")
        labelSpectators:SizeToContents()


        for i, ply in ipairs(specs) do
            local y = 6+(i*16)
            local avatarSpecPly = frameSpec:Add("AvatarImage")
            avatarSpecPly:SetSize(14,14)
            avatarSpecPly:SetPos(8,y)
            avatarSpecPly:SetPlayer(ply,16)


            local buttonSpecPlyAv = frameSpec:Add("DButton")
            buttonSpecPlyAv:SetSize(14,14)
            buttonSpecPlyAv:SetPos(8,y)
            buttonSpecPlyAv:SetText("")
            buttonSpecPlyAv.Paint = function()
                draw.RoundedBox(0,0,0,buttonSpecPlyAv:GetWide(),buttonSpecPlyAv:GetTall(),Color(0,0,0,0))
            end


            buttonSpecPlyAv.DoClick = function(DermaButton)
                ply:ShowProfile()
                Hide()
            end


            buttonSpecPlyAv.DoRightClick = function(DermaButton)
                local menu = DermaMenu()
                hook.Run("HASScoreboardMenu", menu, ply)
                menu:Open()

                surface.PlaySound("garrysmod/ui_click.wav")
            end



            local labelSpecPlyName = frameSpec:Add("DLabel")
            labelSpecPlyName:SetPos(26,y)
            labelSpecPlyName:SetColor(Color(255,255,255,255))
            labelSpecPlyName:SetFont("DermaDefault")
            labelSpecPlyName:SetText(ply:Name())
            labelSpecPlyName:SizeToContents()
        end
    end
end


function PANEL:RefreshPlayers()
    -- This can probably be done in a better way

    local focused = vgui.CursorVisible()

    self:Remove()
    GAMEMODE.Scoreboard = vgui.Create("HNS.ScoreboardClassic")

    if focused then
        gui.EnableScreenClicker(true)
    end
end


function PANEL:HeadMenu(menu)


    menu:AddOption("Open Help", function()
        --RunConsoleCommand("has_help")
        vgui.Create("HNS.Help")
        Hide()
    end):SetImage("icon16/information.png")

    menu:AddOption("Open Options",function()
        --RunConsoleCommand("has_options")
        vgui.Create("HNS.Options")
        Hide()
    end):SetImage("icon16/cog_edit.png")

    menu:AddOption("Open Achievements",function()
        --RunConsoleCommand("has_achievements")

        vgui.Create("HNS.Achievements")
        Hide()
    end):SetImage("icon16/table.png")

    menu:AddSpacer()

    local sb, mb = menu:AddSubMenu("Sort")
    sb:AddOption("By EntityID",function()
        GAMEMODE.CVars.Sort:SetInt(1)
        GAMEMODE.Scoreboard:RefreshPlayers()

        surface.PlaySound("garrysmod/ui_return.wav")
    end):SetImage("icon16/brick.png")

    mb:SetImage("icon16/image_link.png")
    sb:AddOption("By Alphabetical",function()
        GAMEMODE.CVars.Sort:SetInt(3)
        GAMEMODE.Scoreboard:RefreshPlayers()

        surface.PlaySound("garrysmod/ui_return.wav")
    end):SetImage("icon16/font.png")

    sb:AddOption("By Score",function()
        GAMEMODE.CVars.Sort:SetInt(2)
        GAMEMODE.Scoreboard:RefreshPlayers()

        surface.PlaySound("garrysmod/ui_return.wav")
    end):SetImage("icon16/medal_gold_1.png")


end


vgui.Register("HNS.ScoreboardClassic", PANEL, "DFrame")


