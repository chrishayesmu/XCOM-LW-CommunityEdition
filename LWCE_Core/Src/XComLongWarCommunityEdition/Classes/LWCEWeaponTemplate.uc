class LWCEWeaponTemplate extends LWCEEquipmentTemplate;

enum ERangeCalculationMethod
{
    eRCM_HeightIncreases, // Use the range specified in the template, plus height bonuses. Default for all guns
    eRCM_Static,          // Always use the range specified in the template
    eRCM_Grenade,         // Use the range specified in the template, modified by grenade-specific perks, and reduced by debuffs
    eRCM_Rocket,          // Use the range specified in the template, modified by rocket-specific perks, and reduced by debuffs
};

struct LWCE_ProjectileTrailFxConfig
{
    var string FxPath;
    var int iOnlyForAbility;
    var int iOnlyWithPerk;
    var bool bIsHeatAmmo;
    var bool bIsHeatRocket;
    var bool bIsReaperRounds;
    var bool bIsShredderRocket;
};

var config name nmWeaponCategory;

var config int iDamage;

var config int iEnvironmentDamage;

var config int iRadius;

var config int iRange; // Range of the weapon, in meters.

var config int iReactionRange;

var config array<name> arrProperties;         // Properties of the weapon; LWCE uses the values from EWeaponProperty, but the array uses names so that
                                              // mods can define custom properties if they wish.

var config string strSkeletalMesh;            // Asset path for the skeletal mesh of this weapon, if any.

var config string strWeaponPanelImageData;    // Path and sizing info for the image to use in the weapon panel (bottom right of tactical HUD) for this weapon.
                                              // Only primary and secondary weapons need this set, as others do not appear in the panel. The format to use is
                                              // "image_path|pxWidth|pxHeight", e.g. "gfxTacticalHUD.IC_HeavyPlasma|87.15|39.3"

var config ELocation eEquipLocation;

var config ERangeCalculationMethod eRangeCalculationType;

var config string strPerkHUDIcon;             // Name of the icon to use for this item in the perk HUD. Items which don't have this set will not
                                              // appear in the perk list. Currently this must be a fixed list which is hard-coded in the Flash movie.

var config array<name> arrProjectileTrailFx;  // Note: all weapons can apply tracer beam FX without configuration.

var array<LWCEEffect> BonusWeaponEffects;     // Effects which are applied by single target attacks with this weapon, in addition to the ability's normal effects.



var const localized string strPerkHUDSummary; // A brief description of the item, shown when hovering over the perk list during battle. Items which don't have this set will not
                                              // appear in the perk list.

var array< delegate<CalcBonusWeaponDamage> > arrBonusWeaponDamageFn;

delegate float CalcBonusWeaponDamage(LWCE_XGUnit kSource, LWCE_XGUnit kTarget, LWCE_XGAbility kAbility);

function bool HasProperty(name PropertyName)
{
    return arrProperties.Find(PropertyName) != INDEX_NONE;
}

function int CalcAoERange(LWCE_XGUnit kUnit, optional int iBaseRange = 0)
{
    local int iFinalRange, iNumRangeReducingEffects;

    if (iBaseRange == 0)
    {
        iBaseRange = `METERSTOUNITS(iRange);
    }

    iFinalRange = iBaseRange;

    // TODO: move lots of this to config
    if (DataName == 'Item_BattleScanner' && kUnit.HasPerk(`LW_PERK_ID(BattleScanner)))
    {
        // This is two steps in the original, preserved here for rounding purposes
        iFinalRange *= 1.4;
        iFinalRange *= 1.2;
    }
    else if (eRangeCalculationType == eRCM_Grenade)
    {
        if (kUnit.HasPerk(`LW_PERK_ID(Bombard)))
        {
            iFinalRange *= 1.40;
        }

        if (kUnit.HasPerk(`LW_PERK_ID(Grenadier)))
        {
            iFinalRange *= 1.20;
        }
    }
    else if (eRangeCalculationType == eRCM_Rocket)
    {
        if (kUnit.HasPerk(`LW_PERK_ID(JavelinRockets)))
        {
            iFinalRange *= 1.25;
        }

        if (kUnit.m_iMovesActionsPerformed > 0)
        {
            iFinalRange *= kUnit.HasPerk(`LW_PERK_ID(SnapShot)) ? 0.6f : 0.4f;;
        }
    }

    // Count up how many effects are reducing the unit's AoE range
    iNumRangeReducingEffects = 0;

    if (kUnit.IsBeingSuppressed())
    {
        iNumRangeReducingEffects++;
    }

    if (kUnit.IsPoisoned())
    {
        iNumRangeReducingEffects++;
    }

    if (kUnit.IsAffectedByAbility(eAbility_FlashBang))
    {
        iNumRangeReducingEffects++;
    }

    if (kUnit.IsAffectedByAbility(eAbility_Mindfray))
    {
        iNumRangeReducingEffects++;
    }

    if (kUnit.m_bWasJustStrangling)
    {
        iNumRangeReducingEffects++;
    }

    iFinalRange = iFinalRange / (iNumRangeReducingEffects + 1);

    if (`GAMECORE.IsOptionEnabled(`LW_SECOND_WAVE_ID(RedFog)))
    {
        if (kUnit.m_iBWAimPenalty < 0)
        {
            iFinalRange *= (1.0f + (kUnit.m_iBWAimPenalty / 100.0f));
        }
    }

    return iFinalRange;
}

/// <summary>
/// Calculates the range modifier to hit chance based on the distance between
/// the shooter and the target.
/// </summary>
function int CalcRangeMod(LWCE_XGUnit kShooter, LWCE_XGUnit kTarget)
{
    return CalcRangeModAtLocation(kShooter, kTarget, kShooter.GetLocation());
}

function int CalcRangeModAtLocation(LWCE_XGUnit kShooter, LWCE_XGUnit kTarget, Vector vShooterLocation)
{
    local float fDist, fOverDistance;
    local int iRangeMod;

    if (kTarget == none)
    {
        return 0;
    }

    if (HasProperty('Melee'))
    {
        return 0;
    }

    fDist = VSize(vShooterLocation - kTarget.GetLocation()) / 64.0f;

    if (HasProperty('Assault'))
    {
        iRangeMod = `LWCE_TACCFG(ASSAULT_AIM_CLIMB) * (`LWCE_TACCFG(CLOSE_RANGE) - fDist);

        if (iRangeMod < `LWCE_TACCFG(ASSAULT_LONG_RANGE_MAX_PENALTY))
        {
            iRangeMod = `LWCE_TACCFG(ASSAULT_LONG_RANGE_MAX_PENALTY);
        }
    }
    else if (HasProperty('Sniper'))
    {
        if (fDist < `LWCE_TACCFG(CLOSE_RANGE))
        {
            iRangeMod = `LWCE_TACCFG(SNIPER_AIM_FALL) * (`LWCE_TACCFG(CLOSE_RANGE) - fDist);
        }
    }
    else if (fDist < class'LWCE_XGTacticalGameCore'.default.CLOSE_RANGE)
    {
        iRangeMod = `LWCE_TACCFG(AIM_CLIMB) * (`LWCE_TACCFG(CLOSE_RANGE) - fDist);
    }

    // Range penalties for pistols are calculated differently, but bonuses are not
    if (HasProperty('Pistol'))
    {
        // With Ranger: negate the range penalty
        if (iRangeMod < 0 && kShooter.HasPerk(`LW_PERK_ID(Ranger)))
        {
            iRangeMod = 0;
        }
        else
        {
            // Calculate the range penalty by our logic and replace the calculated range mod if a penalty applies
            fOverDistance = fDist - (`LWCE_TACCFG(fPistolMaxEffectiveRange) / 64.0f);

            if (fOverDistance > 0.0f)
            {
                iRangeMod = int(fOverDistance * `LWCE_TACCFG(fPistolAimPenaltyPerMeter));
            }
        }
    }

    // TODO: implement LWCE version of reaper rounds check
    //if (iRangeMod < 0 && kViewer.HasReaperRoundsForWeapon(iWeapon))
    //{
    //    iRangeMod *= 2;
    //}

    return iRangeMod;
}

function bool CanBeReflected(LWCE_XGUnit kShooter, LWCE_XGUnit kTarget)
{
    return !HasProperty('ReflectImmunity');
}

function eWeaponRangeCat GetWeaponCatRange()
{
    if (iRange > 30)
    {
        return eWRC_Long;
    }

    if (iReactionRange < 30)
    {
        return eWRC_Short;
    }

    return eWRC_Medium;
}

function bool HasWeaponProperty(EWeaponProperty eProp)
{
    local name PropertyName;

    switch (eProp)
    {
        case eWP_Secondary:
            PropertyName = 'Secondary';
            break;
        case eWP_Pistol:
            PropertyName = 'Pistol';
            break;
        case eWP_AnyClass:
            PropertyName = 'AnyClass';
            break;
        case eWP_Support:
            PropertyName = 'Support';
            break;
        case eWP_Rifle:
            PropertyName = 'Rifle';
            break;
        case eWP_Assault:
            PropertyName = 'Assault';
            break;
        case eWP_Sniper:
            PropertyName = 'Sniper';
            break;
        case eWP_Heavy:
            PropertyName = 'Heavy';
            break;
        case eWP_Explosive:
            PropertyName = 'Explosive';
            break;
        case eWP_UnlimitedAmmo:
            PropertyName = 'UnlimitedAmmo';
            break;
        case eWP_Overheats:
            PropertyName = 'Overheats';
            break;
        case eWP_Psionic:
            PropertyName = 'Psionic';
            break;
        case eWP_Melee:
            PropertyName = 'Melee';
            break;
        case eWP_Integrated:
            PropertyName = 'Integrated';
            break;
        case eWP_Encumber:
            PropertyName = 'Encumber';
            break;
        case eWP_MoveLimited:
            PropertyName = 'MoveLimited';
            break;
        case eWP_Backpack:
            PropertyName = 'Backpack';
            break;
        case eWP_NoReload:
            PropertyName = 'NoReload';
            break;
        case eWP_CantReact:
            PropertyName = 'CantReact';
            break;
        case eWP_Mec:
            PropertyName = 'Mec';
            break;
    }

    return HasProperty(PropertyName);
}

function bool IsAccessory()
{
    return iSize == 0 && !IsDamaging();
}

function bool IsDamaging()
{
    return iDamage > 0;
}

function bool IsLarge()
{
    return iSize >= 1;
}

function bool IsPrimaryWeapon()
{
    return iSize >= 1 && !HasProperty('Backpack') && !HasProperty('Pistol') && !HasProperty('Secondary');
}

function bool IsSmall()
{
    return iSize <= 0;
}

function bool IsSmallItem()
{
    return IsSmall() && !HasProperty('Pistol');
}

function bool IsWeapon()
{
    return true;
}

function bool UsesProjectileTrailFx(name FxName)
{
    return arrProjectileTrailFx.Find(FxName) != INDEX_NONE;
}