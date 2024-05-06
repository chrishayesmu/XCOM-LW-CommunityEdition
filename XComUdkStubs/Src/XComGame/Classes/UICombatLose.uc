class UICombatLose extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

enum UICombatLoseType
{
    eUICombatLose_Operatives,
    eUICombatLose_Volunteer,
    eUICombatLose_HQAssault,
    eUICombatLose_MAX
};

enum UICombatLoseOption
{
    eUICombatLoseOpt_Restart,
    eUICombatLoseOpt_Reload,
    eUICombatLoseOpt_ExitToMain,
    eUICombatLoseOpt_MAX
};

var const localized string m_sVolunteerTitle;
var const localized string m_sVolunteerBody;
var const localized string m_sOperativesTitle;
var const localized string m_sOperativesBody;
var const localized string m_sHQAssaultTitle;
var const localized string m_sHQAssaultBody;
var const localized string m_sRestart;
var const localized string m_sReload;
var const localized string m_sExitToMain;
var const localized string m_kExitGameDialogue_title;
var const localized string m_kExitGameDialogue_body;
var const localized string m_sAccept;
var const localized string m_sCancel;
var private UICombatLoseType m_eType;
var private UIWidgetHelper m_hWidgetHelper;

defaultproperties
{
    s_package="/ package/gfxCombatLose/CombatLose"
    s_screenId="gfxCombatLose"
    e_InputState=eInputState_Consume
    s_name="theCombatLoseScreen"
}