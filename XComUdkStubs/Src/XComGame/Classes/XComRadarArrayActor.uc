class XComRadarArrayActor extends XComInteractiveLevelActor
    native(Destruction)
    hidecategories(Navigation,XComInteractiveLevelActor);

struct CheckpointRecord_XComRadarArrayActor extends CheckpointRecord
{
    var bool m_bActive;
    var bool m_bWasEverActive;
    var bool m_bShowObjectiveVisuals;
    var bool m_bHasFiredOperativeNearbyRemoteEvent;
    var bool m_bHasFiredNonOperativeNearbyRemoteEvent;
};

var() const name m_nOperativeActivatedRemoteEvent;
var() const name m_nOperativeOperativeNearbyRemoteEvent;
var() const name m_nOperativeNonOperativeNearbyRemoteEvent;
var export editinline ParticleSystemComponent m_kMarkerParticleComponent;
var export editinline ParticleSystemComponent m_kVFXParticleComponent;
var export editinline StaticMeshComponent m_kWaypointMeshComponent;
var privatewrite bool m_bActive;
var private bool m_bWasEverActive;
var private bool m_bShowObjectiveVisuals;
var private bool m_bHasFiredOperativeNearbyRemoteEvent;
var private bool m_bHasFiredNonOperativeNearbyRemoteEvent;
var private ParticleSystem m_kIdleParticleSystem;
var private ParticleSystem m_kHackedParticleSystem;
var private MaterialInstance m_kIdleMaterial;
var private MaterialInstance m_kActiveMaterial;
var private SoundCue m_kHackingCue;

defaultproperties
{
    InteractionPoints(0)=(SrcSocket=EInteractionSocket.XGBUTTON_01)
    InteractionPoints(1)=(SrcSocket=EInteractionSocket.XGBUTTON_02)
    InteractionPoints(2)=(SrcSocket=EInteractionSocket.XGBUTTON_03)
    InteractionPoints(3)=(SrcSocket=EInteractionSocket.XGBUTTON_04)
    IconSocket=XGBUTTON_Icon
    InteractionPrompt=Hack
    bMovable=true

    begin object name=SkeletalMeshComponent0
        SkeletalMesh=SkeletalMesh'HotButton.Meshes.HotButtonColumnLow'
        LightEnvironment=MyNEWLightEnvironment
    end object

    begin object name=StaticMeshComponent0
        LightEnvironment=MyNEWLightEnvironment
        bUsePrecomputedShadows=false
        LightingChannels=(Static=false)
    end object

    begin object name=ParticleSystemComponent0 class=ParticleSystemComponent
        HiddenGame=true
        Translation=(X=0.0,Y=0.0,Z=200.0)
        Scale=3.0
    end object

    m_kMarkerParticleComponent=ParticleSystemComponent0
    Components.Add(ParticleSystemComponent0)

    begin object name=ParticleSystemComponent1 class=ParticleSystemComponent
    end object

    m_kVFXParticleComponent=ParticleSystemComponent1
    Components.Add(ParticleSystemComponent1)

    begin object name=StaticMeshComponent1 class=StaticMeshComponent
        HiddenGame=true
        bAllowApproximateOcclusion=true
        Scale=2.0
    end object

    m_kWaypointMeshComponent=StaticMeshComponent1
    Components.Add(StaticMeshComponent1)
}