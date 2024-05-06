class SeqAct_PlayNextDialogueLine extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var Actor FaceFxTarget;

defaultproperties
{
    InputLinks(0)=(LinkDesc="Play")
    OutputLinks=none
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="FaceFxTarget",PropertyName=FaceFxTarget)
    ObjName="PlayNextDialogueLine"
}