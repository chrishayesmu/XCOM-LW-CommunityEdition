class SeqAct_TacticalMouseControls extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bDisablePreviousSoldier;
var() bool bDisableNextSoldier;
var() bool bDisableSoldierInfo;
var() bool bDisableEndTurn;
var() bool bDisableCameraRotate;

defaultproperties
{
    ObjName="Tactical Mouse HUD"
}