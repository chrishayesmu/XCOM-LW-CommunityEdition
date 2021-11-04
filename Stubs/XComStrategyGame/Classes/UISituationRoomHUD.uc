class UISituationRoomHUD extends UI_FxsScreen
    hidecategories(Navigation);
//complete stub

enum UISitRoomMode
{
    DISPLAY_MODE_SATELLITE,
    DISPLAY_MODE_COVERT_OPS,
    DISPLAY_MODE_TRANSITION,
    DISPLAY_MODE_RESULTS_SUCCESS,
    DISPLAY_MODE_RESULTS_FAIL,
    DISPLAY_MODE_MAX
};

var string m_strContinentName;
var string m_strContinentBodyText;
var int m_iContinentPanic;
var string m_strCountryName;
var string m_strCountryBodyText;
var int m_iCountryPanic;
var int m_eMode;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateHelpTicker(){}
simulated function SetContinentInfo(string continentName, string bodyText, int iPanic){}
simulated function AS_SetContinentInfo(string continentName, string bodyText, int iPanic){}
simulated function SetCountryInfo(string countryName, string bodyText, int iPanic){}
simulated function AS_SetCountryInfo(string countryName, string bodyText, int iPanic){}
simulated function AS_SetSatStatus(bool bHasSatellite){}
simulated function AS_SetLaunchButton(string Icon, string msg, bool bIsEnabled){}
simulated function AS_SetAccuseButton(string Icon, string msg, bool bIsEnabled){}
simulated function AS_SetDisplayMode(UISitRoomMode Mode){}
simulated function AS_SetResults(string Title, string subtitle, string Body, string countryLabel, optional string doom, optional int doomValue){}
simulated function AS_SetOkButton(string Icon, string msg){}
simulated function AS_SetCancelButton(string Icon, string msg){}
simulated function AS_SetTransitionButton(string Icon, string msg){}
simulated function AS_SetTransitionDescription(string msg){}
simulated function AS_SetIntelLabel(string headerText){}
simulated function AS_SetTickerText(string txt){}
