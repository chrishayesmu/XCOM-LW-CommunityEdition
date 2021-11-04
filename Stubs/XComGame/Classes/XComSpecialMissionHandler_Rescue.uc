class XComSpecialMissionHandler_Rescue extends XComSpecialMissionHandler
    notplaceable
    hidecategories(Navigation);
//complete stub

var bool bVIPPawnSet;
var SeqVar_Object VIPPawn;
var SeqVar_Object VIPUnit;

function Initialize(){}
function RescuePeriodicUpdate(){}

state EscortVIP
{
    function SetObjectives(){}
}
state killaliens
{
    function SetObjectives(){}
}
state ReportToEvac
{
    function SetObjectives(){}
}
state AllUnitsLost
{
    event BeginState(name PreviousStateName){}
}
