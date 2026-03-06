GM.Achievements = {}

GM.Achievements["1kchampion"] = {
    Name = "Seeking Champion",
    Desc = "Catch 1000 players through-out your seeking career..",
    Goal = 1000,
    ImageName = "SKR1000"
}

GM.Achievements["submission"] = {
    Name = "Submission!",
    Desc = "As a seeker, have a hider run into you.",
    ImageName = "SBMISSN"
}

GM.Achievements["crowd"] = {
    Name = "Three's a Crowd!",
    Desc = "As a hider, win a round with 2 or more other hiders close-by.",
    ImageName = "HCROWD"
}

GM.Achievements["bike"] = {
    Name = "A Wise Man Once Said",
    Desc = "RED! This isn't the time to use that!",
    ImageName = "PKUPBIKE"
}

GM.Achievements["lasthiding"] = {
    Name = "Last Man Hiding",
    Desc = "Win a round as the last hider (with at least 4 other players)",
    ImageName = "LASTMAN"
}

GM.Achievements["closecall"] = {
    Name = "Close Call",
    Desc = "As a seeker, end the round by catching a hider in the last 10 seconds.",
    ImageName = "CLSECALL"
}

GM.Achievements["mario"] = {
    Name = "Mario the Italian Seeker",
    Desc = "As a seeker, catch a hider Mario style.",
    ImageName = "MTIS"
}

GM.Achievements["tranquility"] = {
    Name = "Hiding in Tranquility",
    Desc = "Wait for a total of 5 hours in your hiding career.",
    Goal = 18000,
    ImageName = "TNQHDING"
}

GM.Achievements["conversationalist"] = {
    Name = "Conversationalist",
    Desc = "As a hider, let the seekers know they're bad by talking a lot.",
    ImageName = "CONVOST"
}

GM.Achievements["ticklefight"] = {
    Name = "Magic Words",
    Desc = "Starts out fun, ends in tears.",
    ImageName = "TCKLEFGHT"
}

GM.Achievements["anotherway"] = {
    Name = "Another Way Through",
    Desc = "As a seeker, break something to hastily catch a hider.",
    ImageName = "WAYTHRO"
}

GM.Achievements["rubberlegs"] = {
    Name = "Rubber Legs",
    Desc = "Break your legs 50 times.",
    Goal = 50,
    ImageName = "RBRLEGS"
}

GM.Achievements["topplayer"] = {
    Name = "Top Player",
    Desc = "Be announced as the top scorer 10 times. ( 4+ players )",
    Goal = 10,
    ImageName = "TOPPLYR"
}

GM.Achievements["healthy"] = {
    Name = "Stayin' Healthy",
    Desc = "Get a helping of nutritious goods from the market.",
    ImageName = "HEALTHY"
}

GM.Achievements["rooted"] = {
    Name = "Rooted",
    Desc = "As a hider, survive a round by not setting foot out of your hiding spot.",
    ImageName = "ROOTED"
}

--GM.Achievements["friendsnatcher"] = {
--    Name = "Friend Snatcher",
--    Desc = "As a seeker, catch 3 friends in a single round.",
--    ImageName = "FRNDSCHR"
--}

-- Cache count, to not call table.Count again
GM.AchievementsCount = table.Count(GM.Achievements)
-- While we're at it
game.AddParticles("particles/explosion.pcf")
PrecacheParticleSystem("bday_confetti")
PrecacheParticleSystem("bday_confetti_colors")

