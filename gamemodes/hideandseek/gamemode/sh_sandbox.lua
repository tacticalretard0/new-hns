-- This function controls whether ANY sandbox feature can be used
-- Any sandbox feature that can be accessed by a user is an oversight on my end
-- Some Admin tools (like SAM and ULX) override these permissions
function GM:CanPlayerSandbox(ply)
    return ply:IsSuperAdmin()
end

-- This function doesn't have a Sandbox function
function GM:CanArmDupe(ply)
    return hook.Run("CanPlayerSandbox", ply)
end

function GM:CanDrive(ply, ent)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.CanDrive(self, ply, ent)
    end
    return false
end

function GM:CanProperty(ply, property, ent)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.CanProperty(self, ply, property, ent)
    end
    return false
end

function GM:CanTool(ply, tr, toolname, tool, button)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.CanTool(self, ply, tr, toolname, tool, button)
    end
    return false
end




if CLIENT then
    function GM:ContextMenuOpen()
        return hook.Run("CanPlayerSandbox", LocalPlayer())
    end

    function GM:SpawnMenuOpen()
        return hook.Run("CanPlayerSandbox", LocalPlayer())
    end



    local function SuppressSandboxStuff()
        -- Don't open the spawn menu when F1 is pressed
        -- Run in a timer because sandbox uses a 0 second timer to add the hook for some reason
        --
        -- Stack trace from where the hook is added:
        -- https://github.com/Facepunch/garrysmod/blob/a2ef0633fa8635e42481a33de6c3add17de859ce/garrysmod/gamemodes/sandbox/gamemode/spawnmenu/creationmenu/content/contentsearch.lua#L78
        -- https://github.com/Facepunch/garrysmod/blob/a2ef0633fa8635e42481a33de6c3add17de859ce/garrysmod/gamemodes/sandbox/gamemode/spawnmenu/creationmenu/content/contentsidebar.lua#L22
        -- https://github.com/Facepunch/garrysmod/blob/a2ef0633fa8635e42481a33de6c3add17de859ce/garrysmod/gamemodes/sandbox/gamemode/spawnmenu/creationmenu/content/content.lua#L53
        -- https://github.com/Facepunch/garrysmod/blob/a2ef0633fa8635e42481a33de6c3add17de859ce/garrysmod/gamemodes/sandbox/gamemode/spawnmenu/creationmenu/content/contenttypes/vehicles.lua#L83
        -- https://github.com/Facepunch/garrysmod/blob/a2ef0633fa8635e42481a33de6c3add17de859ce/garrysmod/gamemodes/sandbox/gamemode/spawnmenu/creationmenu.lua#L48
        timer.Simple(0.1, function() hook.Remove("StartSearch", "StartSearch") end)



        if hook.Run("CanPlayerSandbox", LocalPlayer()) then return end

        GAMEMODE:SuppressHint("Annoy1")
        GAMEMODE:SuppressHint("Annoy2")
        GAMEMODE:SuppressHint("OpeningMenu")
    end

    -- Needs to be on InitPostEntity because SuppressHints calls LocalPlayer
    GM:AddHook(SuppressSandboxStuff, "InitPostEntity", {"HNS", "SuppressHints"})
    function GM:OnReloaded() SuppressSandboxStuff() end
end






if CLIENT then return end


function GM:PlayerSpawnObject(ply)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.PlayerSpawnObject(self, ply)
    end
    return false
end

function GM:CanPlayerUnfreeze(ply, entity, physobject)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.CanPlayerUnfreeze(self, ply, entity, physobject)
    end
    return false
end

function GM:PlayerSpawnRagdoll(ply, model)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.PlayerSpawnRagdoll(self, ply, model)
    end
    return false
end

function GM:PlayerSpawnProp(ply, model)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.PlayerSpawnProp(self, ply, model)
    end
    return false
end

function GM:PlayerSpawnEffect(ply, model)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.PlayerSpawnEffect(self, ply, model)
    end
    return false
end

function GM:PlayerSpawnVehicle(ply, model, vname, vtable)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.PlayerSpawnVehicle(self, ply, model, vname, vtable)
    end
    return false
end

function GM:PlayerSpawnSWEP(ply, wname, wtable)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.PlayerSpawnSWEP(self, ply, wname, wtable)
    end
    return false
end

function GM:PlayerGiveSWEP(ply, wname, wtable)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.PlayerGiveSWEP(self, ply, wname, wtable)
    end
    return false
end

function GM:PlayerSpawnSENT(ply, name)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.PlayerSpawnSENT(self, ply, name)
    end
    return false
end

function GM:PlayerSpawnNPC(ply, npc_type, equipment)
    if hook.Run("CanPlayerSandbox", ply) then
        return self.BaseClass.PlayerSpawnNPC(self, ply, npc_type, equipment)
    end
    return false
end




function GM:PostCleanupMap()
    local filename = GetConVar("sbox_persist"):GetString():Trim()
    if filename == "" then return end

    hook.Run("PersistenceLoad", filename)
end

