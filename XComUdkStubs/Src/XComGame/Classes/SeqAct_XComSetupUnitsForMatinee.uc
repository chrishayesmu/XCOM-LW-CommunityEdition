class SeqAct_XComSetupUnitsForMatinee extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() FaceFXAsset FaceFX;
var() bool bClearMove;
var() bool bDisableGenderBlender;

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Prep")
    InputLinks(1)=(LinkDesc="Restore")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Unit Pawns",PropertyName=Targets)
    ObjName="XCom Pawns to Matinee"
}