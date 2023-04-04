class LWCE_XGUnit extends XGUnit;

struct CheckpointRecord_LWCE_XGUnit extends CheckpointRecord_XGUnit
{
    var LWCE_TSoldier m_kCESoldier;
    var LWCE_TAppearance m_kCESavedAppearance;

    var array<name> m_arrActionPoints;

    var array<int> m_arrCEBonuses;
    var array<int> m_arrCEPassives;
    var array<int> m_arrCEPenalties;

    // LWCE issue #76: this flag is not persisted on save/load, making it possible to lose your
    // better alien bonus under some circumstances.
    var bool m_bSeenBetterAlien;
};

var LWCE_TSoldier m_kCESoldier;
var LWCE_TAppearance m_kCESavedAppearance;

var array<name> m_arrActionPoints; // The action points currently available to this unit.
var array<LWCE_XGAbility> m_arrAbilities;
var array<LWCEAppliedEffect> m_arrAppliedEffects; // The persistent effects currently applied to this unit.

// TODO: delete these; replaced by effects
var array<int> m_arrCEBonuses;
var array<int> m_arrCEPassives;
var array<int> m_arrCEPenalties;

// -------------------------------------------------
// Functions newly added in LWCE
//
// Use these functions instead of accessing data directly!
// There's a lot of weird stuff going on under the hood.
// -------------------------------------------------

function AddPersistentEffect(LWCEAppliedEffect kEffect)
{
    local bool bAdded;
    local int Index;

    `LWCE_LOG_CLS("AddPersistentEffect: effect name is " $ kEffect.m_kEffect.EffectName);

    for (Index = 0; Index < m_arrAppliedEffects.Length; Index++)
    {
        if (m_arrAppliedEffects[Index].m_kEffect.iPriority >= kEffect.m_kEffect.iPriority)
        {
            m_arrAppliedEffects.InsertItem(Index, kEffect);
            bAdded = true;
            break;
        }
    }

    if (!bAdded)
    {
        m_arrAppliedEffects.AddItem(kEffect);
    }
}

function LWCEAppliedEffect FindEffect(name EffectName)
{
    local LWCEAppliedEffect kEffect;

    foreach m_arrAppliedEffects(kEffect)
    {
        if (kEffect.m_kEffect.EffectName == EffectName)
        {
            return kEffect;
        }
    }

    return none;
}

function LWCE_XGCharacter LWCE_GetCharacter()
{
    return LWCE_XGCharacter(m_kCharacter);
}

function int GetClassId()
{
    return LWCE_GetCharacter().GetCharacter().iClassId;
}

function LWCE_XGInventory LWCE_GetInventory()
{
    return LWCE_XGInventory(m_kInventory);
}

function int GetSituationalWill(bool bIncludeBaseStat, bool bIncludeNeuralDamping, bool bIncludeCombatStims)
{
    local int iMod, iWill;
    local XGTacticalGameCore kGameCore;

    kGameCore = `GAMECORE;

    if (bIncludeBaseStat)
    {
        iWill += GetWill();
    }

    if (bIncludeNeuralDamping && HasPerk(`LW_PERK_ID(NeuralDamping)))
    {
        iWill += `LWCE_TACCFG(iNeuralDampingWillBonus);
    }

    if (bIncludeCombatStims && GetAppliedAbility(eAbility_CombatStim) != none)
    {
        iWill += `LWCE_TACCFG(iCombatStimsWillBonus);
    }

    if (m_bInCombatDrugs)
    {
        iWill += `LWCE_TACCFG(iCombatDrugsWillBonus);
    }

    if (HasPerk(`LW_PERK_ID(LegioPatriaNostra)))
    {
        iWill += kGameCore.CalcInternationalWillBonus();
    }

    // Esprit de Corps
    if (GetSquad().SquadHasStarOfTerra(/* PowerA */ true) && !kGameCore.CharacterHasProperty(GetCharType(), eCP_Robotic))
    {
        iWill += `LWCE_TACCFG(iEspritDeCorpsWillBonus);
    }

    iWill += GetBattleFatigueWillPenalty() + GetFallenComradesWillPenalty();

    if (kGameCore.IsOptionEnabled(`LW_SECOND_WAVE_ID(GreenFog)) && !IsAI())
    {
        iMod = `BATTLE.m_iTurn * `LWCE_TACCFG(fGreenFogWillLossPerTurn);
        iMod = Clamp(iMod, `LWCE_TACCFG(iGreenFogMaximumWillLoss), 0);

        iWill += iMod;
    }

    return iWill;
}

/// <summary>
/// Retrieves the actual amount of defense this unit is receiving from cover versus the given attacker.
/// While XGUnit contains a field called "m_iCurrentCoverValue", for some reason that field includes some
/// perk bonuses and other effects.
///
/// This function should only be called if you have verified that the unit is in cover from the attacker.
/// </summary>
function int GetTrueCoverValue(XGUnit kAttacker)
{
    local int iNonCoverBonus;

    UpdateCoverBonuses(kAttacker);

    // Use superclass function to get the value that would've been baked into m_iCurrentCoverValue
    iNonCoverBonus = super.GetTacticalSenseCoverBonus();
    iNonCoverBonus += super.GetLowProfileCoverBonus();

    // TODO what perk values are in m_iCurrentCoverValue? probably not ours from config
    if (HasBonus(`LW_PERK_ID(DamnGoodGround)) && HasHeightAdvantageOver(kAttacker))
    {
        iNonCoverBonus += 10;
    }

    if (m_bInSmokeBomb)
    {
        iNonCoverBonus += 20;
    }

    if (m_bInDenseSmoke)
    {
        iNonCoverBonus += 20;
    }

    if (HasBonus(`LW_PERK_ID(AutomatedThreatAssessment)))
    {
        iNonCoverBonus += 15;
    }

    if (HasAirEvadeBonus())
    {
        iNonCoverBonus += `GAMECORE.AIR_EVADE_DEF;
    }

    if (HasPerk(`LW_PERK_ID(SemperVigilans)))
    {
        iNonCoverBonus += 5;
    }

    return Max(0, m_iCurrentCoverValue - iNonCoverBonus);
}

function GivePerk(int iPerkId, optional name nmSourceTypeId = 'Innate', optional name nmSourceId)
{
    local LWCE_TIDWithSource kPerkData;

    // Add base game perks to the underlying character, for native code to read
    if (iPerkId < ePerk_MAX)
    {
        m_kCharacter.m_kChar.aUpgrades[iPerkId] = m_kCharacter.m_kChar.aUpgrades[iPerkId] | 1;
    }

    kPerkData.Id = iPerkId;
    kPerkData.SourceId = nmSourceId;
    kPerkData.SourceType = nmSourceTypeId;

    LWCE_GetCharacter().AddPerk(kPerkData);
}

function bool HasAbility(name nmAbility)
{
    local LWCE_XGAbility kAbility;

    foreach m_arrAbilities(kAbility)
    {
        if (kAbility.m_TemplateName == nmAbility)
        {
            return true;
        }
    }

    return false;
}

function bool HasCharacterProperty(int iCharPropId)
{
    return LWCE_GetCharacter().HasCharacterProperty(iCharPropId);
}

function bool HasPerk(int iPerkId)
{
    // Need to check base game data as well for effects that only apply there
    if (iPerkId < ePerk_MAX && m_kCharacter.m_kChar.aUpgrades[iPerkId] != 0)
    {
        return true;
    }

    return LWCE_GetCharacter().HasPerk(iPerkId);
}

function bool HasSquadsight()
{
    return LWCE_GetCharacter().HasPerk(`LW_PERK_ID(Squadsight));
}

function bool HasTraversal(int iTraversalId)
{
    return LWCE_GetCharacter().HasTraversal(iTraversalId);
}

function bool IsInExecutionerRange()
{
    return GetHealthPct() <= `LWCE_TACCFG(fExecutionerHealthThreshold);
}

function bool IsPsionic()
{
    return LWCE_GetCharacter().IsPsionic();
}

/// <summary>
/// Causes all ability breakdowns (their cached hit/crit chances) to update.
///
/// WARNING: This is an expensive operation, and it's very unlikely for mods to need to call this.
/// </summary>
function UpdateAbilityBreakdowns(optional bool bHostileOnly = true)
{
    local LWCE_XGAbility kAbility;

    foreach m_arrAbilities(kAbility)
    {
        if (bHostileOnly && kAbility.m_kTemplate.Hostility != eHostility_Offensive)
        {
            continue;
        }

        // Shouldn't be any need to do this for non-input abilities
        if (!kAbility.IsTriggeredByInput())
        {
            continue;
        }

        kAbility.GatherTargets();
    }
}

// -------------------------------------------------
// Overrides/additions to base game functions below
// -------------------------------------------------

function int AbsorbDamage(const int IncomingDamage, XGUnit kDamageCauser, XGWeapon kWeapon)
{
    local LWCE_XGUnit kCEDamageCauser;
    local LWCE_XGWeapon kCEWeapon;
    local float fAbsorptionFieldsBasis, fReturnDmg, fDist;
    local int iReturnDmg;

    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(self))
    {
        return 0;
    }

    kCEDamageCauser = LWCE_XGUnit(kDamageCauser);
    kCEWeapon = LWCE_XGWeapon(kWeapon);
    fReturnDmg = float(IncomingDamage);

    // Apply the Damage Reduction stat
    if ((m_aCurrentStats[eStat_DamageReduction] % 100) > 0)
    {
        fReturnDmg = fReturnDmg - (float(m_aCurrentStats[eStat_DamageReduction] % 100) / float(10));
    }

    // Mind merge bonus DR (XCOM only)
    if (!IsAI() && m_iWillCheatBonus > 0)
    {
        fReturnDmg -= `LWCE_TACCFG(fMindMergeDRPerWill) * float(m_iWillCheatBonus);
    }

    // Damage Control
    if (HasPerk(ePerk_DamageControl) && m_iDamageControlTurns > 0 && fReturnDmg > 1.0)
    {
        fReturnDmg -= `LWCE_TACCFG(fDamageControlDRBonus);
    }

    // One for All bonus DR
    if (m_bOneForAllActive)
    {
        fReturnDmg -= `LWCE_TACCFG(fOneForAllDRBonus);
    }

    // Uber Ethereal bonus DR: 15 per remaining Ethereal in the level
    if (m_kCharacter.m_kChar.iType == eChar_EtherealUber)
    {
        foreach AllActors(class'XGUnit', m_kZombieVictim)
        {
            if (m_kZombieVictim.IsAliveAndWell() && m_kZombieVictim.m_kCharacter.m_kChar.iType == eChar_Ethereal)
            {
                fReturnDmg -= float(15);
            }
        }
    }

    // Combat stims damage multiplier
    if (GetAppliedAbility(eAbility_CombatStim) != none)
    {
        fReturnDmg *= `LWCE_TACCFG(fCombatStimsIncomingDamageMultiplier);
    }

    // Reduce melee damage for soldiers with Chitin Plating and for Chryssalids
    if (kWeapon != none)
    {
        if (kWeapon.IsMelee() || kWeapon.IsA('XGWeapon_MEC_KineticStrike'))
        {
            if (GetInventory() != none && GetInventory().GetRearBackpackItem(eItem_ChitinPlating) != none)
            {
                fReturnDmg *= `LWCE_TACCFG(fIncomingMeleeDamageMultiplierForChitinPlating);
            }
            else if (m_kCharacter.m_kChar.iType == eChar_Chryssalid)
            {
                fReturnDmg *= `LWCE_TACCFG(fIncomingMeleeDamageMultiplierForChryssalids);
            }
        }
    }

    // Psi Shield on Mechtoids provides DR
    if (GetShieldHP() > 0)
    {
        fReturnDmg *= `LWCE_TACCFG(fPsiShieldIncomingDamageMultiplier);
    }

    // Shock-Absorbent Armor if attacker within 4 tiles
    if (kCEDamageCauser != none && HasPerk(ePerk_ShockAbsorbentArmor))
    {
        fDist = VSize(GetLocation() - kCEDamageCauser.GetLocation());

        if (fDist <= `LWCE_TACCFG(fShockAbsorbentArmorRadius))
        {
            fReturnDmg *= `LWCE_TACCFG(fShockAbsorbentArmorIncomingDamageMultiplier);
        }
    }

    // Absorption Fields: X% DR of remaining damage greater than Y
    if (HasPerk(ePerk_AbsorptionFields))
    {
        if (fReturnDmg > `LWCE_TACCFG(fAbsorptionFieldsActivationThreshold))
        {
            fAbsorptionFieldsBasis = fReturnDmg - `LWCE_TACCFG(fAbsorptionFieldsActivationThreshold);
            fReturnDmg -= fAbsorptionFieldsBasis * `LWCE_TACCFG(fAbsorptionFieldsIncomingDamageMultiplier);
            m_bAbsorptionFieldsWorked = true;
        }
    }

    // Acid: negate percentage of DR, with a minimum value
    if (IsPoisoned())
    {
        fReturnDmg += FMax(`LWCE_TACCFG(fAcidMinimumDRRemoved),
                           `LWCE_TACCFG(fAcidDRRemovalPercentage) * (float(IncomingDamage) - fReturnDmg));
    }

    if (IsInCover())
    {
        if (!IsFlankedBy(kCEDamageCauser) || (kWeapon != none && kWeapon.IsA('XGWeapon_NeedleGrenade')))
        {
            fDist = fReturnDmg;

            // Base DR bonus from being in cover
            if (IsInLowCover())
            {
                fReturnDmg -= `LWCE_TACCFG(fLowCoverDRBonus);
            }
            else
            {
                fReturnDmg -= `LWCE_TACCFG(fHighCoverDRBonus);
            }

            // Doubled cover DR bonus if hunkered
            if (IsHunkeredDown())
            {
                if (IsInLowCover())
                {
                    fReturnDmg -= `LWCE_TACCFG(fLowCoverDRBonus);
                }
                else
                {
                    fReturnDmg -= `LWCE_TACCFG(fHighCoverDRBonus);
                }
            }

            // Will to Survive DR
            if (HasPerk(ePerk_WillToSurvive))
            {
                fReturnDmg -= `LWCE_TACCFG(fWillToSurviveDRBonus);
            }

            // Fortiores Una
            if (HasPerk(`LW_PERK_ID(FortioresUna)) && HasBonus(170))
            {
                if (IsInLowCover())
                {
                    fReturnDmg -= `LWCE_TACCFG(fLowCoverDRBonus);
                }
                else
                {
                    fReturnDmg -= `LWCE_TACCFG(fHighCoverDRBonus);
                }
            }
        }
    }

    if (kCEDamageCauser != none)
    {
        // Combined Arms: negate 1 DR
        if (kCEDamageCauser.HasPerk(`LW_PERK_ID(CombinedArms)))
        {
            fReturnDmg += `LWCE_TACCFG(fCombinedArmsDRPenetration);
        }

        if (kCEDamageCauser.LWCE_GetCharacter().HasItemInInventory('Item_ArmorPiercingAmmo'))
        {
            if (kWeapon != none && !kWeapon.HasProperty(eWP_Assault) && !kWeapon.HasProperty(eWP_Pistol))
            {
                fReturnDmg += 2.0; // TODO: configure this value on the item itself
            }
        }

        if (kWeapon != none)
        {
            if (kCEWeapon.m_kTemplate.nmTechTier == 'wpn_gauss')
            {
                fReturnDmg += `LWCE_TACCFG(fGaussWeaponsDRPenetration);

                if (kCEDamageCauser.HasPerk(`LW_PERK_ID(Quenchguns)))
                {
                    fReturnDmg += `LWCE_TACCFG(fQuenchgunsDRPenetration);
                }
            }
        }

        fReturnDmg = FMin(fReturnDmg, float(IncomingDamage));
    }

    if (fReturnDmg < float(IncomingDamage))
    {
        if (kCEDamageCauser != none)
        {
            if (kWeapon != none && kWeapon.HasProperty(eWP_Assault))
            {
                // DR penalty for shotguns unless using Breaching Ammo
                if (!kCEDamageCauser.LWCE_GetCharacter().HasItemInInventory('Item_BreachingAmmo'))
                {
                    fReturnDmg -= (`LWCE_TACCFG(fShotgunDRPenalty) * (float(IncomingDamage) - fReturnDmg));
                }
            }
        }

        fReturnDmg = FMax(fReturnDmg, 0.0f);

        if (kWeapon != none && kWeapon.IsA('XGWeapon_MEC_KineticStrike'))
        {
            iReturnDmg = FFloor(fReturnDmg);
        }
        else if (FRand() < (fReturnDmg - float(FFloor(fReturnDmg))))
        {
            iReturnDmg = FCeil(fReturnDmg);
        }
        else if (IncomingDamage == 12345)
        {
            // This is some special case that I don't even want to start digging into
            iReturnDmg = FCeil(fReturnDmg);
        }
        else
        {
            iReturnDmg = FFloor(fReturnDmg);
        }

        // Record the amount of DR for display later
        if (IncomingDamage - iReturnDmg > 0)
        {
            m_bCantBeHurt = IncomingDamage - iReturnDmg;
        }

        return iReturnDmg;
    }

    return IncomingDamage;
}

function AddBonus(int iBonus)
{
    if (iBonus < ePerk_MAX)
    {
        super.AddBonus(iBonus);
    }

    if (m_arrCEBonuses.Find(iBonus) == INDEX_NONE)
    {
        m_arrCEBonuses.AddItem(iBonus);
    }
}

function RemoveBonus(int iBonus)
{
    if (iBonus < ePerk_MAX)
    {
        super.RemoveBonus(iBonus);
    }

    m_arrCEBonuses.RemoveItem(iBonus);
}

function AddPassive(int iPassive)
{
    `LWCE_LOG_CLS("AddPassive: iPassive = " $ iPassive);

    if (iPassive < ePerk_MAX)
    {
        super.AddPassive(iPassive);
    }

    if (m_arrCEPassives.Find(iPassive) == INDEX_NONE)
    {
        m_arrCEPassives.AddItem(iPassive);
    }
}

function RemovePassive(int iPassive)
{
    if (iPassive < ePerk_MAX)
    {
        super.RemovePassive(iPassive);
    }

    m_arrCEPassives.RemoveItem(iPassive);
}

function AddPenalty(int iPenalty)
{
    `LWCE_LOG_CLS("AddPenalty: iPenalty = " $ iPenalty);

    if (iPenalty < ePerk_MAX)
    {
        super.AddPenalty(iPenalty);
    }

    if (m_arrCEPenalties.Find(iPenalty) == INDEX_NONE)
    {
        m_arrCEPenalties.AddItem(iPenalty);
    }
}

function RemovePenalty(int iPenalty)
{
    if (iPenalty < ePerk_MAX)
    {
        super.RemovePenalty(iPenalty);
    }

    m_arrCEPenalties.RemoveItem(iPenalty);
}

simulated function bool ActiveWeaponHasAmmoForShot(optional int iAbilityType = eAbility_ShotStandard, optional bool bReactionShot = false, optional bool bUsePrimaryWeapon = false)
{
    local LWCE_XGTacticalGameCore kGameCore;
    local XGWeapon kActiveWeapon;

    kGameCore = `LWCE_GAMECORE;
    kActiveWeapon = bUsePrimaryWeapon ? GetInventory().GetPrimaryWeapon() : GetInventory().GetActiveWeapon();

    if (kActiveWeapon == none)
    {
        return false;
    }

    if (kActiveWeapon.HasProperty(eWP_NoReload))
    {
        return true;
    }

    if (kActiveWeapon.GetRemainingAmmo() < kGameCore.LWCE_GetOverheatIncrement(class'LWCE_XGWeapon_Extensions'.static.GetItemName(kActiveWeapon), iAbilityType, LWCE_GetCharacter().GetCharacter(), bReactionShot))
    {
        return false;
    }

    return true;
}

simulated event AddArmorAbilities(Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly = false)
{
    local int Index, iAbilityId;
    local LWCEArmorTemplate kArmor;
    local bool bShouldAddMoveAbilities;

    kArmor = `LWCE_ARMOR(LWCE_GetCharacter().GetInventory().nmArmor);

    // Enemies don't actually have armor equipment, so check first
    if (kArmor == none)
    {
        return;
    }

    bShouldAddMoveAbilities = ShouldAddMoveAbilities();

    for (Index = 0; Index < kArmor.arrAbilities.Length; Index++)
    {
        if (kArmor.arrAbilities[Index] == '')
        {
            continue;
        }

        iAbilityId = class'LWCE_XGAbilityTree'.static.AbilityBaseIdFromName(kArmor.arrAbilities[Index]);

        if (iAbilityId == 0)
        {
            continue;
        }

        if (`GAMECORE.m_kAbilities.AbilityHasProperty(iAbilityId, eProp_CostMove) && !bShouldAddMoveAbilities)
        {
            continue;
        }

        GenerateAbilities(iAbilityId, vLocation, arrAbilities,, bForLocalUseOnly);
    }
}

simulated event AddCharacterAbilities(Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly = false)
{
    local array<int> arrAbilityIdsToAdd;
    local int Index;
    local LWCE_TCharacter kChar;

    kChar = LWCE_GetCharacter().GetCharacter();

    for (Index = 0; Index < kChar.arrAbilities.Length; Index++)
    {
        // Don't add the same ability more than once
        if (kChar.arrAbilities[Index].Id == 0 || arrAbilityIdsToAdd.Find(kChar.arrAbilities[Index].Id) != INDEX_NONE)
        {
            break;
        }

        if (kChar.arrAbilities[Index].Id == eAbility_TakeCover)
        {
            // TODO base game logic seems to skip this ability for MECs?
        }

        arrAbilityIdsToAdd.AddItem(kChar.arrAbilities[Index].Id);
    }

    for (Index = 0; Index < arrAbilityIdsToAdd.Length; Index++)
    {
        GenerateAbilities(arrAbilityIdsToAdd[Index], vLocation, arrAbilities,, bForLocalUseOnly);
    }
}


function AddCriticallyWoundedAction(optional bool bStunAlien = false, optional bool bLoading = false)
{
    local XGAction_CriticallyWounded kAction;
    local XGAIPlayer kAI;

    if (!bLoading)
    {
        if (!bStunAlien && IsAlien_CheckByCharType())
        {
            return;
        }

        if (m_bCriticallyWounded || (m_kCurrAction != none && m_kCurrAction.IsA('XGAction_CriticallyWounded')))
        {
            return;
        }
    }

    if (IsMoving())
    {
        m_kActionQueue.Clear(true, false);
    }

    m_bCriticallyWounded = true;
    kAI = XGAIPlayer(`BATTLE.GetAIPlayer());

    if (kAI != none)
    {
        kAI.OnCriticalWound(self);
    }

    if (bStunAlien)
    {
        m_bStunned = true;
        m_bStabilized = true;

        if (m_kCharacter.m_kChar.iType == eChar_Outsider)
        {
            LWCE_XGBattleDesc(`BATTLE.m_kDesc).m_kArtifactsContainer.AdjustQuantity('Item_OutsiderShard', 1);
            PRES().UINarrative(`XComNarrativeMoment("OutsiderShardFirstSeen"));
        }

        // LWCE issue #7: if the last visible enemy is stunned instead of killed, combat music will continue playing.
        // This fix simply stops the music in that case.
        if (ShouldStopCombatMusicAfterBeingStunned())
        {
            XComTacticalSoundManager(XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).GetSoundManager()).StopCombatMusic();
        }
    }

    kAction = Spawn(class'XGAction_CriticallyWounded', Owner);
    kAction.Init(self, bLoading);

    if (bLoading && !m_bStabilized)
    {
        `PRES.MSGBleedingOut(self);
    }

    AddAction(kAction);
}

simulated function AddMoveAbilities(XGTacticalGameCoreNativeBase kGameCore, out array<XGAbility> arrAbilities)
{
    local array<XGUnit> arrTargets;
    local XGAbility kAbility;

    arrTargets.AddItem(self);

    if (ShouldAddMoveAbilities())
    {
        kAbility = kGameCore.m_kAbilities.SpawnAbility(eAbility_Move, self, arrTargets, /* kWeapon */ none, /* kMiscActor */ none, /* bForLocalUseOnly */ false, /* bReactionFire */ false);
        arrAbilities.AddItem(kAbility);
    }

    if (HasPerk(`LW_PERK_ID(RunAndGun)))
    {
        kAbility = kGameCore.m_kAbilities.SpawnAbility(eAbility_RunAndGun, self, arrTargets, /* kWeapon */ none, /* kMiscActor */ none, /* bForLocalUseOnly */ false, /* bReactionFire */ false);
        arrAbilities.AddItem(kAbility);
    }
}

simulated function AddPerkSpecificAbilities(XGTacticalGameCoreNativeBase kGameCore, out array<XGAbility> arrAbilities)
{
    local Vector vLocation;

    vLocation = GetLocation();

    // Like AddWeaponAbilities, this is reverse engineered and adapted from the native code
    if (HasPerk(`LW_PERK_ID(Concealment)))
    {
        GenerateAbilities(eAbility_MimeticSkin, vLocation, arrAbilities,, /* bForLocalUseOnly */ false);
    }

    if (HasPerk(`LW_PERK_ID(AdrenalNeurosympathy)))
    {
        GenerateAbilities(eAbility_AdrenalNeurosympathy, vLocation, arrAbilities,, /* bForLocalUseOnly */ false);
    }

    if (HasPerk(`LW_PERK_ID(JetbootModule)))
    {
        GenerateAbilities(eAbility_JetbootModule, vLocation, arrAbilities,, /* bForLocalUseOnly */ false);
    }

    if (HasPerk(`LW_PERK_ID(OneForAll)))
    {
        GenerateAbilities(eAbility_MEC_OneForAll, vLocation, arrAbilities,, /* bForLocalUseOnly */ false);
    }
}


simulated event AddPsiAbilities(Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly = false)
{
    local XGCharacter kChar;

    if (IsAlien_CheckByCharType())
    {
        return;
    }

    kChar = GetCharacter();

    if (kChar.HasUpgrade(ePerk_MindFray))
    {
        GenerateAbilities(eAbility_Mindfray, vLocation, arrAbilities,, bForLocalUseOnly);
    }

    if (kChar.HasUpgrade(ePerk_PsiPanic))
    {
        GenerateAbilities(eAbility_PsiPanic, vLocation, arrAbilities,, bForLocalUseOnly);
    }

    if (kChar.HasUpgrade(ePerk_PsiInspiration))
    {
        GenerateAbilities(eAbility_PsiInspiration, vLocation, arrAbilities,, bForLocalUseOnly);
        GenerateAbilities(eAbility_PsiInspired, vLocation, arrAbilities,, bForLocalUseOnly);
    }

    if (kChar.HasUpgrade(ePerk_MindControl))
    {
        GenerateAbilities(eAbility_MindControl, vLocation, arrAbilities,, bForLocalUseOnly);
    }

    if (kChar.HasUpgrade(ePerk_TelekineticField))
    {
        GenerateAbilities(eAbility_TelekineticField, vLocation, arrAbilities,, bForLocalUseOnly);
    }

    if (!kChar.HasUpgrade(ePerk_Rift))
    {
        if (kChar.IsA('XGCharacter_Soldier') && LWCE_XGCharacter_Soldier(kChar).m_kCESoldier.iPsiRank == 7)
        {
            kChar.GivePerk(ePerk_Rift);
        }
    }

    if (kChar.HasUpgrade(ePerk_Rift))
    {
        GenerateAbilities(eAbility_Rift, vLocation, arrAbilities,, bForLocalUseOnly);
    }
}

simulated function AddWeaponAbilities(XGTacticalGameCoreNativeBase GameCore, Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly = false)
{
    local bool bLog;
    local int Index, iAbilityId, iBackpackIndex;
    local name nmAbilityId;
    local XGCharacter kChar;
    local LWCE_XGInventory kInventory;
    local LWCE_XGTacticalGameCore kGameCore;
    local LWCE_XGWeapon kWeapon, kActiveWeapon;
    local LWCEWeaponTemplate kWeaponTemplate;
    local array<LWCE_XGWeapon> arrWeapons, arrEquippableWeapons;

    bLog = false;
    kChar = m_kCharacter;
    kInventory = LWCE_XGInventory(m_kInventory);
    kGameCore = `LWCE_GAMECORE;

    if (HasPerk(`LW_PERK_ID(SmokeGrenade)) && !kInventory.LWCE_HasItemOfType('Item_SmokeGrenade'))
    {
        kGameCore.nmItemToCreate = 'Item_SmokeGrenade';
        kWeapon = Spawn(class'LWCE_XGWeapon', self, /* SpawnTag */, /* SpawnLocation */, /* SpawnRotation */, /* ActorTemplate */, /* bNoCollisionFail */ true);
        kWeapon.InitFromTemplate('Item_SmokeGrenade');

        m_kInventory.AddItem(kWeapon, eSlot_RearBackPack, /* bMultipleItems */ true);

        if (WorldInfo.NetMode != NM_Standalone && Role == ROLE_Authority)
        {
            m_kDynamicSpawnedSmokeGrenade.m_kDynamicSpawnWeapon = kWeapon;
            m_kDynamicSpawnedSmokeGrenade.m_eDynamicSpawnWeaponSlotLocation = eSlot_RearBackPack;
        }
    }

    if (HasPerk(`LW_PERK_ID(BattleScanner)) && !kInventory.LWCE_HasItemOfType('Item_BattleScanner'))
    {
        kGameCore.nmItemToCreate = 'Item_BattleScanner';
        kWeapon = Spawn(class'LWCE_XGWeapon', self, /* SpawnTag */, /* SpawnLocation */, /* SpawnRotation */, /* ActorTemplate */, /* bNoCollisionFail */ true);
        kWeapon.InitFromTemplate('Item_BattleScanner');

        m_kInventory.AddItem(kWeapon, eSlot_RearBackPack, /* bMultipleItems */ true);

        if (WorldInfo.NetMode != NM_Standalone && Role == ROLE_Authority)
        {
            m_kDynamicSpawnedBattleScanner.m_kDynamicSpawnWeapon = kWeapon;
            m_kDynamicSpawnedBattleScanner.m_eDynamicSpawnWeaponSlotLocation = eSlot_RearBackPack;
        }
    }

    kWeapon = LWCE_XGWeapon(kInventory.FindItemByName('Item_Medikit'));

    if (kWeapon != none)
    {
        if (HasPerk(`LW_PERK_ID(Revive)))
        {
            iAbilityId = eAbility_Revive;
        }
        else
        {
            iAbilityId = eAbility_Stabilize;
        }

        GenerateAbilities(iAbilityId, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
    }

    kActiveWeapon = LWCE_XGWeapon(kInventory.GetActiveWeapon());

    for (Index = 0; Index < eSlot_MAX; Index++)
    {
        if (Index == eSlot_RearBackPack)
        {
            for (iBackpackIndex = 0; iBackpackIndex < kInventory.GetNumberOfItemsInSlot(eSlot_RearBackPack); iBackpackIndex++)
            {
                kWeapon = LWCE_XGWeapon(kInventory.GetItemByIndexInSlot(iBackpackIndex, eSlot_RearBackPack));

                if (kWeapon == none)
                {
                    continue;
                }

                // Skip reloadable weapons that are out of ammo
                if (kWeapon.iAmmo == 0 && kWeapon.HasProperty(eWP_NoReload))
                {
                    continue;
                }

                // Skip overheated weapons
                if (kWeapon.iOverheatChance == 100 && kWeapon.HasProperty(eWP_Overheats))
                {
                    continue;
                }

                if (kWeapon.HasProperty(eWP_Secondary))
                {
                    arrWeapons.AddItem(kWeapon);
                }
                else
                {
                    arrEquippableWeapons.AddItem(kWeapon);
                }
            }
        }
        else
        {
            kWeapon = LWCE_XGWeapon(kInventory.GetItem(ELocation(Index)));

            if (kWeapon == none)
            {
                continue;
            }

            if (kWeapon == kActiveWeapon)
            {
                arrWeapons.AddItem(kWeapon);
            }
            else if (kWeapon.HasProperty(eWP_Secondary))
            {
                arrWeapons.AddItem(kWeapon);
            }
            else
            {
                arrEquippableWeapons.AddItem(kWeapon);
            }
        }
    }

    foreach arrWeapons(kWeapon)
    {
        `LWCE_LOG_CLS("Checking weapon item " $ kWeapon.m_kTemplate.DataName, bLog);
        if (kWeapon.HasProperty(eWP_Sniper))
        {
            if (HasPerk(`LW_PERK_ID(PrecisionShot)))
            {
                GenerateAbilities(eAbility_PrecisionShot, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }

            if (HasPerk(`LW_PERK_ID(DisablingShot)))
            {
                GenerateAbilities(eAbility_DisablingShot, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }
        }

        if (kWeapon.WeaponHasStandardShot())
        {
            // No idea what these two character types are for, maybe some kind of debug
            if (HasPerk(`LW_PERK_ID(Suppression)) || kChar.m_kChar.iType == 67 || kChar.m_kChar.iType == 63)
            {
                if (!kWeapon.HasProperty(eWP_Pistol))
                {
                    iAbilityID = HasPerk(`LW_PERK_ID(Mayhem)) ? eAbility_ShotMayhem : eAbility_ShotSuppress;

                    GenerateAbilities(iAbilityID, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
                }
            }

            if (HasPerk(`LW_PERK_ID(RapidFire)))
            {
                GenerateAbilities(eAbility_RapidFire, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }

            if (HasPerk(`LW_PERK_ID(Flush)) && !kWeapon.HasProperty(eWP_Secondary))
            {
                GenerateAbilities(eAbility_ShotFlush, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }

            if (HasPerk(`LW_PERK_ID(CollateralDamage)))
            {
                GenerateAbilities(eAbility_MEC_Barrage, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }
        }

        // TODO: don't hardcode
        if (kWeapon.m_TemplateName == 'Item_RocketLauncher' || kWeapon.m_TemplateName == 'Item_RecoillessRifle' || kWeapon.m_TemplateName == 'Item_BlasterLauncher')
        {
            if (HasPerk(`LW_PERK_ID(ShredderAmmo)))
            {
                GenerateAbilities(eAbility_ShredderRocket, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }

            if (HasPerk(`LW_PERK_ID(FireRocket)))
            {
                GenerateAbilities(eAbility_RocketLauncher, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }
        }

        // TODO: don't hardcode
        if (kWeapon.m_TemplateName == 'Item_ArcThrower')
        {
            if (HasPerk(`LW_PERK_ID(DroneCapture)))
            {
                GenerateAbilities(eAbility_ShotDroneHack, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }

            if (HasPerk(`LW_PERK_ID(FieldRepairs)))
            {
                GenerateAbilities(eAbility_RepairSHIV, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
            }
        }

        // In the base native code, there's a check for the SHIV Suppression perk here; however in Long War, that perk ID is
        // repurposed and SHIVs just get the regular Suppression check, so that check is omitted.


        // Look at abilities from the weapon's configuration
        kWeaponTemplate = kWeapon.m_kTemplate;
        for (Index = 0; Index < kWeaponTemplate.arrAbilities.Length; Index++)
        {
            nmAbilityId = kWeaponTemplate.arrAbilities[Index];
            iAbilityId = class'LWCE_XGAbilityTree'.static.AbilityBaseIdFromName(nmAbilityId);

            `LWCE_LOG_CLS("Weapon template " $ kWeaponTemplate.DataName $ " has ability " $ nmAbilityId $ ", mapping to ID " $ iAbilityId, bLog);
            if (AbilityIsInList(iAbilityId, arrAbilities))
            {
                continue;
            }

            GenerateAbilities(iAbilityId, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
        }

        // Lastly, check if we need to reload
        if (kWeapon.iAmmo < 100 && !kWeapon.HasProperty(eWP_NoReload))
        {
            GenerateAbilities(eAbility_Reload, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
        }
    }

    // Loop the other array of weapons and generate eAbility_EquipWeapon for them
    foreach arrEquippableWeapons(kWeapon)
    {
        GenerateAbilities(eAbility_EquipWeapon, vLocation, arrAbilities, kWeapon, bForLocalUseOnly);
    }
}

function ApplyInventoryStatModifiers()
{
    local LWCE_TCharacter kChar;
    local name nmEquippedWeapon;
    local XGInventory kInventory;
    local XGWeapon kWeapon;
    local array<name> arrBackPackItems;

    kInventory = GetInventory();

    if (kInventory != none)
    {
        kWeapon = kInventory.GetActiveWeapon();

        if (kWeapon != none)
        {
            nmEquippedWeapon = class'LWCE_XGWeapon_Extensions'.static.GetItemName(kWeapon);
        }
    }

    arrBackPackItems = LWCE_GetCharacter().GetAllBackpackItems();
    m_aCurrentStats[9] = m_aCurrentStats[eStat_HP];
    RemoveStatModifiers(m_aInventoryStats);

    kChar = LWCE_GetCharacter().GetCharacter();
    `LWCE_GAMECORE.LWCE_GetInventoryStatModifiers(m_aInventoryStats, kChar, nmEquippedWeapon, arrBackPackItems);

    if (m_iWillCheatBonus > 0 && IsAI())
    {
        m_aInventoryStats[eStat_HP] += (1 + (m_iWillCheatBonus / 25));
    }

    if (m_iWillCheatBonus > 0)
    {
        m_aInventoryStats[eStat_Will] += (0 + (m_iWillCheatBonus / 10));
    }

    AddStatModifiers(m_aInventoryStats);

    if (m_iWillCheatBonus < 0)
    {
        if (IsAI())
        {
            m_aCurrentStats[eStat_HP] = m_aCurrentStats[9];
            SetUnitHP(m_aCurrentStats[eStat_HP]);
        }
        else if (m_aCurrentStats[eStat_HP] <= 0)
        {
            SetUnitHP(1);
        }
        else
        {
            SetUnitHP(m_aCurrentStats[eStat_HP]);
        }
    }

    m_aCurrentStats[9] = 0;
    SetUnitHP(Min(GetUnitHP(), GetUnitMaxHP()));
    m_aInventoryStats[3] += m_iCovertOpKills;
}

simulated function ApplyLoadout(XGLoadoutInstances kLoadoutInstances, bool bLoadFromCheckpoint)
{
    local int I, J;
    local XGInventoryItem kItemToEquip, kItem;
    local XGInventory kInventory;
    local array<XGWeapon> Weapons;
    local bool bLoadoutIsNew;

    `LWCE_LOG_CLS("ApplyLoadout begin for char type " $ m_kCharacter.m_kChar.iType);

    bLoadoutIsNew = (m_kLoadoutInstances != kLoadoutInstances) || (WorldInfo.NetMode != NM_Standalone);
    m_kLoadoutInstances = kLoadoutInstances;
    m_kLoadoutInstances.m_kUnit = self;

    if (Role == ROLE_Authority && GetInventory() == none)
    {
        kInventory = Spawn(class'LWCE_XGInventory', Owner);
        SetInventory(kInventory);
        kInventory.PostInit();
    }

    kInventory = GetInventory();

    if (kInventory != none)
    {
        for (I = 0; I < eSlot_MAX; I++)
        {
            if (I == eSlot_RearBackPack)
            {
                for (J = 0; J < m_kLoadoutInstances.m_iNumBackpackItems; J++)
                {
                    kItem = m_kLoadoutInstances.m_aBackpackItems[J];

                    if (kItem != none)
                    {
                        if (!bLoadoutIsNew)
                        {
                            kItem.Init();
                        }

                        if (bLoadFromCheckpoint)
                        {
                            kItem.m_kEntity = kItem.CreateEntity();
                        }

                        kInventory.AddItem(kItem, eSlot_RearBackPack, true);
                    }
                }
            }
            else
            {
                if (m_kLoadoutInstances.m_aItems[I] != none)
                {
                    kItem = m_kLoadoutInstances.m_aItems[I];

                    if (!bLoadoutIsNew)
                    {
                        kItem.Init();
                    }

                    if (bLoadFromCheckpoint)
                    {
                        kItem.m_kEntity = kItem.CreateEntity();
                    }
                    else if (kItem.m_kEntity != none)
                    {
                        m_kPawn.UpdateMeshMaterials(XComWeapon(kItem.m_kEntity).Mesh);
                    }

                    kInventory.AddItem(kItem, ELocation(I));
                }
            }
        }

        if (bLoadoutIsNew)
        {
            kInventory.CalculateWeaponToEquip();

            // TODO: fix MEC check
            if (m_kCharacter.m_kChar.iType == eChar_Soldier && m_kCharacter.m_kChar.eClass == eSC_Mec)
            {
                kInventory.GetLargeItems(Weapons);

                for (I = 0; I < Weapons.Length; I++)
                {
                    kInventory.EquipItem(Weapons[I], true, true);
                }

                kInventory.SetActiveWeapon(Weapons[0]);
            }
            else if (kInventory.m_kPrimaryWeapon != none)
            {
                kItemToEquip = kInventory.m_kPrimaryWeapon;
            }
            else if (kInventory.m_kSecondaryWeapon != none)
            {
                kItemToEquip = kInventory.m_kSecondaryWeapon;
            }

            if (kItemToEquip != none)
            {
                kInventory.EquipItem(kItemToEquip, true, true);
            }
        }
    }

    ProcessNewPosition();

    if (WorldInfo.NetMode == NM_Client)
    {
        kLoadoutInstances.ServerDestroy();
    }
    else if (WorldInfo.NetMode == NM_Standalone)
    {
        kLoadoutInstances.Destroy();
    }

    if (GetPawn().IsA('XComHumanPawn') && !IsCivilian())
    {
        XComHumanPawn(GetPawn()).AttachKit();
    }

    if (!bLoadFromCheckpoint)
    {
        LoadoutChanged_UpdateModifiers();

        if (WorldInfo.NetMode == NM_Standalone)
        {
            BuildAbilities();
        }
    }

    `LWCE_LOG_CLS("ApplyLoadout end for char type " $ m_kCharacter.m_kChar.iType);
}

function ApplyStaticHeightBonusStatModifiers()
{
    // This doesn't actually do anything in the base game, but it uses XGItem.GameplayType, so it needs to be removed.
    // It doesn't log as deprecated to avoid having to rewrite the function that calls it.
}

simulated function BeginTurn(optional bool bLoadedFromCheckpoint)
{
    super.BeginTurn(bLoadedFromCheckpoint);

    // TODO: configure default action points as part of the character
    m_arrActionPoints.Length = 0;
    m_arrActionPoints.AddItem('Standard');
    m_arrActionPoints.AddItem('Standard');
}

function BuildAbilities(optional bool bUpdateUI = true)
{
    local bool bShouldBuild;
    local int Index;
    local Vector vLocation;
    local array<XGAbility> arrAbilities;
    local XGTacticalGameCore kGameCore;

    `LWCE_LOG_CLS("BuildAbilities: begin - char type " $ m_kCharacter.m_kChar.iType);
    ScriptTrace();

    bShouldBuild = true;
    kGameCore = `GAMECORE;

    if (Role < ROLE_Authority)
    {
        return;
    }

    if (`WORLDINFO.NetMode != NM_Standalone)
    {
        // TODO: add this if we want multiplayer support
    }

    if (!m_bBuildAbilityDataDirty)
    {
        return;
    }

    if (!bShouldBuild)
    {
        return;
    }

    m_iBuildAbilityNotifier++;
    bNetDirty = true;
    bForceNetUpdate = true;
    m_bBuildAbilityDataDirty = false;

    ClearAbilities();

    if (m_kPawn != none)
    {
        vLocation = m_kPawn.Location;
    }

    AddMoveAbilities(kGameCore, arrAbilities);
    AddWeaponAbilities(kGameCore, vLocation, arrAbilities);
    AddPerkSpecificAbilities(kGameCore, arrAbilities);

    // Not entirely sure about the order on these three
    AddPsiAbilities(vLocation, arrAbilities);
    AddCharacterAbilities(vLocation, arrAbilities);
    AddArmorAbilities(vLocation, arrAbilities);

    // Remove any abilities which shouldn't be shown and are unavailable (doesn't matter for AI)
    if (!IsAI())
    {
        for (Index = arrAbilities.Length - 1; Index >= 0; Index--)
        {
            if (arrAbilities[Index].aDisplayProperties[eDisplayProp_HideUnavailable] != 0 && !arrAbilities[Index].CheckAvailable())
            {
                arrAbilities[Index].Destroy();
                arrAbilities.Remove(Index, 1);
            }
        }
    }

    // Reset m_aAbilities
    for (Index = 0; Index < 64; Index++)
    {
        m_aAbilities[Index] = none;
    }

    for (Index = 0; Index < arrAbilities.Length; Index++)
    {
        m_aAbilities[Index] = arrAbilities[Index];
    }

    m_iNumAbilities = arrAbilities.Length;

    // This part isn't in the native code; in fact I can't find reference to bUpdateUI at all.
    // But our version doesn't work without it.
    if (bUpdateUI)
    {
        UpdateAbilitiesUI();
    }

    UpdateAbilityBreakdowns();
    //`LWCE_LOG_CLS("BuildAbilities: end - char type " $ m_kCharacter.m_kChar.iType);
}

function CalcHitRolls(int ShotIndex, XGAbility_Targeted ShotAbility, XGAction_Fire FireAction)
{
    local int iNewHP[3];
    local XGUnit PrimaryTarget;
    local FiringStateReplicationData FireData;
    local XComUnitPawn TargetPawn;
    local KineticStrikeAttackInfo AttackInfo;
    local Vector TargetLoc;

    PrimaryTarget = ShotAbility.GetPrimaryTarget();

    if (PrimaryTarget == none && ShotAbility.GetType() == eAbility_MEC_KineticStrike)
    {
        TargetLoc = FireAction.GetTargetLoc();
        class'XComWorldData'.static.GetWorldData().GetKineticStrikeInfoFromTargetLocation(GetPawn(), TargetLoc, AttackInfo);
        PrimaryTarget = XGUnit(AttackInfo.AttackUnit);
    }

    if (ShotAbility.GetType() == eAbility_DeathBlossom)
    {
        FireData.m_bKillShot = false;
        FireData.m_bHit = false;
        FireData.m_bCritical = false;
    }
    else
    {
        ShotAbility.RollForHit(FireAction);

        FireData.m_bKillShot = false;
        FireData.m_bHit = ShotAbility.IsHit();
        FireData.m_bCritical = ShotAbility.IsCritical();
    }

    FireData.m_bReflected = ShotAbility.IsReflected();
    FireData.m_iDamage = ShotAbility.GetActualDamage();
    TargetPawn = PrimaryTarget != none ? PrimaryTarget.GetPawn() : none;

    // TODO: tons of this is redundant and should be centralized
    // TODO: replace use of XGCharacter with LWCE_XGCharacter
    if (FireData.m_bHit && ShotAbility.DoesDamage() && !ShotAbility.IsRocketShot())
    {
        if (TargetPawn != none)
        {
            if (ShotAbility.GetType() == eAbility_MEC_KineticStrike)
            {
                iNewHP[1] = PrimaryTarget.AbsorbDamage(FireData.m_iDamage, self, ShotAbility.m_kWeapon);
            }
            else
            {
                iNewHP[1] = FireData.m_iDamage;
            }

            iNewHP[0] = Max(PrimaryTarget.GetUnitHP() + PrimaryTarget.GetShieldHP() - iNewHP[1], 0);

            if (PrimaryTarget.IsShredded())
            {
                iNewHP[0] -= Max((iNewHP[1] * 4) / 10, 1);
            }

            if (HasPerk(`LW_PERK_ID(HEATAmmo)))
            {
                if (!ShotAbility.HasProperty(eProp_Psionic))
                {
                    if (PrimaryTarget.IsVulnerableToElectropulse())
                    {
                        if (ShotAbility.m_kWeapon != none)
                        {
                            if (LWCE_XGWeapon(ShotAbility.m_kWeapon).m_kTemplate.IsLarge())
                            {
                                if (ShotAbility.GetType() == eAbility_MEC_Barrage || ShotAbility.GetType() == eAbility_ShotMayhem)
                                {
                                    iNewHP[0] -= 2;
                                }
                                else
                                {
                                    iNewHP[0] -= Max(2, int(float(ShotAbility.m_kWeapon.GetDamageStat()) * class'XGTacticalGameCore'.default.COUNCIL_FUNDING_MULTIPLIER_HARD));
                                }
                            }
                        }
                    }
                }
            }

            if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(GetCharacter().m_kChar.kInventory, /* Flak Ammo */ 225))
            {
                if (ShotAbility.m_kWeapon != none)
                {
                    if (LWCE_XGWeapon(ShotAbility.m_kWeapon).m_kTemplate.IsLarge())
                    {
                        if (PrimaryTarget.IsFlying())
                        {
                            if (ShotAbility.GetType() != eAbility_Mindfray)
                            {
                                iNewHP[0] -= Max(2, ShotAbility.m_kWeapon.GetDamageStat() * 0.20);
                            }
                        }
                    }
                }
            }

            if (iNewHP[0] <= 0)
            {
                FireData.m_bKillShot = true;
            }
        }
    }

    FireData.m_bCanApplyTracerBeamFX = TargetPawn != none && TargetPawn.CanApplyTracerBeams(ShotAbility, self, PrimaryTarget);

    if (FireAction != none && FireAction.bForceHit)
    {
        FireData.m_bHit = true;
        FireData.m_bKillShot = true;
    }
    else if (FireAction != none && FireAction.bForceMiss)
    {
        FireData.m_bHit = false;
        FireData.m_bKillShot = false;
    }

    FireData.m_bAttackerVisibleToEnemy = IsVisibleToTeam(`BATTLE.GetEnemyPlayer(GetPlayer()).m_eTeam);
    FireData.m_bProjectileWillBeVisibleToEnemy = FireData.m_bAttackerVisibleToEnemy;
    FireData.m_bPlaySuccessfulKillAnimation = FireData.m_bKillShot;
    FireData.m_kTargetActor = PrimaryTarget;
    FireData.m_bTargetActorNone = PrimaryTarget == none;
    FireData.m_kTargetedEnemy = PrimaryTarget;
    FireData.m_bTargetedEnemyNone = PrimaryTarget == none;
    FireData.m_bReplicated = true;

    m_arrFiringStateRepDatas[ShotIndex] = FireData;
}

simulated function bool CanTakeDamage()
{
    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(self))
    {
        return false;
    }

    return super.CanTakeDamage();
}

function CheckForDamagedItems()
{
    local int I, iWeaponFragments;
    local LWCE_XGWeapon kWeapon;

    if (m_bWasKilledByExplosion)
    {
        if (!IsMine() && IsAlien() && !IsExalt())
        {
            `BATTLE.m_kDesc.m_kDropShipCargoInfo.m_bAlienDiedByExplosive = true;
        }
    }

    for (I = 0; I < eSlot_MAX; I++)
    {
        kWeapon = LWCE_XGWeapon(GetInventory().GetItem(ELocation(I)));

        if (kWeapon == none)
        {
            continue;
        }

        if (!IsMine() && !m_bWasKilledByExplosion)
        {
            iWeaponFragments = `LWCE_GAMECORE.LWCE_GenerateWeaponFragments(kWeapon.m_TemplateName);

            if (iWeaponFragments > 0)
            {
                PRES().MSGWeaponFragments(kWeapon.m_kTemplate.strName, iWeaponFragments);
                LWCE_XGBattleDesc(`BATTLE.m_kDesc).m_kArtifactsContainer.AdjustQuantity('Item_WeaponFragment', iWeaponFragments);
                kWeapon.m_bDamaged = true;
            }
        }

        if (m_bWasKilledByExplosion)
        {
            kWeapon.m_bDamaged = true;

            if (IsExalt() && WorldInfo.NetMode == NM_Standalone)
            {
                if (kWeapon.m_kTemplate.IsLarge())
                {
                    PRES().MSGItemDestroyed(kWeapon.m_kTemplate.strName);
                }
            }
        }
    }
}

function CreateCheckpointRecord()
{
    local LWCE_XComHumanPawn HumanPawn;

    if (m_kPawn != none)
    {
        m_ePawnOpenCloseState = m_kPawn.m_eOpenCloseState;
        HumanPawn = LWCE_XComHumanPawn(m_kPawn);

        if (HumanPawn != none)
        {
            m_kCESavedAppearance = HumanPawn.m_kCEAppearance;
        }
    }
}

simulated function DebugAnims(int kCanvas, XComTacticalCheatManager kCheatManager)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function DebugAnims was called. This needs to be replaced with InitUnitUpgrades. Stack trace follows.");
    ScriptTrace();
}

simulated function DebugCoverActors(XComTacticalCheatManager kCheatManager)
{
    local XGInventoryItem kItem;
    local LWCEWeaponTemplate kWeaponTemplate;
    local int iItemIndex, iSlotIndex;

    for (iSlotIndex = 0; iSlotIndex < eSlot_MAX; iSlotIndex++)
    {
        for (iItemIndex = 0; iItemIndex < GetInventory().GetNumberOfItemsInSlot(ELocation(iSlotIndex)); iItemIndex++)
        {
            kItem = GetInventory().GetItemByIndexInSlot(iItemIndex, ELocation(iSlotIndex));

            if (kItem != none)
            {
                kWeaponTemplate = `LWCE_WEAPON(class'LWCE_XGWeapon_Extensions'.static.GetItemName(kItem));

                if (kWeaponTemplate.HasWeaponProperty(eWP_Pistol))
                {
                    kItem.m_eReservedSlot = eSlot_RightThigh;
                }
                else if (kWeaponTemplate.HasWeaponProperty(eWP_Heavy))
                {
                    kItem.m_eReservedSlot = eSlot_LeftBack;
                }
                else if (kWeaponTemplate.HasWeaponProperty(eWP_Mec))
                {
                    kItem.m_eReservedSlot = ELocation(iSlotIndex);
                }
                else if (kWeaponTemplate.IsLarge())
                {
                    kItem.m_eReservedSlot = eSlot_RightBack;
                }
                else
                {
                    kItem.m_eReservedSlot = ELocation(iSlotIndex);
                }
            }
        }
    }
}

simulated function DrawRangesForMedikit(optional bool bDetach = true)
{
    local XGSquad kSquad;
    local XGUnit kUnit;
    local LWCEWeaponTemplate kMedikit;
    local int I;
    local float fRadius;
    local LWCE_XGInventory kInventory;

    kInventory = LWCE_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.LWCE_HasItemOfType('Item_Medikit'))
    {
        return;
    }

    if (GetMediKitCharges() > 0)
    {
        kSquad = GetSquad();
        kMedikit = `LWCE_WEAPON('Item_Medikit');
        fRadius = float(kMedikit.iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (kUnit != self && kUnit.CanBeHealedWithMedikit() && kUnit.IsVisible() && !kUnit.IsDead() && kUnit.GetPawn() != none && !`GAMECORE.CharacterHasProperty(kUnit.m_kCharacter.m_kChar.iType, eCP_Robotic))
            {
                kUnit.GetPawn().AttachRangeIndicator(2.0 * fRadius, kUnit.GetPawn().MedikitRing);
            }
            else if (bDetach && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().DetachRangeIndicator();
            }
        }
    }
}

simulated function DrawRangesForRevive(optional bool bDetach = true)
{
    local XGSquad kSquad;
    local XGUnit kUnit;
    local int I;
    local float fRadius;
    local LWCE_XGInventory kInventory;

    kInventory = LWCE_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.LWCE_HasItemOfType('Item_Medikit'))
    {
        return;
    }

    if (GetMediKitCharges() > 0)
    {
        kSquad = GetSquad();
        fRadius = float(`GAMECORE.m_kAbilities.GetTAbility(eAbility_Stabilize).iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (kUnit != self && !kUnit.IsDead() && kUnit.IsVisible() && kUnit.GetPawn() != none && kUnit.IsCriticallyWounded() && !`GAMECORE.CharacterHasProperty(kUnit.m_kCharacter.m_kChar.iType, eCP_Robotic))
            {
                kUnit.GetPawn().AttachRangeIndicator(2.0 * fRadius, kUnit.GetPawn().MedikitRing);
            }
            else if (bDetach && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().DetachRangeIndicator();
            }
        }
    }
}

simulated function DrawRangesForRepairSHIV(optional bool bDetach)
{
    local XGSquad kSquad;
    local XGUnit kUnit;
    local int I;
    local float fRadius;
    local LWCE_XGInventory kInventory;
    local XGWeapon kItem;
    local bool bHasRepair;

    bDetach = true;
    kInventory = LWCE_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.LWCE_HasItemOfType('Item_ArcThrower'))
    {
        return;
    }

    if (GetArcThrowerCharges() > 0)
    {
        kItem = XGWeapon(kInventory.FindItemByName('Item_ArcThrower'));
        bHasRepair = false;

        for (I = 0; I < class'XGWeapon'.const.NUM_WEAP_ABILITIES; I++)
        {
            if (kItem.aAbilities[I] == eAbility_RepairSHIV)
            {
                bHasRepair = true;
                break;
            }
        }

        if (!bHasRepair)
        {
            return;
        }

        kSquad = GetSquad();
        fRadius = float(`GAMECORE.m_kAbilities.GetTAbility(eAbility_RepairSHIV).iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (kUnit != self
              && (`GAMECORE.CharacterHasProperty(kUnit.m_kCharacter.m_kChar.iType, eCP_Robotic) || kUnit.IsAugmented())
              && kUnit.GetUnitHP() < kUnit.GetUnitMaxHP()
              && kUnit.IsVisible()
              && !kUnit.IsDead()
              && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().AttachRangeIndicator(2.0 * fRadius, kUnit.GetPawn().MedikitRing);
            }
            else if (bDetach && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().DetachRangeIndicator();
            }
        }
    }
}

simulated function DrawRangesForShotStun(optional XCom3DCursor kCursor = none, optional bool bDetach = true)
{
    local XGSquad kSquad;
    local XGUnit kUnit;
    local int I;
    local float fRadius;
    local LWCE_XGInventory kInventory;

    kInventory = LWCE_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.LWCE_HasItemOfType('Item_ArcThrower'))
    {
        return;
    }

    if (GetArcThrowerCharges() > 0)
    {
        kSquad = `BATTLE.GetEnemyPlayer(GetPlayer()).GetSquad();

        // FIXME: Not sure why this is using eAbility_RepairSHIV instead of eAbility_ShotStun. They probably match in the
        // base game, but we should change this at some point for clarity's sake and easier modding.
        fRadius = float(`GAMECORE.m_kAbilities.GetTAbility(eAbility_RepairSHIV).iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (`GAMECORE.CanBeStunned(kUnit) && kUnit.IsVisible() && kUnit.IsAliveAndWell() && kUnit.GetPawn() != none)
            {
                if (kCursor == none || VSize(kCursor.Location - kUnit.GetPawn().Location) <= float(400))
                {
                    kUnit.GetPawn().AttachRangeIndicator(2.0 * fRadius, kUnit.GetPawn().ArcThrowerRing);
                }
                else if (bDetach)
                {
                    kUnit.GetPawn().DetachRangeIndicator();
                }
            }
            else if (bDetach && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().DetachRangeIndicator();
            }
        }
    }
}

simulated function DrawRangesForDroneHack(optional XCom3DCursor kCursor = none, optional bool bDetach = true)
{
    local XGSquad kSquad;
    local XGUnit kUnit;
    local int I;
    local float fRadius;
    local LWCE_XGInventory kInventory;
    local bool bHasHack;
    local XGWeapon kItem;

    kInventory = LWCE_XGInventory(GetInventory());

    if (kInventory == none || !kInventory.LWCE_HasItemOfType('Item_ArcThrower'))
    {
        return;
    }

    if (GetArcThrowerCharges() > 0)
    {
        kItem = XGWeapon(kInventory.FindItemByName('Item_ArcThrower'));
        bHasHack = false;

        for (I = 0; I < class'XGWeapon'.const.NUM_WEAP_ABILITIES; I++)
        {
            if (kItem.aAbilities[I] == eAbility_ShotDroneHack)
            {
                bHasHack = true;
                break;
            }
        }

        if (!bHasHack)
        {
            return;
        }

        kSquad = `BATTLE.GetEnemyPlayer(GetPlayer()).GetSquad();
        fRadius = float(`GAMECORE.m_kAbilities.GetTAbility(eAbility_ShotDroneHack).iRange * 64);

        for (I = 0; I < kSquad.GetNumMembers(); I++)
        {
            kUnit = kSquad.GetMemberAt(I);

            if (kUnit.m_kCharacter.m_kChar.iType == eChar_Drone && kUnit.IsVisible() && kUnit.IsAliveAndWell() && kUnit.GetPawn() != none)
            {
                if (kCursor == none || VSize(kCursor.Location - kUnit.GetPawn().Location) <= float(400))
                {
                    kUnit.GetPawn().AttachRangeIndicator(2.0 * fRadius, kUnit.GetPawn().ArcThrowerRing);
                }
                else if (bDetach)
                {
                    kUnit.GetPawn().DetachRangeIndicator();
                }
            }
            else if (bDetach && kUnit.GetPawn() != none)
            {
                kUnit.GetPawn().DetachRangeIndicator();
            }
        }
    }
}

simulated function GenerateAbilities(int iAbility, Vector vLocation, out array<XGAbility> arrAbilities, optional XGWeapon kWeapon, optional bool bForLocalUseOnly = false)
{
    // Based on reconstruction of the native GenerateAbilities
    local bool bIsPsionic, bIsValidTarget, bHasCustomRange, bTargetIsCriticallyWounded, bTargetNonRobotic, bTargetRobotic;
    local float fCustomRange;
    local int Index;
    local EAbilityRange eRange;
    local TAbility kTAbility;
    local XGAbility kAbility;
    local XGAbilityTree kAbilityTree;
    local XGTacticalGameCore kGameCore;
    local array<XGUnitNativeBase> arrPotentialTargets;
    local array<XGUnit> arrActualTargets;

    fCustomRange = 0.0;
    kGameCore = `GAMECORE;
    kAbilityTree = kGameCore.m_kAbilities;
    kTAbility = kAbilityTree.GetTAbility(iAbility);
    eRange = EAbilityRange(kTAbility.iRange);

    if (GenerateAbilities_CheckForFlyAbility(iAbility, arrAbilities, kGameCore))
    {
        return;
    }

    if (GenerateAbilities_CheckForCloseAbility(iAbility, arrAbilities, kGameCore))
    {
        return;
    }

    if (iAbility == eAbility_ShotStandard)
    {
        GenerateAbilityFromTemplate('StandardShot', arrAbilities, kWeapon);
        return;
    }

    bIsPsionic = kAbilityTree.AbilityHasProperty(iAbility, eProp_Psionic);
    bHasCustomRange = kAbilityTree.AbilityHasProperty(iAbility, eProp_CustomRange);
    bTargetNonRobotic = kAbilityTree.AbilityHasProperty(iAbility, eProp_TargetNonRobotic);
    bTargetRobotic = kAbilityTree.AbilityHasProperty(iAbility, eProp_TargetRobotic);

    if (bIsPsionic)
    {
        bTargetNonRobotic = true;
    }

    if (bHasCustomRange)
    {
        fCustomRange = 64.0 * kTAbility.iRange;
    }

    if (iAbility == eAbility_ShotStandard && IsMeleeOnly())
    {
        eRange = eRange_Weapon;
    }

    if (kWeapon != none && kWeapon.HasProperty(eWP_Sniper) && eRange == eRange_Sight && HasPerk(`LW_PERK_ID(Squadsight)))
    {
        eRange = eRange_Squadsight;
    }

    GetTargetsInRange(kTAbility.iTargetType, eRange, arrPotentialTargets, vLocation, kWeapon, fCustomRange, /* bNoLOSRequired */ false, bTargetNonRobotic, bTargetRobotic, iAbility);

    for (Index = arrPotentialTargets.Length - 1; Index >=  0; Index--)
    {
        // Don't allow suppressing targets that aren't activated yet
        if (arrPotentialTargets[Index].m_kBehavior != none && arrPotentialTargets[Index].m_kBehavior.IsDormant(/* bFalseIfActivating */ false) && kAbilityTree.AbilityHasEffect(iAbility, eEffect_Suppression))
        {
            bIsValidTarget = false;
        }
        else
        {
            bIsValidTarget = true;
        }

        if (arrPotentialTargets[Index].m_bStunned || !bIsValidTarget)
        {
            arrPotentialTargets.Remove(Index, 1);
        }
        else
        {
            arrActualTargets.AddItem(XGUnit(arrPotentialTargets[Index]));
        }
    }

    if (kTAbility.iTargetType == eTarget_MultipleAllies ||
        kTAbility.iTargetType == eTarget_MultipleEnemies ||
        kTAbility.iTargetType == eTarget_SectoidAllies ||
        kTAbility.iTargetType == eTarget_MutonAllies)
    {
        // Abilities that target multiple things: just create the ability once, with all targets
        kAbility = kAbilityTree.SpawnAbility(iAbility, self, arrActualTargets, kWeapon, /* kMiscActor */ none, bForLocalUseOnly, /* bReactionFire */ false);
        arrAbilities.AddItem(kAbility);
    }
    else
    {
        arrActualTargets.Length = 1;

        for (Index = 0; Index < arrPotentialTargets.Length; Index++)
        {
            // TODO: not sure why this isn't just checked at the start of the function
            if (HasPerk(`LW_PERK_ID(Revive)) && kTAbility.iType == eAbility_Stabilize)
            {
                continue;
            }

            bTargetIsCriticallyWounded = arrPotentialTargets[Index].IsCriticallyWounded();

            // TODO: this is weirdly specific to psi panic, probably redundant with many other checks
            if (iAbility == eAbility_PsiPanic)
            {
                if (bTargetIsCriticallyWounded || !arrPotentialTargets[Index].IsAlive() || arrPotentialTargets[Index].IsPossessed())
                {
                    continue;
                }
            }

            if (kTAbility.aProperties[eProp_TargetCritical] != 0 && !bTargetIsCriticallyWounded)
            {
                continue;
            }

            if (!kAbilityTree.AbilityHasEffect(eEffect_Damage, iAbility) && arrPotentialTargets[Index].IsAnimal())
            {
                continue;
            }

            arrActualTargets[0] = XGUnit(arrPotentialTargets[Index]);
            kAbility = kAbilityTree.SpawnAbility(iAbility, self, arrActualTargets, kWeapon, /* kMiscActor */ none, bForLocalUseOnly, /* bReactionFire */ false);
            arrAbilities.AddItem(kAbility);
        }
    }

    // If we still haven't generated the ability, do it now without any targets
    if (!AbilityIsInList(iAbility, arrAbilities))
    {
        // In the native version, the array length is still 1 but arrUnknown[0] = none
        arrActualTargets.Length = 1;
        arrActualTargets[0] = none;
        kAbility = kAbilityTree.SpawnAbility(iAbility, self, arrActualTargets, kWeapon, /* kMiscActor */ none, bForLocalUseOnly, /* bReactionFire */ false);
        arrAbilities.AddItem(kAbility);
    }
}

simulated function bool GenerateAbilities_CheckForCloseAbility(int iAbility, out array<XGAbility> arrAbilities, XGTacticalGameCoreNativeBase GameCore)
{
    local XGAbility kAbility;
    local array<XGUnit> arrTargets;

    if (iAbility != eAbility_CloseCyberdisc)
    {
        return false;
    }

    if (m_kCharacter == none || m_kCharacter.m_kChar.iType != eChar_Cyberdisc)
    {
        return true;
    }

    if (m_kPawn.m_eOpenCloseState != eUP_Open)
    {
        return true;
    }

    if (FindAbility(eAbility_CloseCyberdisc, /* kTarget */ none) != none)
    {
        return true;
    }

    arrTargets.AddItem(self);

    kAbility = `GAMECORE.m_kAbilities.SpawnAbility(eAbility_CloseCyberdisc, self, arrTargets, /* kWeapon */ none, /* kMiscActor */ none, /* bForLocalUseOnly */ false, /* bReactionFire */ false);
    arrAbilities.AddItem(kAbility);

    return true;
}

simulated function bool GenerateAbilities_CheckForFlyAbility(int iAbility, out array<XGAbility> arrAbilities, XGTacticalGameCoreNativeBase GameCore)
{
    local int Index;
    local XGAbility kAbility;
    local array<XGUnit> arrTargets;

    if (iAbility != eAbility_Fly)
    {
        return false;
    }

    for (Index = 0; Index < arrAbilities.Length; Index++)
    {
        if (arrAbilities[Index].IsA('XGAbility_Fly'))
        {
            return true;
        }
    }

    arrTargets.AddItem(self);

    kAbility = `GAMECORE.m_kAbilities.SpawnAbility(eAbility_Fly, self, arrTargets, /* kWeapon */ none, /* kMiscActor */ none, /* bForLocalUseOnly */ false, /* bReactionFire */ false);
    arrAbilities.AddItem(kAbility);

    return true;
}

function LWCE_XGAbility GenerateAbilityFromTemplate(name nmAbility, out array<XGAbility> arrAbilities, XGWeapon kWeapon)
{
    local LWCE_XGAbility kAbility;

    `LWCE_LOG_CLS("Generating template ability with name " $ nmAbility);

    kAbility = Spawn(class'LWCE_XGAbility', self);
    kAbility.m_kUnit = self;
    kAbility.LWCE_Init(nmAbility, kWeapon);

    arrAbilities.AddItem(kAbility);

    // TODO: temporary way to get abilities into the right array permanently
    if (!HasAbility(nmAbility))
    {
        m_arrAbilities.AddItem(kAbility);
    }

    return kAbility;
}

simulated function int GetAggressionBonus()
{
    return Clamp(`LWCE_TACCFG(iAggressionCritChanceBonusPerVisibleEnemy) * m_arrVisibleEnemies.Length, 0, `LWCE_TACCFG(iAggressionMaximumBonus));
}

simulated function array<int> GetBonusesPerkList()
{
    m_iNumOfBonuses = m_arrCEBonuses.Length;
    return m_arrCEBonuses;
}

simulated function int GetCharType()
{
    return LWCE_GetCharacter().GetCharacterType();
}

simulated function array<EItemType_Info> GetItemInfos()
{
    local LWCE_XGInventory kInventory;

    if (!m_bCheckedItemInfos)
    {
        m_bCheckedItemInfos = true;
        kInventory = LWCE_XGInventory(GetInventory());

        if (kInventory != none)
        {
            if (kInventory.LWCE_HasItemOfType('Item_MindShield'))
            {
                m_arrItemInfos.AddItem(1);
            }

            if (kInventory.LWCE_HasItemOfType('Item_ChitinPlating'))
            {
                m_arrItemInfos.AddItem(2);
            }

            if (kInventory.LWCE_HasItemOfType('Item_SCOPE'))
            {
                m_arrItemInfos.AddItem(3);
            }

            if (kInventory.LWCE_HasItemOfType('Item_ReaperPack'))
            {
                m_arrItemInfos.AddItem(4);
            }

            if (kInventory.LWCE_HasItemOfType('Item_RespiratorImplant'))
            {
                m_arrItemInfos.AddItem(5);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_AlloyJacketedRounds'))
            {
                m_arrItemInfos.AddItem(14);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_EnhancedBeamOptics'))
            {
                m_arrItemInfos.AddItem(15);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_PlasmaStellerator'))
            {
                m_arrItemInfos.AddItem(16);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_LaserSight'))
            {
                m_arrItemInfos.AddItem(17);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_CeramicPlating'))
            {
                m_arrItemInfos.AddItem(18);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_HiCapMags'))
            {
                m_arrItemInfos.AddItem(19);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_BattleComputer'))
            {
                m_arrItemInfos.AddItem(20);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_ChameleonSuit'))
            {
                m_arrItemInfos.AddItem(21);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_HoloTargeter'))
            {
                m_arrItemInfos.AddItem(22);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_SmartshellPod'))
            {
                m_arrItemInfos.AddItem(23);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_CoreArmoring'))
            {
                m_arrItemInfos.AddItem(24);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_TheThumper'))
            {
                m_arrItemInfos.AddItem(25);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_ImpactVest'))
            {
                m_arrItemInfos.AddItem(26);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_FuelCell'))
            {
                m_arrItemInfos.AddItem(27);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_AlloyBipod'))
            {
                m_arrItemInfos.AddItem(28);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_BreachingAmmo'))
            {
                m_arrItemInfos.AddItem(29);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_ArmorPiercingAmmo'))
            {
                m_arrItemInfos.AddItem(30);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_WalkerServos'))
            {
                m_arrItemInfos.AddItem(31);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_NeuralGunlink'))
            {
                m_arrItemInfos.AddItem(32);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_ShredderAmmo'))
            {
                m_arrItemInfos.AddItem(33);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_PsiScreen'))
            {
                m_arrItemInfos.AddItem(34);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_IlluminatorGunsight'))
            {
                m_arrItemInfos.AddItem(35);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_IncineratorModule'))
            {
                m_arrItemInfos.AddItem(36);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_TargetingModule'))
            {
                m_arrItemInfos.AddItem(37);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_ReinforcedArmor'))
            {
                m_arrItemInfos.AddItem(38);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_EleriumTurbos'))
            {
                m_arrItemInfos.AddItem(39);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_CognitiveEnhancer'))
            {
                m_arrItemInfos.AddItem(40);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_Neuroregulator'))
            {
                m_arrItemInfos.AddItem(41);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_FlakAmmo'))
            {
                m_arrItemInfos.AddItem(42);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_AlloyPlating'))
            {
                m_arrItemInfos.AddItem(43);
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_DrumMags'))
            {
                m_arrItemInfos.AddItem(44);
            }
        }
    }

    return m_arrItemInfos;
}

simulated function array<int> GetPassivePerkList()
{
    local array<int> arr;

    if (`GAMECORE.m_kAbilities.HasAutopsyTechForChar(LWCE_GetCharacter().GetCharacterType()))
    {
        arr = m_arrCEPassives;
    }
    else
    {
        arr.AddItem(ePerk_AutopsyRequired);
    }

    return arr;
}

simulated function array<int> GetPenaltiesPerkList()
{
    m_iNumOfPenalties = m_arrCEPenalties.Length;
    return m_arrCEPenalties;
}

simulated function int GetMoveModifierCost(optional int bFlying = 0, optional int bIgnorePoison = 0)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetMoveModifierCost was called. This needs to be replaced with LWCEWeaponTemplate.CalcAoERange. Stack trace follows.");
    ScriptTrace();

    return -100;
}

simulated function int GetOffense()
{
    local int iAim;
    local LWCE_TCharacterStats kStatChanges;
    local LWCEWeaponTemplate kWeapon;
    local LWCE_XGTacticalGameCore kGameCore;

    iAim = m_aCurrentStats[eStat_Offense];
    kGameCore = `LWCE_GAMECORE;

    if (GetInventory().GetActiveWeapon() == none)
    {
        return iAim;
    }

    kWeapon = `LWCE_WEAPON_FROM_XG(GetInventory().GetActiveWeapon());

    // The weapon's aim is already included in m_aCurrentStats, so we have to remove it here
    kWeapon.GetStatChanges(kStatChanges, LWCE_GetCharacter().GetCharacter());
    iAim -= kStatChanges.iAim;

    if (IsBeingSuppressed())
    {
        iAim -= `LWCE_TACCFG(iSuppressionAimPenalty);
    }

    if (IsPoisoned())
    {
        // TODO move this to LWCE config
        iAim -= kGameCore.POISONED_AIM_PENALTY;
    }

    return iAim;
}

simulated function int GetTacticalSenseCoverBonus()
{
    if (!HasPerk(`LW_PERK_ID(TacticalSense)))
    {
        return 0;
    }

    return Clamp(`LWCE_TACCFG(iTacticalSenseDefenseBonusPerVisibleEnemy) * m_arrVisibleEnemies.Length, 0, `LWCE_TACCFG(iTacticalSenseMaximumBonus));
}

simulated function GetTargetsInRange(int iTargetType, int iRangeType, out array<XGUnitNativeBase> arrTargets, Vector vLocation, optional XGWeapon kWeapon, optional float fCustomRange = 0.0, optional bool bNoLOSRequired, optional bool bSkipRoboticUnits = false, optional bool bSkipNonRoboticUnits = false, optional int eType = 0)
{
    local LWCE_XGWeapon kCEWeapon;
    local array<float> arrTargets_HeightBonusModifier, arrDistToTargetSq;
    local float fRange;
    local bool bHealing, bMindMerge;
    local int iCharFilter;

    arrTargets.Remove(0, arrTargets.Length);
    arrDistToTargetSq.Remove(0, arrDistToTargetSq.Length);
    kCEWeapon = LWCE_XGWeapon(kWeapon);
    bHealing = kCEWeapon != none && (kCEWeapon.m_TemplateName == 'Item_Medikit' || kCEWeapon.m_TemplateName == 'Item_RestorativeMist'); // TODO: don't hardcode
    bMindMerge = eType == eAbility_MindMerge || eType == eAbility_GreaterMindMerge;

    if (iTargetType == eTarget_Self)
    {
        arrTargets.AddItem(self);
        return;
    }
    else if (iTargetType == eTarget_Location)
    {
        // TODO: don't hardcode
        if ( kCEWeapon != none && (kCEWeapon.m_TemplateName == 'Item_RocketLauncher' || kCEWeapon.m_TemplateName == 'Item_RecoillessRifle' || kCEWeapon.m_TemplateName == 'Item_BlasterLauncher') )
        {
            DetermineEnemiesInSight(arrTargets, arrDistToTargetSq, vLocation, bSkipRoboticUnits, bSkipNonRoboticUnits);
        }

        return;
    }

    switch (iTargetType)
    {
        case eTarget_SingleDeadAlly:
            DetermineDeadAllies(arrTargets, arrDistToTargetSq, vLocation);
            break;
        case eTarget_SingleAlly:
        case eTarget_SingleAllyOrSelf:
        case eTarget_MultipleAllies:
        case eTarget_SectoidAllies:
        case eTarget_MutonAllies:
            if (iTargetType == eTarget_SectoidAllies || eType == eAbility_MindMerge)
            {
                if (IsAI())
                {
                    iCharFilter = 1 << eChar_Sectoid;
                }
                else
                {
                    iCharFilter = 1 << eChar_Soldier;
                }
            }

            if (iTargetType == eTarget_MutonAllies)
            {
                iCharFilter = (1 << eChar_Muton) | (1 << eChar_MutonBerserker) | (1 << eChar_MutonElite);
            }

            if (eType == 41) // Command
            {
                iCharFilter = 1;
            }

            if (fCustomRange != 0.0f)
            {
                DetermineFriendsInRange(fCustomRange, false, arrTargets, arrDistToTargetSq, vLocation, iCharFilter, bSkipRoboticUnits, bSkipNonRoboticUnits, bHealing, bMindMerge);
            }
            else
            {
                switch (iRangeType)
                {
                    case eRange_Weapon:
                        if (kCEWeapon != none)
                        {
                            fRange = class'LWCE_XGWeapon_Extensions'.static.LongRange(kCEWeapon) + float(m_aCurrentStats[eStat_WeaponRange]);
                            DetermineFriendsInRange(fRange, false, arrTargets, arrDistToTargetSq, vLocation, iCharFilter, bSkipRoboticUnits, bSkipNonRoboticUnits, bHealing, bMindMerge);
                        }

                        break;
                    case eRange_Sight:
                        DetermineFriendsInRange(-1.0, false, arrTargets, arrDistToTargetSq, vLocation, iCharFilter, bSkipRoboticUnits, bSkipNonRoboticUnits, bHealing, bMindMerge);
                        break;
                    case eRange_SquadSight:
                    case eRange_Unlimited:
                        DetermineFriendsInRange(-1.0, true, arrTargets, arrDistToTargetSq, vLocation, iCharFilter, bSkipRoboticUnits, bSkipNonRoboticUnits, bHealing, bMindMerge);
                        break;
                    default:
                        break;
                }
            }

            if (iTargetType == eTarget_SingleAllyOrSelf)
            {
                if (bHealing && CanBeHealedWithMedikit())
                {
                    arrTargets.AddItem(self);
                    arrDistToTargetSq.AddItem(0.0);
                }
            }

            break;

        case eTarget_SingleDeadEnemy:
            DetermineDeadEnemies(arrTargets, arrDistToTargetSq, vLocation);
            break;
        case eTarget_SingleEnemy:
        case eTarget_MultipleEnemies:
            if (fCustomRange != 0.0f)
            {
                DetermineEnemiesInRangeByWeapon(kCEWeapon, fCustomRange, arrTargets, arrTargets_HeightBonusModifier, arrDistToTargetSq, vLocation, bSkipRoboticUnits, bSkipNonRoboticUnits);

                if (eType == eAbility_ShotStun)
                {
                    FilterStunTargets(arrTargets);
                }
            }
            else
            {
                switch (iRangeType)
                {
                    case eRange_Weapon:
                        DetermineEnemiesInRangeByWeapon(kCEWeapon, 0.0, arrTargets, arrTargets_HeightBonusModifier, arrDistToTargetSq, vLocation, bSkipRoboticUnits, bSkipNonRoboticUnits);
                        break;
                    case eRange_Sight:
                        DetermineEnemiesInSight(arrTargets, arrDistToTargetSq, vLocation, bSkipRoboticUnits, bSkipNonRoboticUnits, EAbility(eType));
                        break;
                    case eRange_SquadSight:
                        DetermineEnemiesInSquadSight(arrTargets, vLocation, !bNoLOSRequired, bSkipRoboticUnits, bSkipNonRoboticUnits, EAbility(eType));
                        break;
                    case eRange_Unlimited:
                        DetermineAllEnemies(arrTargets, arrDistToTargetSq, vLocation, bSkipRoboticUnits, bSkipNonRoboticUnits);
                        break;
                    default:
                        break;
                }
            }

            break;
    }
}

simulated function int GetUnitMaxHP()
{
    return LWCE_GetCharacter().GetCharacter().aStats[eStat_HP];
}

simulated function int GetMaxShieldHP()
{
    return LWCE_GetCharacter().GetCharacter().aStats[eStat_ShieldHP];
}

function bool HasAttackableCivilians(optional out XGUnitNativeBase kUnit_Out)
{
    local XGUnit kUnit;

    foreach m_arrCiviliansInRange(kUnit)
    {
        if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kUnit))
        {
            continue;
        }

        if (kUnit.IsAliveAndWell())
        {
            kUnit_Out = kUnit;
            return true;
        }
    }

    return false;
}

function bool HasAttackableEnemies(optional out XGUnitNativeBase kUnit_Out)
{
    local UnitDirectionInfo kEnemyVisInfo;

    foreach m_arrUnitDirectionInfos(kEnemyVisInfo)
    {
        if (kEnemyVisInfo.bVisible && kEnemyVisInfo.TargetUnit.IsAliveAndWell() && kEnemyVisInfo.TargetUnit.m_eTeam != m_eTeam)
        {
            if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kEnemyVisInfo.TargetUnit))
            {
                continue;
            }

            if (IsMeleeOnly())
            {
                if (IsInMeleeRange(kEnemyVisInfo.TargetUnit))
                {
                    kUnit_Out = kEnemyVisInfo.TargetUnit;
                    return true;
                }

                continue;
            }

            kUnit_Out = kEnemyVisInfo.TargetUnit;
            return true;
        }
    }

    return false;
}

simulated function bool HasBonuses()
{
    local int I;

    for (I = 0; I < m_arrCEBonuses.Length; I++)
    {
        if (m_arrCEBonuses[I] == `LW_PERK_ID(Hardened) ||
            m_arrCEBonuses[I] == `LW_PERK_ID(LegioPatriaNostra) ||
            m_arrCEBonuses[I] == `LW_PERK_ID(BandOfWarriors) ||
            m_arrCEBonuses[I] == `LW_PERK_ID(EspritDeCorps))
        {
            continue;
        }

        // Any other bonus counts
        return true;
    }

    return false;
}

simulated function bool HasHandledMoraleEventThisTurn(EMoraleEvent eEvent)
{
    local int Index;

    for (Index = 0; Index < m_arrMoraleEventsThisTurn.Length; Index++)
    {
        if (m_arrMoraleEventsThisTurn[Index] == eEvent)
        {
            return true;
        }
    }

    return false;
}

function bool Init(XGPlayer kPlayer, XGCharacter kNewChar, XGSquad kSquad, optional bool bDestroyOnBadLocation = false, optional bool bSnapToGround = true)
{
    local LWCE_TCharacter kChar;

    super(XGUnitNativeBase).Init(kPlayer, kNewChar, kSquad, bDestroyOnBadLocation);

    m_kReplicatedOwner = Owner;

    m_kCharacter = kNewChar;
    m_kCharacter.InitTCharacter();

    kChar = LWCE_GetCharacter().GetCharacter();
    AddStatModifiers(kChar.aStats);

    `LWCE_LOG_CLS("Character " $ m_kCharacter.GetFullName() $ " stats: HP = " $ kChar.aStats[eStat_HP] $ "; aim = " $ kChar.aStats[eStat_Offense] $ "; mobility = " $ kChar.aStats[eStat_Mobility]);

    m_aCurrentStats[eStat_ShieldHP] = 0;
    m_kPlayer = kPlayer;

    ResetUseAbilities();
    ResetMoves();
    ResetReaction();
    ResetTurnActions();

    m_bCanOpenWindowsAndDoors = m_kCharacter.m_bCanOpenWindowsAndDoors;

    SetIdleState(eIdle_Normal);
    SpawnPawn(bSnapToGround);

    if (m_kPawn == none)
    {
        return false;
    }

    if (bDestroyOnBadLocation && DestroyOnBadLocation())
    {
        return false;
    }

    kSquad.AddUnit(self, m_bBattleScanner);

    if (IsAI())
    {
        InitBehavior();

        if (`BATTLE.m_kDesc.m_iMissionType == eMission_Final)
        {
            // Every enemy on the Temple Ship is L8
            InitUnitUpgrades(8);
        }
        else if (`BATTLE.m_kDesc.m_iMissionType == eMission_HQAssault)
        {
            // Leaders appear to be rolled specially on base defense missions
            if (Rand(100) > ((`BATTLE.STAT_GetStat(1) - 250) / 10))
            {
                InitUnitUpgrades(Clamp(Rand(`BATTLE.STAT_GetStat(1) / 64), 1, 7));
            }
        }
    }

    if (m_kCharacter.m_kChar.iType == eChar_Zombie)
    {
        m_bHasChryssalidEgg = true;
    }

    m_iRepairServosHPLeft = 6;

    SetDiscState(eDS_None);
    CreateUnitView();
    AddIdleAction();

    m_iLowestHP = GetUnitHP();

    return true;
}

simulated function InitUnitUpgrades(int iLeaderLevel)
{
    local bool bApplyUpgrade, bIsAlienBaseMission;
    local int iCharType, iCurrentResearch, iMaxNavigatorRoll;
    local LWCE_TIDWithSource kPerkData;
    local LWCE_TCharacter kChar;
    local MeshComponent MeshComp;
    local TCharacterBalance kSeq;
    local Vector vScale;

    bIsAlienBaseMission = `BATTLE.m_kDesc.m_iMissionType == eMission_AlienBase;
    iCharType = LWCE_GetCharacter().GetCharacterType();
    iCurrentResearch = `BATTLE.STAT_GetStat(1);
    kChar = LWCE_GetCharacter().GetCharacter();

    // TODO: replace all of this with our own config/logic

    foreach class'XGTacticalGameCore'.default.BalanceMods_Hard(kSeq)
    {
        if (kSeq.eType == iCharType)
        {
            // High digits of iCritHit are the alien research requirements for this config entry to activate
            if ((kSeq.iCritHit / 100) <= iCurrentResearch)
            {
                bApplyUpgrade = false;

                // If the leader level is greater than the low digits of iCritHit, this is a leader upgrade
                // and this unit is eligible for it
                if (iLeaderLevel >= (kSeq.iCritHit % 100))
                {
                    bApplyUpgrade = true;
                }

                // If the low digits of iCritHit are >= 10, then this config entry is a navigator upgrade, and
                // the low digits represent the percentage chance of applying the upgrade
                if ((kSeq.iCritHit % 100) >= 10)
                {
                    iMaxNavigatorRoll = bIsAlienBaseMission ? 50 : 100;

                    if (Rand(iMaxNavigatorRoll) <= (kSeq.iCritHit % 100))
                    {
                        bApplyUpgrade = true;
                    }
                }

                if (bApplyUpgrade)
                {
                    kChar.aStats[eStat_HP] += kSeq.iHP;
                    SetUnitHP(GetUnitMaxHP());

                    kChar.aStats[eStat_Offense] += kSeq.iAim;
                    m_aCurrentStats[eStat_Offense] += kSeq.iAim;

                    kChar.aStats[eStat_Damage] += kSeq.iDamage;
                    m_aCurrentStats[eStat_Damage] += kSeq.iDamage;

                    kChar.aStats[eStat_Will] += kSeq.iWill;
                    m_aCurrentStats[eStat_Will] += kSeq.iWill;

                    kPerkData.Id = kSeq.iMobility;
                    kPerkData.SourceType = 'Innate';
                    LWCE_GetCharacter().AddPerk(kPerkData);

                    m_iFlamethrowerCharges += kSeq.iDefense;
                }
            }
        }
    }

    // Set unit pawn's scale
    if (m_iFlamethrowerCharges != 0)
    {
        vScale.X = 1.0f + (float(m_iFlamethrowerCharges) / 100.0f);
        vScale.X = FClamp(vScale.X, 0.20, 10.0);

        foreach GetPawn().ComponentList(class'MeshComponent', MeshComp)
        {
            MeshComp.SetScale(vScale.X);
        }
    }

    // TODO: CHEAT_InitPawnPerkContent needs to be updated
    GetPawn().XComUpdateAnimSetList();
    GetPawn().CHEAT_InitPawnPerkContent(GetCharacter().m_kChar);

    // Setting special unit names if the unit has been autopsied. Perk numbers have been replaced with the enum values where appropriate;
    // in cases where the enum value has been repurposed, the perk is listed in comments instead, to avoid being misleading.
    if (`GAMECORE.m_kAbilities.HasAutopsyTechForChar(iCharType))
    {
        switch (iCharType)
        {
            case eChar_Sectoid:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(Executioner)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[32]; // Sectoid Leader
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(TacticalSense)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[33]; // Sectoid Master
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[34]; // Reticulan
                }

                break;

            case eChar_Floater:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CoveringFire)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[35]; // Floater Sentry
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(Sprinter)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[36]; // Floater Raider
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(ReadyForAnything)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[37]; // Floater Reaver
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(TacticalSense)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[38]; // Great Reaver
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[39]; // Reaver Lord
                }

                break;
            case eChar_Thinman:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightningReflexes)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[40]; // Sidewinder
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(SquadSight)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[41]; // Thin Man Sniper
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[42]; // Typhon
                }

                break;
            case eChar_Muton:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CoveringFire)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[43]; // Muton Sentry
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(Bombard)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[44]; // Muton Grenadier
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(Sentinel)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[45]; // Muton Sentinel
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(SquadSight)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[46]; // Muton Sniper
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightEmUp)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[47]; // Muton Centurion
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[48]; // Sargon
                }

                break;
            case eChar_Cyberdisc:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(DamageControl)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[49]; // Cyberdisc Gunship
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(HEATAmmo)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[50]; // Cyberdisc Destroyer
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightEmUp)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[51]; // Gunstar
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[52]; // Dreadnought
                }
                break;
            case eChar_SectoidCommander:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[53]; // Great Reticulan
                }

                break;
            case eChar_FloaterHeavy:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CoveringFire)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[54]; // Heavy Floater Sentry
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(HEATAmmo)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[55]; // Heavy Floater Destroyer
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(TacticalSense)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[56]; // Aircobra
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(DamnGoodGround)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[57]; // Warmaster
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[58]; // Archon
                }

                break;
            case eChar_MutonElite:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CoveringFire)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[59]; // Muton Elite Sentry
                }

                // BUG: this should be after Light Em Up, since the Centurion is a higher rank leader than the Legionary
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(TacticalSense)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[60]; // Muton Elite Centurion
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(SquadSight)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[61]; // Muton Elite Sniper
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightEmUp)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[62]; // Muton Elite Legionary
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[63]; // Muton Elite Commando
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(ReactiveTargetingSensors)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[64]; // Muton Elite Praetorian
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(ShredderAmmo)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[65]; // Bashar
                }

                break;
            case eChar_Ethereal:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[66]; // Ethereal Overmind
                }

                break;
            case eChar_Chryssalid:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightningReflexes)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[67]; // Chryssalid Warrior
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(Sprinter)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[68]; // Chryssalid Charger
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(ShockAbsorbentArmor)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[69]; // Hive Queen
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(Resilience)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[70]; // Greater Hive Queen
                }

                break;
            case eChar_MutonBerserker:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(ShockAbsorbentArmor)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[71]; // Behemoth
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(Sprinter)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[72]; // Juggernaut
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightningReflexes)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[73]; // Mongo
                }

                break;
            case eChar_Sectopod:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(HEATAmmo)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[74]; // Sectopod Destroyer
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(ReactiveTargetingSensors)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[75]; // Reaper
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[76]; // Titan
                }

                break;
            case eChar_Drone:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(HoloTargeting)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[77]; // Tracker Drone
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(AbsorptionFields)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[78]; // Battle Drone
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightEmUp)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[79]; // Atlas Drone
                }

                break;
            case eChar_Outsider:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(Opportunist)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[80]; // Outsider Engineer
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightningReflexes)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[81]; // Outsider Navigator
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CloseCombatSpecialist)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[82]; // Outsider Captain
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(DamageControl)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[83]; // Outsider Commander
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[84]; // Outsider Overlord
                }

                break;
            case eChar_Mechtoid:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(ShockAbsorbentArmor)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[85]; // Vulcan Mechtoid
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(ReactiveTargetingSensors)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[86]; // Leviathan Mechtoid
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(HEATAmmo)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[87]; // Colossus
                }

                break;
            case eChar_Seeker:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(UnlimitedCloak)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[88]; // Stalker
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(PlatformStability)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[89]; // Wraith
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CombinedArms)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[90]; // Hydra
                }

                break;
            case eChar_ExaltOperative:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CoveringFire)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[91]; // EXALT Sentry
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightningReflexes)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[92]; // EXALT Scout
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightEmUp)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[93]; // EXALT Lieutenant
                }

                break;
            case eChar_ExaltSniper:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(SquadSight)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[94]; // EXALT Sniper
                }

                break;
            case eChar_ExaltHeavy:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(JavelinRockets)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[95]; // EXALT Rocketeer
                }

                break;
            case eChar_ExaltMedic:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CoveringFire)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[96]; // EXALT Defender
                }

                break;
            case eChar_ExaltEliteOperative:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CoveringFire)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[97]; // EXALT Elite Sentry
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightningReflexes)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[98]; // EXALT Elite Scout
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(Sharpshooter)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[99]; // EXALT Deputy Commander
                }

                break;
            case eChar_ExaltEliteHeavy:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(JavelinRockets)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[100]; // EXALT Elite Rocketeer
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(TacticalSense)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[103]; // EXALT Commander Iago Van Doorn
                }

                break;
            case eChar_ExaltEliteMedic:
                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(CoveringFire)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[101]; // EXALT Elite Defender
                }

                if (LWCE_GetCharacter().HasPerk(`LW_PERK_ID(LightEmUp)))
                {
                    kChar.strName = class'XLocalizedData'.default.m_aCharacterName[102]; // EXALT Elite Captain
                }

                break;
            default:
                // Deliberately missing case for eChar_ExaltEliteSniper; has no alternate names
                break;
        }
    }

    LWCE_GetCharacter().SetCharacter(kChar);
}

/**
 * Originally rewritten by Long War to check morale events; now deprecated and that functionality
 * is moved to HasHandledMoraleEventThisTurn.
 */
simulated function bool IsAboveFloorTile(Vector vLoc, optional int iMinTiles)
{
    `LWCE_LOG("ERROR: LWCE-incompatible function IsAboveFloorTile was called. This needs to be replaced with HasHandledMoraleEventThisTurn. Stack trace follows.");
    ScriptTrace();

    return false;
}

simulated function bool IsAlien_CheckByCharType()
{
    if (GetCharType() >= eChar_Sectoid)
    {
        return true;
    }
    else
    {
        return false;
    }
}

simulated function bool IsTargetInReactionArea(XGUnit kTarget)
{
    local XGWeapon kActiveWeapon;
    local float fReactionRange;
    local Vector vTargetDir;

    kActiveWeapon = GetInventory().GetActiveWeapon();

    if (kActiveWeapon == none)
    {
        return false;
    }

    // TODO: this could be extended for a config option where height advantage increases reaction range
    fReactionRange = 64.0f * LWCE_XGWeapon(kActiveWeapon).m_kTemplate.iReactionRange;
    vTargetDir = kTarget.GetLocation() - GetLocation();

    if (fReactionRange >= 0.0f)
    {
        if (VSizeSq(vTargetDir) > (fReactionRange * fReactionRange))
        {
            return false;
        }
    }

    GetPlayer().GetSightMgr().UpdateVisible();

    return true;
}

function bool LoadInit(XGPlayer NewPlayer)
{
    super(XGUnitNativeBase).LoadInit(NewPlayer);

    if (m_kPlayer == none)
    {
        m_kPlayer = NewPlayer;
    }

    // LWCE issue #23: the character's reference to the unit is not persisted, causing it to be lost
    // if the tac game is saved and loaded. We simply restore it manually.
    m_kCharacter.m_kUnit = self;

    SpawnPawn(false, true);

    if (m_bOffTheBattlefield)
    {
        SetVisible(false);
    }

    if (m_kPawn == none)
    {
        return false;
    }

    if (m_kPawn.IsA('LWCE_XComHumanPawn') && m_kCharacter.IsA('LWCE_XGCharacter_Soldier'))
    {
        // TODO does omitting this cause any problems?
        //LWCE_XComHumanPawn(m_kPawn).LWCE_SetAppearance(LWCE_XGCharacter_Soldier(m_kCharacter).m_kCESoldier.kAppearance);
    }
    else if (m_kPawn.IsA('XComHumanPawn'))
    {
        // TODO: might need LWCE appearance here
        XComCivilian(m_kPawn).SetAppearance(m_SavedAppearance);
    }

    GetInventory().OnLoad(self);

    if (!IsMine())
    {
        InitBehavior();
    }

    CreateUnitView();
    ProcessNewPosition();

    m_bCanOpenWindowsAndDoors = m_kCharacter.m_bCanOpenWindowsAndDoors;

    if (IsDead())
    {
        ProcessDeathOnLoad();
    }
    else if (IsCriticallyWounded())
    {
        AddCriticallyWoundedAction(false, true);
        SetDiscState(0);
    }
    else if (m_iPanicCounter > 0)
    {
        AddIdleAction();
        GotoState('Panicked');
    }
    else
    {
        AddIdleAction();
        SetDiscState(0);
    }

    if (IsBattleScanner())
    {
        OnBattleScannerBegin(GetPawn().Location);
    }

    if (m_bHiding)
    {
        if (XComSeeker(GetPawn()) != none)
        {
            XComSeeker(GetPawn()).BeginStealth();
        }
        else
        {
            GetPawn().SetGhostFX(true);
        }
    }

    if (m_bWeaponDisabled)
    {
        XComUnitPawn(m_kPawn).ApplyDisablingShot();
    }

    if (m_bStunned)
    {
        XComUnitPawn(m_kPawn).ApplyStunFX();
    }

    if (!IsDead())
    {
        UpdatePsiEffects();
    }

    if ((XComOutsider(m_kPawn) != none) && m_kPod == none)
    {
        XComOutsider(m_kPawn).SwapToRevealMaterials();
    }

    if (XComSectopod(m_kPawn) != none && IsApplyingAbility(eAbility_ClusterBomb))
    {
        XComSectopod(GetPawn()).EnableClusterBombTargeting(true);
        XComSectopod(GetPawn()).UpdateTargetingLocation(GetAppliedAbility(eAbility_ClusterBomb).m_vTargetLocation);
    }

    if (IsApplyingAbility(eAbility_Strangle) || IsAffectedByAbility(eAbility_Strangle))
    {
        m_bStrangleStarted = true;
        IdleStateMachine.bLoadInitStrangle = true;
        IdleStateMachine.CheckForStanceUpdate();
    }

    if (m_numSuppressionTargets > 0)
    {
        IdleStateMachine.CheckForStanceUpdate();
        StoredEnterCoverAction = Spawn(class'XGAction_EnterCover', self);
        StoredEnterCoverAction.Init(self);
        StoredEnterCoverAction.PrimaryTarget = XGUnit(m_arrSuppressionTargets[0]);
        StoredEnterCoverAction.vTarget = StoredEnterCoverAction.PrimaryTarget.Location;
    }

    if (!IsDead())
    {
        m_kPawn.XComUpdateOpenCloseStateNode(m_ePawnOpenCloseState, true);
    }

    return true;
}

function OnEnterPoison(XGVolume kVolume)
{
    // Don't apply poison to visibility helpers or it'll be visible on the UI
    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(self))
    {
        return;
    }

    super.OnEnterPoison(kVolume);
}

function int OnTakeDamage(int iDamage, class<DamageType> inDamageType, XGUnit kDamageDealer_Base, Vector HitLocation, Vector Momentum, optional Actor DamageCauser)
{
    local int iRank, iUnitShieldHP, iShieldDamage;
    local bool bNeuralFeedback;
    local LWCE_TCharacter kTChar;
    local LWCE_XGUnit kDamageDealer;
    local LWCE_XGWeapon kItem;
    local XGAction_TakeDamage kDamageAction;
    local XGAction_Death kDeathAction;
    local XComWeapon kWeapon;
    local XComUIBroadcastWorldMessage kBroadcastWorldMessage, kBroadcastModuleDisabled;

    kDamageDealer = LWCE_XGUnit(kDamageDealer_Base);

    if (IsShredded())
    {
        if (inDamageType != class'XComDamageType_Poison')
        {
            if (iDamage > 0)
            {
                iDamage += Max((iDamage * 4) / 10, 1);
            }
        }
    }

    if (kDamageDealer != none)
    {
        kItem = LWCE_XGWeapon(kDamageDealer.GetInventory().GetActiveWeapon());

        if (kDamageDealer.HasPerk(`LW_PERK_ID(HEATWarheads)) && ClassIsChildOf(inDamageType, class'XComDamageType_Explosion'))
        {
            if (IsVulnerableToElectropulse())
            {
                iDamage += Max(2, kItem.GetDamageStat() * class'XGTacticalGameCore'.default.COUNCIL_FUNDING_MULTIPLIER_HARD);
            }
        }
        else if (IsVulnerableToElectropulse())
        {
            if (inDamageType != class'XComDamageType_Psionic')
            {
                if (kDamageDealer.HasPerk(`LW_PERK_ID(HEATAmmo)) && kItem.m_kTemplate.IsLarge() && !kItem.m_kTemplate.HasProperty('Assault'))
                {
                    if (kDamageDealer.m_eUsedAbility == eAbility_MEC_Barrage || kDamageDealer.m_eUsedAbility == eAbility_ShotMayhem)
                    {
                        iDamage += 2;
                    }
                    else
                    {
                        iDamage += Max(2, kItem.GetDamageStat() * class'XGTacticalGameCore'.default.COUNCIL_FUNDING_MULTIPLIER_HARD);
                    }
                }
            }
        }

        if (kDamageDealer.LWCE_GetInventory().LWCE_HasItemOfType('Item_FlakAmmo'))
        {
            if (kItem.m_kTemplate.IsLarge())
            {
                if (IsFlying())
                {
                    if (inDamageType != class'XComDamageType_Psionic')
                    {
                        iDamage += Max(2, kItem.GetDamageStat() * 0.20);
                    }
                }
            }
        }
    }

    if (m_kCharacter.HasUpgrade(ePerk_DamageControl))
    {
        m_iDamageControlTurns = 2;
    }

    if (m_kBehavior != none && m_kBehavior.m_kPod != none)
    {
        if (IsDormant())
        {
            `BATTLE.m_kPodMgr.QueuePodReveal(m_kBehavior.m_kPod, kDamageDealer, true);
        }
    }

    bNeuralFeedback = kDamageDealer != none && kDamageDealer.m_kNeuralFeedbackTarget == self && !kDamageDealer.m_bHitNeuralFeedbackTarget;
    iUnitShieldHP = 0;

    if (GetShieldHP() > 0)
    {
        iUnitShieldHP = GetShieldHP();
    }

    if (HasPerk(`LW_PERK_ID(RepairServos)))
    {
        m_iRepairServosHPLeft -= (class'XGTacticalGameCore'.default.PSI_TEST_LIMIT * m_iRepairServosHPLeft) / 100;
        m_iRepairServosHPLeft = Max(0, m_iRepairServosHPLeft);
        m_iRepairServosHPLeft += iDamage;
    }

    if (LWCE_XGCharacter_Soldier(GetCharacter()) != none)
    {
        iRank = LWCE_XGCharacter_Soldier(GetCharacter()).m_kCESoldier.iRank;
    }

    if (kDamageDealer != none && kDamageDealer.IsPoisonous(inDamageType))
    {
        RollForPoison(kDamageDealer);
    }

    if (!m_bStunned && !ActionQueueContains('XGAction_Death') &&
        kDamageDealer != none &&
        XGAction_Fire(kDamageDealer.GetAction()) != none &&
        XGAction_Fire(kDamageDealer.GetAction()).m_kShot.iType == eAbility_ShotStun &&
        `GAMECORE.CanBeStunned(self))
    {
        iDamage = 0;

        if (`GAMECORE.TryStunned(self, kDamageDealer.GetAction()))
        {
            if (IsExalt())
            {
                SetUnitHP(0);
                m_kPawn.Health = 0;
                m_bStunned = true;
            }
            else
            {
                kDamageDealer.SetTimer(2.0, false, 'DelayStunSpeech');
                SetUnitHP(1);
                m_kPawn.Health = 1;
                AddCriticallyWoundedAction(true);

                if (XGBattle_SP(`BATTLE) != none)
                {
                    if (GetCharacter().m_kChar.iType == eChar_Outsider)
                    {
                        `ONLINEEVENTMGR.UnlockAchievement(AT_TheWatchers);
                        `BATTLE.m_kDesc.m_kDropShipCargoInfo.m_bNeedOutsider = false;
                    }
                    else
                    {
                        `ONLINEEVENTMGR.UnlockAchievement(AT_PrisonerOfWar);
                    }
                }

                if (XComUnitPawn(m_kPawn).StunShot_Receive != none)
                {
                    XComUnitPawn(m_kPawn).ApplyStunFX();
                }
            }
        }
        else
        {
            kBroadcastWorldMessage = `PRES.GetWorldMessenger().Message(`GAMECORE.GetUnexpandedLocalizedMessageString(eULS_UnitNotStunned), Location, eColor_Bad,,, m_eTeamVisibilityFlags,,,, class'XComUIBroadcastWorldMessage_UnexpandedLocalizedString');

            if (kBroadcastWorldMessage != none)
            {
                XComUIBroadcastWorldMessage_UnexpandedLocalizedString(kBroadcastWorldMessage).Init_UnexpandedLocalizedString(eULS_UnitNotStunned, Location, eColor_Bad, m_eTeamVisibilityFlags);
            }

            kDamageDealer.SetTimer(2.0, false, 'DelayStunFailSpeech');
        }
    }

    if (!ActionQueueContains('XGAction_Death') && kDamageDealer != none && `GAMECORE.CanBeHacked(self, kDamageDealer.GetAction()))
    {
        iDamage = 0;
        `BATTLE.SwapTeams(self);
        return 0;
    }

    if (m_kBehavior != none)
    {
        m_kBehavior.OnTakeDamage(iDamage, inDamageType);
    }

    if (iUnitShieldHP > 0)
    {
        if (iDamage > iUnitShieldHP)
        {
            iDamage -= iUnitShieldHP;
            iShieldDamage = iUnitShieldHP;
            SetShieldHP(0);
        }
        else
        {
            SetShieldHP(iUnitShieldHP - iDamage);
            iShieldDamage = iDamage;
            iDamage = 0;
        }
    }

    SetUnitHP(Max(GetUnitHP() - iDamage, 0));
    ClearAppliedAbilitiesWithProperty(eProp_AbortWithWound);

    if (GetUnitHP() > 0)
    {
        if (inDamageType != class'XComDamageType_MindMerge' && XGAction_Move_Direct(m_kCurrAction) == none && !IsStrangled())
        {
            if (iDamage > 0 || iShieldDamage > 0)
            {
                kDamageAction = Spawn(class'XGAction_TakeDamage');

                if (kDamageAction.Init(self, kDamageDealer, iDamage, inDamageType, HitLocation, Momentum, DamageCauser, iShieldDamage))
                {
                    AddAction(kDamageAction);
                }
                else
                {
                    kDamageAction.Destroy();
                }
            }
        }

        if (iDamage > 0 && CanIntimidate() && kDamageDealer != none && !kDamageDealer.IsReactionFiring() && !kDamageDealer.IsPanicking() && !kDamageDealer.IsPanicked() && !kDamageDealer.IsStrangled() && !kDamageDealer.IsStrangling() && `BATTLE.m_kActivePlayer == kDamageDealer.m_kPlayer)
        {
            if (!kDamageDealer.IsUsingFlush())
            {
                Intimidate(kDamageDealer);
            }
        }
    }
    else
    {
        kTChar = LWCE_GetCharacter().GetCharacter();

        if (inDamageType != class'XComDamageType_MindMerge' &&
            !m_bCriticallyWounded && !ActionQueueContains('XGAction_Death') &&
            kDamageDealer != none &&
            kDamageDealer.LWCE_GetCharacter().GetCharacterType() != eChar_Chryssalid &&
            !`BATTLE.m_kDesc.m_bScripted &&
            !`BATTLE.m_kDesc.m_bDisableSoldierChatter &&
            `LWCE_GAMECORE.LWCE_CalcCriticallyWounded(self, kTChar, m_aCurrentStats, iDamage, iRank, GetCharacter().IsA('XGCharacter_Soldier') && XGCharacter_Soldier(GetCharacter()).m_kSoldier.iPsiRank == 7, HasPerk(`LW_PERK_ID(SecondaryHeart)) && m_iUsedSecondaryHeart == 0, m_iUsedSecondaryHeart, GetPawn().Location, m_eTeamVisibilityFlags))
        {
            LWCE_GetCharacter().SetCharacter(kTChar);

            // Critically wound this unit
            SetUnitHP(1);
            m_kPawn.Health = 1;
            m_kDamageDealer = kDamageDealer;

            if (!HasPerk(`LW_PERK_ID(SecondaryHeart)))
            {
                m_aCurrentStats[eStat_Will] -= class'XGTacticalGameCore'.default.UFO_FUSION_SURVIVE;
                GetCharacter().m_kChar.aStats[eStat_Will] -= class'XGTacticalGameCore'.default.UFO_FUSION_SURVIVE;
            }

            AddCriticallyWoundedAction();
        }
        else
        {
            kItem = LWCE_XGWeapon(GetInventory().GetItem(eSlot_PsiSource));
            kWeapon = XComWeapon(kItem.m_kEntity);
            kDeathAction = Spawn(class'XGAction_Death');

            if (kDeathAction.Init(self, kDamageDealer, iDamage, inDamageType, HitLocation, Momentum, DamageCauser, kWeapon, m_kPawn))
            {
                if (m_bBloodlustMove)
                {
                    m_bBloodlustMove = false;
                    XComTacticalController(GetALocalPlayerController()).DecBloodlustMove();
                }

                if (IsMoving() || m_kActionQueue.Contains('XGAction_Berserk'))
                {
                    m_kActionQueue.Clear(true, false);
                }

                AddAction(kDeathAction);

                if (bNeuralFeedback && XGBattle_SP(`BATTLE) != none)
                {
                    `ONLINEEVENTMGR.UnlockAchievement(AT_MentalMinefield);
                }

                if (GetCharType() == eChar_ExaltEliteSniper && kDamageDealer != none)
                {
                    if (kDamageDealer.IsMine() && kDamageDealer.GetCharacter().IsA('XGCharacter_Soldier') && kDamageDealer.GetCharacter().m_kChar.eClass == eSC_Sniper)
                    {
                        `ONLINEEVENTMGR.UnlockAchievement(AT_Gday);
                    }
                }
            }
            else
            {
                kDeathAction.Destroy();
            }
        }
    }

    if (IsMine())
    {
        RecordTookDamage(iDamage, kDamageDealer);
    }

    if (m_bHasChryssalidEgg && iDamage > 0 && !class'XGAIChryssalidEgg'.static.CanSurviveDamage(inDamageType))
    {
        m_bHasChryssalidEgg = false;
    }

    // When crit, Sentinel Module is disabled for the rest of the mission
    if (DamageCauser != none && DamageCauser.IsA('XComProjectile') && HasSentinelModule())
    {
        if (XComProjectile(DamageCauser).m_bWasCrit)
        {
            m_bSentinelModuleDisabled = true;
            kBroadcastModuleDisabled = `PRES.GetWorldMessenger().Message(`GAMECORE.GetUnexpandedLocalizedMessageString(eULS_ShivModuleDisabled), GetLocation(), eColor_Bad,,, m_eTeamVisibilityFlags,,,, class'XComUIBroadcastWorldMessage_UnexpandedLocalizedString');

            if (kBroadcastModuleDisabled != none)
            {
                XComUIBroadcastWorldMessage_UnexpandedLocalizedString(kBroadcastModuleDisabled).Init_UnexpandedLocalizedString(eULS_ShivModuleDisabled, GetLocation(), eColor_Bad, m_eTeamVisibilityFlags);
            }
        }
    }

    if (DamageCauser != none && !DamageCauser.IsA('XComProjectile') || XComProjectile(DamageCauser).m_bShowDamage)
    {
        if (`PROFILESETTINGS.Data.m_bShowEnemyHealth || IsMine())
        {
            if (iDamage == 0 && `BATTLE.m_kDesc.m_bIsTutorial && `BATTLE.m_kDesc.m_bDisableSoldierChatter)
            {
                return iDamage;
            }

            if (XComProjectile(DamageCauser).m_bWasCrit)
            {
                if (iDamage > 0)
                {
                    kBroadcastWorldMessage = class'UIWorldMessageMgr'.static.DamageDisplay(GetLocation(), iDamage @ m_sCriticalDamageImage @ m_sCriticalHitDamageDisplay, m_eTeamVisibilityFlags, class'XComUIBroadcastWorldMessage_DamageDisplay');

                    if (kBroadcastWorldMessage != none)
                    {
                        XComUIBroadcastWorldMessage_DamageDisplay(kBroadcastWorldMessage).Init_DisplayDamage(eUIBWMDamageDisplayType_CriticalHit, GetLocation(), iDamage, m_eTeamVisibilityFlags);
                    }
                }

                if (iShieldDamage > 0)
                {
                    kBroadcastWorldMessage = class'UIWorldMessageMgr'.static.DamageDisplay(GetLocation(), iShieldDamage @ m_sCriticalDamageImage @ m_sCriticalHitDamageDisplay, m_eTeamVisibilityFlags, class'XComUIBroadcastWorldMessage_DamageDisplay');

                    if (kBroadcastWorldMessage != none)
                    {
                        XComUIBroadcastWorldMessage_DamageDisplay(kBroadcastWorldMessage).Init_DisplayDamage(eUIBWMDamageDisplayType_CriticalHit, GetLocation(), iShieldDamage, m_eTeamVisibilityFlags);
                    }
                }
            }
            else
            {
                if (iDamage > 0)
                {
                    kBroadcastWorldMessage = class'UIWorldMessageMgr'.static.DamageDisplay(GetLocation(), iDamage @ m_sDamageImage, m_eTeamVisibilityFlags, class'XComUIBroadcastWorldMessage_DamageDisplay');

                    if (kBroadcastWorldMessage != none)
                    {
                        XComUIBroadcastWorldMessage_DamageDisplay(kBroadcastWorldMessage).Init_DisplayDamage(eUIBWMDamageDisplayType_Hit, GetLocation(), iDamage, m_eTeamVisibilityFlags);
                    }
                }

                if (iShieldDamage > 0)
                {
                    kBroadcastWorldMessage = class'UIWorldMessageMgr'.static.DamageDisplay(GetLocation(), string(iShieldDamage) @ m_sDamageImage, m_eTeamVisibilityFlags, class'XComUIBroadcastWorldMessage_DamageDisplay');

                    if (kBroadcastWorldMessage != none)
                    {
                        XComUIBroadcastWorldMessage_DamageDisplay(kBroadcastWorldMessage).Init_DisplayDamage(eUIBWMDamageDisplayType_Hit, GetLocation(), iShieldDamage, m_eTeamVisibilityFlags);
                    }
                }
            }
        }
    }
    else
    {
        if (DamageCauser != none)
        {
            if (`PROFILESETTINGS.Data.m_bShowEnemyHealth || IsMine())
            {

                if (DamageCauser.IsA('XGAbility_Electropulse') || inDamageType == class'XComDamageType_Flame' || inDamageType == class'XComDamageType_Barrage' || DamageCauser.IsA('XGAbility_KineticStrike') || inDamageType == class'XComDamageType_Melee')
                {
                    if (iDamage > 0)
                    {
                        kBroadcastWorldMessage = class'UIWorldMessageMgr'.static.DamageDisplay(GetLocation(), string(iDamage) @ m_sDamageImage, m_eTeamVisibilityFlags, class'XComUIBroadcastWorldMessage_DamageDisplay');

                        if (kBroadcastWorldMessage != none)
                        {
                            XComUIBroadcastWorldMessage_DamageDisplay(kBroadcastWorldMessage).Init_DisplayDamage(eUIBWMDamageDisplayType_Hit, GetLocation(), iDamage, m_eTeamVisibilityFlags);
                        }
                    }

                    if (iShieldDamage > 0)
                    {
                        kBroadcastWorldMessage = class'UIWorldMessageMgr'.static.DamageDisplay(GetLocation(), string(iShieldDamage) @ m_sDamageImage, m_eTeamVisibilityFlags, class'XComUIBroadcastWorldMessage_DamageDisplay');

                        if (kBroadcastWorldMessage != none)
                        {
                            XComUIBroadcastWorldMessage_DamageDisplay(kBroadcastWorldMessage).Init_DisplayDamage(eUIBWMDamageDisplayType_Hit, GetLocation(), iShieldDamage, m_eTeamVisibilityFlags);
                        }
                    }
                }
            }
        }
    }

    return iDamage + iShieldDamage;
}

simulated event OnUpdatedVisibility(bool bVisibilityChanged)
{
    local XGBattle_SP kBattle;
    local XGAIPlayer kAIPlayer;

    // This almost certainly does nothing, but better safe than sorry with UE3 events
    super(XGUnitNativeBase).OnUpdatedVisibility(bVisibilityChanged);

    FlankCheck();
    m_bBuildAbilityDataDirty = bVisibilityChanged || m_bBuildAbilityDataDirty;
    kBattle = XGBattle_SP(`BATTLE);

    if (kBattle != none)
    {
        kAIPlayer = XGAIPlayer(kBattle.GetAIPlayer());

        if (kAIPlayer != none)
        {
            kAIPlayer.MarkDestinationCacheDirty();
        }
    }

    if (IsAliveAndWell() && GetPlayer().IsHumanPlayer() && self == GetPlayer().GetActiveUnit() && !GetPlayer().GetSquad().IsAnyoneElsePerformingAction(none))
    {
        // Don't allow abilities to rebuild while using the grapple. Normally this wouldn't be possible, but our LOS helpers move around
        // to provide an accurate LOS preview when grappling, and we don't want to rebuild an ability that's in use. (Hat tip to the Sightlines mod
        // by tracktwo which originally spotted the need for this logic.)
        if (XGAction_Targeting(GetAction()) != none && XGAction_Targeting(GetAction()).m_kShot != none && XGAbility_Grapple(XGAction_Targeting(GetAction()).m_kShot) != none)
        {
            m_bBuildAbilitiesTriggeredFromVisibilityChange = false;
            return;
        }

        // TODO: experimenting with not triggering BuildAbilities here, for efficiency; clean up the code eventually
        // m_bBuildAbilitiesTriggeredFromVisibilityChange = bVisibilityChanged;
        // BuildAbilities(bVisibilityChanged);
    }
    else
    {
        m_bBuildAbilitiesTriggeredFromVisibilityChange = false;
    }
}

simulated event PostBeginPlay()
{
    local LWCE_XGAbility kAbility;

    super.PostBeginPlay();

    // Check for any abilities which trigger when we begin play
    BuildAbilities();

    `LWCE_LOG_CLS("Unit " $ self $ " looking for abilities that trigger on PostBeginPlay. There are " $ m_arrAbilities.Length $ " abilities to iterate.");
    foreach m_arrAbilities(kAbility)
    {
        if (kAbility.IsTriggeredOnUnitPostBeginPlay())
        {
            `LWCE_LOG_CLS("Ability " $ kAbility $ "(" $ kAbility.m_TemplateName $ ") is triggered on PostBeginPlay. Activating now.");
            kAbility.Activate();
        }
    }
}

simulated function bool ReactionAbilityCheck(XGUnit kTarget)
{
    local int I;
    local LWCE_XGWeapon kActiveWeapon;

    if (IsUnitBusy())
    {
        return false;
    }

    kActiveWeapon = LWCE_XGWeapon(GetInventory().GetActiveWeapon());

    if (kActiveWeapon == none)
    {
        return false;
    }

    if (kActiveWeapon.HasProperty(eWP_CantReact))
    {
        return false;
    }

    CleanUpAbilitiesAffecting();

    for (I = 0; I < m_iNumAbilitiesAffecting; I++)
    {
        if (m_aAbilitiesAffecting[I].HasProperty(eProp_TargetCantReact))
        {
            return false;
        }
    }

    CleanUpAbilitiesApplied();

    for (I = 0; I < m_iNumAbilitiesApplied; I++)
    {
        if (m_aAbilitiesApplied[I].HasProperty(eProp_CantReact))
        {
            return false;
        }
    }

    return true;
}

simulated function bool ReactionWeaponCheck()
{
    local XGWeapon kActiveWeapon;

    kActiveWeapon = GetInventory().GetActiveWeapon();

    if (kActiveWeapon == none)
    {
        return false;
    }

    if (!ActiveWeaponHasAmmoForShot(eAbility_ShotStandard, true))
    {
        return false;
    }

    // Remove call to XGWeapon.IsOverheated, which is deprecated

    return true;
}

function RecordKill(XGUnit kVictim, optional bool bDiedFromExplosiveDamage = false)
{
    local LWCE_XGCharacter_Soldier kSoldierChar;
    local XGAction_Fire kFireAction;
    local bool bAlreadyLeveledUp;

    kSoldierChar = LWCE_XGCharacter_Soldier(m_kCharacter);
    kFireAction = XGAction_Fire(m_kCurrAction);

    if (kFireAction != none)
    {
        kFireAction.AddVictim(kVictim);
    }

    if (GetCharType() == eChar_Soldier && IsEnemy(kVictim))
    {
        bAlreadyLeveledUp = kSoldierChar.LeveledUp();
        kSoldierChar.AddXP(`GAMECORE.CalcXP(self, eGameEvent_Kill, kVictim));

        if (kSoldierChar.LeveledUp() && !bAlreadyLeveledUp)
        {
            XComTacticalController(Owner).ClientPHUDLevelUp(kSoldierChar);
        }

        if (XGBattle_SP(`BATTLE) != none)
        {
            if (kVictim.IsAlien_CheckByCharType())
            {
                if (IsFlying())
                {
                    `ONLINEEVENTMGR.UnlockAchievement(AT_ThePersuader);
                }

                `BATTLE.STAT_AddProfileStat(eProfile_AliensKilled, 1.0);
                `BATTLE.STAT_AddStat(eRecap_AliensKilled, 1);

                if (bDiedFromExplosiveDamage)
                {
                    `BATTLE.STAT_AddProfileStat(eProfile_AliensKilledFromExplosions, 1.0);
                    `BATTLE.STAT_AddStat(eRecap_AliensKilledFromExplosives, 1);
                }

                if (`BATTLE.STAT_GetProfileStat(eProfile_AliensKilledFromExplosions) >= 50)
                {
                    `ONLINEEVENTMGR.UnlockAchievement(AT_BadaBoom);
                }

                if (`BATTLE.STAT_GetProfileStat(eProfile_AliensKilled) >= 150)
                {
                    `ONLINEEVENTMGR.UnlockAchievement(AT_WelcomeToEarth);
                }

                if (`BATTLE.STAT_GetProfileStat(eProfile_AliensKilled) >= 500)
                {
                    `ONLINEEVENTMGR.UnlockAchievement(AT_AndHeRode);
                }

                if (kVictim.GetCharType() == eChar_ExaltEliteMedic && bDiedFromExplosiveDamage)
                {
                    `ONLINEEVENTMGR.UnlockAchievement(AT_RegenerateThis);
                }
            }
        }
    }
}

simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
}

function SetActorTemplateInfo(out ActorTemplateInfo TemplateInfo)
{
    return; // TODO
}

simulated function ShowMouseOverDisc(optional bool bShow = true)
{
    if (m_bShowMouseOverDisc != bShow)
    {
        m_bShowMouseOverDisc = bShow;
        RefreshUnitDisc();

        `LWCE_VISHELPER.UpdateVisibilityMarkers();
    }
}

function SpawnPawn(optional bool bSnapToGround = true, optional bool bLoaded = false)
{
    local LWCE_TCharacter kChar;
    local MeshComponent MeshComp;
    local Vector vRotDir;
    local class<XComUnitPawn> PawnClass;

    kChar = LWCE_GetCharacter().GetCharacter();
    PawnClass = m_kCharacter.GetPawnClass();

    `LWCE_LOG_CLS("SpawnPawn: bSnapToGround = " $ bSnapToGround $ ", bLoaded = " $ bLoaded);

    // TODO extend this to all pawns
    if (ClassIsChildOf(PawnClass, class'XComHumanPawn'))
    {
        `LWCE_LOG_CLS("Changing pawn class to LWCE_XComHumanPawn");
        PawnClass = class'LWCE_XComHumanPawn';
    }

    // Normally the pawn is spawned with the XGUnit's owner as its owner, but our LWCE pawns need to grab some
    // data from the unit in order to initialize, so they reset the owner themselves in PostBeginPlay
    m_kPawn = Spawn(PawnClass, self,, Location, Rotation, /* ActorTemplate */ none, true, m_eTeam);
    SetBase(m_kPawn);

    if (m_kPawn != none)
    {
        if (m_kCharacter.m_kChar.iType == eChar_Cyberdisc)
        {
            m_kPawn.XComUpdateOpenCloseStateNode(eUP_Close, true);
        }

        m_kPawn.SetXGCharacter(m_kCharacter);
        m_kPawn.SpawnDefaultController();
        m_kPawn.SetGameUnit(self);
        m_kPawn.HealthMax = GetUnitMaxHP();
        m_kPawn.Health = m_kPawn.HealthMax;
        m_kActionQueue = Spawn(class'XGActionQueue', self);

        if (WorldInfo.NetMode != NM_Standalone)
        {
            m_kNetExecActionQueue = Spawn(class'XGNetExecActionQueue', self);
            m_kNetExecActionQueue.SetUnit(self);
        }

        if (bSnapToGround)
        {
            SnapToGround();
        }

        vRotDir = vector(m_kPawn.Rotation);
        vRotDir.Z = 0.0;
        m_kPawn.FocalPoint = m_kPawn.Location + (vRotDir * 128.0f);
        m_kPathingPawn = Spawn(class'XComPathingPawn', self,,,,, true, m_eTeam);

        if (m_kPathingPawn == none)
        {
            return;
        }

        m_kPathingPawn.SpawnDefaultController();
        m_kPawn.SetPhysics(PHYS_None);
        m_kPawn.SetVisibleToTeams(m_kPlayer.m_eTeam);
        class'XComWorldData'.static.GetWorldData().RegisterActor(m_kPawn, self.GetSightRadius());
        XComUnitPawn(m_kPawn).InitPawnPerkContent(GetCharacter().m_kChar);
    }

    if (PawnClass == class'LWCE_XComHumanPawn')
    {
        LWCE_XComHumanPawn(m_kPawn).LWCE_Init(kChar, kChar.kInventory, m_kCESoldier.kAppearance);
    }

    if (bLoaded)
    {
        m_kPawn.Health = GetUnitHP();

        if (IsPoisoned())
        {
            if (m_bPoisonedByThinman)
            {
                m_kPawn.Mesh.AttachComponentToSocket(XComUnitPawn(m_kPawn).PoisonedByThinmanFX, 'Unit_Root');
                XComUnitPawn(m_kPawn).PoisonedByThinmanFX.SetActive(true);
            }
            else
            {
                m_kPawn.Mesh.AttachComponentToSocket(XComUnitPawn(m_kPawn).PoisonedByChryssalidFX, 'Unit_Root');
                XComUnitPawn(m_kPawn).PoisonedByChryssalidFX.SetActive(true);
            }
        }

        if (IsAlien_CheckByCharType())
        {
            if (m_iFlamethrowerCharges != 0)
            {
                vRotDir.X = 1.0f + (m_iFlamethrowerCharges / 100.0f);
                vRotDir.X = FClamp(vRotDir.X, 0.20, 10.0);

                foreach GetPawn().ComponentList(class'MeshComponent', MeshComp)
                {
                    MeshComp.SetScale(vRotDir.X);
                }
            }
        }
    }
}

simulated event UpdateAbilitiesUI()
{
    super.UpdateAbilitiesUI();
}

simulated function UpdateCiviliansInRange()
{
    local XGUnit kEnemy;

    ClearCiviliansInRange();

    if (m_kPlayer.GetSightMgr() == none)
    {
        // Might not be initialized yet
        return;
    }

    foreach m_arrVisibleCivilians(kEnemy)
    {
        if (!class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kEnemy))
        {
            m_kPlayer.GetSightMgr().AddVisibleCivilian(self, kEnemy);
        }
    }
}

simulated function UpdateInteractClaim()
{
    // Prevent visibility helpers from claiming interaction points such as doors and Meld
    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(self))
    {
        return;
    }

    super.UpdateInteractClaim();
}

function UpdateItemCharges()
{
    // TODO: connect this to LWCE's item system
    local LWCE_XGInventory kInventory;

    kInventory = LWCE_XGInventory(GetInventory());

    SetGhostCharges(3);

    if (kInventory.LWCE_GetNumItems('Item_Medikit') > 0)
    {
        m_iMediKitCharges = kInventory.LWCE_GetNumItems('Item_Medikit');

        if (HasPerk(`LW_PERK_ID(Packmaster)))
        {
            m_iMediKitCharges += kInventory.LWCE_GetNumItems('Item_Medikit');
        }

        if (HasPerk(`LW_PERK_ID(FieldMedic)))
        {
            m_iMediKitCharges += kInventory.LWCE_GetNumItems('Item_Medikit') - 1;
        }
    }

    if (kInventory.LWCE_GetNumItems('Item_ArcThrower') > 0)
    {
        SetArcThrowerCharges(kInventory.LWCE_GetNumItems('Item_ArcThrower') * 1);

        if (HasPerk(/* Packmaster */ 53))
        {
            SetArcThrowerCharges(GetArcThrowerCharges() + kInventory.LWCE_GetNumItems('Item_ArcThrower'));
        }

        if (HasPerk(ePerk_Repair))
        {
            SetArcThrowerCharges(GetArcThrowerCharges() + (kInventory.LWCE_GetNumItems('Item_ArcThrower') * 2));
        }
    }

    SetMimicBeaconCharges(kInventory.LWCE_GetNumItems('Item_MimicBeacon') * (HasPerk(`LW_PERK_ID(SmokeAndMirrors)) ? 2 : 1));
    SetFragGrenades(kInventory.LWCE_GetNumItems('Item_HEGrenade') * (HasPerk(`LW_PERK_ID(Grenadier)) ? 2 : 1));
    SetFlashBangs(kInventory.LWCE_GetNumItems('Item_FlashbangGrenade') * (HasPerk(`LW_PERK_ID(SmokeAndMirrors)) ? 2 : 1));
    SetAlienGrenades(kInventory.LWCE_GetNumItems('Item_AlienGrenade') * (HasPerk(`LW_PERK_ID(Grenadier)) ? 2 : 1));
    SetGhostGrenades(kInventory.LWCE_GetNumItems('Item_ShadowDevice') * (HasPerk(`LW_PERK_ID(SmokeAndMirrors)) ? 1 : 1));
    SetGasGrenades(kInventory.LWCE_GetNumItems('Item_ChemGrenade') * (HasPerk(`LW_PERK_ID(SmokeAndMirrors)) ? 2 : 1));
    SetNeedleGrenades(kInventory.LWCE_GetNumItems('Item_APGrenade') * (HasPerk(`LW_PERK_ID(Grenadier)) ? 2 : 1));

    if (HasPerk(`LW_PERK_ID(Packmaster)))
    {
        // SetGhostGrenades(GetGhostGrenades()); // Shadow Devices don't scale
        SetFragGrenades(GetFragGrenades() + kInventory.LWCE_GetNumItems('Item_HEGrenade'));
        SetFlashBangs(GetFlashBangs() + kInventory.LWCE_GetNumItems('Item_FlashbangGrenade'));
        SetAlienGrenades(GetAlienGrenades() + kInventory.LWCE_GetNumItems('Item_AlienGrenade'));
        SetGasGrenades(GetGasGrenades() + kInventory.LWCE_GetNumItems('Item_ChemGrenade'));
        SetNeedleGrenades(GetNeedleGrenades() + kInventory.LWCE_GetNumItems('Item_APGrenade'));
        SetMimicBeaconCharges((GetMimicBeaconCharges()) + kInventory.LWCE_GetNumItems('Item_MimicBeacon'));
    }

    if (HasPerk(`LW_PERK_ID(ShredderAmmo)))
    {
        // TODO: HasPerk needs to differentiate the innate perk from the one granted by the item
        m_iShredderRockets = 1 + kInventory.LWCE_GetNumItems('Item_ShredderRocket');
    }

    if (HasPerk(`LW_PERK_ID(FireRocket)))
    {
        SetRockets(1);

        if (HasPerk(/* Shock and Awe */ 92))
        {
            SetRockets(2);
        }

        if (class'XGTacticalGameCoreNativeBase'.static.TInventoryHasItemType(m_kCharacter.m_kChar.kInventory, /* Rocket */ 77))
        {
            SetRockets(GetRockets() + 1);
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(BattleScanner)] & 1) > 0)
    {
        SetBattleScannerCharges(2);

        if (HasPerk(/* Packmaster */ 53))
        {
            SetBattleScannerCharges(3);
        }

        if (HasPerk(ePerk_SmokeAndMirrors))
        {
            SetBattleScannerCharges(GetBattleScannerCharges() + 1);
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(BattleScanner)] >> 1) > 0)
    {
        SetBattleScannerCharges(GetBattleScannerCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] >> 1));

        if (HasPerk(/* Packmaster */ 53))
        {
            SetBattleScannerCharges(GetBattleScannerCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] >> 1));
        }

        if (HasPerk(ePerk_SmokeAndMirrors))
        {
            SetBattleScannerCharges(GetBattleScannerCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_BattleScanner] >> 1));
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(SmokeGrenade)] & 1) > 0)
    {
        SetSmokeGrenadeCharges(1);

        if (HasPerk(/* Packmaster */ 53))
        {
            SetSmokeGrenadeCharges(2);
        }

        if (HasPerk(ePerk_SmokeAndMirrors))
        {
            SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + 1);
        }
    }

    if ((m_kCharacter.m_kChar.aUpgrades[`LW_PERK_ID(SmokeGrenade)] >> 1) > 0)
    {
        SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] >> 1));

        if (HasPerk(/* Packmaster */ 53))
        {
            SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] >> 1));
        }

        if (HasPerk(ePerk_SmokeAndMirrors))
        {
            SetSmokeGrenadeCharges(GetSmokeGrenadeCharges() + (m_kCharacter.m_kChar.aUpgrades[ePerk_SmokeBomb] >> 1));
        }
    }

    if (m_kCharacter.m_kChar.eClass == eSC_Mec)
    {
        m_iFragGrenades = 0;
        m_iAlienGrenades = 0;
        m_iMediKitCharges = 0;

        // TODO change characters
        for (m_iDamageControlTurns = 0; m_iDamageControlTurns < m_kCharacter.m_kChar.kInventory.iNumLargeItems; m_iDamageControlTurns++)
        {
            if (m_kCharacter.m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecFlameThrower)
            {
                m_iFlamethrowerCharges += 2;

                if (HasPerk(/* Packmaster */ 53))
                {
                    m_iFlamethrowerCharges += 1;
                }
            }

            if (m_kCharacter.m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecGrenadeLauncher)
            {
                m_iFragGrenades += 2;
                m_iAlienGrenades += 2;

                if (HasPerk(/* Packmaster */ 53))
                {
                    m_iFragGrenades += AdditionalGrenades;
                    m_iAlienGrenades += AdditionalGrenades;
                }

                if (HasPerk(ePerk_Grenadier))
                {
                    m_iFragGrenades += 1;
                    m_iAlienGrenades += 1;
                }
            }

            if (m_kCharacter.m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecRestorativeMist)
            {
                m_iMediKitCharges += 1;

                if (HasPerk(/* Packmaster */ 53))
                {
                    m_iMediKitCharges += AdditionalRestorativeMistShots;
                }

                if (HasPerk(ePerk_FieldMedic))
                {
                    m_iMediKitCharges += 2;
                }
            }

            if (m_kCharacter.m_kChar.kInventory.arrLargeItems[m_iDamageControlTurns] == eItem_MecElectroPulse)
            {
                m_iProximityMines += 3;

                if (HasPerk(/* Packmaster */ 53))
                {
                    m_iProximityMines += AdditionalProximityMines;
                }
            }
        }

        m_iFragGrenades = Max(m_iFragGrenades, 2);
        m_iAlienGrenades = Max(m_iAlienGrenades, 2);
        m_iDamageControlTurns = 0;
    }

    // Seeker in multiplayer, presumably
    if (GetCharType() == eChar_Seeker && WorldInfo.NetMode != NM_Standalone)
    {
        SetStealthCharges(5);
    }

    for (m_iDamageControlTurns = 0; m_iDamageControlTurns < m_kCharacter.m_kChar.kInventory.iNumSmallItems; m_iDamageControlTurns++)
    {
        if (m_kCharacter.m_kChar.kInventory.arrSmallItems[m_iDamageControlTurns] == eItem_PsiGrenade)
        {
            m_iFlashBangs += HasPerk(`LW_PERK_ID(SmokeAndMirrors)) ? 2 : 1;
            m_iFlashBangs += HasPerk(`LW_PERK_ID(Packmaster)) ? 1 : 0;
        }
    }

    m_iDamageControlTurns = 0;

    if (m_kCharacter.m_kChar.eClass != eSC_Mec)
    {
        if (HasPerk(ePerk_Savior))
        {
            m_iMediKitCharges += 2;
        }

        if (!IsAlien_CheckByCharType())
        {
            m_iFlamethrowerCharges = 0; // Command charges

            if (HasPerk(`LW_PERK_ID(LegioPatriaNostra)) || HasPerk(`LW_PERK_ID(StayFrosty)))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (HasPerk(`LW_PERK_ID(FortioresUna)) || HasPerk(`LW_PERK_ID(SemperVigilans)))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (HasPerk(`LW_PERK_ID(SoShallYouFight)) || HasPerk(`LW_PERK_ID(IntoTheBreach)))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (HasPerk(`LW_PERK_ID(EspritDeCorps)) || HasPerk(`LW_PERK_ID(BandOfWarriors)))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (HasPerk(`LW_PERK_ID(CombinedArms)) || HasPerk(`LW_PERK_ID(SoOthersMayLive)))
            {
                m_iFlamethrowerCharges += 1;
            }

            if (LWCE_GetCharacter().HasItemInInventory('Item_MotionTracker'))
            {
                m_iProximityMines = class'XGTacticalGameCore'.default.EXALT_LOOT1;

                if (HasPerk(`LW_PERK_ID(Packmaster)))
                {
                    m_iProximityMines += 1;
                }
            }
        }
    }

    `LWCE_MOD_LOADER.OnUpdateItemCharges(self);
}

reliable server function UpdateUnitBuffs()
{
    local int Index;
    local XGAbilityTree kAbilityTree;

    kAbilityTree = `GAMECORE.m_kAbilities;

    RemoveAllBuffs();
    kAbilityTree.RegenBonusPerks(self, none);
    kAbilityTree.RegenPenaltyPerks(self);
    kAbilityTree.RegenPassivePerks(self);

    // Copy base-game data into ours

    // Bonuses
    m_arrCEBonuses.Remove(0, m_arrCEBonuses.Length);

    for (Index = 0; Index < ePerk_MAX; Index++)
    {
        if (m_arrBonuses[Index] > 0)
        {
            m_arrCEBonuses.AddItem(m_arrBonuses[Index]);
        }
    }

    `LWCE_MOD_LOADER.OnRegenBonusPerks(self, none);

    // Passives
    m_arrCEPassives.Remove(0, m_arrCEPassives.Length);

    for (Index = 0; Index < ePerk_MAX; Index++)
    {
        if (m_arrPassives[Index] > 0)
        {
            m_arrCEPassives.AddItem(m_arrPassives[Index]);
        }
    }

    `LWCE_MOD_LOADER.OnRegenPassivePerks(self);

    // Penalties
    m_arrCEPenalties.Remove(0, m_arrCEPenalties.Length);

    for (Index = 0; Index < ePerk_MAX; Index++)
    {
        if (m_arrPenalties[Index] > 0)
        {
            m_arrCEPenalties.AddItem(m_arrPenalties[Index]);
        }
    }

    `LWCE_MOD_LOADER.OnRegenPenaltyPerks(self);
}

simulated event SetBETemplate()
{
    // Don't set up bioelectric skin particles for visibility helpers, so they aren't shown
    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(self))
    {
        return;
    }

    super.SetBETemplate();
}

protected function bool ShouldStopCombatMusicAfterBeingStunned()
{
    local array<XGUnitNativeBase> EnemiesInSquadSight;
    local XGPlayer kPlayer;
    local XGSquad Squad;
    local XGUnitNativeBase FriendlyUnit, EnemyUnit;

    // Logic here is basically mirrored from XGPlayer.OnUnitKilled, which stops the combat music
    // when the last visible enemy dies
    kPlayer = XGBattle_SP(`BATTLE).GetHumanPlayer();

    if (kPlayer.m_bKismetControlledCombatMusic)
    {
        return false;
    }

    Squad = kPlayer.GetSquad();
    FriendlyUnit = Squad.GetNextGoodMember();

    if (FriendlyUnit == none)
    {
        return true;
    }

    XGUnit(FriendlyUnit).DetermineEnemiesInSquadSight(EnemiesInSquadSight, FriendlyUnit.Location, false, false);

    foreach EnemiesInSquadSight(EnemyUnit)
    {
        if (EnemyUnit != self && !XGUnit(EnemyUnit).IsDeadOrDying())
        {
            return false;
        }
    }

    return true;
}

simulated event Tick(float fDeltaT)
{
    super.Tick(fDeltaT);
}

simulated state Active
{
    function AddPathAction(optional int iCustomPathLength = 0, optional bool bNoCloseCombat = false)
    {
        local XGAction_Path kAction;

        if (`BATTLE.IsTurnTimerCloseToExpiring())
        {
            AddIdleAction();
            return;
        }

        if (iCustomPathLength == 0)
        {
            if (GetMoves() == 0)
            {
                AddIdleAction();
                return;
            }
            else if (IsMine() && IsFlying())
            {
                SetDashing(false);
                SetPathLength(GetMaxPathLength() * 2);
            }
            else
            {
                SetPathLength(GetMaxPathLength());
            }
        }
        else
        {
            SetPathLength(iCustomPathLength);
        }

        GetPathingPawn().MyUnit = none;

        kAction = Spawn(class'LWCE_XGAction_Path', Owner);
        kAction.Init(self);
        kAction.SetBoundToClientProxyID(m_iBindNextPathActionToClientProxyActionID);
        kAction.m_bNoCloseCombat = bNoCloseCombat;
        AddAction(kAction);

        m_iBindNextPathActionToClientProxyActionID = -1;
    }

    simulated event BeginState(name nmPrev)
    {
        super.BeginState(nmPrev);
    }

    simulated event EndState(name nmNext)
    {
        super.EndState(nmNext);
    }
}

auto simulated state Inactive
{
    simulated event BeginState(name nmPrev)
    {
        super.BeginState(nmPrev);
    }
}