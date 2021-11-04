class UIChooseTech extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete  stub

struct UIOption
{
    var int iIndex;
    var string strLabel;
    var int iState;
    var string strHelp;
};

var const localized string m_strScienceTechSelectTitle;
var const localized string m_strCreditArchiveTitle;
var const localized string m_strConfirm;
var const localized string m_strExit;
var XGResearchUI m_kLocalMgr;
var string m_strCameraTag;
var name DisplayTag;
var int m_iCurrentSelection;
var array<UIOption> m_arrUIOptions;
var int m_iView;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, int iView){}
simulated function XGResearchUI GetMgr(){}
simulated function OnInit(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData(){}
simulated function UpdateLayout(){}
simulated function AS_AddOption(int iIndex, string sLabel, int iState){}
simulated function AS_SetConfirmButtonHelp(string sLabel){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function OnUCancel(){}
simulated function bool OnCancel(optional string Str){}
simulated function bool OnOption(optional string Str){}
simulated function UpdateInfoPanelData(int iTechIndex){}
simulated function AS_UpdateInfo(string techName, string infoText, string descText, string imgPath){}
simulated function AS_SetTitle(string displayString){}
simulated function RealizeSelected(){}
function UnlockItems(array<TItemUnlock> arrUnlocks);
function UnlockItem(TItemUnlock kUnlock);
simulated function Remove(){}
