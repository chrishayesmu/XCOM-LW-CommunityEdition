class UIMissionSummary_Factors extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

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

var private XGSummaryUI m_kData;
var const localized string m_strResults;
var const localized string m_strRating;

defaultproperties
{
    s_name="factorsPage"
}