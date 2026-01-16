include("sh_init.lua")

function GM:PlayerStartVoice(ply)
    if not IsValid(ply) then return end

    local panel = self.VoiceContainer.Players[ply:SteamID64()]
    if IsValid(panel) then
        panel.LastSpoke = nil
        return
    end

    panel = self.VoiceContainer:Add("HNS.VoicePlayer")
    panel:SetPlayer(ply)

    self.VoiceContainer.Players[ply:SteamID64()] = panel
end

function GM:PlayerEndVoice(ply)
    local panel = self.VoiceContainer.Players[ply:SteamID64()]
    if IsValid(panel) then
        panel.LastSpoke = CurTime()
    end
end

-- Clean avatar frame cache
function GM:ShutDown()
    if not file.Exists("hns_avatarframes_cache", "DATA") then return end

    for _, filename in ipairs(file.Find("hns_avatarframes_cache/*", "DATA")) do
        file.Delete("hns_avatarframes_cache/" .. filename)
    end
end

GM.AvatarFrames = GM.AvatarFrames or {}

-- Receive a chat message from gamemode
net.Receive("HNS.Say", function()
    local say = util.JSONToTable(net.ReadString())
    if not say then return end

    for i, arg in ipairs(say) do
        -- Fix color
        if istable(arg) and arg.r and arg.g and arg.b then
            say[i] = Color(arg.r, arg.g, arg.b, arg.a)
        end
    end

    chat.AddText(unpack(say))
end)

-- Play sounds
net.Receive("HNS.PlaySound", function()
    local path = net.ReadString()
    surface.PlaySound(path)
end)

-- Events that involve players and their steam id
net.Receive("HNS.PlayerEvent", function()
    local event = net.ReadUInt(3)
    local ply = net.ReadEntity()
    -- Stop if ply wasn't send to the client yet
    if not IsValid(ply) or not ply.Name then return end

    if event == PLYEVENT_PLAY then
        if GAMEMODE.CVars.ShowID:GetBool() then
            chat.AddText(COLOR_WHITE, "[", Color(215, 215, 215), "HNS", COLOR_WHITE, "] ", ply:Name(), COLOR_WHITE, " (", Color(215, 215, 215), ply:SteamID(), COLOR_WHITE, ") is now playing!")
        else
            chat.AddText(COLOR_WHITE, "[", Color(215, 215, 215), "HNS", COLOR_WHITE, "] ", ply:Name(), COLOR_WHITE, " is now playing!")
        end
    elseif event == PLYEVENT_SPEC then
        if GAMEMODE.CVars.ShowID:GetBool() then
            chat.AddText(COLOR_WHITE, "[", Color(215, 215, 215), "HNS", COLOR_WHITE, "] ", ply:Name(), COLOR_WHITE, " (", Color(215, 215, 215), ply:SteamID(), COLOR_WHITE, ") is now spectating!")
        else
            chat.AddText(COLOR_WHITE, "[", Color(215, 215, 215), "HNS", COLOR_WHITE, "] ", ply:Name(), COLOR_WHITE, " is now spectating!")
        end
    end
end)

function GM:InitPostEntity()
    -- Notify the server that we are ready to receive net messages
    net.Start("HNS.PlayerNetReady")
    net.SendToServer()
    -- Create welcome screen
    vgui.Create("HNS.Help")
    LocalPlayer().Stamina = 100
    -- Voice derma
    self.VoiceContainer = vgui.Create("HNS.VoiceContainer")

    self.BlurMaterial = Material("pp/blurscreen")

    -- From TTT cl_init.lua
    timer.Create("tbutton_cache_ents", 1, 0, function() TBHUD:CacheEnts() end)
end

local specCams = {}
function GM:Tick()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply.KeyDown then return end



    local hider = ply:Team() == TEAM_HIDE

    -- Don't want it to stay on if they become a seeker or if it's suddenly disallowed
    if self.FlashlightIsOn and (hider and not self.CVars.HiderFlash:GetBool() or not hider) then
        ply:RemoveEffects(EF_DIMLIGHT)
        self.FlashlightIsOn = false
    end

    if not hider or not self.CVars.HiderNV:GetBool() then
        self.NightVisionIsOn = false
    end


    self:StaminaPrediction(ply, ply:KeyDown(IN_SPEED))


    -- Spectator camera models
    local show = self.CVars.SpecCams:GetBool()
    for i, cam in ipairs(specCams) do
        local shouldHave = show and IsValid(cam.player) and cam.player:Team() == TEAM_SPECTATOR

        if not shouldHave then
            cam:Remove()
            table.remove(specCams, i)
        end
    end

    if not show then return end

    for _, ply in ipairs(team.GetPlayers(TEAM_SPECTATOR)) do
        if ply == LocalPlayer() then continue end

        if not IsValid(ply.SpecCamera) then
            -- TODO: Let the player choose between these two models
            --ply.SpecCamera = ClientsideModel("models/dav0r/camera.mdl") -- Light HNS
            ply.SpecCamera = ClientsideModel("models/tools/camera/camera.mdl") -- Old HNS

            ply.SpecCamera:Spawn()

            ply.SpecCamera.player = ply
            table.insert(specCams, ply.SpecCamera)
        end

        ply.SpecCamera:SetPos(ply:EyePos())
        ply.SpecCamera:SetAngles(ply:EyeAngles())
    end
end

function GM:Think()
    if not self.NightVisionIsOn then return end

    local nvLight = DynamicLight( LocalPlayer():EntIndex() )

    if nvLight then
        nvLight.pos = LocalPlayer():GetPos() + Vector(0, 0, 30)
        nvLight.r = 120
        nvLight.g = 255
        nvLight.b = 120
        nvLight.brightness = 1
        nvLight.size = 750
        nvLight.decay = 750 * 5
        nvLight.dietime = CurTime() + 1
        nvLight.style = 0
    end
end

function GM:PostDrawOpaqueRenderables()
    -- Draw spectators' names
    ang = LocalPlayer():EyeAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)
    col = ColorAlpha(team.GetColor(TEAM_SPECTATOR), 75)

    for _, ply in ipairs(team.GetPlayers(TEAM_SPECTATOR)) do
        -- Don't draw ourselves
        if ply == LocalPlayer() then continue end
        -- Draw a text above head
        cam.Start3D2D(ply:EyePos() + Vector(0, 0, 18), Angle(0, ang.y, 90), 0.075)
        draw.SimpleTextOutlined(ply:Name(), "HNS.RobotoSpec", 0, 0, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 125))
        draw.SimpleTextOutlined(ply:SteamID(), "HNS.RobotoLarge", 0, 54, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 125))
        cam.End3D2D()
    end
end

function GM:PrePlayerDraw(ply)
    -- Don't draw spectators
    if ply:Team() == TEAM_SPECTATOR then return true end
end

function GM:PlayerBindPress(ply, bind, pressed)
    -- Safe check
    if ply ~= LocalPlayer() then return end

    -- From TTT cl_keys.lua
    if bind == "+use" and pressed and TBHUD:PlayerIsFocused() then
        return TBHUD:UseFocused()
    end

    -- Team selection menu
    if bind == "gm_showteam" then
        self:TeamSelect()
    elseif bind == "gm_showhelp" then
        vgui.Create("HNS.Help")
    elseif bind == "impulse 100" then


        local options = {"fl", "nv"}

        if not self.CVars.HiderFlash:GetBool() then
            table.RemoveByValue(options, "fl")
        end

        if not self.CVars.HiderNV:GetBool() then
            table.RemoveByValue(options, "nv")
        end


        local which

        -- Choose preference if the length is two, otherwise choose whatever value is in there
        if #options == 1 then
            which = options[1]
        elseif #options == 2 then
            which = options[self.CVars.PreferNV:GetBool() and 2 or 1]
        end



        -- If both are disallowed, then `#options` will be 0 and `which` will be nil
        -- and both of these checks will fail

        if ply:Team() == TEAM_HIDE and which == "fl" then
            -- So that we don't end up in a state where both are on simultaneously
            self.NightVisionIsOn = false

            self.FlashlightIsOn = not self.FlashlightIsOn

            if self.FlashlightIsOn then
                ply:AddEffects(EF_DIMLIGHT)
            else
                ply:RemoveEffects(EF_DIMLIGHT)
            end
        end

        if ply:Team() == TEAM_HIDE and which == "nv" then
            self.FlashlightIsOn = false

            self.NightVisionIsOn = not self.NightVisionIsOn

            LocalPlayer():EmitSound("buttons/blip1.wav")
        end


    end
end

function GM:OnPlayerChat(ply, text, teamChat, dead)
    -- CONSOLE: on invalid/unloaded
    if not IsValid(ply) then
        chat.AddText(Color(125, 125, 125), "CONSOLE: ", Color(255, 255, 255), text)
        return true
    end

    local line = {}

    if teamChat then
        table.insert(line, Color(30, 160, 40))
        table.insert(line, "(TEAM) ")
    end

    if ply:Team() ~= TEAM_SPECTATOR then
        table.insert(line, self:GetPlayerTeamColor(ply) or team.GetColor(ply:Team()))
        table.insert(line, ply:Name())
    else
        table.insert(line, ply)
    end

    table.insert(line, Color(255, 255, 255))
    table.insert(line, ": " .. text)
    chat.AddText(unpack(line))

    return true
end

-- Update playercolor
local function PlayerColorUpdate()
    net.Start("HNS.PlayerColorUpdate")
    net.SendToServer()
end

cvars.AddChangeCallback("has_hidercolor", PlayerColorUpdate)
cvars.AddChangeCallback("has_seekercolor", PlayerColorUpdate)

hook.Add("OnPlayerChat", "HNS.Commands", function(ply, text)
    -- Using hooks instead of a function in case there's an addon overriting the gamemode function
    text = string.lower(text)

    -- HUD - Interface section
    if text == "!hnshud" or text == "!hnsmenu" then
        if ply == LocalPlayer() then
            vgui.Create("HNS.Preferences")
        end

        return true
    end

    -- Playercolors
    if text == "!hnscolors" or text == "!hnscolours" then
        if ply == LocalPlayer() then
            local panel = vgui.Create("HNS.Preferences")
            panel.TabsP:GetChildren()[2]:DoClick()
        end

        return true
    end

    if text == "!3p" or text == "!3pv" then
        GAMEMODE:ToggleThirdperson()
        return true
    end
end)

