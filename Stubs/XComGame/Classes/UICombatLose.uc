class UICombatLose extends UI_FxsScreen
	dependsOn(UIDialogueBox);

//complete stub
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
var UICombatLoseType m_eType;
var UIWidgetHelper m_hWidgetHelper;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UICombatLoseType eType){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function RequestRestart(){}
simulated function RequestLoad(){}
simulated function RequestExit(){}
simulated function ExitGameDialogueCallback(EUIAction eAction){}
simulated function AS_SetDisplay(string sTitle, string sBody, int iImage){}

