class UISpecialMissionHUD_MeldStats extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

struct TUIMeldCanisterData
{
    var bool bVisible;
    var bool bArrowVisible;
    var bool bActivated;
    var XComMeldContainerActor kMeldCanister;
    var UISpecialMissionHUD_TurnCounter kMeldCounter;
};

var private array<TUIMeldCanisterData> m_arrMeldData;
var const localized string m_strTurnsLeftMessage;
var const localized string m_strCollectMeldMessage;
var const localized string m_strLocationUnknownLabel;
var const localized string m_strMeldLabel;
var const localized string m_strAvailableLabel;
var const localized string m_strRecoveredLabel;
var const localized string m_strLostLabel;
var private XGUnit m_kActiveUnit;
var private int m_iVertAdjustment;
var private string m_strInteractMessage;
var XComPresentationLayer m_kPres;

defaultproperties
{
    m_iVertAdjustment=110
}