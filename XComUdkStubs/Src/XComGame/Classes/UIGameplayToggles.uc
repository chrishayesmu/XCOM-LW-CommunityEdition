class UIGameplayToggles extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

var const localized string m_strTitle;
var const localized string m_strWarning;
var const localized string m_arrGameplayToggleTitle[EGameplayOption];
var const localized string m_arrGameplayToggleDesc[EGameplayOption];
var const localized string m_strCanNotChangeInGame;
var private UIWidgetHelper m_hWidgetHelper;
var private UINavigationHelp m_kHelpBar;
var private bool m_bViewOnly;
var private array<int> CheckboxIndexToGameplayOptionMap;

defaultproperties
{
    s_package="/ package/gfxGameplayToggles/GameplayToggles"
    s_screenId="gfxGameplayToggles"
    e_InputState=eInputState_Consume
    s_name="theGameplayToggles"
}