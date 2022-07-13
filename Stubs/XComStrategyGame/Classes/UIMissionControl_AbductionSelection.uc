class UIMissionControl_AbductionSelection extends UIMissionControl_AlertBase;
//complete stub

const MAX_NUM_BUTTONS = 3;

var const localized string m_strConfirmLabel;
var int m_iOptionSelected;
var UIWidgetHelper m_hWidgetHelper;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UIMissionControl _screen){}
simulated function OnInit(){}
simulated function UpdateData(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function OnMenuButtonClick(){}
simulated function AS_SetHeaderLabels(string abductionSitesLabel, string panicLevelLabel, string difficultyLabel, string rewardLabel, string confirmLabel){}
simulated function AS_SetData(string countryName, int panicLevel, string Difficulty, string reward){}

defaultproperties
{
    m_iOptionSelected=-1
    s_alertName="AbductionSelection"
    m_bShowBackButtonOnMissionControl=true
}