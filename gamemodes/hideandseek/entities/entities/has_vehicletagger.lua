
ENT.Base = "base_anim"
ENT.Type = "anim"


function ENT:Initialize()
   self:SetNoDraw(true)

   self:SetSolid(SOLID_VPHYSICS)

   self:SetSolidFlags(FSOLID_CUSTOMBOXTEST)
   self:SetTrigger(true)

   -- Don't collide with anything
   self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
end


function ENT:UpdateTransmitState()
   return TRANSMIT_NEVER
end


function ENT:SetVehicle(veh)
   self:SetMoveParent(veh)
   self.vehicle = veh


   local vehPhys = veh:GetPhysicsObject()
   local convexes = vehPhys:GetMeshConvexes()


   -- Scale each of the convexes slightly so that players don't need to be
   -- pressing right up against a vehicle for tags to be detected
   --
   -- We make sure to scale each of the convexes around its own "center"
   -- instead of just multiplying them, so that each convex scales around its
   -- corresponding feature on the vehicle model without moving away from it
   local centroids = {}
   for i, convex in ipairs(convexes) do
      local sum = Vector()
      local total

      for j, vertex in ipairs(convex) do
         sum = sum + vertex.pos
         total = j
      end

      centroids[i] = sum / total
   end


   local scaledConvexes = {}
   for i, convex in ipairs(convexes) do
      scaledConvexes[i] = {}

      for j, vertex in ipairs(convex) do
         local relativeToCentroid = vertex.pos - centroids[i]

         local scaledAroundCentroid = centroids[i] + relativeToCentroid * 1.25
         scaledConvexes[i][j] = scaledAroundCentroid
      end
   end


   self:PhysicsInitMultiConvex(scaledConvexes)
end


function ENT:Touch(ent)
   local playingPlayer = ent:IsPlayer() and ent:IsPlaying()

   if not (ent.HNSVehicle or playingPlayer) then return end
   if GAMEMODE.RoundState ~= ROUND_ACTIVE then return end



   local driver = self.vehicle:GetDriver()

   if not driver:IsValid() then return end



   local updateOurCar = false
   local updateOtherCar = false


   -- Red car + blue car
   if ent.HNSVehicle then
      -- We're red
      if driver:Team() ~= TEAM_SEEK then return end


      local otherDriver = ent:GetDriver()

      -- They're blue
      if not otherDriver:IsValid() then return end
      if otherDriver:Team() ~= TEAM_HIDE then return end


      otherDriver:Caught(driver)
      updateOtherCar = true
   

   -- Red car + blue player
   elseif driver:Team() == TEAM_SEEK and ent:Team() == TEAM_HIDE then
      ent:Caught(driver)

   -- Blue car + red player
   elseif driver:Team() == TEAM_HIDE and ent:Team() == TEAM_SEEK then
      driver:Caught(ent)
      updateOurCar = true
   end



   if updateOurCar then
      self.vehicle:SetToPlayerColor(driver)
   end


   if updateOtherCar then
      ent:SetToPlayerColor( ent:GetDriver() )
   end


end


