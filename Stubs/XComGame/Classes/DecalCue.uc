class DecalCue extends Object
    native(Graphics)
    editinlinenew
    collapsecategories
    hidecategories(Object);
//complete stub
struct native DecalCueEntry
{
    var() MaterialInterface DecalMaterial;
    var() float Weight;

    structdefaultproperties
    {
        DecalMaterial=none
        Weight=1.0
    }
};

struct native DecalProperties
{
    var() float DecalWidthLow;
    var() float DecalWidthHigh;
    var() float DecalHeightLow;
    var() float DecalHeightHigh;
    var() float DecalDepth;
    var() float DecalLifeSpan;
    var() float DecalBackfaceAngle;
    var() bool bUseRandomRotation;
    var() Vector2D DecalBlendRange;
    var() int SortOrder;
};

var() array<DecalCueEntry> DecalMaterials;

native function int PickDecalIndexToUse();
function MaterialInterface PickDecal(){}
static function SpawnDecalFromCue(DecalManager DecalMgr, DecalCue Cue, DecalProperties DecalSettings, float DepthBias, Vector PlacementLocation, Rotator ProjectionDir, optional PrimitiveComponent OverrideComponent, optional bool bProjectOnTerrain=true, optional bool bProjectOnSkeletal=true, optional TraceHitInfo HitInfo){}
static function SpawnDecal(DecalManager DecalMgr, MaterialInterface UseMaterial, DecalProperties DecalSettings, float DepthBias, Vector PlacementLocation, Rotator ProjectionDir, optional PrimitiveComponent OverrideComponent, optional bool bProjectOnTerrain, optional bool bProjectOnSkeletal, optional TraceHitInfo HitInfo){}
