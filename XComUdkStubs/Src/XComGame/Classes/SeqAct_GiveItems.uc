class SeqAct_GiveItems extends SequenceAction
    dependson(XGGameData, XGInventoryNativeBase)
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;
var() EItemType eItemToGive;
var() ELocation ELocation;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    ObjName="Give Items"
}