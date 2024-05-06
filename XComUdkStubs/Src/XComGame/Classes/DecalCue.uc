class DecalCue extends Object
    native(Graphics)
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native DecalCueEntry
{
    var() MaterialInterface DecalMaterial;
    var() float Weight;

    structdefaultproperties
    {
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

    structdefaultproperties
    {
        DecalWidthLow=200.0
        DecalWidthHigh=200.0
        DecalHeightLow=200.0
        DecalHeightHigh=200.0
        DecalDepth=200.0
        DecalBackfaceAngle=0.0010
        bUseRandomRotation=true
        DecalBlendRange=(X=89.50,Y=180.0)
    }
};

var() array<DecalCueEntry> DecalMaterials;