class UIDebrief extends UI_FxsScreen
    implements(IScreenMgrInterface);
//complete stub
var const localized string m_strDebrief;
var const localized string m_strKills;
var const localized string m_strMissions;
var const localized string m_strActive;
var const localized string m_strWounded;
var const localized string m_strDays;
var const localized string m_strKIA;
var const localized string m_strContinue;
var const localized string m_strPromote;
var const localized string m_strPromoteMouse;
var int m_iView;
var int m_iCurrentSelection;
var array<int> m_arrPromotedIndexes;
var XGDebriefUI m_kMgr;
var XGShip_Dropship m_kSkyranger;

function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, XGShip_Dropship kSkyranger){}
simulated function OnInit(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnAccept(optional string Arg){}
simulated function bool OnCancel(optional string Arg){}
simulated function bool OnAlternatePressed(){}
simulated function bool OnPressUp(){}
simulated function bool OnPressDown(){}
simulated function RealizeLabels(){}
simulated function ShowSoldierDebrief(){}
simulated function ShowCovertOpDebrief(){}
simulated function ShowCouncilDebrief(){}
simulated function ShowScienceDebrief(){}
function name GetViewState(int iView){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
function GoToView(int iView){}
simulated function bool IsVisible(){}
simulated function Hide(){}
simulated function Show(){}
simulated function AS_ShowSoldierDebrief(){}
simulated function AS_ShowCovertOpDebrief(){}
simulated function AS_ShowScienceDebrief(){}
simulated function AS_ShowCouncilDebrief(){}
simulated function AS_SetTitles(string debriefText, string operationTitleText, string soldierDebriefText, string scienceDebriefText, string countryDebriefText, string covertTitleText, string covertSubTitleText){}
simulated function AS_SetLabels(string killsText, string missionsText, string activeText, string woundedText, string daysText, string kiaText, string continueText, string promoteText, string promoteMouseText){}
simulated function AS_AddListHeader(int Id, string Description){}
simulated function AS_AddScienceItem(int Id, string Description, int Amount, string imagePath){}
simulated function AS_AddScienceResearch(int Id, string Title, string Description, string imagePath){}
simulated function AS_SetSoldierSelection(int iIndex){}
simulated function AS_SetSoldier(int slotId, string portraitPath, string flagImageLabel, string rankImageLabel, string classImageLabel, string nameStr, string NickName, int killsOverall, int killsThisMission, int Missions, int promoteRank, string promoteText, string classPromoteText, string Status, bool IsDead, bool isPsiPromoted){}
simulated function AS_SetShiv(int slotId, string shivName, int killsOverall, int killsThisMission, int Missions, bool IsAlive, string Status, string rankIconLabel){}
simulated function AS_SetCovertSoldier(string portraitPath, string flagImageLabel, string rankImageLabel, string classImageLabel, string nameStr, string NickName, int killsOverall, int killsThisMission, int Missions, int promoteRank, string promoteText, string classPromoteText, string Status, bool IsDead, bool isPsiPromoted){}
simulated function AS_SetCovertInfo(bool bSuccess, string feedback, string clue){}
simulated function AS_SetCouncilInfo(string Description, string rewards, string Panic){}
simulated function AS_ScrollUp(){}
simulated function AS_ScrollDown(){}
event Destroyed(){}
