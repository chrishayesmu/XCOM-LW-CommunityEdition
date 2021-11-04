class XComSpecialMissionHandler_Bomb extends XComSpecialMissionHandler
    notplaceable
    hidecategories(Navigation);
//complete stub

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

function Initialize(){}
function OnTimerChanged(){}

state FindBomb
{
    function SetObjectives(){}
}
state ApproachDefuseBomb
{
    function SetObjectives(){}
}
state AllNodesDefused
{
    function SetObjectives()
	{}
}
state killaliens
{
    function SetObjectives()
	{}
}
state ReportToEvac
{
    function SetObjectives()
	{}
}
state BombExploded
{
    event BeginState(name PreviousStateName)
	{}
}
state AllUnitsLost
{
}