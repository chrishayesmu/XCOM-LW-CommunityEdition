class XComSpawnSalvagePoint extends Actor
    placeable
    hidecategories(Navigation);

var() ESalvageType m_eSalvageType;
var() EItemType m_eItemType;

defaultproperties
{
    Components(0)=none
    Components(1)=none
    bMovable=false
    bCollideWhenPlacing=true
}