class SeqAct_GetValidCameras extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    bCallHandler=false
    OutputLinks(0)=(LinkDesc="pass")
    OutputLinks(1)=(LinkDesc="fail")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="ActingUnit",PropertyName=Targets)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="DummyTarget")
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_ObjectList',LinkDesc="TestLocationList")
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_ObjectList',LinkDesc="TestCameraList")
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_ObjectList',LinkDesc="ValidCameraList",bWriteable=true)
    ObjName="Get Valid Cameras"
}