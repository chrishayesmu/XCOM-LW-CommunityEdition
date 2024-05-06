class XComMovementGridComponent extends PrimitiveComponent
    native(Level)
    config(Game);

struct native XComMovementGridRenderData
{
    var int VertexCount;
    var int IndexCount;
    var int MaxVertexBufferSize;
    var int MaxIndexBufferSize;
    var int CachedStage7Hash;
    var native Pointer VertexData;
    var native Pointer IndexData;
};

var const globalconfig transient float MovementBorderWidth;
var const globalconfig transient float CurveSmoothing;
var const globalconfig transient float CurveResolution;
var const globalconfig transient float UVTilingDistance;
var transient Vector LastUnitLocation;
var transient XGUnitNativeBase LastUnit;
var transient int LastCursorZPosition;
var transient bool bCustomHidden;
var transient bool bCinematicHidden;
var transient bool bUIHidden;
var transient bool bUsedHeightConstraints;
var transient bool bIsGrappleMove;
var native transient bool bUsingMouseMaterial;
var MaterialInstanceConstant BorderMaterial;
var native int SizeOfPreviousMapping;
var native int SizeOfPreviousEdges;
var native int DebugTileX;
var native int DebugTileY;
var native int DebugTileZ;
var int CachedStage7Hash;
var native transient XComMovementGridRenderData GameThreadRenderData;

defaultproperties
{
    bCustomHidden=true
    bUsedHeightConstraints=true
    bTranslucentIgnoreFOW=true
    bDisableAllRigidBody=true
    TranslucencySortPriority=1000
}