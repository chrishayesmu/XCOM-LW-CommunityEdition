class SeqAct_EnableButtons extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bAllButtons;
var() bool AButton;
var() bool BButton;
var() bool XButton;
var() bool YButton;
var() bool LTrigger;
var() bool RTrigger;
var() bool LBumper;
var() bool RBumper;
var() bool L3;
var() bool R3;
var() bool DPadButton;
var() bool DPadUp;
var() bool DPadDown;
var() bool DPadLeft;
var() bool DPadRight;
var() bool Select;
var() bool Start;
var() bool MouseDoubleclick;

defaultproperties
{
    VariableLinks.Empty()
    ObjName="Enable Buttons"
}