include("sh_init.lua")
AddCSLuaFile("sh_init.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_fonts.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_derma.lua")
AddCSLuaFile("cl_thirdperson.lua")
AddCSLuaFile("vgui/scoreboard.lua")
AddCSLuaFile("vgui/help.lua")
AddCSLuaFile("vgui/help_welcome.lua")
AddCSLuaFile("vgui/help_achievements.lua")
AddCSLuaFile("vgui/help_hiding.lua")
AddCSLuaFile("vgui/help_seeking.lua")
AddCSLuaFile("vgui/help_spectating.lua")
AddCSLuaFile("vgui/team_select.lua")
AddCSLuaFile("vgui/options.lua")
AddCSLuaFile("vgui/voice.lua")
AddCSLuaFile("vgui/avatar.lua")
AddCSLuaFile("vgui/avatar_frame.lua")
include("sv_player.lua")

util.AddNetworkString("HNS.Say")
util.AddNetworkString("HNS.PlaySound")
util.AddNetworkString("HNS.JoinPlaying")
util.AddNetworkString("HNS.JoinSpectating")
util.AddNetworkString("HNS.PlayerColorUpdate")
util.AddNetworkString("HNS.PlayerEvent")
util.AddNetworkString("HNS.PlayerNetReady")
util.AddNetworkString("HNS.RoundInfo")
util.AddNetworkString("HNS.Winner")

-- Sends a table to be unpacked on chat.AddText
function GM:SendChat(ply, ...)
    net.Start("HNS.Say")

    net.WriteString(util.TableToJSON({...}))

    net.Send(ply)
end

-- Same but to everyone
function GM:BroadcastChat(...)
    net.Start("HNS.Say")

    net.WriteString(util.TableToJSON({...}))

    net.Broadcast()
end

-- Plays a sound on the client
function GM:SendSound(ply, path)
    net.Start("HNS.PlaySound")
    net.WriteString(path)
    net.Send(ply)
end

-- Same but to everyone
function GM:BroadcastSound(path)
    net.Start("HNS.PlaySound")
    net.WriteString(path)
    net.Broadcast()
end

function GM:BroadcastEvent(ply, event)
    net.Start("HNS.PlayerEvent")
    net.WriteUInt(event, 3)
    net.WriteEntity(ply)
    net.Broadcast()
end
