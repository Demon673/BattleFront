function OnStartTouch(keys)
	-- outputid     number
	-- caller       entity
	-- activator    entity
	local hUnit = keys.activator
	local iPlayerPosition = hUnit:GetPlayerPosition()
	
	if iPlayerPosition ~= nil then
		local hEnemyRegion = Region:GetEnemyRegion(iPlayerPosition)
		if hEnemyRegion == keys.caller then
			local hPlacementRegion = Region:GetPlacementRegion(iPlayerPosition)
			if hPlacementRegion ~= nil then
				FindClearSpaceForUnit(hUnit, hPlacementRegion:GetOrigin(), false) 
			end
		end
	end
end

function OnEndTouch(keys)
	-- outputid     number
	-- caller       entity
	-- activator    entity
end