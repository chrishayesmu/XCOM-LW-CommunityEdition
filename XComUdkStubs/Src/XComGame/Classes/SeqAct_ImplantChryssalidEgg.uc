class SeqAct_ImplantChryssalidEgg extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    InputLinks(0)=(LinkDesc="Implant")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Unit or Pawn",PropertyName=Targets)
    ObjName="Implant Chryssalid Egg"
}