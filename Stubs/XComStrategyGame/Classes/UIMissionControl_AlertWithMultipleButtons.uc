class UIMissionControl_AlertWithMultipleButtons extends UIMissionControl_AlertBase
    hidecategories(Navigation);

var int NUM_BUTTONS;
var int m_iSelectedBtn;

simulated function AS_SetButtonFocus(int buttonIndex, bool bFocus) {}
simulated function AS_SetButtonData(int buttonIndex, string Text, bool Disabled) {}
simulated function RealizeSelected(int newSelection) {}
simulated function UpdateButtonText() {}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateData() {}
simulated function OnInit() {}