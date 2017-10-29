if Region == nil then
	Region = class({})
	Region.RegionEntities = {}
	Region.PlacementRegionEntities = {}
	Region.OffensiveRegionEntities = {}
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

function Region:GetOffensiveRegion(iPosition)
	return self.OffensiveRegionEntities[iPosition]
end
function Region:IsPositionInOffensiveRegion(vLocation, iPosition)
	local hOffensiveRegion = self:GetOffensiveRegion(iPosition)
	if hOffensiveRegion == nil then return false end

	return hOffensiveRegion:IsPositionInTrigger2D(vLocation)
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
			local hOffensiveRegion = Entities:FindByName(nil, "enemy_region_"..tostring(iPosition))
			if hOffensiveRegion ~= nil then
				self.OffensiveRegionEntities[iPosition] = hOffensiveRegion
			end
		end
	end
end