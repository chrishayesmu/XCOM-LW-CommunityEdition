class XComConversationNode extends SoundNodeConcatenator
    native;
//complete stub

var(XCom) bool bMatineeContainsVoice;
var bool bModal;
var bool bFinished;
var bool bDialogLineFinished;
var(XCom) name MatineeToPlay;

simulated function Reset(bool bIsModal){}
event DialogLineFinished(){}
// Export UXComConversationNode::execGetCurrentDialogue(FFrame&, void* const)
native simulated function string GetCurrentDialogue(AudioComponent AudioComponent);

// Export UXComConversationNode::execGetCurrentDialogueDuration(FFrame&, void* const)
native simulated function float GetCurrentDialogueDuration(AudioComponent AudioComponent);

// Export UXComConversationNode::execGetCurrentSpeaker(FFrame&, void* const)
native simulated function SoundNodeWave.EXComSpeakerType GetCurrentSpeaker(AudioComponent AudioComponent);

// Export UXComConversationNode::execSkipToNextDialogueLine(FFrame&, void* const)
native simulated function SkipToNextDialogueLine(AudioComponent AudioComponent);

// Export UXComConversationNode::execGetFaceFxInfo(FFrame&, void* const)
native simulated function GetFaceFxInfo(AudioComponent AudioComponent, out FaceFXAnimSet FaceFXAnimSetRef, out string FaceFXGroupName, out string FaceFXAnimName);