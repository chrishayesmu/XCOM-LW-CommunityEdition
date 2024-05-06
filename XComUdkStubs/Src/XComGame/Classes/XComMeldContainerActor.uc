class XComMeldContainerActor extends XComFriendlyDestructibleSkeletalMeshActor
    native(Destruction)
    config(GameData)
    hidecategories(Navigation)
    implements(XComInteractiveLevelActorInteractionHandler);

enum EMeldInteractionAnim
{
    eMeld_Idle,
    eMeld_Crush,
    eMeld_CrushedState,
    eMeld_Open,
    eMeld_OpenState,
    eMeld_MAX
};

struct CheckpointRecord_XComMeldContainerActor extends CheckpointRecord
{
    var XComMeldContainerSpawnPoint m_kSpawnPoint;
    var bool m_bHasBeenSeen;
    var bool m_bCollected;
    var bool m_bPerceivedLastTurn;
    var int m_iTurnsUntilDestroyed;
    var EMeldInteractionAnim m_eLastInteractionAnim;
};

var const config int m_iMeldAwardedPerContainer;
var private XComInteractiveLevelActor m_kInteractiveLevelActor;
var private export editinline AudioComponent m_kLoopCueComponent;
var privatewrite XComMeldContainerSpawnPoint m_kSpawnPoint;
var privatewrite bool m_bHasBeenSeen;
var privatewrite bool m_bVisibleToSquad;
var privatewrite bool m_bCollected;
var private bool m_bPerceivedLastTurn;
var privatewrite int m_iTurnsUntilDestroyed;
var private int m_iVictoryResultChangeWatchHandle;
var const localized string m_strMeldCollectedFlyoverText;
var() private SoundCue m_kLoopFastCue;
var() private SoundCue m_kLoopMediumCue;
var() private SoundCue m_kLoopSlowCue;
var() private SoundCue m_kMeldBreakCue;
var() private SoundCue m_kPowerDownCue;
var() private name AnimNodeName;
var private transient AnimNodeBlendList AnimNode;
var private EMeldInteractionAnim m_eLastInteractionAnim;

defaultproperties
{
    bTickIsDisabled=false
    bCanStepUpOn=false
    bMovable=true

    begin object name=MyNEWLightEnvironment
        bCastShadows=true
        bForceCompositeAllLights=true
        MaxModulatedShadowColor=(R=0.40,G=0.40,B=0.40,A=1.0)
        bEnabled=true
        bUseBiasedSubjectMatrix=true
    end object

    begin object name=StaticMeshComponent0
        bUsePrecomputedShadows=false
        LightingChannels=(Static=false)
    end object

    begin object name=CylinderComponent0 class=CylinderComponent
        CollisionHeight=128.0
        CollisionRadius=32.0
        HiddenGame=false
        CollideActors=true
        BlockActors=true
    end object

    CollisionComponent=CylinderComponent0
    Components.Add(CylinderComponent0)
}