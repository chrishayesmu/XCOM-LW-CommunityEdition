class Highlander_XGSoldierUI extends XGSoldierUI;

event Destroyed()
{
    super.Destroyed();
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
}

function TInventoryOption BuildInventoryOption(int iItemId, int iOptionType, bool bHighlight)
{
    local HL_TItem kItem;
    local TInventoryOption kOption;

    kItem = `HL_ITEM(iItemId);

    kOption.iItem = iItemId;
    kOption.iOptionType = iOptionType;

    switch (iOptionType)
    {
        case eInvSlot_Armor:
            kOption.txtLabel.StrValue = m_strArmor;
            break;
        case eInvSlot_Pistol:
            kOption.txtLabel.StrValue = m_strPistol;
            break;
        case eInvSlot_Large:
            kOption.txtLabel.StrValue = m_strLargeItem;
            break;
        case eInvSlot_Small:
            kOption.txtLabel.StrValue = m_strSmallItem;
            break;
    }

    if (iItemId != 0)
    {
        kOption.txtName.StrValue = kItem.StrName;
        kOption.imgItem.strPath = kItem.ImagePath;
        kOption.bInfinite = `HL_STORAGE.HL_IsInfinite(iItemId);
    }
    else
    {
        kOption.txtName.StrValue = m_strEmpty;
        kOption.imgItem.iImage = 0;
    }

    kOption.bHighlight = bHighlight;
    return kOption;
}

function TInventoryOption BuildLockerOption(TLockerItem kItem, int iOptionType)
{
    local Highlander_XGItemTree kItemTree;
    local HL_TItem kInvItem;
    local TInventoryOption kOption;

    kItemTree = `HL_ITEMTREE;
    kInvItem = kItemTree.HL_GetItem(kItem.iItem);

    kOption.iItem = kItem.iItem;
    kOption.iOptionType = iOptionType;
    kOption.iState = eUIState_Normal;
    kOption.bShowItemCard = true;

    if (kItem.bTechLocked)
    {
        kOption.txtLabel.StrValue = m_strLabelRequiresResearch;
    }
    else if (kItem.bClassLocked)
    {
        if (m_kSoldier == BARRACKS().m_kVolunteer && kItemTree.IsArmor(kItem.iItem))
        {
            kOption.txtLabel.StrValue = Caps(m_strLabelUnavailableToVolunteer);
        }
        else
        {
            kOption.txtLabel.StrValue = m_strLabelItemUnavailableToClass;
        }
    }
    else if (kItemTree.HL_IsItemUniqueEquip(kItem.iItem) && HasItemEquipped(kItem.iItem))
    {
        kOption.txtLabel.StrValue = m_strLabelUniqueEquip;
    }
    else if (!HasAnyOfItemsEquipped(kInvItem.arrCompatibleLargeEquipment, true))
    {
        kOption.txtLabel.StrValue = m_strLabelReaperRoundsRestriction;
    }
    else if (HasAnyOfItemsEquipped(kInvItem.arrIncompatibleLargeEquipment, false))
    {
        kOption.txtLabel.StrValue = m_strLabelReaperRoundsRestriction;
    }
    else if (HasAnyOfItemsEquipped(kInvItem.arrMutuallyExclusiveEquipment, false))
    {
        kOption.txtLabel.StrValue = m_strLabelClassTypeOnly;
    }

    if (kOption.txtLabel.StrValue != "")
    {
        kOption.txtLabel.iState = eUIState_Bad;
        kOption.iState = eUIState_Disabled;
    }

    kOption.txtName.StrValue = kInvItem.strName;
    kOption.imgItem.strPath = kInvItem.ImagePath;
    kOption.bInfinite = `HL_STORAGE.HL_IsInfinite(kOption.iItem);

    if (!kOption.bInfinite)
    {
        kOption.txtQuantity.StrValue = string(kItem.iQuantity);
    }

    return kOption;
}

function TItemCard GetItemCardFromOption(TInventoryOption kItemOp)
{
    local TItemCard kItemCard;

    `HL_LOG_DEPRECATED_CLS(GetItemCardFromOption);

    return kItemCard;
}

function HL_TItemCard HL_GetItemCardFromOption(TInventoryOption kItemOp)
{
    local HL_TItemCard kItemCard;
    local int iMedalIndex, iItemId;

    iItemId = kItemOp.iItem;

    if (`GAMECORE.ItemIsAccessory(iItemId))
    {
        kItemCard = class'Highlander_XGItemCards'.static.BuildEquippableItemCard(iItemId);
        kItemCard.iCharges = HL_GetItemCharges(iItemId, false, true);
    }
    else if (`GAMECORE.ItemIsWeapon(iItemId))
    {
        iMedalIndex = iItemId;

        if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DamageRoulette)))
        {
            iMedalIndex = iMedalIndex | 65536;
        }

        if (`GAMECORE.WeaponHasProperty(iItemId, eWP_Pistol) && ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(ReflexPistols)))
        {
            iMedalIndex = iMedalIndex | 256;
        }

        if (iItemId == `LW_ITEM_ID(APGrenade) && ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienGrenades)))
        {
            iMedalIndex = iMedalIndex | 512;
        }

        if (iItemId == `LW_ITEM_ID(KineticStrikeModule) && ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(MecCloseCombat)))
        {
            iMedalIndex = iMedalIndex | 1024;
        }

        if (iItemId == `LW_ITEM_ID(GrenadeLauncher) && ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienGrenades)))
        {
            iMedalIndex = iMedalIndex | 256;
        }

        if (iItemId == `LW_ITEM_ID(Flamethrower) && ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(JelliedElerium)))
        {
            iMedalIndex = iMedalIndex | 768;
        }

        if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(EnhancedPlasma)))
        {
            iMedalIndex = iMedalIndex | 131072;
        }

        kItemCard = class'Highlander_XGItemCards'.static.BuildWeaponCard(iMedalIndex);

        if (`GAMECORE.WeaponHasProperty(iItemId, eWP_Pistol) && ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(MagPistols)))
        {
            kItemCard.iBaseCritChance += 10;
        }

        return kItemCard;
    }
    else
    {
        kItemCard = class'Highlander_XGItemCards'.static.BuildItemCard(iItemId);
    }

    return kItemCard;
}

function int GetItemCharges(EItemType eItem, optional bool bForce1_for_NonGrenades = false, optional bool bForItemCardDisplay = false)
{
    `HL_LOG_DEPRECATED_CLS(GetItemCharges);
    return 0;
}

function int HL_GetItemCharges(int iItemId, optional bool bForce1_for_NonGrenades = false, optional bool bForItemCardDisplay = false)
{
    local int NumCharges;

    if (iItemId == 0)
    {
        return 0;
    }

    NumCharges = 1;

    switch (iItemId)
    {
        case `LW_ITEM_ID(HEGrenade):
        case `LW_ITEM_ID(AlienGrenade):
        case `LW_ITEM_ID(APGrenade):
            if (m_kSoldier.HasPerk(24)) // Grenadier
            {
                NumCharges++;
            }

            if (m_kSoldier.HasPerk(53)) // Packmaster
            {
                NumCharges++;
            }

            break;
        case `LW_ITEM_ID(SmokeGrenade):
        case `LW_ITEM_ID(FlashbangGrenade):
        case `LW_ITEM_ID(ChemGrenade):
        case `LW_ITEM_ID(PsiGrenade):
        case `LW_ITEM_ID(BattleScanner):
        case `LW_ITEM_ID(MimicBeacon):
            if (m_kSoldier.HasPerk(91)) // Smoke and Mirrors
            {
                NumCharges++;
            }

            if (m_kSoldier.HasPerk(53)) // Packmaster
            {
                NumCharges++;
            }

            break;
        case `LW_ITEM_ID(Medikit):
            if (m_kSoldier.HasPerk(48)) // Field Medic
            {
                NumCharges++;
            }

            if (m_kSoldier.HasPerk(53)) // Packmaster
            {
                NumCharges++;
            }

            break;
        case `LW_ITEM_ID(RestorativeMist):
            if (m_kSoldier.HasPerk(48)) // Field Medic
            {
                NumCharges += 2;
            }

            if (m_kSoldier.HasPerk(53)) // Packmaster
            {
                NumCharges++;
            }

            break;
        case `LW_ITEM_ID(ArcThrower):
            if (!bForce1_for_NonGrenades)
            {
                if (m_kSoldier.HasPerk(102)) // Repair
                {
                    NumCharges += 2;
                }

                if (m_kSoldier.HasPerk(53)) // Packmaster
                {
                    NumCharges++;
                }
            }

            break;
        case `LW_ITEM_ID(Rocket):
        case `LW_ITEM_ID(ShredderRocket):
            NumCharges = 1;
            break;
        default:
            NumCharges = bForItemCardDisplay ? 0 : 1;
    }

    // TODO add mod hook

    return NumCharges;
}

function string GetItemTypeName(EItemType iItem)
{
    `HL_LOG_CLS("GetItemTypeName is deprecated in the Highlander. Use HL_TItem.strName instead.");
    ScriptTrace();
    return "";
}

function bool HasAnyOfItemsEquipped(out array<int> arrItems, bool bDefaultIfEmpty)
{
    local int iItemId;

    if (arrItems.Length == 0)
    {
        return bDefaultIfEmpty;
    }

    foreach arrItems(iItemId)
    {
        if (HasItemEquipped(iItemId))
        {
            return true;
        }
    }

    return false;
}

function bool HasItemEquipped(int iItemId)
{
    return `GAMECORE.TInventoryHasItemType(m_kSoldier.m_kChar.kInventory, iItemId);
}

/**
 * Callback for when gear is clicked in the loadout screen, either currently-equipped gear or gear in the locker.
 */
function OnGearAccept()
{
    local int I;
    local HL_TItem kItem;

    if (!m_kLocker.bIsSelected && m_kLocker.arrOptions.Length >= 0)
    {
        m_kLocker.bIsSelected = true;
        PlayGoodSound();
    }
    else if (OnEquip(m_kGear.iHighlight, m_kLocker.iHighlight))
    {
        m_kLocker.bIsSelected = false;
        m_kGear.bDataDirty = true;

        // Check if the most recent equipment change has invalidated any other equipment,
        // and if so, remove it
        for (I = 0; I < m_kGear.arrOptions.Length; I++)
        {
            kItem = `HL_ITEM(m_kGear.arrOptions[I].iItem);

            if (!HasAnyOfItemsEquipped(kItem.arrCompatibleLargeEquipment, true)
              || HasAnyOfItemsEquipped(kItem.arrIncompatibleLargeEquipment, false)
              || HasAnyOfItemsEquipped(kItem.arrMutuallyExclusiveEquipment, false))
            {
                OnUnequipGear(I);
            }
        }

        UpdateView();
        PRES().m_kSoldierSummary.UpdatePanels();

        if (PRES().m_kSoldierLoadout != none)
        {
            PRES().m_kSoldierLoadout.UpdatePanels();
        }
    }
}

function TItemCard SOLDIERUIGetItemCard()
{
    local TItemCard kItemCard;

    `HL_LOG_DEPRECATED_CLS(SOLDIERUIGetItemCard);

    return kItemCard;
}

function HL_TItemCard HL_SOLDIERUIGetItemCard()
{
    local HL_TItemCard kItemCard;

    if (m_kLocker.bIsSelected)
    {
        kItemCard = HL_GetItemCardFromOption(m_kLocker.arrOptions[m_kLocker.iHighlight]);
    }
    else
    {
        kItemCard = HL_GetItemCardFromOption(m_kGear.arrOptions[m_kGear.iHighlight]);
    }

    return kItemCard;
}