var CONSUME_EVENT = true;
var CONTINUE_PROCESSING_EVENT = false;

function OnRightPressed()
{
	var iPlayerID = Players.GetLocalPlayer();
	var selectedEntities = Players.GetSelectedEntities( iPlayerID );
	var mainSelected = Players.GetLocalPlayerPortraitUnit();
	var mainSelectedName = Entities.GetUnitName(mainSelected);
	var targetIndex = Entities.GetCursorEntity();
	var cursor = GameUI.GetCursorPosition();
	var worldPosition = GameUI.GetScreenWorldPosition(cursor);
	var pressedShift = GameUI.IsShiftDown();
	var bMessageShown = false;

	return CONTINUE_PROCESSING_EVENT;
}

function OnLeftPressed()
{
	var iPlayerID = Players.GetLocalPlayer();
	var selectedEntities = Players.GetSelectedEntities( iPlayerID );
	var mainSelected = Players.GetLocalPlayerPortraitUnit();
	var mainSelectedName = Entities.GetUnitName(mainSelected);
	var targetIndex = Entities.GetCursorEntity();
	var cursor = GameUI.GetCursorPosition();
	var worldPosition = GameUI.GetScreenWorldPosition(cursor);
	var pressedShift = GameUI.IsShiftDown();
	var bMessageShown = false;

	return CONTINUE_PROCESSING_EVENT;
}

GameUI.SetMouseCallback(function(eventName, arg)
{
	if (GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE)
	{
		return CONTINUE_PROCESSING_EVENT;
	}

	// Left-click
	if (arg == 0)
	{
		if (eventName == "pressed" || eventName == "doublepressed")
		{
			return OnLeftPressed();
		}
	}
	// Right-click
	if (arg == 1)
	{
		if (eventName == "pressed" || eventName == "doublepressed")
		{
			return OnRightPressed();
		}
	}

	if (eventName === "pressed")
	{
		// Left-click
		if ( arg === 0 )
		{
		}


		// Middle-click
		if ( arg === 2 )
		{
		}
	}

	// if (eventName === "wheeled")
	// {
	// }

	// if (eventName === "doublepressed")
	// {
	// }
	return CONTINUE_PROCESSING_EVENT;
});
