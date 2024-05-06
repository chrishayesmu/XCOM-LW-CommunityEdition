class SeqAct_SetMaterialOnHumanPawn extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

enum MeshEnum
{
    eMeshEnum_Body,
    eMeshEnum_Head,
    eMeshEnum_Hair,
    eMeshEnum_MAX
};

var() MaterialInterface NewMaterial;
var() int MaterialIndex;
var() MeshEnum MeshToSet;
var() bool bSetCustomizationParameters;

defaultproperties
{
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="TargetPawns",PropertyName=Targets,bModifiesLinkedObject=true)
    ObjName="Set Material On Human Pawn"
}