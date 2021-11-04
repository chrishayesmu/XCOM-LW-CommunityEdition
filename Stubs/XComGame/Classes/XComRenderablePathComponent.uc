class XComRenderablePathComponent extends PrimitiveComponent
    native;
//complete stub

struct native XComPathRenderData
{
    var int VertexCount;
    var int IndexCount;
    var int MaxVertexBufferSize;
    var int MaxIndexBufferSize;
    var native Pointer VertexData;
    var native Pointer IndexData;
};

var MaterialInstanceConstant PathingMaterial;
var int iPathLengthOffset;
var float fRibbonWidth;
var float fEmitterTimeStep;
var native transient XComPathRenderData GameThreadRenderData;

// Export UXComRenderablePathComponent::execUpdatePathRenderData(FFrame&, void* const)
native function bool UpdatePathRenderData(InterpCurveVector Spline, float PathLength);

// Export UXComRenderablePathComponent::execSetMaterial(FFrame&, void* const)
native function SetMaterial(Material InMat);