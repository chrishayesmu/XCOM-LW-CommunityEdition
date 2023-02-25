class LWCEAbilityCondition_Visibility extends LWCEAbilityCondition;

// Visibility from the source unit to targets. If squadsight is not enabled, then the target must be within the source's
// own sight radius; otherwise it must be visible to any unit on the same team as the source unit.

var bool bNoEnemyViewers;          // Condition will fail if the target can be seen by any enemies

var bool bRequireLineOfSight;      // If true, require unobstructed line-of-sight from the source to the target.
var bool bAllowSquadsight;         // If unit has squadsight, they can target any unit in LOS which is visible to an ally
var bool bActAsSquadsight;         // If true, ability acts as though unit has squadsight (regardless of whether they do)

function name MeetsCondition(LWCE_XGUnit kSource, LWCE_XGUnit kTarget)
{
    local bool bHasSquadsight;

    bHasSquadsight = bActAsSquadsight || (bAllowSquadsight && kSource.HasSquadsight());

    if (bRequireLineOfSight && !kSource.CanSee(kTarget, bHasSquadsight))
    {
        return 'AA_Visibility_CannotSee';
    }

    // TODO add more conditions

    return 'AA_Success';
}