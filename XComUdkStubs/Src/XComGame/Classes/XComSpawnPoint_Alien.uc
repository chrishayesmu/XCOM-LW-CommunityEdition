class XComSpawnPoint_Alien extends XComSpawnPoint
    placeable
    hidecategories(Navigation);

enum EBehavior
{
    EAIBehavior_None,
    EAIBehavior_Hunt,
    EAIBehavior_SeekActor,
    EAIBehavior_MAX
};

var() XComSpawnPoint_Alien.EBehavior m_eBehavior;
var() Actor kSeekActor;
var() float fSeekRadius;
var() bool m_bForcePlacement;
var() bool bKismetSpawnOnly;
var protected bool m_bUseAltLocation;
var protected Vector m_vAltLocation;

defaultproperties
{
    m_eBehavior=EBehavior.EAIBehavior_Hunt
    fSeekRadius=640.0
    UnitType=EUnitType.UNIT_TYPE_Alien
}