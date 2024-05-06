class UIUnitFlagManager extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var private array<UIUnitFlag> m_arrFlags;
var private bool m_bDebugHardHide;
var private bool m_bFlagsInitiallyLoaded;
var bool m_bHideFriendlies;
var bool m_bHideEnemies;
var private XGUnit m_lastActiveUnit;

defaultproperties
{
    s_package="/ package/gfxUnitFlag/UnitFlag"
    s_screenId="gfxUnitFlag"
    s_name="theUnitFlagManager"
}