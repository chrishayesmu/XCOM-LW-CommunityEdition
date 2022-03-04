class UIFinalShell extends UIShell;

var const localized string m_sSinglePlayer;
var const localized string m_sMultiplayer;
var const localized string m_sExitToDesktop;
var const localized string m_strExitToPSNStoreTitle;
var const localized string m_strExitToPSNStoreBody;
var int m_iSP;
var int m_iMP;
var int m_iLoad;
var int m_iOptions;
var int m_iExit;

simulated function OnInit(){}
simulated function SetText(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated event OnCleanupWorld(){}
protected simulated function Cleanup(){}
simulated function AcceptMenu(){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function LoginStatusChange(ELoginStatus NewStatus, UniqueNetId NewId){}