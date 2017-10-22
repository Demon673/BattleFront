modifier_hero = modifier_hero or class({})

function modifier_hero:IsHidden()
    return true
end
function modifier_hero:IsPurgable()
    return false
end
function modifier_hero:IsPurgeException()
    return false
end
function modifier_hero:IsPermanent()
    return true
end
function modifier_hero:RemoveOnDeath()
    return false
end
function modifier_hero:CheckState()
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_ROOTED] = true,
    }
end
function modifier_hero:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_DISABLE_TURNING,
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
    }
end
function modifier_hero:GetModifierDisableTurning(keys)
    return 1
end
function modifier_hero:GetModifierIgnoreCastAngle(keys)
    return 1
end