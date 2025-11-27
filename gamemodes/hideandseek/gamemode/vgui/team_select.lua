function GM:TeamSelect()
	Derma_Query("What would you like to be doing?", "Team Selection",
	"Hiding", function()
		net.Start("HNS.JoinPlaying")
		net.SendToServer()
		--if LocalPlayer():Team() == 3 then sprintpower = 100 end
		surface.PlaySound("garrysmod/save_load4.wav")
	end, "Spectating", function()
		net.Start("HNS.JoinSpectating")
		net.SendToServer()
		surface.PlaySound("garrysmod/save_load2.wav")
	end)
end

