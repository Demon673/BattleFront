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
	Round._Phase = Round.CONSTANT.ROUND_PHASE_INIT
	Round._EndTime = 0
	Round._BarrierWall = {}
	Round._UnitDatas = {}
end

--BarrierWall
function Round:_BuildBarrierWall()
	for iTeam, iPosition in pairs(GameRules.TeamPosition) do
		if iTeam ~= "MAX_POSITION" then
			local hRegion = Region:GetRegion(iPosition)
			if hRegion ~= nil and self._BarrierWall[iPosition] == nil then
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

				self._BarrierWall[iPosition] =
				{
					iParticleID = iParticleID,
					obstructions = obstructions
				}
			end
		end
	end
end
function Round:_DestroyBarrierWall()
	for iTeam, iPosition in pairs(GameRules.TeamPosition) do
		if iTeam ~= "MAX_POSITION" then
			if self._BarrierWall[iPosition] ~= nil then
				ParticleManager:DestroyParticle(self._BarrierWall[iPosition].iParticleID, false)

				for i, ent in pairs(self._BarrierWall[iPosition].obstructions) do
					ent:RemoveSelf()
				end

				self._BarrierWall[iPosition] = nil
			end
		end
	end
end

function Round:NextPhase()
	--初始化回合系统阶段
	if self._Phase == self.CONSTANT.ROUND_PHASE_INIT then
		self._Phase = self.CONSTANT.ROUND_PHASE_DEPLOYMENT
		self:_Deploy()
		self:_UpdateNetTable()
	--部署阶段->准备战斗阶段
	elseif self._Phase == self.CONSTANT.ROUND_PHASE_DEPLOYMENT then
		self._Phase = self.CONSTANT.ROUND_PHASE_PRE_BATTLE
		self:_PrepareBattle()
		self:_UpdateNetTable()
	--准备战斗阶段->战斗阶段
	elseif self._Phase == self.CONSTANT.ROUND_PHASE_PRE_BATTLE then
		self._Phase = self.CONSTANT.ROUND_PHASE_IN_BATTLE
		self:_StartBattle()
		self:_UpdateNetTable()
	--战斗阶段->结束战斗阶段
	elseif self._Phase == self.CONSTANT.ROUND_PHASE_IN_BATTLE then
		self._Phase = self.CONSTANT.ROUND_PHASE_FINISHED_BATTLE
		self:_EndBattle()
		self:_UpdateNetTable()
	--结束战斗阶段->部署阶段
	elseif self._Phase == self.CONSTANT.ROUND_PHASE_FINISHED_BATTLE then
		self._Phase = self.CONSTANT.ROUND_PHASE_DEPLOYMENT
		self:_Deploy()
		self:_UpdateNetTable()
	end
end

function Round:GetPhase()
	return self._Phase
end

function Round:_Deploy()
	self._EndTime = GameRules:GetGameTime() + self.CONSTANT.ROUND_DEPLOYMENT_TIME

	self:_BuildBarrierWall()

	for iTeam, iPosition in pairs(GameRules.TeamPosition) do
		if iTeam ~= "MAX_POSITION" then
			local hPlacementRegion = Region:GetPlacementRegion(iPosition)
			local vPlacementRegionOrigion = hPlacementRegion:GetOrigin()

			local defenseUnits = Unit:GetDefenseUnits(iTeam)
			for i, hDefenseUnitEntIndex in pairs(defenseUnits) do
				local hDefenseUnit = EntIndexToHScript(hDefenseUnitEntIndex)
				local data = self._UnitDatas[hDefenseUnitEntIndex]
				if data ~= nil then
					if hDefenseUnit ~= nil and hDefenseUnit:IsAlive() then
						hDefenseUnit:Heal(hDefenseUnit:GetMaxHealth(), hDefenseUnit)
						FindClearSpaceForUnit(hDefenseUnit, data.origin, false)
					else
						hDefenseUnit = CreateUnitByName(data.name, data.origin, true, nil, nil, iTeam)
						hDefenseUnit:SetOwner(data.owner)

						defenseUnits[i] = hDefenseUnit:entindex()
					end
		
					hDefenseUnit:SetControllableByPlayer(hDefenseUnit:GetPlayerOwnerID(), false)
					hDefenseUnit:SetForwardVector(data.forward)
				end
			end

			local offensiveUnits = Unit:GetOffensiveUnits(iTeam)
			for i, hOffensiveUnitEntIndex in pairs(offensiveUnits) do
				local hOffensiveUnit = EntIndexToHScript(hOffensiveUnitEntIndex)
				if hOffensiveUnit ~= nil and hOffensiveUnit:IsAlive() then
					hOffensiveUnit:ForceKill(false)
				end
			end
			Unit:ClearOffensiveUnit(iTeam)
		end
	end
end

function Round:_PrepareBattle()
	self._EndTime = GameRules:GetGameTime() + self.CONSTANT.ROUND_PRE_TIME

	self:_DestroyBarrierWall()

	for iTeam, iPosition in pairs(GameRules.TeamPosition) do
		if iTeam ~= "MAX_POSITION" then
			local hRegion = Region:GetRegion(iPosition)
			local vRegionOrigion = hRegion:GetOrigin()
			local hPlacementRegion = Region:GetPlacementRegion(iPosition)
			local vPlacementRegionOrigion = hPlacementRegion:GetOrigin()
			local hOffensiveRegion = Region:GetOffensiveRegion(iPosition)
			local vOffensiveRegionOrigion = hOffensiveRegion:GetOrigin()

			--创建进攻单位
			-- if PlayerResource:GetPlayerCountForTeam(iTeam) > 0 then
				local iEnemyTeam = GetEnemyTeam(iPosition)
				if iEnemyTeam ~= nil then
					local iEnemyPosition = GameRules.TeamPosition[iEnemyTeam]
					local hEnemyRegion = Region:GetRegion(iEnemyPosition)
					local vEnemyRegionOrigion = hEnemyRegion:GetOrigin()
					local enemyDefenseUnits = Unit:GetDefenseUnits(iEnemyTeam)
					for i, hEnemyDefenseUnitEntIndex in pairs(enemyDefenseUnits) do
						local hEnemyDefenseUnit = EntIndexToHScript(hEnemyDefenseUnitEntIndex)
						local vEnemyDefenseUnitOrigion = hEnemyDefenseUnit:GetOrigin()
						vEnemyDefenseUnitOrigion.x = 2*vEnemyRegionOrigion.x - vEnemyDefenseUnitOrigion.x
						vEnemyDefenseUnitOrigion.y = 2*vEnemyRegionOrigion.y - vEnemyDefenseUnitOrigion.y
						local vEnemyOffensiveOrigion = vEnemyDefenseUnitOrigion - vEnemyRegionOrigion + vRegionOrigion

						local hEnemyOffensiveUnit = CreateUnitByName(hEnemyDefenseUnit:GetUnitName(), vEnemyOffensiveOrigion, true, nil, nil, iEnemyTeam)
						hEnemyOffensiveUnit:SetOwner(hEnemyDefenseUnit:GetOwner())
						hEnemyOffensiveUnit:SetForwardVector(Vector(0,-1,0))

						Unit:AddOffensiveUnit(hEnemyOffensiveUnit)

						hEnemyOffensiveUnit:AddNewModifier(hEnemyOffensiveUnit, nil, "modifier_unit_pause", nil)

						hEnemyOffensiveUnit:SetContextThink(DoUniqueString("Order"),
							function()
								ExecuteOrderFromTable(
									{
										UnitIndex = hEnemyOffensiveUnit:entindex(),
										OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
										Position = vPlacementRegionOrigion,
									}
								)
							end
						, 0)
					end
				end
			-- end

			--处理防守单位
			local defenseUnits = Unit:GetDefenseUnits(iTeam)
			for i, hDefenseUnitEntIndex in pairs(defenseUnits) do
				local hDefenseUnit = EntIndexToHScript(hDefenseUnitEntIndex)
				self._UnitDatas[hDefenseUnitEntIndex] = 
				{
					name = hDefenseUnit:GetUnitName(),
					origin = hDefenseUnit:GetOrigin(),
					forward = hDefenseUnit:GetForwardVector(),
					owner = hDefenseUnit:GetOwner(),
				}

				hDefenseUnit:SetForwardVector(Vector(0,1,0))

				hDefenseUnit:SetControllableByPlayer(-1, false)

				hDefenseUnit:AddNewModifier(hDefenseUnit, nil, "modifier_unit_pause", nil)

				ExecuteOrderFromTable(
					{
						UnitIndex = hDefenseUnit:entindex(),
						OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
						Position = vOffensiveRegionOrigion,
					}
				)
			end
		end
	end
end

function Round:_StartBattle()
	self._EndTime = GameRules:GetGameTime() + 999999

	for iTeam, iPosition in pairs(GameRules.TeamPosition) do
		if iTeam ~= "MAX_POSITION" then
			local defenseUnits = Unit:GetDefenseUnits(iTeam)
			for i, hDefenseUnitEntIndex in pairs(defenseUnits) do
				local hDefenseUnit = EntIndexToHScript(hDefenseUnitEntIndex)
				hDefenseUnit:RemoveModifierByName("modifier_unit_pause")
			end

			local offensiveUnits = Unit:GetOffensiveUnits(iTeam)
			for i, hOffensiveUnitEntIndex in pairs(offensiveUnits) do
				local hOffensiveUnit = EntIndexToHScript(hOffensiveUnitEntIndex)
				hOffensiveUnit:RemoveModifierByName("modifier_unit_pause")
			end
		end
	end
end

function Round:_EndBattle()
	self._EndTime = GameRules:GetGameTime() + 10

	for iTeam, iPosition in pairs(GameRules.TeamPosition) do
		if iTeam ~= "MAX_POSITION" then			
			local nOffensiveUnits = 0 --对下家造成伤害的单位数量
			local nEnemyOffensiveUnits = 0 --受到上家造成伤害的单位数量

			local offensiveUnits = Unit:GetOffensiveUnits(iTeam)
			for i, hOffensiveUnitEntIndex in pairs(offensiveUnits) do
				local hOffensiveUnit = EntIndexToHScript(hOffensiveUnitEntIndex)
				if hOffensiveUnit ~= nil and hOffensiveUnit:IsAlive() then
					nOffensiveUnits = nOffensiveUnits + 1
				end
			end

			local iEnemyTeam = GetEnemyTeam(iPosition)
			if iEnemyTeam ~= nil then
				local enemyOffensiveUnits = Unit:GetOffensiveUnits(iEnemyTeam)
				for i, hEnemyOffensiveUnitEntIndex in pairs(enemyOffensiveUnits) do
					local hEnemyOffensiveUnit = EntIndexToHScript(hEnemyOffensiveUnitEntIndex)
					if hEnemyOffensiveUnit ~= nil and hEnemyOffensiveUnit:IsAlive() then
						nEnemyOffensiveUnits = nEnemyOffensiveUnits + 1
					end
				end
			end
		end
	end
end

function Round:Init()
	self._EndTime = GameRules:GetGameTime() + 5

	Round:_BuildBarrierWall()

	GameRules:GetGameModeEntity():SetContextThink("Round",
		function()
			local now = GameRules:GetGameTime()
			if now < self._EndTime then
				return 0
			end
			if self:GetPhase() == self.CONSTANT.ROUND_PHASE_INIT then
				self:NextPhase()
				return 0
			end
			if self:GetPhase() == self.CONSTANT.ROUND_PHASE_DEPLOYMENT then
				self:NextPhase()
				return 0
			end
			if self:GetPhase() == self.CONSTANT.ROUND_PHASE_PRE_BATTLE then
				self:NextPhase()
				return 0
			end
			if self:GetPhase() == self.CONSTANT.ROUND_PHASE_IN_BATTLE then
				self:NextPhase()
				return 0
			end
			if self:GetPhase() == self.CONSTANT.ROUND_PHASE_FINISHED_BATTLE then
				self:NextPhase()
				return 0
			end
			return 0
		end
	, 0)
	self:_UpdateNetTable()
end

function Round:CheckBattleUnits()
	for iTeam, iPosition in pairs(GameRules.TeamPosition) do
		if iTeam ~= "MAX_POSITION" then
			local bAllUnitsIsDead = true
			local bAllEnemiesIsDead = true

			local defenseUnits = Unit:GetDefenseUnits(iTeam)
			for i, hDefenseUnitEntIndex in pairs(defenseUnits) do
				local hDefenseUnit = EntIndexToHScript(hDefenseUnitEntIndex)
				if hDefenseUnit ~= nil and hDefenseUnit:IsAlive() then
					bAllUnitsIsDead = false
					break
				end
			end

			local iEnemyTeam = GetEnemyTeam(iPosition)
			if iEnemyTeam ~= nil then
				local enemyOffensiveUnits = Unit:GetOffensiveUnits(iEnemyTeam)
				for i, hEnemyOffensiveUnitEntIndex in pairs(enemyOffensiveUnits) do
					local hEnemyOffensiveUnit = EntIndexToHScript(hEnemyOffensiveUnitEntIndex)
					if hEnemyOffensiveUnit ~= nil and hEnemyOffensiveUnit:IsAlive() then
						bAllEnemiesIsDead = false
						break
					end
				end
			end

			if not (bAllUnitsIsDead or bAllEnemiesIsDead) then
				return false
			end
		end
	end

	self._EndTime = 0
	return true
end

function Round:_UpdateNetTable()
	CustomNetTables:SetTableValue("Game", "Round",
		{
			Phase = self._Phase,
			EndTime = self._EndTime,
			CONSTANT = self.CONSTANT,
		}
	)
end