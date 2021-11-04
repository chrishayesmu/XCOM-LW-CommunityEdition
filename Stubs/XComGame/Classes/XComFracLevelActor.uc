class XComFracLevelActor extends FracturedStaticMeshActor
    native(Level)
    hidecategories(Navigation)
    implements(XComCoverInterface,Destructible,IMouseInteractionInterface)
	dependson (XGGameData)
	dependson(XComLevelActor);
//complete stub

struct native FracturedHitInfo
{
    var Class DamageType;
    var Vector HitDirection;
    var Vector HitOrigin;
    var bool IsExplosion;
    var int Damage;
};

struct native FragmentCacheEntry
{
    var() int FragIndex;
    var() float MinZ;
    var deprecated float MaxZ;
};

struct native DestructibleCacheEntry
{
    var() XComDestructibleActor DestructibleActor;
    var() float MinZ;
};

struct native FracActorCacheEntry
{
    var() XComFracLevelActor FracActor;
    var() int ColumnIndex;
};

struct native FragmentColumn
{
    var() Box Bounds;
    var() init array<init FragmentCacheEntry> FragCache;
    var() init array<init DestructibleCacheEntry> DestructibleCache;
    var() init array<init FracActorCacheEntry> FracActorCache;
    var bool bCoverDebrisPlaced;
    var transient bool bDamaged;
    var transient bool bDestroyed;
};

struct CheckpointRecord
{
    var array<int> SavedVisibleFragments;
    var init array<init FragmentColumn> FragmentColumns;
};

//var private native const noexport Pointer VfTable_IXComCoverInterface;
//var private native const noexport Pointer VfTable_IDestructible;
var() const editconst export editinline XComFloorComponent FloorComponent;
var() const bool HideableWhenBlockingObjectOfInterest;
var() const bool bIgnoreFor3DCursorCollision;
var() bool bAlwaysFracture;
var() bool bAlwaysDestroyColumns;
var(Cover) bool bAlwaysConsiderForCover;
var(Cover) bool bCanClimbOver;
var(Cover) bool bCanClimbOnto;
var(Cover) bool bIsValidDestination;
var(Cover) bool bIgnoreForCover;
var(Cover) bool bUseRigidBodyCollisionForCover;
var(Pathing) bool bIsFloor;
var transient bool bNeedsDamageResolution;
var() VisibilityBlocking VisibilityBlockingData;
var() LinearColor TintColor;
var() Actor HidingPartner;
var(Cover) ECoverForceFlag CoverForceFlag;
var(Cover) ECoverForceFlag CoverIgnoreFlag;
var() EMaterialType ImpactMaterialType;
var Box LastFilterBox;
var() XComDestructibleActor_Toughness Toughness;
var init array<init int> SavedVisibleFragments;
var transient FracturedHitInfo LastHitInfo;
var init array<init FragmentColumn> FragmentColumns;
var() XComFracLevelActorImpactDefinition ImpactEffectsDefinition;
var() EmitterInstanceParameterSet ImpactInstanceParameters;

function bool ShouldSaveForCheckpoint(){}
function CreateCheckpointRecord(){}
function ApplyCheckpointRecord(){}
// Export UXComFracLevelActor::execBreakOffIsolatedIslands(FFrame&, void* const)
native simulated event BreakOffIsolatedIslands(out array<int> FragmentVis, array<int> IgnoreFrags, Vector ChunkDir, array<FracturedStaticMeshPart> DisableCollWithPart, bool bWantPhysChunks);

// Export UXComFracLevelActor::execConsiderForOccupancy(FFrame&, void* const)
native simulated function bool ConsiderForOccupancy();

// Export UXComFracLevelActor::execShouldIgnoreForCover(FFrame&, void* const)
native simulated function bool ShouldIgnoreForCover();

// Export UXComFracLevelActor::execCanClimbOver(FFrame&, void* const)
native simulated function bool CanClimbOver();

// Export UXComFracLevelActor::execCanClimbOnto(FFrame&, void* const)
native simulated function bool CanClimbOnto();

// Export UXComFracLevelActor::execUseRigidBodyCollisionForCover(FFrame&, void* const)
native simulated function bool UseRigidBodyCollisionForCover();

// Export UXComFracLevelActor::execGetCoverForceFlag(FFrame&, void* const)
native simulated function XComCoverInterface.ECoverForceFlag GetCoverForceFlag();

// Export UXComFracLevelActor::execGetCoverIgnoreFlag(FFrame&, void* const)
native simulated function XComCoverInterface.ECoverForceFlag GetCoverIgnoreFlag();

// Export UXComFracLevelActor::execSetPrimitiveCutdownFlag(FFrame&, void* const)
native simulated function SetPrimitiveCutdownFlag(bool bShouldCutdown);

// Export UXComFracLevelActor::execSetPrimitiveCutoutFlag(FFrame&, void* const)
native simulated function SetPrimitiveCutoutFlag(bool bShouldCutout);

// Export UXComFracLevelActor::execSetPrimitiveCutdownFlagImm(FFrame&, void* const)
native simulated function SetPrimitiveCutdownFlagImm(bool bShouldCutdown);

// Export UXComFracLevelActor::execSetPrimitiveCutoutFlagImm(FFrame&, void* const)
native simulated function SetPrimitiveCutoutFlagImm(bool bShouldCutout);

// Export UXComFracLevelActor::execSetPrimitiveHidden(FFrame&, void* const)
native simulated function SetPrimitiveHidden(bool bInHidden);

// Export UXComFracLevelActor::execSetVisFadeFlag(FFrame&, void* const)
native simulated function SetVisFadeFlag(bool bVisFade, optional bool bForceReattach);

// Export UXComFracLevelActor::execGetPrimitiveVisHeight(FFrame&, void* const)
native simulated function GetPrimitiveVisHeight(out float fCutdownHeight, out float fCutoutHeight, out float fOpacityMaskHeight, out float fPreviousOpacityMaskHeight);

// Export UXComFracLevelActor::execSetPrimitiveVisHeight(FFrame&, void* const)
native simulated function SetPrimitiveVisHeight(float fCutdownHeight, float fCutoutHeight, float fOpacityMaskHeight, float fPreviousOpacityMaskHeight);

// Export UXComFracLevelActor::execGetPrimitiveVisFadeValues(FFrame&, void* const)
native simulated function GetPrimitiveVisFadeValues(out float CutoutFade, out float TargetCutoutFade);

// Export UXComFracLevelActor::execSetPrimitiveVisFadeValues(FFrame&, void* const)
native simulated function SetPrimitiveVisFadeValues(float CutoutFade, float TargetCutoutFade);

// Export UXComFracLevelActor::execCanUseCutout(FFrame&, void* const)
native simulated function bool CanUseCutout();

// Export UXComFracLevelActor::execSetHideableFlag(FFrame&, void* const)
native simulated function SetHideableFlag(bool bShouldHide);

// Export UXComFracLevelActor::execSetHideableFlagImm(FFrame&, void* const)
native simulated function SetHideableFlagImm(bool bShouldHide, optional bool bAffectMainSceneChannel=true);

// Export UXComFracLevelActor::execCanUseHideable(FFrame&, void* const)
native simulated function bool CanUseHideable();

// Export UXComFracLevelActor::execChangeVisibilityAndHide(FFrame&, void* const)
native simulated function ChangeVisibilityAndHide(bool bShow, float fCutdownHeight, float fCutoutHeight);

// Export UXComFracLevelActor::execChangeVisibility(FFrame&, void* const)
native simulated function ChangeVisibility(float fCutdown, float fCutoutHeight);

// Export UXComFracLevelActor::execGetHidingPartner(FFrame&, void* const)
native simulated function Actor GetHidingPartner();

// Export UXComFracLevelActor::execPostApplyCheckpoint(FFrame&, void* const)
native simulated function PostApplyCheckpoint();

// Export UXComFracLevelActor::execUpdateTintColor(FFrame&, void* const)
native simulated function UpdateTintColor();

// Export UXComFracLevelActor::execIsPositionVisible(FFrame&, void* const)
native function bool IsPositionVisible(const out Vector Position, out int bCutout, PrimitiveComponent HitComp);
// Export UXComFracLevelActor::execResetHealth(FFrame&, void* const)
native simulated function ResetHealth();

// Export UXComFracLevelActor::execApplyDamage(FFrame&, void* const)
native simulated function ApplyDamage(Vector Origin, float Radius, int Damage);
// Export UXComFracLevelActor::execDamageColumn(FFrame&, void* const)
native function DamageColumn(int ColumnIdx, float MaxZ, int DamageAmount, optional bool bAllowCascade=true);

simulated event PostBeginPlay(){}
simulated event BreakOffPartsInRadius(Vector Origin, float Radius, float RBStrength, bool bWantPhysChunksAndParticles){}
simulated event Tick(float DeltaTime){}
simulated function RecordDamageEvent(const out DamageEvent Dmg){}
simulated event TakeDirectDamage(const DamageEvent Dmg){}
simulated event TakeSplashDamage(const DamageEvent Dmg){}
simulated event TakeCollateralDamage(Actor FromActor, int ColumnIdx, float MaxZ, int DamageAmount){}
function bool OnMouseEvent(int Cmd, int Actionmask, optional Vector MouseWorldOrigin, optional Vector MouseWorldDirection, optional Vector HitLocation){}
