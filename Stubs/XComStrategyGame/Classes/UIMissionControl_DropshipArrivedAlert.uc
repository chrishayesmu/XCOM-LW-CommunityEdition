class UIMissionControl_DropshipArrivedAlert extends UIMissionControl_AlertBase;
//complete stub

const NUM_BUTTONS = 2;

var int m_iSelectedBtn;

simulated function OnInit(){}
simulated function UpdateButtonText(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function RealizeSelected(int newSelection){}
simulated function AS_SetButtonFocus(int buttonIndex, bool bFocus){}
simulated function AS_SetButtonData(int buttonIndex, string Text, bool Disabled){}
