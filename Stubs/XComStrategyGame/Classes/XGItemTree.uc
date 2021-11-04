class XGItemTree extends XGStrategyActor
    hidecategories(Navigation)
    config(GameData)
    notplaceable;
//complete stub
var array<TItem> m_arrItems;
var array<TFacility> m_arrFacilities;
var array<TItem> m_arrStaff;
var array<TShip> m_arrShips;
var array<TShipWeapon> m_arrShipWeapons;
var int m_iCurrentCategory;
var XGStrategyActorTag m_kStrategyActorTag;
var const localized string m_strRangeShort;
var const localized string m_strRangeMedium;
var const localized string m_strRangeLong;
var const localized string m_strNotFullyResearched;
var const localized string ItemTypeSummary[EItemType];
var const localized string ShipTypeNames[16];
var const localized string ShipTypeFlavorTxt[16];
var const localized string m_strSizeSmall;
var const localized string m_strSizeMedium;
var const localized string m_strSizeLarge;
var const localized string m_strSizeVeryLarge;

function Init(){}
function bool ItemIsValid(EItemType eItem){}
function BuildItems(){}
function BuildFacilities(){}
function BuildStaffTypes(){}
function BuildShips(){}
function UpdateShips(){}
function UpdateAllShipTemplates(){}
function BuildShipWeapons(){}
function BuildShip(EShipType eType, string strSize, EImage eShipImage, optional int iWeapon1, optional int iWeapon2){}
function UpdateShip(EShipType eType, int iSpeed, int iEngagementSpeed, int iHP, int Armor, int iAP){}
function UpdateShipToNewValues(XGShip kShip){}
function BuildShipWeapon(EShipWeapon eType, int iAmmo, int iRange, float fFiringTime, int iDamage, int iArmorPen, int iToHit){}
function DetermineShipSalvage(out TShip kShip){}
function int Alloys(int iNumAlloys){}
function int Elerium(int iNumPowerSources){}
function TItem GetItem(int iItem, optional int iTransactionType){}
function ScaleCost(out TItem kItem){}
function CalcEscalatingSatelliteCost(out TItem kItem){}
function TFacility GetFacility(int iFacility, optional bool bRushConstruction){}
function TItem GetStaff(int iStaff){}
function TShip GetShip(EShipType eShip){}
function TShipWeapon GetShipWeapon(int iWeaponType){}
function bool IsShipWeapon(int iItemType){}
function array<TItem> GetBuildItems(int iCategory){}
function array<TFacility> GetBuildFacilities(){}
function int GetScientistsRequiredForNextLab(){}
function int GetEngineersRequiredForNextWorkshop(){}
function int GetEngineersRequiredForNextUplink(EFacilityType eFacility, optional bool bCurrentCapacity){}
function bool CanFacilityBeBuilt(int iFacility){}
function bool CanHaveMultiple(int iFacility){}
function bool CanBeBuilt(int iItem){}
function bool CanBeSold(int iItem){}
function int GetAlloySalePrice(){}
function int GetItemSalePrice(EItemType eItem){}
function int GetItemQuestPrice(EItemType eItem){}
function int GetItemBuildTime(EItemType eItem, EItemCategory eItemCat, int iEngineerDays){}
function int GetFacilityEngineeringCost(int iEngineers){}
function int GetFacilityMaintenanceCost(int iCost){}
function int GetFacilityTimeCost(int iDays){}
function int GetFacilityCost(int iCost){}
function int GetFacilityPower(int iPower){}
function int GetItemAlloyCost(int iCost){}
function int GetItemMeldCost(int iCost){}
function int GetItemEleriumCost(int iCost){}
function int GetItemCreditCost(int iCost){}
function int GetItemEngineersRequired(int iEngineers){}
function bool IsMecArmor(int iItem){}
function BalanceItems(){}
function BalanceFacilities(){}
function BuildItem(int iItem, optional int iCashCost, optional int iEleriumCost, optional int iAlloyCost, optional int iMeldCost, optional int iTime, optional int iMaxEngineers, optional ETechType eTechReq, optional EItemType eItemReq, optional EFoundryTech eFTech, optional int EImage){}
function BuildFacility(int iFacility, int iCashCost, int iElerium, int iAlloy, int iMaintenanceCost, int iEngineers, int iTime, int iPower, int iSize, optional ETechType eTechReq, optional EItemType eItemReq, optional EImage EImage){}
function BuildStaff(int iStaff, int iCashCost, int iDeliveryTime, int iImage){}
function SetSoldierStaffCost(){}
function string GetSummary(int iItem){}
function string GetFacilitySummary(int iFacility){}
function string GetStaffSummary(int iStaff){}
function bool IsArmor(int iItem){}
function bool IsWeapon(int iItem){}
function bool IsItem(int iItem){}
function bool IsLargeWeapon(int iItem){}
function bool IsSmallWeapon(int iItem){}
function bool IsSmallItem(int iItem){}
function bool IsCaptive(EItemType eItem){}
simulated function bool IsItemUniqueEquip(EItemType eItem){}
function EItemType CaptiveToCorpse(EItemType eCaptive){}
