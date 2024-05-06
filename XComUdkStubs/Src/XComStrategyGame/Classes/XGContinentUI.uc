// Controller for UIContinentSelect screen
class XGContinentUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum EContinentView
{
    eContView_MainMenu,
    eContView_MAX
};

struct TContHeader
{
    var TText txtTitle;
};

struct TContOption
{
    var TText txtName;
    var TText txtBonusLabel;
    var TText txtBonusTitle;
    var TText txtBonusDesc;
};

struct TContMainMenu
{
    var TMenu mnuOptions;
    var array<TContOption> arrContOptions;
};

var TContHeader m_kHeader;
var TContMainMenu m_kMainMenu;
var TButtonBar m_kButtonBar;
var int m_iChosenContinent;
var array<int> m_arrContinents;
var const localized string m_strLabelBaseLocation;
var const localized string m_strLabelUnknown;
var const localized string m_strLabelPickContinent;
var const localized string m_strLabelExit;
var const localized string m_strlabelBeginGame;
var const localized string m_strLabelReturnToContinent;
var const localized string m_strLabelBonus;