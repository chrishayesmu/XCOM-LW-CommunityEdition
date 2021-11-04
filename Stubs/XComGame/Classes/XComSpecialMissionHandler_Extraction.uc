class XComSpecialMissionHandler_Extraction extends XComSpecialMissionHandler
    notplaceable
    hidecategories(Navigation);
//complete stub

var bool bVIPPawnSet;
var SeqVar_Object VIPPawn;
var SeqVar_Object VIPUnit;

function Initialize(){}
function ExtractionPeriodicUpdate(){}

state LocateVIP
{
    function SetObjectives()
	{}
}
state ApproachVIP
{
    function SetObjectives()
	{}
}
state EscortVIP
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
state AllUnitsLost
{
    event BeginState(name PreviousStateName)
	{}
}
