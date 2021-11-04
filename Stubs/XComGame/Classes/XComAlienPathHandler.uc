class XComAlienPathHandler extends Actor;

var XComAlienPod m_kPod;
var float m_fPathingDistancePerTurn;
var int m_iLastVisitedTerminal;
var int m_iLastNode;
var bool m_bPartialPath;
var bool m_bHasBegunTrippedPatrol;
var float m_fDistanceRemaining;
var array<XGUnit> m_arrTrippedUnit;
var int m_iNextVisibleNode;
var int m_iCurrInteraction;
var int m_iWaitCounter;
var float m_fDoorHangTimer;

function bool IsForwardBackwards(){}
simulated function ReversePath(){}
simulated function InitRoute(XComAlienPod kPod){}
simulated function OnTouchPath(XComUnitPawn kPawn){}
function ResetTripped(){}
function bool CanSeeUnitFromPath(){}
function bool IsDynamicPodMoving(){}
function IncrementPatrolNode(){}
function bool IsOpeningDoor(){}
function bool IsValidDoorNode(int iNode){}

function bool IsAtClosedDoor(){}
function OpenDoor(){}
function UpdateOpeningDoor(){}
function ContinueRoute(){}
function PatrolBegin(){}
function UpdateWaitTimer(){}
function bool IsWaitingAtNode(){}
static function bool IsBehindDoor(Vector vLoc, XComInteractiveLevelActor kDoor, Vector vRefPoint){}
function bool IsValidDoorDestination(XGUnit kUnit, Vector vDest, int iNode)
{}
function bool GetValidDoorDestination(XGUnit kUnit, out Vector vDest, int iNode)
{}
function PatrolToNextPoint()
{}
function bool UpdatePatrol()
{}
function AbortMovement()
{}
function string GetDebugLabel()
{}
function InitDynamicStartLocation()
{}
function int GetNodeBefore(int iNodeIdx)
{}
function PopAliensTo(int iNodeIdx)
{}
function InitTrippedPatrol()
{}
function WarpPodToNode(int iNode)
{}
