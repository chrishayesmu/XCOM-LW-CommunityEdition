class XGHeadquartersUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum eHQView
{
    eHQView_MainMenu,
    eHQView_MAX
};

struct THQHeader
{
    var array<TText> arrBulletins;
    var TLabeledText txtCash;
};

struct THQMainMenu
{
    var TMenu mnuOptions;
};

var THQHeader m_kHeader;
var THQMainMenu m_kMainMenu;

function UpdateView(){}
function OnMainMenuOption(int iOption);
function UpdateHeader(){}
function UpdateMainMenu(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
