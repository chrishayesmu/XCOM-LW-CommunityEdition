class XComTacticalHUD extends XComHUD
	transient
	config(Game)
	hidecategories(Navigation);
//complete stub

var array<XComBuildingVolume> m_arrBuildingVolumes;
var IMouseInteractionInterface mShootEnemyTrace;
var IMouseInteractionInterface m_InteractionInterface;

simulated event PostBeginPlay(){}
simulated function XCom3DCursor Get3DCursor(){}
function XComPawn GetPawnInSameTile(Vector vLocation){}
function bool IsPositionInPathableTile(Vector kPosition){}
function bool IsPointOutdoors(Vector vLocation){}
function IMouseInteractionInterface GetMousePickActor(){}
function IMouseInteractionInterface GetMousePickInterActor(){}
