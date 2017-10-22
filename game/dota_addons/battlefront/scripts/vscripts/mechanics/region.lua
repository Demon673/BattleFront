if Region == nil then
	Region = class({})
	Region.RegionEntities = {}
	Region.PlacementRegionEntities = {}
	Region.EnemyRegionEntities = {}
end

function CDOTA_PlayerResource:GetPlayerPosition(iPlayerID)
	return GameRules.TeamPosition[self:GetTeam(iPlayerID)]
end

function CDOTAPlayer:GetPlayerPosition()
	return GameRules.TeamPosition[PlayerResource:GetTeam(self:GetPlayerID())]
end

function CDOTA_BaseNPC:GetPlayerPosition()
	return GameRules.TeamPosition[self:GetTeam()]
end

function Region:GetRegion(iPosition)
	return self.RegionEntities[iPosition]
end
function Region:IsPositionInRegion(vLocation, iPosition)
	local hRegion = self:GetRegion(iPosition)
	if hRegion == nil then return false end

	return hRegion:IsPositionInTrigger2D(vLocation)
end

function Region:GetPlacementRegion(iPosition)
	return self.PlacementRegionEntities[iPosition]
end
function Region:IsPositionInPlacementRegion(vLocation, iPosition)
	local hPlacementRegion = self:GetPlacementRegion(iPosition)
	if hPlacementRegion == nil then return false end

	return hPlacementRegion:IsPositionInTrigger2D(vLocation)
end

function Region:GetEnemyRegion(iPosition)
	return self.EnemyRegionEntities[iPosition]
end
function Region:IsPositionInEnemyRegion(vLocation, iPosition)
	local hEnemyRegion = self:GetEnemyRegion(iPosition)
	if hEnemyRegion == nil then return false end

	return hEnemyRegion:IsPositionInTrigger2D(vLocation)
end

function Region:Init()
	for iTeam, iPosition in pairs(GameRules.TeamPosition) do
		if iTeam ~= "MAX_POSITION" then
			local hRegion = Entities:FindByName(nil, "region_"..tostring(iPosition))
			if hRegion ~= nil then
				self.RegionEntities[iPosition] = hRegion
				-- print(hRegion)
				-- print(hRegion:GetBoundingMins()+hRegion:GetOrigin())
				-- print(hRegion:GetBoundingMaxs()+hRegion:GetOrigin())
				-- print(hRegion:GetCenter())
				-- print(GetGroundPosition(hRegion:GetCenter(), nil))
			end
			local hPlacementRegion = Entities:FindByName(nil, "placement_region_"..tostring(iPosition))
			if hPlacementRegion ~= nil then
				self.PlacementRegionEntities[iPosition] = hPlacementRegion
			end
			local hEnemyRegion = Entities:FindByName(nil, "enemy_region_"..tostring(iPosition))
			if hEnemyRegion ~= nil then
				self.EnemyRegionEntities[iPosition] = hEnemyRegion
			end
		end
	end
end