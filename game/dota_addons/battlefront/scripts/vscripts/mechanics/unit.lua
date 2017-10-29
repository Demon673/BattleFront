
if Unit == nil then
	Unit = class({})

	Unit.DefenseUnits = {}
	Unit.OffensiveUnits = {}
end

--防守单位
function Unit:AddDefenseUnit(hUnit, iTeam)
	if iTeam == nil then iTeam = hUnit:GetTeam() end

	local iPosition = GameRules.TeamPosition[iTeam]

	hUnit:SetUnitCanRespawn(true)

	if self.DefenseUnits[iPosition] == nil then
		self.DefenseUnits[iPosition] = {}
	end

	table.insert(self.DefenseUnits[iPosition], hUnit:entindex())
end

function Unit:RemoveDefenseUnit(hUnit, iTeam)
	if iTeam == nil then iTeam = hUnit:GetTeam() end
	
	local iPosition = GameRules.TeamPosition[iTeam]

	if self.DefenseUnits[iPosition] == nil then
		self.DefenseUnits[iPosition] = {}
	end

	table.remove_value(self.DefenseUnits[iPosition], hUnit:entindex())
end

function Unit:GetDefenseUnits(iTeam)
	local iPosition = GameRules.TeamPosition[iTeam]

	if self.DefenseUnits[iPosition] == nil then
		self.DefenseUnits[iPosition] = {}
	end

	return self.DefenseUnits[iPosition]
end

--进攻单位
function Unit:AddOffensiveUnit(hUnit, iTeam)
	if iTeam == nil then iTeam = hUnit:GetTeam() end
	
	local iPosition = GameRules.TeamPosition[iTeam]

	if self.OffensiveUnits[iPosition] == nil then
		self.OffensiveUnits[iPosition] = {}
	end

	table.insert(self.OffensiveUnits[iPosition], hUnit:entindex())
end

function Unit:RemoveOffensiveUnit(hUnit, iTeam)
	if iTeam == nil then iTeam = hUnit:GetTeam() end
	
	local iPosition = GameRules.TeamPosition[iTeam]

	if self.OffensiveUnits[iPosition] == nil then
		self.OffensiveUnits[iPosition] = {}
	end

	table.remove_value(self.OffensiveUnits[iPosition], hUnit:entindex())
end

function Unit:GetOffensiveUnits(iTeam)
	local iPosition = GameRules.TeamPosition[iTeam]

	if self.OffensiveUnits[iPosition] == nil then
		self.OffensiveUnits[iPosition] = {}
	end

	return self.OffensiveUnits[iPosition]
end

function Unit:ClearOffensiveUnit(iTeam)
	local iPosition = GameRules.TeamPosition[iTeam]

	self.OffensiveUnits[iPosition] = {}
end