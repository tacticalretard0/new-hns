-- Shared ConVars
GM.CVars = GM.CVars or {}

GM.CVars.MaxRounds = CreateConVar("has_maxrounds", 5, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Rounds until map change")
GM.CVars.TimeLimit = CreateConVar("has_timelimit", 300, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Time to seek (0 is infinite)")
GM.CVars.EnviromentDamageAllowed = CreateConVar("has_envdmgallowed", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Will the map hurt players?")
GM.CVars.BlindTime = CreateConVar("has_blindtime", 30, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Time to hide (seekers are blinded)")
GM.CVars.HiderReward = CreateConVar("has_hidereward", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "How many points to award hiders per round won")
GM.CVars.SeekerReward = CreateConVar("has_seekreward", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "How many points to award seekers per hider tag")
GM.CVars.HiderRunSpeed = CreateConVar("has_hiderrunspeed", 320, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Speed at which hiders run at")
GM.CVars.SeekerRunSpeed = CreateConVar("has_seekerrunspeed", 360, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Speed at which seekers run at")
GM.CVars.HiderWalkSpeed = CreateConVar("has_hiderwalkspeed", 190, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Speed at which hiders walk at")
GM.CVars.SeekerWalkSpeed = CreateConVar("has_seekerwalkspeed", 200, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Speed at which seekers walk at")
GM.CVars.JumpPower = CreateConVar("has_jumppower", 210, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Force everyone jumps with")
GM.CVars.ClickRange = CreateConVar("has_clickrange", 100, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Range at which seekers can click tag")
GM.CVars.ScoreboardText = CreateConVar("has_scob_text", "Light HNS", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Text for the scoreboard (top left button)")
GM.CVars.ScoreboardURL = CreateConVar("has_scob_url", "https://github.com/Fafy2801/light-hns", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Link the scoreboard button will open (top left button too)")
GM.CVars.HiderTrail = CreateConVar("has_lasthidertrail", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Put a trail on the last remaining hider.")
GM.CVars.HiderFlash = CreateConVar("has_hiderflashlight", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Enable hider flashlights (only visible to them).")
GM.CVars.TeamIndicators = CreateConVar("has_teamindicators", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Draw an indicator over teammates heads when they are far away.")
GM.CVars.InfiniteStamina = CreateConVar("has_infinitestamina", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Enable infinite stamina.")
GM.CVars.FirstSeeks = CreateConVar("has_firstcaughtseeks", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "First player caught will seek next round.")
GM.CVars.MaxStamina = CreateConVar("has_maxstamina", 100, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Maximum ammount of stamina players can refill.")
GM.CVars.StaminaRefill = CreateConVar("has_staminarefill", 6.6, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Rate at which stamina is filled.")
GM.CVars.StaminaDeplete = CreateConVar("has_staminadeplete", 13.3, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Rate at which stamina is depleted.")
GM.CVars.StaminaWait = CreateConVar("has_staminawait", 2, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "How many seconds to wait before filling stamina.")
GM.CVars.MinPlayers = CreateConVar("has_minplayers", 2, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE}, "Minimum players required to start a round.")



-- Create local cvars for customization
if SERVER then return end
GM.CVars.HUD = CreateClientConVar("has_hud", 2, true, false)
GM.CVars.HiderColor = CreateClientConVar("has_hidercolor", "Default", true, true)
GM.CVars.SeekerColor = CreateClientConVar("has_seekercolor", "Default", true, true)
GM.CVars.Gender = CreateClientConVar("has_gender", 0, true, true)
GM.CVars.ShowID = CreateClientConVar("has_showid", 1, true, false)
GM.CVars.ShowOnTop = CreateClientConVar("has_scob_ontop", 0, true, false)
GM.CVars.Sort = CreateClientConVar("has_scob_sort", 1, true, false)
GM.CVars.ShowSpeed = CreateClientConVar("has_showspeed", 0, true, false)
GM.CVars.SpeedX = CreateClientConVar("has_speedx", 45, true, false)
GM.CVars.SpeedY = CreateClientConVar("has_speedy", 30, true, false)
GM.CVars.HUDScale = CreateClientConVar("has_hud_scale", 2, true, false)
GM.CVars.SortReversed = CreateClientConVar("has_scob_sort_reversed", 0, true, false)
GM.CVars.DarkTheme = CreateClientConVar("has_darktheme", 1, true, false)
GM.CVars.AvatarFrames = CreateClientConVar("has_avatarframes", 1, true, false)

-- For voice derma
GM.CVars.VoiceLoopback = GetConVar("voice_loopback")

