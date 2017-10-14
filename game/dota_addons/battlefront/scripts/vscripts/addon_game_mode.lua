if BattleFront == nil then
	_G.BattleFront = class({})
end

require("constants")
require("utility_functions")
require("events")
require("filters")

--mechanics
require("mechanics/wearables")
require("mechanics/region")

--libraries
require("libraries/keyvalues")

function Precache(context)
	local precache = require("precache")
	for type, t in pairs(precache) do
		for _, path in pairs(t) do
			if type == "item" then
				PrecacheItemByNameSync(path, context)
			elseif type == "unit" then
				PrecacheUnitByNameSync(path, context)
			else
				PrecacheResource(type, path, context)
			end
		end
	end
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = BattleFront()
	GameRules.AddonTemplate:InitGameMode()
end

function BattleFront:InitGameMode()
	--mechanics/wearables
	if IsInToolsMode() then
		MakeSets()
	end
	GameRules.TeamPosition = {}
	if GetMapName() == "battlefront" then
		GameRules.TeamPosition[DOTA_TEAM_GOODGUYS] = 1
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 1)

		GameRules.TeamPosition[DOTA_TEAM_BADGUYS] = 2
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 1)

		GameRules.TeamPosition[DOTA_TEAM_CUSTOM_1] = 3
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_1, 1)

		GameRules.TeamPosition[DOTA_TEAM_CUSTOM_2] = 4
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_2, 1)

		GameRules.TeamPosition[DOTA_TEAM_CUSTOM_3] = 5
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_3, 1)

		GameRules.TeamPosition[DOTA_TEAM_CUSTOM_4] = 6
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_4, 1)

		GameRules.TeamPosition[DOTA_TEAM_CUSTOM_5] = 7
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_5, 1)

		GameRules.TeamPosition[DOTA_TEAM_CUSTOM_6] = 8
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_CUSTOM_6, 1)

		GameRules.TeamPosition.MAX_POSITION = 8
	end

	Region:Init()

	GameRules:SetUseUniversalShopMode(true)

	ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(BattleFront, "OnGameRulesStateChange"), self)
	ListenToGameEvent("dota_player_reconnected", Dynamic_Wrap(BattleFront, "OnPlayerReconnected"), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(BattleFront, "OnNPCSpawned"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(BattleFront, "OnEntityKilled"), self)
	ListenToGameEvent("dota_player_gained_level", Dynamic_Wrap(BattleFront, "OnPlayerGainedLevel"), self)
	ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(BattleFront, "OnItemPickedUp"), self)
	ListenToGameEvent("dota_holdout_revive_complete", Dynamic_Wrap(BattleFront, "OnPlayerRevived"), self)
	ListenToGameEvent("dota_buyback", Dynamic_Wrap(BattleFront, "OnPlayerBuyback"), self)
	ListenToGameEvent("dota_item_spawned", Dynamic_Wrap(BattleFront, "OnItemSpawned"), self)

	GameRules:GetGameModeEntity():SetAbilityTuningValueFilter(Dynamic_Wrap(BattleFront, "AbilityTuningValueFilter"), self)
	GameRules:GetGameModeEntity():SetBountyRunePickupFilter(Dynamic_Wrap(BattleFront, "BountyRunePickupFilter"), self)
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(BattleFront, "DamageFilter"), self)
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(BattleFront, "ExecuteOrderFilter"), self)
	GameRules:GetGameModeEntity():SetHealingFilter(Dynamic_Wrap(BattleFront, "HealingFilter"), self)
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(BattleFront, "ItemAddedToInventoryFilter"), self)
	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(BattleFront, "ModifierGainedFilter"), self)
	GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(BattleFront, "ModifyExperienceFilter"), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(BattleFront, "ModifyGoldFilter"), self)
	GameRules:GetGameModeEntity():SetRuneSpawnFilter(Dynamic_Wrap(BattleFront, "RuneSpawnFilter"), self)
	GameRules:GetGameModeEntity():SetTrackingProjectileFilter(Dynamic_Wrap(BattleFront, "TrackingProjectileFilter"), self)
	
	print("BattleFront is loaded.")
	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 0)
end

-- Evaluate the state of the game
function BattleFront:OnThink()
	local now = GameRules:GetGameTime()
	return 0
end