class SeqAct_XComSetupUnitForMatinee extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XComHumanPawn UnitPawn1;
var XComHumanPawn UnitPawn2;
var XComHumanPawn UnitPawn3;
var XComHumanPawn UnitPawn4;
var() FaceFXAsset FaceFX;
var() bool bClearMove;
var() bool bDisableGenderBlender;

defaultproperties
{
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Prep")
    InputLinks(1)=(LinkDesc="Restore")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="UnitPawn1",PropertyName=UnitPawn1)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="UnitPawn2",PropertyName=UnitPawn2)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="UnitPawn3",PropertyName=UnitPawn3)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="UnitPawn4",PropertyName=UnitPawn4)
    ObjName="XCom Pawn to Matinee"
}