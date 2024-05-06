class XGAbility_Electropulse extends XGAbility_GameCore
    native(Core)
    config(GameCore)
    notplaceable
    hidecategories(Navigation);

var config float ElectroPulseXY_Range;
var config string ElectroPulse_OrganicFX_Path;
var config string ElectroPulse_RoboticFX_Path;

defaultproperties
{
    m_bTargetUpkeep=true
}