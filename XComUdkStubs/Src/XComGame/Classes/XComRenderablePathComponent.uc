class XComRenderablePathComponent extends PrimitiveComponent
    native;

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

defaultproperties
{
    fRibbonWidth=5.0
    fEmitterTimeStep=10.0
}