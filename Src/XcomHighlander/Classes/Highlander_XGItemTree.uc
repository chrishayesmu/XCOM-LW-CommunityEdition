class Highlander_XGItemTree extends XGItemTree
    dependson(HighlanderTypes)
    config(HighlanderBaseStrategyGame);

var config array<HL_TItem> arrBaseGameItems;

var array<HL_TItem> m_arrHLItems;

function Init()
{
    local HL_TItem kItem;

    m_kStrategyActorTag = new class'XGStrategyActorTag';

    foreach arrBaseGameItems(kItem)
    {
        kItem.strName = class'XLocalizedData'.default.m_aItemNames[kItem.iItemId];
        kItem.strNamePlural = class'XLocalizedData'.default.m_aItemNamesPlural[kItem.iItemId];
        kItem.strBriefSummary = ItemTypeSummary[kItem.iItemId];
        kItem.strTacticalText = class'XLocalizedData'.default.m_aItemTacticalText[kItem.iItemId];

        m_arrHLItems.AddItem(kItem);
    }

    `HL_MOD_LOADER.OnItemsBuilt(m_arrHLItems);

    m_arrFacilities.Add(24);
    m_arrStaff.Add(4);
    m_arrShips.Add(16);
    m_arrShipWeapons.Add(11);

    BuildShips();
    BuildShipWeapons();
    BuildFacilities();
    BuildStaffTypes();
}

function BuildShips()
{
    BuildShip(1,  m_strSizeSmall,     eImage_Interceptor, eShipWeapon_Avalanche);                            // Interceptor
    BuildShip(2,  m_strSizeSmall,     eImage_Skyranger);                                                     // Skyranger
    BuildShip(3,  m_strSizeSmall,     eImage_Firestorm,   eShipWeapon_Avalanche);                            // Firestorm
    BuildShip(4,  m_strSizeSmall,     eImage_SmallScout,  eShipWeapon_UFOPlasmaI);                           // Scout
    BuildShip(5,  m_strSizeMedium,    eImage_LargeScout,  eShipWeapon_UFOPlasmaI);                           // Destroyer
    BuildShip(6,  m_strSizeLarge,     eImage_Abductor,    eShipWeapon_UFOPlasmaII);                          // Abductor
    BuildShip(7,  m_strSizeLarge,     eImage_SupplyShip,  eShipWeapon_UFOPlasmaII);                          // Transport
    BuildShip(8,  m_strSizeVeryLarge, eImage_Battleship,  eShipWeapon_UFOFusionI);                           // Battleship
    BuildShip(9,  m_strSizeMedium,    eImage_EtherealUFO, eShipWeapon_UFOPlasmaII, eShipWeapon_UFOPlasmaI);  // Overseer
    BuildShip(10, m_strSizeSmall,     eImage_SmallScout,  eShipWeapon_UFOPlasmaI);                           // Fighter
    BuildShip(11, m_strSizeMedium,    eImage_LargeScout,  eShipWeapon_UFOPlasmaI);                           // Raider
    BuildShip(12, m_strSizeLarge,     eImage_Abductor,    eShipWeapon_UFOPlasmaII);                          // Harvester
    BuildShip(13, m_strSizeLarge,     eImage_SupplyShip,  eShipWeapon_UFOPlasmaII);                          // Terror Ship
    BuildShip(14, m_strSizeVeryLarge, eImage_Battleship,  eShipWeapon_UFOPlasmaII, eShipWeapon_UFOPlasmaI);  // Assault Carrier

    UpdateShips();
}

function BuildShipWeapons()
{
    local int ToHitBonus;

    ToHitBonus = IsOptionEnabled(`LW_SECOND_WAVE_ID(TheFriendlySkies)) ? int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI) : 0;

    // XCOM weapons
    BuildShipWeapon(1, -1,  100, 0.750, 140,  5,  40 + ToHitBonus); // Phoenix Cannon
    BuildShipWeapon(2, -1,  100, 1.50,  200,  10, 40 + ToHitBonus); // Stingray Missiles
    BuildShipWeapon(3, -1,  100, 2.0,   340,  0,  40 + ToHitBonus); // Avalanche Missiles
    BuildShipWeapon(4, -1,  100, 1.0,   290,  5,  55 + ToHitBonus); // Laser Cannon
    BuildShipWeapon(5, -1,  100, 1.0,   650,  22, 40 + ToHitBonus); // Plasma Cannon
    BuildShipWeapon(6, -1,  100, 0.550, 310,  30, 30 + ToHitBonus); // EMP Cannon
    BuildShipWeapon(7, -1,  100, 1.250, 1200, 26, 30 + ToHitBonus); // Fusion Lance

    // UFO weapons
    BuildShipWeapon(8,  -1, 101, 1.150, 450,  0,  33); // UFO: Single Plasma
    BuildShipWeapon(9,  -1, 101, 1.250, 800,  20, 40); // UFO: Double Plasma
    BuildShipWeapon(10, -1, 101, 1.250, 1300, 50, 45); // UFO: Fusion Lance

    UpdateShips();
}

function bool CanBeBuilt(int iItemId)
{
    local HL_TItem kItem;

    kItem = HL_GetItem(iItemId);

    if (kItem.iHours < 0 || kItem.bIsInfinite)
    {
        return false;
    }

    if (!`HL_HQ.ArePrereqsFulfilled(kItem.kPrereqs))
    {
        return false;
    }

    // TODO: add a mod hook

    return true;
}

function bool CanBeSold(int iItemId)
{
    local HL_TItem kItem;

    kItem = HL_GetItem(iItemId, eTransaction_Sell);

    if (kItem.bIsInfinite)
    {
        return false;
    }

    // TODO: add a mod hook

    switch (iItemId)
    {
        case `LW_ITEM_ID(LeatherJacket):
        case `LW_ITEM_ID(SHIV):
        case `LW_ITEM_ID(AlloySHIV):
        case `LW_ITEM_ID(HoverSHIV):
        case `LW_ITEM_ID(Interceptor):
        case `LW_ITEM_ID(Firestorm):
        case `LW_ITEM_ID(Skyranger):
        case `LW_ITEM_ID(Satellite):
        case `LW_ITEM_ID(StingrayMissiles):
        case `LW_ITEM_ID(PhoenixCannon):
        case `LW_ITEM_ID(AvalancheMissiles):
        case `LW_ITEM_ID(LaserCannon):
        case `LW_ITEM_ID(PlasmaCannon):
        case `LW_ITEM_ID(EMPCannon):
        case `LW_ITEM_ID(FusionLance):
        case `LW_ITEM_ID(DefenseMatrixDodge):
        case `LW_ITEM_ID(UFOTrackingBoost):
        case `LW_ITEM_ID(UplinkTargetingAim):
        case `LW_ITEM_ID(SkeletonKey):
        case `LW_ITEM_ID(BaseAugments):
            return false;
        case `LW_ITEM_ID(AlienGrenade):
            return !ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienGrenades));
        default:
            return kItem.kCost.iCash >= 0;
    }
}

function EItemType CaptiveToCorpse(EItemType eCaptive)
{
    `HL_LOG_DEPRECATED_CLS(CaptiveToCorpse);
    return eItem_None;
}

function int HL_CaptiveToCorpse(int iCaptiveItemId)
{
    return HL_GetItem(iCaptiveItemId).iCaptiveToCorpseId;
}

function int CharacterToCorpse(int iCharacterId)
{
    local array<int> arrPossibleCorpses;
    local HL_TItem kItem;

    foreach m_arrHLItems(kItem)
    {
        if (kItem.bIsCorpse && kItem.iCorpseToCharacterId == iCharacterId)
        {
            arrPossibleCorpses.AddItem(kItem.iCorpseToCharacterId);
        }
    }

    if (arrPossibleCorpses.Length == 0)
    {
        return 0;
    }

    return arrPossibleCorpses[Rand(arrPossibleCorpses.Length)];
}

function int GetAlloySalePrice()
{
    return HL_GetItem(`LW_ITEM_ID(AlienAlloy)).kCost.iCash;
}

function array<TItem> GetBuildItems(int iCategory)
{
    local array<TItem> arrItems;
    arrItems.Add(0);

    `HL_LOG_DEPRECATED_CLS(GetBuildItems);

    return arrItems;
}

function array<HL_TItem> HL_GetBuildItems(int iCategory)
{
    local Highlander_XGFacility_Engineering kEngineering;
    local array<HL_TItem> arrItems;
    local HL_TItem kItem;
    local int iPriorityItems;

    kEngineering = `HL_ENGINEERING;

    foreach m_arrHLItems(kItem)
    {
        if (kItem.iCategory == iCategory)
        {
            if (CanBeBuilt(kItem.iItemId))
            {
                if (kEngineering.HL_IsPriorityItem(kItem.iItemId))
                {
                    arrItems.InsertItem(iPriorityItems, kItem);
                    ++iPriorityItems;
                }
                else
                {
                    arrItems.AddItem(kItem);
                }
            }
        }
    }

    return arrItems;
}

function int GetEleriumSalePrice()
{
    return HL_GetItem(`LW_ITEM_ID(Elerium)).kCost.iCash;
}

function TItem GetItem(int iItem, optional int iTransactionType = eTransaction_Build)
{
    local TItem kItem;

    `HL_LOG_DEPRECATED_CLS(GetItem);

    return kItem;
}

function HL_TItem HL_GetItem(int iItemId, optional int iTransactionType = eTransaction_Build)
{
    local int Index;
    local HL_TItem kItem;

    Index = m_arrHLItems.Find('iItemId', iItemId);

    if (Index == INDEX_NONE)
    {
        if (iItemId != 0)
        {
            `HL_LOG_CLS("ERROR: HL_GetItem had requested item ID " $ iItemId $ " but no such item exists!");
            ScriptTrace();
        }

        return kItem;
    }

    kItem = m_arrHLItems[Index];

    if (iItemId == `LW_ITEM_ID(AlienGrenade))
    {
        kItem.bIsInfinite = ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(AlienGrenades));
    }

    if (iTransactionType == eTransaction_Sell)
    {
        kItem.kCost.iCash = HL_GetItemSalePrice(kItem.iItemId);
    }

    `HL_MOD_LOADER.Override_GetItem(kItem, iTransactionType);

    return kItem;
}

function int GetItemBuildTime(EItemType eItem, EItemCategory eItemCat, int iEngineerDays)
{
    `HL_LOG_DEPRECATED_CLS(GetItemBuildTime);
    return 0;
}

function int HL_GetItemBuildTime(int iItemId, int iItemCat, int iEngineerDays)
{
    local float fBalanceFactor;

    if (iEngineerDays < 0)
    {
        return -1;
    }

    if (iItemCat != eItemCat_Vehicles && IsShipWeapon(iItemId))
    {
        iEngineerDays = 0;
    }

    fBalanceFactor = class'XGTacticalGameCore'.default.ITEM_TIME_BALANCE;
    return int(float(iEngineerDays * 24) * fBalanceFactor);
}

function int GetItemQuestPrice(EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(GetItemQuestPrice);
    return 0;
}

function int HL_GetItemQuestPrice(int iItemid)
{
    local int iQuestPrice;
    local float fPerHourValue;
    local HL_TItem kItem;

    kItem = HL_GetItem(iItemId);

    iQuestPrice = 0;
    fPerHourValue = 0.0650; // TODO move to config
    iQuestPrice += kItem.kCost.iCash;
    iQuestPrice += int(fPerHourValue * kItem.iHours);
    iQuestPrice += kItem.kCost.iAlloys * GetAlloySalePrice();
    iQuestPrice += kItem.kCost.iElerium * GetEleriumSalePrice();

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        if (iItemId != `LW_ITEM_ID(AlienAlloy) && iItemId != `LW_ITEM_ID(Elerium) && iItemId != `LW_ITEM_ID(Meld) && iItemId != `LW_ITEM_ID(WeaponFragment))
        {
            iQuestPrice /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }
    }

    return iQuestPrice;
}

function int GetItemSalePrice(EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(GetItemSalePrice);
    return 0;
}

function int HL_GetItemSalePrice(int iItemId)
{
    local HL_TItem kItem;
    local int iManufactureCost;

    kItem = HL_GetItem(iItemId);
    iManufactureCost = kItem.kCost.iCash;

    if (kItem.iHours >= 0)
    {
        iManufactureCost *= 0.40;
    }
    else if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        if (iItemId != `LW_ITEM_ID(AlienAlloy) && iItemId != `LW_ITEM_ID(Elerium) && iItemId != `LW_ITEM_ID(Meld) && iItemId != `LW_ITEM_ID(WeaponFragment))
        {
            iManufactureCost /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }
    }

    if (HL_IsCorpse(iItemId) && HQ().HasBonus(`LW_HQ_BONUS_ID(XenologicalRemedies)) > 0)
    {
        iManufactureCost *= (float(1) + (float(HQ().HasBonus(`LW_HQ_BONUS_ID(XenologicalRemedies))) / float(100)));
    }

    return iManufactureCost;
}

function string GetSummary(int iItemId)
{
    `HL_LOG_CLS("Highlander_XGItemTree.GetSummary is deprecated. Use HL_TItem.strBriefSummary instead. Stack trace follows.");
    ScriptTrace();

    return "";
}

// TODO: reimplement most of the functions after this
function bool IsArmor(int iItem)
{
    // TODO rewrite by looking for a TArmor referencing this item ID
    if (iItem == 182)
    {
        return true;
    }

    if (iItem == 159)
    {
        return true;
    }

    if (iItem == 160)
    {
        return true;
    }

    return iItem >= 57 && iItem <= 68;
}

function bool IsCaptive(EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(IsCaptive);
    return false;
}

function bool HL_IsCaptive(int iItemId)
{
    return HL_GetItem(iItemId).bIsCaptive;
}

function bool HL_IsCorpse(int iItemId)
{
    return HL_GetItem(iItemId).bIsCorpse;
}

function bool IsItem(int iItem)
{
    return TACTICAL().ItemIsAccessory(iItem);
}

simulated function bool IsItemUniqueEquip(EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(IsItemUniqueEquip);
    return false;
}

simulated function bool HL_IsItemUniqueEquip(int iItemId)
{
    return HL_GetItem(iItemId).bIsUniqueEquip;
}

function bool IsLargeWeapon(int iItem)
{
    return IsWeapon(iItem) && TACTICAL().GetTWeapon(iItem).iSize == 1;
}

function bool IsSmallItem(int iItem)
{
    return IsItem(iItem) && TACTICAL().GetTWeapon(iItem).iSize == 0;
}

function bool IsSmallWeapon(int iItem)
{
    return IsWeapon(iItem) && TACTICAL().GetTWeapon(iItem).iSize == 0;
}

function bool IsWeapon(int iItem)
{
    return TACTICAL().ItemIsWeapon(iItem);
}

function bool ItemIsValid(EItemType eItem)
{
    `HL_LOG_DEPRECATED_CLS(ItemIsValid);
    return false;
}

function bool HL_ItemIsValid(int iItemId)
{
    // TODO: add a mod hook to help gracefully deprecate items
    return iItemId != 0 && iItemId != 255;
}