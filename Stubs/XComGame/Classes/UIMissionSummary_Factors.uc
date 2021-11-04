class UIMissionSummary_Factors extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EFactorIcon
{
    eFactorIcon_DeadAliens,
    eFactorIcon_Civilians,
    eFactorIcon_DeadSoldiers,
    eFactorIcon_MissionLength,
    eFactorIcon_ResponseTime,
    eFactorIcon_DeadExalt,
    eFactorIcon_Meld,
    eFactorIcon_MAX
};

var XGSummaryUI m_kData;
var const localized string m_strResults;
var const localized string m_strRating;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen, XGSummaryUI kData){}
simulated function OnInit(){}
simulated function SetData(){}
simulated function string GetIconLabel(string factorName){}
