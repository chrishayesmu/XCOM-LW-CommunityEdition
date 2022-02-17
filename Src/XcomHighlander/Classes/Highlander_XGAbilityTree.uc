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
    local XGAbility_Targeted kAbilityTargeted;

    // Pick the ability class. Note that there is an XGAbility_PrecisionShot class, but it
    // isn't used in the native version of this function.
    switch (iAbility)
    {
        case eAbility_BullRush:
            kAbilityClass = class'Highlander_XGAbility_BullRush';
            break;
        case eAbility_ClusterBomb:
            kAbilityClass = class'Highlander_XGAbility_ClusterBomb';
            break;
        case eAbility_DisablingShot:
            kAbilityClass = class'Highlander_XGAbility_DisablingShot';
            break;
        case eAbility_FlashBang:
            kAbilityClass = class'Highlander_XGAbility_Flashbang';
            break;
        case eAbility_Fly:
            kAbilityClass = class'Highlander_XGAbility_Fly';
            break;
        case eAbility_FlyUp:
            kAbilityClass = class'Highlander_XGAbility_Ascend';
            break;
        case eAbility_FlyDown:
            kAbilityClass = class'Highlander_XGAbility_Descend';
            break;
        case eAbility_Grapple:
            kAbilityClass = class'Highlander_XGAbility_Grapple';
            break;
        case eAbility_GhostGrenade:
            kAbilityClass = class'Highlander_XGAbility_GhostGrenade';
            break;
        case eAbility_Launch:
            kAbilityClass = class'Highlander_XGAbility_Launch';
            break;
        case eAbility_MEC_ElectroPulse:
            kAbilityClass = class'Highlander_XGAbility_Electropulse';
            break;
        case eAbility_MEC_KineticStrike:
            kAbilityClass = class'Highlander_XGAbility_KineticStrike';
            break;
        case eAbility_MEC_OneForAll:
            kAbilityClass = class'Highlander_XGAbility_OneForAll';
            break;
        case eAbility_MEC_RestorativeMist:
            kAbilityClass = class'Highlander_XGAbility_RestorativeMist';
            break;
        case eAbility_Move:
            kAbilityClass = class'Highlander_XGAbility_Move';
            break;
        case eAbility_PsiInspiration:
            kAbilityClass = class'Highlander_XGAbility_PsiInspiration';
            break;
        case eAbility_RapidFire:
            kAbilityClass = class'Highlander_XGAbility_RapidFire';
            break;
        case eAbility_Rift:
            kAbilityClass = class'Highlander_XGAbility_Rift';
            break;
        case eAbility_ShredderRocket:
            kAbilityClass = class'Highlander_XGAbility_ShredderRocket';
            break;
        default:
            kAbilityClass = class'Highlander_XGAbility_GameCore';
            break;
    }

    kAbility = Spawn(kAbilityClass, kUnit);

    // Not sure why this check is in the native code, but it is
    if (iAbility == eAbility_BullRush && kWeapon == none)
    {
        kWeapon = XGWeapon(kUnit.m_kInventory.m_arrStructSlots[kUnit.m_kInventory.m_ActiveWeaponLoc].m_arrItems[0]);
    }

    kAbilityTargeted = XGAbility_Targeted(kAbility);

    if (kAbilityTargeted != none)
    {
        kAbilityTargeted.ShotInit(iAbility, arrTargets, kWeapon, /* bReactionFire */ false);
    }
    else
    {
        kAbility.Init(iAbility);
    }

    if (bForLocalUseOnly)
    {
        kAbility.RemoteRole = ROLE_None;
        kAbility.m_iAbilityID = -1;
    }

    if (kAbility.Role == ROLE_Authority)
    {
        kAbility.m_bCachedAvailable = kAbility.InternalCheckAvailable();
        kAbility.bNetDirty = true;
        kAbility.bForceNetUpdate = true;
    }

    kAbility.m_kInitialReplicationData_XGAbility.m_bAvailable = kAbility.m_bCachedAvailable;

    return kAbility;
}
