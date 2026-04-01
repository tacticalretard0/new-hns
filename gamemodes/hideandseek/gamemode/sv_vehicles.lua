local vehicles = {
    ["prop_vehicle_airboat"] = true,
    ["prop_vehicle_jeep"] = true
}


local VEHICLE = FindMetaTable("Vehicle")

function VEHICLE:IsAllowedVehicle()
    return vehicles[self:GetClass()] or false
end

function VEHICLE:SetToPlayerColor(ply)
    if not self:IsAllowedVehicle() then return end

    if not self.oldColor then
        self.oldColor = self:GetColor()
    end

    self:SetColor( GAMEMODE:GetPlayerTeamColor(ply) )
end

function VEHICLE:ResetColor(ply)
    if not self:IsAllowedVehicle() then return end

    self:SetColor(self.oldColor)
    self.oldColor = nil
end



function GM:PlayerEnteredVehicle(ply, veh, role)
    if not veh:IsAllowedVehicle() then return end

    veh:SetToPlayerColor(ply)
end


function GM:PlayerLeaveVehicle(ply, veh)
    if not veh:IsAllowedVehicle() then return end

    veh:ResetColor()
end



GM:AddHook(function(gm, data, ent)
    timer.Simple(0, function()
        if not ent:IsValid() then return end
        if not ent:IsVehicle() then return end
        if not ent:IsValidVehicle() then return end

        if not ent:IsAllowedVehicle() then return end


        ent.HNSVehicle = true


        local vehTagger = ents.Create("has_vehicletagger")

        vehTagger:Spawn()
        vehTagger:SetVehicle(ent)
    end)
end, "OnEntityCreated", {"HNS", "Vehicles", "CreateVehicleTaggers"})


