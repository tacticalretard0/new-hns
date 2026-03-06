if CLIENT then
    net.Receive("HNS.Winner", function()
        surface.PlaySound("music/class_menu_09.wav")

        local winner = net.ReadPlayer()
        GAMEMODE.winner = {
            frags = net.ReadInt(32),
            name = net.ReadString()
        }

        if winner == LocalPlayer() then
            GAMEMODE.winner.name = GAMEMODE.winner.name .. " (You!)"
        end

    end)
end

if CLIENT then return end



function GM:HASVotemapStart()
    local winner
    --for _, ply in player.Iterator() do
    for _, ply in ipairs(player.GetAll()) do
        if winner == nil or ply:Frags() > winner:Frags() then
            winner = ply
        end
    end
    winner.winner = true

    winner:SetPlayerColor( Vector(1, 1, 0) )
    winner:SetColor( Color(255, 200, 0) )
    winner:SetMaterial("models/shiny")

    -- These are also set in GM:PlayerSpawn in sv_player.lua
    winner:SetJumpPower(630)
    winner:SetWalkSpeed(350)
    winner:SetRunSpeed(550)

    winner:EmitSound("misc/tf_crowd_walla_intro.wav", 80, 100)

    -- TODO: Winner gets infinite stamina

    net.Start("HNS.Winner")
        net.WritePlayer(winner)
        net.WriteInt(winner:Frags(), 32)
        net.WriteString(winner:Nick()) -- send the name in case the winner disconnects
    net.Broadcast()


    hook.Run("HASPlayerWon", winner)
end


GM:AddHook(function(_, _, ply)
    if not ply.winner then return end

    ply:SetJumpPower(630)
    ply:SetWalkSpeed(350)
    ply:SetRunSpeed(550)
end, "PlayerSpawn", {"HNS", "WinnerSpawn"}, {
    runMeAfter = "HNS PlayerSpawn &"
})


