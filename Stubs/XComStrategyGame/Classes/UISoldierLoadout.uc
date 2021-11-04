class UISoldierLoadout extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);

var const localized string m_strScreenTitle;
var const localized string m_strInventoryListTitle;
var const localized string m_strLockerListTitle;
var const localized string m_strEquipItemHelpText;
var const localized string m_strViewItemCardHelpText;
var const localized string m_strRemoveEqipmentHelpText;
var XGSoldierUI m_kLocalMgr;
var string m_strCameraTag;
var name DisplayTag;
var SkeletalMeshActor m_kCameraRig;
var Vector m_kCameraRigDefaultLocation;
var float m_kCameraRigMecVerticalOffset;
var int m_iCurrentInventorySlot;
var int m_iLockerSelectionWatchHandle;
var bool m_bItemCardActive;
var XGStrategySoldier m_kSoldier;
var UIStrategyComponent_SoldierInfo m_kSoldierHeader;
var UIStrategyComponent_SoldierStats m_kSoldierStats;
var UIStrategyComponent_SoldierAbilityList m_kAbilityList;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function XGSoldierUI GetMgr(optional int iStaringView){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function OnFlashCommand(string Cmd, string Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function ShowItemCard(){}
simulated function ListFocusUpdated(){}
simulated function SoldierPawnUpdated(){}
simulated function UpdateData(){}
simulated function UpdateInventoryList(){}
simulated function UpdateLockerList(optional int InventorySlot){}
simulated function GFxObject GetMecArmorIconsArray(int iArmorItem){}
simulated function UpdatePanels(){}
final simulated function RealizeSelected(){}
simulated function RealizeSelected_Locker(){}
simulated function RealizeSelected_Inventory(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function OnMousePrevSoldier(){}
simulated function PrevSoldier(){}
simulated function OnMouseNextSoldier(){}
simulated function NextSoldier(){}
final simulated function UpdateButtonHelp(){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string Str){}
simulated function OnUnequip(){}
simulated function Show(){}
simulated function Hide(){}
simulated function Remove(){}
final simulated function AS_SetScreenTitle(string Title){}
final simulated function AS_SetListTitles(string inventoryTitle, string lockerTitle){}
simulated function AS_SetLockerButtonHelp(string equipItemHelpText, string equipItemGamepadIcon, string viewItemCardHelpText, string viewItemCardGamepadIcon){}
simulated function AS_SetRemoveInventorySlotButtonHelp(string Label, string btnIcon){}
simulated function AS_AddInventoryItem(int Type, string Title, string imgLabel, int numEquipableItems, GFxObject mecIconsArray){}
simulated function AS_AddLockerItem(string Title, string Count, string imgLabel, bool isLocked, bool showItemCardHelp, string lockedDescription, GFxObject mecIconsArray){}
simulated function AS_SetSelectedIndex_InventoryList(int Index){}
simulated function AS_SetSelectedIndex_LockerList(int Index){}
function OnDeactivate(){}
event Destroyed(){}
