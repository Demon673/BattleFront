var self = $("#Timer");
var Phase;
var EndTime;
var CONSTANT;

function UpdateGameRound(tableName, keyName, table)
{
	if (keyName == "Round")
	{
		Phase = table.Phase;
		EndTime = table.EndTime;
		CONSTANT = table.CONSTANT;

		self.SetHasClass("ROUND_PHASE_INIT", Phase == CONSTANT.ROUND_PHASE_INIT);
		self.SetHasClass("ROUND_PHASE_DEPLOYMENT", Phase == CONSTANT.ROUND_PHASE_DEPLOYMENT);
		self.SetHasClass("ROUND_PHASE_PRE_BATTLE", Phase == CONSTANT.ROUND_PHASE_PRE_BATTLE);
		self.SetHasClass("ROUND_PHASE_IN_BATTLE", Phase == CONSTANT.ROUND_PHASE_IN_BATTLE);
		self.SetHasClass("ROUND_PHASE_FINISHED_BATTLE", Phase == CONSTANT.ROUND_PHASE_FINISHED_BATTLE);
		
		Update();
	}
}

function Update()
{
	$.Schedule(0, Update);

	var nowTime = Game.GetGameTime();
	var countdown = Math.ceil(EndTime - Game.GetGameTime());
	self.SetDialogVariableInt("countdown", countdown);
}

(function()
{
	UpdateGameRound("Game", "Round", CustomNetTables.GetTableValue("Game", "Round"));
	CustomNetTables.SubscribeNetTableListener("Game", UpdateGameRound);
	
	Update();
})();