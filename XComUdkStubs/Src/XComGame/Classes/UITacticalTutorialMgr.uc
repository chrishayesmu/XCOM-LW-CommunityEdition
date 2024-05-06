class UITacticalTutorialMgr extends Actor
    notplaceable
    hidecategories(Navigation);

var private XComPlayerController controllerRef;
var private UIFxsMovie manager;
var private XGUnit m_kActiveUnit;
var private bool m_bShowingDashHelp;
var private bool m_bShowingFlyHelp;
var private bool m_bShowingHoverHelp;
var private bool m_bShowingPrimedGrenadeHelp;
var const localized string m_strCursorHelpDashActive;
var const localized string m_strCursorHelpSprintActive;
var const localized string m_strCursorHelpFlyActive;
var const localized string m_strCursorHelpRevive;
var const localized string m_strCursorHelpStabilize;
var const localized string m_strCursorHelpStunned;
var const localized string m_strCursorHelpDead;
var const localized string m_strCursorHelpDestroyed;
var const localized string m_strCursorHelpNoFuel;
var int m_hOnOutOfRangeChange;
var int m_hOnFlyChange;
var int m_hOnHoverChange;

defaultproperties
{
    m_hOnOutOfRangeChange=-1
}