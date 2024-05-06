/**
 * This class does not appear to be used anywhere.
 */
class XGInterceptionThrowdownUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum EThrowdownView
{
    eThrowdownView_MainMenu,
    eThrowdownView_Throwdown,
    eThrowdownView_MAX
};

var TText m_txtTitle;
var TButtonText m_buttonFight;
var TButtonText m_buttonChangeUFO;
var array<TButtonText> m_abuttonInterceptors;
var array<TButtonText> m_abuttonInterceptorWeapons;
var int m_iUFO;
var array<int> m_aiInterceptors;
var array<int> m_aiInterceptorWeapon;
var int m_iSelectedInterceptor;
var array<int> m_aiPrevConsumables;
var XGInterception m_kInterception;
var const localized string m_strInterceptionThrowDown;
var const localized string m_strLabelFight;
var const localized string m_strLabelNone;
var const localized string m_strShipInterceptor;
var const localized string m_strShipFirestorm;