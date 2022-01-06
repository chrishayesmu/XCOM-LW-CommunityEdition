class Highlander_XGStrategySoldier extends XGStrategySoldier;

function DEMOUltimateSoldier()
{
    `HL_LOG_CLS("XGStrategySoldier.DEMOUltimateSoldier is deprecated in the Highlander. Use Highlander_XGStrategySoldier.CheckForDamagedOrLostItems instead. Stack trace follows.");
}

/// <summary>
/// Rolls each of the soldier's eligible equipped items to see if any were damaged or lost in the previous mission.
/// Should only be called immediately after a mission ends, while the soldier still has their gear equipped. Calling at
/// other times, or multiple times, may result in extra gear being lost unnecessarily.
/// </summary>
function CheckForDamagedOrLostItems()
{
    local Highlander_XGStorage kStorage;
    local int Index, iItemId;

    kStorage = `HL_STORAGE;

    iItemId = GetInventory().iPistol;

    if (iItemId != 0 && !kStorage.HL_IsInfinite(iItemId))
    {
        if (ShouldItemBeLost(iItemId))
        {
            LOCKERS().EquipPistol(self, `LW_ITEM_ID(Pistol));
            LoseItem(iItemId, kStorage);
        }
        else if (ShouldItemBeDamaged(iItemId))
        {
            LOCKERS().EquipPistol(self, `LW_ITEM_ID(Pistol));
            DamageItem(iItemId, kStorage);
        }
    }

    for (Index = 0; Index < GetInventory().iNumLargeItems; Index++)
    {
        iItemId = GetInventory().arrLargeItems[Index];

        if (!kStorage.HL_IsInfinite(iItemId) && iItemId != 0)
        {
            if (ShouldItemBeLost(iItemId))
            {
                LOCKERS().UnequipLargeItem(self, Index);
                LoseItem(iItemId, kStorage);
            }
            else if (ShouldItemBeDamaged(iItemId))
            {
                LOCKERS().UnequipLargeItem(self, Index);
                DamageItem(iItemId, kStorage);
            }
        }
    }

    for (Index = 0; Index < GetInventory().iNumSmallItems; Index++)
    {
        iItemId = GetInventory().arrSmallItems[Index];

        if (!kStorage.HL_IsInfinite(iItemId) && iItemId != 0)
        {
            if (ShouldItemBeLost(iItemId))
            {
                LOCKERS().UnequipSmallItem(self, Index);
                LoseItem(iItemId, kStorage);
            }
            else if (ShouldItemBeDamaged(iItemId))
            {
                LOCKERS().UnequipSmallItem(self, Index);
                DamageItem(iItemId, kStorage);
            }
        }
    }

    if (GetPsiRank() != 7 && !IsATank())
    {
        iItemId = GetInventory().iArmor;

        if (!kStorage.HL_IsInfinite(iItemId))
        {
            if (ShouldItemBeLost(iItemId))
            {
                LOCKERS().EquipArmor(self, IsAugmented() ? `LW_ITEM_ID(BaseAugments) : `LW_ITEM_ID(TacArmor));
                LoseItem(iItemId, kStorage);
            }
            else if (ShouldItemBeDamaged(iItemId))
            {
                LOCKERS().EquipArmor(self, IsAugmented() ? `LW_ITEM_ID(BaseAugments) : `LW_ITEM_ID(TacArmor));
                DamageItem(iItemId, kStorage);
            }
        }
    }

    if (GetInventory().arrLargeItems[0] == 0)
    {
        LOCKERS().EquipLargeItem(self, kStorage.HL_GetInfinitePrimary(self), 0);
    }

    if (GetInventory().arrLargeItems[1] == 0)
    {
        LOCKERS().EquipLargeItem(self, kStorage.HL_GetInfiniteSecondary(self), 1);
    }

    if (GetCurrentStat(eStat_HP) == 0)
    {
        kStorage.ReleaseLoadout(self);
    }
}

function SetSoldierClass(ESoldierClass eNewClass)
{
    local Highlander_XGStorage kStorage;
    local TInventory kNewLoadout;
    local ESoldierClass ePreviousClass;
    local array<ECharacterVoice> PossibleVoices;
    local int iEquipmentGroup;

    kStorage = `HL_STORAGE;
    ePreviousClass = GetClass();
    kNewLoadout = m_kChar.kInventory;
    m_kChar.eClass = eNewClass;
    m_kSoldier.kClass.eType = eNewClass;
    kNewLoadout = m_kChar.kInventory;

    switch (eNewClass)
    {
        case eSC_Sniper:
            if (HQ().HasBonus(`LW_HQ_BONUS_ID(FirstRecce)) > 0)
            {
                m_kChar.aStats[eStat_Defense] += HQ().HasBonus(`LW_HQ_BONUS_ID(FirstRecce));
            }

            if (HasPerk(GetPerkInClassTree(1, 0, false)))
            {
                iEquipmentGroup = 7;
                m_iEnergy = 11; // Sniper
            }
            else
            {
                iEquipmentGroup = 11;
                m_iEnergy = 21; // Scout
            }

            break;
        case eSC_HeavyWeapons:
            if (HQ().HasBonus(`LW_HQ_BONUS_ID(ArmyOfTheSouthernCross)) > 0)
            {
                m_kChar.aStats[eStat_Offense] += HQ().HasBonus(`LW_HQ_BONUS_ID(ArmyOfTheSouthernCross));
            }

            if (HasPerk(GetPerkInClassTree(1, 0, false)))
            {
                iEquipmentGroup = 8;
                m_iEnergy = 12; // Rocketeer
                TACTICAL().TInventoryLargeItemsSetItem(kNewLoadout, 1, `LW_ITEM_ID(RocketLauncher));
                TACTICAL().TInventoryLargeItemsSetItem(m_kBackedUpLoadout, 1, `LW_ITEM_ID(RocketLauncher));
            }
            else
            {
                iEquipmentGroup = 4;
                m_iEnergy = 22; // Gunner
            }

            break;
        case eSC_Support:
            if (HQ().HasBonus(`LW_HQ_BONUS_ID(TaskForceArrowhead)) > 0)
            {
                m_kChar.aStats[eStat_Will] += HQ().HasBonus(`LW_HQ_BONUS_ID(TaskForceArrowhead));
            }

            if (HasPerk(GetPerkInClassTree(1, 0, false)))
            {
                iEquipmentGroup = 5;
                m_iEnergy = 13; // Medic
            }
            else
            {
                iEquipmentGroup = 10;
                m_iEnergy = 23; // Engineer
            }

            break;
        case eSC_Assault:
            if (HQ().HasBonus(`LW_HQ_BONUS_ID(Spetznaz)) > 0)
            {
                m_kChar.aStats[eStat_HP] += HQ().HasBonus(`LW_HQ_BONUS_ID(Spetznaz));
            }

            if (HasPerk(GetPerkInClassTree(1, 0, false)))
            {
                iEquipmentGroup = 6;
                m_iEnergy = 14; // Assault
            }
            else
            {
                iEquipmentGroup = 5;
                m_iEnergy = 24; // Infantry
            }

            break;
        case eSC_Mec:
            m_bPsiTested = true;
            LOCKERS().UnequipArmor(self);
            m_kSoldier.iPsiXP = m_kChar.aStats[eStat_Will];
            m_kChar = TACTICAL().GetTCharacter(eChar_Soldier);
            m_kChar.eClass = eNewClass;
            m_kSoldier.iPsiRank = 0;

            ClearPerks(true);
            GivePerk(ePerk_OneForAll);
            GivePerk(/* Combined Arms */ 138);

            m_kChar.aStats[eStat_HP] += 4;

            if (IsOptionEnabled(`LW_SECOND_WAVE_ID(CinematicMode)))
            {
                m_kChar.aStats[eStat_Offense] += int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI);
            }

            if (HQ().HasBonus(`LW_HQ_BONUS_ID(Robotics)) > 0)
            {
                m_kChar.aStats[eStat_Offense] += HQ().HasBonus(`LW_HQ_BONUS_ID(Robotics));
            }

            // Carry over some will from the non-MEC unit
            if ( m_kSoldier.iPsiXP - m_kChar.aStats[eStat_Will] - (4 * GetRank()) > 0)
            {
                m_kChar.aStats[eStat_Will] += m_kSoldier.iPsiXP - m_kChar.aStats[eStat_Will] - (4 * GetRank());
            }

            m_kSoldier.iPsiXP = 0;
            BARRACKS().UpdateFoundryPerksForSoldier(self);
            kNewLoadout = m_kChar.kInventory;
            kNewLoadout.iArmor = eItem_MecCivvies;

            iEquipmentGroup = 20;
            m_iEnergy += 20; // Base class +20 maps to the corresponding MEC class

            if (GetRank() < 7)
            {
                m_kSoldier.iXP = TACTICAL().GetXPRequired(GetRank() - 1) + int(float(TACTICAL().GetXPRequired(GetRank()) - TACTICAL().GetXPRequired(GetRank() - 1)) * (float(1) - (float(TACTICAL().GetXPRequired(GetRank() + 1) - m_kSoldier.iXP) / float(TACTICAL().GetXPRequired(GetRank() + 1) - TACTICAL().GetXPRequired(GetRank())))));
            }
            else
            {
                m_kSoldier.iXP = TACTICAL().GetXPRequired(GetRank() - 1);
            }

            m_kSoldier.iRank -= 1;

            if (m_kSoldier.iRank > BARRACKS().m_iHighestMecRank)
            {
                BARRACKS().m_iHighestMecRank = m_kSoldier.iRank;
            }

            if (!IsASpecialSoldier())
            {
                `CONTENTMGR.GetPossibleVoices(EGender(m_kSoldier.kAppearance.iGender), m_kSoldier.kAppearance.iLanguage, true, PossibleVoices);
                m_kSoldier.kAppearance.iVoice = PossibleVoices[Rand(PossibleVoices.Length)];
            }

            m_bAllIn = false;
            break;
        default:
            eNewClass = ESoldierClass(1 + Rand(4));

            while (ePreviousClass == eNewClass)
            {
                eNewClass = ESoldierClass(1 + Rand(4));
            }

            m_kChar.eClass = eNewClass;
            m_kSoldier.kClass.eType = eNewClass;
            GivePerk(GetPerkInClassTree(1, 2 * Rand(2), false));
            SetSoldierClass(eNewClass);

            return;
    }

    m_kSoldier.kClass.eWeaponType = EWeaponProperty(iEquipmentGroup);
    m_kSoldier.kClass.strName = class'XGLocalizedData'.default.SoldierClassNames[m_iEnergy];
    TACTICAL().TInventoryLargeItemsSetItem(kNewLoadout, 0, kStorage.HL_GetInfinitePrimary(self));
    TACTICAL().TInventoryLargeItemsSetItem(m_kBackedUpLoadout, 0, kStorage.HL_GetInfinitePrimary(self));

    if (eNewClass != eSC_Mec)
    {
        if (HasPerk(`LW_PERK_ID(FireRocket)))
        {
            TACTICAL().TInventoryLargeItemsSetItem(kNewLoadout, 1, kStorage.HL_GetInfiniteSecondary(self));
            TACTICAL().TInventoryLargeItemsSetItem(m_kBackedUpLoadout, 1, kStorage.HL_GetInfiniteSecondary(self));
        }
        else
        {
            kNewLoadout.iPistol = kStorage.HL_GetInfiniteSecondary(self);
            m_kBackedUpLoadout.iPistol = kStorage.HL_GetInfiniteSecondary(self);
        }
    }

    LOCKERS().ApplySoldierLoadout(self, kNewLoadout);

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(TrainingRoulette)) && !IsASuperSoldier())
    {
        AssignRandomPerks();
    }

    // Set the soldier's cosmetics based on their class
    if (eNewClass != eSC_Mec)
    {
        // ePreviousClass: index into cosmetics config
        ePreviousClass = 0;

        switch (m_iEnergy)
        {
            case 11: // Sniper
                ePreviousClass = 4;
                break;
            case 21: // Scout
                ePreviousClass = 6;
                break;
            case 12: // Rocketeer
                ePreviousClass = 8;
                break;
            case 22: // Gunner
                ePreviousClass = 10;
                break;
            case 13: // Medic
                ePreviousClass = 12;
                break;
            case 23: // Engineer
                ePreviousClass = 14;
                break;
            case 14: // Assault
                ePreviousClass = 16;
                break;
            case 24: // Infantry
                ePreviousClass = 18;
                break;
        }

        if (ePreviousClass != 0)
        {
            if (class'XGTacticalGameCore'.default.HQ_BASE_POWER[ePreviousClass] >= 1)
            {
                m_kSoldier.kAppearance.iArmorTint = class'XGTacticalGameCore'.default.HQ_BASE_POWER[ePreviousClass] - 1;

                if (class'XGTacticalGameCore'.default.HQ_BASE_POWER[ePreviousClass + 1] >= 1)
                {
                    m_kSoldier.kAppearance.iHaircut = class'XGTacticalGameCore'.default.HQ_BASE_POWER[ePreviousClass + 1];
                }
            }
        }
    }

    OnLoadoutChange();
}

protected function DamageItem(int iItemId, Highlander_XGStorage kStorage)
{
    kStorage.HL_DamageItem(iItemId, 1);

    // Mark that an item was damaged, for the debrief UI
    `HL_UTILS.AdjustItemQuantity(kStorage.m_arrHLItemsDamagedLastMission, iItemId, 1);
}

protected function LoseItem(int iItemId, Highlander_XGStorage kStorage)
{
    kStorage.RemoveItem(iItemId, 1);

    // Mark that an item was lost, for the debrief UI
    `HL_UTILS.AdjustItemQuantity(kStorage.m_arrHLItemsLostLastMission, iItemId, 1);
}

protected function bool ShouldItemBeDamaged(int iItemId)
{
    local float fPercentHPMissing;
    local int iBaseDamageChance, iScaledDamageChance;

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(Durability)))
    {
        return false;
    }

    // TODO: need a new data source for damage chance
    iBaseDamageChance = int(class'XGGameData'.static.GetMecBaseArmor(EItemType(iItemId)));

    if (iBaseDamageChance <= 0)
    {
        return false;
    }

    // Damage chance is scaled by how much HP the soldier is missing, maxing out at the value in config when a soldier dies
    fPercentHPMissing = 1.0 - (float(GetCurrentStat(eStat_HP)) / float(GetMaxStat(eStat_HP)));
    iScaledDamageChance = int(fPercentHPMissing * iBaseDamageChance);

    if (Roll(iScaledDamageChance))
    {
        return true;
    }

    // Without Wear and Tear enabled, there's no other chance for items to be damaged
    if (!IsOptionEnabled(`LW_SECOND_WAVE_ID(WearAndTear)))
    {
        return false;
    }

    return Roll(int(class'XGTacticalGameCore'.default.SW_RARE_PSI));
}

protected function bool ShouldItemBeLost(int iItemId)
{
    // Items are only lost when a soldier dies
    if (GetCurrentStat(eStat_HP) > 0)
    {
        return false;
    }

    // If the Total Loss second wave option is on, items can be lost any time a soldier dies;
    // otherwise, they're only lost if the mission is failed (aka the soldier is marked MIA)
    if (!IsOptionEnabled(`LW_SECOND_WAVE_ID(TotalLoss)) && !m_bMIA)
    {
        return false;
    }

    // TODO: potential place to add a mod hook

    return Roll(BLUESHIRT_HP_MOD);
}