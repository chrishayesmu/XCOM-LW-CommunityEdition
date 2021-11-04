class XGAIPlayerOvermindHandler extends Actor
    notplaceable
    hidecategories(Navigation)
dependson(XGOvermindActor);

struct CheckpointRecord
{
    var XGOvermind m_kOvermind;
    var bool bEnabled;
};

var XGOvermind m_kOvermind;
var array<XGPod> m_arrActivePod;
var array<XGManeuver> m_arrImmediateManeuver;
var XGPod m_kActivePod;
var int m_iActivePod;
var int m_iCurrUnit;
var XGManeuver m_kActiveManeuver;
var bool bEnabled;
var bool bInited;
var XGAIPlayer m_kPlayer;
var XGAction m_kPrimaryAction;
var array<XGUnit> m_arrDeferred;

function bool CheckAndUpdateCanDoOvermindUpdate(XGAction kAction){}
function OnActionComplete(XGAction kAction){}
simulated function Init(XGAIPlayer kPlayer){}
simulated function LoadInit(){}
simulated function InitOvermind(){}
simulated function InitTurn(){}
function EndTurn(){}
simulated function OnSpawn(int iSpawn, array<XGUnit> arrSpawns, optional bool bFromSpawnList=TRUE){}
function OnReveal(XGUnit kAlien, XGUnit kEnemy){}
function OnRevealComplete(array<XGUnit> arrAlien, XGUnit kEnemy, optional bool bActivated=TRUE){}
function OnMoveComplete(XGUnit kAlien, XGManeuver kManeuver, optional bool bSuccess=TRUE){}
function OnPodMoveComplete(XComAlienPod kPod, XGManeuver kManeuver){}
function OnSound(Vector vLoc, XGUnit kSourceUnit, optional bool bOnMove){}
function OnMimicBeacon(Vector vLoc){}
function OnManeuverComplete(XGUnit kAlien, XGManeuver kManeuver, optional bool bSuccess){}
simulated function InitMainUnitLoop(){}
simulated function UpdateImmediateManeuvers(){}
simulated function ClearImmediateManeuver(XGManeuver kManeuver){}
function bool IsWaitingOnImmediateManeuver(){}
function bool IsValidUnitToActivate(XGUnit kUnit, optional bool bDeferred=FALSE){}
function bool GetNextPodUnitToActivate(out XGUnit kUnit, const out XGPod kPod){}
simulated function XGUnit GetNextActiveUnit(){}
simulated function XGUnit GetNextActiveUnit_Deferred(){}
simulated function XGUnit GetNextActiveUnit_Internal(){}
function bool HasValidUnitsToActivate(XGPod kPod){}
function int FindActivePod(int iPodID){}
function ProcessOvermind(array<XGPod> arrPod){}
function InitManeuver(XGManeuver kManeuver, XGPod kPod){}
function bool AbilityMapsToManeuver(int iAbilityType, EManeuverType kType){}
function bool IsPointInUFO(Vector vPoint){}
function bool InitProcessOvermind(){}
function bool IsBusy(){}
function ClearImmediateManeuvers(){}
function SetDeferredUnit(XGUnit kUnit){}
