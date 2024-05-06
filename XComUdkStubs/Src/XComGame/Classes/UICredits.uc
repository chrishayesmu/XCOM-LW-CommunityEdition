class UICredits extends UI_FxsShellScreen
    notplaceable
    hidecategories(Navigation);

var const localized array<localized string> m_arrCredits;
var const localized array<localized string> m_arrCreditsEW;
var private int m_iNumCreditsEntries;
var private bool m_bGameOver;
var private string h0_tagOpen;
var private string h1_tagOpen;
var private string h2_tagOpen;
var private string h3_tagOpen;
var private string h0_tagClose;
var private string h1_tagClose;
var private string h2_tagClose;
var private string h3_tagClose;
var private string h0_pre;
var private string h0_post;
var private string h1_pre;
var private string h1_post;
var private string h2_pre;
var private string h2_post;
var private string h3_pre;
var private string h3_post;
var const localized string m_strLegal_PS3;
var const localized string m_strLegal_XBOX;
var const localized string m_strLegal_PC;

defaultproperties
{
    s_package="/ package/gfxCredits/Credits"
    s_screenId="gfxCredits"
    e_InputState=eInputState_Consume
    s_name="theScreen"
}