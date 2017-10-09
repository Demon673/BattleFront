
---------------------------------------------------------------------------
--	AbilityTuningValueFilter
--  *
---------------------------------------------------------------------------
function BattleFront:AbilityTuningValueFilter(filterTable)
    return true
end

---------------------------------------------------------------------------
--	BountyRunePickupFilter
--  *
---------------------------------------------------------------------------
function BattleFront:BountyRunePickupFilter(filterTable)
    return true
end

---------------------------------------------------------------------------
--	DamageFilter
--  *entindex_victim_const
--	*entindex_attacker_const
--	*entindex_inflictor_const
--	*damagetype_const
--	*damage
---------------------------------------------------------------------------
function BattleFront:DamageFilter(filterTable)
    return true
end

---------------------------------------------------------------------------
--	ExecuteOrderFilter
--  *entindex_victim_const
--	*entindex_attacker_const
--	*entindex_inflictor_const
--	*damagetype_const
--	*damage
---------------------------------------------------------------------------
function BattleFront:ExecuteOrderFilter(filterTable)
    return true
end

---------------------------------------------------------------------------
--	HealingFilter
--  *entindex_target_const
--	*entindex_healer_const
--	*entindex_inflictor_const
--	*heal
---------------------------------------------------------------------------
function BattleFront:HealingFilter(filterTable)
	return true
end

---------------------------------------------------------------------------
--	ItemAddedToInventoryFilter
--  *item_entindex_const
--	*item_parent_entindex_const
--	*inventory_parent_entindex_const
--	*suggested_slot
---------------------------------------------------------------------------
function BattleFront:ItemAddedToInventoryFilter(filterTable)
	return true
end

---------------------------------------------------------------------------
--	ModifierGainedFilter
--  *entindex_parent_const
--	*entindex_ability_const
--	*entindex_caster_const
--	*name_const
--	*duration
---------------------------------------------------------------------------
function BattleFront:ModifierGainedFilter(filterTable)
	return true
end

---------------------------------------------------------------------------
--	ModifyExperienceFilter
--  *
---------------------------------------------------------------------------
function BattleFront:ModifyExperienceFilter(filterTable)
	return true
end

---------------------------------------------------------------------------
--	ModifyGoldFilter
--  *
---------------------------------------------------------------------------
function BattleFront:ModifyGoldFilter(filterTable)
	return true
end

---------------------------------------------------------------------------
--	RuneSpawnFilter
--  *
---------------------------------------------------------------------------
function BattleFront:RuneSpawnFilter(filterTable)
	return true
end

---------------------------------------------------------------------------
--	TrackingProjectileFilter
--  *
---------------------------------------------------------------------------
function BattleFront:TrackingProjectileFilter(filterTable)
	return true
end