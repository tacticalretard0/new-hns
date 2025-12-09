DeriveGamemode("base")

GM.Name = "New Hide and Seek"
GM.Author = "Fafy"
GM.Email = ""

AddCSLuaFile()
AddCSLuaFile("sh_init.lua")

-- Client
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_derma.lua")
AddCSLuaFile("cl_thirdperson.lua")
AddCSLuaFile("vgui/scoreboard.lua")
AddCSLuaFile("vgui/help.lua")
AddCSLuaFile("vgui/help_welcome.lua")
AddCSLuaFile("vgui/help_achievements.lua")
AddCSLuaFile("vgui/achievements.lua")
AddCSLuaFile("vgui/help_hiding.lua")
AddCSLuaFile("vgui/help_seeking.lua")
AddCSLuaFile("vgui/help_spectating.lua")
AddCSLuaFile("vgui/team_select.lua")
AddCSLuaFile("vgui/options.lua")
AddCSLuaFile("vgui/options_interface.lua")
AddCSLuaFile("vgui/options_player.lua")
AddCSLuaFile("vgui/options_world.lua")
AddCSLuaFile("vgui/voice.lua")
AddCSLuaFile("vgui/avatar.lua")
AddCSLuaFile("vgui/avatar_frame.lua")
AddCSLuaFile("ttt/cl_tbuttons.lua")


-- Shared
AddCSLuaFile("sh_cvars.lua")
AddCSLuaFile("sh_colors.lua")
AddCSLuaFile("sh_roundmanager.lua")
AddCSLuaFile("sh_winner.lua")
AddCSLuaFile("ttt/sh_util.lua")
AddCSLuaFile("ttt/sh_extensions.lua")
AddCSLuaFile("_config.lua")
AddCSLuaFile("ttt/sh_config.lua")


-- Shared
include("sh_cvars.lua")
include("sh_colors.lua")
include("sh_roundmanager.lua")
include("sh_winner.lua")
include("ttt/sh_util.lua")
include("ttt/sh_extensions.lua")

if SERVER then
    include("sv_player.lua")
else
    -- Client
    include("cl_fonts.lua")
    include("cl_hud.lua")
    include("cl_derma.lua")
    include("cl_thirdperson.lua")
    include("vgui/scoreboard.lua")
    include("vgui/help.lua")
    include("vgui/help_welcome.lua")
    include("vgui/help_achievements.lua")
    include("vgui/achievements.lua")
    include("vgui/help_hiding.lua")
    include("vgui/help_seeking.lua")
    include("vgui/help_spectating.lua")
    include("vgui/team_select.lua")
    include("vgui/options.lua")
    include("vgui/options_interface.lua")
    include("vgui/options_player.lua")
    include("vgui/options_world.lua")
    include("vgui/voice.lua")
    include("vgui/avatar_frame.lua")
    include("vgui/avatar.lua")
    include("ttt/cl_tbuttons.lua")
end


-- Player events
PLYEVENT_PLAY, PLYEVENT_SPEC, PLYEVENT_AVOID = 1, 2, 3

TEAM_HIDE, TEAM_SEEK = 1, 2

-- Shared, these need to be included after the team enums are defined
-- so that the enums can be used in the configuration file for convenience
include("_config.lua")
include("ttt/sh_config.lua")

function GM:CreateTeams()
    team.SetUp(TEAM_HIDE, "Hiding", Color(75, 150, 225))
    team.SetUp(TEAM_SEEK, "Seeking", Color(215, 75, 50))
    -- Just changing spectators colors
    team.SetUp(TEAM_SPECTATOR, "Spectating", Color(0, 175, 100))
end

-- Sound when seekers are unblinded
GM.PlayedStartSound = true

hook.Add("Tick", "HNS.SeekerBlinded", function()
    -- Store time left
    if GAMEMODE.RoundState == ROUND_WAIT then
        GAMEMODE.TimeLeft = GAMEMODE.CVars.TimeLimit:GetInt() + GAMEMODE.CVars.BlindTime:GetInt()
    else
        GAMEMODE.TimeLeft = timer.TimeLeft("HNS.RoundTimer") or 0
        GAMEMODE.TimeLeft = math.abs(math.ceil(GAMEMODE.TimeLeft))
    end

    -- See if seeker is blinded
    if GAMEMODE.RoundState == ROUND_ACTIVE and GAMEMODE.RoundLength < GAMEMODE.TimeLeft then
        GAMEMODE.SeekerBlinded = true
    else
        GAMEMODE.SeekerBlinded = false
    end

    if GAMEMODE.RoundState == ROUND_ACTIVE then
        if not GAMEMODE.PlayedStartSound and not GAMEMODE.SeekerBlinded then
            GAMEMODE.PlayedStartSound = true

            -- Sound
            if SERVER then
                for _, ply in pairs(team.GetPlayers(TEAM_SEEK)) do
                    ply:EmitSound("coach/coach_attack_here.wav")
                end
            elseif CLIENT then
                LocalPlayer():EmitSound("coach/coach_attack_here.wav", 90, 100)
            end
        end
    else
        GAMEMODE.PlayedStartSound = false
    end
end)

function GM:StaminaLinearFunction(x)
    --return x * 20 / 3
    return x * self.CVars.StaminaRefill:GetFloat()
end

function GM:StaminaLinearDeplete(x)
    --return x * 40 / 3
    return x * self.CVars.StaminaDeplete:GetFloat()
end

function GM:StaminaPrediction(ply, sprinting)
    if ply:Team() == TEAM_SPECTATOR then return end
    local max = self.CVars.MaxStamina:GetInt()
    ply.Stamina = ply.Stamina or max
    -- Make sure values exist
    local lastSprint = ply:GetNWFloat("has_staminalastsprinted", -1)

    if lastSprint < 0 then
        lastSprint = nil
    end

    local lastAmmount = ply:GetNWFloat("has_staminalastammount", max)
    local lastTime = ply:GetNWFloat("has_staminalasttime", CurTime())

    if sprinting and not lastSprint then
        lastSprint = CurTime()
        ply:SetNWFloat("has_staminalastsprinted", lastSprint)
    end

    -- If player sprinted at some point (defined on KeyPress)
    if lastSprint then
        -- And we're still sprinting
        if sprinting and ply:GetVelocity():Length2DSqr() >= 4225 then
            ply.Stamina = lastAmmount - self:StaminaLinearDeplete(CurTime() - lastSprint)
            ply:SetNWFloat("has_staminalasttime", CurTime())
        else
            -- If we aren't sprinting, we delete StaminaLastSprinted and define last stamina aquired
            ply:SetNWFloat("has_staminalastammount", ply.Stamina or max)
            ply:SetNWFloat("has_staminalasttime", CurTime())
            ply:SetNWFloat("has_staminalastsprinted", -1)
        end

        ply.Stamina = math.Clamp(ply.Stamina, 0, max)

        return
    end

    -- Last time since stamina was changed
    local since = CurTime() - lastTime

    -- We wait to refill stamina
    if since <= self.CVars.StaminaWait:GetFloat() then
        ply.Stamina = lastAmmount
    else
        ply.Stamina = lastAmmount + self:StaminaLinearFunction(since - self.CVars.StaminaWait:GetFloat())
    end

    ply.Stamina = math.Clamp(ply.Stamina, 0, max)
end

hook.Add("KeyPress", "HNS.StaminaStart", function(ply, key)
    if IsFirstTimePredicted() and key == IN_SPEED then
        ply:SetNWFloat("has_staminalastsprinted", CurTime())
        ply:SetNWFloat("has_staminalastammount", ply.Stamina)
    end
end)

local AllowCMD = {
    IN_RELOAD, IN_ATTACK, IN_ATTACK2, IN_SCORE
}

function GM:StartCommand(ply, cmd)
    if ply:Team() == TEAM_SPECTATOR then return end

    -- Prevent movement while blind
    if self.SeekerBlinded and ply:Team() == TEAM_SEEK then
        local buttons = cmd:GetButtons()
        local new = 0

        cmd:ClearMovement()
        cmd:ClearButtons()

        -- Allow certain actions
        for _, button in ipairs(AllowCMD) do
            if bit.band(buttons, button) ~= 0 then
                new = bit.bxor(new, button)
            end
        end

        cmd:SetButtons(new)
    end

    -- Prevent running
    if cmd:KeyDown(IN_SPEED) then
        if ply:GetStamina() <= 0 then
            cmd:SetButtons(cmd:GetButtons() - IN_SPEED)
            ply:SetNWBool("has_sprinting", false)
        else
            ply:SetNWBool("has_sprinting", true)
        end
    else
        ply:SetNWBool("has_sprinting", false)
    end
end

hook.Add("Move", "HNS.SeekerMove", function(ply, data)
    if GAMEMODE.SeekerBlinded and ply:Team() == TEAM_SEEK then
        data:SetVelocity(Vector(0, 0, 0))
    end
end)

local PLAYER = FindMetaTable("Player")

-- This function will always be unpredicted
if SERVER then
    function PLAYER:SetStamina(sta)
        sta = math.Clamp(sta, 0, GAMEMODE.CVars.MaxStamina:GetInt())
        self:SetNWFloat("has_staminalastammount", sta)
        self:SetNWFloat("has_staminalasttime", CurTime())
        local lastSprint = self:GetNWFloat("has_staminalastsprinted", -1)

        if lastSprint >= 0 then
            self:SetNWFloat("has_staminalastsprinted", CurTime())
        end
    end
end

function PLAYER:GetStamina()
    if GAMEMODE.CVars.InfiniteStamina:GetBool() then return GAMEMODE.CVars.MaxStamina:GetInt() end

    -- We want to get the stamina of another player
    if CLIENT and self ~= LocalPlayer() then
        GAMEMODE:StaminaPrediction(self, self:GetNWBool("has_sprinting", false))
    end

    return self.Stamina
end

