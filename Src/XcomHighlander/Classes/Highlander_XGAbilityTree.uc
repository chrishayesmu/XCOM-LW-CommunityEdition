class Highlander_XGAbilityTree extends XGAbilityTree;

simulated function BuildAbilities()
{
    super.BuildAbilities();

    `HL_MOD_LOADER.OnAbilitiesBuilt(m_arrAbilities);
}

simulated function bool HasAutopsyTechForChar(int iCharType)
{
    local Highlander_XGDropshipCargoInfo kCargo;
    local HL_TTech kTech;

    // Hard-coded character types that don't need to be autopsied
    if (iCharType == eChar_Civilian ||
        iCharType == eChar_Soldier ||
        iCharType == eChar_Tank ||
        iCharType == eChar_Zombie ||
        iCharType == eChar_Outsider ||
        iCharType == eChar_ExaltOperative ||
        iCharType == eChar_ExaltSniper ||
        iCharType == eChar_ExaltHeavy ||
        iCharType == eChar_ExaltMedic ||
        iCharType == eChar_ExaltEliteOperative ||
        iCharType == eChar_ExaltEliteSniper ||
        iCharType == eChar_ExaltEliteHeavy ||
        iCharType == eChar_ExaltEliteMedic)
    {
        return true;
    }

    kCargo = Highlander_XGDropshipCargoInfo(`BATTLE.m_kDesc.m_kDropShipCargoInfo);

    if (kCargo == none)
    {
        `HL_LOG_CLS("ERROR: could not find Highlander_XGDropshipCargoInfo in the current battle! Falling back on native HasAutopsyTechForChar.");
        return super.HasAutopsyTechForChar(iCharType);
    }

    foreach kCargo.m_arrHLTechHistory(kTech)
    {
        if (kTech.bIsAutopsy && kTech.iSubjectCharacterId == iCharType)
        {
            return true;
        }
    }

    return false;
}

simulated function XGAbility SpawnAbility(int iAbility, XGUnitNativeBase kUnit, array<XGUnit> arrTargets, XGWeapon kWeapon, /* unused */ optional Actor kMiscActor, optional bool bForLocalUseOnly = false, optional bool bReactionFire = false)
{
    local class<XGAbility> kAbilityClass;
    local XGAbility kAbility;

    switch (iAbility)
    {
        case eAbility_BullRush:
            kAbilityClass = class'XGAbility_BullRush';
            break;
        case eAbility_ClusterBomb:
            kAbilityClass = class'XGAbility_ClusterBomb';
            break;
        case eAbility_DisablingShot:
            kAbilityClass = class'XGAbility_DisablingShot';
            break;
        case eAbility_FlashBang:
            kAbilityClass = class'XGAbility_Flashbang';
            break;
        case eAbility_Fly:
            kAbilityClass = class'XGAbility_Fly';
            break;
        case eAbility_FlyUp:
            kAbilityClass = class'XGAbility_Ascend';
            break;
        case eAbility_FlyDown:
            kAbilityClass = class'XGAbility_Descend';
            break;
        case eAbility_Grapple:
            kAbilityClass = class'XGAbility_Grapple';
            break;
        case eAbility_GhostGrenade:
            kAbilityClass = class'XGAbility_GhostGrenade';
            break;
        case eAbility_Launch:
            kAbilityClass = class'XGAbility_Launch';
            break;
        case eAbility_MEC_ElectroPulse:
            kAbilityClass = class'XGAbility_Electropulse';
            break;
        case eAbility_MEC_KineticStrike:
            kAbilityClass = class'XGAbility_KineticStrike';
            break;
        case eAbility_MEC_RestorativeMist:
            kAbilityClass = class'XGAbility_RestorativeMist';
            break;
        case eAbility_Move:
            kAbilityClass = class'XGAbility_Move';
            break;
        case eAbility_PrecisionShot:
            kAbilityClass = class'XGAbility_PrecisionShot';
            break;
        case eAbility_PsiInspiration:
            kAbilityClass = class'XGAbility_PsiInspiration';
            break;
        case eAbility_RapidFire:
            kAbilityClass = class'XGAbility_RapidFire';
            break;
        case eAbility_Rift:
            kAbilityClass = class'XGAbility_Rift';
            break;
        case eAbility_ShredderRocket:
            kAbilityClass = class'XGAbility_ShredderRocket';
            break;
        default:
            kAbilityClass = class'XGAbility';
            break;
    }

    `HL_LOG_CLS("Spawning ability class " $ kAbilityClass $ " for iAbility " $ iAbility);
    kAbility = Spawn(kAbilityClass);

    kAbility.m_kGameCore = `GAMECORE;
    //kAbility.m_kPerkManager = ;
    kAbility.m_kUnit = XGUnit(kUnit);

    if (XGAbility_Targeted(kAbility) != none)
    {
        XGAbility_Targeted(kAbility).m_kWeapon = kWeapon;
    }

    `HL_LOG_CLS("Calling kAbility.Init()");
    kAbility.Init(iAbility);
    `HL_LOG_CLS("Init complete");

    return kAbility;
}
