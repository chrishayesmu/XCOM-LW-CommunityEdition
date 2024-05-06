class SeqAct_DisplayUIMessageBox extends SequenceAction
    native(Level)
    dependson(UIDialogueBox)
    forcescriptorder(true)
    hidecategories(Object);

enum UIMessageBoxInputType
{
    eUIInputMessageType_OK,
    eUIInputMessageType_OKCancel,
    eUIInputMessageType_MAX
};

var() UIDialogueBox.EUIDialogBoxDisplay DisplayType;
var() UIMessageBoxInputType InputType;
var() string Title;
var() string Message;
var() string imagePath;

simulated function OnComplete(EUIAction eAction)
{
    OutputLinks[1].bHasImpulse = true;
}

defaultproperties
{
    bCallHandler=false
    bLatentExecution=true
    bAutoActivateOutputLinks=false
    OutputLinks(0)=(LinkDesc="Out")
    OutputLinks(1)=(LinkDesc="Completed")
    VariableLinks.Empty()
    ObjName="UI Message Box Tutorial"
}