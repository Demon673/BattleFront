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

function Region:GetRegion(iPosition)
	return self.RegionEntities[iPosition]
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