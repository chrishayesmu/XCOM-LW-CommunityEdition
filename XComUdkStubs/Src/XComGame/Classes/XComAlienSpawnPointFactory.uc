class XComAlienSpawnPointFactory extends ActorFactory
    native(Level)
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() EUnitType UnitType;

defaultproperties
{
    MenuName="Add XComSpawnPoint_Alien actor"
    NewActorClass=class'XComSpawnPoint_Alien'
}