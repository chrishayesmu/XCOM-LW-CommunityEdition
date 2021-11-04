class XGAIBehavior_MutonBerserker extends XGAIBehavior_Muton
	notplaceable;
//complete  stub

struct bull_rush_point
{
    var Actor kWall;
    var XGUnit kTargetEnemy;
    var Vector vOuterLimit;
    var Vector vWallLoc;
    var array<Vector> arrMoveToLoc;
    var int iScore;
};

var array<bull_rush_point> m_arrBullRushPoints;
var bool m_bBullRushActive;
var bull_rush_point m_kActiveBRPoint;
var array<XGUnit> m_arrBullRushTarget;
var XGUnit m_kNearestEnemy;

simulated function InitFromPlayer()
{
}

simulated function PostBuildAbilities()
{
}

function bool GetBullRushRange(XGUnit kEnemy, out array<bull_rush_point> arrEndPoint, float fMaxMoveDist)
{
}

function bool FindNearestDestructible(XGUnit kTarget, out Actor kBest)
{
}

function bool AddTilePositionsBetween(const out Vector vSource, out bull_rush_point kBRPoint, out array<XComCoverPoint> Points)
{
}

function AddOtherPoints(out array<XComCoverPoint> Points, Vector vLoc)
{
}

simulated function int ScoreLocation(ai_cover_score kScore, float fDistance)
{
}

function SortBullRushPoints();

function bool GetEngageLocation(out Vector vCover, XGUnit kEnemy, optional bool bOutOfRange, optional out string strFail)
{
}

simulated function bool HasPredeterminedAbility()
{
}

simulated function int GetPredeterminedAbility()
{
}

simulated function XGUnit GetPredeterminedTarget()
{
}

simulated function InitPredeterminedAbility(XGAbility kAbility)
{
}

state IgnoreCoverMove
{
    simulated event BeginState(name P)
    {
    }  
}
