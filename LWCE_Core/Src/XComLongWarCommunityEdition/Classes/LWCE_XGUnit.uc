class LWCE_XGUnit extends XGUnit;

struct CheckpointRecord_LWCE_XGUnit extends CheckpointRecord_XGUnit
{
    var LWCE_TCharacter m_kCEChar;
    var LWCE_TSoldier m_kCESoldier;

    var array<int> m_arrCEBonuses;
    var array<int> m_arrCEPassives;
    var array<int> m_arrCEPenalties;
};

var LWCE_TCharacter m_kCEChar;
var LWCE_TSoldier m_kCESoldier;

var array<int> m_arrCEBonuses;
var array<int> m_arrCEPassives;
var array<int> m_arrCEPenalties;

// -------------------------------------------------
// Functions newly added in LWCE
//
// Use these functions instead of accessing data directly!
// There's a lot of weird stuff going on under the hood.
// -------------------------------------------------

function LWCE_XGCharacter LWCE_GetCharacter()
{
    return LWCE_XGCharacter(m_kCharacter);
}

function int GetClassId()
{
    return m_kCEChar.iClassId;
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

function GivePerk(int iPerkId, optional int iSourceTypeId = 0, optional int iSourceId = 0)
{
    local LWCE_TIDWithSource kPerkData;

    // Add base game perks to the underlying character, for native code to read
    if (iPerkId < ePerk_MAX)
    {
        m_kCharacter.m_kChar.aUpgrades[iPerkId] = m_kCharacter.m_kChar.aUpgrades[iPerkId] | 1;
    }

    kPerkData.Id = iPerkId;
    kPerkData.SourceId = iSourceId;
    kPerkData.SourceType = iSourceTypeId;

    m_kCEChar.arrPerks.AddItem(kPerkData);
}

function bool HasAbility(int iAbilityId)
{
    // A ternary would make sense here but UnrealScript keeps breaking shit when I use them
    if (m_kCEChar.arrAbilities.Find('Id', iAbilityId) != INDEX_NONE)
    {
        return true;
    }

    return false;
}

function bool HasCharacterProperty(int iCharPropId)
{
    if (m_kCEChar.arrProperties.Find('Id', iCharPropId) != INDEX_NONE)
    {
        return true;
    }

    return false;
}

function bool HasPerk(int iPerkId)
{
    // Need to check base game data as well for effects that only apply there
    if (iPerkId < ePerk_MAX && m_kCharacter.m_kChar.aUpgrades[iPerkId] != 0)
    {
        return true;
    }

    if (m_kCEChar.arrPerks.Find('Id', iPerkId) != INDEX_NONE)
    {
        return true;
    }

    return false;
}

function bool HasTraversal(int iTraversalId)
{
    if (m_kCEChar.arrTraversals.Find('Id', iTraversalId) != INDEX_NONE)
    {
        return true;
    }

    return false;
}

function bool IsInExecutionerRange()
{
    return GetHealthPct() <= `LWCE_TACCFG(fExecutionerHealthThreshold);
}

function bool IsPsionic()
{
    return m_kCEChar.bHasPsiGift;
}

// -------------------------------------------------
// Overrides/additions to base game functions below
// -------------------------------------------------

function int AbsorbDamage(const int IncomingDamage, XGUnit kDamageCauser, XGWeapon kWeapon)
{
    local LWCE_XGWeapon kCEWeapon;
    local float fAbsorptionFieldsBasis, fReturnDmg, fDist;
    local int iReturnDmg;

    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(self))
    {
        return 0;
    }

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
    if (kDamageCauser != none && HasPerk(ePerk_ShockAbsorbentArmor))
    {
        fDist = VSize(GetLocation() - kDamageCauser.GetLocation());

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
        if (!IsFlankedBy(kDamageCauser) || (kWeapon != none && kWeapon.IsA('XGWeapon_NeedleGrenade')))
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

    if (kDamageCauser != none)
    {
        // Combined Arms: negate 1 DR
        if (LWCE_XGUnit(kDamageCauser).HasPerk(`LW_PERK_ID(CombinedArms)))
        {
            fReturnDmg += `LWCE_TACCFG(fCombinedArmsDRPenetration);
        }

        if (class'LWCEInventoryUtils'.static.HasItemOfName(LWCE_XGUnit(kDamageCauser).m_kCEChar.kInventory, 'Item_ArmorPiercingAmmo'))
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

                if ((kDamageCauser.m_kCharacter.m_kChar.aUpgrades[123] & 32) > 0) // Quenchguns
                {
                    fReturnDmg += `LWCE_TACCFG(fQuenchgunsDRPenetration);
                }
            }
        }

        fReturnDmg = FMin(fReturnDmg, float(IncomingDamage));
    }

    if (fReturnDmg < float(IncomingDamage))
    {
        if (kDamageCauser != none)
        {
            if (kWeapon != none && kWeapon.HasProperty(eWP_Assault))
            {
                // DR penalty for shotguns unless using Breaching Ammo
                if (!class'LWCEInventoryUtils'.static.HasItemOfName(LWCE_XGUnit(kDamageCauser).m_kCEChar.kInventory, 'Item_BreachingAmmo'))
                {
                    fReturnDmg -= (`LWCE_TACCFG(fShotgunDRPenalty) * (float(IncomingDamage) - fReturnDmg));
                }
            }
        }

        fReturnDmg = FMax(fReturnDmg, float(0));

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

    if (kActiveWeapon.GetRemainingAmmo() < kGameCore.LWCE_GetOverheatIncrement(class'LWCE_XGWeapon_Extensions'.static.GetItemName(kActiveWeapon), iAbilityType, m_kCEChar, bReactionShot))
    {
        return false;
    }

    return true;
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

simulated function AddWeaponAbilities(XGTacticalGameCoreNativeBase GameCore, Vector vLocation, out array<XGAbility> arrAbilities, optional bool bForLocalUseOnly = false)
{
    local int Index, iAbilityId, iBackpackIndex;
    local name nmAbilityId;
    local XGCharacter kChar;
    local LWCE_XGInventory kInventory;
    local LWCE_XGTacticalGameCore kGameCore;
    local LWCE_XGWeapon kWeapon, kActiveWeapon;
    local LWCEWeaponTemplate kWeaponTemplate;
    local array<LWCE_XGWeapon> arrWeapons, arrEquippableWeapons;

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
        `LWCE_LOG_CLS("Checking weapon item " $ kWeapon.m_kTemplate.DataName);
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

            `LWCE_LOG_CLS("Weapon template " $ kWeaponTemplate.DataName $ " has ability " $ nmAbilityId $ ", mapping to ID " $ iAbilityId);
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

    arrBackPackItems = class'LWCEInventoryUtils'.static.GetAllBackpackItems(m_kCEChar.kInventory);
    m_aCurrentStats[9] = m_aCurrentStats[eStat_HP];
    RemoveStatModifiers(m_aInventoryStats);

    `LWCE_GAMECORE.LWCE_GetInventoryStatModifiers(m_aInventoryStats, m_kCEChar, nmEquippedWeapon, arrBackPackItems);

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

function BuildAbilities(optional bool bUpdateUI = true)
{
    local bool bShouldBuild;
    local int Index;
    local Vector vLocation;
    local array<XGAbility> arrAbilities;
    local XGTacticalGameCore kGameCore;

    //`LWCE_LOG_CLS("BuildAbilities: begin - char type " $ m_kCharacter.m_kChar.iType);

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
    //AddPsiAbilities(vLocation, arrAbilities);
    //AddCharacterAbilities(vLocation, arrAbilities);
    //AddArmorAbilities(vLocation, arrAbilities);

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

    `LWCE_LOG_CLS("GenerateAbilities: iAbility = " $ iAbility);

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

simulated function int GetAggressionBonus()
{
    return Clamp(`LWCE_TACCFG(iAggressionCritChanceBonusPerVisibleEnemy) * m_arrVisibleEnemies.Length, 0, `LWCE_TACCFG(iAggressionMaximumBonus));
}

simulated function array<int> GetBonusesPerkList()
{
    m_iNumOfBonuses = m_arrCEBonuses.Length;
    return m_arrCEBonuses;
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

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_AlloyJacketedRounds'))
            {
                m_arrItemInfos.AddItem(14);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_EnhancedBeamOptics'))
            {
                m_arrItemInfos.AddItem(15);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_PlasmaStellerator'))
            {
                m_arrItemInfos.AddItem(16);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_LaserSight'))
            {
                m_arrItemInfos.AddItem(17);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_CeramicPlating'))
            {
                m_arrItemInfos.AddItem(18);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_HiCapMags'))
            {
                m_arrItemInfos.AddItem(19);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_BattleComputer'))
            {
                m_arrItemInfos.AddItem(20);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_ChameleonSuit'))
            {
                m_arrItemInfos.AddItem(21);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_HoloTargeter'))
            {
                m_arrItemInfos.AddItem(22);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_SmartshellPod'))
            {
                m_arrItemInfos.AddItem(23);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_CoreArmoring'))
            {
                m_arrItemInfos.AddItem(24);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_TheThumper'))
            {
                m_arrItemInfos.AddItem(25);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_ImpactVest'))
            {
                m_arrItemInfos.AddItem(26);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_FuelCell'))
            {
                m_arrItemInfos.AddItem(27);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_AlloyBipod'))
            {
                m_arrItemInfos.AddItem(28);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_BreachingAmmo'))
            {
                m_arrItemInfos.AddItem(29);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_ArmorPiercingAmmo'))
            {
                m_arrItemInfos.AddItem(30);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_WalkerServos'))
            {
                m_arrItemInfos.AddItem(31);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_NeuralGunlink'))
            {
                m_arrItemInfos.AddItem(32);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_ShredderAmmo'))
            {
                m_arrItemInfos.AddItem(33);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_PsiScreen'))
            {
                m_arrItemInfos.AddItem(34);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_IlluminatorGunsight'))
            {
                m_arrItemInfos.AddItem(35);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_IncineratorModule'))
            {
                m_arrItemInfos.AddItem(36);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_TargetingModule'))
            {
                m_arrItemInfos.AddItem(37);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_ReinforcedArmor'))
            {
                m_arrItemInfos.AddItem(38);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_EleriumTurbos'))
            {
                m_arrItemInfos.AddItem(39);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_CognitiveEnhancer'))
            {
                m_arrItemInfos.AddItem(40);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_Neuroregulator'))
            {
                m_arrItemInfos.AddItem(41);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_FlakAmmo'))
            {
                m_arrItemInfos.AddItem(42);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_AlloyPlating'))
            {
                m_arrItemInfos.AddItem(43);
            }

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_DrumMags'))
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
    kWeapon.GetStatChanges(kStatChanges, m_kCEChar);

    // I'm not really sure why we subtract the weapon's aim, but that's how it's done in the original
    iAim -= `LWCE_WEAPON_FROM_XG(GetInventory().GetActiveWeapon()).kStatChanges.iAim;

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
    if (super.LoadInit(NewPlayer))
    {
        // LWCE issue #23: the character's reference to the unit is not persisted, causing it to be lost
        // if the tac game is saved and loaded. We simply restore it manually.
        m_kCharacter.m_kUnit = self;

        return true;
    }

    return false;
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
    m_bBuildAbilityDataDirty = true;
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

        m_bBuildAbilitiesTriggeredFromVisibilityChange = bVisibilityChanged;
        BuildAbilities(bVisibilityChanged);
    }
    else
    {
        m_bBuildAbilitiesTriggeredFromVisibilityChange = false;
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
    local MeshComponent MeshComp;
    local Vector vRotDir;
    local class<XComUnitPawn> PawnClass;

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
        LWCE_XComHumanPawn(m_kPawn).LWCE_Init(m_kCEChar, m_kCEChar.kInventory, m_kCESoldier.kAppearance);
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
        SetShredderRockets(m_kCharacter.m_kChar.aUpgrades[ePerk_ShredderRocket] & 1);
        SetShredderRockets(m_iShredderRockets + (m_kCharacter.m_kChar.aUpgrades[ePerk_ShredderRocket] >> 1));
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

            if (class'LWCEInventoryUtils'.static.HasItemOfName(m_kCEChar.kInventory, 'Item_MotionTracker'))
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