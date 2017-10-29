(function(){
	var offsetX = null;
	var offsetY = null;
	var Draggable = false;
	var DragPanel = null;
	function DragCallback()
	{
		var isLeftPressed = GameUI.IsMouseDown(0);
		if (isLeftPressed)
		{
			if (offsetX == null && offsetY == null)
			{
				offsetX = DragPanel.GetPositionWithinWindow().x - (GameUI.GetCursorPosition())[0];
				offsetY = DragPanel.GetPositionWithinWindow().y - (GameUI.GetCursorPosition())[1];
			}
			DragPanel.style.marginLeft = "0px";
			DragPanel.style.marginTop = "0px";
			DragPanel.style.marginRight = "0px";
			DragPanel.style.marginBottom = "0px";
			DragPanel.style.horizontalAlign = "left";
			DragPanel.style.verticalAlign = "top";
			DragPanel.style.x = GameUI.CorrectPositionValue((GameUI.GetCursorPosition())[0] + offsetX) + "px";
			DragPanel.style.y = GameUI.CorrectPositionValue((GameUI.GetCursorPosition())[1] + offsetY) + "px";
		}
		else
		{
			offsetX = null;
			offsetY = null;
		}
		if (Draggable || isLeftPressed)
		{
			$.Schedule(0, DragCallback);
		}
		else
		{
			DragPanel = null;
		}
	}
	GameUI.CustomUIConfig().StartDrag = function(panel)
	{
		Draggable = true;
		DragPanel = panel;
		$.Schedule(0, DragCallback);
	}
	GameUI.CustomUIConfig().EndDrag = function()
	{
		Draggable = false;
	}

	GameEvents.Subscribe("emit_sound", function(keys)
	{
		if (keys.SoundName)
		{
			Game.EmitSound(keys.SoundName);
		}
	});
})();