class XGStorage extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord
{
    var array<int> m_arrItems;
    var array<int> m_arrDamagedItems;
    var array<int> m_arrItemArchives;
    var array<int> m_arrClaims;
    var array<EItemType> m_arrInfiniteItems;
};

var array<int> m_arrItems;
var array<int> m_arrDamagedItems;
var array<int> m_arrItemArchives;
var array<int> m_arrClaims;
var array<EItemType> m_arrInfiniteItems;

function Init(){}
function AddInfiniteItem(EItemType eItem){}
function bool IsInfinite(EItemType eItem){}
function array<TItem> GetItemsInCategory(int iCategory, optional int iTransaction, optional ESoldierClass eClassLock){}
function array<TItem> GetDamagedItemsInCategory(int iCategory, optional ESoldierClass eClassLock){}
function bool IsClassEquippable(ESoldierClass eClass, EItemType eItem){}
function ESoldierClass GetWeaponClassLimit(EItemType eItem){}
function int GetNumItemsAvailable(int iItemType){}
function bool EverHadItem(int iItemType){}
function bool ClaimItem(int iItemType, XGStrategySoldier kSoldier){}
function bool ReleaseItem(int iItemType, XGStrategySoldier kSoldier){}
function EItemType GetShivWeapon(){}
function AddItem(int iItemType, optional int iQuantity, optional int iContinent){}
function RemoveItem(int iItemType, optional int iQuantity){}
function RemoveAllItem(int iItemType){}
function DamageItem(EItemType eItem, optional int iQuantity){}
function RepairItem(EItemType eItem, optional int iQuantity){}
function int GetNumDamagedItems(EItemType eItem){}
function array<EItemType> GetCaptives(){}
function KillTheCaptives(){}
function RemoveLoadout(XGStrategySoldier kSoldier){}
function ReleaseLoadout(XGStrategySoldier kSoldier){}
function ReleaseSmallItems(XGStrategySoldier kSoldier){}
function EItemType GetInfinitePrimary(XGStrategySoldier kSoldier){}
function EItemType GetInfiniteSecondary(XGStrategySoldier kSoldier){}
function BackupAndReleaseInventoryForCovertOp(XGStrategySoldier kSoldier){}
function BackupAndReleaseInventory(XGStrategySoldier kSoldier){}
function RestoreBackedUpInventory(XGStrategySoldier kSoldier){}
function int GetBestAvailableArmor(){}
function int GetBestAvailableLargeWeapon(){}
function int GetBestAvailablePistol(){}
function int GetBestAvailableSmallItem(){}
function bool AreReaperRoundsValid(XGStrategySoldier kSoldier){}
function AutoEquip(XGStrategySoldier kSoldier){}
function array<TItem> GetCorpses(){}
function bool HasAlienWeapon(){}
function bool HasXenobiologyCorpse(){}
function bool HasAlienCaptive(){}
function bool HasSatellites(){}
