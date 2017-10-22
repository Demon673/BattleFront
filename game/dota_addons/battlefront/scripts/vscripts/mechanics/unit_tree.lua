UnitTree = UnitTree or class({})

UnitTree.lists = 
{
	base_level_1 = 
	{
		"bear_lv1",
		"centaur_lv1",
		"melee_creep_lv1",
		"ogre_magi_lv1",
		"range_creep_lv1",
		"satyr_lv1",
		"treant_lv1",
		"wildkin_lv1",
		"wolf_lv1",
	},
	base_level_2 = 
	{
		"bear_lv2",
		"centaur_lv2",
		"melee_creep_lv2",
		"ogre_magi_lv2",
		"range_creep_lv2",
		"satyr_lv2",
		"treant_lv2",
		"wildkin_lv2",
		"wolf_lv2",
	},
	base_level_3 = 
	{
		"bear_lv3",
		"centaur_lv3",
		"melee_creep_lv3",
		"ogre_magi_lv3",
		"range_creep_lv3",
		"satyr_lv3",
		"treant_lv3",
		"wildkin_lv3",
		"wolf_lv3",
	},
}

function UnitTree:GetListByUnitType(sUnitType)
	return self.lists[sUnitType]
end

function UnitTree:Init()
end