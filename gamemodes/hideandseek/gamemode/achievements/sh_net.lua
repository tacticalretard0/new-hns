if CLIENT then

    -- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/net.lua#L77
    -- The number of bits that's used to transmit a player's ent index
    local maxplayers_bits = math.ceil( math.log(1 + game.MaxPlayers()) / math.log(2) )

    net.Receive("HNS.PlayerAchData", function(len)
        local dataLenBits = len - maxplayers_bits
        local dataLenBytes = dataLenBits / 8

        local ply = net.ReadPlayer()
        local data = net.ReadData(dataLenBytes)

        if not IsValid(ply) then return end                


        local tab = util.JSONToTable(util.Decompress(data))


        ply.achMaster = tab["AM"] or ply.achMaster
        ply.achsCompleted = table.Merge(ply.achsCompleted or {}, tab["AC"] or {})
        ply.achProgress   = table.Merge(ply.achProgress   or {}, tab["AP"] or {})
        ply.achReqs       = table.Merge(ply.achReqs       or {}, tab["AR"] or {})


        if tab["INIT"] then return end


        if tab["AC"] and not table.IsEmpty(tab["AC"]) then
            GAMEMODE:AchCongrats(ply, achID)

            for achID, _ in pairs(tab["AC"]) do GAMEMODE:AchMessage(ply, achID) end
        end


        if tab["AM"] then
            GAMEMODE:AchMasterMessage(ply)

            -- Everybody has a party
            RunConsoleCommand("act", "dance")
        end


    end)



    -- NOTE: should this message be sent from the server with GM:BroadcastChatWithTag?
    function GM:AchMessage(ply, achID)
        chat.AddText(COLOR_WHITE, "[", COLOR_HNS_TAG_ACH, "HNS", COLOR_WHITE, "] ", ply, COLOR_WHITE, " has earned ", COLOR_HNS_TAG_ACH, GAMEMODE.Achievements[achID].Name, COLOR_WHITE, ".")
    end

    function GM:AchMasterMessage(ply)
        chat.AddText(COLOR_WHITE, "[", COLOR_HNS_TAG_ACH, "HNS", COLOR_WHITE, "] ", ply, COLOR_WHITE, " has earned ", COLOR_HNS_TAG_ACH, "all", COLOR_WHITE, " of the achievements!")
    end


    function GM:AchCongrats(ply)
        ply:EmitSound("misc/achievement_earned.wav")



        ParticleEffectAttach("bday_confetti", PATTACH_ABSORIGIN_FOLLOW, ply, 0)
        local data = EffectData()
        data:SetOrigin(ply:GetPos())
        util.Effect("PhyscannonImpact", data)



        timer.Create("HNS.AchParticles1." .. ply:EntIndex(), 0.3, 10, function()
            if not IsValid(ply) then return end

            ParticleEffectAttach("bday_confetti", PATTACH_ABSORIGIN_FOLLOW, ply, 0)

            local data2 = EffectData()
            data2:SetOrigin(ply:GetPos())
            util.Effect("PhyscannonImpact", data2)
        end)


        timer.Create("HNS.AchParticles2." .. ply:EntIndex(), 0.1, 50, function()
            if not IsValid(ply) then return end

            ParticleEffectAttach("bday_confetti_colors", PATTACH_ABSORIGIN_FOLLOW, ply, 0)

            local data2 = EffectData()
            data2:SetOrigin(ply:GetPos())
            util.Effect("PhyscannonImpact", data2)
        end)
    end



end

if CLIENT then return end



local PLAYER = FindMetaTable("Player")

-- The user of these functions must call net.Send or net.Broadcast afterwards
function PLAYER:NetworkAchData(tab, init)
    -- INIT will be true if we're initializing a player's achievement data for the first time.
    -- If it's nil, then the player made new progress and their client should play a sound effect, chat message, etc.
    tab["INIT"] = init

    local data = util.Compress(util.TableToJSON(tab))

    net.Start("HNS.PlayerAchData")
        net.WritePlayer(self)
        net.WriteData(data)
end



function PLAYER:NetworkAchCompletion(achID)
    local netTab = {
        ["AM"] = self.newAchMaster,
        ["AC"] = { [achID] = self.achsCompleted[achID] }
    }
    self:NetworkAchData(netTab)
end



function PLAYER:NetworkAchProgress(achID)
    local netTab = { ["AP"] = { [achID] = self.achProgress[achID] } }
    self:NetworkAchData(netTab)
end



function PLAYER:NetworkAchReq(achID, req)
    local netTab = { ["AR"] = { [achID] = { [req] = {
        ply.achReqs[achID][req]
    }}}}

    self:NetworkAchData(netTab)
end



GM:AddHook(function(gm, data, ply, achID)
    ply:NetworkAchCompletion(achID)
    net.Broadcast()
end, "HASAchievementEarned", {"HNS", "NetworkAchUpdate"})


GM:AddHook(function(gm, data, ply, achID)
    ply:NetworkAchProgress(achID)
    net.Broadcast()
end, "HASAchProgressUpdate", {"HNS", "NetworkAchUpdate"})



GM:AddHook(function(gm, data, ply, achID, req)
    ply:NetworkAchReq(achID, req)
    net.Broadcast()
end, "HASAchFulfilled", {"HNS", "NetworkAchUpdate"})







-- A player just joined
GM:AddHook(function(gm, data, ply)

    -- Send everyone else's achievement data to the new player
    for _, ply2 in ipairs(player.GetAll()) do
        local tab = {
            ["AM"] = ply2.achMaster,
            ["AC"] = ply2.achsCompleted,
            ["AP"] = ply2.achProgress,
            ["AR"] = ply2.achReqs
        }

        ply2:NetworkAchData(tab, true)

        -- Send the new player's achievement data to everyone else
        if ply == ply2 then net.Broadcast() return end

        net.Send(ply)
    end



end, "HASPlayerNetReady", {"HNS", "NetworkAchievements"})



