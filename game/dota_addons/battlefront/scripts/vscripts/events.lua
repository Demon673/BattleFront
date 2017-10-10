
-------------------------------------------------------
-- game_rules_state_change
---------------------------------------------------------
function BattleFront:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()

	if nNewState == DOTA_GAMERULES_STATE_INIT then
		--print("OnGameRulesStateChange: Init")

	elseif nNewState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		--print("OnGameRulesStateChange: Wait For Players To Load")

	elseif nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		--print("OnGameRulesStateChange: Custom Game Setup")

	elseif nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		--print("OnGameRulesStateChange: Hero Selection")

	elseif nNewState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		--print("OnGameRulesStateChange: Strategy Time")
		for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
			local hPlayer = PlayerResource:GetPlayer(nPlayerID)
			if hPlayer and not PlayerResource:HasSelectedHero(nPlayerID) then
				hPlayer:MakeRandomHeroSelection()
			end
		end

	elseif nNewState == DOTA_GAMERULES_STATE_TEAM_SHOWCASE then
		--print("OnGameRulesStateChange: Team Showcase")

	elseif nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
		--print("OnGameRulesStateChange: Pre Game")

	elseif nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print("OnGameRulesStateChange: Game In Progress")

	elseif nNewState == DOTA_GAMERULES_STATE_POST_GAME then
		--print("OnGameRulesStateChange: Post Game")

	elseif nNewState == DOTA_GAMERULES_STATE_DISCONNECT then
		--print("OnGameRulesStateChange: Disconnect")

	end
end

---------------------------------------------------------
-- dota_player_reconnected
-- * player_id
---------------------------------------------------------
function BattleFront:OnPlayerReconnected(event)
	local hPlayer = PlayerResource:GetPlayer(event.player_id)
	if hPlayer ~= nil then
		local hPlayerHero = hPlayer:GetAssignedHero()
		if hPlayerHero ~= nil then
		end
	end
end

---------------------------------------------------------
-- npc_spawned
-- * entindex
---------------------------------------------------------
function BattleFront:OnNPCSpawned(event)
	local spawnedUnit = EntIndexToHScript(event.entindex)
	if spawnedUnit ~= nil then
		if spawnedUnit:IsRealHero() then
			self:OnNPCSpawned_PlayerHero(event)
			return
		end
		if spawnedUnit:IsCreature() then
			self:OnNPCSpawned_Creature(event)
			return
		end
	end
end
function BattleFront:OnNPCSpawned_PlayerHero(event)
	local hPlayerHero = EntIndexToHScript(event.entindex)
	if hPlayerHero ~= nil then
		local hModel = hPlayerHero:FirstMoveChild()
		while hModel ~= nil do
			if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" then
				hModel:RemoveSelf()
			end
			hModel = hModel:NextMovePeer()
		end
		hPlayerHero:SetForwardVector(Vector(1,0,0))
	end
end
function BattleFront:OnNPCSpawned_Creature(event)
	local hEnemyCreature = EntIndexToHScript(event.entindex)
	if hEnemyCreature ~= nil then
	end
end

---------------------------------------------------------
-- entity_killed
-- * entindex_killed
-- * entindex_attacker
-- * entindex_inflictor
-- * damagebits
---------------------------------------------------------
function BattleFront:OnEntityKilled(event)
	local killedUnit = EntIndexToHScript(event.entindex_killed)
	if killedUnit ~= nil then
		if killedUnit:IsRealHero() then
			self:OnEntityKilled_PlayerHero(event)
			return
		end

		if killedUnit:IsCreature() then
			self:OnEntityKilled_Creature(event)
			return
		end
	end
end
function BattleFront:OnEntityKilled_PlayerHero(event)
	local killedUnit = EntIndexToHScript(event.entindex_killed)
	local killerUnit = EntIndexToHScript(event.entindex_attacker)
	if killedUnit and killedUnit:IsRealHero() then
	end
end
function BattleFront:OnEntityKilled_Creature(event)
	local hDeadCreature = EntIndexToHScript(event.entindex_killed)
	if hDeadCreature == nil then
		return
	end

	local hAttackerUnit = EntIndexToHScript(event.entindex_attacker)
	if hAttackerUnit and hAttackerUnit:IsRealHero() then
	end
end

---------------------------------------------------------
-- dota_holdout_revive_complete
-- * caster (reviver hero entity index)
-- * target (revivee hero entity index)
---------------------------------------------------------
function BattleFront:OnPlayerRevived(event)
	local hRevivedHero = EntIndexToHScript(event.target)
	if hRevivedHero ~= nil and hRevivedHero:IsRealHero() then
	end
end

---------------------------------------------------------
-- dota_buyback
-- * entindex
-- * player_id
---------------------------------------------------------
function BattleFront:OnPlayerBuyback(event)
	local hPlayer = PlayerResource:GetPlayer(event.player_id)
	if hPlayer == nil then
		return
	end

	local hHero = hPlayer:GetAssignedHero()
	if hHero == nil then
		return
	end
end

---------------------------------------------------------
-- dota_player_gained_level
-- * player (player entity index)
-- * level (new level)
---------------------------------------------------------
function BattleFront:OnPlayerGainedLevel(event)
end

---------------------------------------------------------
-- dota_item-spawned
-- * player_id
-- * item_ent_index
---------------------------------------------------------
function BattleFront:OnItemSpawned(event)
	local item = EntIndexToHScript(event.item_ent_index)
	if item ~= nil then
	end
end

---------------------------------------------------------
-- dota_item_picked_up
-- * PlayerID
-- * HeroEntityIndex
-- * UnitEntityIndex (only if parent is not a hero)
-- * itemname
-- * ItemEntityIndex
---------------------------------------------------------
function BattleFront:OnItemPickedUp(event)
	local item = EntIndexToHScript(event.ItemEntityIndex)
	local hero = EntIndexToHScript(event.HeroEntityIndex)
	if item ~= nil and hero ~= nil then
	end
end

---------------------------------------------------------
-- dota_non_player_used_ability
-- * abilityname
-- * caster_entindex
---------------------------------------------------------
function BattleFront:OnNonPlayerUsedAbility(event)
	local szAbilityName = event.abilityname
	if event.caster_entindex == nil then
		print("ERROR: event.caster_entindex is nil.  (szAbilityName == " .. szAbilityName .. "\")")
		return
	end
	local hCaster = EntIndexToHScript(event.caster_entindex)
	if szAbilityName ~= nil and hCaster ~= nil then
	end
end