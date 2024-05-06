class SeqAct_GetTargetMesh extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="TargetObj",PropertyName=Targets)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="TargetMesh",PropertyName=TargetMesh,bWriteable=true)
    ObjName="Get Target Mesh"
}