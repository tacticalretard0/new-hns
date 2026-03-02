GM.Thirdperson = false
function GM:ToggleThirdperson()
    if not self.CVars.ThirdpersonAllowed:GetBool() then return end

    self.Thirdperson = not self.Thirdperson

    if self.Thirdperson then
        chat.AddText("Third person enabled. Disable typing !3p")
    else
        chat.AddText("Third person disabled. Enable typing !3p")
    end
end

concommand.Add("thirdperson_toggle", function() GAMEMODE:ToggleThirdperson() end)


DEFINE_BASECLASS("gamemode_base")
function GM:CalcView(ply, pos, ang, fov)
    local view = BaseClass.CalcView(self, ply, pos, ang, fov)


    local allowed = self.CVars.ThirdpersonAllowed:GetBool()
    if not allowed then self.Thirdperson = false end

    if allowed and self.Thirdperson and ply:Alive() then
        local mode = self.CVars.ThirdpersonMode:GetInt()

        if mode == 1 then
            view.origin = pos - ang:Forward() * 70 + ang:Right() * -20 + ang:Up() * 5
        elseif mode == 2 then
            view.origin = pos - ang:Forward() * 90 + ang:Right() * 1.75 + ang:Up() * 7.5
        elseif mode == 3 then
            view.origin = pos - ang:Forward() * 70 + ang:Right() * 20 + ang:Up() * 5
        end

        view.drawviewer = true
    end

    return view
end

