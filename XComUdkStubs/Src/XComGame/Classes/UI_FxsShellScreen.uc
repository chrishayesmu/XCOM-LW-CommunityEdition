class UI_FxsShellScreen extends UI_FxsScreen
    native(UI)
    notplaceable
    hidecategories(Navigation);

var protected int m_iCurrentCommand;
var const localized string m_strDefaultHelp_Accept;
var const localized string m_strDefaultHelp_Cancel;
var const localized string m_strDefaultHelp_MouseNav_Accept;
var const localized string m_strDefaultHelp_MouseNav_Cancel;
var string m_strHelp_MouseNav_Accept;
var string m_strHelp_MouseNav_Cancel;
var UINavigationHelp m_kHelpBar;

delegate HelpbarDelgate()
{
}

defaultproperties
{
    e_InputState=eInputState_Evaluate
}