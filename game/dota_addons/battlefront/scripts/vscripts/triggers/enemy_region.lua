function OnStartTouch(keys)
	-- outputid     number
	-- caller       entity
	-- activator    entity
	local hUnit = keys.activator
	local iPosition = hUnit:GetPosition()
	
	if iPosition ~= nil and Round:GetPhase() <= Round.CONSTANT.ROUND_PHASE_PRE_BATTLE then
		local hOffensiveRegion = Region:GetOffensiveRegion(iPosition)
		if hOffensiveRegion == keys.caller then
			local hPlacementRegion = Region:GetPlacementRegion(iPosition)
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