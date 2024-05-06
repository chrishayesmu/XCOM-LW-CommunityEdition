class SeqAct_GetTargetUnit extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

defaultproperties
{
    bCallHandler=false
    bAutoActivateOutputLinks=false
    OutputLinks(0)=(LinkDesc="unknown")
    OutputLinks(1)=(LinkDesc="Floater")
    OutputLinks(2)=(LinkDesc="Sectoid")
    OutputLinks(3)=(LinkDesc="Soldier")
    OutputLinks(4)=(LinkDesc="Muton")
    OutputLinks(5)=(LinkDesc="Chryssalid")
    OutputLinks(6)=(LinkDesc="ThinMan")
    OutputLinks(7)=(LinkDesc="Elder")
    OutputLinks(8)=(LinkDesc="Sectopod")
    OutputLinks(9)=(LinkDesc="SectopodDrone")
    OutputLinks(10)=(LinkDesc="Zombie")
    OutputLinks(11)=(LinkDesc="Mechtoid")
    OutputLinks(12)=(LinkDesc="Seeker")
    OutputLinks(13)=(LinkDesc="ExaltOperative")
    OutputLinks(14)=(LinkDesc="ExaltSniper")
    OutputLinks(15)=(LinkDesc="ExaltHeavy")
    OutputLinks(16)=(LinkDesc="ExaltMedic")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="TargetUnit",PropertyName=Targets)
    ObjName="Get Target Unit"
}