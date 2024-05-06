class SeqAct_TeleportWithAim extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() bool bRotateToWeaponAim;
var() bool bUseHeightOfLowestCollision;
var() bool bRotateToUnitFacing;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target",PropertyName=Targets)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Destination")
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="AimingAt")
    ObjName="Teleport With Aim"
}