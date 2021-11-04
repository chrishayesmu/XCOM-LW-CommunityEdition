class UISoldierCustomize extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

const FIRST_NAME_MAX_CHARS = 11;
const NICKNAME_NAME_MAX_CHARS = 11;
const LAST_NAME_MAX_CHARS = 15;
const NUM_BUTTONS = 3;
const NUM_SPINNERS = 11;

var const localized string m_strCustomizeFirstName;
var const localized string m_strCustomizeLastName;
var const localized string m_strCustomizeNickName;
var const localized array<localized string> m_arrLanguages;
var XGCustomizeUI m_kLocalMgr;
var string m_strCameraTag;
var name DisplayTag;
var SkeletalMeshActor m_kCameraRig;
var Vector m_kCameraRigDefaultLocation;
var float m_kCameraRigMecDistanceOffset;
var float m_kCameraRigMecVerticalOffset;
var float m_kCameraRigMecHorizontalOffset;
var int m_iView;
var int m_iCustomizeNameType;
var XGStrategySoldier m_kSoldier;
var UIStrategyComponent_SoldierInfo m_kSoldierHeader;
var UIWidgetHelper m_hWidgetHelper;
var bool m_bRequestUserInputActive;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function XGCustomizeUI GetMgr(){}
simulated function XGSoldierUI GetSoldierUIMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnAccept(optional string Arg){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string Arg){}
simulated function UpdateData(){}
function OnSpinnerIncrease(){}
function OnSpinnerDecrease(){}
function OnMenuButtonClick(){}
function CustomizeName(){}
function OnNameInputBoxClosed(string Text){}
simulated function OpenVirtualKeyboard(string titleStr, string defaultStr, optional int maxCharLimit){}
reliable client simulated function VirtualKeyboard_OnAccept(string userInput, bool bWasSuccessful){}
reliable client simulated function VirtualKeyboard_OnCancel(){}
function bool ShouldAcceptName(string strInput, int char_max){}
simulated function OnMousePrevSoldier(){}
simulated function bool PrevSoldier(){}
simulated function OnMouseNextSoldier(){}
simulated function bool NextSoldier(){}
simulated function SuperSoldierCreated(){}
simulated function UpdateButtonHelp(){}
simulated function GoToView(int iView){}
simulated function AS_SetSoldierInformation(string _name, string _nickname, string _status, string _flagIcon, string _classLabel, string _classText, string _rankLabel, string _rankText, bool _showPromoteIcon){}
simulated function Remove(){}
function OnDeactivate(){}
event Destroyed(){}
