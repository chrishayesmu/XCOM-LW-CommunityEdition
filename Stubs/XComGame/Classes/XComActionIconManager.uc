class XComActionIconManager extends Actor
    native(Level);
//complete  stub

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
    var EFlankingCoverStatus FlankingCoverStatus;
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
var transient EFlankingCoverStatus FlankingCoverStatus;
var private transient FlankingCoverCheckValues LastFlankingCoverChecks;

native function ShowIcons(const bool bShow);

// Export UXComActionIconManager::execAddInteractIconsForUnit(FFrame&, void* const)
native function AddInteractIconsForUnit(XGUnitNativeBase Unit, bool bOnlyIfOwnedByLocalPlayer);

// Export UXComActionIconManager::execClearInteractIcons(FFrame&, void* const)
native function ClearInteractIcons();

// Export UXComActionIconManager::execUpdateCursorLocation(FFrame&, void* const)
native function UpdateCursorLocation(const out Vector cursorLocation, const optional bool bForceRefresh);

// Export UXComActionIconManager::execHighlightCoverLocation(FFrame&, void* const)
native function HighlightCoverLocation(const out Vector HighlightLocation);

// Export UXComActionIconManager::execClearHighlightedCoverLocation(FFrame&, void* const)
native function ClearHighlightedCoverLocation();

// Export UXComActionIconManager::execClearCoverIcons(FFrame&, void* const)
native function ClearCoverIcons();

// Export UXComActionIconManager::execAddFlankingIcons(FFrame&, void* const)
native function bool AddFlankingIcons(const optional bool bShowClosestOnly);

// Export UXComActionIconManager::execClearFlankingCoverIcons(FFrame&, void* const)
native function ClearFlankingCoverIcons(const optional bool bEndPathing);

event bool IsLocationFlanked(const out XComCoverPoint CoverPoint){}
event GetVisibleTargets(out array<XGUnit> Enemies){}
event bool IsLocationFlanking(const XGUnitNativeBase PlayerUnit, const XComCoverPoint CoverPoint, optional array<XGUnit> Enemies){}
simulated function RedrawFlankingIcons(){}

defaultproperties
{
	//setting to 'none' just to make compiler build references
    HighCoverMesh=none
    LowCoverMesh=none
    CoverIconHighlightSound=none
    DoorIconMesh=none
}