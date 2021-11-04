class XComSpecialMissionHandler_ChrysHive extends XComSpecialMissionHandler;
//complete stub

struct CheckpointRecord_XComSpecialMissionHandler_ChrysHive extends CheckpointRecord
{
    var TriggerVolume kTheOne;
    var array<XGUnit> m_arrEnemiesSeen;
};

var TriggerVolume kVolume;
var TriggerVolume kTheOne;
var array<XGUnit> m_arrEnemiesSeen;

function Initialize(){}
function OnAlienTypeSeen(){}
function OnEnemySeen(){}
function Conflagrate(){}
function bool SkipAbortDialog(XGSquad kSquad){}

state InvestigateDistress{
    function SetObjectives(){}
}

state FindInfestation{
    function SetObjectives(){}
}
state ActivateBeacon
{
    function SetObjectives()
    {
    }
}
state RunLikeDickens
{
    function SetObjectives()
    {
    }
}
state NukeFromSpace
{
    function SetObjectives()
    {
    }
}
state Airstrike
{
    function BeginState(name PreviousStateName){}
    function SetObjectives(){}
}
state AllUnitsLost
{
}
