class XGAIBehavior_Civilian extends XGAIBehavior
    native(AI)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum ETerrorStatus
{
    eTS_InDanger,
    eTS_Saved,
    eTS_Dead,
    eTS_MAX
};

struct CheckpointRecord_XGAIBehavior_Civilian extends CheckpointRecord
{
    var XGAIBehavior_Civilian.ETerrorStatus m_eTerrorStatus;
    var bool m_bDrawProximityRing;
};

var bool m_bRunToDropship;
var bool m_bIsAtDropship;
var bool m_bDrawProximityRing;
var int m_iMoveTimeStart;
var ETerrorStatus m_eTerrorStatus;

simulated function CheckForDropshipLocation(){}
simulated function bool CivilianFleeValidator(Vector vLocation){}
simulated function Vector GetDropshipLocation(){}
simulated function array<XComCoverPoint> GetValidDestinations(optional bool bIgnoreTeamDestinations, optional bool bDecreasingDistanceSort){}
simulated function InitTurn(){}
simulated function bool IsBehaviorDefined(){}
function bool IsBetterLocation(Vector vNewLoc, XComCoverPoint kNewCover){}
simulated function LoadInit(XGUnit kUnit){}
simulated function OnDeath(XGUnit kKiller){}
simulated function OnMoveComplete(){}
simulated function RunToDropship(){}
simulated function SetDefaultBehavior(){}
simulated function bool ShouldDrawProximityRing(){}
simulated function bool ShouldFlee(){}
simulated event Tick(float fDeltaT){}
function WarpToDropship(){}
