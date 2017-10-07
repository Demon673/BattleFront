-- Generated from template

if BattleFront == nil then
	BattleFront = class({})
end

function Precache(context)
	local precache = require("precache")
	for type, path in pairs(precache) do
		PrecacheResource(type, path, context)
	end
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = BattleFront()
	GameRules.AddonTemplate:InitGameMode()
end

function BattleFront:InitGameMode()
	if GetMapName() == "battlefront" then
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_2, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_3, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_4, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_5, 1)
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_6, 1)
	end
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end

-- Evaluate the state of the game
function BattleFront:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end