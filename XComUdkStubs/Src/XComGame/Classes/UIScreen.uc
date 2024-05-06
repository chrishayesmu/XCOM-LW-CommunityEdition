class UIScreen extends UIProtoScreen
    abstract
    dependson(XGNarrative, XGTacticalScreenMgr)
    notplaceable
    hidecategories(Navigation)
    implements(IScreenMgrInterface);

const DBWIDTH = 0.5f;
const DBHEIGHT = 0.4f;
const DBIMAGE_WIDTH = 0.15f;
const DBTITLE_HEIGHT = 0.05f;
const IMAGE_SPACING = 4;

struct TUITableMenu
{
    var UIProtoWidget_Text txtHeader;
    var UIProtoWidget_Menu mnuOptions;
    var array<int> arrSpacing;
};

var XGTacticalScreenMgr m_kTacMgr;
var bool m_bInited;
var bool m_bHasHelp;
var TRect m_rectHelp;
var array<TText> m_arrHelpText;
var array<TUITableMenu> m_arrTableMenus;
var array<TItemUnlock> m_arrUnlocks;
var protected Color m_clrBackground;
var protected Color m_clrHelpBackground;
var protected Color m_clrPanels;
var protected Color m_clrHeaders;
var protected Color m_clrNormal;
var protected Color m_clrHighlight;
var protected Color m_clrDisabled;
var protected Color m_clrGood;
var protected Color m_clrBad;
var protected Color m_clrWarning;
var protected Color m_clrMenuBG;
var protected Color m_clrTextNormal;
var protected Color m_clrTextHighlight;
var protected Color m_clrTextDisabled;
var protected Color m_clrTextGood;
var protected Color m_clrTextBad;
var protected Color m_clrTextWarning;
var protected Color m_clrTextTech;
var protected Color m_clrTextAlloys;
var protected Color m_clrTextElerium;
var protected Color m_clrTextCash;
var protected Color m_clrTextMenu;

defaultproperties
{
    m_clrHelpBackground=(R=0,G=0,B=0,A=128)
    m_clrPanels=(R=15,G=20,B=30,A=150)
    m_clrHeaders=(R=15,G=20,B=30,A=150)
    m_clrNormal=(R=45,G=80,B=120,A=175)
    m_clrHighlight=(R=90,G=160,B=240,A=175)
    m_clrDisabled=(R=25,G=25,B=25,A=100)
    m_clrGood=(R=0,G=200,B=0,A=175)
    m_clrBad=(R=200,G=0,B=0,A=175)
    m_clrWarning=(R=200,G=200,B=0,A=175)
    m_clrMenuBG=(R=0,G=0,B=0,A=175)
    m_clrTextNormal=(R=255,G=255,B=255,A=255)
    m_clrTextHighlight=(R=0,G=255,B=255,A=255)
    m_clrTextDisabled=(R=125,G=0,B=0,A=255)
    m_clrTextGood=(R=0,G=200,B=0,A=255)
    m_clrTextBad=(R=200,G=0,B=0,A=255)
    m_clrTextWarning=(R=200,G=200,B=0,A=255)
    m_clrTextTech=(R=175,G=0,B=175,A=255)
    m_clrTextAlloys=(R=175,G=175,B=175,A=255)
    m_clrTextElerium=(R=180,G=255,B=0,A=255)
    m_clrTextCash=(R=0,G=150,B=0,A=255)
    m_clrTextMenu=(R=25,G=225,B=255,A=255)
    e_InputState=eInputState_Consume
}