-- ach_master is a timestamp of when the player finished getting all of the achievements
-- It will be NULL if that hasn't happened yet
sql.Query("CREATE TABLE IF NOT EXISTS nhns_players (sid TEXT, ach_master_timestamp INT, PRIMARY KEY (sid))")

--sql.Query("CREATE TABLE IF NOT EXISTS nhns_achs_ach_types (type TEXT)")
--    sql.Query("INSERT INTO nhns_achs_ach_types VALUES ('once')")
--    sql.Query("INSERT INTO nhns_achs_ach_types VALUES ('prog')")
--    sql.Query("INSERT INTO nhns_achs_ach_types VALUES ('reqs')")


--sql.Query("CREATE TABLE IF NOT EXISTS nhns_achs_achs (id TEXT, type TEXT, PRIMARY KEY (id))")



--local playerAchievementFKs = "FOREIGN KEY (player_sid) REFERENCES nhns_players(sid), FOREIGN KEY (ach_id) REFERENCES nhns_achs (id)"
local playerAchievementFKs = "FOREIGN KEY (player_sid) REFERENCES nhns_players(sid)"


sql.Query("CREATE TABLE IF NOT EXISTS nhns_achs_completions (player_sid TEXT, ach_id TEXT, timestamp INT NOT NULL, " .. playerAchievementFKs .. ", PRIMARY KEY (player_sid, ach_id))")
sql.Query("CREATE TABLE IF NOT EXISTS nhns_achs_data_prog (player_sid TEXT, ach_id TEXT, progress INT NOT NULL, timestamp INT NOT NULL, " .. playerAchievementFKs .. ", PRIMARY KEY (player_sid, ach_id))")
sql.Query("CREATE TABLE IF NOT EXISTS nhns_achs_data_reqs (player_sid TEXT, ach_id TEXT, req_name TEXT, timestamp INT NOT NULL, " .. playerAchievementFKs .. ", PRIMARY KEY (player_sid, ach_id, req_name))")




GM:AddHook(function(gm, data, ply)

    local sid = ply:SteamID()
    sql.QueryTyped("INSERT OR IGNORE INTO nhns_players(sid) VALUES (?)", sid)


    -- achMaster looks like:
    -- 1772104950

    -- achsCompleted looks like:
    -- { ["crowd"] = 1772104950 }

    -- achProgresss looks like:
    -- { ["1kchampion"] = {["progress"] = 500, ["timestamp"] = 1772104950} }

    -- achReqs looks like:
    -- { ["specialrounds"] = {["sardine"] = 1772104950} }

    -- Each corresponding "new" table has the same structure



    -- ply.achMaster will be set later in this function
    ply.achsCompleted = {}
    ply.achProgress = {}
    ply.achReqs = {}



    -- New achievement progress
    -- Used to avoid making more DB queries than is necessary

    -- ply.newAchMaster will be set elsewhere if the player becomes an ach master
    ply.newAchsCompleted = {}
    ply.newAchProgress = {}
    ply.newAchReqs = {}



    local master = sql.QueryTyped("SELECT ach_master_timestamp FROM nhns_players WHERE sid = ?", sid)
    if master then
        ply.achMaster = master[1]["ach_master_timestamp"]
    end




    local completions = sql.QueryTyped("SELECT * FROM nhns_achs_completions WHERE player_sid = ?", sid) or {}

    for _, row in ipairs(completions) do
        ply.achsCompleted[row["ach_id"]] = row["timestamp"]
    end




    local progress = sql.QueryTyped("SELECT * FROM nhns_achs_data_prog WHERE player_sid = ?", sid) or {}

    for _, row in ipairs(progress) do
        ply.achProgress[row["ach_id"]] = {
            ["progress"] = row["progress"],
            ["timestamp"] = row["timestamp"]
        }
    end




    local reqs = sql.QueryTyped("SELECT * FROM nhns_achs_data_reqs WHERE player_sid = ?", sid) or {}

    for _, row in ipairs(reqs) do
        local achID = row["ach_id"]
        ply.achReqs[achID] = ply.achReqs[achID] or {}

        ply.achReqs[achID][row["req_name"]] = row["timestamp"]
    end




end, "PlayerInitialSpawn", {"HNS", "InitPlayerAchievements"})




local PLAYER = FindMetaTable("Player")



function PLAYER:AchComplete(achID)
    if self.achsCompleted[achID] then return end

    local time = os.time()

    self.newAchsCompleted[achID] = time
    self.achsCompleted[achID] = time


    if table.Count(self.achsCompleted) == GAMEMODE.AchievementsCount then
        self.newAchMaster = time
    end


    -- Called HASAchievementEarned for compatibility with LHNS
    hook.Run("HASAchievementEarned", self, achID)
end


function PLAYER:AchSetProgress(achID, progress)
    if self.achsCompleted[achID] then return end


    local goal = GAMEMODE.Achievements[achID].Goal

    local prog = math.Clamp(progress, 0, goal)
    local time = os.time()

    local tab = {
        ["progress"] = prog,
        ["timestamp"] = time
    }

    self.newAchProgress[achID] = tab
    self.achProgress[achID] = tab


    if prog == goal then self:AchComplete(achID) end


    hook.Run("HASAchProgressUpdate", self, achID)
end

function PLAYER:AchAddProgress(achID, progress)
    local prog = self.achProgress[achID] and self.achProgress[achID]["progress"] or 0

    self:AchSetProgress(achID, prog + progress)
end


function PLAYER:AchReqFulfill(achID, reqName)
    self.achReqs[achID] = self.achReqs[achID] or {}

    if self.achReqs[achID][reqName] then return end


    local time = os.time()
    self.newAchReqs[achID][reqName] = time
    self.achReqs[achID][reqName] = time



    local complete = true
    for req, _ in pairs(GAMEMODE.Achievements[achID].Requirements) do
        if not self.achReqs[req] then complete = false end
    end


    if complete then ply:AchComplete(achID) end



    hook.Run("HASAchReqFulfilled", self, achID, req)
end





function PLAYER:WriteAchs()
    sql.Begin()

    local sid = self:SteamID()



    if self.newAchMaster then
        sql.QueryTyped("UPDATE nhns_players SET ach_master_timestamp = ? WHERE sid = ?", self.newAchMaster, sid)
    end



    for achID, timestamp in pairs(self.newAchsCompleted) do
        sql.QueryTyped("INSERT INTO nhns_achs_completions VALUES (?, ?, ?)", sid, achID, timestamp)
    end




    for achID, info in pairs(self.newAchProgress) do
        local progress = info["progress"]
        local timestamp = info["timestamp"]

        sql.QueryTyped("REPLACE INTO nhns_achs_data_prog VALUES (?, ?, ?, ?)", sid, achID, progress, timestamp)
    end




    for achID, reqs in pairs(self.newAchReqs) do

        for req, timestamp in pairs(reqs) do
            sql.QueryTyped("INSERT INTO nhns_achs_data_reqs VALUES (?, ?, ?, ?)", sid, achID, req, timestamp)
        end

    end


    sql.Commit()
end




GM:AddHook(function(gm, data, ply)
    ply:WriteAchs()
end, "PlayerDisconnected", {"HNS", "WriteAchs"})



-- This is here because PlayerDisconnected won't always work
--
-- https://wiki.facepunch.com/gmod/GM:PlayerDisconnected
-- "BUG: This is not called in single-player or listen servers for the host."
GM:AddHook(function(gm, data)

    for _, ply in ipairs(player.GetAll()) do
        if not ply:IsListenServerHost() then continue end

        ply:WriteAchs()
        break
    end

end, "ShutDown", {"HNS", "WriteAchs"})


