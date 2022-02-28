class LWCE_XGAbilityTree extends XGAbilityTree;

simulated function BuildAbilities()
{
    super.BuildAbilities();

    `LWCE_MOD_LOADER.OnAbilitiesBuilt(m_arrAbilities);
}

simulated event GetVolume(XGAbility_Targeted kAbility, out TVolume kVolume)
{
    if (!AbilityHasEffect(kAbility.iType, eEffect_Volume) && kAbility.iType != eAbility_Rift)
    {
        return;
    }

    switch (kAbility.GetType())
    {
        case eAbility_SmokeGrenade:
            if (kAbility.m_kUnit.GetCharacter().HasUpgrade(ePerk_CombatDrugs))
            {
                kVolume = `BATTLE.m_kVolumeMgr.GetTVolume(eVolume_CombatDrugs);
            }
            else
            {
                kVolume = `BATTLE.m_kVolumeMgr.GetTVolume(eVolume_Smoke);
            }

            kVolume.fRadius = kAbility.m_kWeapon.GetDamageRadius();

            if (kAbility.m_kUnit.GetCharacter().HasUpgrade(ePerk_CombatDrugs))
            {
                kVolume.fRadius *= class'LWCE_XGTacticalGameCore'.default.fCombatDrugsRadiusMultiplier;
            }

            break;
        case eAbility_Torch:
            kVolume = `BATTLE.m_kVolumeMgr.GetTVolume(eVolume_Fire);
            break;
        case eAbility_Overwatch:
            kVolume = `BATTLE.m_kVolumeMgr.GetTVolume(eVolume_Suppression);
            break;
        case eAbility_BattleScanner:
            kVolume = `BATTLE.m_kVolumeMgr.GetTVolume(eVolume_Spy);
            break;
        case eAbility_GasGrenade:
        case eAbility_Plague:
            kVolume = `BATTLE.m_kVolumeMgr.GetTVolume(eVolume_Poison);
            kVolume.fRadius = kAbility.m_kWeapon.GetDamageRadius();
            break;
        case eAbility_Rift:
            kVolume = `BATTLE.m_kVolumeMgr.GetTVolume(eVolume_Rift);
            break;
        case eAbility_TelekineticField:
            kVolume = `BATTLE.m_kVolumeMgr.GetTVolume(eVolume_Telekinetic);
            break;
        default:
            break;
    }
}

simulated function bool HasAutopsyTechForChar(int iCharType)
{
    local LWCE_XGDropshipCargoInfo kCargo;
    local LWCE_TTech kTech;

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

    kCargo = LWCE_XGDropshipCargoInfo(`BATTLE.m_kDesc.m_kDropShipCargoInfo);

    if (kCargo == none)
    {
        `LWCE_LOG_CLS("ERROR: could not find LWCE_XGDropshipCargoInfo in the current battle! Falling back on native HasAutopsyTechForChar.");
        return super.HasAutopsyTechForChar(iCharType);
    }

    foreach kCargo.m_arrCETechHistory(kTech)
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
            kAbilityClass = class'LWCE_XGAbility_BullRush';
            break;
        case eAbility_ClusterBomb:
            kAbilityClass = class'LWCE_XGAbility_ClusterBomb';
            break;
        case eAbility_DisablingShot:
            kAbilityClass = class'LWCE_XGAbility_DisablingShot';
            break;
        case eAbility_FlashBang:
            kAbilityClass = class'LWCE_XGAbility_Flashbang';
            break;
        case eAbility_Fly:
            kAbilityClass = class'LWCE_XGAbility_Fly';
            break;
        case eAbility_FlyUp:
            kAbilityClass = class'LWCE_XGAbility_Ascend';
            break;
        case eAbility_FlyDown:
            kAbilityClass = class'LWCE_XGAbility_Descend';
            break;
        case eAbility_Grapple:
            kAbilityClass = class'LWCE_XGAbility_Grapple';
            break;
        case eAbility_GhostGrenade:
            kAbilityClass = class'LWCE_XGAbility_GhostGrenade';
            break;
        case eAbility_Launch:
            kAbilityClass = class'LWCE_XGAbility_Launch';
            break;
        case eAbility_MEC_ElectroPulse:
            kAbilityClass = class'LWCE_XGAbility_Electropulse';
            break;
        case eAbility_MEC_KineticStrike:
            kAbilityClass = class'LWCE_XGAbility_KineticStrike';
            break;
        case eAbility_MEC_OneForAll:
            kAbilityClass = class'LWCE_XGAbility_OneForAll';
            break;
        case eAbility_MEC_RestorativeMist:
            kAbilityClass = class'LWCE_XGAbility_RestorativeMist';
            break;
        case eAbility_Move:
            kAbilityClass = class'LWCE_XGAbility_Move';
            break;
        case eAbility_PsiInspiration:
            kAbilityClass = class'LWCE_XGAbility_PsiInspiration';
            break;
        case eAbility_RapidFire:
            kAbilityClass = class'LWCE_XGAbility_RapidFire';
            break;
        case eAbility_Rift:
            kAbilityClass = class'LWCE_XGAbility_Rift';
            break;
        case eAbility_ShredderRocket:
            kAbilityClass = class'LWCE_XGAbility_ShredderRocket';
            break;
        default:
            kAbilityClass = class'LWCE_XGAbility_GameCore';
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
        kAbilityTargeted.ShotInit(iAbility, arrTargets, kWeapon, bReactionFire);
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
