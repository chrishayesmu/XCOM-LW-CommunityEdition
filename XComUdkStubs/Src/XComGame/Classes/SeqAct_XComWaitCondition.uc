class SeqAct_XComWaitCondition extends SequenceAction
    abstract
    native(Level)
    editinlinenew
    forcescriptorder(true)
    hidecategories(Object);

var() bool bNot;

defaultproperties
{
    bCallHandler=false
    bLatentExecution=true
    bAutoActivateOutputLinks=false
    InputLinks(0)=(LinkDesc="Wait")
    InputLinks(1)=(LinkDesc="Abort")
    OutputLinks(0)=(LinkDesc="Finished")
    OutputLinks(1)=(LinkDesc="Aborted")
    VariableLinks.Empty()
    ObjName="Wait Condition"
}