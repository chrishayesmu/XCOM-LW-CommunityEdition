class XGAbility_Electropulse extends XGAbility_GameCore
    native(Core)
    config(GameCore)
    notplaceable
    hidecategories(Navigation);
//complete stub

var config float ElectroPulseXY_Range;
var config string ElectroPulse_OrganicFX_Path;
var config string ElectroPulse_RoboticFX_Path;

simulated function ApplyEffect(){}
simulated event bool CanTargetUnit(XGUnit kUnit){}

defaultproperties
{
}