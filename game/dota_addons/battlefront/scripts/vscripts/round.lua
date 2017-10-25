if Round == nil then
	Round = class({})
	Round.CONSTANT = {
		ROUND_PHASE_INIT = 0,
		ROUND_PHASE_DEPLOYMENT  = 1,
		ROUND_PHASE_PRE_BATTLE = 2,
		ROUND_PHASE_IN_BATTLE = 3,
		ROUND_PHASE_FINISHED_BATTLE = 4,

		ROUND_DEPLOYMENT_TIME = 30,
		ROUND_PRE_TIME = 5,
	}
	Round.Phase = Round.CONSTANT.ROUND_PHASE_INIT
	Round.EndTime = 0
	Round.Units = {}
	Round.BarrierWall = {}
end

function Round:Init()
	for iTeam, iPosition in pairs(GameRules.TeamPosition) do
		if iTeam ~= "MAX_POSITION" then
			local hRegion = Region:GetRegion(iPosition)
			if hRegion then
				local vOrigin = hRegion:GetOrigin()
				local vLeft = hRegion:GetOrigin()
				vLeft.x = vLeft.x + hRegion:GetBoundingMins().x
				local vRight = hRegion:GetOrigin()
				vRight.x = vRight.x + hRegion:GetBoundingMaxs().x

				local iParticleID = ParticleManager:CreateParticle("particles/round/barrier_wall.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(iParticleID, 0, vLeft)
				ParticleManager:SetParticleControl(iParticleID, 1, vRight)

				local obstructions = {}
				for i = vLeft.x+32, vRight.x-32, 64 do
					local ent = SpawnEntityFromTableSynchronous("point_simple_obstruction", {origin = Vector(i, vOrigin.y, vOrigin.z)})
					table.insert(obstructions, ent)
				end

				self.BarrierWall[iPosition] = 
				{
					iParticleID = iParticleID,
					obstructions = obstructions
				}
			end
		end
	end
	GameRules:GetGameModeEntity():SetContextThink("Round",
		function()
			if self:GetPhase() == self.CONSTANT.ROUND_PHASE_DEPLOYMENT then

			end
			return 0
		end
	, 0)
	CustomNetTables:SetTableValue("Game", "Round", 
		{
			Phase = self.Phase,
			CONSTANT = self.CONSTANT,
		}
	)
end

function Round:NextPhase()
	--初始化回合系统阶段
	if self.Phase == self.CONSTANT.ROUND_PHASE_INIT then
		self.Phase = self.CONSTANT.ROUND_PHASE_DEPLOYMENT
	--部署阶段
	elseif self.Phase == self.CONSTANT.ROUND_PHASE_DEPLOYMENT then
		self.Phase = self.CONSTANT.ROUND_PHASE_PRE_BATTLE
	--准备战斗阶段
	elseif self.Phase == self.CONSTANT.ROUND_PHASE_PRE_BATTLE then
		self.Phase = self.CONSTANT.ROUND_PHASE_IN_BATTLE
	--战斗阶段
	elseif self.Phase == self.CONSTANT.ROUND_PHASE_IN_BATTLE then
		self.Phase = self.CONSTANT.ROUND_PHASE_FINISHED_BATTLE
	--结束战斗阶段
	elseif self.Phase == self.CONSTANT.ROUND_PHASE_FINISHED_BATTLE then
		self.Phase = self.CONSTANT.ROUND_PHASE_DEPLOYMENT
	end
end

function Round:GetPhase()
	return self.Phase
end