class SeqAct_GetExtractionVolume extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XComBuildingVolume ExtractionVolume;

defaultproperties
{
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="ExtractionVolume",PropertyName=ExtractionVolume,bWriteable=true)
    ObjName="Get Extraction Volume"
}