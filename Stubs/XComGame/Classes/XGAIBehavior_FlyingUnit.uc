class XGAIBehavior_FlyingUnit extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);
//complete stub

const MAX_TILE_HEIGHT = 10;
const MIN_TILE_HEIGHT = 3;

var int m_iFlightDuration;

function AddPriorityFlightDestinations(out array<XComCoverPoint> Points){}
simulated function int GetMaxFlightDuration(){}
simulated function bool IsGrounded(){}
simulated function DrawDebugLabel(Canvas kCanvas, out Vector vScreenPos){}
simulated function OnMoveComplete(){}
simulated function AddNearbyGroundTiles(out array<XComCoverPoint> arrDestList, int iTileRadius){}
simulated function InitFromPlayer(){}
simulated function bool HasPredeterminedAbility(){}
simulated function int GetPredeterminedAbility(){}
simulated function float GetMoveOffenseScore(){}
simulated function float GetMinEngageRange(){}
simulated function Vector GetPodRevealMoveToLocation(XGUnit kTarget){}
function float GetReasonableAttackRange(){}
function bool GetEngageLocation(out Vector vCover, XGUnit kEnemy, optional bool bOutOfRange, optional out string strFail){}
simulated function bool CanFly(){}
simulated function int ScoreLocation(ai_cover_score kScore, float fDistance){}