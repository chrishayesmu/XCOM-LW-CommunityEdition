class SeqAct_RespawnAlienPod extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="AlienName",PropertyName=AlienName,MaxVars=1)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="AlienPods",PropertyName=AlienPods)
    ObjName="Respawn Alien Pod"
}