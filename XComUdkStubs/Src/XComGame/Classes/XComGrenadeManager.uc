class XComGrenadeManager extends XComCountdownObjectManager
    notplaceable
    hidecategories(Navigation);

var array<XComDestructibleActor> m_arrDestructibleActors;
var Vector vLookAt;

defaultproperties
{
    m_fPostExplodeWait=3.0
}