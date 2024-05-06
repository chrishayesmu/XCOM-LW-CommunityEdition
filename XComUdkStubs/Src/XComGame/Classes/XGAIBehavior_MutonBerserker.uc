class XGAIBehavior_MutonBerserker extends XGAIBehavior_Muton
    notplaceable
    hidecategories(Navigation);

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