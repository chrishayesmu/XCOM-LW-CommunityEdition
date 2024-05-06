class XGAbility_Launch extends XGAbility_Targeted
    native(Core)
    notplaceable
    hidecategories(Navigation);

var Vector m_vDestination;
var XComPathingPawn PathingPawn;

defaultproperties
{
    m_bDelayApplyCost=true
}