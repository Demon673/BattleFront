modifier_unit_pause = modifier_unit_pause or class({})

function modifier_unit_pause:IsHidden()
    return true
end
function modifier_unit_pause:IsPurgable()
    return false
end
function modifier_unit_pause:IsPurgeException()
    return false
end
function modifier_unit_pause:IsPermanent()
    return true
end
function modifier_unit_pause:RemoveOnDeath()
    return false
end
function modifier_unit_pause:CheckState()
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_STUNNED] = true,
    }
end