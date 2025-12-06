
GM.CurrentTTTConfig = {
    ["classnames"] = {},
    ["targetnames"] = {},
    ["mapids"] = {}
}

local function StoreMapConfig(config)
    if not config then return end

    for k, v in pairs(config) do
        if k == "DEFAULT_ENT_CONFIG" then
            GM.CurrentTTTConfig[k] = v
            continue
        end

        if isnumber(k) then
            GM.CurrentTTTConfig["mapids"][k] = v
            continue
        end

        local dot = k:find("%.")
        local type = k:Left(dot - 1)
        local name = k:Right(#k - dot)

        -- TODO: error here if there's no dot


        if type == "classname" then
            GM.CurrentTTTConfig["classnames"][name] = v
            continue
        end

        if type == "targetname" then
            GM.CurrentTTTConfig["targetnames"][name] = v
            continue
        end


        -- TODO: error here
        -- If this code is reached then type isn't "classname" or "targetname"

    end

end

StoreMapConfig( GM.TTTConfig["DEFAULT_MAP_CONFIG"] )
StoreMapConfig( GM.TTTConfig[game.GetMap()] )




if CLIENT then return end

local lookup = {
    ["ttt_traitor_button"] = true,
    ["ttt_logic_role"] = true,
    ["ttt_traitor_check"] = true,
    ["ttt_win"] = true,
    ["ttt_damageowner"] = true,
}

-- Targetnames are needed to figure out an entity's config
--
-- They're not available on the client, so we transmit them
function GM:OnEntityCreated(ent)
    -- Need to use a timer because the entity isn't fully initialized yet,
    -- and we won't get anything from ent:GetName()
    timer.Simple(0, function()
        -- IIRC GMod creates a lot of entities on map load that immediately get removed,
        -- so ent could be invalid by now
        --
        -- So check for validity
        if not IsValid(ent) then return end
        if not lookup[ent:GetClass()] then return end

        ent:SetNWString("targetname", ent:GetName())
    end)

end




-- Handle KeyValue overrides in the config
function GM:HASTTTKeyValue(ent, key, value)
    return ent:GetTTTConfig()[key]
end

