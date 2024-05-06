class XComGameInfo extends FrameworkGame
    abstract
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var Class TacticalSaveGameClass;
var Class StrategySaveGameClass;
var Class TransportSaveGameClass;
var config array<config string> ModNames;
var array<XComMod> Mods;
var array<string> PawnAnimSetNames;
var array<AnimSet> PawnAnimSets;
var(HQ) string PawnAnimTreeName;
var(HQ) AnimTree PawnAnimTree;
var(HQ) string InterceptorMeshName;
var(HQ) string FirestormMeshName;
var(HQ) string InterceptorAnimSetName;
var(HQ) string FirestormAnimSetName;
var(HQ) array<string> JetWeaponMeshNames;
var(HQ) array<string> PerkContentNames;
var(HQ) SkeletalMesh InterceptorMesh;
var(HQ) SkeletalMesh FirestormMesh;
var(HQ) AnimSet InterceptorAnimSet;
var(HQ) AnimSet FirestormAnimSet;
var(HQ) array<StaticMesh> JetWeaponMeshes;
var(HQ) array<XComPerkContent> PerkContents;
var(HQ) array<string> DressMedalNames;
var(HQ) array<SkeletalMesh> DressMedalMeshes;
var(HQ) string MECAnimSetHQName;
var(HQ) AnimSet MECAnimSetHQ;
var(HQ) string MECAnimTreeHQName;
var(HQ) AnimTree MECAnimTreeHQ;
var(HQ) string MECCivvieAnimTreeHQName;
var(HQ) AnimTree MECCivvieAnimTreeHQ;
var(HQ) string EmptyMECViewerAnimTreeHQName;
var(HQ) AnimTree EmptyMECViewerAnimTreeHQ;
var(HQ) string MECPreviewMaterialName;
var(HQ) Material MECPreviewMaterialHQ;
var(HQ) string XRayFemaleMeshName;
var(HQ) SkeletalMesh XRayFemaleMesh;
var(HQ) string XRayMaleMeshName;
var(HQ) SkeletalMesh XRayMaleMesh;

defaultproperties
{
    TacticalSaveGameClass=class'Checkpoint_TacticalGame'
    TransportSaveGameClass=class'Checkpoint_StrategyTransport'
    bRestartLevel=false
    DefaultPawnClass=class'XCom3DCursor'
    HUDType=class'XComHUD'
    PlayerControllerClass=class'XComTacticalController'
    PlayerReplicationInfoClass=class'XComPlayerReplicationInfo'
    GameReplicationInfoClass=class'XComGameReplicationInfo'
}