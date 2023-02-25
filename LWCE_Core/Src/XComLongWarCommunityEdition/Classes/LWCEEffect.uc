class LWCEEffect extends Object
    abstract;

var array<LWCEAbilityCondition> TargetConditions;
var bool bApplyOnHit;
var bool bApplyOnMiss;

function bool IsExplosiveDamage()
{
    return false;
}
