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
    local array<LWCEItemTemplate> arrAllItems;
    local LWCEItemTemplateManager kItemMgr;
    local LWCEItemTemplate kItem;
    local int iQuantity;

    kItemMgr = `LWCE_ITEM_TEMPLATE_MGR;
    arrAllItems = kItemMgr.GetAllItemTemplates();

    foreach arrAllItems(kItem)
    {
        iQuantity = 0;

        if (kItem.IsInfinite())
        {
            iQuantity = 1000;
        }
        else if (kItem.iStartingQuantity > 0)
        {
            iQuantity = kItem.iStartingQuantity;
        }

        if (iQuantity > 0)
        {
            LWCE_AddItem(kItem.GetItemName(), iQuantity);
        }
    }
}

function AddInfiniteItem(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(AddInfiniteItem);
}

function AddItem(int iItemId, optional int iQuantity = -1, optional int iContinent = -1)
{
    // The XGStrategyActor.AddResource function uses AddItem for these 3 items, and it would be a great deal of
    // work for no benefit to change that to LWCE_AddItem, so we allow just these 3 to go through. All other items
    // must use LWCE_AddItem.
    if (iItemId == eItem_AlienAlloys)
    {
        LWCE_AddItem('Item_AlienAlloy', iQuantity, '');
        return;
    }

    if (iItemId == eItem_Elerium115)
    {
        LWCE_AddItem('Item_Elerium', iQuantity, '');
        return;
    }

    if (iItemId == eItem_Meld)
    {
        LWCE_AddItem('Item_Meld', iQuantity, '');
        return;
    }

    `LWCE_LOG_DEPRECATED_CLS(AddItem);
}

function LWCE_AddItem(name ItemName, optional int iQuantity = 1, optional name nmContinent = '')
{
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCEItemTemplate kItem;
    local int I;

    kBarracks = `LWCE_BARRACKS;

    if (ItemName == '')
    {
        return;
    }

    kItem = `LWCE_ITEM(ItemName);

    if (kItem == none)
    {
        `LWCE_LOG_CLS("ERROR: requested to add item " $ ItemName $ " but no such item could be found!");
        return;
    }

    if (kItem.nmReplacementItem != '')
    {
        LWCE_AddItem(kItem.nmReplacementItem, iQuantity, nmContinent);
        return;
    }

    if (kItem.IsInfinite())
    {
        return;
    }

    if (kItem.nmResultingShip != '')
    {
        if (iQuantity <= 0)
        {
            `LWCE_LOG_ERROR("Adding a non-positive number of ships is not supported; iQuantity was " $ iQuantity);
            return;
        }

        for (I = 0; I < iQuantity; I++)
        {
            LWCE_XGFacility_Hangar(HANGAR()).LWCE_AddShip(kItem.nmResultingShip, nmContinent);
        }

        if (kItem.nmResultingShip == 'Firestorm')
        {
            STAT_AddStat(eRecap_FirestormsBuilt, iQuantity);
        }

        return;
    }

    `LWCE_UTILS.AdjustItemQuantity(m_arrCEItems, ItemName, iQuantity);

    if (iQuantity > 0)
    {
        `LWCE_UTILS.AdjustItemQuantity(m_arrCEItemArchives, ItemName, iQuantity);
    }

    // Handle a few special items
    // TODO: move this logic to templates or event listeners
    for (I = 0; I < iQuantity; I++)
    {
        switch (ItemName)
        {
            case 'Item_SHIV':
                LWCE_AddItem('Item_SHIVChassis');
                kBarracks.LWCE_AddTank('Item_SHIVChassis', 'Item_Autocannon');
                STAT_AddStat(eRecap_SHIVsBuilt, 1);
                break;
            case 'Item_SHIVAlloy':
                LWCE_AddItem('Item_SHIVAlloyChassis');
                kBarracks.LWCE_AddTank('Item_SHIVAlloyChassis', 'Item_Autocannon');
                STAT_AddStat(eRecap_SHIVsBuilt, 1);
                break;
            case 'Item_SHIVHover':
                LWCE_AddItem('Item_SHIVHoverChassis');
                kBarracks.LWCE_AddTank('Item_SHIVHoverChassis', 'Item_Autocannon');
                STAT_AddStat(eRecap_SHIVsBuilt, 1);
                break;
            default:
                break;
        }
    }

    if (ItemName == 'Item_Medikit')
    {
        STAT_AddStat(eRecap_MedikitsBuilt, iQuantity);
    }

    if (ItemName == 'Item_ArcThrower')
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
    local name ItemName;
    local LWCE_TInventory kRookieLoadout;

    ReleaseLoadout(kSoldier);

    // TODO: expose all of the default equipment to configuration
    if (kSoldier.GetCurrentStat(eStat_Mobility) >= class'XGTacticalGameCore'.default.SOLDIER_COST_HARD)
    {
        kRookieLoadout.nmArmor = 'Item_TacArmor';
    }
    else
    {
        kRookieLoadout.nmArmor = 'Item_TacVest';
    }

    if (`LWCE_MOD_LOADER.Override_GetInfiniteSecondary(kSoldier, ItemName))
    {
        kRookieLoadout.nmPistol = ItemName;
    }
    else
    {
        kRookieLoadout.nmPistol = 'Item_Pistol';
    }

    class'LWCEInventoryUtils'.static.SetLargeItem(kRookieLoadout, 0, 'Item_AssaultCarbine');

    if (kSoldier.GetCurrentStat(eStat_Offense) >= class'XGTacticalGameCore'.default.SOLDIER_COST_CLASSIC)
    {
        class'LWCEInventoryUtils'.static.SetLargeItem(kRookieLoadout, 0, 'Item_AssaultRifle');
    }
    else
    {
        class'LWCEInventoryUtils'.static.SetLargeItem(kRookieLoadout, 0, 'Item_AssaultCarbine');
    }

    class'LWCEInventoryUtils'.static.SetSmallItem(kRookieLoadout, 0, 'Item_APGrenade');

    switch (Rand(6))
    {
        case 0:
            class'LWCEInventoryUtils'.static.SetSmallItem(kRookieLoadout, 1, 'Item_LaserSight');
            break;
        case 1:
            if (`LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_AlienGrenades'))
            {
                class'LWCEInventoryUtils'.static.SetSmallItem(kRookieLoadout, 1, 'Item_AlienGrenade');
            }
            else
            {
                class'LWCEInventoryUtils'.static.SetSmallItem(kRookieLoadout, 1, 'Item_HEGrenade');
            }

            break;
        case 2:
            class'LWCEInventoryUtils'.static.SetSmallItem(kRookieLoadout, 1, 'Item_CeramicPlating');
            break;
        case 3:
            class'LWCEInventoryUtils'.static.SetSmallItem(kRookieLoadout, 1, 'Item_APGrenade');
            break;
        case 4:
            class'LWCEInventoryUtils'.static.SetSmallItem(kRookieLoadout, 1, 'Item_FlashbangGrenade');
            break;
        case 5:
            class'LWCEInventoryUtils'.static.SetSmallItem(kRookieLoadout, 1, 'Item_Medikit');
            break;
    }

    if (`LWCE_MOD_LOADER.Override_GetInfinitePrimary(kSoldier, ItemName))
    {
        class'LWCEInventoryUtils'.static.SetLargeItem(kRookieLoadout, 0, ItemName);
    }

    LWCE_XGFacility_Lockers(LOCKERS()).LWCE_ApplySoldierLoadout(kSoldier, kRookieLoadout);
}

function BackupAndReleaseInventory(XGStrategySoldier kSoldier)
{
    local name ItemName;
    local int I;
    local LWCE_TInventory kNewInventory;
    local LWCEItemTemplate kItem;
    local LWCE_XGStrategySoldier kCESoldier;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    kCESoldier.m_kCEBackedUpLoadout = kCESoldier.m_kCEChar.kInventory;

    ItemName = kCESoldier.m_kCEChar.kInventory.nmArmor;
    kItem = `LWCE_ITEM(ItemName);

    if (ItemName != '' && kCESoldier.GetPsiRank() != 7 && !kItem.IsInfinite() && !kCESoldier.IsATank())
    {
        kNewInventory.nmArmor = kCESoldier.IsAugmented() ? 'Item_BaseAugments' : 'Item_TacArmor';
    }
    else
    {
        kNewInventory.nmArmor = ItemName;
    }

    if (kCESoldier.m_kCEChar.kInventory.arrLargeItems.Length >= 1)
    {
        ItemName = kCESoldier.m_kCEChar.kInventory.arrLargeItems[0];
        kItem = `LWCE_ITEM(ItemName);

        if (ItemName != '' && !kItem.IsInfinite())
        {
            class'LWCEInventoryUtils'.static.SetLargeItem(kNewInventory, 0, LWCE_GetInfinitePrimary(kCESoldier));
        }
        else
        {
            class'LWCEInventoryUtils'.static.SetLargeItem(kNewInventory, 0, ItemName);
        }
    }

    class'LWCEInventoryUtils'.static.SetLargeItem(kNewInventory, 1, LWCE_GetInfiniteSecondary(kCESoldier));
    class'LWCEInventoryUtils'.static.SetLargeItem(kNewInventory, 2, '');
    class'LWCEInventoryUtils'.static.SetLargeItem(kNewInventory, 3, '');

    for (I = 0; I < kCESoldier.m_kCEChar.kInventory.arrSmallItems.Length; I++)
    {
        ItemName = kCESoldier.m_kCEChar.kInventory.arrSmallItems[I];

        if (ItemName != '' && !`LWCE_ITEM(ItemName).IsInfinite())
        {
            class'LWCEInventoryUtils'.static.SetSmallItem(kNewInventory, I, '');
        }
        else
        {
            class'LWCEInventoryUtils'.static.SetSmallItem(kNewInventory, I, ItemName);
        }
    }

    ItemName = kCESoldier.m_kCEChar.kInventory.nmPistol;

    if (ItemName != '' && !`LWCE_ITEM(ItemName).IsInfinite())
    {
        kNewInventory.nmPistol = 'Item_Pistol';
    }
    else
    {
        kNewInventory.nmPistol = ItemName;
    }

    ReleaseLoadout(kCESoldier);
    LWCE_XGFacility_Lockers(LOCKERS()).LWCE_ApplySoldierLoadout(kCESoldier, kNewInventory);
}

function bool ClaimItem(int iItemId, XGStrategySoldier kSoldier)
{
    `LWCE_LOG_DEPRECATED_CLS(ClaimItem);

    return false;
}

function bool LWCE_ClaimItem(name ItemName, optional XGStrategySoldier kSoldier = none, optional int iQuantity = 1)
{
    local bool bIsInfinite;
    local int Index, iPerkId;
    local name PerkName;
    local LWCEEquipmentTemplate kEquipment;
    local LWCE_XGStrategySoldier kCESoldier;

    if (ItemName == '')
    {
        return true;
    }

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);
    kEquipment = LWCEEquipmentTemplate(`LWCE_ITEM(ItemName));
    Index = m_arrCEItems.Find('ItemName', ItemName);
    bIsInfinite = kEquipment.IsInfinite();

    if ( !bIsInfinite && (Index == INDEX_NONE || m_arrCEItems[Index].iQuantity < iQuantity) )
    {
        return false;
    }

    if (kCESoldier != none)
    {
        foreach kEquipment.arrPerks(PerkName)
        {
            iPerkId = class'LWCE_XComPerkManager'.static.BaseIDFromPerkName(PerkName);

            if (iPerkId > 0 && iPerkId < ePerk_MAX)
            {
                kCESoldier.LWCE_GivePerk(iPerkId, 'Item');
            }
        }
    }

    if (!bIsInfinite)
    {
        m_arrCEItems[Index].iQuantity -= iQuantity;
    }

    return true;
}

function DamageItem(EItemType eItem, optional int iQuantity = 1)
{
    `LWCE_LOG_DEPRECATED_CLS(DamageItem);
}

function LWCE_DamageItem(name ItemName, optional int iQuantity = 1)
{
    local int iCurrentQuantity;

    if (`LWCE_ITEM(ItemName).IsInfinite())
    {
        return;
    }

    iCurrentQuantity = `LWCE_UTILS.GetItemQuantity(m_arrCEItems, ItemName).iQuantity;

    if (iCurrentQuantity <= 0)
    {
        return;
    }

    if (iQuantity > iCurrentQuantity)
    {
        iQuantity = iCurrentQuantity;
    }

    `LWCE_UTILS.AdjustItemQuantity(m_arrCEDamagedItems, ItemName, iQuantity);
    `LWCE_UTILS.AdjustItemQuantity(m_arrCEItems, ItemName, -1 * iQuantity);
}

function bool EverHadItem(int ItemName)
{
    `LWCE_LOG_DEPRECATED_CLS(EverHadItem);

    return false;
}

function bool LWCE_EverHadItem(name ItemName)
{
    if (ItemName == '')
    {
        return true;
    }

    return m_arrCEItemArchives.Find('ItemName', ItemName) != INDEX_NONE;
}

function array<EItemType> GetCaptives()
{
    local array<EItemType> arrCaptives;
    arrCaptives.Add(0);

    `LWCE_LOG_DEPRECATED_CLS(GetCaptives);

    return arrCaptives;
}

function array<LWCEItemTemplate> LWCE_GetCaptives()
{
    local LWCEItemTemplate kItem;
    local LWCE_TItemQuantity kItemQuantity;
    local array<LWCEItemTemplate> arrItems;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `LWCE_ITEM(kItemQuantity.ItemName);

        if (kItem.IsCaptive())
        {
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

function array<LWCEItemTemplate> LWCE_GetCorpses()
{
    local LWCEItemTemplate kItem;
    local LWCE_TItemQuantity kItemQuantity;
    local array<LWCEItemTemplate> arrItems;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `LWCE_ITEM(kItemQuantity.ItemName);

        if (kItem.IsCorpse())
        {
            arrItems.AddItem(kItem);
        }
    }

    return arrItems;
}

function name LWCE_GetInfinitePistol(XGStrategySoldier kSoldier)
{
    local name ItemName;

    if (`LWCE_MOD_LOADER.Override_GetInfinitePistol(kSoldier, ItemName))
    {
        return ItemName;
    }

    return 'Item_Pistol';
}

function EItemType GetInfinitePrimary(XGStrategySoldier kSoldier)
{
    `LWCE_LOG_DEPRECATED_CLS(GetInfinitePrimary);
    return eItem_None;
}

function name LWCE_GetInfinitePrimary(LWCE_XGStrategySoldier kSoldier)
{
    local name ItemName;
    local LWCE_TClassDefinition kClassDef;

    if (`LWCE_MOD_LOADER.Override_GetInfinitePrimary(kSoldier, ItemName))
    {
        return ItemName;
    }

    kClassDef = LWCE_XGFacility_Barracks(BARRACKS()).GetClassDefinition(kSoldier.m_kCESoldier.iSoldierClassId);

    switch (kClassDef.iWeaponType)
    {
        case eWP_Support:
            return 'Item_SAW';
        case eWP_Assault:
            return 'Item_Shotgun';
        case eWP_Sniper:
            return 'Item_SniperRifle';
        case eWP_Integrated:
            return 'Item_Autocannon';
        case eWP_Mec:
            return 'Item_Minigun';
        default:
            return 'Item_AssaultRifle';
    }
}

function EItemType GetInfiniteSecondary(XGStrategySoldier kSoldier)
{
    `LWCE_LOG_DEPRECATED_CLS(GetInfiniteSecondary);
    return eItem_None;
}

function name LWCE_GetInfiniteSecondary(XGStrategySoldier kSoldier)
{
    local name ItemName;

    if (`LWCE_MOD_LOADER.Override_GetInfiniteSecondary(kSoldier, ItemName))
    {
        return ItemName;
    }

    if (kSoldier.HasPerk(`LW_PERK_ID(FireRocket)))
    {
        return 'Item_RocketLauncher';
    }

    return '';
}

function array<TItem> GetItemsInCategory(int iCategory, optional int iTransaction = 1, optional ESoldierClass eClassLock = 0)
{
    local array<TItem> arrItems;
    arrItems.Add(0);

    `LWCE_LOG_DEPRECATED_CLS(GetItemsInCategory);

    return arrItems;
}

function array<LWCEItemTemplate> LWCE_GetItemsInCategory(name nmCategory, optional int iTransaction = eTransaction_Build, optional int iClassLock = 0)
{
    local LWCEItemTemplate kItem;
    local LWCE_TItemQuantity kItemQuantity;
    local array<LWCEItemTemplate> arrItems;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `LWCE_ITEM(kItemQuantity.ItemName);

        if (kItem == none)
        {
            continue;
        }

        if (iTransaction == eTransaction_Sell && !kItem.CanBeSold())
        {
            continue;
        }

        if (iTransaction == eTransaction_Build && !kItem.CanBeBuilt())
        {
            continue;
        }

        if (nmCategory != '' && nmCategory != 'All' && kItem.nmCategory != nmCategory)
        {
            continue;
        }

        if (iClassLock != 0 && !LWCE_IsClassEquippable(iClassLock, kItemQuantity.ItemName))
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

function array<LWCEItemTemplate> LWCE_GetDamagedItemsInCategory(optional name nmCategory = '', optional int iClassLock = 0)
{
    local LWCEItemTemplate kItem;
    local LWCE_TItemQuantity kItemQuantity;
    local array<LWCEItemTemplate> arrItems;

    foreach m_arrCEDamagedItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `LWCE_ITEM(kItemQuantity.ItemName);

        if (nmCategory != '' && nmCategory != 'All' && kItem.nmCategory != nmCategory)
        {
            continue;
        }

        if (iClassLock != 0 && !LWCE_IsClassEquippable(iClassLock, kItemQuantity.ItemName))
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
    local LWCEItemTemplate kItem;
    local LWCE_TItemQuantity kItemQuantity;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `LWCE_ITEM(kItemQuantity.ItemName);

        if (kItem.IsCaptive())
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

function int LWCE_GetNumDamagedItems(name ItemName)
{
    local int Index;

    Index = m_arrCEDamagedItems.Find('ItemName', ItemName);

    if (Index == INDEX_NONE)
    {
        return 0;
    }

    return m_arrCEDamagedItems[Index].iQuantity;
}

function int GetNumItemsAvailable(int iItemId)
{
    if (iItemId == eItem_AlienAlloys)
    {
        return LWCE_GetNumItemsAvailable('Item_AlienAlloy');
    }

    if (iItemId == eItem_Elerium115)
    {
        return LWCE_GetNumItemsAvailable('Item_Elerium');
    }

    if (iItemId == eItem_Meld)
    {
        return LWCE_GetNumItemsAvailable('Item_Meld');
    }

    `LWCE_LOG_DEPRECATED_CLS(GetNumItemsAvailable);

    return -1;
}

function int LWCE_GetNumItemsAvailable(name ItemName)
{
    local LWCEItemTemplate kItem;
    local int Index;

    kItem = `LWCE_ITEM(ItemName);

    // Handle missing items in case of mods
    if (kItem == none)
    {
        return 0;
    }

    if (kItem.IsInfinite())
    {
        return 1000;
    }

    Index = m_arrCEItems.Find('ItemName', ItemName);

    if (Index == INDEX_NONE)
    {
        return 0;
    }

    return m_arrCEItems[Index].iQuantity;
}

function EItemType GetShivWeapon()
{
    `LWCE_LOG_DEPRECATED_CLS(GetShivWeapon);

    return eItem_None;
}

function name LWCE_GetShivWeapon()
{
    return 'Item_Autocannon';
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
        if (kItemQuantity.iQuantity > 0 && `LWCE_ITEM(kItemQuantity.ItemName).IsCaptive())
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
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function IsInfinite was called. This needs to be replaced with LWCEItemTemplate.IsInfinite. Stack trace follows.");
    ScriptTrace();

    return false;
}

function bool IsClassEquippable(ESoldierClass eClass, EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_CLS(IsClassEquippable);
    return super.IsClassEquippable(eClass, eItem);
}

function bool LWCE_IsClassEquippable(int iEquipmentGroup, name ItemName)
{
    local LWCEArmorTemplate kArmor;
    local LWCEItemTemplate kItem;
    local LWCEWeaponTemplate kWeapon;

    kItem = `LWCE_ITEM(ItemName);

    // TODO: rewrite this entirely and start from the class, not the item

    if (kItem.IsArmor())
    {
        kArmor = LWCEArmorTemplate(kItem);

        if (iEquipmentGroup == /* All MEC classes */ 20)
        {
            return kArmor.HasArmorProperty(eAP_MEC);
        }

        if (iEquipmentGroup == /* All SHIVs */ 14)
        {
            return kArmor.HasArmorProperty(eAP_Tank);
        }

        return !kArmor.HasArmorProperty(eAP_MEC) && !kArmor.HasArmorProperty(eAP_Tank);
    }

    kWeapon = LWCEWeaponTemplate(kItem);

    if (kWeapon.HasWeaponProperty(eWP_AnyClass))
    {
        return true;
    }

    if (iEquipmentGroup == /* Assault */ 6 || iEquipmentGroup == /* Engineer */ 10 || iEquipmentGroup == /* Scout */ 11)
    {
        if (kWeapon.HasWeaponProperty(eWP_Rifle))
        {
            return true;
        }
    }

    if (kWeapon.HasWeaponProperty(eWP_Pistol))
    {
        if (ItemName == 'Item_SawedOffShotgun') // Sawed-off shotgun
        {
            return iEquipmentGroup == /* Medic, Infantry */ 5 || iEquipmentGroup == /* Assault */ 6 || iEquipmentGroup == /* Engineer */ 10 || iEquipmentGroup == /* Scout */ 11;
        }

        return iEquipmentGroup != /* Rocketeer */ 8 && iEquipmentGroup != /* Gunner */ 4;
    }

    if (iEquipmentGroup == 0)
    {
        return false;
    }

    return kWeapon.HasWeaponProperty(EWeaponProperty(iEquipmentGroup));
}

/// <summary>Turns all captives in storage into corpses.</summary>
function KillTheCaptives()
{
    local LWCEItemTemplate kItem;
    local LWCE_TItemQuantity kItemQuantity;

    foreach m_arrCEItems(kItemQuantity)
    {
        if (kItemQuantity.iQuantity <= 0)
        {
            continue;
        }

        kItem = `LWCE_ITEM(kItemQuantity.ItemName);

        if (kItem.IsCaptive())
        {
            LWCE_RemoveAllItem(kItemQuantity.ItemName);

            if (kItem.nmCaptiveToCorpseId != '')
            {
                LWCE_AddItem(kItem.nmCaptiveToCorpseId, kItemQuantity.iQuantity);
            }
            else
            {
                `LWCE_LOG_CLS("WARNING: Captive item ID " $ kItem.GetItemName() $ " doesn't have a corresponding corpse set. Captives of this type will be killed without compensation.");
            }
        }
    }
}

function bool ReleaseItem(int iItemId, XGStrategySoldier kSoldier)
{
    `LWCE_LOG_DEPRECATED_CLS(ReleaseItem);

    return false;
}

function bool LWCE_ReleaseItem(name ItemName, XGStrategySoldier kSoldier, optional int iQuantity = 1)
{
    local int Index, iPerkId;
    local LWCE_TItemQuantity kItemQuantity;
    local LWCEEquipmentTemplate kItem;
    local LWCE_XGStrategySoldier kCESoldier;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    // Sometimes we get called to release an empty item slot, so just no-op
    if (ItemName == '')
    {
        return true;
    }

    kItem = LWCEEquipmentTemplate(`LWCE_ITEM(ItemName));

    // Remove any perks granted by this item
    if (kCESoldier != none)
    {
        for (Index = 0; Index < kItem.arrPerks.Length; Index++)
        {
            iPerkId = class'LWCE_XComPerkManager'.static.BaseIDFromPerkName(kItem.arrPerks[Index]);

            // TODO: just move everything to names once perks are templated
            if (iPerkId <= 0 || iPerkId >= ePerk_MAX)
            {
                continue;
            }

            kCESoldier.RemovePerk(iPerkId, 'Item');
        }
    }

    if (kItem.IsInfinite())
    {
        return true;
    }

    Index = m_arrCEItems.Find('ItemName', ItemName);

    if (Index != INDEX_NONE)
    {
        m_arrCEItems[Index].iQuantity += iQuantity;
    }
    else
    {
        // This shouldn't really come up, but just in case it does through some weird mod interactions or something
        kItemQuantity.ItemName = ItemName;
        kItemQuantity.iQuantity = iQuantity;

        m_arrCEItems.AddItem(kItemQuantity);
    }

    return true;
}

function ReleaseLoadout(XGStrategySoldier kSoldier)
{
    local int I;
    local LWCE_XGStrategySoldier kCESoldier;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.nmArmor, kCESoldier);
    kCESoldier.m_kCEChar.kInventory.nmArmor = '';

    LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.nmPistol, kCESoldier);
    kCESoldier.m_kCEChar.kInventory.nmPistol = '';

    for (I = 0; I < kCESoldier.m_kCEChar.kInventory.arrLargeItems.Length; I++)
    {
        LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.arrLargeItems[I], kCESoldier);
        class'LWCEInventoryUtils'.static.SetLargeItem(kCESoldier.m_kCEChar.kInventory, I, '');
    }

    for (I = 0; I < kCESoldier.m_kCEChar.kInventory.arrSmallItems.Length; I++)
    {
        LWCE_ReleaseItem(kCESoldier.m_kCEChar.kInventory.arrSmallItems[I], kCESoldier);
        class'LWCEInventoryUtils'.static.SetSmallItem(kCESoldier.m_kCEChar.kInventory, I, '');
    }
}

function ReleaseSmallItems(XGStrategySoldier kSoldier)
{
    local LWCE_XGStrategySoldier kCESoldier;
    local int I;
    local name ItemName;

    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    for (I = 0; I < kCESoldier.m_kCEChar.kInventory.arrSmallItems.Length; I++)
    {
        ItemName = kCESoldier.m_kCEChar.kInventory.arrSmallItems[I];

        if (!`LWCE_ITEM(ItemName).IsInfinite())
        {
            LWCE_ReleaseItem(ItemName, kCESoldier);
            class'LWCEInventoryUtils'.static.SetSmallItem(kCESoldier.m_kCEChar.kInventory, I, '');
        }
    }
}

function RemoveAllItem(int iItemType)
{
    `LWCE_LOG_DEPRECATED_CLS(RemoveAllItem);
}

function LWCE_RemoveAllItem(name ItemName)
{
    local int Index;

    if (`LWCE_ITEM(ItemName).IsInfinite())
    {
        return;
    }

    Index = m_arrCEItems.Find('ItemName', ItemName);

    if (Index != INDEX_NONE)
    {
        m_arrCEItems[Index].iQuantity = 0;
    }
}

function RemoveItem(int iItemId, optional int iQuantity = 1)
{
    // The XGStrategyActor.AddResource function uses RemoveItem for these 3 items, and it would be a great deal of
    // work for no benefit to change that to LWCE_RemoveItem, so we allow just these 3 to go through. All other items
    // must use LWCE_RemoveItem.
    if (iItemId == eItem_AlienAlloys)
    {
        LWCE_RemoveItem('Item_AlienAlloy', iQuantity);
        return;
    }

    if (iItemId == eItem_Elerium115)
    {
        LWCE_RemoveItem('Item_Elerium', iQuantity);
        return;
    }

    if (iItemId == eItem_Meld)
    {
        LWCE_RemoveItem('Item_Meld', iQuantity);
        return;
    }

    `LWCE_LOG_DEPRECATED_CLS(RemoveItem);
}

function LWCE_RemoveItem(name ItemName, optional int iQuantity = 1)
{
    local int Index;

    if (`LWCE_ITEM(ItemName).IsInfinite())
    {
        return;
    }

    Index = m_arrCEItems.Find('ItemName', ItemName);

    if (Index != INDEX_NONE && m_arrCEItems[Index].iQuantity >= iQuantity)
    {
        m_arrCEItems[Index].iQuantity -= iQuantity;
    }
}

function RepairItem(EItemType eItem, optional int iQuantity = 1)
{
    `LWCE_LOG_DEPRECATED_CLS(RepairItem);
}

function LWCE_RepairItem(name ItemName, optional int iQuantity = 1)
{
    local int iDamagedIndex, iItemIndex;

    if (`LWCE_ITEM(ItemName).IsInfinite())
    {
        return;
    }

    iDamagedIndex = m_arrCEDamagedItems.Find('ItemName', ItemName);
    iItemIndex = m_arrCEItems.Find('ItemName', ItemName);

    if (iQuantity > m_arrCEDamagedItems[iDamagedIndex].iQuantity)
    {
        iQuantity = m_arrCEDamagedItems[iDamagedIndex].iQuantity;
    }

    m_arrCEDamagedItems[iDamagedIndex].iQuantity -= iQuantity;
    m_arrCEItems[iItemIndex].iQuantity += iQuantity;
}

function RestoreBackedUpInventory(XGStrategySoldier kSoldier)
{
    local LWCE_XGFacility_Lockers kLockers;
    local LWCE_XGStrategySoldier kCESoldier;
    local name nmDefaultPrimaryWeapon;
    local int Index;

    kLockers = LWCE_XGFacility_Lockers(LOCKERS());
    kCESoldier = LWCE_XGStrategySoldier(kSoldier);

    if (kCESoldier.m_kCEBackedUpLoadout.nmArmor == 'Item_LeatherJacket')
    {
        // TODO need a hook for the default infinite armor
        kCESoldier.m_kCEBackedUpLoadout.nmArmor = 'Item_TacArmor';
    }

    if (!kLockers.LWCE_EquipArmor(kCESoldier, kCESoldier.m_kCEBackedUpLoadout.nmArmor) && kCESoldier.m_kCEChar.kInventory.nmArmor == 'Item_LeatherJacket')
    {
        kLockers.LWCE_EquipArmor(kCESoldier, 'Item_TacArmor');
    }

    if (kCESoldier.m_kCEBackedUpLoadout.arrLargeItems.Length > 0 && kCESoldier.m_kCEBackedUpLoadout.arrLargeItems[0] == '')
    {
        nmDefaultPrimaryWeapon = LWCE_GetInfinitePrimary(kCESoldier);
        class'LWCEInventoryUtils'.static.SetLargeItem(kCESoldier.m_kCEBackedUpLoadout, 0, nmDefaultPrimaryWeapon);
    }

    if (kCESoldier.m_kCEBackedUpLoadout.arrLargeItems.Length > 0  && kCESoldier.m_kCEBackedUpLoadout.arrLargeItems[0] != kCESoldier.m_kCEChar.kInventory.arrLargeItems[0])
    {
        if (!kLockers.LWCE_EquipLargeItem(kCESoldier, kCESoldier.m_kCEBackedUpLoadout.arrLargeItems[0], 0))
        {
            if (kCESoldier.m_kCEChar.kInventory.arrLargeItems[0] == '')
            {
                nmDefaultPrimaryWeapon = LWCE_GetInfinitePrimary(kCESoldier);
                class'LWCEInventoryUtils'.static.SetLargeItem(kCESoldier.m_kCEBackedUpLoadout, 0, nmDefaultPrimaryWeapon);
            }
        }
    }

    for (Index = 1; Index < kCESoldier.m_kCEBackedUpLoadout.arrLargeItems.Length; Index++)
    {
        if (kCESoldier.m_kCEBackedUpLoadout.arrLargeItems[Index] != kCESoldier.m_kCEChar.kInventory.arrLargeItems[Index])
        {
            kLockers.LWCE_EquipLargeItem(kCESoldier, kCESoldier.m_kCEBackedUpLoadout.arrLargeItems[Index], Index);
        }
    }

    for (Index = 0; Index < kCESoldier.m_kCEBackedUpLoadout.arrSmallItems.Length; Index++)
    {
        if (kCESoldier.m_kCEBackedUpLoadout.arrSmallItems[Index] != kCESoldier.m_kCEChar.kInventory.arrSmallItems[Index])
        {
            kLockers.LWCE_EquipSmallItem(kCESoldier, kCESoldier.m_kCEBackedUpLoadout.arrSmallItems[Index], Index);
        }
    }

    if (kCESoldier.m_kCEBackedUpLoadout.nmPistol != kCESoldier.m_kCEChar.kInventory.nmPistol)
    {
        if (!kLockers.LWCE_EquipPistol(kCESoldier, kCESoldier.m_kCEBackedUpLoadout.nmPistol))
        {
            kLockers.LWCE_EquipPistol(kCESoldier, LWCE_GetInfiniteSecondary(kCESoldier));
        }
    }
}