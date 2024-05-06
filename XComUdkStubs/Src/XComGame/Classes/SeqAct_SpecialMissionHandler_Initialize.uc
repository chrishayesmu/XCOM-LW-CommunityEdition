class SeqAct_SpecialMissionHandler_Initialize extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

enum HandlerType
{
    eSpecialMissionExtraction,
    eSpecialMissionRescue,
    eSpecialMissionBomb,
    eSpecialMissionTempleship,
    eSpecialMissionChrysHive,
    eSpecialMissionHQAssault,
    eSpecialMissionDataRecovery,
    HandlerType_MAX
};

var() HandlerType SpecialMissionHandlerType;

defaultproperties
{
    ObjName="Special Mission Handler Initialize"
}