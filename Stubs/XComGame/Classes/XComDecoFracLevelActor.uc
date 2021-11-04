class XComDecoFracLevelActor extends XComFracLevelActor
    native(Level);
//complete stub

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

simulated event BreakOffPartsInRadius(Vector Origin, float Radius, float RBStrength, bool bWantPhysChunksAndParticles)
{}

event Destroyed(){}
// Export UXComDecoFracLevelActor::execSetHidden(FFrame&, void* const)
native simulated function SetHidden(bool bNewHidden);

// Export UXComDecoFracLevelActor::execSetPrimitiveCutdownFlagImm(FFrame&, void* const)
native simulated function SetPrimitiveCutdownFlagImm(bool bShouldCutdown);

// Export UXComDecoFracLevelActor::execSetPrimitiveCutoutFlagImm(FFrame&, void* const)
native simulated function SetPrimitiveCutoutFlagImm(bool bShouldCutout);

// Export UXComDecoFracLevelActor::execSetPrimitiveHidden(FFrame&, void* const)
native simulated function SetPrimitiveHidden(bool bInHidden);

// Export UXComDecoFracLevelActor::execSetVisFadeFlag(FFrame&, void* const)
native simulated function SetVisFadeFlag(bool bVisFade, optional bool bForceReattach);

// Export UXComDecoFracLevelActor::execSetPrimitiveVisFadeValues(FFrame&, void* const)
native simulated function SetPrimitiveVisFadeValues(float fCutoutFade, float fTargetCutoutFade);

// Export UXComDecoFracLevelActor::execSetPrimitiveVisHeight(FFrame&, void* const)
native simulated function SetPrimitiveVisHeight(float fCutdownHeight, float fCutoutHeight, float fOpacityMaskHeight, float fPreviousOpacityMaskHeight);

// Export UXComDecoFracLevelActor::execChangeVisibilityAndHide(FFrame&, void* const)
native simulated function ChangeVisibilityAndHide(bool bShow, float fCutdownHeight, float fCutoutHeight);

// Export UXComDecoFracLevelActor::execDeregister(FFrame&, void* const)
native function Deregister();
