class UIMECUpgrade extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

const MAX_ROWS = 3;
const MAX_COLS = 2;

var const localized string m_strMECUpgradeNewMEC;
var const localized string m_strMECUpgradeUpgrade;
var const localized string m_strMECUpgradeSubtitle;
var const localized string m_strConfirmUpgradeTitle;
var const localized string m_strConfirmUpgradeText;
var const localized string m_strConfirmUpgrade;
var const localized string m_strCancelUpgrade;
var const localized string m_strLockedMECLabel;
var const localized string m_strLockedMECDescription;
var const localized string m_strCostLabel;
var XGCyberneticsUI m_kLocalMgr;
var name DisplayTag;
var string m_strCameraTag;
var private SkeletalMeshActor m_kCameraRig;
var private Vector m_kCameraRigDefaultLocation;
var private array<Vector> m_arrMecUpgradeCameraOffsets;
var private string m_strCameraOffset_1;
var private string m_strCameraOffset_2;
var private string m_strCameraOffset_3;
var private int m_iCurrentMec;
var private int m_iCurrentAbility;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function XGCyberneticsUI GetMgr(){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData(){}
function UpdateUpgradeCamera(){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function OnUCancel(){}
simulated function bool OnCancel(optional string Str){}
function ConfirmDialogue(){}
simulated function ConfirmDialogueCallback(EUIAction eAction){}
simulated function RealizeSelected(){}
simulated function UpdateResources(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function Remove(){}
simulated function AS_SetLabels(string Title, string subtitle){}
simulated function AS_SetCost(string Cost){}
simulated function AS_SetAbilityInfo(string abilityName, string abilityDesc){}
simulated function AS_SetAbilityIcon(int column, int Row, string iconLabel, bool isHighlighted){}
simulated function AS_SetColumnData(int ColumnIndex, string Label, int columnHighlightState){}
simulated function AS_SetSelectedIcon(int column, int Row){}
