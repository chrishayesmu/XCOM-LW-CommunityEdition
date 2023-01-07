class XGCharacter_Tank extends XGCharacter_Soldier
    notplaceable
    hidecategories(Navigation);

defaultproperties
{
    m_eType=ePawnType_Tank
    m_kUnitPawnClassToSpawn=class'XComTank'
}