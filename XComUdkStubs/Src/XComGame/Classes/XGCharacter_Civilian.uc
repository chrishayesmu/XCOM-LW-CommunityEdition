class XGCharacter_Civilian extends XGCharacter
    notplaceable
    hidecategories(Navigation);

var string strFirstName;
var string strLastName;
var string strNickName;

defaultproperties
{
    m_eType=ePawnType_Civilian
    m_kUnitPawnClassToSpawn=class'XComCivilian'
}