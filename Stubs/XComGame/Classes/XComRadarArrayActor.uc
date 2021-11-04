class XComRadarArrayActor extends XComInteractiveLevelActor
    native(Destruction)
    hidecategories(Navigation,XComInteractiveLevelActor);
//complete stub

struct CheckpointRecord_XComRadarArrayActor extends CheckpointRecord
{
    var bool m_bActive;
    var bool m_bWasEverActive;
    var bool m_bShowObjectiveVisuals;
    var bool m_bHasFiredOperativeNearbyRemoteEvent;
    var bool m_bHasFiredNonOperativeNearbyRemoteEvent;
};

var const name m_nOperativeActivatedRemoteEvent;
var const name m_nOperativeOperativeNearbyRemoteEvent;
var const name m_nOperativeNonOperativeNearbyRemoteEvent;
var export editinline ParticleSystemComponent m_kMarkerParticleComponent;
var export editinline ParticleSystemComponent m_kVFXParticleComponent;
var export editinline StaticMeshComponent m_kWaypointMeshComponent;
var bool m_bActive;
var bool m_bWasEverActive;
var bool m_bShowObjectiveVisuals;
var bool m_bHasFiredOperativeNearbyRemoteEvent;
var bool m_bHasFiredNonOperativeNearbyRemoteEvent;
var ParticleSystem m_kIdleParticleSystem;
var ParticleSystem m_kHackedParticleSystem;
var MaterialInstance m_kIdleMaterial;
var MaterialInstance m_kActiveMaterial;
var SoundCue m_kHackingCue;

native simulated function bool ShouldIgnoreForCover();

simulated function ActivateRadar(optional bool bShowObjectiveVisuals){}
simulated function UISpecialMissionHUD_Arrows GetArrowManager(){}
simulated function SetActive(bool bActive){}
simulated function OnExaltHackingArrayInteraction(XGUnit kUnit){}
simulated function bool Interact(XGUnit InUnit, name SocketName){}
simulated function ApplyDamageToMe(const out DamageEvent Dmg){};
simulated function FireRemoteEvent(name nEventName){}
simulated event PostBeginPlay(){}
function bool ShouldSaveForCheckpoint(){}
function ApplyCheckpointRecord(){}
simulated event Destroyed(){}

auto simulated state _Pristine
{
    simulated function bool CanInteract(XGUnit InUnit, name SocketName){}
}
