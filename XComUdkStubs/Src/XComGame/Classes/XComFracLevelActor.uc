class XComFracLevelActor extends FracturedStaticMeshActor
    native(Level)
    dependson(XComLevelActor)
    hidecategories(Navigation)
    implements(XComCoverInterface,Destructible,IMouseInteractionInterface);

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
var(Cover) XComCoverInterface.ECoverForceFlag CoverForceFlag;
var(Cover) XComCoverInterface.ECoverForceFlag CoverIgnoreFlag;
var() EMaterialType ImpactMaterialType;
var Box LastFilterBox;
var() XComDestructibleActor_Toughness Toughness;
var init array<init int> SavedVisibleFragments;
var transient FracturedHitInfo LastHitInfo;
var init array<init FragmentColumn> FragmentColumns;
var() XComFracLevelActorImpactDefinition ImpactEffectsDefinition;
var() EmitterInstanceParameterSet ImpactInstanceParameters;

defaultproperties
{
    bAlwaysConsiderForCover=true
    bIsValidDestination=true
    bNeedsDamageResolution=true
    bStaticCollision=true
    bNoDelete=false
    bTickIsDisabled=true
    bCanStepUpOn=false
    m_bNoDeleteOnClientInitializeActors=true
    bPathColliding=false

    begin object name=FracturedStaticMeshComponent0
        WireframeColor=(R=111,G=63,B=254,A=255)
        bReceiverOfDecalsEvenIfHidden=true
        bForceDirectLightMap=false
        LightingChannels=(bInitialized=true,Static=true)
    end object

	begin object Class=XComFloorComponent Name=FloorComponent0
		fTargetOpacityMaskHeight=999999.0
	end object
	FloorComponent=FloorComponent0
	Components.Add(FloorComponent0)
}