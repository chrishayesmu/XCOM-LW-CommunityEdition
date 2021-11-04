class UICredits extends UI_FxsShellScreen
    notplaceable
    hidecategories(Navigation);
//complete stub

var const localized array<localized string> m_arrCredits;
var const localized array<localized string> m_arrCreditsEW;
var int m_iNumCreditsEntries;
var bool m_bGameOver;
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

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, bool bGameOver){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function UpdateData(){}
simulated function string ApplyStyle(string origStr){}
private final function CapitalizeHeaders(out string styledString){}
private final function ConvertHeaderToFontTag(out string styledString){}
simulated function bool OnCancel(optional string Str){}
simulated function AS_SetCredits(string sDesc){}
simulated function DEBUG_AS_SetPixelsPerSec(int pps){}
