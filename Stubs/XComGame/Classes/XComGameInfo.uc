class XComGameInfo extends FrameworkGame
    native
    config(Game);
//complete stub

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

event InitGame(string Options, out string ErrorMessage){}
simulated function CacheMods(){}
simulated function ModStartMatch() {}
event GameEnding(){}
function RestartPlayer(Controller NewPlayer){}
native function bool GetSupportedGameTypes(const out string InFilename, out GameTypePrefix OutGameType, optional bool bCheckExt);
native function bool GetMapCommonPackageName(const out string InFilename, out string OutCommonPackageName);
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal){}
native function OnPostSeamlessTravel();
native static function string GetGameVersion();
function class<Pawn> GetDefaultPlayerClass(Controller C){}
event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage){}
event PostLogin(PlayerController NewPlayer){}

function Input_ConfirmAction();

function Input_CycleAction();

function string GetSavedGameDescription();

function string GetSavedGameCommand();
event GetSeamlessTravelActorList(bool bToTransitionMap, out array<Actor> ActorList){}
event PostSeamlessTravel(){}

simulated function XGTacticalGameCore TACTICAL(){}
simulated function TItemCard GetItemCard(){}
simulated event Destroyed(){}
function EndOnlineGame(){}
simulated function OnEndOnlineGameComplete(name SessionName, bool bWasSuccessful){}
simulated function DelayedEndOnlineGameComplete(name SessionName, bool bWasSuccessful){}
simulated function OnDestroyedOnlineGame(name SessionName, bool bWasSuccessful){}
event PreBeginPlay(){}
simulated event OnCleanupWorld(){}
