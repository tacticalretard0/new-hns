local ENTITY = FindMetaTable("Entity")
local PLAYER = FindMetaTable("Player")

if SERVER then
    -- From TTT entity.lua
    function ENTITY:SetDamageOwner(ply)
        self.dmg_owner = {ply = ply, t = CurTime()}
    end
end


function ENTITY:GetTTTConfig()
    local config_default = GAMEMODE.CurrentTTTConfig["DEFAULT_ENT_CONFIG"]

    local config_classname = GAMEMODE.CurrentTTTConfig["classnames"][self:GetClass()]
    local config_targetname = GAMEMODE.CurrentTTTConfig["targetnames"][self:GetNWString("targetname")]
    local config_mapid = GAMEMODE.CurrentTTTConfig["mapids"][self:MapCreationID()]

    return config_mapid or config_targetname or config_classname or config_default
end




-- From TTT shared.lua
ROLE_INNOCENT = 0
ROLE_TRAITOR = 1
ROLE_DETECTIVE = 2
ROLE_NONE = ROLE_INNOCENT


-- From TTT player_ext_shd.lua

function PLAYER:IsPlaying()
    return self:IsValid() and (self:Team() == TEAM_HIDE or self:Team() == TEAM_SEEK)
end
PLAYER.IsTerror = PLAYER.IsPlaying

function PLAYER:IsSpec() return self:Team() == TEAM_SPECTATOR end

function PLAYER:GetRole(askingEnt)
    return askingEnt:GetTTTConfig()[self:Team()]
end

function PLAYER:GetTraitor(askingEnt) return self:GetRole(askingEnt) == ROLE_TRAITOR end
function PLAYER:GetDetective(askingEnt) return self:GetRole(askingEnt) == ROLE_DETECTIVE end

PLAYER.IsTraitor = PLAYER.GetTraitor
PLAYER.IsDetective = PLAYER.GetDetective

function PLAYER:IsSpecial(askingEnt) return self:GetRole(askingEnt) != ROLE_INNOCENT end

-- Player is alive and in an active round
function PLAYER:IsActive()
    return self:IsTerror() and GAMEMODE.RoundState == ROUND_ACTIVE
end

-- convenience functions for common patterns
function PLAYER:IsRole(askingEnt, role) return self:GetRole(askingEnt) == role end
function PLAYER:IsActiveRole(askingEnt, role) return self:IsRole(askingEnt, role) and self:IsActive() end
function PLAYER:IsActiveTraitor(askingEnt) return self:IsActiveRole(askingEnt, ROLE_TRAITOR) end
function PLAYER:IsActiveDetective(askingEnt) return self:IsActiveRole(askingEnt, ROLE_DETECTIVE) end
function PLAYER:IsActiveSpecial(askingEnt) return self:IsSpecial(askingEnt) and self:IsActive() end

