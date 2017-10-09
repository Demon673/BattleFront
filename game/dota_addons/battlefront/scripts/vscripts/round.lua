if Round == nil then
	Round = class({})
	Round.constant = {
		ROUND_PHASE_INIT = 0,
		ROUND_PHASE_DEPLOYMENT  = 1,
		ROUND_PHASE_PRE_BATTLE = 2,
		ROUND_PHASE_IN_BATTLE = 3,
		ROUND_PHASE_FINISHED_BATTLE = 4,
		
		ROUND_PRE_TIME = 60,
		ROUND_PRE_TIME = 60,
	}
	Round.Phase = 0
	Round.Units = {}
end

function Round:Init()
	GameRules:GetGameModeEntity():SetContextThink("Round",
		function()
			return 0
		end
	, 0)
end

function Round:NextPhase()
	if self.Phase >= ROUND_PHASE_FINISHED_BATTLE then
		self.Phase = ROUND_PHASE_DEPLOYMENT
	else
		self.Phase = self.Phase + 1
	end
end

function Round:GetPhase()
	return self.Phase
end