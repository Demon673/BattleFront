GameUI.GetComposeTable = function()
{
	return ComposeTable.concat();
}
GameUI.GetComposeData = function(itemname)
{
	for (var i = 0; i < ComposeTable.length; i++)
	{
		if (ComposeTable[i]["composeItem"] === itemname)
		{
			return ComposeTable[i];
		}
	}
}




var ComposeTable = 
[{"ID":1,"tech":0,"composeItem":"item_axe","requestItem":[{"itemname":"item_twig","count":2}],"classification":"tools"},{"ID":2,"tech":0,"composeItem":"item_chest_lumber","requestItem":[{"itemname":"item_axe","count":1},{"itemname":"item_twig","count":1}],"classification":"structures"},{"ID":3,"tech":0,"composeItem":"item_twig","requestItem":[{"itemname":"item_branches","count":1}],"classification":"tools"}]

