class XComDecoFracLevelActor extends XComFracLevelActor
    native(Level)
    hidecategories(Navigation);

var(DecoMesh) StaticMesh m_DecoMesh;
var(DecoMesh) float fRotationLimit;
var(DecoMesh) float fMaxStretch;
var(DecoMesh) float fDecoMeshScale;
var(DecoMesh) bool bRelativeScale;
var(DecoMesh) bool bForceDecoVisible;
var(DecoMesh) bool bEnableDecoMeshes;
var(DebrisMesh) bool bForceDebrisVisible;
var(DebrisMesh) bool bEnableDebrisMeshes;
var(DecoMesh) transient int nFittingIterations;
var(DebrisMesh) StaticMesh m_DebrisWholeMesh;
var(DebrisMesh) array<StaticMesh> m_DebrisHalfMeshes;
var(DebrisMesh) array<XComDestructibleDebrisActor> m_PartialCoverDebrisMeshes;
var(DebrisMesh) float m_CoverDebrisChance;
var int nCachedFragmentsVisible;

defaultproperties
{
    fRotationLimit=360.0
    fMaxStretch=2.0
    fDecoMeshScale=1.50
    bRelativeScale=true
    bEnableDecoMeshes=true
    bEnableDebrisMeshes=true
    nFittingIterations=30
    m_CoverDebrisChance=0.20
    nCachedFragmentsVisible=-1

    begin object name=FracturedStaticMeshComponent0
        bUseVertexColorDestruction=true
        bUsesDestroyedMaterials=true
    end object
}