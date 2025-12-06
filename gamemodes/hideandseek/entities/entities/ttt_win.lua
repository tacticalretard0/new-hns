
ENT.Type = "point"
ENT.Base = "base_point"

function ENT:AcceptInput(name, activator, caller)
   if name == "TraitorWin" then
      GAMEMODE:RoundEnd(ROUND_ENDMAP, self:GetWinningTeam(ROLE_TRAITOR))
      return true
   elseif name == "InnocentWin" then
      GAMEMODE:RoundEnd(ROUND_ENDMAP, self:GetWinningTeam(ROLE_INNOCENT))
      return true
   end
end


function ENT:GetWinningTeam(winningRole)
   local config = self:GetTTTConfig()

   local hidersWin = config[TEAM_HIDE] == winningRole
   local seekersWin = config[TEAM_SEEK] == winningRole


   -- Bruh
   if hidersWin and seekersWin then
      return ({TEAM_HIDE, TEAM_SEEK})[math.random(2)]
   end


   if hidersWin then return TEAM_HIDE end
   if seekersWin then return TEAM_SEEK end

end

