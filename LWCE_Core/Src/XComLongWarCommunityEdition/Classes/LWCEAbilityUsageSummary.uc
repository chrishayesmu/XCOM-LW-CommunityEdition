/// <summary>
/// Encapsulates information related to a single activation (potential or actual) of an ability. Includes hit
/// and crit chance, possible (and actual) damage, and possible (and actual) damage reduction.
/// </summary>
class LWCEAbilityUsageSummary extends Object;

`define LWCE_LOG_ROLLS(msg, cond) `log(msg, cond, 'LWCE_AbilityRolls')

/// <summary>
/// TODO revise this documentation
/// Contains a modification for an ability (such as its damage or hit chance) and the source of that modification.
/// Whether this is a good or bad mod depends on context; a positive value is good for damage and bad for DR (if you're
/// the one getting shot).
///
/// For many ability modifications, the max and min values are the same; e.g. the soldier's aim stat is a baseline mod that
/// doesn't change within the context of a single ability activation. For other values, the max and min may be different depending
/// on other values, such as Absorption Fields' DR depending on the damage of the hit.
///
/// Supplying a unique Source name is helpful for mod interoperability, but note that the same Source can appear multiple times in
/// the calculation for a single ability activation. It should not be treated as unique in that sense.
/// </summary>
struct LWCE_TAbilityMod
{
    var name Source;
    var string SourceFriendlyName;
    var int iValue;
};

var array<LWCE_TAbilityMod> arrCritChanceModifiers;
var array<LWCE_TAbilityMod> arrHitChanceModifiers;

var int iMaxCritChance;
var int iMinCritChance;
var int iMaxHitChance;
var int iMinHitChance;

var bool bPreventCrit; // If true, this ability can't crit, regardless of its total crit chance. Ignores iMinCritChance.
var bool bPreventHit;  // If true, this ability can't hit, regardless of its total hit chance. Ignores iMinHitChance.
var bool bForceCrit;   // If true, this ability is guaranteed to crit. Overrides bPreventCrit, and ignores iMaxCritChance.
var bool bForceHit;    // If true, this ability is guaranteed to hit. Overrides bPreventHit, and ignores iMaxHitChance.

var protected bool m_bHasRolledOutcome;

var protected LWCE_TAbilityResult m_kResult; // Actual result of using the ability.

function AddCritChanceMod(name Source, string SourceFriendlyName, int iMod)
{
    local LWCE_TAbilityMod kAbilityMod;

    if (iMod == 0)
    {
        return;
    }

    kAbilityMod.Source = Source;
    kAbilityMod.SourceFriendlyName = SourceFriendlyName;
    kAbilityMod.iValue = iMod;

    arrCritChanceModifiers.AddItem(kAbilityMod);
}

function AddHitChanceMod(name Source, string SourceFriendlyName, int iMod)
{
    local LWCE_TAbilityMod kAbilityMod;

    if (iMod == 0)
    {
        return;
    }

    kAbilityMod.Source = Source;
    kAbilityMod.SourceFriendlyName = SourceFriendlyName;
    kAbilityMod.iValue = iMod;

    arrHitChanceModifiers.AddItem(kAbilityMod);
}

function int GetUncappedCritChance()
{
    local int Index, iCritChance;

    if (bForceCrit)
    {
        return 100;
    }

    if (bPreventCrit)
    {
        return 0;
    }

    for (Index = 0; Index < arrCritChanceModifiers.Length; Index++)
    {
        iCritChance += arrCritChanceModifiers[Index].iValue;
    }

    return Clamp(iCritChance, iMinCritChance, iMaxCritChance);
}

function int GetUncappedHitChance()
{
    local int Index, iHitChance;

    if (bForceHit)
    {
        return 100;
    }

    if (bPreventHit)
    {
        return 0;
    }

    for (Index = 0; Index < arrHitChanceModifiers.Length; Index++)
    {
        iHitChance += arrHitChanceModifiers[Index].iValue;
    }

    return Clamp(iHitChance, iMinHitChance, iMaxHitChance);
}

defaultproperties
{
    iMaxCritChance=100
    iMinCritChance=0
    iMaxHitChance=100
    iMinHitChance=0
}