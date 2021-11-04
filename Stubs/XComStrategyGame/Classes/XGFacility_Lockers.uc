class XGFacility_Lockers extends XGFacility;
//complet stub

enum EInventorySlot
{
    eInvSlot_Armor,
    eInvSlot_Pistol,
    eInvSlot_Large,
    eInvSlot_Small,
    eInvSlot_MAX
};

struct TLockerItem
{
    var int iItem;
    var int iQuantity;
    var bool bTechLocked;
    var bool bClassLocked;
    var ESoldierClass eClassLock;
};

var string m_strError;
var bool m_bNarrArcWarning;

function Init(bool bLoadingFromSave){}
function InitNewGame(){}
function bool ApplySoldierLoadout(XGStrategySoldier kSoldier, TInventory kInventory) {}
function bool ApplyTankLoadout(XGStrategySoldier kTank, TInventory kInventory){}
function UnequipArmor(XGStrategySoldier kSoldier){}
simulated function DoNarrativeMomentsForEquipingArmors(int iArmor){}
function bool EquipLargeItem(XGStrategySoldier kSoldier, int iItem, int iSlot) {}
function bool EquipArmor(XGStrategySoldier kSoldier, int iArmor){}
function bool EquipPistol(XGStrategySoldier kSoldier, int iPistol){}
function bool EquipSmallItem(XGStrategySoldier kSoldier, int iItem, int iSlot){}
function bool EquipCustomItem(XGStrategySoldier kSoldier, int iItem, int iSlot){}
function bool UnequipPistol(XGStrategySoldier kSoldier){}
function bool UnequipLargeItem(XGStrategySoldier kSoldier, int iSlot){}
function bool UnequipSmallItem(XGStrategySoldier kSoldier, int iSlot){}
function DisableSmallSlot(XGStrategySoldier kSoldier){}
function EnableSmallSlot(XGStrategySoldier kSoldier){}
function bool UnequipCustomItem(XGStrategySoldier kSoldier, int iSlot){}
function int GetLargeInventorySlots(XGStrategySoldier kSoldier, int iArmor){}
function int GetSmallInventorySlots(XGStrategySoldier kSoldier, int iArmor){}
function bool IsTechLocked(out TItem kItem, XGStrategySoldier kSoldier){}
function TLockerItem GetLockerItem(EInventorySlot eSlotType, out TItem kItem, XGStrategySoldier kSoldier){}
function array<TLockerItem> GetLockerItems(int iSlotType, int iSlotIndex, XGStrategySoldier kSoldier){}
function AddLargeItemToLockerList(const TLockerItem kLockerItem, out array<TLockerItem> arrLockerItems){}
function int FindLockerItemByType(const out array<TLockerItem> arrLockerItems, int Type){}


