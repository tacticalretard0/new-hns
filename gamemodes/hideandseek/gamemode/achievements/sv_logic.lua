
timer.Create("HNS.Tranquility", 5, 0, function()
    if GAMEMODE.RoundState ~= ROUND_ACTIVE then return end

    for _, ply in ipairs(team.GetPlayers(TEAM_HIDE)) do
        ply:AchAddProgress("tranquility", 5)
    end
end)


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


GM:AddHook(function(gm, data, ply)
    -- Setup
    ply.TauntsSingle = 0
end, "PlayerSpawn", {"HNS", "Achievements"})

GM:AddHook(function(gm, data, ply)
    if gm.RoundState ~= ROUND_ACTIVE or ply:Team() ~= TEAM_HIDE then return end
    -- Conversationalist
    ply.TauntsSingle = ply.TauntsSingle + 1

    if ply.TauntsSingle >= 30 then
        ply:AchComplete("conversationalist")
    end
end, "HASPlayerTaunted", {"HNS", "Achievements"})


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
end, "PlayerSay", {"HNS", "Achievements"})


GM:AddHook(function(gm, data, ply, ent)
    if not string.match(ent:GetClass(), "^prop_physics") then return end

    ply.PickupTime = CurTime() + 1
    if CurTime() >= ply.PickupTime and ent:GetModel() == "models/props_junk/bicycle01a.mdl" then
        ply:AchComplete("bike")
    end
end, "PlayerUse", {"HNS", "Achievements"})

