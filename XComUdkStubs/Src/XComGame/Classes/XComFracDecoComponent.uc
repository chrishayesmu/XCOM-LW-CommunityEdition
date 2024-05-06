class XComFracDecoComponent extends ToggleableInstancedStaticMeshComponent
    native(Destruction)
    editinlinenew
    hidecategories(Object);

const DECO_INSTANCE_UID = 0x00FFFF;

var private XComDecoFracLevelActor m_DecoFracParent;
var private export editinline FracturedStaticMeshComponent m_FracturedStaticMeshComponent;
var bool bCreatedPostLightmapBake;
var transient bool bReinitialize;
var int nCachedFragmentsVisible;

defaultproperties
{
    nCachedFragmentsVisible=-1
    bCutoutMask=true
    CastShadow=false
    bUsePrecomputedShadows=true
    LightingChannels=(bInitialized=true,Static=true)
}