class Highlander_XGStorage extends XGStorage;

struct CheckpointRecord_Highlander_XGStorage extends CheckpointRecord
{
    var array<HL_TItemQuantity> m_arrHLItems;
    var array<HL_TItemQuantity> m_arrHLDamagedItems;
    var array<HL_TItemQuantity> m_arrHLItemArchives;
    var array<HL_TItemQuantity> m_arrHLClaims;
};

var array<HL_TItemQuantity> m_arrHLItems;
var array<HL_TItemQuantity> m_arrHLDamagedItems;
var array<HL_TItemQuantity> m_arrHLItemArchives;
var array<HL_TItemQuantity> m_arrHLClaims;

var array<HL_TItemQuantity> m_arrHLItemsDamagedLastMission;
var array<HL_TItemQuantity> m_arrHLItemsLostLastMission;

function Init()
{
    local Highlander_XGItemTree kItemTree;
    local HL_TItem kItem;
    local HL_TItemQuantity kItemQuantity;

    kItemTree = `HL_ITEMTREE;

    foreach kItemTree.m_arrHLItems(kItem)
    {
        kItemQuantity.iItemId = kItem.iItemId;
        kItemQuantity.iQuantity = 0;

        if (kItem.bIsInfinite)
        {
            kItemQuantity.iQuantity = 1000;
        }
        else if (kItem.iStartingQuantity > 0)
        {
            kItemQuantity.iQuantity = kItem.iStartingQuantity;
        }

        if (kItemQuantity.iQuantity > 0)
        {
            AddItem(kItemQuantity.iItemId, kItemQuantity.iQuantity);
        }
    }
}

function AddInfiniteItem(EItemType eItem)
{
    `HL_LOG_DEPRECATED_NOREPLACE_CLS(AddInfiniteItem);
}

function AddItem(int iItemId, optional int iQuantity = -1, optional int iContinent = -1)
{
    local Highlander_XGFacility_Barracks kBarracks;
    local int I;

    kBarracks = `HL_BARRACKS;

    if (iItemId == eItem_None)
    {
        return;
    }

    `HL_LOG_CLS("AddItem: iItemId = " $ iItemId $ ", iQuantity = " $ iQuantity);

    // 206, 207, 208 are SHIV rebuild projects
    if (iItemId != 206 && iItemId != 207 && iItemId != 208)
    {
        `HL_UTILS.AdjustItemQuantity(m_arrHLItems, iItemId, iQuantity);

        if (iQuantity > 0)
        {
            `HL_UTILS.AdjustItemQuantity(m_arrHLItemArchives, iItemId, iQuantity);
        }
    }

    // Handle a few special items
    for (I = 0; I < iQuantity; I++)
    {
        switch (iItemId)
        {
            case eItem_SHIV:
                AddItem(eItem_SHIVDeck_I);
                kBarracks.HL_AddTank(eItem_SHIVDeck_I, eItem_ShivAutocannon);
                STAT_AddStat(eRecap_SHIVsBuilt, 1);
                break;
            case 206: // Rebuild SHIV
                AddItem(eItem_SHIV);
                break;
            case eItem_SHIV_Alloy:
                AddItem(eItem_SHIVDeck_II);
                kBarracks.HL_AddTank(eItem_SHIVDeck_II, eItem_ShivAutocannon);
                STAT_AddStat(eRecap_SHIVsBuilt, 1);
                break;
            case 207: // Rebuild Alloy SHIV
                AddItem(eItem_SHIV_Alloy);
                break;
            case eItem_SHIV_Hover:
                AddItem(eItem_SHIVDeck_III);
                kBarracks.HL_AddTank(eItem_SHIVDeck_III, eItem_ShivAutocannon);
                STAT_AddStat(eRecap_SHIVsBuilt, 1);
                break;
            case 208: // Rebuild Hover SHIV
                AddItem(eItem_SHIV_Hover);
                break;
            case eItem_Interceptor:
                HANGAR().AddInterceptor(iContinent);
                break;
            case eItem_Firestorm:
                HANGAR().AddFirestorm(iContinent);
                STAT_AddStat(eRecap_FirestormsBuilt, 1);
                break;
            case eItem_Skyranger:
                HANGAR().AddDropship();
                break;
            default:
                break;
        }
    }

    if (iItemId == eItem_Medikit)
    {
        STAT_AddStat(eRecap_MedikitsBuilt, iQuantity);
    }

    if (iItemId == eItem_ArcThrower)
    {
        STAT_AddStat(eRecap_ArcThrowersBuilt, iQuantity);
    }
}

function bool AreReaperRoundsValid(XGStrategySoldier kSoldier)
{
    `HL_LOG_DEPRECATED_NOREPLACE_CLS(AreReaperRoundsValid);

    return false;
}

function BackupAndReleaseInventory(XGStrategySoldier kSoldier)
{
    local int iItemId, I;
    local TInventory kNewInventory;

    kSoldier.m_kBackedUpLoadout = kSoldier.m_kChar.kInventory;
    iItemId = kSoldier.m_kChar.kInventory.iArmor;

    if (iItemId != 0 && kSoldier.GetPsiRank() != 7 && !HL_IsInfinite(iItemId) && !kSoldier.IsATank())
    {
        kNewInventory.iArmor = kSoldier.IsAugmented() ? eItem_MecCivvies : eItem_TacArmor;
    }
    else
    {
        kNewInventory.iArmor = iItemId;
    }

    iItemId = kSoldier.m_kChar.kInventory.arrLargeItems[0];

    if (iItemId != 0 && !HL_IsInfinite(iItemId))
    {
        TACTICAL().TInventoryLargeItemsSetItem(kNewInventory, 0, HL_GetInfinitePrimary(kSoldier));
    }
    else
    {
        TACTICAL().TInventoryLargeItemsSetItem(kNewInventory, 0, iItemId);
    }

    TACTICAL().TInventoryLargeItemsSetItem(kNewInventory, 1, HL_GetInfiniteSecondary(kSoldier));
    TACTICAL().TInventoryLargeItemsSetItem(kNewInventory, 2, 0);
    TACTICAL().TInventoryLargeItemsSetItem(kNewInventory, 3, 0);

    for (I = 0; I < kSoldier.m_kChar.kInventory.iNumSmallItems; I++)
    {
        iItemId = kSoldier.m_kChar.kInventory.arrSmallItems[I];

        if (iItemId != 0 && !HL_IsInfinite(iItemId))
        {
            TACTICAL().TInventorySmallItemsSetItem(kNewInventory, I, 0);
        }
        else
        {
            TACTICAL().TInventorySmallItemsSetItem(kNewInventory, I, iItemId);
        }
    }

    iItemId = kSoldier.m_kChar.kInventory.iPistol;

    if (iItemId != 0 && !HL_IsInfinite(iItemId))
    {
        kNewInventory.iPistol = `LW_ITEM_ID(Pistol);
    }
    else
    {
        kNewInventory.iPistol = iItemId;
    }

    ReleaseLoadout(kSoldier);
    LOCKERS().ApplySoldierLoadout(kSoldier, kNewInventory);
}

function bool ClaimItem(int iItemId, XGStrategySoldier kSoldier)
{
    local int Index, iPerkId;
    local HL_TItem kItem;

    if (iItemId == eItem_None)
    {
        return true;
    }

    Index = m_arrHLItems.Find('iItemId', iItemId);

    if ( !HL_IsInfinite(iItemId) && (Index == INDEX_NONE || m_arrHLItems[Index].iQuantity <= 0) )
    {
        return false;
    }

    kItem = `HL_ITEM(iItemId);

    // Perks granted by item; adding 2 indicates it's from an item and not from the class perks
    foreach kItem.arrPerksGranted(iPerkId)
    {
        kSoldier.m_kChar.aUpgrades[iPerkId] += 2;
    }

    m_arrHLItems[Index].iQuantity -= 1;

    return true;
}

function DamageItem(EItemType eItem, optional int iQuantity = 1)
{
    `HL_LOG_DEPRECATED_CLS(DamageItem);
}

function HL_DamageItem(int iItemId, optional int iQuantity = 1)
{
    local int iCurrentQuantity;

    if (HL_IsInfinite(iItemId))
    {
        return;
    }

    iCurrentQuantity = `HL_UTILS.GetItemQuantity(m_arrHLItems, iItemId).iQuantity;

    if (iCurrentQuantity <= 0)
    {
        return;
    }

    if (iQuantity > iCurrentQuantity)
    {
        iQuantity = iCurrentQuantity;
    }

    `HL_UTILS.AdjustItemQuantity(m_arrHLDamagedItems, iItemId, iQuantity);
    `HL_UTILS.AdjustItemQuantity(m_arrHLItems, iItemId, -1 * iQuantity);
}

function bool EverHadItem(int iItemId)
{
    if (iItemId == 0)
    {
        return true;
    }

    return m_arrHLItemArchives.Find('iItemId', iItemId) != INDEX_NONE;
}

function array<EItemType> GetCaptives()
{
    local array<EItemType> arrCaptives;
    arrCaptives.Add(0);

    `HL_LOG_DEPRECATED_CLS(GetCaptives);

    return arrCaptives;
}

function array<HL_TItem> HL_GetCaptives()
{
    local Highlander_XGItemTree kItemTree;
    local HL_TItem kItem;
    local HL_TItemQuantity kItemQuantity;
    local array<HL_TItem> arrItems;

    kItemTree = `HL_ITEMTREE;

    foreach m_arrHLItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        if (kItemTree.HL_IsCaptive(kItemQuantity.iItemId))
        {
            kItem = kItemTree.HL_GetItem(kItemQuantity.iItemId);
            arrItems.AddItem(kItem);
        }
    }

    return arrItems;
}

function array<TItem> GetCorpses()
{
    local array<TItem> arrCorpses;
    arrCorpses.Add(0);

    `HL_LOG_DEPRECATED_CLS(GetCorpses);

    return arrCorpses;
}

function array<HL_TItem> HL_GetCorpses()
{
    local Highlander_XGItemTree kItemTree;
    local HL_TItem kItem;
    local HL_TItemQuantity kItemQuantity;
    local array<HL_TItem> arrItems;

    kItemTree = `HL_ITEMTREE;

    foreach m_arrHLItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        if (kItemTree.HL_IsCorpse(kItemQuantity.iItemId))
        {
            kItem = kItemTree.HL_GetItem(kItemQuantity.iItemId);
            arrItems.AddItem(kItem);
        }
    }

    return arrItems;
}

function EItemType GetInfinitePrimary(XGStrategySoldier kSoldier)
{
    `HL_LOG_DEPRECATED_CLS(GetInfinitePrimary);
    return eItem_None;
}

function int HL_GetInfinitePrimary(XGStrategySoldier kSoldier)
{
    // TODO add mod hook
    switch (kSoldier.m_kSoldier.kClass.eWeaponType)
    {
        case eWP_Support:
            return `LW_ITEM_ID(SAW);
        case eWP_Assault:
            return `LW_ITEM_ID(Shotgun);
        case eWP_Sniper:
            return `LW_ITEM_ID(SniperRifle);
        case eWP_Integrated:
            return `LW_ITEM_ID(Autocannon);
        case eWP_Mec:
            return `LW_ITEM_ID(Minigun);
        default:
            return `LW_ITEM_ID(AssaultRifle);
    }
}

function EItemType GetInfiniteSecondary(XGStrategySoldier kSoldier)
{
    `HL_LOG_DEPRECATED_CLS(GetInfiniteSecondary);
    return eItem_None;
}

function int HL_GetInfiniteSecondary(XGStrategySoldier kSoldier)
{
    // TODO add mod hook
    if (kSoldier.HasPerk(18)) // Fire Rocket
    {
        return eItem_RocketLauncher;
    }

    return 0;
}

function array<TItem> GetItemsInCategory(int iCategory, optional int iTransaction = 1, optional ESoldierClass eClassLock = 0)
{
    local array<TItem> arrItems;
    arrItems.Add(0);

    `HL_LOG_DEPRECATED_CLS(GetItemsInCategory);

    return arrItems;
}

function array<HL_TItem> HL_GetItemsInCategory(int iCategory, optional int iTransaction = eTransaction_Build, optional int iClassLock = 0)
{
    local HL_TItem kItem;
    local HL_TItemQuantity kItemQuantity;
    local array<HL_TItem> arrItems;

    foreach m_arrHLItems(kItemQuantity)
    {

        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `HL_ITEM(kItemQuantity.iItemId, iTransaction);

        if (iTransaction == eTransaction_Sell && !ITEMTREE().CanBeSold(kItem.iItemId))
        {
            continue;
        }

        if (iTransaction == eTransaction_Build && !ENGINEERING().HavePreReqs(kItem.iItemId))
        {
            continue;
        }

        if (iCategory != eItemCat_All && kItem.iCategory != iCategory)
        {
            continue;
        }

        if (iClassLock != 0 && !HL_IsClassEquippable(iClassLock, kItem.iItemId))
        {
            continue;
        }

        arrItems.AddItem(kItem);
    }

    return arrItems;
}

function array<TItem> GetDamagedItemsInCategory(int iCategory, optional ESoldierClass eClassLock = 0)
{
    local array<TItem> arrItems;
    arrItems.Add(0);

    `HL_LOG_DEPRECATED_CLS(GetDamagedItemsInCategory);

    return arrItems;
}

function array<HL_TItem> HL_GetDamagedItemsInCategory(int iCategory, optional int iClassLock = 0)
{
    local HL_TItem kItem;
    local HL_TItemQuantity kItemQuantity;
    local array<HL_TItem> arrItems;

    foreach m_arrHLDamagedItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `HL_ITEM(kItemQuantity.iItemId);

        if (iCategory != 0 && kItem.iCategory != iCategory)
        {
            continue;
        }

        if (iClassLock != 0 && !HL_IsClassEquippable(iClassLock, kItem.iItemId))
        {
            continue;
        }

        arrItems.AddItem(kItem);
    }

    return arrItems;
}

function int GetNumCaptives()
{
    local int iNumCaptives;
    local Highlander_XGItemTree kItemTree;
    local HL_TItem kItem;
    local HL_TItemQuantity kItemQuantity;

    kItemTree = `HL_ITEMTREE;

    foreach m_arrHLItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = kItemTree.HL_GetItem(kItemQuantity.iItemId);

        if (kItem.bIsCaptive)
        {
            iNumCaptives += kItemQuantity.iQuantity;
        }
    }

    return iNumCaptives;
}

function int GetNumDamagedItems(EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(GetNumDamagedItems);
    return 0;
}

function int HL_GetNumDamagedItems(int iItemId)
{
    local int Index;

    Index = m_arrHLDamagedItems.Find('iItemId', iItemId);

    if (Index == INDEX_NONE)
    {
        return 0;
    }

    return m_arrHLDamagedItems[Index].iQuantity;
}

function int GetNumItemsAvailable(int iItemId)
{
    local int Index;

    if (HL_IsInfinite(iItemId))
    {
        return 1000;
    }

    Index = m_arrHLItems.Find('iItemId', iItemId);

    if (Index == INDEX_NONE)
    {
        return 0;
    }

    return m_arrHLItems[Index].iQuantity;
}

function EItemType GetShivWeapon()
{
    return EItemType(`LW_ITEM_ID(Autocannon));
}

function ESoldierClass GetWeaponClassLimit(EItemType eItem)
{
    `HL_LOG_DEPRECATED_NOREPLACE_CLS(GetWeaponClassLimit);
    return 0;
}

function bool HasAlienWeapon()
{
    `HL_LOG_DEPRECATED_NOREPLACE_CLS(HasAlienWeapon);
    return false;
}

function bool HasXenobiologyCorpse()
{
    `HL_LOG_DEPRECATED_NOREPLACE_CLS(HasXenobiologyCorpse);
    return false;
}

function bool HasSatellites()
{
    `HL_LOG_DEPRECATED_NOREPLACE_CLS(HasSatellites);
    return false;
}

function bool IsInfinite(EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(IsInfinite);
    return false;
}

function bool HL_IsInfinite(int iItemId)
{
    return `HL_ITEM(iItemId).bIsInfinite;
}

function bool IsClassEquippable(ESoldierClass eClass, EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(IsClassEquippable);
    return super.IsClassEquippable(eClass, eItem);
}

function bool HL_IsClassEquippable(int iEquipmentGroup, int iItemId)
{
    if (`HL_ITEM(iItemId).iCategory == eItemCat_Armor)
    {
        if (iEquipmentGroup == /* All MEC classes */ 20)
        {
            return TACTICAL().ArmorHasProperty(iItemId, eAP_MEC);
        }

        if (iEquipmentGroup == /* All SHIVs */ 14)
        {
            return TACTICAL().ArmorHasProperty(iItemId, eAP_Tank);
        }

        return !TACTICAL().ArmorHasProperty(iItemId, eAP_MEC) && !TACTICAL().ArmorHasProperty(iItemId, eAP_Tank);
    }

    if (TACTICAL().WeaponHasProperty(iItemId, eWP_AnyClass))
    {
        return true;
    }

    if (iEquipmentGroup == /* Assault */ 6 || iEquipmentGroup == /* Engineer */ 10 || iEquipmentGroup == /* Scout */ 11)
    {
        if (TACTICAL().WeaponHasProperty(iItemId, eWP_Rifle))
        {
            return true;
        }
    }

    if (TACTICAL().WeaponHasProperty(iItemId, eWP_Pistol))
    {
        if (iItemId == 254) // Sawed-off shotgun
        {
            return iEquipmentGroup == /* Medic, Infantry */ 5 || iEquipmentGroup == /* Assault */ 6 || iEquipmentGroup == /* Engineer */ 10 || iEquipmentGroup == /* Scout */ 11;
        }

        return iEquipmentGroup != /* Rocketeer */ 8 && iEquipmentGroup != /* Gunner */ 4;
    }

    if (iEquipmentGroup == 0)
    {
        return false;
    }

    return TACTICAL().WeaponHasProperty(iItemId, iEquipmentGroup);
}

/// <summary>Turns all captives in storage into corpses.</summary>
function KillTheCaptives()
{
    local Highlander_XGItemTree kItemTree;
    local HL_TItem kItem;
    local HL_TItemQuantity kItemQuantity;

    kItemTree = `HL_ITEMTREE;

    foreach m_arrHLItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = kItemTree.HL_GetItem(kItemQuantity.iItemId);

        if (kItem.bIsCaptive)
        {
            RemoveAllItem(kItem.iItemId);

            if (kItem.iCaptiveToCorpseId != 0)
            {
                AddItem(kItem.iCaptiveToCorpseId, kItemQuantity.iQuantity);
            }
            else
            {
                `HL_LOG_CLS("WARNING: Captive item ID " $ kItem.iItemId $ " doesn't have a corresponding corpse set. Captives of this type will be killed without compensation.");
            }
        }
    }
}

function bool ReleaseItem(int iItemId, XGStrategySoldier kSoldier)
{
    local int Index;
    local HL_TItemQuantity kItemQuantity;
    local HL_TItem kItem;

    // Sometimes we get called to release an empty item slot, so just no-op
    if (iItemId == 0)
    {
        return true;
    }

    kItem = `HL_ITEM(iItemId);

    // Remove any perks granted by this item
    for (Index = 0; Index < kItem.arrPerksGranted.Length; Index++)
    {
        if (kSoldier.m_kChar.aUpgrades[kItem.arrPerksGranted[Index]] > 1)
        {
            kSoldier.m_kChar.aUpgrades[kItem.arrPerksGranted[Index]] -= 2;
        }
    }

    if (HL_IsInfinite(iItemId))
    {
        return true;
    }

    Index = m_arrHLItems.Find('iItemId', iItemId);

    if (Index != INDEX_NONE)
    {
        m_arrHLItems[Index].iQuantity += 1;
    }
    else
    {
        // This shouldn't really come up, but just in case it does through some weird mod interactions or something
        kItemQuantity.iItemId = iItemId;
        kItemQuantity.iQuantity = 1;

        m_arrHLItems.AddItem(kItemQuantity);
    }

    return true;
}

function ReleaseSmallItems(XGStrategySoldier kSoldier)
{
    local int I;
    local int iItemId;

    for (I = 0; I < kSoldier.m_kChar.kInventory.iNumSmallItems; I++)
    {
        iItemId = kSoldier.m_kChar.kInventory.arrSmallItems[I];

        if (!HL_IsInfinite(iItemId))
        {
            ReleaseItem(iItemId, kSoldier);
            TACTICAL().TInventorySmallItemsSetItem(kSoldier.m_kChar.kInventory, I, 0);
        }
    }
}

function RemoveItem(int iItemType, optional int iQuantity = 1)
{
    local int Index;

    if (HL_IsInfinite(iItemType))
    {
        return;
    }

    Index = m_arrHLItems.Find('iItemId', iItemType);

    if (Index != INDEX_NONE && m_arrHLItems[Index].iQuantity >= iQuantity)
    {
        m_arrHLItems[Index].iQuantity -= iQuantity;
    }
}

function RemoveAllItem(int iItemType)
{
    local int Index;

    if (HL_IsInfinite(iItemType))
    {
        return;
    }

    Index = m_arrHLItems.Find('iItemId', iItemType);

    if (Index != INDEX_NONE)
    {
        m_arrHLItems[Index].iQuantity = 0;
    }
}

function RepairItem(EItemType eItem, optional int iQuantity = 1)
{
    `HL_LOG_DEPRECATED_CLS(RepairItem);
}

function HL_RepairItem(int iItemId, optional int iQuantity = 1)
{
    local int iDamagedIndex, iItemIndex;

    if (HL_IsInfinite(iItemId))
    {
        return;
    }

    iDamagedIndex = m_arrHLDamagedItems.Find('iItemId', iItemId);
    iItemIndex = m_arrHLItems.Find('iItemId', iItemId);

    if (iQuantity > m_arrHLDamagedItems[iDamagedIndex].iQuantity)
    {
        iQuantity = m_arrHLDamagedItems[iDamagedIndex].iQuantity;
    }

    m_arrHLDamagedItems[iDamagedIndex].iQuantity -= iQuantity;
    m_arrHLDamagedItems[iItemIndex].iQuantity += iQuantity;
}