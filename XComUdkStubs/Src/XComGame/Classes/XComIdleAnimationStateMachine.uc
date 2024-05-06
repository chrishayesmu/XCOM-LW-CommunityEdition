class XComIdleAnimationStateMachine extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var private XGUnit Unit;
var private XGUnitNativeBase UnitNative;
var private XComUnitPawn UnitPawn;
var private XComUnitPawnNativeBase UnitPawnNative;
var privatewrite float BlendTime;
var private XComAnimNodeCover ActiveCoverNode;
var private AnimNodeSequence FinishAnimNodeSequence;
var private bool bWaitingForStanceEval;
var private bool bDeferredGotoIdle;
var private bool bDeferredGotoDormant;
var private bool bInLatentTurn;
var private bool bIsCivilian;
var private bool bRestartIdle;
var bool bLoadInitStrangle;
var private bool bForceDesiredCover;
var private bool bForceTurnTarget;
var private bool bIsExitFromCover;
var private bool m_bRecenterAim;
var private XGUnit LastAttacker;
var private Vector TargetLocation;
var private Actor TargetActor;
var private Actor kDormantLock;
var private float fIdleAnimRate;
var private AnimNodeAdditiveBlending Idle_AdditiveBlend;
var private AnimNodeBlendList Idle_AlienPresenceCheck;
var private AnimNodeBlendList Idle_Flanked;
var private XComAnimNodeStartLoopStop Peek_StartLoopStop;
var private float PeekTimeout;
var private float PeekDuration;
var private float PeekTime;
var private AnimNodeBlendList Flinch_NoCoverList;
var private XComAnimNodeStartLoopStop Flinch_StartLoopStop;
var private float FlinchDuration;
var private float FlinchTime;
var private float LastFlinchTime;
var private float FlinchCooldownTime;
var private XComAnimNodeBlendByPanic Panic_StartStop;
var private AnimNodeBlendList Hunker_StartStop;
var private name m_nmAnim;
var private int DesiredCoverIndex;
var private UnitPeekSide DesiredPeekSide;
var private XComAnimNodeBlendByExitCoverType.EExitCoverTypeToUse ExitCoverType;
var private Vector TempFaceLocation;
var private name ReturnToState;
var private XComAnimNodeCover CoverNode;
var private XComAnimNodeBlendByExitCoverType ExitCoverNode;
var private int bSwitchSidesToExit;
var private float ExitCoverAnimTimer;
var private float ExitCoverAnimTime;
var private XComAnimNodeAimOffset FireState_UseAimOffsetNode;
var private AnimNodeBlendList FireState_StartLoopStop;
var private float m_fAimTimer;
var private Vector2D m_TmpAimOffset;
var private float FireState_AimingTimeout;
var private const AnimNodeSequence LatentSwitchSidesSeqNode;

defaultproperties
{
    BlendTime=0.250
    PeekTimeout=2.0
    PeekDuration=2.50
    FlinchDuration=1.50
    FlinchCooldownTime=3.0
}