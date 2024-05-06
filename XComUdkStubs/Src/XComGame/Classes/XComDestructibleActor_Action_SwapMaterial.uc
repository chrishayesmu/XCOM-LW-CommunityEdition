class XComDestructibleActor_Action_SwapMaterial extends XComDestructibleActor_Action within XComDestructibleActor
    native(Destruction)
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum MaterialSwapType
{
    SWAP_SingleIndexOnly,
    SWAP_AllIndices,
    SWAP_MAX
};

struct native MaterialSwap
{
    var() MaterialInterface SwapMaterial;
    var() XComDestructibleActor_Action_SwapMaterial.MaterialSwapType SwapType;
    var() int MaterialIndex;
};

var(XComDestructibleActor_Action) array<MaterialSwap> MaterialsToSwap;