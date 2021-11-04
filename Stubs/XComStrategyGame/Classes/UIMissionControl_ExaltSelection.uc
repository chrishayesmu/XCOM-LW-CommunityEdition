class UIMissionControl_ExaltSelection extends UIMissionControl_AlertWithMultipleButtons
    hidecategories(Navigation);
//complete stub

var const localized string m_strConfirmLabel;
var const localized string m_strPanicLabel;
var int m_iOptionSelected;
var UIWidgetHelper m_hWidgetHelper;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UIMissionControl _screen){}
simulated function UpdateData(){}
simulated function OnReceiveFocus(){}
simulated function RefreshButtons(){}
simulated function CloseAlert(optional int inputCode){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
protected simulated function AS_SetHeaderLabels(string Title, string subtitle, string confirmLabel){}
protected simulated function AS_SetData(string countryName, string Description, int Type){}
protected simulated function AS_SetPanicLevel(string Label, int Level){}
