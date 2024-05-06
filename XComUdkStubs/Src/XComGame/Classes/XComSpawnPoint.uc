class XComSpawnPoint extends XComSpawnPointNativeBase
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Actor m_kLastActorSpawned;
};

var() EUnitType UnitType;
var XComBuildingVolume m_kVolume;
var bool m_bInside;
var bool m_bInit;
var Actor m_kLastActorSpawned;

defaultproperties
{
    Components(0)=none
    Components(1)=none
    bTickIsDisabled=true
    bMovable=false
    bCollideWhenPlacing=true
}