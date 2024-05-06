class XGAction_Equip extends XGAction
    notplaceable
    hidecategories(Navigation);

var protected ELocation m_eSlot;
var protected XGWeapon kWeapon;

defaultproperties
{
    m_bBlocksInput=true
}