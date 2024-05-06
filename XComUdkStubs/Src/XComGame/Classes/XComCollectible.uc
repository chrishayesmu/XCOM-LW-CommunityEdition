class XComCollectible extends XComDestructibleActor
    native(Destruction)
    hidecategories(Navigation);

var() EItemType CollectibleType;

defaultproperties
{
    CollectibleType=eItem_AlienEntertainment
}