class LWCE_XGStorage extends XGStorage;

struct CheckpointRecord_LWCE_XGStorage extends CheckpointRecord
{
    var array<LWCE_TItemQuantity> m_arrCEItems;
    var array<LWCE_TItemQuantity> m_arrCEDamagedItems;
    var array<LWCE_TItemQuantity> m_arrCEItemArchives;
    var array<LWCE_TItemQuantity> m_arrCEClaims;
};

var array<LWCE_TItemQuantity> m_arrCEItems;
var array<LWCE_TItemQuantity> m_arrCEDamagedItems;
var array<LWCE_TItemQuantity> m_arrCEItemArchives;
var array<LWCE_TItemQuantity> m_arrCEClaims;

var array<LWCE_TItemQuantity> m_arrCEItemsDamagedLastMission;
var array<LWCE_TItemQuantity> m_arrCEItemsLostLastMission;

function Init()
{
    local LWCE_XGItemTree kItemTree;
    local LWCE_TItem kItem;
    local LWCE_TItemQuantity kItemQuantity;

    kItemTree = `LWCE_ITEMTREE;

    foreach kItemTree.m_arrCEItems(kItem)
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
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(AddInfiniteItem);
}

function AddItem(int iItemId, optional int iQuantity = -1, optional int iContinent = -1)
{
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_TItem kItem;
    local int I;

    kBarracks = `LWCE_BARRACKS;

    if (iItemId == 0)
    {
        return;
    }

    kItem = `LWCE_ITEM(iItemId);

    if (kItem.iReplacementItemId > 0)
    {
        AddItem(kItem.iReplacementItemId, iQuantity, iContinent);
        return;
    }

    `LWCE_UTILS.AdjustItemQuantity(m_arrCEItems, iItemId, iQuantity);

    if (iQuantity > 0)
    {
        `LWCE_UTILS.AdjustItemQuantity(m_arrCEItemArchives, iItemId, iQuantity);
    }

    // Handle a few special items
    for (I = 0; I < iQuantity; I++)
    {
        switch (iItemId)
        {
            case `LW_ITEM_ID(SHIV):
                AddItem(`LW_ITEM_ID(SHIVChassis));
                kBarracks.LWCE_AddTank(`LW_ITEM_ID(SHIVChassis), `LW_ITEM_ID(Autocannon));
                STAT_AddStat(eRecap_SHIVsBuilt, 1);
                break;
            case `LW_ITEM_ID(AlloySHIV):
                AddItem(`LW_ITEM_ID(AlloySHIVChassis));
                kBarracks.LWCE_AddTank(`LW_ITEM_ID(AlloySHIVChassis), `LW_ITEM_ID(Autocannon));
                STAT_AddStat(eRecap_SHIVsBuilt, 1);
                break;
            case `LW_ITEM_ID(HoverSHIV):
                AddItem(`LW_ITEM_ID(HoverSHIVChassis));
                kBarracks.LWCE_AddTank(`LW_ITEM_ID(HoverSHIVChassis), `LW_ITEM_ID(Autocannon));
                STAT_AddStat(eRecap_SHIVsBuilt, 1);
                break;
            case `LW_ITEM_ID(Interceptor):
                HANGAR().AddInterceptor(iContinent);
                break;
            case `LW_ITEM_ID(Firestorm):
                HANGAR().AddFirestorm(iContinent);
                STAT_AddStat(eRecap_FirestormsBuilt, 1);
                break;
            case `LW_ITEM_ID(Skyranger):
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
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(AreReaperRoundsValid);

    return false;
}

function AutoEquip(XGStrategySoldier kSoldier)
{
    local int iItemId;
    local TInventory kRookieLoadout;

    ReleaseLoadout(kSoldier);

    if (kSoldier.GetCurrentStat(eStat_Mobility) >= class'XGTacticalGameCore'.default.SOLDIER_COST_HARD)
    {
        kRookieLoadout.iArmor = `LW_ITEM_ID(TacArmor);
    }
    else
    {
        kRookieLoadout.iArmor = `LW_ITEM_ID(TacVest);
    }

    if (`LWCE_MOD_LOADER.Override_GetInfiniteSecondary(kSoldier, iItemId))
    {
        kRookieLoadout.iPistol = iItemId;
    }
    else
    {
        kRookieLoadout.iPistol = `LW_ITEM_ID(Pistol);
    }

    if (kSoldier.GetCurrentStat(eStat_Offense) >= class'XGTacticalGameCore'.default.SOLDIER_COST_CLASSIC)
    {
        TACTICAL().TInventoryLargeItemsSetItem(kRookieLoadout, 0, `LW_ITEM_ID(AssaultRifle));
    }
    else
    {
        TACTICAL().TInventoryLargeItemsSetItem(kRookieLoadout, 0, `LW_ITEM_ID(AssaultCarbine));
    }

    TACTICAL().TInventorySmallItemsSetItem(kRookieLoadout, 0, `LW_ITEM_ID(APGrenade));

    switch (Rand(6))
    {
        case 0:
            TACTICAL().TInventorySmallItemsSetItem(kRookieLoadout, 1, `LW_ITEM_ID(LaserSight));
            break;
        case 1:
            if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienGrenades)))
            {
                TACTICAL().TInventorySmallItemsSetItem(kRookieLoadout, 1, `LW_ITEM_ID(AlienGrenade));
            }
            else
            {
                TACTICAL().TInventorySmallItemsSetItem(kRookieLoadout, 1, `LW_ITEM_ID(HEGrenade));
            }

            break;
        case 2:
            TACTICAL().TInventorySmallItemsSetItem(kRookieLoadout, 1, `LW_ITEM_ID(CeramicPlating));
            break;
        case 3:
            TACTICAL().TInventorySmallItemsSetItem(kRookieLoadout, 1, `LW_ITEM_ID(APGrenade));
            break;
        case 4:
            TACTICAL().TInventorySmallItemsSetItem(kRookieLoadout, 1, `LW_ITEM_ID(FlashbangGrenade));
            break;
        case 5:
            TACTICAL().TInventorySmallItemsSetItem(kRookieLoadout, 1, `LW_ITEM_ID(Medikit));
            break;
    }

    if (`LWCE_MOD_LOADER.Override_GetInfinitePrimary(kSoldier, iItemId))
    {
        TACTICAL().TInventoryLargeItemsSetItem(kRookieLoadout, 0, iItemId);
    }

    LOCKERS().ApplySoldierLoadout(kSoldier, kRookieLoadout);
}

function BackupAndReleaseInventory(XGStrategySoldier kSoldier)
{
    local int iItemId, I;
    local TInventory kNewInventory;

    kSoldier.m_kBackedUpLoadout = kSoldier.m_kChar.kInventory;
    iItemId = kSoldier.m_kChar.kInventory.iArmor;

    if (iItemId != 0 && kSoldier.GetPsiRank() != 7 && !LWCE_IsInfinite(iItemId) && !kSoldier.IsATank())
    {
        kNewInventory.iArmor = kSoldier.IsAugmented() ? eItem_MecCivvies : eItem_TacArmor;
    }
    else
    {
        kNewInventory.iArmor = iItemId;
    }

    iItemId = kSoldier.m_kChar.kInventory.arrLargeItems[0];

    if (iItemId != 0 && !LWCE_IsInfinite(iItemId))
    {
        TACTICAL().TInventoryLargeItemsSetItem(kNewInventory, 0, LWCE_GetInfinitePrimary(kSoldier));
    }
    else
    {
        TACTICAL().TInventoryLargeItemsSetItem(kNewInventory, 0, iItemId);
    }

    TACTICAL().TInventoryLargeItemsSetItem(kNewInventory, 1, LWCE_GetInfiniteSecondary(kSoldier));
    TACTICAL().TInventoryLargeItemsSetItem(kNewInventory, 2, 0);
    TACTICAL().TInventoryLargeItemsSetItem(kNewInventory, 3, 0);

    for (I = 0; I < kSoldier.m_kChar.kInventory.iNumSmallItems; I++)
    {
        iItemId = kSoldier.m_kChar.kInventory.arrSmallItems[I];

        if (iItemId != 0 && !LWCE_IsInfinite(iItemId))
        {
            TACTICAL().TInventorySmallItemsSetItem(kNewInventory, I, 0);
        }
        else
        {
            TACTICAL().TInventorySmallItemsSetItem(kNewInventory, I, iItemId);
        }
    }

    iItemId = kSoldier.m_kChar.kInventory.iPistol;

    if (iItemId != 0 && !LWCE_IsInfinite(iItemId))
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
    local bool bIsInfinite;
    local int Index, iPerkId;
    local LWCE_TItem kItem;

    if (iItemId == eItem_None)
    {
        return true;
    }

    Index = m_arrCEItems.Find('iItemId', iItemId);
    bIsInfinite = LWCE_IsInfinite(iItemId);

    if ( !bIsInfinite && (Index == INDEX_NONE || m_arrCEItems[Index].iQuantity <= 0) )
    {
        return false;
    }

    kItem = `LWCE_ITEM(iItemId);

    // Perks granted by item; adding 2 indicates it's from an item and not from the class perks
    foreach kItem.arrPerksGranted(iPerkId)
    {
        kSoldier.m_kChar.aUpgrades[iPerkId] += 2;
    }

    if (!bIsInfinite)
    {
        m_arrCEItems[Index].iQuantity -= 1;
    }

    return true;
}

function DamageItem(EItemType eItem, optional int iQuantity = 1)
{
    `LWCE_LOG_DEPRECATED_CLS(DamageItem);
}

function LWCE_DamageItem(int iItemId, optional int iQuantity = 1)
{
    local int iCurrentQuantity;

    if (LWCE_IsInfinite(iItemId))
    {
        return;
    }

    iCurrentQuantity = `LWCE_UTILS.GetItemQuantity(m_arrCEItems, iItemId).iQuantity;

    if (iCurrentQuantity <= 0)
    {
        return;
    }

    if (iQuantity > iCurrentQuantity)
    {
        iQuantity = iCurrentQuantity;
    }

    `LWCE_UTILS.AdjustItemQuantity(m_arrCEDamagedItems, iItemId, iQuantity);
    `LWCE_UTILS.AdjustItemQuantity(m_arrCEItems, iItemId, -1 * iQuantity);
}

function bool EverHadItem(int iItemId)
{
    if (iItemId == 0)
    {
        return true;
    }

    return m_arrCEItemArchives.Find('iItemId', iItemId) != INDEX_NONE;
}

function array<EItemType> GetCaptives()
{
    local array<EItemType> arrCaptives;
    arrCaptives.Add(0);

    `LWCE_LOG_DEPRECATED_CLS(GetCaptives);

    return arrCaptives;
}

function array<LWCE_TItem> LWCE_GetCaptives()
{
    local LWCE_XGItemTree kItemTree;
    local LWCE_TItem kItem;
    local LWCE_TItemQuantity kItemQuantity;
    local array<LWCE_TItem> arrItems;

    kItemTree = `LWCE_ITEMTREE;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        if (kItemTree.LWCE_IsCaptive(kItemQuantity.iItemId))
        {
            kItem = kItemTree.LWCE_GetItem(kItemQuantity.iItemId);
            arrItems.AddItem(kItem);
        }
    }

    return arrItems;
}

function array<TItem> GetCorpses()
{
    local array<TItem> arrCorpses;
    arrCorpses.Add(0);

    `LWCE_LOG_DEPRECATED_CLS(GetCorpses);

    return arrCorpses;
}

function array<LWCE_TItem> LWCE_GetCorpses()
{
    local LWCE_XGItemTree kItemTree;
    local LWCE_TItem kItem;
    local LWCE_TItemQuantity kItemQuantity;
    local array<LWCE_TItem> arrItems;

    kItemTree = `LWCE_ITEMTREE;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        if (kItemTree.LWCE_IsCorpse(kItemQuantity.iItemId))
        {
            kItem = kItemTree.LWCE_GetItem(kItemQuantity.iItemId);
            arrItems.AddItem(kItem);
        }
    }

    return arrItems;
}

function EItemType GetInfinitePrimary(XGStrategySoldier kSoldier)
{
    `LWCE_LOG_DEPRECATED_CLS(GetInfinitePrimary);
    return eItem_None;
}

function int LWCE_GetInfinitePistol(XGStrategySoldier kSoldier)
{
    local int iItemId;

    if (`LWCE_MOD_LOADER.Override_GetInfinitePistol(kSoldier, iItemId))
    {
        return iItemId;
    }

    return `LW_ITEM_ID(Pistol);
}

function int LWCE_GetInfinitePrimary(XGStrategySoldier kSoldier)
{
    local int iItemId;

    if (`LWCE_MOD_LOADER.Override_GetInfinitePrimary(kSoldier, iItemId))
    {
        return iItemId;
    }

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
    `LWCE_LOG_DEPRECATED_CLS(GetInfiniteSecondary);
    return eItem_None;
}

function int LWCE_GetInfiniteSecondary(XGStrategySoldier kSoldier)
{
    local int iItemId;

    if (`LWCE_MOD_LOADER.Override_GetInfiniteSecondary(kSoldier, iItemId))
    {
        return iItemId;
    }

    if (kSoldier.HasPerk(`LW_PERK_ID(FireRocket)))
    {
        return `LW_ITEM_ID(RocketLauncher);
    }

    return 0;
}

function array<TItem> GetItemsInCategory(int iCategory, optional int iTransaction = 1, optional ESoldierClass eClassLock = 0)
{
    local array<TItem> arrItems;
    arrItems.Add(0);

    `LWCE_LOG_DEPRECATED_CLS(GetItemsInCategory);

    return arrItems;
}

function array<LWCE_TItem> LWCE_GetItemsInCategory(int iCategory, optional int iTransaction = eTransaction_Build, optional int iClassLock = 0)
{
    local LWCE_TItem kItem;
    local LWCE_TItemQuantity kItemQuantity;
    local array<LWCE_TItem> arrItems;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `LWCE_ITEM(kItemQuantity.iItemId, iTransaction);

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

        if (iClassLock != 0 && !LWCE_IsClassEquippable(iClassLock, kItem.iItemId))
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

    `LWCE_LOG_DEPRECATED_CLS(GetDamagedItemsInCategory);

    return arrItems;
}

function array<LWCE_TItem> LWCE_GetDamagedItemsInCategory(int iCategory, optional int iClassLock = 0)
{
    local LWCE_TItem kItem;
    local LWCE_TItemQuantity kItemQuantity;
    local array<LWCE_TItem> arrItems;

    foreach m_arrCEDamagedItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `LWCE_ITEM(kItemQuantity.iItemId);

        if (iCategory != 0 && kItem.iCategory != iCategory)
        {
            continue;
        }

        if (iClassLock != 0 && !LWCE_IsClassEquippable(iClassLock, kItem.iItemId))
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
    local LWCE_XGItemTree kItemTree;
    local LWCE_TItem kItem;
    local LWCE_TItemQuantity kItemQuantity;

    kItemTree = `LWCE_ITEMTREE;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = kItemTree.LWCE_GetItem(kItemQuantity.iItemId);

        if (kItem.bIsCaptive)
        {
            iNumCaptives += kItemQuantity.iQuantity;
        }
    }

    return iNumCaptives;
}

function int GetNumDamagedItems(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(GetNumDamagedItems);
    return 0;
}

function int LWCE_GetNumDamagedItems(int iItemId)
{
    local int Index;

    Index = m_arrCEDamagedItems.Find('iItemId', iItemId);

    if (Index == INDEX_NONE)
    {
        return 0;
    }

    return m_arrCEDamagedItems[Index].iQuantity;
}

function int GetNumItemsAvailable(int iItemId)
{
    local int Index;

    if (LWCE_IsInfinite(iItemId))
    {
        return 1000;
    }

    Index = m_arrCEItems.Find('iItemId', iItemId);

    if (Index == INDEX_NONE)
    {
        return 0;
    }

    return m_arrCEItems[Index].iQuantity;
}

function EItemType GetShivWeapon()
{
    return EItemType(`LW_ITEM_ID(Autocannon));
}

function ESoldierClass GetWeaponClassLimit(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetWeaponClassLimit);

    return 0;
}

function bool HasAlienCaptive()
{
    local LWCE_TItemQuantity kItemQuantity;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity > 0 && `LWCE_ITEM(kItemQuantity.iItemId).bIsCaptive)
        {
            return true;
        }
    }

    return false;
}

function bool HasAlienWeapon()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(HasAlienWeapon);
    return false;
}

function bool HasXenobiologyCorpse()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(HasXenobiologyCorpse);
    return false;
}

function bool HasSatellites()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(HasSatellites);
    return false;
}

function bool IsInfinite(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(IsInfinite);
    return false;
}

function bool LWCE_IsInfinite(int iItemId)
{
    return `LWCE_ITEM(iItemId).bIsInfinite;
}

function bool IsClassEquippable(ESoldierClass eClass, EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(IsClassEquippable);
    return super.IsClassEquippable(eClass, eItem);
}

function bool LWCE_IsClassEquippable(int iEquipmentGroup, int iItemId)
{
    if (`LWCE_ITEM(iItemId).iCategory == eItemCat_Armor)
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
    local LWCE_XGItemTree kItemTree;
    local LWCE_TItem kItem;
    local LWCE_TItemQuantity kItemQuantity;

    kItemTree = `LWCE_ITEMTREE;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = kItemTree.LWCE_GetItem(kItemQuantity.iItemId);

        if (kItem.bIsCaptive)
        {
            RemoveAllItem(kItem.iItemId);

            if (kItem.iCaptiveToCorpseId != 0)
            {
                AddItem(kItem.iCaptiveToCorpseId, kItemQuantity.iQuantity);
            }
            else
            {
                `LWCE_LOG_CLS("WARNING: Captive item ID " $ kItem.iItemId $ " doesn't have a corresponding corpse set. Captives of this type will be killed without compensation.");
            }
        }
    }
}

function bool ReleaseItem(int iItemId, XGStrategySoldier kSoldier)
{
    local int Index;
    local LWCE_TItemQuantity kItemQuantity;
    local LWCE_TItem kItem;

    // Sometimes we get called to release an empty item slot, so just no-op
    if (iItemId == 0)
    {
        return true;
    }

    kItem = `LWCE_ITEM(iItemId);

    // Remove any perks granted by this item
    for (Index = 0; Index < kItem.arrPerksGranted.Length; Index++)
    {
        if (kSoldier.m_kChar.aUpgrades[kItem.arrPerksGranted[Index]] > 1)
        {
            kSoldier.m_kChar.aUpgrades[kItem.arrPerksGranted[Index]] -= 2;
        }
    }

    if (LWCE_IsInfinite(iItemId))
    {
        return true;
    }

    Index = m_arrCEItems.Find('iItemId', iItemId);

    if (Index != INDEX_NONE)
    {
        m_arrCEItems[Index].iQuantity += 1;
    }
    else
    {
        // This shouldn't really come up, but just in case it does through some weird mod interactions or something
        kItemQuantity.iItemId = iItemId;
        kItemQuantity.iQuantity = 1;

        m_arrCEItems.AddItem(kItemQuantity);
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

        if (!LWCE_IsInfinite(iItemId))
        {
            ReleaseItem(iItemId, kSoldier);
            TACTICAL().TInventorySmallItemsSetItem(kSoldier.m_kChar.kInventory, I, 0);
        }
    }
}

function RemoveItem(int iItemType, optional int iQuantity = 1)
{
    local int Index;

    if (LWCE_IsInfinite(iItemType))
    {
        return;
    }

    Index = m_arrCEItems.Find('iItemId', iItemType);

    if (Index != INDEX_NONE && m_arrCEItems[Index].iQuantity >= iQuantity)
    {
        m_arrCEItems[Index].iQuantity -= iQuantity;
    }
}

function RemoveAllItem(int iItemType)
{
    local int Index;

    if (LWCE_IsInfinite(iItemType))
    {
        return;
    }

    Index = m_arrCEItems.Find('iItemId', iItemType);

    if (Index != INDEX_NONE)
    {
        m_arrCEItems[Index].iQuantity = 0;
    }
}

function RepairItem(EItemType eItem, optional int iQuantity = 1)
{
    `LWCE_LOG_DEPRECATED_CLS(RepairItem);
}

function LWCE_RepairItem(int iItemId, optional int iQuantity = 1)
{
    local int iDamagedIndex, iItemIndex;

    if (LWCE_IsInfinite(iItemId))
    {
        return;
    }

    iDamagedIndex = m_arrCEDamagedItems.Find('iItemId', iItemId);
    iItemIndex = m_arrCEItems.Find('iItemId', iItemId);

    if (iQuantity > m_arrCEDamagedItems[iDamagedIndex].iQuantity)
    {
        iQuantity = m_arrCEDamagedItems[iDamagedIndex].iQuantity;
    }

    m_arrCEDamagedItems[iDamagedIndex].iQuantity -= iQuantity;
    m_arrCEDamagedItems[iItemIndex].iQuantity += iQuantity;
}