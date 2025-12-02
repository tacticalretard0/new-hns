local PLAYER = FindMetaTable("Player")

if SERVER then
    -- From TTT entity.lua
    local ENTITY = FindMetaTable("Entity")

    function ENTITY:SetDamageOwner(ply)
        self.dmg_owner = {ply = ply, t = CurTime()}
    end
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

function PLAYER:GetRole(asking_ent)
    --local config_default = HNSTTTMapConfig["DEFAULT_ENT_CONFIG"]

    --local config_classname = HNSTTTMapConfig["classnames"][asking_ent:GetClass()]
    --local config_targetname = HNSTTTMapConfig["targetnames"][asking_ent:GetNWString("targetname")]
    --local config_mapid = HNSTTTMapConfig["mapids"][asking_ent:MapCreationID()]


    --local config = config_default

    --if config_classname ~= nil then config = config_classname end
    --if config_targetname ~= nil then config = config_targetname end
    --if config_mapid ~= nil then config = config_mapid end


    --return config[self:Team()]

    if self:Team() == TEAM_SEEK then
        return ROLE_TRAITOR
    elseif self:Team() == TEAM_HIDE then
        return ROLE_INNOCENT
    else
        return ROLE_NONE
    end
end

function PLAYER:GetTraitor(asking_ent) return self:GetRole(asking_ent) == ROLE_TRAITOR end
function PLAYER:GetDetective(asking_ent) return self:GetRole(asking_ent) == ROLE_DETECTIVE end

PLAYER.IsTraitor = PLAYER.GetTraitor
PLAYER.IsDetective = PLAYER.GetDetective

function PLAYER:IsSpecial(asking_ent) return self:GetRole(asking_ent) != ROLE_INNOCENT end

-- Player is alive and in an active round
function PLAYER:IsActive()
    return self:IsTerror() and GAMEMODE.RoundState == ROUND_ACTIVE
end

-- convenience functions for common patterns
function PLAYER:IsRole(asking_ent, role) return self:GetRole(asking_ent) == role end
function PLAYER:IsActiveRole(asking_ent, role) return self:IsRole(asking_ent, role) and self:IsActive() end
function PLAYER:IsActiveTraitor(asking_ent) return self:IsActiveRole(asking_ent, ROLE_TRAITOR) end
function PLAYER:IsActiveDetective(asking_ent) return self:IsActiveRole(asking_ent, ROLE_DETECTIVE) end
function PLAYER:IsActiveSpecial(asking_ent) return self:IsSpecial(asking_ent) and self:IsActive() end

