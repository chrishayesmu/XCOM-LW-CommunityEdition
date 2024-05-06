class XGAction_Targeting extends XGAction_Idle
    native(Action)
    notplaceable
    hidecategories(Navigation);

var const localized string m_strTargetNameEnemy;
var const localized string m_strTargetNameFriend;
var const localized string m_strTargetNameCivilian;
var const localized string m_sShotHasTarget;
var const localized string m_sShotHasTargets;
var protected XGUnit m_kInitialUnitTarget;
var XGUnit m_kFireOnlyAtThisUnit;
var bool m_bMustPerformAction;
var bool m_bTargetMustBeWithinCursorRange;
var bool m_bOnlyFireAtLocation;
var bool m_bResetTraceValues;
var bool m_bBullRushValid;
var bool m_bLastTileValid;
var bool m_bSetShotDisabled;
var bool m_bPleaseHitFriendlies;
var privatewrite bool m_bShotSetViaLocalPlayerInput;
var protected bool m_bShotIsBlocked;
var bool bClusterBombSetup;
var bool bClusterBombFiring;
var privatewrite bool m_bForceOverheadCamera;
var protected bool m_bUnitIsActive;
var protectedwrite bool m_bCanceled;
var bool bForceHit;
var bool bForceMiss;
var privatewrite bool m_bFired;
var float m_fAllowedCursorRange;
var Vector m_vFireOnlyAtThisLocation;
var ParticleSystem m_DiscPreview;
var transient XComEmitter ExplosionEmitter;
var transient DynamicSMActor_Spawnable VisualizerActor;
var transient EAbility ExplosionEmitterType;
var ParticleSystem m_blastPreview;
var array<XGUnit> m_arrInteractionList_Total;
var array<XGUnit> m_arrInteractionList_ConstrainedByAbilities;
var int m_iLastTileIndexTrace;
var Vector m_vTraceOrigin;
var Vector m_vTraceDir;
var privatewrite repnotify Vector m_vReplicatedBullRushHitNormal;
var Vector m_vSplashCenterCache;
var float m_fSplashRadiusCache;
var int m_iSplashHitsFriendliesCache;
var int m_iSplashHitsFriendlyDestructibleCache;
var private repnotify XGAbility_Targeted m_kReplicatedShot;
var XGUnit m_kTargetedEnemy;
var protected repnotify Vector m_vTarget;
var repnotify Actor TargetActor;
var XGAbility_Targeted m_kShot;
var XGCameraView m_kAimingView;
var protected Vector m_vHitLocation;
var private array<Actor> m_arrMarkedTargets;

defaultproperties
{
    m_iLastTileIndexTrace=-1
}