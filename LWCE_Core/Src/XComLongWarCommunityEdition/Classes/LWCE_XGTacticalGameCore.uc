class LWCE_XGTacticalGameCore extends XGTacticalGameCore
    config(LWCEBaseTacticalGame)
    dependson(LWCETypes);

enum EHitChanceCalcStyle
{
    // 100% chance to hit, no matter what.
    eHCCS_AlwaysHit,

    // Hit chance calculated the same way chances are calculated against civilians in LW 1.0:
    // 100% chance to hit, modified only by suppression (due to a bug).
    eHCCS_CivilianBaseGame,

    // 0% chance to hit, no matter what.
    eHCCS_NeverHit,

    // Normal hit chance calculation
    eHCCS_Normal
};

var config array<LWCE_TWeapon> arrCfgWeapons;

// ----------------------------------------
// Config for tactical game abilities
// ----------------------------------------

var config EHitChanceCalcStyle eCivilianHitChanceCalcStyle;

// Config that mostly impact the player's units, or aliens and XCOM equally
var config float fAbsorptionFieldsActivationThreshold;
var config float fAbsorptionFieldsIncomingDamageMultiplier;
var config float fAcidDRRemovalPercentage;
var config float fAcidMinimumDRRemoved;
var config float fBattleScannerVolumeRadius;
var config float fBullRushRadius;
var config float fCollateralDamageRadius;
var config float fCombatDrugsRadiusMultiplier;
var config float fCombatStimsIncomingDamageMultiplier;
var config float fCombinedArmsDRPenetration;
var config float fDamageControlDRBonus;
var config float fDeathBlossomRadius;
var config float fExecutionerHealthThreshold;
var config float fFireVolumeRadius;
var config float fGaussWeaponsDRPenetration;
var config float fGreenFogAimLossPerTurn;
var config float fGreenFogWillLossPerTurn;
var config float fLowCoverDRBonus;
var config float fHighCoverDRBonus;
var config float fOneForAllDRBonus;
var config float fOverloadRadius;
var config float fIncomingMeleeDamageMultiplierForChitinPlating;
var config float fIncomingMeleeDamageMultiplierForChryssalids;
var config float fMindMergeDRPerWill;
var config float fPistolAimPenaltyPerMeter;
var config float fPistolMaxEffectiveRange;
var config float fPsiInspirationRadius;
var config float fPsiShieldIncomingDamageMultiplier;
var config float fPsychokineticStrikeRadius;
var config float fQuenchgunsDRPenetration;
var config float fReactionFireAimDivisorLargeTarget;
var config float fReactionFireAimMultiplier;
var config float fReactionFireAimMultiplierDashing;
var config float fReactionFireAimMultiplierUnusedLightningReflexes;
var config float fReactionFireAimMultiplierUsedLightningReflexes;
var config float fReactionFireAimMultiplierWithChameleonSuit;
var config float fRiftRadius;
var config float fRocketScatterMultiplierAfterMove;
var config float fRocketScatterMultiplierAfterMoveWithSnapShot;
var config float fSapperEnvironmentalDamageMultiplier;
var config float fShockAbsorbentArmorIncomingDamageMultiplier;
var config float fShockAbsorbentArmorRadius;
var config float fShotgunDRPenalty;
var config float fShredderRocketDamageMultiplier;
var config float fShredderRocketRadiusMultiplier;
var config float fShredderRocketRadiusOverride;
var config float fSuppressionReactionFireCoverPenetration;
var config float fTelekineticFieldRadius;
var config float fWillToSurviveDRBonus;

var config int iAcidVolumeDuration;
var config int iAdrenalNeurosympathyAimBonus;
var config int iAdrenalNeurosympathyCritChanceBonus;
var config int iAdrenalineSurgeAimBonus;
var config int iAdrenalineSurgeCritChanceBonus;
var config int iAggressionCritChanceBonusPerVisibleEnemy;
var config int iAggressionMaximumBonus;
var config int iAlienGrenadesDamageBonusForAPGrenades;
var config int iAlienGrenadesDamageBonusForGrenadeLauncher;
var config int iAutomatedThreatAssessmentDefenseBonus;
var config int iBattleRifleSecondActionAimPenalty;
var config int iBattleScannerVolumeDuration;
var config int iBloodCallAimBonus;
var config int iBodyShieldAimPenalty;
var config int iCatchingBreathAimPenalty;
var config int iCombatDrugsCritChanceBonus;
var config int iCombatDrugsVolumeDuration;
var config int iCombatDrugsWillBonus;
var config int iCombatStimsWillBonus;
var config int iConcealmentCritChanceBonus;
var config int iDamnGoodGroundAimBonus;
var config int iDamnGoodGroundDefenseBonus;
var config int iDeadeyeAimBonus;
var config int iDenseSmokeDefenseBonus;
var config int iDepthPerceptionAimBonus;
var config int iDepthPerceptionCritChanceBonus;
var config int iDisablingShotAimPenalty;
var config int iDisorientedAimPenalty;
var config int iDistortionFieldDefenseBonus;
var config int iEnhancedPlasmaDamageBonus;
var config int iEspritDeCorpsDefenseBonus;
var config int iEspritDeCorpsWillBonus;
var config int iExecutionerAimBonus;
var config int iExecutionerCritChanceBonus;
var config int iFireInTheHoleAimBonusForRockets;
var config int iFireVolumeDuration;
var config int iFlushAimBonus;
var config int iFlyingDefenseBonus;
var config int iGreenFogMaximumAimLoss;
var config int iGreenFogMaximumWillLoss;
var config int iHeightAdvantageAimBonus;
var config int iHoloTargetingAimBonus;
var config int iHyperReactivePupilsAimBonus;
var config int iInTheZoneCritPenaltyPerShot;
var config int iImprovedMedikitHealBonus;
var config int iLoneWolfAimBonus;
var config int iLoneWolfCritChanceBonus;
var config int iMecCloseCombatDamageBonus;
var config int iMayhemDamageBonusForGrenades;
var config int iMayhemDamageBonusForMachineGuns;
var config int iMayhemDamageBonusForProximityMines;
var config int iMayhemDamageBonusForRocketLaunchers;
var config int iMayhemDamageBonusForSniperRifles;
var config int iMayhemDamageBonusForSuppression;
var config int iMindControlHitModifier;
var config int iMindfrayAimPenalty;
var config int iMindfrayHitModifier;
var config int iMindfrayDamage;
var config int iMedikitHealBase;
var config int iNeuralDampingWillBonus;
var config int iPlatformStabilityAimBonus;
var config int iPlatformStabilityAimBonusForRockets;
var config int iPlatformStabilityCritChanceBonus;
var config int iPrecisionShotDamageBonusForBallisticSniper;
var config int iPrecisionShotDamageBonusForGaussSniper;
var config int iPrecisionShotDamageBonusForLaserSniper;
var config int iPrecisionShotDamageBonusForPulseSniper;
var config int iPrecisionShotDamageBonusForPlasmaSniper;
var config int iPsiPanicHitModifier;
var config int iRangerDamageBonusPistol;
var config int iRangerDamageBonusPrimary;
var config int iRapidFireAimPenalty;
var config int iReflexPistolsDamageBonus;
var config int iRepairHealBaseAliens;
var config int iRepairHealBaseXCOM;
var config int iRiftVolumeDuration;
var config int iSapperDamageBonus;
var config int iSaviorHealBonus;
var config int iSemperVigilansDefenseBonus;
var config int iSmartMacrophagesHealBonus;
var config int iSmokeGrenadeDefenseBonus;
var config int iSmokeGrenadeVolumeDuration;
var config int iSnapShotAimPenalty;
var config int iSharpshooterAimBonus;
var config int iSharpshooterCritChanceBonus;
var config int iShredderDebuffDurationFromEnemyGrenade;
var config int iShredderDebuffDurationFromEnemyWeapon;
var config int iShredderDebuffDurationFromPerk;
var config int iShredderDebuffDurationFromRocket;
var config int iShredderDebuffDurationFromSmallItem;
var config int iSquadsightCritChancePenalty;
var config int iSuppressionAimPenalty;
var config int iTacticalSenseDefenseBonusPerVisibleEnemy;
var config int iTacticalSenseMaximumBonus;
var config int iTelekineticFieldDefenseBonus;
var config int iTelekineticFieldVolumeDuration;
var config int iVitalPointTargetingDamageBonusPistol;
var config int iVitalPointTargetingDamageBonusPrimary;

var config LinearColor AreaTargetingFriendliesInRadiusColor;
var config LinearColor AreaTargetingInvalidColor;
var config LinearColor AreaTargetingValidColor;

// Config for enemies
var config LWCE_TRange BullRushAddedDamage;
var config LWCE_TRange DeathBlossomAddedDamage;

// This field is here as a pretty big hack, to get around UnrealScript's lack of constructors. In LWCE_XGWeapon, the
// CreateEntity method is called when the actor is spawned. At that time we need to read the weapon template, but since
// there are no constructors, we don't know which template to use. The base game handles this by having various subclasses
// of XGWeapon that have their item type set as a default property. LWCE handles this by having a field in this class, which
// is set immediately before spawning and can be read from CreateEntity to do initialization.
var name nmItemToCreate;

var private LWCEItemTemplateManager m_kItemTemplateMgr;

static function name LWCE_GetPrimaryWeapon(const LWCE_TInventory kInventory)
{
    local int Index;

    for (Index = 0; Index < kInventory.arrLargeItems.Length; Index++)
    {
        if (kInventory.arrLargeItems[Index] != '')
        {
            return kInventory.arrLargeItems[Index];
        }
    }

    return kInventory.nmPistol;
}

simulated event Init()
{
    `LWCE_LOG_CLS("Init");

    m_kItemTemplateMgr = `LWCE_ITEM_TEMPLATE_MGR;

    // These need to be populated to avoid crashing, since native code accesses them
    m_arrWeapons.Add(255);
    m_arrArmors.Add(255);
    m_arrCharacters.Add(32);

    if (Role == ROLE_Authority)
    {
        m_kAbilities = Spawn(class'LWCE_XGAbilityTree', self);
        m_kAbilities.Init();
    }

    BuildWeapons();
    BuildArmors();
    BuildCharacters();
    m_bInitialized = true;
}

// TODO: macro undefine this function's body when not in dev builds
simulated function BuildArmors()
{
    local int Index;

    for (Index = 0; Index < m_arrWeapons.Length; Index++)
    {
        m_arrArmors[Index].strName = "Armor " $ Index;
        m_arrArmors[Index].iType = Index;
        m_arrArmors[Index].iHPBonus = 100;
        m_arrArmors[Index].iDefenseBonus = 100;
        m_arrArmors[Index].iFlightFuel = 100;
        m_arrArmors[Index].iWillBonus = 100;
        m_arrArmors[Index].iLargeItems = 100;
        m_arrArmors[Index].iSmallItems = 100;
        m_arrArmors[Index].iMobilityBonus = 100;
    }
}

// TODO: macro undefine this function's body when not in dev builds
simulated function BuildWeapons()
{
    local int Index;

    // Set up weapons with a bunch of values that will be immediately obvious if they're
    // being used somewhere important
    for (Index = 0; Index < m_arrWeapons.Length; Index++)
    {
        m_arrWeapons[Index].strName = "Weapon " $ Index;
        m_arrWeapons[Index].iType = Index;
        m_arrWeapons[Index].iDamage = 100;
        m_arrWeapons[Index].iEnvironmentDamage = 100;
        m_arrWeapons[Index].iRange = 100;
        m_arrWeapons[Index].iReactionRange = 100;
        m_arrWeapons[Index].iReactionAngle = 100;
        m_arrWeapons[Index].iCritical = 100;
        m_arrWeapons[Index].iRadius = 100;
        m_arrWeapons[Index].iOffenseBonus = 100;
        m_arrWeapons[Index].iSuppression = 100;
        m_arrWeapons[Index].iSize = 100;
        m_arrWeapons[Index].iHPBonus = 100;
        m_arrWeapons[Index].iWillBonus = 100;
    }
}

simulated function int CalcBaseHitChance(XGUnitNativeBase kShooter, XGUnitNativeBase kTarget, bool bReactionFire)
{
    local int iDefense, iHitChance;

    // TODO: this function should be deprecated and merged into other hit chance calculators
    `LWCE_LOG_CLS("CalcBaseHitChance");

    if (kTarget.m_bVIP) // Probably right, needs confirmation
    {
        if (kTarget.m_kCharacter.m_kChar.iType == eChar_Civilian || kShooter.m_kCharacter.m_kChar.aProperties[eCP_MeleeOnly] != 0)
        {
            return 100;
        }
    }

    iDefense = kTarget.m_aCurrentStats[eStat_Defense];

    if (kTarget.IsInTelekineticField())
    {
        iDefense += iTelekineticFieldDefenseBonus;
    }

    if (kTarget.m_kSquad != none && kTarget.m_kSquad.SquadHasStarOfTerra(/* PowerA */ true))
    {
        iDefense += class'XGTacticalGameCoreNativeBase'.default.TERRA_DEFENSE;
    }

    if (kTarget.IsFlankedBy(kShooter))
    {
        // Remove cover bonuses from target's defense stat
        kTarget.UpdateCoverBonuses(kShooter);

        if (kTarget.IsAffectedByAbility(eAbility_TakeCover)) // Hunker Down
        {
            iDefense -= kTarget.m_iCurrentCoverValue * HUNKER_BONUS;
        }
        else
        {
            iDefense -= kTarget.m_iCurrentCoverValue;
        }
    }

    iHitChance = kShooter.m_aCurrentStats[eStat_Offense] - iDefense;

    if (kShooter.HasHeightAdvantageOver(XGUnit(kTarget)))
    {
        iHitChance += iHeightAdvantageAimBonus;
    }

    if (bReactionFire && kShooter.m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(Opportunist)] == 0 && kShooter.m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(AdvancedFireControl)] == 0)
    {
        if (kTarget.m_bDashing)
        {
            iHitChance *= DASHING_REACTION_MODIFIER;
        }
        else
        {
            iHitChance *= REACTION_PENALTY;
        }
    }

    if (kShooter.IsPoisoned())
    {
        iHitChance -= POISONED_AIM_PENALTY;
    }

    if (kShooter.IsMine())
    {
        // TODO very unclear what the hell is happening in here, or whether any of it matters
    }

    return iHitChance;
}

// This function is reverse-engineered from its native version in XGTacticalGameCoreNativeBase.
// It is unmodified and unused; this version is only kept around to see what the native
// version does. Modifications should go in CalcBaseHitChance.
private simulated function int CalcBaseHitChance_Original(XGUnitNativeBase kShooter, XGUnitNativeBase kTarget, bool bReactionFire)
{
    local int iDefense, iHitChance;

    if (kTarget.m_bVIP) // Probably right, needs confirmation
    {
        if (kTarget.m_kCharacter.m_kChar.iType == eChar_Civilian || kShooter.m_kCharacter.m_kChar.aProperties[eCP_MeleeOnly] != 0)
        {
            return 100;
        }
    }

    iDefense = kTarget.m_aCurrentStats[eStat_Defense];

    if (kTarget.IsInTelekineticField())
    {
        iDefense += 40;
    }

    if (kTarget.m_kSquad != none && kTarget.m_kSquad.SquadHasStarOfTerra(/* PowerA */ true))
    {
        iDefense += class'XGTacticalGameCoreNativeBase'.default.TERRA_DEFENSE;
    }

    if (kTarget.IsFlankedBy(kShooter))
    {
        // Remove cover bonuses from target's defense stat
        kTarget.UpdateCoverBonuses(kShooter);

        if (kTarget.IsAffectedByAbility(eAbility_TakeCover)) // Hunker Down
        {
            iDefense -= kTarget.m_iCurrentCoverValue * HUNKER_BONUS;
        }
        else
        {
            iDefense -= kTarget.m_iCurrentCoverValue;
        }
    }

    iHitChance = kShooter.m_aCurrentStats[eStat_Offense] - iDefense;

    if (kShooter.HasHeightAdvantageOver(XGUnit(kTarget)))
    {
        iHitChance += 20;
    }

    if (bReactionFire && kShooter.m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(Opportunist)] == 0 && kShooter.m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(AdvancedFireControl)] == 0)
    {
        if (kTarget.m_bDashing)
        {
            iHitChance *= DASHING_REACTION_MODIFIER;
        }
        else
        {
            iHitChance *= REACTION_PENALTY;
        }
    }

    if (kShooter.IsPoisoned())
    {
        iHitChance -= POISONED_AIM_PENALTY;
    }

    if (kShooter.IsMine())
    {
        // TODO very unclear what the hell is happening in here, or whether any of it matters
    }

    return iHitChance;
}

function bool CalcCriticallyWounded(XGUnit kUnit, out TCharacter kCharacter, out int aCurrentStats[ECharacterStat], int iDamageAmount, int iRank, bool bIsVolunteer, bool bHasSecondaryHeart, out int iSavedBySecondaryHeart, const out Vector CharLocation, const out ETeam TeamVis)
{
    `LWCE_LOG_DEPRECATED_CLS(CalcCriticallyWounded);

    return false;
}

function bool LWCE_CalcCriticallyWounded(XGUnit kUnit, out LWCE_TCharacter kCharacter, out int aCurrentStats[ECharacterStat], int iDamageAmount, int iRank, bool bIsVolunteer, bool bHasSecondaryHeart, out int iSavedBySecondaryHeart, const out Vector CharLocation, const out ETeam TeamVis)
{
    `LWCE_LOG_NOT_IMPLEMENTED(LWCE_CalcCriticallyWounded);

    return false;
}

simulated function int CalcEnvironmentalDamage(int iWeapon, int iAbility, out TCharacter kCharacter, out int aCurrentStats[ECharacterStat], optional bool bCritical = false, optional bool bHasHeightBonus = false, optional float fDistanceToTarget = 0.0, optional bool bUseFlankBonus = false)
{
    `LWCE_LOG_DEPRECATED_CLS(CalcEnvironmentalDamage);

    return 50000;
}

simulated function int LWCE_CalcEnvironmentalDamage(name WeaponName, int iAbility, out int aCurrentStats[ECharacterStat])
{
    local int iDamage;

    iDamage = `LWCE_WEAPON(WeaponName).iEnvironmentDamage;

    if (iDamage > 0)
    {
        iDamage += 8 * aCurrentStats[eStat_Damage];
    }

    if (iAbility == eAbility_MindMerge)
    {
        iDamage = 0;
    }

    return iDamage;
}

function int CalcOverallDamage(int iWeapon, int iCurrDamageStat, optional bool bCritical = false, optional bool bReflected = false)
{
    `LWCE_LOG_DEPRECATED_CLS(CalcOverallDamage);

    return 10000;
}

function int LWCE_CalcOverallDamage(name WeaponName, int iCurrDamageStat, optional bool bCritical = false, optional bool bReflected = false)
{
    local int iDamage, iRandDamage, iWeaponDamage;

    iWeaponDamage = `LWCE_WEAPON(WeaponName).iDamage;
    iDamage = iWeaponDamage + iCurrDamageStat;

    if (bReflected)
    {
        return 0;
    }

    iRandDamage = `SYNC_RAND( (IsOptionEnabled(eGO_RandomDamage) ? 4 : 2) * iDamage + 2 );

    if (IsOptionEnabled(eGO_RandomDamage))
    {
        iDamage = ( (bCritical ? 6 : 2) * iDamage + 1 + iRandDamage ) / 4;
    }
    else
    {
        iDamage = ( (bCritical ? 5 : 3) * iDamage + 1 + iRandDamage) / 4;
    }

    if (bCritical)
    {
        iDamage = Max(iDamage, ( (IsOptionEnabled(eGO_RandomDamage) ? 6 : 5) * (iWeaponDamage + iCurrDamageStat) + 2) / 4);
    }

    if (iDamage < 1)
    {
        iDamage = 1;
    }

    return iDamage;
}

simulated function int CalcRangeModForWeaponAt(int iWeapon, XGUnit kViewer, XGUnit kTarget, Vector vViewerLoc)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function CalcRangeModForWeaponAt was called. This needs to be replaced with LWCEWeaponTemplate.CalcRangeMod. Stack trace follows.");
    ScriptTrace();

    return -1000;
}

// This function is reverse-engineered from its native version in XGTacticalGameCoreNativeBase.
// It is unmodified and unused; this version is only kept around to see what the native
// version does. Modifications should go in LWCE_CalcRangeModForWeaponAt.
private simulated function int CalcRangeModForWeaponAt_Original(int iWeapon, XGUnit kViewer, XGUnit kTarget, Vector vViewerLoc)
{
    local float fDist;
    local int iRangeMod;

    if (kTarget == none)
    {
        return 0;
    }

    if (m_arrWeapons[iWeapon].aProperties[eWP_Melee] != 0)
    {
        return 0;
    }

    fDist = VSize(vViewerLoc - kTarget.GetLocation());

    if (m_arrWeapons[iWeapon].aProperties[eWP_Assault] != 0)
    {
        iRangeMod = ASSAULT_AIM_CLIMB * (CLOSE_RANGE - fDist);

        if (iRangeMod < ASSAULT_LONG_RANGE_MAX_PENALTY)
        {
            iRangeMod = ASSAULT_LONG_RANGE_MAX_PENALTY;
        }
    }
    else if (m_arrWeapons[iWeapon].aProperties[eWP_Sniper] != 0)
    {
        if (fDist < CLOSE_RANGE)
        {
            iRangeMod = SNIPER_AIM_FALL * (CLOSE_RANGE - fDist);
        }
    }
    else if (fDist < CLOSE_RANGE)
    {
        iRangeMod = AIM_CLIMB * (CLOSE_RANGE - fDist);
    }

    if (iRangeMod < 0 && kViewer.HasReaperRoundsForWeapon(iWeapon))
    {
        iRangeMod *= 2;
    }

    return iRangeMod;
}

simulated function int CalcRangeModForWeapon(int iWeapon, XGUnit kViewer, XGUnit kTarget)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function CalcRangeModForWeapon was called. This needs to be replaced with LWCEWeaponTemplate.CalcRangeMod. Stack trace follows.");
    ScriptTrace();

    return -1000;
}

simulated function bool CalcReflection(int iAbilityType, int iWeaponType, out TCharacter kShooter, out TCharacter kTarget, bool bIsHit)
{
    `LWCE_LOG_DEPRECATED_CLS(CalcReflection);

    return true;
}

simulated function bool LWCE_CalcReflection(int iAbilityType, name nmWeapon, LWCE_XGUnit kShooter, LWCE_XGUnit kTarget, bool bIsHit)
{
    local int iTargetCharacterType;
    local LWCEWeaponTemplate kWeapon;

    iTargetCharacterType = kTarget.LWCE_GetCharacter().GetCharacterType();
    kWeapon = m_kItemTemplateMgr.FindWeaponTemplate(nmWeapon);

    if (kWeapon == none)
    {
        return false;
    }

    if (iAbilityType == eAbility_ShotStun)
    {
        return false;
    }

    if (!kWeapon.CanBeReflected(kShooter, kTarget))
    {
        return false;
    }

    if (!bIsHit && (iTargetCharacterType == eChar_Ethereal || iTargetCharacterType == eChar_EtherealUber))
    {
        return true;
    }

    return false;
}

simulated function int CalcXP(XGUnit kSoldier, int iEvent, XGUnit kVictim)
{
    local int iXPEarned;
    local LWCE_XGCharacter_Soldier kSoldierChar;

    kSoldierChar = LWCE_XGCharacter_Soldier(kSoldier.GetCharacter());

    // TODO: make all of the exp events configurable
    switch (iEvent)
    {
        case eGameEvent_Sight:
            if (XGCharacter_Soldier(kSoldier.GetCharacter()) != none && LWCE_IsBetterAlien(kSoldierChar.m_kCESoldier, kVictim.GetCharType(), false))
            {
                kSoldier.m_bSeenBetterAlien = true;
            }

            break;
        case eGameEvent_Kill:
            if (XGCharacter_Soldier(kSoldier.GetCharacter()) != none && LWCE_IsBetterAlien(kSoldierChar.m_kCESoldier, kVictim.GetCharType()))
            {
                iXPEarned = GetBetterAlienKillXP(kSoldier);
                kSoldier.m_bSeenBetterAlien = true;
            }
            else
            {
                iXPEarned = GetBasicKillXP(kSoldier);
            }

            break;
        case eGameEvent_MissionComplete:
            if (DeservesBetterAlienBonus(kSoldier))
            {
                iXPEarned = 110;
            }
            else
            {
                iXPEarned = 80;
            }

            if (kSoldierChar != none)
            {
                if (kSoldierChar.m_kCESoldier.iRank <= 4 && kSoldier.GetSquad().SquadHasStarOfTerra(false))
                {
                    iXPEarned += (iXPEarned / default.TERRA_XP);
                }
            }

            break;
        case eGameEvent_SpecialMissionComplete:
            if (DeservesBetterAlienBonus(kSoldier))
            {
                iXPEarned = 180;
            }
            else
            {
                iXPEarned = 120;
            }

            if (kSoldierChar != none)
            {
                if (kSoldierChar.m_kCESoldier.iRank <= 4 && kSoldier.GetSquad().SquadHasStarOfTerra(false))
                {
                    iXPEarned += (iXPEarned / default.TERRA_XP);
                }
            }

            break;
        case eGameEvent_ZeroDeadSoldiersBonus:
            iXPEarned = 20;
            break;
        case eGameEvent_TargetResistPsiAttack:
            iXPEarned = 10;
            break;
        case eGameEvent_KillMindControlEnemy:
            iXPEarned = 0;
            break;
        case eGameEvent_SuccessfulMindControl:
            iXPEarned = 25;
            break;
        case eGameEvent_SuccessfulMindFray:
            iXPEarned = 20;
            break;
        case eGameEvent_SuccessfulInspiration:
            iXPEarned = 0;
            break;
        case eGameEvent_AssistPsiInspiration:
            iXPEarned = 0;
            break;
        case eGameEvent_SuccessfulPsiPanic:
            iXPEarned = 15;
            break;
    }

    return iXPEarned;
}

simulated function bool CharacterIsPsionic(const out TCharacter kCharacter)
{
    `LWCE_LOG_DEPRECATED_CLS(CharacterIsPsionic);

    return false;
}

simulated function bool LWCE_CharacterIsPsionic(const out LWCE_TCharacter kCharacter)
{
    local int iAbility;

    for (iAbility = 0; iAbility < kCharacter.arrAbilities.Length; iAbility++)
    {
        if (m_kAbilities.AbilityHasProperty(kCharacter.arrAbilities[iAbility].ID, eProp_Psionic))
        {
            return true;
        }
    }

    return false;
}

simulated function bool DeservesBetterAlienBonus(XGUnit kSoldier)
{
    local LWCE_XGCharacter_Soldier kChar;
    local XGUnit kUnit;
    local XGSquad kSquad;
    local int kNumMembers, I;

    kChar = LWCE_XGCharacter_Soldier(kSoldier.GetCharacter());

    if (kChar == none)
    {
        return false;
    }

    if (kChar.m_kCESoldier.iRank > 4)
    {
        return false;
    }

    kSquad = kSoldier.GetSquad();
    kNumMembers = kSquad.GetNumMembers();

    for (I = 0; I < kNumMembers; I++)
    {
        kUnit = kSquad.GetMemberAt(I);

        if (kUnit.m_bSeenBetterAlien)
        {
            return true;
        }
    }

    return false;
}

function int GenerateWeaponFragments(int iItem)
{
    `LWCE_LOG_DEPRECATED_CLS(GenerateWeaponFragments);

    return 0;
}

function int LWCE_GenerateWeaponFragments(name ItemName)
{
    local int iFragments;

    if (!`BATTLE.m_bAllowItemFragments)
    {
        return 0;
    }

    iFragments = m_kItemTemplateMgr.FindEquipmentTemplate(ItemName).iWeaponFragmentsWhenDestroyed;

    if (iFragments == 0)
    {
        return 0;
    }

    return Max(1, int(float(iFragments) * FragmentBalance[m_iDifficulty]));
}

simulated function GetBackpackItemArray(TInventory kInventory, out array<int> arrBackPackItems)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetBackpackItemArray was called. This needs to be replaced with LWCEInventoryUtils.GetAllBackpackItems. Stack trace follows.");
    ScriptTrace();
}

simulated function int GetBackpackStatBonus(int iStat, array<int> arrBackPackItems, out TCharacter kCharacter)
{
    `LWCE_LOG_DEPRECATED_CLS(GetBackpackStatBonus);

    return -1;
}

simulated function int LWCE_GetBackpackStatBonus(int iStat, array<name> arrBackPackItems)
{
    local name ItemName;
    local int iTotal;

    iTotal = 0;

    foreach arrBackPackItems(ItemName)
    {
        iTotal += GetEquipmentItemStat(ItemName, ECharacterStat(iStat));
    }

    return iTotal;
}

simulated function TArmor GetTArmor(int iArmor)
{
    local TArmor kArmor;

    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetTArmor);

    return kArmor;
}

simulated function TWeapon GetTWeapon(int iWeapon)
{
    local TWeapon kWeapon;

    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetTWeapon);

    return kWeapon;

/*
    // Map as much as we can into the original struct
    kCEWeapon = LWCE_GetTWeapon(iWeapon);

    kWeapon.strName = kCEWeapon.strName;
    kWeapon.iType = kCEWeapon.iItemId;
    kWeapon.iSize = kCEWeapon.iSize;
    kWeapon.iDamage = kCEWeapon.iDamage;
    kWeapon.iEnvironmentDamage = kCEWeapon.iEnvironmentDamage;
    kWeapon.iRange = kCEWeapon.iRange;
    kWeapon.iReactionRange = kCEWeapon.iReactionRange;
    kWeapon.iRadius = kCEWeapon.iRadius;
    kWeapon.iCritical = kCEWeapon.kStatChanges.iCriticalChance;
    kWeapon.iOffenseBonus = kCEWeapon.kStatChanges.iAim;
    kWeapon.iHPBonus = kCEWeapon.kStatChanges.iHP;
    kWeapon.iWillBonus = kCEWeapon.kStatChanges.iWill;

    // iSuppression holds the ammo amount; the high digits are the amount with Ammo Conservation, which
    // always grants +1 ammo, and the low digits are the amount without.
    if (kCEWeapon.iBaseAmmo > 0)
    {
        kWeapon.iSuppression = 100 * (kCEWeapon.iBaseAmmo + 1) + kCEWeapon.iBaseAmmo;
    }

    foreach kCEWeapon.arrAbilities(iAbilityId)
    {
        if (iAbilityId < eAbility_MAX)
        {
            kWeapon.aAbilities[iAbilityId] = 1;
        }
    }

    foreach kCEWeapon.arrProperties(iPropertyId)
    {
        if (iPropertyId < eWP_MAX)
        {
            kWeapon.aProperties[iPropertyId] = 1;
        }
    }

    return kWeapon;
 */
}

/// <summary>
/// Retrieves the requested stat modifier on the given piece of equipment. By default, most stats from primary weapons
/// will be returned as 0, reflecting that they do not apply except when firing that weapon (the exceptions are mobility
/// and defense, which apply at all times). This can be overridden using the bIncludePrimaryWeaponStats parameter.
/// </summary>
simulated function float GetEquipmentItemStat(name ItemName, ECharacterStat eCharacterStat, optional bool bIncludePrimaryWeaponStats = false)
{
    local LWCE_TCharacterStats kStatChanges;
    local LWCEEquipmentTemplate kEquipment;
    local LWCEWeaponTemplate kWeapon;
    local float fStat;

    if (ItemName == '')
    {
        return 0;
    }

    kEquipment = LWCEEquipmentTemplate(m_kItemTemplateMgr.FindItemTemplate(ItemName));
    kWeapon = LWCEWeaponTemplate(kEquipment);

    if (!bIncludePrimaryWeaponStats && kWeapon != none && kWeapon.IsPrimaryWeapon())
    {
        if (eCharacterStat != eStat_Defense && eCharacterStat != eStat_Mobility)
        {
            return 0;
        }
    }

    // TODO: this probably needs to be passing a LWCE_TCharacter here
    kEquipment.GetStatChanges(kStatChanges);

    fStat = `LWCE_UTILS.GetCharacterStat(eCharacterStat, kStatChanges);

    return fStat;
}

simulated function EItemType GetEquipWeapon(TInventory kInventory)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEquipWeapon);

    return eItem_None;
}

simulated function name LWCE_GetEquipWeapon(LWCE_TInventory kInventory)
{
    local int Index;
    local LWCEWeaponTemplate kWeapon;

    for (Index = 0; Index < kInventory.arrLargeItems.Length; Index++)
    {
        if (kInventory.arrLargeItems[Index] == '')
        {
            continue;
        }

        kWeapon = m_kItemTemplateMgr.FindWeaponTemplate(kInventory.arrLargeItems[Index]);

        if (!kWeapon.HasWeaponProperty(eWP_Secondary))
        {
            return kInventory.arrLargeItems[Index];
        }
    }

    return kInventory.nmPistol;
}

simulated function GetInventoryStatModifiers(out int aModifiers[ECharacterStat], out TCharacter kCharacter, EItemType iEquippedWeapon, array<int> arrBackPackItems)
{
    `LWCE_LOG_DEPRECATED_CLS(GetInventoryStatModifiers);
}

// TODO: the int array here is incompatible with us using floats for DR in LWCE_TCharacterStats
simulated function LWCE_GetInventoryStatModifiers(out int aModifiers[ECharacterStat], out LWCE_TCharacter kCharacter, name EquippedWeaponName, array<name> arrBackpackItemNames)
{
    local LWCEArmorTemplate kArmor;
    local LWCEWeaponTemplate kWeapon;
    local int iStat;

    `LWCE_LOG_CLS("LWCE_GetInventoryStatModifiers: character type = " $ kCharacter.iCharacterType $ ", EquippedWeaponName = " $ EquippedWeaponName $ ", armor = " $ kCharacter.kInventory.nmArmor $ ", pistol = " $ kCharacter.kInventory.nmPistol $ ", num backpack items = " $ arrBackpackItemNames.Length);

    kArmor = `LWCE_ARMOR(kCharacter.kInventory.nmArmor);
    kWeapon = `LWCE_WEAPON(EquippedWeaponName);

    for (iStat = 0; iStat < eStat_MAX; iStat++)
    {
        aModifiers[iStat]  = GetEquipmentItemStat(EquippedWeaponName, ECharacterStat(iStat), /* bIncludePrimaryWeaponStats */ true);
        aModifiers[iStat] += GetEquipmentItemStat(kCharacter.kInventory.nmArmor, ECharacterStat(iStat));

        if (iStat == eStat_HP && kCharacter.arrPerks.Find('Id', `LW_PERK_ID(ExtraConditioning)) != INDEX_NONE)
        {
            aModifiers[iStat] += kArmor.iExtraConditioningBonusHP;
        }

        // Pistols do not get aim/crit stats from backpack items
        if ( !kWeapon.HasWeaponProperty(eWP_Pistol) || (iStat != eStat_Offense && iStat != eStat_CriticalShot) )
        {
            aModifiers[iStat] += LWCE_GetBackpackStatBonus(iStat, arrBackpackItemNames);

            switch (iStat)
            {
                case eStat_HP:
                    if (`LWCE_UTILS.IsFoundryTechResearched('Foundry_ShapedArmor'))
                    {
                        if (kCharacter.iCharacterType == eChar_Tank || kCharacter.bIsAugmented)
                        {
                            aModifiers[iStat] += 3;
                        }
                    }

                    break;
                case eStat_Mobility:
                    if (kCharacter.arrPerks.Find('Id', `LW_PERK_ID(Sprinter)) != INDEX_NONE)
                    {
                        aModifiers[iStat] += 4;
                    }

                    break;
                case eStat_DamageReduction:
                    if (kCharacter.arrPerks.Find('Id', `LW_PERK_ID(AutomatedThreatAssessment)) != INDEX_NONE)
                    {
                        aModifiers[iStat] += 5;
                    }

                    if (kCharacter.arrPerks.Find('Id', `LW_PERK_ID(IronSkin)) != INDEX_NONE)
                    {
                        aModifiers[iStat] += 10;
                    }

                    break;
                case eStat_FlightFuel:
                    if (`LWCE_UTILS.IsFoundryTechResearched('Foundry_AdvancedFlight'))
                    {
                        aModifiers[iStat] *= 2;
                    }

                    break;
                default:
                    break;
            }
        }
    }
}

simulated function int GetOverheatIncrement(XGUnit kUnit, int iWeapon, int iAbility, out TCharacter kCharacter, optional bool bReactionFire)
{
    `LWCE_LOG_DEPRECATED_CLS(GetOverheatIncrement);

    return 1000;
}

// TODO: this needs to be part of the weapon/ability templates
simulated function int LWCE_GetOverheatIncrement(name WeaponName, int iAbility, LWCE_TCharacter kCharacter, optional bool bReactionFire)
{
    local LWCEWeaponTemplate kWeapon;
    local int iAmount;

    if (WeaponName == '')
    {
        return 0;
    }

    kWeapon = `LWCE_WEAPON(WeaponName);

    if (kWeapon.HasWeaponProperty(eWP_UnlimitedAmmo))
    {
        return 0;
    }

    if (kWeapon.HasWeaponProperty(eWP_NoReload))
    {
        return 0;
    }

    if (kWeapon.HasWeaponProperty(eWP_Melee))
    {
        return 0;
    }

    iAmount = kWeapon.GetClipSize();

    if (`LWCE_UTILS.IsFoundryTechResearched('Foundry_AmmoConservation'))
    {
        iAmount += 1;
    }

    if (!kWeapon.HasWeaponProperty(eWP_Pistol))
    {
        if (kCharacter.arrPerks.Find('ID', `LW_PERK_ID(LockNLoad)) != INDEX_NONE)
        {
            iAmount += 1;
        }

        if (class'LWCEInventoryUtils'.static.HasItemOfName(kCharacter.kInventory, 'Item_HiCapMags'))
        {
            iAmount += 1;
        }

        if (class'LWCEInventoryUtils'.static.HasItemOfName(kCharacter.kInventory, 'Item_DrumMags'))
        {
            iAmount += 2;
        }
    }

    iAmount = Max(iAmount, 1);
    iAmount = 100 / iAmount;

    switch (iAbility)
    {
        case eAbility_MEC_Barrage:
        case eAbility_ShotFlush:
        case eAbility_ShotMayhem:
        case eAbility_ShotSuppress:
            iAmount = 2 * iAmount;
            break;
    }

    return iAmount;
}

simulated function int GetUpgradeAbilities(int iRank, int iPersonality)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetUpgradeAbilities was called. This needs to be replaced with GetEquipmentItemStat. Stack trace follows.");
    ScriptTrace();

    return -100;
}

simulated function int GetWeaponStatBonus(int iStat, int iWeapon, const out TCharacter kCharacter)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetWeaponStatBonus);

    return -100;
}

private simulated function int GetWeaponStatBonus_Original(int iStat, int iWeapon, const out TCharacter kCharacter)
{
    if (iStat == eStat_HP)
    {
        return m_arrWeapons[iWeapon].iHPBonus;
    }

    if (iStat == eStat_Will)
    {
        return m_arrWeapons[iWeapon].iWillBonus;
    }

    if (iStat == eStat_Offense)
    {
        if (m_arrWeapons[iWeapon].aProperties[eWP_Pistol] != 0 && kCharacter.aUpgrades[ePerk_Foundry_PistolII] != 0)
        {
            return m_arrWeapons[iWeapon].iOffenseBonus + FOUNDRY_PISTOL_AIM_BONUS;
        }
        else
        {
            return m_arrWeapons[iWeapon].iOffenseBonus;
        }
    }

    if (iStat == eStat_CriticalShot)
    {
        if (iWeapon == /* SCOPE */ 74 && kCharacter.aUpgrades[ePerk_Foundry_Scope] != 0)
        {
            return FOUNDRY_SCOPE_CRIT_BONUS;
        }
    }

    return 0;
}

function eWeaponRangeCat GetWeaponCatRange(EItemType eWeapon)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetWeaponCatRange was called. This needs to be replaced with LWCEWeaponTemplate.GetWeaponCatRange. Stack trace follows.");
    ScriptTrace();

    return eWRC_Short;
}

simulated function bool IsBetterAlien(TSoldier kSoldier, int iTargetCharType, optional bool bCheckSoldierRank = true)
{
    `LWCE_LOG_DEPRECATED_CLS(IsBetterAlien);

    return true;
}

simulated function bool LWCE_IsBetterAlien(LWCE_TSoldier kSoldier, int iTargetCharType, optional bool bCheckSoldierRank = true)
{
    local int iRank;
    local bool isLesserRank;
    local int iAlien;

    iRank = kSoldier.iRank;
    iAlien = iTargetCharType;

    if (bCheckSoldierRank)
    {
        isLesserRank = iRank < 4;
    }
    else
    {
        isLesserRank = true;
    }

    if (isLesserRank)
    {
        return iAlien == eChar_SectoidCommander || iAlien == eChar_MutonElite || iAlien == eChar_Ethereal || iAlien == eChar_Sectopod || iAlien == eChar_Outsider || iAlien == eChar_EtherealUber || iAlien == eChar_Mechtoid;
    }

    return false;
}

// TODO: rewrite all of the ItemIs* functions, maybe move into XGItemTree
simulated function bool ItemIsAccessory(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function ItemIsAccessory was called. This needs to be replaced with LWCEWeaponTemplate.IsAccessory. Stack trace follows.");
    ScriptTrace();

    return false;
}

simulated function bool ItemIsWeapon(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function ItemIsWeapon was called. This needs to be replaced with LWCEWeaponTemplate.IsWeapon. Stack trace follows.");
    ScriptTrace();

    return false;
}

simulated function bool ItemIsArmor(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function ItemIsArmor was called. This needs to be replaced with LWCEWeaponTemplate.IsArmor. Stack trace follows.");
    ScriptTrace();

    return false;
}

simulated function bool ItemIsMecArmor(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function ItemIsMecArmor was called. This needs to be replaced with LWCEWeaponTemplate.IsMecArmor. Stack trace follows.");
    ScriptTrace();

    return false;
}

simulated function bool ItemIsShipWeapon(int iItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function ItemIsShipWeapon was called. This needs to be replaced with LWCEWeaponTemplate.IsShipWeapon. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool RollForHit(float fChance, out TCharacter kShooter, out TCharacter kTarget, out float fRoll)
{
    `LWCE_LOG_DEPRECATED_CLS(RollForHit);

    fRoll = -1.0f;
    return false;
}

function bool LWCE_RollForHit(float fChance, out float fRoll)
{
    fRoll = class'XComEngine'.static.SyncFRand(Name @ GetStateName() @ GetFuncName());
    return fRoll <= fChance;
}

simulated function bool WeaponHasProperty(int iWeapon, int iWeaponProperty)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function WeaponHasProperty was called. This needs to be replaced with LWCEWeaponTemplate.HasWeaponProperty. Stack trace follows.");
    ScriptTrace();

    return false;
}