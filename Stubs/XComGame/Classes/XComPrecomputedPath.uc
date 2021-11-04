class XComPrecomputedPath extends Actor
    native(Weapon)
    config(GameCore)
    notplaceable
    hidecategories(Navigation);
//complete stub

const MAXPRECOMPUTEDPATHKEYFRAMES = 128;
const PATHSTARTTIME = 1.0f;
const PATHMAXTIME = 2.5f;
const MAX_CB_OFFSET = 192.0f;

struct native XKeyframe
{
    var float fTime;
    var Vector vLoc;
    var Rotator rRot;
    var bool bValid;

};


var repnotify XKeyframe akKeyframesReplicated[128];
var XKeyframe akKeyframes[128];
var repnotify int iNumKeyframesReplicated;
var int iNumKeyframes;
var bool bAllValidKeyframeDataReplicated;
var bool bEnableTick;
var bool bSplineDirty;
var bool bOnlyDrawIfFriendlyToLocalPlayer;
var bool m_bValid;
var bool m_bBlasterBomb;
var int iLastExtractedKeyframe;
var InterpCurveVector kSplineInfo;
var float fEmitterTimeStep;
var XComWeapon kCurrentWeapon;
var export editinline XComRenderablePathComponent kRenderablePath;
var const string PathingRibbonMaterialName;
var repnotify ETeam eComputePathForTeam;
var float m_fTime;
var config float BlasterBombSpeed;

// Export UXComPrecomputedPath::execUpdateWeaponProjectilePhysics(FFrame&, void* const)
native function UpdateWeaponProjectilePhysics(XComWeapon kWeapon, float dt);

// Export UXComPrecomputedPath::execBuildSpline(FFrame&, void* const)
native simulated function BuildSpline();

// Export UXComPrecomputedPath::execSetEmitterTimeStep(FFrame&, void* const)
native simulated function SetEmitterTimeStep(float fTimeStep);

simulated event PostBeginPlay(){}
simulated function string ToString(){}
function AddKeyframe(float fTime, Vector vLoc, Rotator rRot){}
function bool ShouldAddKeyframe(Vector vLoc, Rotator rRot){}
simulated function ActivatePath(XComWeapon kWeapon, ETeam eForTeam){}
function InvalidateKeyframes(){}
simulated function Vector GetEndPosition(){}
function SetWeapon(XComWeapon kWeapon, ETeam eForTeam){}
simulated function XKeyframe ExtractInterpolatedKeyframe(float fTime){}
simulated function bool MoveAlongPath(float fTime, Actor pActor){}
simulated function ClearPathGraphics(){}
simulated function DrawPath(){}
simulated function InitializeEmitter(){}
simulated function bool FindGround(out float fZ, Vector vLoc){}
simulated event Tick(float DeltaTime){}
// Export UXComPrecomputedPath::execCalculateBlasterBombTrajectoryToTarget(FFrame&, void* const)
native simulated function CalculateBlasterBombTrajectoryToTarget();

// Export UXComPrecomputedPath::execCalculateTrajectoryToTarget(FFrame&, void* const)
native simulated function CalculateTrajectoryToTarget(optional float fInitialTime=1.0, optional float fMaxTime=2.5);

simulated event ReplicatedEvent(name VarName){}
simulated function CopyReplicatedKeyframesToLocal(){}
