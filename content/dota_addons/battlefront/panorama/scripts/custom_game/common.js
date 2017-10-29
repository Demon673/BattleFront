alertObj = function(obj,name,str)
{
	var output = "";
	if (name == null)
	{
		name = toString(obj);
	}
	if (str == null)
	{
		str = "";
	}
	$.Msg(str+name+"\n"+str+"{")
	for(var i in obj){  
		var property=obj[i];
		if (typeof(property) == "object")
		{
			alertObj(property,i,str+"\t");
		}
		else
		{
			output = i + " = " + property + "\t(" + typeof(property) +")";
			$.Msg(str+"\t"+output);
		}
	}
	$.Msg(str+"}");
}
DeepPrint = function(obj){return alertObj(obj);}
Print = function(msg){$.Msg(msg);}
print = Print;

//GameUI
GameUI.SetCameraPitch = function(Pitch)
{
	GameUI.SetCameraPitchMin(Pitch+360);
	GameUI.SetCameraPitchMax(Pitch+360);
}

GameUI.SetMainStateUIVisible = function(bool,whitelist)
{
	var panel = $.GetContextPanel();
	// $.Msg(panel.paneltype)
	while( panel.paneltype != "DOTACustomUIRoot")
	{
		 panel =  panel.GetParent();
	}
	var t = 0;
	while(panel.GetChild(t).id != "CustomUIContainer_Hud")
		t++; 
	// $.Msg(panel.GetChild(t))
	panel = panel.GetChild(t)
	for (var i = 0; i < panel.GetChildCount(); i++)
	{
		var childPanel = panel.GetChild(i);
		var in_whitelist = false;
		for (var s = 0; s < whitelist.length; s++)
		{
			if (whitelist[s] == childPanel.id)
			{
				in_whitelist = true;
				break;
			}
		}
		if (!in_whitelist)
		{
			childPanel.SetHasClass("HUD_collapse", !bool);
		}
	}
}

GameUI.GetHUDSeed = function()
{
	var ParentPanel = $.GetContextPanel();
	while(ParentPanel.paneltype != "DOTAHud")
	{
		ParentPanel = ParentPanel.GetParent();
	}
	// $.Msg(panel.GetPositionWithinWindow());
	var width = Game.GetScreenWidth();
	var seed = 1920/width;
	if (ParentPanel.BHasClass("AspectRatio4x3"))
	{
		seed = 1440/width;
	}
	if (ParentPanel.BHasClass("AspectRatio5x4"))
	{
		seed = 1344/width;
	}
	if (ParentPanel.BHasClass("AspectRatio16x10"))
	{
		seed = 1728/width;
	}
	return seed;
}
GameUI.CorrectPositionValue = function(value)
{
	return GameUI.GetHUDSeed() * value;
}

GameUI.ErrorMessage = function(msg)
{
	GameEvents.SendEventClientSide("dota_hud_error_message", {"splitscreenplayer":Players.GetLocalPlayer(), "reason":80, "message":msg});
}

//Entities
Entities.GetCursorEntity = function()
{
	var targets = GameUI.FindScreenEntities(GameUI.GetCursorPosition());
	var targets1 = targets.filter(function(e)
		{
			return e.accurateCollision;
		});
	var targets2 = targets.filter(function(e)
		{
			return !e.accurateCollision;
		});
	targets = targets1;
	if (targets1.length == 0)
	{
		targets = targets2;
	}
	if (targets.length == 0)
	{
		return -1;
	}
	return targets[0].entityIndex;
}

Entities.DistanceBetweenUnits = function(unitindex1,unitindex2)
{
	if (Entities.IsValidEntity(unitindex1) && Entities.IsValidEntity(unitindex2))
	{
		var position1 = Entities.GetAbsOrigin(unitindex1);
		var position2 = Entities.GetAbsOrigin(unitindex2);
		return Math.sqrt((position2[0]-position1[0])*(position2[0]-position1[0])+(position2[1]-position1[1])*(position2[1]-position1[1]));
	}
	return 0;
}

Entities.GetUnitParentEntity = function(unit)
{
	return CustomNetTables.GetTableValue("unitEntities", unit);
}

Entities.IsChest = function(entityIndex)
{
	if (entityIndex != -1 && Entities.GetUnitParentEntity(entityIndex) != undefined && Entities.GetUnitParentEntity(entityIndex).chest != undefined)
	{
		return true;
	}
	return false;
}

Entities.HasModifier = function(entIndex, modifierName)
{
	var nBuffs = Entities.GetNumBuffs(entIndex);
	for (var i = 0; i < nBuffs; i++)
	{
		if (Buffs.GetName(entIndex, Entities.GetBuff(entIndex, i)) == modifierName)
		{
			return true;
		}
	}
	return false;
}

Entities.FindModifierByName = function(entIndex, modifierName)
{
	var nBuffs = Entities.GetNumBuffs(entIndex);
	for (var i = 0; i < nBuffs; i++)
	{
		if (Buffs.GetName(entIndex, Entities.GetBuff(entIndex, i)) == modifierName)
		{
			return Entities.GetBuff(entIndex, i);
		}
	}
	return -1;
}

Entities.LookAllItemContainers = function(entIndex, func)
{
	var unitEntity = Entities.GetUnitParentEntity(entIndex);
	if (unitEntity == undefined || unitEntity == null) return;
	var inventoryIndex = unitEntity.inventory;
	var backpackIndex = unitEntity.backpack;
	var openChests = unitEntity.openChests;

	if (inventoryIndex != undefined && inventoryIndex != null)
	{
		LookContainer(GetContainerByIndex(inventoryIndex), 
			function(slot, itemIndex)
			{
				if (func(inventoryIndex, slot, itemIndex) == true)
				{
					return true;
				}
			}
		);
	}

	if (backpackIndex != undefined && backpackIndex != null)
	{
		LookContainer(GetContainerByIndex(backpackIndex), 
			function(slot, itemIndex)
			{
				if (func(backpackIndex, slot, itemIndex) == true)
				{
					return true;
				}
			}
		);
	}


	if (openChests != undefined && openChests != null)
	{
		for (var id in openChests)
		{
			var chestIndex = openChests[id];
			LookContainer(GetContainerByIndex(chestIndex), 
				function(slot, itemIndex)
				{
					if (func(chestIndex, slot, itemIndex) == true)
					{
						return true;
					}
				}
			);
		}
	}
}

//Items
Items.GetItemDataByIndex = function(index)
{
	return CustomNetTables.GetTableValue("items", index);
}

Items.IsStackable = function(index)
{
	var itemData = Items.GetItemDataByIndex(index);

	if (itemData != undefined && itemData.isStackable != undefined && itemData.isStackable == 1)
	{
		return true;
	}
	return false;
}
Items.IsEquipment = function(index)
{
	var itemData = Items.GetItemDataByIndex(index);

	if (itemData != undefined && itemData.isEquipment != undefined && itemData.isEquipment == 1)
	{
		return true;
	}
	return false;
}
Items.IsFiniteUses = function(index)
{
	var itemData = Items.GetItemDataByIndex(index);

	if (itemData != undefined && itemData.isFiniteUses != undefined && itemData.isFiniteUses == 1)
	{
		return true;
	}
	return false;
}
Items.IsPerishable = function(index)
{
	var itemData = Items.GetItemDataByIndex(index);

	if (itemData != undefined && itemData.isPerishable != undefined && itemData.isPerishable == 1)
	{
		return true;
	}
	return false;
}
Items.IsEdible = function(index)
{
	var itemData = Items.GetItemDataByIndex(index);

	if (itemData != undefined && itemData.isEdible != undefined && itemData.isEdible == 1)
	{
		return true;
	}
	return false;
}
Items.IsBuildable = function(index)
{
	var itemData = Items.GetItemDataByIndex(index);

	if (itemData != undefined && itemData.isBuildable != undefined && itemData.isBuildable == 1)
	{
		return true;
	}
	return false;
}

//Generals
LookContainer = function(container, func)
{
	var row = container.row;
	var colm = container.colm;
	var list = container.list;
	var capacity = row*colm;
	for(slot in list)
	{
		var itemIndex = list[slot];
		if (func(slot, itemIndex) == true)
		{
			return true;
		}
	}
}

IsStackable = function(itemData)
{
	if (itemData != undefined && itemData.isStackable != undefined && itemData.isStackable == 1)
	{
		return true;
	}
	return false;
}
IsEquipment = function(itemData)
{
	if (itemData != undefined && itemData.isEquipment != undefined && itemData.isEquipment == 1)
	{
		return true;
	}
	return false;
}
IsFiniteUses = function(itemData)
{
	if (itemData != undefined && itemData.isFiniteUses != undefined && itemData.isFiniteUses == 1)
	{
		return true;
	}
	return false;
}
IsPerishable = function(itemData)
{
	if (itemData != undefined && itemData.isPerishable != undefined && itemData.isPerishable == 1)
	{
		return true;
	}
	return false;
}
IsEdible = function(itemData)
{
	if (itemData != undefined && itemData.isEdible != undefined && itemData.isEdible == 1)
	{
		return true;
	}
	return false;
}
IsBuildable = function(itemData)
{
	if (itemData != undefined && itemData.isBuildable != undefined && itemData.isBuildable == 1)
	{
		return true;
	}
	return false;
}

GetContainerByIndex = function(index)
{
	return CustomNetTables.GetTableValue("itemContainers", index);
}

