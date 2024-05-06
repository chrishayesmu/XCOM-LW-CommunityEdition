class SeqAct_WaitForLevelVisible extends SeqAct_Latent
    native(Level)
    forcescriptorder(true)
    hidecategories(Object);

var string LevelNameString;
var name LevelName;
var() bool bShouldBlockOnLoad;

defaultproperties
{
    bShouldBlockOnLoad=true
    InputLinks(0)=(LinkDesc="Wait")
    OutputLinks(0)=(LinkDesc="Finished")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_String',LinkDesc="Level Name",PropertyName=LevelNameString)
    ObjName="Wait for a level to be visible"
}