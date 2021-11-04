class XGSightManager extends XGSightManagerNativeBase;
//complete stub

var transient bool CachedPositionsInitialized;
var transient array<Vector> CachedUnitPos;
var int m_iVisibleCacheTime;

simulated event ReplicatedEvent(name VarName){}
simulated function bool IsInitialReplicationComplete(){}
function Init(XGPlayer kPlayer){}
simulated function UpdateVisible(optional bool bLog, optional bool bIncremental=true){}
simulated function UpdateBuildingVisibility(){}
simulated function XGUnit CanSeeBuilding(XComBuildingVolume kBuildingVolume){}
simulated function UpdateAlienSenses(XGUnit kUnit, XGUnit kAlien, int iAlienIndex){}
simulated function AllEnemiesRevealed(bool bRevealed){}
simulated function bool IsVisibleEnemy(XGUnit kEnemy){}
simulated function GetAllVisibleTargets(XGTacticalGameCoreData.ETargetUnitType kType, out array<XGUnit> arrEnemies, out array<float> arrEnemiesDistSq, optional bool bCheckDistances, optional Vector vSourceLocation){}
simulated function bool IsCurrentlyVisible(Vector vLocation, optional XGUnit kEnemy){}
simulated function array<XGUnit> GetVisibleEnemies(XGUnit kViewer){}
