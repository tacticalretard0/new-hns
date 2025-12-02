
ENT.Type = "point"
ENT.Base = "base_point"

function ENT:AcceptInput(name, activator, caller)
   if name == "TraitorWin" then
      GAMEMODE:RoundEnd(ROUND_ENDMAP, WIN_TRAITOR)
      return true
   elseif name == "InnocentWin" then
      GAMEMODE:RoundEnd(ROUND_ENDMAP, WIN_INNOCENT)
      return true
   end
end

