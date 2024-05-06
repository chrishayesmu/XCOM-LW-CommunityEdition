class UIEnemyArrowContainer extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var protected array<XGUnit> arrCurrent;
var protected XGUnit m_kNextTarget;
var protected XGUnit m_kPrevTarget;

defaultproperties
{
    s_package="/ package/gfxEnemyArrows/EnemyArrows"
    s_screenId="gfxEnemyArrows"
    s_name="theArrowContainer"
}