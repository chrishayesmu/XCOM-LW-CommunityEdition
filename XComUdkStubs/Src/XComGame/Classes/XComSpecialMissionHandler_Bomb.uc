class XComSpecialMissionHandler_Bomb extends XComSpecialMissionHandler
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XComSpecialMissionHandler_Bomb extends CheckpointRecord
{
    var bool bAllNodesDeactivated;
    var bool bFindBombActive;
    var bool bApproachBombActive;
};

var array<SequenceObject> IntVariables;
var SeqVar_Int TimerVariable;
var int PreviousTimerValue;
var int TimerWatchVarHandle;
var bool bAllNodesDeactivated;
var bool bFindBombActive;
var bool bApproachBombActive;