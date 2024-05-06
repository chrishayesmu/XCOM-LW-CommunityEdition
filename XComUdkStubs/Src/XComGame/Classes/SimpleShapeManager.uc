class SimpleShapeManager extends Actor
    notplaceable
    hidecategories(Navigation);

struct ShapePair
{
    var bool bDestroy;
    var bool bPersistent;
    var DynamicSMActor_Spawnable Shape;
};

var array<ShapePair> mShapes;