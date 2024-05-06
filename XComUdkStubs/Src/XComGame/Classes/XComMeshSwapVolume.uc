class XComMeshSwapVolume extends TriggerVolume
    hidecategories(Navigation,Movement,Display);

var bool bSwappingSomeone;
var() class<XGCharacter> UnitClass;

defaultproperties
{
    UnitClass=class'XGCharacter_Chryssalid'
}