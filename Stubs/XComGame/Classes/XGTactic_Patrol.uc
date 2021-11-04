class XGTactic_Patrol extends XGTactic
    notplaceable
    hidecategories(Navigation);
//complete stub

const OVERMIND_PATROL_PADDING = 144.0f;

struct CheckpointRecord_XGTactic_Patrol extends CheckpointRecord
{
    var int m_iBuilding;
    var TRect m_kPatrolRect;
    var bool m_bHorizontal;
    var bool m_bDirectionToggle;
};

var int m_iBuilding;
var TRect m_kPatrolRect;
var bool m_bHorizontal;
var bool m_bDirectionToggle;

function bool InitPatrol(XGPod kPod, EPodTactic eTactic){}
function bool InitBuildingPatrol(XGPod kPod, EPodTactic eTactic, int iBuildingVolume){}
function XGManeuver GetNextManeuver(){}
function bool IsComplete(){}
function bool BuildPatrolRect(optional int iBuilding = -1){}
function bool IsPatrollingBehindUFO(TRect kPatrolRect){}
function float GetClosestCorner(TRect kRect, Vector vPoint){}
function TRect GetPatrolAroundUFO(){}
function TRect BuildCapitalUFOPatrolRect(int iBuildingIndex){}
function Vector GetPatrolTopLeft(){}
function Vector GetPatrolTopRight(){}
function Vector GetPatrolBottomLeft(){}
function Vector GetPatrolBottomRight(){}
function AddPatrolCycle(){}
function bool HasBeenPassed(float fEnemyParameter){}
function float CalcParameter(){}
function EPodAnimation GetPodAnim(){}

defaultproperties
{
    m_strName="PATROL"
}