class XGAction_Path_AI extends XGAction
    notplaceable
    hidecategories(Navigation);

var Vector m_vDestination;
var() float CrumbDistance;
var bool m_bVisibleBreadcrumbs;
var bool m_bObeyMaxCosts;

defaultproperties
{
    CrumbDistance=150.0
}