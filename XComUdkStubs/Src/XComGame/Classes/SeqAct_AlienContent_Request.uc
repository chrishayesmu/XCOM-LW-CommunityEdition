class SeqAct_AlienContent_Request extends SequenceAction
    dependson(XGGameData)
    forcescriptorder(true)
    hidecategories(Object);

var() EPawnType ContentType;

defaultproperties
{
    bCallHandler=false
    bAutoActivateOutputLinks=false
    OutputLinks(0)=(LinkDesc="Out")
    OutputLinks(1)=(LinkDesc="Completed")
    VariableLinks.Empty()
    ObjName="Request Alien Content"
}