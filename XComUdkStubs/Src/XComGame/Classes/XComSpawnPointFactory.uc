class XComSpawnPointFactory extends ActorFactory
    native(Level)
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() EUnitType UnitType;

defaultproperties
{
    MenuName="Add XComSpawnPoint actor"
    NewActorClass=class'XComSpawnPoint'
}