class XComAlienSpawnVolume extends TriggerVolume
    hidecategories(Navigation,Movement,Display);

var bool bSwappingSomeone;
var() Volume Volume;
var() class<XGCharacter> UnitClass;

defaultproperties
{
    UnitClass=class'XGCharacter_Chryssalid'
}