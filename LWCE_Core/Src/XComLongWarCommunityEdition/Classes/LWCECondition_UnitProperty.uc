class LWCECondition_UnitProperty extends LWCECondition;

var bool bExcludeLiving;
var bool bExcludeDead;
var bool bExcludeRobotic;
var bool bExcludeOrganic;
var bool bExcludeCivilian;        // excludes based on character type, not team
var bool bExcludeNonCivilian;     // excludes based on character type, not team
var bool bExcludePanicked;
var bool bExcludePsionic;
var bool bExcludeNonPsionic;
var bool bExcludeNoCover;
var bool bExcludeNoCoverToSource;
var bool bExcludeFullHealth;
var bool bRequireBleedingOut;

var bool bExcludeHostileToSource;
var bool bExcludeFriendlyToSource;
var bool bTreatMindControlledSquadmateAsHostile;
var bool bRequireSquadmates;

function name MeetsCondition(LWCE_XGUnit kSource, LWCE_XGUnit kTarget)
{
    local LWCE_XGCharacter kChar;

    if (kTarget == none)
    {
        kTarget = kSource;
    }

    kChar = kTarget.LWCE_GetCharacter();

    if (bExcludeLiving && kTarget.IsAlive())
    {
        return 'AA_DoesNotMeetCondition_UnitProperty';
    }

    if (bExcludeDead && !kTarget.IsAlive())
    {
        return 'AA_DoesNotMeetCondition_UnitProperty';
    }

    if (bExcludeRobotic && kChar.HasCharacterProperty(eCP_Robotic))
    {
        return 'AA_DoesNotMeetCondition_UnitProperty';
    }

    if (bExcludeOrganic && !kChar.HasCharacterProperty(eCP_Robotic))
    {
        return 'AA_DoesNotMeetCondition_UnitProperty';
    }

    if (bExcludeCivilian && kChar.GetCharacterType() == eChar_Civilian)
    {
        return 'AA_DoesNotMeetCondition_UnitProperty';
    }

    if (bExcludeNonCivilian && kChar.GetCharacterType() != eChar_Civilian)
    {
        return 'AA_DoesNotMeetCondition_UnitProperty';
    }

    // TODO: implement missing conditions
    if (bExcludeHostileToSource && kSource.IsEnemy(kTarget))
    {
        return 'AA_DoesNotMeetCondition_UnitProperty';
    }

    if (bExcludeFriendlyToSource && !kSource.IsEnemy(kTarget))
    {
        return 'AA_DoesNotMeetCondition_UnitProperty';
    }

    if (bRequireSquadmates && kSource.GetTeam() != kTarget.GetTeam())
    {
        return 'AA_DoesNotMeetCondition_UnitProperty';
    }

    return 'AA_Success';
}

defaultproperties
{
    bExcludeDead=true
    bExcludeFriendlyToSource=true
}