class UIMedals extends UI_FxsScreen
    hidecategories(Navigation)
    implements(IScreenMgrInterface);
//complete stub

var int m_iCurrentMedal;
var int m_iCurrentEditing;
var int m_iCurrentPower;
var int m_iView;
var bool m_bRequestUserInputActive;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function XGMedalsUI GetMgr(optional int iStaringView){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string Arg){}
simulated function UpdateButtonHelp(){}
simulated function UpdateCurrentMedals(){}
simulated function UpdateEditMedals(){}
simulated function UpdateAssignPower(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
simulated function GoToView(int iView){}
simulated function AS_SetDisplayMode(int displayMode){}
simulated function OnConfirm(){}
simulated function OnNext(){}
simulated function OnPrev(){}
simulated function OnLeft(){}
simulated function OnRight(){}
event Destroyed(){}
function OnDeactivate(){}
simulated function AS_SetTitle(string Title){}
simulated function AS_SetEditingTitle(string Title, string subtitle, string subtitle2){}
simulated function AS_SetInfo(int Index, string strName, string Status, bool bIsLocked, string medalIcon){}
simulated function AS_SetFocus(int Index){}
simulated function AS_SetEditingButton(int Index, string Label, bool bEnabled){}
simulated function AS_SetEditingImage(string Image){}
simulated function AS_SetEditingHelp(string Help){}
simulated function AS_SetPowerInfo(int Index, string Desc, string img){}
simulated function AS_SetPowerButton(int Index, string Label){}
function RequestUserData(){}
function OnNameInputBoxClosed(string Text){}
simulated function OpenVirtualKeyboard(string titleStr, string defaultStr, optional int maxCharLimit){}
reliable client simulated function VirtualKeyboard_OnAccept(string userInput, bool bWasSuccessful){}
reliable client simulated function VirtualKeyboard_OnCancel(){}
function bool ShouldAcceptName(string strInput, int char_max){}
