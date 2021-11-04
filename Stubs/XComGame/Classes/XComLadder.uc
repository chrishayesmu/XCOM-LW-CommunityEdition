class XComLadder extends XComLevelActor
    native(Level)
    hidecategories(Navigation);
//complete stub

enum ELadderType
{
    eLadderType_Ladder,
    eLadderType_Pipe,
    eLadderType_AirLift,
    eLadderType_MAX
};

var() int LoopAnimations;
var() deprecated float Depth;
var export editinline transient LineBatchComponent LineBatch;
var export editinline StaticMeshComponent StaticMesh;
var() ELadderType eType;
var export editinline ParticleSystemComponent AlienAirLiftPSC;
var ParticleSystem AlienAirLiftUpFX;
var ParticleSystem AlienAirLiftDownFX;

simulated event PostBeginPlay(){}
native simulated function float GetHeight();
simulated function bool IsAtBottom(float fHeight){}
simulated function GetPath(float fStartHeight, out Vector vUnitMoveBegin, out Vector vUnitMoveEnd){}
simulated function bool GetDistanceSqToClosestMoveToPoint(Vector vCenter, int iRadiusSq, int iMaxHeightDiff, out float fClosestDistance){}
simulated function GetMoveToPoint(Vector vCurrentLoc, out Vector vUnitMoveTo){}
