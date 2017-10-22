purchase_unit = purchase_unit or class({})

function purchase_unit:CastFilterResultLocation(vLocation)
	if IsServer() then
		local iPlayerPosition = self:GetCaster():GetPlayerPosition()
		if iPlayerPosition == nil or not Region:IsPositionInPlacementRegion(vLocation, iPlayerPosition) then
			self.error = "error_invalid_location"
			return UF_FAIL_CUSTOM
		end
	else
		return UF_SUCCESS
	end
end

function purchase_unit:GetCustomCastErrorLocation(vLocation)
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
	local vLocation = self:GetCursorPosition()

	local sUnitType = self.poor[RandomInt(1, #self.poor)]
	print(sUnitType)
	local list = UnitTree:GetListByUnitType(sUnitType)
	if list then
		local sUnitName = list[RandomInt(1, #list)]

		local hNewUnit = CreateUnitByName(sUnitName, vLocation, true, nil, nil, hCaster:GetTeam())
		hNewUnit:SetOwner(hCaster)
		hNewUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), false)
	end
end