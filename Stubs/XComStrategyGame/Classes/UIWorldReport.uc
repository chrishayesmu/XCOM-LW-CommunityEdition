class UIWorldReport extends UI_FxsShellScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);

var XGWorldReportUI m_kMgr;
var const localized string m_strNext;
var const localized string m_strDecoded;
var string m_strMessage;

function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, XGWorldReportUI gameManager){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function name GetViewState(int iView){}
simulated function GoToView(int iView){}
simulated function Show(){}
simulated function Hide(){}
simulated function Remove(){}
simulated function AS_SetText(string Text){}
simulated function AS_SetDecryptingText(string Text, string Ready){}
simulated function AS_HideDecrypting(){}
