class XComWorldData extends Object
    native(Core)
	dependsOn(XGTacticalGameCoreData);
//complete stub

const WORLD_StepSize = 96.0f;
const WORLD_StepSizeSquared = 9216.0f;
const WORLD_StepSize_2D_Diagonal = 135.7645f;
const WORLD_StepSize_2DZ_Diagonal = 115.3776f;
const WORLD_StepSize_3D_Diagonal = 150.0933f;
const WORLD_HalfStepSize = 48.0f;
const WORLD_FloorHeight = 64.0f;
const WORLD_HalfFloorHeight = 32.0f;
const WORLD_BaseHeight = 24.0f;
const WORLD_PartialRadius = 20.0f;


enum ETraversalType
{
    eTraversal_None,
    eTraversal_Normal,
    eTraversal_ClimbOver,
    eTraversal_ClimbOnto,
    eTraversal_ClimbLadder,
    eTraversal_DropDown,
    eTraversal_Grapple,
    eTraversal_Landing,
    eTraversal_BreakWindow,
    eTraversal_KickDoor,
    eTraversal_WallClimb,
    eTraversal_JumpUp,
    eTraversal_Ramp,
    eTraversal_BreakWall,
    eTraversal_Unreachable,
    eTraversal_MAX
};

enum UnitPeekSide
{
    eNoPeek,
    ePeekLeft,
    ePeekRight,
    UnitPeekSide_MAX
};

enum ECoverDir
{
    eCD_North,
    eCD_South,
    eCD_East,
    eCD_West,
    eCD_MAX
};
enum EPathType
{
    ePathType_Normal,
    ePathType_PathObject,
    ePathType_Dropdown,
    ePathType_MAX
};

enum ERuntimeRebuildStep
{
    eStep_Idle,
    eStep_Starting,
    eStep_Occupancy,
    eStep_CoverAndBlocking,
    eStep_Interactions,
    eStep_Neighbors,
    eStep_Finished,
    eStep_MAX
};


struct native TTile
{
    var int X;
    var int Y;
    var int Z;

};

struct native XComCoverPoint
{
    var int X;
    var int Y;
    var int Z;
    var Vector TileLocation;
    var Vector CoverLocation;
    var int Flags;

};

struct native ViewerInfo
{
    var int TileX;
    var int TileY;
    var int TileZ;
    var float SightRadius;
    var int SightRadiusRaw;
    var int SightRadiusTiles;
    var int SightRadiusTilesSq;
    var Actor AssociatedActor;
    var Vector PositionOffset;
    var bool bNeedsTextureUpdate;
    var bool bHasSeenXCom;

};

struct native PathingTraversalData
{
    var int TileX;
    var int TileY;
    var int TileZ;
    var float AStarG_Modifier;
    var Actor PathObject;
    var init array<init ETraversalType> TraversalTypes;
    var init array<init Vector> Positions;

 
};

struct native FloorTileData
{
    var Vector FloorLocation;
    var Vector FloorNormal;
    var Actor FloorActor;
    var Actor FloorVolume;
    var init array<init PathingTraversalData> Neighbors;
    var byte RampDirection;

};

struct native VolumeEffectTileData
{
    var int NumTurns;
    var int NumHops;
    var ParticleSystem VolumeEffectParticleTemplate;
    var export editinline ParticleSystemComponent VolumeEffectParticles;
    var int Intensity;

};

struct native CoverTileData
{
    var Vector CoverLocation;

 };

struct native XComInteractPoint
{
    var Vector Location;
    var Rotator Rotation;
    var XComInteractiveLevelActor InteractiveActor;
    var name InteractSocketName;
    var int ModifyTileStaticFlags;

};

struct native PeekAroundInfo
{
    var int bHasPeekaround;
    var Vector PeekaroundLocation;
    var Vector PeekaroundDirectionFromCoverPt;
    var TTile PeekTile;

   
};

struct native CoverDirectionPeekData
{
    var PeekAroundInfo LeftPeek;
    var PeekAroundInfo RightPeek;
    var Vector CoverDirection;
    var int bHasCover;

};

struct native UnitDirectionInfo
{
    var XGUnit TargetUnit;
    var int CoverDirection;
    var int AdditionalFlags;
    var UnitPeekSide PeekSide;
    var float PeekToTargetDist;
    var bool bVisible;
    var bool bVisibleFromDefault;

};

struct native CachedVisibilityQueryData
{
    var CoverDirectionPeekData CoverDirectionInfo[4];
    var Vector DefaultVisibilityCheckLocation;
    var TTile DefaultVisibilityCheckTile;
    var int bDefaultTileValid;

};

struct native KineticStrikeAttackInfo
{
    var Vector AttackDirection;
    var ECoverType DestroyCoverType;
    var Vector DestroyCoverLocation;
    var XGUnitNativeBase AttackUnit;
    var int AttackUnitDeltaZ;

};

struct native TileData
{
    var FloorTileData FloorData;
    var CoverTileData CoverData;
    var VolumeEffectTileData FireData;
    var VolumeEffectTileData SmokeData;
    var VolumeEffectTileData PoisonData;
    var init array<init XComInteractPoint> InteractPoints;
    var int StaticFlags;
    var int CoverFlags;
    var int Viewers;
    var int DynamicWorldFlags;
    var byte VisibilityFlags;

};

struct native WorldDataRenderParams
{
    var float FOWNeverSeenAlpha;
    var float FOWHaveSeenAlpha;
    var int WorldDataNumX;
    var int WorldDataNumY;
    var int WorldDataNumZ;

};

struct native SmokeEmitter
{
    var native Array_Mirror Tiles;
    var Vector HalfSize;
    var Vector Center;
    var byte VolumeType;
    var ParticleSystem ParticleTemplate;
    var export editinline ParticleSystemComponent Particles;

};

var native const noexport Pointer VfTable_FTickableObject;
var transient bool bDisableVisibilityUpdates;
var transient bool bDebugVisibility;
var transient bool bDebugFOW;
var transient bool bEnableFOW;
var transient bool bEnableFOWUpdate;
var transient bool bDebugBlockingTiles;
var transient bool bDebugNormals;
var transient bool bShowCoverNodes;
var transient bool bShowCoverTiles;
var transient bool bShowFloorTiles;
var transient bool bUseIntroFOWUpdate;
var transient bool bDebuggingGenericUpdate;
var transient bool bEnableUnitOutline;
var transient bool bCinematicMode;
var transient bool bFOWTextureBufferIsDirty;
var transient bool bUpdatingVisibility;
var transient bool bWorldDataInitialized;
var transient bool bUseSingleThreadedSolver;
var transient bool bInitVolumeEffectsPostLoad;
var bool bUseLineChecksForFOW;
var bool bDrawVisibilityChecks;
var transient bool UpdateBuildHeightTiles;
var transient bool bShowNeverSeenAsHaveSeen;
var transient int CoverDebugFlags;
var Box WorldBounds;
var int NumX;
var int NumY;
var int NumZ;
var int NumTiles;
var transient int NumRebuilds;
var init transient array<init byte> FOWUpdateTextureBuffer;
var transient Double LastFOWTextureUpdateTime;
var transient int HFNumX_New;
var transient int HFNumY_New;
var transient int HFNumZ_New;
var init transient array<init byte> FOWHeightFogUpdateTextureBuffer;
var transient array<Vector> UpdateCorners;
var transient Box CurrentUpdateBox;
var native const Pointer WorldDataPtr;
var ParticleSystem FireParticleSystemCenter;
var ParticleSystem FireParticleSystemFill;
var ParticleSystem SmokeParticleSystemCenter;
var ParticleSystem SmokeParticleSystemFill;
var ParticleSystem CombatDrugsParticleSystemCenter;
var ParticleSystem CombatDrugsParticleSystemFill;
var ParticleSystem PoisonParticleSystemCenter;
var ParticleSystem PoisonParticleSystemFill;
var init string FireParticleSystemCenter_Name;
var init string FireParticleSystemFill_Name;
var init string SmokeParticleSystemCenter_Name;
var init string SmokeParticleSystemFill_Name;
var init string CombatDrugsParticleSystemCenter_Name;
var init string CombatDrugsParticleSystemFill_Name;
var init string PoisonParticleSystemCenter_Name;
var init string PoisonParticleSystemFill_Name;
var transient DamageFrame DamageFrame;
var transient ERuntimeRebuildStep RebuildState;
var transient int RebuildIndex;
var delegate<CanSeeLocationCallback> CurrentCanSeeLocationCallback;
var Object CurrentCanSeeLocationCallbackOwner;
var init transient array<init Actor> Viewers;
var init protected transient array<init ViewerInfo> ViewerInfos;
var init protected transient array<init Actor> DeferredRemoveViewers;
var protected editoronly native Set_Mirror DebugTiles;
var protected native Set_Mirror VolumeEffectUpdateTiles;
var XComLevelVolume Volume;
var float FOWNeverSeen;
var float FOWHaveSeen;
var float LastFloorHeight;
var array<SmokeEmitter> SmokeEmitters;
var transient array<Vector> PotentialFireColumns;
//var delegate<CanSeeLocationCallback> __CanSeeLocationCallback__Delegate;


delegate CanSeeLocationCallback();
// Export UXComWorldData::execAddXGVolume(FFrame&, void* const)
native function AddXGVolume(EVolumeType eType, CylinderComponent NewVolume, int NumTurns);
// Export UXComWorldData::execBuildTileCache_Tiles(FFrame&, void* const)
native function bool BuildTileCache_Tiles(const out TTile Start, const out TTile Destination, optional int MaxPathCost=-1);
// Export UXComWorldData::execBuildTileCache_Vectors(FFrame&, void* const)
native function bool BuildTileCache_Vectors(const out Vector Start, const out Vector Destination, optional int MaxPathCost=-1);
// Export UXComWorldData::execBuildWorldData(FFrame&, void* const)
native function BuildWorldData(XComLevelVolume LevelVolume);
// Export UXComWorldData::execCacheVisibilityDataForTile(FFrame&, void* const)
native function CacheVisibilityDataForTile(int X, int Y, int Z, out CachedVisibilityQueryData Data, optional XGUnitNativeBase Unit);
// Export UXComWorldData::execCanSeeActorToActor(FFrame&, void* const)
native function bool CanSeeActorToActor(Actor FromActor, Actor ToActor, out UnitDirectionInfo DirectionInfo, optional bool bCheckRange=true, optional int CoverDirection=-1, optional int ViewerIndex=-1, optional bool bIgnoreStealth);
// Export UXComWorldData::execCanSeeActorToLocation(FFrame&, void* const)
native function bool CanSeeActorToLocation(Actor FromActor, const out Vector ToLocation, optional bool bUseLineChecks);
// Export UXComWorldData::execCanSeeActorToTile(FFrame&, void* const)
native function bool CanSeeActorToTile(Actor FromActor, int TileX, int TileY, int TileZ, optional bool bUseLineChecks);
// Export UXComWorldData::execCheckClearanceForPodReveal(FFrame&, void* const)
native function bool CheckClearanceForPodReveal(const out Vector Position);
// Export UXComWorldData::execCheckTargetSquadsight(FFrame&, void* const)
native function bool CheckTargetSquadsight(XComLocomotionUnitPawn Viewer, XComLocomotionUnitPawn Target, out UnitDirectionInfo DirectionInfo);
// Export UXComWorldData::execClampTile(FFrame&, void* const)
native function ClampTile(int TileX, int TileY, int TileZ, out int ValidTileX, out int ValidTileY, out int ValidTileZ);
// Export UXComWorldData::execCleanup(FFrame&, void* const)
native function Cleanup();
// Export UXComWorldData::execClearFlameThrowerUI(FFrame&, void* const)
native function ClearFlameThrowerUI();
// Export UXComWorldData::execClearTileBlockedByUnitFlag(FFrame&, void* const)
native function ClearTileBlockedByUnitFlag(Actor BlockingUnit);
// Export UXComWorldData::execDebugUpdateVisibilityMapForViewer(FFrame&, void* const)
native function DebugUpdateVisibilityMapForViewer(Actor Viewer, const out Vector DebugLocation);
// Export UXComWorldData::execDisableUnitVisCleanup(FFrame&, void* const)
native function DisableUnitVisCleanup();
// Export UXComWorldData::execDoInitialTextureStreaming(FFrame&, void* const)
native function DoInitialTextureStreaming(const Vector Location);
// Export UXComWorldData::execDrawFlameThrowerUI(FFrame&, void* const)
native function DrawFlameThrowerUI(XComUnitPawnNativeBase UnitPawn, const out Vector OriginLoc, const out Vector TargetLoc, float FlameRange, float SweepAngle, out array<Actor> OutFlamedUnits);
// Export UXComWorldData::execDrawKineticStrikeUI(FFrame&, void* const)
native function DrawKineticStrikeUI(XComUnitPawnNativeBase UnitPawn, const out Vector TargetLoc);
// Export UXComWorldData::execFindClosestValidLocation(FFrame&, void* const)
native function Vector FindClosestValidLocation(const Vector TestLocation, bool bAllowFlying, bool bPrioritizeZLevel, optional bool bAvoidNoSpawnZones);
// Export UXComWorldData::execGetAStarPath(FFrame&, void* const)
native function GetAStarPath(out array<TTile> arrPath, const out Vector vStart, const out Vector vEnd, bool bFlying, bool bOptimalPath);
// Export UXComWorldData::execGetCanSeeLocationTiles(FFrame&, void* const)
native function GetCanSeeLocationTiles(const out TTile kLookTile, int RadiusMeters, delegate<CanSeeLocationCallback> CallbackFn, Object CallbackOwner);
// Export UXComWorldData::execGetClosestActionLocation(FFrame&, void* const)
native function bool GetClosestActionLocation(const Vector TestLocation, out Vector ActionLocation, optional float Radius=128.0);
// Export UXComWorldData::execGetClosestCoverPoint(FFrame&, void* const)
native function bool GetClosestCoverPoint(const Vector InPoint, const float Radius, out XComCoverPoint CoverPoint, optional bool bOnlyUnblockedTiles, optional bool bAvoidNoSpawnZones);
// Export UXComWorldData::execGetClosestInteractionPoint(FFrame&, void* const)
native function bool GetClosestInteractionPoint(const Vector InPoint, const float Radius, const float Height, out XComInteractPoint InteractPoint);
// Export UXComWorldData::execGetClosestTile(FFrame&, void* const)
native function GetClosestTile(const out TTile kStartTile, const out array<TTile> arrDestTiles, out TTile OutClosestDestTile);
// Export UXComWorldData::execGetClosestValidCursorPosition(FFrame&, void* const)
native function Vector GetClosestValidCursorPosition(Vector CurrentLocation);
// Export UXComWorldData::execGetCoverDirection(FFrame&, void* const)
native static final function bool GetCoverDirection(out int CoverDir, int DX, int DY);
// Export UXComWorldData::execGetCoverPoint(FFrame&, void* const)
native function bool GetCoverPoint(const Vector InPoint, out XComCoverPoint CoverPoint);
// Export UXComWorldData::execGetCoverPoints(FFrame&, void* const)
native function bool GetCoverPoints(const Vector InPoint, const float Radius, const float Height, out array<XComCoverPoint> CoverPoints, optional bool bSortedByDist);
// Export UXComWorldData::execGetCoverPointsInPathingRange(FFrame&, void* const)
native function bool GetCoverPointsInPathingRange(out array<XComCoverPoint> CoverPoints);
// Export UXComWorldData::execGetCoverTestLength(FFrame&, void* const)
native static final function float GetCoverTestLength(const int CoverDir, const bool bDiagonal);
// Export UXComWorldData::execGetFloorTileForPosition(FFrame&, void* const)
native function bool GetFloorTileForPosition(const out Vector Position, out int TileX, out int TileY, out int TileZ, optional bool bUnlimitedSearch);
// Export UXComWorldData::execGetFloorTileZ(FFrame&, void* const)
native function int GetFloorTileZ(int TileX, int TileY, int TileZ, optional bool bUnlimitedSearch);
// Export UXComWorldData::execGetFloorZForPosition(FFrame&, void* const)
native function float GetFloorZForPosition(const out Vector Position, optional bool bUnlimitedSearch);
// Export UXComWorldData::execGetInteractionPoints(FFrame&, void* const)
native function bool GetInteractionPoints(const Vector InPoint, const float Radius, const float Height, out array<XComInteractPoint> InteractPoints);
// Export UXComWorldData::execGetKineticStrikeInfoFromTargetLocation(FFrame&, void* const)
native function GetKineticStrikeInfoFromTargetLocation(XComUnitPawnNativeBase UnitPawn, const out Vector TargetLoc, out KineticStrikeAttackInfo AttackInfo);
// Export UXComWorldData::execGetPeekLeftDirection(FFrame&, void* const)
native static final function Vector GetPeekLeftDirection(const int CoverDir, const bool bDiagonal);
// Export UXComWorldData::execGetPeekRightDirection(FFrame&, void* const)
native static final function Vector GetPeekRightDirection(const int CoverDir, const bool bDiagonal);
// Export UXComWorldData::execGetPositionFromTileCoordinates(FFrame&, void* const)
native function Vector GetPositionFromTileCoordinates(int TileX, int TileY, int TileZ);
// Export UXComWorldData::execGetPositionFromTileIndex(FFrame&, void* const)
native function Vector GetPositionFromTileIndex(int Index);
// Export UXComWorldData::execGetTileCoordinatesFromPosition(FFrame&, void* const)
native function GetTileCoordinatesFromPosition(const out Vector Position, out int TileX, out int TileY, out int TileZ);
// Export UXComWorldData::execGetValidSpawnLocation(FFrame&, void* const)
native function Vector GetValidSpawnLocation(const out Vector InitialPt);
// Export UXComWorldData::execGetVisibilityMapTileCoordinates(FFrame&, void* const)
native function GetVisibilityMapTileCoordinates(int Index, out int TileX, out int TileY, out int TileZ);
// Export UXComWorldData::execGetVisibilityMapTileIndex(FFrame&, void* const)
native function int GetVisibilityMapTileIndex(int TileX, int TileY, int TileZ);
// Export UXComWorldData::execGetVisibilityMapTileIndexFromPosition(FFrame&, void* const)
native function int GetVisibilityMapTileIndexFromPosition(const out Vector Position);
// Export UXComWorldData::execGetWorldData(FFrame&, void* const)
native static function XComWorldData GetWorldData();
// Export UXComWorldData::execGetWorldDirection(FFrame&, void* const)
native static final function Vector GetWorldDirection(const int CoverDir, const bool bDiagonal);
// Export UXComWorldData::execHasOverheadClearance(FFrame&, void* const)
native function bool HasOverheadClearance(const out Vector Location, optional float ClearanceDistanceRequirement=64.0);
// Export UXComWorldData::execHasPendingVisibilityUpdates(FFrame&, void* const)
native function bool HasPendingVisibilityUpdates();
// Export UXComWorldData::execInitializeAllViewersToHaveSeenFog(FFrame&, void* const)
native function InitializeAllViewersToHaveSeenFog(bool bSetting);
// Export UXComWorldData::execInitializeVolumeEffectsPostLoad(FFrame&, void* const)
native function InitializeVolumeEffectsPostLoad();
// Export UXComWorldData::execInitializeWorldData(FFrame&, void* const)
native function InitializeWorldData();
// Export UXComWorldData::execIsActionAvailable(FFrame&, void* const)
native function bool IsActionAvailable(const Vector TestLocation, optional float Radius=128.0);
// Export UXComWorldData::execIsAdjacentTileVisible(FFrame&, void* const)
native function bool IsAdjacentTileVisible(const out Vector FromLocation, const out Vector ToLocation);
// Export UXComWorldData::execIsInNoSpawnZone(FFrame&, void* const)
native function bool IsInNoSpawnZone(const out Vector vLoc, optional bool bCivilian, optional bool bLogFailures);
// Export UXComWorldData::execIsLocationFlammable(FFrame&, void* const)
native function bool IsLocationFlammable(const out Vector Location);
// Export UXComWorldData::execIsLocationHighCover(FFrame&, void* const)
native function bool IsLocationHighCover(const out Vector Location);
// Export UXComWorldData::execIsLocationLowCover(FFrame&, void* const)
native function bool IsLocationLowCover(const out Vector Location);
// Export UXComWorldData::execIsLocationVisibleToTeam(FFrame&, void* const)
native function bool IsLocationVisibleToTeam(const out Vector TestLocation, ETeam TeamFlag);
// Export UXComWorldData::execIsPositionOnFloor(FFrame&, void* const)
native function bool IsPositionOnFloor(const out Vector Position);
// Export UXComWorldData::execIsPositionOnFloorAndValidDestination(FFrame&, void* const)
native function bool IsPositionOnFloorAndValidDestination(const out Vector Position);
// Export UXComWorldData::execIsRebuildingTiles(FFrame&, void* const)
native function bool IsRebuildingTiles();
// Export UXComWorldData::execIsTileBlockedByUnitFlag(FFrame&, void* const)
native function bool IsTileBlockedByUnitFlag(const out int X, const out int Y, const out int Z, Actor IgnoreUnit);
// Export UXComWorldData::execIsTileFullyOccupied(FFrame&, void* const)
native function bool IsTileFullyOccupied(int X, int Y, int Z);
// Export UXComWorldData::execIsTileOccupied(FFrame&, void* const)
native function bool IsTileOccupied(int X, int Y, int Z);
// Export UXComWorldData::execIsTileOutOfRange(FFrame&, void* const)
native function bool IsTileOutOfRange(int TileX, int TileY, int TileZ);
// Export UXComWorldData::execPathLength(FFrame&, void* const)
native function float PathLength(const out TTile kStartTile, const out TTile kEndTile);
// Export UXComWorldData::execProcessFlameThrowerSweep(FFrame&, void* const)
native function ProcessFlameThrowerSweep(bool bProcessFire, XComUnitPawn UnitPawn, const Vector Facing, float AimOffsetX, float FlameRange, float SweepAngle, out array<XGUnitNativeBase> OutFlamedUnits, out array<Vector> OutSecondaryFireLocations);
// Export UXComWorldData::execQueryCanSeeLocationTiles(FFrame&, void* const)
native function QueryCanSeeLocationTiles(const out TTile kCenter, int iTileRadius, out array<TTile> arrCanSeeTiles, optional bool bDrawDebug);
// Export UXComWorldData::execRebuildTileData(FFrame&, void* const)
native function RebuildTileData(const out Vector InPoint, const float ExtentXY, const float ExtentZ);
// Export UXComWorldData::execRebuildTileDataExtents(FFrame&, void* const)
native function RebuildTileDataExtents(const out Vector InPoint, const out Vector Extents);
// Export UXComWorldData::execRegisterActor(FFrame&, void* const)
native function RegisterActor(Actor Viewer, int SightRadius, optional Vector PositionOffset);
// Export UXComWorldData::execRemoveInteractionPoints(FFrame&, void* const)
native function RemoveInteractionPoints(XComInteractiveLevelActor inActor);
// Export UXComWorldData::execSetIsWaterTile(FFrame&, void* const)
native function bool SetIsWaterTile(int X, int Y, int Z, bool bIsWaterTile);
// Export UXComWorldData::execSetRebuildTileProcessRate(FFrame&, void* const)
native function SetRebuildTileProcessRate(int NumTilesPerUpdate);
// Export UXComWorldData::execSetTileBlockedByUnitFlag(FFrame&, void* const)
native function SetTileBlockedByUnitFlag(Actor BlockingUnit);
// Export UXComWorldData::execSetTileBlockedByUnitFlagAtLocation(FFrame&, void* const)
native function SetTileBlockedByUnitFlagAtLocation(Actor BlockingUnit, const out Vector vLoc);
// Export UXComWorldData::execTileContainsPoison(FFrame&, void* const)
native function bool TileContainsPoison(const int TileX, const int TileY, const int TileZ);
// Export UXComWorldData::execTileContainsSmoke(FFrame&, void* const)
native function bool TileContainsSmoke(const int TileX, const int TileY, const int TileZ);
// Export UXComWorldData::execUnregisterActor(FFrame&, void* const)
native function UnregisterActor(Actor Viewer, optional bool bRemoveFromUnitsArrays=true);
// Export UXComWorldData::execUpdateDebugVisuals(FFrame&, void* const)
native function UpdateDebugVisuals(optional bool bOnlyShowBlocking=true);
// Export UXComWorldData::execUpdateFloorHeight(FFrame&, void* const)
native function UpdateFloorHeight(optional float ShowFloorHeight=-1.0);
// Export UXComWorldData::execUpdateVisibility(FFrame&, void* const)
native function UpdateVisibility(optional bool bLog, optional bool bIncremental=true);
// Export UXComWorldData::execUpdateVolumeEffects(FFrame&, void* const)
native function UpdateVolumeEffects();
// Export UXComWorldData::execWorldTrace(FFrame&, void* const)
native function bool WorldTrace(const out Vector StartLocation, const out Vector EndLocation, out Vector HitLocation, out Vector HitNormal, out Actor HitActor, optional int CheckType=4);

defaultproperties
{
    bDisableVisibilityUpdates=true
    bEnableFOW=true
    bEnableUnitOutline=true
    bFOWTextureBufferIsDirty=true
    FireParticleSystemCenter_Name="FX_WP_Flamethrower.Torch_Volume.P_FlamethrowerCollisionFire_Volume_Center"
    FireParticleSystemFill_Name="FX_Fire_Dynamic.P_Fire_Fill"
    SmokeParticleSystemCenter_Name="FX_WP_SmokeGrenade.Gridded.P_SmokGrenade_Center"
    SmokeParticleSystemFill_Name="FX_WP_SmokeGrenade.Gridded.P_Smoke_Grenade_Fill"
    CombatDrugsParticleSystemCenter_Name="FX_Soldier_Abilities.P_Combat_Drugs_Smoke_Grenade_Center"
    CombatDrugsParticleSystemFill_Name="FX_Soldier_Abilities.P_Combat_Drugs_Fill"
    PoisonParticleSystemCenter_Name="FX_CHA_Thinman.P_Plague_Vapor_Explode"
    PoisonParticleSystemFill_Name="FX_CHA_Thinman.P_Plague_Vapor_Fill"
    LastFloorHeight=-1.0
}