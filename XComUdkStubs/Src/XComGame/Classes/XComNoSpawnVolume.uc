class XComNoSpawnVolume extends Volume
    native
    hidecategories(Navigation,Movement,Display);

var() bool CivilianNoSpawnZone;
var() bool AlienNoSpawnZone;

defaultproperties
{
    CivilianNoSpawnZone=true
    AlienNoSpawnZone=true
}