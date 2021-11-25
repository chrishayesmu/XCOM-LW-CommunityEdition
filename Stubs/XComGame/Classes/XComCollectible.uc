class XComCollectible extends XComDestructibleActor
    native(Destruction)
    hidecategories(Navigation);

var() EItemType CollectibleType;

native static simulated function InitCollectibles(const out array<int> InCollectibles);
native static simulated function CollectCollectibles(out array<int> OutCollectibles);
simulated event BecomeDamaged(){}