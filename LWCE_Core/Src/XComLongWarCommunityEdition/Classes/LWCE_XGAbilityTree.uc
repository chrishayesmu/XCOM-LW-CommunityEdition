class LWCE_XGAbilityTree extends XGAbilityTree;

static function name AbilityNameFromBaseId(int iAbilityId)
{
    switch (iAbilityId)
    {
        case eAbility_Move:
            return 'Move';
        case eAbility_Fly:
            return 'Fly';
        case eAbility_FlyUp:
            return 'Ascend';
        case eAbility_FlyDown:
            return 'Descend';
        case eAbility_Launch:
            return 'Launch';
        case eAbility_Grapple:
            return 'Grapple';
        case eAbility_ShotStandard:
            return 'StandardShot';
        case eAbility_RapidFire:
            return 'RapidFire';
        case eAbility_ShotStun:
            return 'Stun';
        case eAbility_ShotDroneHack:
            return 'HackDrone';
        case eAbility_ShotOverload:
            return 'Overload';
        case eAbility_ShotFlush:
            return 'Flush';
        case eAbility_ShotSuppress:
            return 'Suppression';
        case eAbility_ShotDamageCover:
            return 'PsychokineticStrike';
        case eAbility_FlashBang:
            return 'FlashbangGrenade';
        case eAbility_FragGrenade:
            return 'HEGrenade';
        case eAbility_SmokeGrenade:
            return 'SmokeGrenade';
        case eAbility_AlienGrenade:
            return 'AlienGrenade';
        case eAbility_RocketLauncher:
            return 'FireRocket';
        case eAbility_Aim:
            return 'SteadyWeapon';
        case eAbility_Intimidate:
            return 'Intimidate';
        case eAbility_Overwatch:
            return 'Overwatch';
        case eAbility_Torch:
            return 'Pyrokinesis';
        case eAbility_Plague:
            return 'AcidSpit';
        case eAbility_Stabilize:
            return 'Stabilize';
        case eAbility_Revive:
            return 'Revive';
        case eAbility_TakeCover:
            return 'HunkerDown';
        case eAbility_Ghost:
            return 'Ghost';
        case eAbility_MedikitHeal:
            return 'MedikitHeal';
        case eAbility_RepairSHIV:
            return 'RepairSHIV';
        case eAbility_CombatStim:
            return 'CombatStim';
        case eAbility_EquipWeapon:
            return 'EquipWeapon';
        case eAbility_Reload:
            return 'Reload';
        case eAbility_MindMerge:
            return 'MindMerge';
        case eAbility_PsiLance:
            return 'PsiLance';
        case eAbility_PsiBoltII:
            return 'TODO';
        case eAbility_PsiBomb:
            return 'TODO';
        case eAbility_GreaterMindMerge:
            return 'GreaterMindMerge';
        case eAbility_PsiControl: // TODO: see if we can consolidate this with Mind Control
            return 'PsiControl';
        case eAbility_PsiPanic:
            return 'PsiPanic';
        case eAbility_WarCry:
            return 'Command';
        case eAbility_Berserk:
            return 'TODO';
        case eAbility_ReanimateAlly:
            return 'TODO';
        case eAbility_ReanimateEnemy:
            return 'TODO';
        case eAbility_PsiDrain:
            return 'PsiDrain';
        case eAbility_PsiBless:
            return 'TODO';
        case eAbility_DoubleTap:
            return 'DoubleTap';
        case eAbility_PrecisionShot:
            return 'PrecisionShot';
        case eAbility_DisablingShot:
            return 'DisablingShot';
        case eAbility_SquadSight:
            return 'Squadsight';
        case eAbility_TooCloseForComfort:
            return 'MotionTracker';
        case eAbility_ShredderRocket:
            return 'ShredderRocket';
        case eAbility_ShotMayhem: // TODO consolidate with suppression?
            return 'MayhemSuppression';
        case eAbility_RunAndGun:
            return 'RunAndGun';
        case eAbility_BullRush:
            return 'BullRush';
        case eAbility_BattleScanner:
            return 'BattleScanner';
        case eAbility_Mindfray:
            return 'Mindfray';
        case eAbility_Rift:
            return 'Rift';
        case eAbility_TelekineticField:
            return 'TelekineticField';
        case eAbility_MindControl:
            return 'MindControl';
        case eAbility_PsiInspiration:
            return 'PsiInspiration';
        case eAbility_CloseCyberdisc:
            return 'CloseCyberdisc';
        case eAbility_DeathBlossom:
            return 'DeathBlossom';
        case eAbility_CannonFire:
            return 'CannonFire';
        case eAbility_ClusterBomb:
            return 'ClusterBomb';
        case eAbility_DestroyTerrain:
            return 'TODO';
        case eAbility_PsiInspired:
            return 'TODO';
        case eAbility_Repair:
            return 'Repair';
        case eAbility_HeatWave:
            return 'TODO';
        case eAbility_CivilianCover:
            return 'HeadDown';
        case eAbility_Bloodlust:
            return 'TODO';
        case eAbility_BloodCall:
            return 'BloodCall';
        case eAbility_MimeticSkin:
            return 'Concealment';
        case eAbility_AdrenalNeurosympathy:
            return 'AdrenalNeurosympathy';
        case eAbility_MimicBeacon:
            return 'MimicBeacon';
        case eAbility_GasGrenade:
            return 'ChemGrenade';
        case eAbility_GhostGrenade:
            return 'ShadowDevice';
        case eAbility_GhostGrenadeStealth:
            return 'ShadowDeviceStealth';
        case eAbility_NeedleGrenade:
            return 'APGrenade';
        case eAbility_MEC_Flamethrower:
            return 'Flamethrower';
        case eAbility_MEC_KineticStrike:
            return 'KineticStrike';
        case eAbility_MEC_ProximityMine:
            return 'ProximityMine';
        case eAbility_JetbootModule:
            return 'JetbootModule';
        case eAbility_MEC_Barrage:
            return 'CollateralDamage';
        case eAbility_MEC_OneForAll:
            return 'OneForAll';
        case eAbility_MEC_GrenadeLauncher:
            return 'GrenadeLauncher';
        case eAbility_MEC_RestorativeMist:
            return 'RestorativeMist';
        case eAbility_MEC_ElectroPulse:
            return 'ElectroPulse';
        case eAbility_MEC_RestorativeMistHealing:
            return 'RestorativeMistHealing';
        case eAbility_Strangle:
            return 'Strangle';
        case eAbility_Stealth:
            return 'Stealth';
        case eAbility_ActivateStealthMP:
            return 'TODO';
        case eAbility_DeactivateStealthMP:
            return 'TODO';
        case eAbility_PsiReflect:
            return 'PsiReflect';
    }

    return '';
}

static function int AbilityBaseIdFromName(name AbilityName)
{
    switch (AbilityName)
    {
        case 'Move':
            return eAbility_Move;
        case 'Fly':
            return eAbility_Fly;
        case 'Ascend':
            return eAbility_FlyUp;
        case 'Descend':
            return eAbility_FlyDown;
        case 'Launch':
            return eAbility_Launch;
        case 'Grapple':
            return eAbility_Grapple;
        case 'StandardShot':
            return eAbility_ShotStandard;
        case 'RapidFire':
            return eAbility_RapidFire;
        case 'Stun':
            return eAbility_ShotStun;
        case 'HackDrone':
            return eAbility_ShotDroneHack;
        case 'Overload':
            return eAbility_ShotOverload;
        case 'Flush':
            return eAbility_ShotFlush;
        case 'Suppression':
            return eAbility_ShotSuppress;
        case 'PsychokineticStrike':
            return eAbility_ShotDamageCover;
        case 'FlashbangGrenade':
            return eAbility_FlashBang;
        case 'HEGrenade':
            return eAbility_FragGrenade;
        case 'SmokeGrenade':
            return eAbility_SmokeGrenade;
        case 'AlienGrenade':
            return eAbility_AlienGrenade;
        case 'FireRocket':
            return eAbility_RocketLauncher;
        case 'SteadyWeapon':
            return eAbility_Aim;
        case 'Intimidate':
            return eAbility_Intimidate;
        case 'Overwatch':
            return eAbility_Overwatch;
        case 'Pyrokinesis':
            return eAbility_Torch;
        case 'AcidSpit':
            return eAbility_Plague;
        case 'Stabilize':
            return eAbility_Stabilize;
        case 'Revive':
            return eAbility_Revive;
        case 'HunkerDown':
            return eAbility_TakeCover;
        case 'Ghost':
            return eAbility_Ghost;
        case 'MedikitHeal':
            return eAbility_MedikitHeal;
        case 'RepairSHIV':
            return eAbility_RepairSHIV;
        case 'CombatStim':
            return eAbility_CombatStim;
        case 'EquipWeapon':
            return eAbility_EquipWeapon;
        case 'Reload':
            return eAbility_Reload;
        case 'MindMerge':
            return eAbility_MindMerge;
        case 'PsiLance':
            return eAbility_PsiLance;
        case 'TODO':
            return eAbility_PsiBoltII;
        case 'TODO':
            return eAbility_PsiBomb;
        case 'GreaterMindMerge':
            return eAbility_GreaterMindMerge;
        case 'PsiControl':
            return eAbility_PsiControl; // TODO: see if we can consolidate this with Mind Contro;
        case 'PsiPanic':
            return eAbility_PsiPanic;
        case 'Command':
            return eAbility_WarCry;
        case 'TODO':
            return eAbility_Berserk;
        case 'TODO':
            return eAbility_ReanimateAlly;
        case 'TODO':
            return eAbility_ReanimateEnemy;
        case 'PsiDrain':
            return eAbility_PsiDrain;
        case 'TODO':
            return eAbility_PsiBless;
        case 'DoubleTap':
            return eAbility_DoubleTap;
        case 'PrecisionShot':
            return eAbility_PrecisionShot;
        case 'DisablingShot':
            return eAbility_DisablingShot;
        case 'Squadsight':
            return eAbility_SquadSight;
        case 'MotionTracker':
            return eAbility_TooCloseForComfort;
        case 'ShredderRocket':
            return eAbility_ShredderRocket;
        case 'MayhemSuppression':
            return eAbility_ShotMayhem; // TODO consolidate with suppression?
        case 'RunAndGun':
            return eAbility_RunAndGun;
        case 'BullRush':
            return eAbility_BullRush;
        case 'BattleScanner':
            return eAbility_BattleScanner;
        case 'Mindfray':
            return eAbility_Mindfray;
        case 'Rift':
            return eAbility_Rift;
        case 'TelekineticField':
            return eAbility_TelekineticField;
        case 'MindControl':
            return eAbility_MindControl;
        case 'PsiInspiration':
            return eAbility_PsiInspiration;
        case 'CloseCyberdisc':
            return eAbility_CloseCyberdisc;
        case 'DeathBlossom':
            return eAbility_DeathBlossom;
        case 'CannonFire':
            return eAbility_CannonFire;
        case 'ClusterBomb':
            return eAbility_ClusterBomb;
        case 'TODO':
            return eAbility_DestroyTerrain;
        case 'TODO':
            return eAbility_PsiInspired;
        case 'Repair':
            return eAbility_Repair;
        case 'TODO':
            return eAbility_HeatWave;
        case 'HeadDown':
            return eAbility_CivilianCover;
        case 'TODO':
            return eAbility_Bloodlust;
        case 'BloodCall':
            return eAbility_BloodCall;
        case 'Concealment':
            return eAbility_MimeticSkin;
        case 'AdrenalNeurosympathy':
            return eAbility_AdrenalNeurosympathy;
        case 'MimicBeacon':
            return eAbility_MimicBeacon;
        case 'ChemGrenade':
            return eAbility_GasGrenade;
        case 'ShadowDevice':
            return eAbility_GhostGrenade;
        case 'ShadowDeviceStealth':
            return eAbility_GhostGrenadeStealth;
        case 'APGrenade':
            return eAbility_NeedleGrenade;
        case 'Flamethrower':
            return eAbility_MEC_Flamethrower;
        case 'KineticStrike':
            return eAbility_MEC_KineticStrike;
        case 'ProximityMine':
            return eAbility_MEC_ProximityMine;
        case 'JetbootModule':
            return eAbility_JetbootModule;
        case 'CollateralDamage':
            return eAbility_MEC_Barrage;
        case 'OneForAll':
            return eAbility_MEC_OneForAll;
        case 'GrenadeLauncher':
            return eAbility_MEC_GrenadeLauncher;
        case 'RestorativeMist':
            return eAbility_MEC_RestorativeMist;
        case 'ElectroPulse':
            return eAbility_MEC_ElectroPulse;
        case 'RestorativeMistHealing':
            return eAbility_MEC_RestorativeMistHealing;
        case 'Strangle':
            return eAbility_Strangle;
        case 'Stealth':
            return eAbility_Stealth;
        case 'TODO':
            return eAbility_ActivateStealthMP;
        case 'TODO':
            return eAbility_DeactivateStealthMP;
        case 'PsiReflect':
            return eAbility_PsiReflect;
    }

    return eAbility_None;
}

function ApplyActionCost(XGAbility_Targeted kAbility)
{
    local int iCost;

    if (kAbility.HasProperty(eProp_FireWeapon) || kAbility.GetType() == eAbility_Ghost || kAbility.GetType() == eAbility_MEC_RestorativeMist)
    {
        if (kAbility.m_kWeapon != none)
        {
            iCost = `LWCE_GAMECORE.LWCE_GetOverheatIncrement(LWCE_XGWeapon(kAbility.m_kWeapon).m_TemplateName, kAbility.GetType(), LWCE_XGUnit(kAbility.m_kUnit).m_kCEChar, kAbility.m_bReactionFire);
        }

        if (kAbility.GetType() == eAbility_FragGrenade)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetFragGrenades(kAbility.m_kUnit.GetFragGrenades() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_AlienGrenade)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetAlienGrenades(kAbility.m_kUnit.GetAlienGrenades() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_MEC_GrenadeLauncher)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetFragGrenades(kAbility.m_kUnit.GetFragGrenades() - 1);
                kAbility.m_kUnit.SetAlienGrenades(kAbility.m_kUnit.GetAlienGrenades() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_MedikitHeal || kAbility.GetType() == eAbility_Revive || kAbility.GetType() == eAbility_Stabilize || kAbility.GetType() == eAbility_MEC_RestorativeMist)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetMediKitCharges(kAbility.m_kUnit.GetMediKitCharges() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_ShredderRocket)
        {
            kAbility.m_kUnit.SetShredderRockets(kAbility.m_kUnit.GetShredderRockets() - 1);
            kAbility.m_kUnit.m_iCovertOpKills += 1;
            kAbility.m_kUnit.m_aInventoryStats[eStat_Mobility] += 1;
        }
        else if (kAbility.GetType() == eAbility_RocketLauncher)
        {
            kAbility.m_kUnit.SetRockets(kAbility.m_kUnit.GetRockets() - 1);
            kAbility.m_kUnit.m_iCovertOpKills += 1;
            kAbility.m_kUnit.m_aInventoryStats[eStat_Mobility] += 1;
        }
        else if (kAbility.GetType() == eAbility_Ghost)
        {
            kAbility.m_kUnit.SetGhostCharges(kAbility.m_kUnit.GetGhostCharges() - 1);
        }

        if (kAbility.m_kWeapon != none && kAbility.m_kWeapon.IsA('XGWeapon_ArcThrower'))
        {
            kAbility.m_kUnit.SetArcThrowerCharges(kAbility.m_kUnit.GetArcThrowerCharges() - 1);
        }

        if (kAbility.GetType() == eAbility_SmokeGrenade)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetSmokeGrenadeCharges(kAbility.m_kUnit.GetSmokeGrenadeCharges() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_BattleScanner)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetBattleScannerCharges(kAbility.m_kUnit.GetBattleScannerCharges() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_MimicBeacon)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetMimicBeaconCharges(kAbility.m_kUnit.GetMimicBeaconCharges() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_GasGrenade)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetGasGrenades(kAbility.m_kUnit.GetGasGrenades() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_GhostGrenade)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetGhostGrenades(kAbility.m_kUnit.GetGhostGrenades() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_FlashBang)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetFlashBangs(kAbility.m_kUnit.GetFlashBangs() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_NeedleGrenade)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetNeedleGrenades(kAbility.m_kUnit.GetNeedleGrenades() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_MEC_ProximityMine)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetProximityMines(kAbility.m_kUnit.GetProximityMines() - 1);
            }
        }
        else if (kAbility.GetType() == eAbility_MEC_Flamethrower)
        {
            if (!kAbility.m_kUnit.m_bInfiniteGrenades)
            {
                kAbility.m_kUnit.SetFlamethrowerCharges(kAbility.m_kUnit.GetFlamethrowerCharges() - 1);
            }
        }

        if (kAbility.m_kWeapon != none)
        {
            kAbility.GraduatedOdds(iCost, none, (kAbility.m_kUnit.GetCharacter().m_kChar.aUpgrades[123] & 2) > 0);
        }
    }

    if (kAbility.GetType() == /* Command */ 41)
    {
        kAbility.m_kUnit.SetFlamethrowerCharges(kAbility.m_kUnit.GetFlamethrowerCharges() - 1);
    }

    if (kAbility.GetType() == /* Motion Tracker */ 51)
    {
        kAbility.m_kUnit.SetProximityMines(kAbility.m_kUnit.GetProximityMines() - 1);
    }
}

simulated function BuildAbilities()
{
    super.BuildAbilities();

    `LWCE_MOD_LOADER.OnAbilitiesBuilt(m_arrAbilities);
}

simulated event GetVolume(XGAbility_Targeted kAbility, out TVolume kVolume)
{
    local LWCE_XGUnit kUnit;

    if (!AbilityHasEffect(kAbility.iType, eEffect_Volume) && kAbility.iType != eAbility_Rift)
    {
        return;
    }

    kUnit = LWCE_XGUnit(kAbility.m_kUnit);

    switch (kAbility.GetType())
    {
        case eAbility_SmokeGrenade:
            if (kUnit.HasPerk(ePerk_CombatDrugs))
            {
                kVolume = `BATTLE.m_kVolumeMgr.GetTVolume(eVolume_CombatDrugs);
            }
            else
            {
                kVolume = `BATTLE.m_kVolumeMgr.GetTVolume(eVolume_Smoke);
            }

            kVolume.fRadius = kAbility.m_kWeapon.GetDamageRadius();

            if (kUnit.HasPerk(ePerk_CombatDrugs))
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
    local name TechName;
    local LWCE_XGDropshipCargoInfo kCargo;
    local LWCETechTemplate kTech;

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

    foreach kCargo.m_arrCETechHistory(TechName)
    {
        kTech = `LWCE_TECH(TechName);

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
