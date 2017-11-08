purchase_unit = purchase_unit or class({})

function purchase_unit:CastFilterResult()
	if IsServer() then
		if Round:GetPhase() ~= Round.CONSTANT.ROUND_PHASE_DEPLOYMENT then
			self.error = "error_only_during_deployment_phase_can_do_this"
			return UF_FAIL_CUSTOM
		end
	else
		return UF_SUCCESS
	end
end

function purchase_unit:GetCustomCastError()
	return self.error or ""
end

function purchase_unit:OnUpgrade()
	self.poor = {}
	local t = {
		base_level_1 = self:GetSpecialValueFor("base_lv1_weight"),
		base_level_2 = self:GetSpecialValueFor("base_lv2_weight"),
		base_level_3 = self:GetSpecialValueFor("base_lv3_weight"),
		hero_level_1 = self:GetSpecialValueFor("hero_lv1_weight"),
		hero_level_2 = self:GetSpecialValueFor("hero_lv2_weight"),
		hero_level_3 = self:GetSpecialValueFor("hero_lv3_weight"),
	}

	for sUnitType, iWeight in pairs(t) do
		for i = #self.poor+1, #self.poor+iWeight do
			self.poor[i] = sUnitType
		end
	end
end

function purchase_unit:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPosition = hCaster:GetTeamPosition()
	local hPlacementRegion = Region:GetPlacementRegion(iPosition)
	
	local sUnitType = self.poor[RandomInt(1, #self.poor)]
	local list = UnitTree:GetListByUnitType(sUnitType)
	if list then
		local sUnitName = list[RandomInt(1, #list)]

		local hNewUnit = CreateUnitByName(sUnitName, hPlacementRegion:GetOrigin(), true, nil, nil, hCaster:GetTeam())
		hNewUnit:SetOwner(hCaster)
		hNewUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), false)

		Unit:AddDefenseUnit(hNewUnit)
	end
end