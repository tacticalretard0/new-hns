local PLAYER = FindMetaTable("Player")

function PLAYER:AchRoundInit()
    -- Round-specific achievement data
    self.tranquility = 0
    self.conversationalist = 0

    self.bike = 0
    self.healthy = {
        melon = false,
        orange = false,
        banana = false
    }
end

GM:AddHook(function(gm, data)
    for _, ply in ipairs(player.GetAll()) do
        ply:AchRoundInit()
    end
end, "HASRoundStarted", {"HNS", "Achievements"})


GM:AddHook(function(gm, data, ply)
    ply:AchRoundInit()
end, "PlayerInitialSpawn", {"HNS", "Achievements"})


timer.Create("HNS.Tranquility", 1, 0, function()
    if GAMEMODE.RoundState ~= ROUND_ACTIVE then return end

    for _, ply in ipairs(team.GetPlayers(TEAM_HIDE)) do
        ply.tranquility = ply.tranquility + 1
    end
end)


GM:AddHook(function(gm, data, ply)
    if gm.RoundState ~= ROUND_ACTIVE or ply:Team() ~= TEAM_HIDE then return end

    ply.conversationalist = ply.conversationalist + 1

    if ply.conversationalist >= 30 then
        ply:AchComplete("conversationalist")
    end
end, "HASPlayerTaunted", {"HNS", "Achievements"})


GM:AddHook(function(gm, data)
    for _, ply in ipairs(player.GetAll()) do
        if ply.tranquility == nil then continue end
        if ply.tranquility == 0 then continue end

        ply:AchAddProgress("tranquility", ply.tranquility)
    end
end, "HASRoundEnded", {"HNS", "Achievements"})


GM:AddHook(function(gm, data, ply, ent)
    if ply:Team() ~= TEAM_SEEK then return end

    -- Another way through
    timer.Simple(0.2, function()
        -- If we broke something
        if not IsValid(ent) or ent:Health() <= 0 then
            -- Flag
            ply.BrokeStuff = true

            -- Unflag after some time
            timer.Create("HNS.BrokeStuff_" .. ply:EntIndex(), 8, 1, function()
                if not IsValid(ply) then return end
                ply.BrokeStuff = false
            end)
        end
    end)
end, "HASHitBreakable", {"HNS", "Achievements"})


GM:AddHook(function(gm, data, ply, water, _, speed)
    -- Mario
    local ent = ply:GetGroundEntity()
    if ply:Team() ~= TEAM_SEEK or not IsValid(ent) or not ent:IsPlayer() or water or speed < 100 then return end
    ply.LandedOnPlayer = ent

    timer.Simple(1, function()
        ply.LandedOnPlayer = nil
    end)
end, "OnPlayerHitGround", {"HNS", "Achievements"})


GM:AddHook(function(gm, data, ply)
    -- Rubber legs
    ply:AchAddProgress("rubberlegs", 1)
end, "HASPlayerFallDamage", {"HNS", "Achievements"})


GM:AddHook(function(gm, data, ply, victim)
    -- Seeking champ
    ply:AchAddProgress("1kchampion", 1)

    -- Close call
    if team.NumPlayers(TEAM_HIDE) == 0 and math.abs(timer.TimeLeft("HNS.RoundTimer") or 0) <= 10 then
        ply:AchComplete("closecall")
    end

    -- Another way
    if ply.BrokeStuff then
        ply:AchComplete("anotherway")
    end
end, "HASPlayerCaught", {"HNS", "Achievements"})


GM:AddHook(function(gm, data, ply, victim)
    -- Submission
    victim.PreventSubmission = true

    timer.Simple(1, function()
        if IsValid(victim) then
            victim.PreventSubmission = false
        end
    end)

    if not ply.PreventSubmission and ply:GetVelocity():Length() <= 16 and ply:GetGroundEntity() ~= nil then
        ply:AchComplete("submission")
    end

    -- Mario
    if ply.LandedOnPlayer == victim then
        ply:AchComplete("mario")
    end
end, "HASPlayerCaughtArea", {"HNS", "Achievements"})


GM:AddHook(function(gm, data)
    -- Crowd
    for _, ply in pairs(team.GetPlayers(TEAM_HIDE)) do
        local ccc = 0

        for _, other in pairs(team.GetPlayers(TEAM_HIDE)) do
            if ply == other then continue end
            if ply:GetPos():DistToSqr(other:GetPos()) > 57600 then continue end

            ccc = ccc + 1
        end

        if ccc >= 2 then
            ply:AchComplete("crowd")
        end
    end

    -- Last standing
    if team.NumPlayers(TEAM_HIDE) == 1 and player.GetCount() >= 4 then
        team.GetPlayers(TEAM_HIDE)[1]:AchComplete("lasthiding")
    end
end, "HASRoundEndedTime", {"HNS", "Achievements"})


GM:AddHook(function(gm, data, ply, text)
    local txt = text:lower()
    -- Magic words
    if txt == "tickle fight" or txt == "ticklefight" then
        ply:AchComplete("ticklefight")
    end

    data.ret = text
end, "PlayerSay", {"HNS", "Achievements"})


GM:AddHook(function(gm, data, ply, ent)
    -- NOTE: maybe only make these achievements possible during ROUND_ACTIVE?

    if not string.match(ent:GetClass(), "^prop_physics") then return end
    local model = ent:GetModel()


    -- Bike
    if model == "models/props_junk/bicycle01a.mdl" then
        -- This increases while the user is holding e
        ply.bike = ply.bike + 1
    end

    if ply.bike >= 100 then
        ply:AchComplete("bike")
    end


    -- Healthy
    if model == "models/props_junk/watermelon01.mdl" then
        ply.healthy.melon = true
    end
    if model == "models/props/cs_italy/orange.mdl" then
        ply.healthy.orange = true
    end
    if model == "models/props/cs_italy/bananna_bunch.mdl" then
        ply.healthy.banana = true
    end

    if ply.healthy.melon and ply.healthy.orange and ply.healthy.banana then
        ply:AchComplete("healthy")
    end

end, "PlayerUse", {"HNS", "Achievements"})

