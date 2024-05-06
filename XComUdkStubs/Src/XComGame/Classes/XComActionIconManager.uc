class XComActionIconManager extends Actor
    native(Level)
    notplaceable
    hidecategories(Navigation);

const ACTION_ICON_POOL_SIZE = 32;

enum EFlankingCoverStatus
{
    eFlankingCover_All,
    eFlankingCover_Closest,
    eFlankingCover_MAX
};

struct native IconPoolEntry
{
    var export editinline StaticMeshComponent Component;
    var float FadeInTime;
    var float FadeDir;
    var bool bActive;
};

struct native CoverIcon extends IconPoolEntry
{
    var MaterialInstanceConstant HighCoverMaterial;
    var MaterialInstanceConstant LowCoverMaterial;
    var MaterialInstanceConstant ActiveMaterial;
    var bool bHighlighted;
    var bool bFlanking;
};

struct native InteractiveIcon extends IconPoolEntry
{
};

struct native FlankingCoverCheckValues
{
    var XGUnitNativeBase FlankingUnit;
    var Vector UnitPosition;
    var bool FlankingIconsEnabled;
    var bool FlankingIconsShown;
    var XComActionIconManager.EFlankingCoverStatus FlankingCoverStatus;
    var bool DashingStatus;
};

var transient CoverIcon CoverIconPool[32];
var native transient MultiMap_Mirror ActiveCoverIcons;
var native transient MultiMap_Mirror ActiveFlankingCoverIcons;
var const StaticMesh HighCoverMesh;
var const StaticMesh LowCoverMesh;
var const LinearColor NormalColor;
var const LinearColor FlankedColor;
var const LinearColor DisabledColor;
var const LinearColor FlankingEnemyColor;
var const SoundCue CoverIconHighlightSound;
var transient InteractiveIcon InteractiveIconPool[32];
var const StaticMesh DoorIconMesh;
var transient bool HiddenForSS;
var transient bool bTutorialCoverLogic;
var transient bool FlankingIconsEnabled;
var transient bool FlankingIconsShown;
var transient float TutorialCoverRadius;
var transient XComActionIconManager.EFlankingCoverStatus FlankingCoverStatus;
var private transient FlankingCoverCheckValues LastFlankingCoverChecks;

defaultproperties
{
    HighCoverMesh=StaticMesh'UI_Cover.Editor_Meshes.Game_CoverHigh'
    LowCoverMesh=StaticMesh'UI_Cover.Editor_Meshes.Game_CoverLow'
    NormalColor=(R=0.929410,G=0.90980,B=0.403920,A=1.0)
    FlankedColor=(R=0.0006380,G=0.0006380,B=0.6253450,A=1.0)
    DisabledColor=(R=0.20,G=0.20,B=0.20,A=1.0)
    FlankingEnemyColor=(R=0.0,G=1.0,B=0.0,A=1.0)
    CoverIconHighlightSound=SoundCue'SoundUI.CoverHighlightCue'
    DoorIconMesh=StaticMesh'UI_Door01.Meshes.ASE_UI_Door01'
    TutorialCoverRadius=96.0
    CollisionType=COLLIDE_NoCollision
}