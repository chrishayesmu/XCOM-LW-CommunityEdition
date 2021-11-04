class XComIdleAnimationStateMachine extends Actor
    native
    notplaceable
    hidecategories(Navigation)
	dependsOn(XComWorldData);
//complete  stub

var XGUnit Unit;
var XGUnitNativeBase UnitNative;
var XComUnitPawn UnitPawn;
var XComUnitPawnNativeBase UnitPawnNative;
var float BlendTime;
var XComAnimNodeCover ActiveCoverNode;
var AnimNodeSequence FinishAnimNodeSequence;
var bool bWaitingForStanceEval;
var bool bDeferredGotoIdle;
var bool bDeferredGotoDormant;
var bool bInLatentTurn;
var bool bIsCivilian;
var bool bRestartIdle;
var bool bLoadInitStrangle;
var bool bForceDesiredCover;
var bool bForceTurnTarget;
var bool bIsExitFromCover;
var bool m_bRecenterAim;
var XGUnit LastAttacker;
var Vector TargetLocation;
var Actor TargetActor;
var Actor kDormantLock;
var float fIdleAnimRate;
var AnimNodeAdditiveBlending Idle_AdditiveBlend;
var AnimNodeBlendList Idle_AlienPresenceCheck;
var AnimNodeBlendList Idle_Flanked;
var XComAnimNodeStartLoopStop Peek_StartLoopStop;
var float PeekTimeout;
var float PeekDuration;
var float PeekTime;
var AnimNodeBlendList Flinch_NoCoverList;
var XComAnimNodeStartLoopStop Flinch_StartLoopStop;
var float FlinchDuration;
var float FlinchTime;
var float LastFlinchTime;
var float FlinchCooldownTime;
var XComAnimNodeBlendByPanic Panic_StartStop;
var AnimNodeBlendList Hunker_StartStop;
var name m_nmAnim;
var int DesiredCoverIndex;
var UnitPeekSide DesiredPeekSide;
var EExitCoverTypeToUse ExitCoverType;
var Vector TempFaceLocation;
var name ReturnToState;
var XComAnimNodeCover CoverNode;
var XComAnimNodeBlendByExitCoverType ExitCoverNode;
var int bSwitchSidesToExit;
var float ExitCoverAnimTimer;
var float ExitCoverAnimTime;
var XComAnimNodeAimOffset FireState_UseAimOffsetNode;
var AnimNodeBlendList FireState_StartLoopStop;
var float m_fAimTimer;
var Vector2D m_TmpAimOffset;
var float FireState_AimingTimeout;
var const AnimNodeSequence LatentSwitchSidesSeqNode;


function Initialize(XGUnit OwningUnit){}
function bool IsStateInterruptible(){}
function CheckForStanceUpdate(){}
function CheckForStanceUpdateOnIdle(){}
function ForceHeading(Vector DesiredRotationVector){}
function ForceStance(int ForceCoverIndex, UnitPeekSide ForcePeekSide){}
function bool IsEvaluatingStance(){}
simulated function bool IsDormant(){}
simulated function Resume(optional Actor UnlockResume=NONE){}
simulated function GoDormant(optional Actor LockResume=NONE, optional bool Force=FALSe, optional bool bDisableWaitingForEval=FALSE){}
function PerformPeek(){}
function PerformFlinch(){}
event bool SetTargetUnit(){}
simulated function ClearTargetInformation(){}
event GetDesiredCoverState(out int CoverIndex, out UnitPeekSide PeekSide){}
native latent function TurnTowardsPosition(const out Vector Position);
native latent function AnimateSwitchCoverSides(optional float Rate=1.0);
native function float GetNextIdleRate();

auto state Dormant{
    event BeginState(name P){}
	event EndState(name N){}
}

state Idle
{
	event Tick(float DeltaTime);
	event BeginState(name P){}
    event EndState(name N){}
    function SetAlienPresenceNode(AnimNodeBlendList Node){}
}

state Peek{
    event BeginState(name P){}
    event EndState(name N){};
    event Tick(float DeltaTime){}

}
state Flinch{
	    event BeginState(name P){}
    event EndState(name N){};
    event Tick(float DeltaTime){}

}
state Panicked{
	event Tick(float DeltaTime);
	event BeginState(name P){}
    event EndState(name N){}
}
state HunkeredDown{
	event Tick(float DeltaTime);
	event BeginState(name P){}
    event EndState(name N){}
}
state NeuralDampingStunned{
	event BeginState(name P){}
}
state EvaluateStance
{
	function bool UnitFacingMatchesDesiredDirection(){}    
	function EExitCoverTypeToUse GetExitCoverTypeToUse(const out Vector FaceLocation, out int bSwitchSidesNeeded){}
	simulated function bool FacingDesiredDirectionForExitCover(){}
    event BeginState(name P){}
    event EndState(name NextStateName){}
    simulated event Tick(float fDeltaT){}
}
simulated state Fire{
	event BeginState(name P);
    event EndState(name N);
	simulated event Tick(float DeltaTime){}
    simulated function SetupNodes(){}
}
state Strangled{
	event Tick(float DeltaTime);
	event BeginState(name P){}
    event EndState(name N){}

}
state Strangling{
	event Tick(float DeltaTime);
	event BeginState(name P){}
    event EndState(name N){}
}