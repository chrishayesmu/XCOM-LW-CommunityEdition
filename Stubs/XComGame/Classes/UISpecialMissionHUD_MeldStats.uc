class UISpecialMissionHUD_MeldStats extends UI_FxsPanel
	notplaceable
	hidecategories(Navigation);
//complete stub

struct TUIMeldCanisterData
{
	var bool bVisible;
	var bool bArrowVisible;
	var bool bActivated;
	var XComMeldContainerActor kMeldCanister;
	var UISpecialMissionHUD_TurnCounter kMeldCounter;
};

var array<TUIMeldCanisterData> m_arrMeldData;
var const localized string m_strTurnsLeftMessage;
var const localized string m_strCollectMeldMessage;
var const localized string m_strLocationUnknownLabel;
var const localized string m_strMeldLabel;
var const localized string m_strAvailableLabel;
var const localized string m_strRecoveredLabel;
var const localized string m_strLostLabel;
var XGUnit m_kActiveUnit;
var int m_iVertAdjustment;
var string m_strInteractMessage;
var XComPresentationLayer m_kPres;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function bool IsMeldContainerInteractableByUnit(XComMeldContainerActor kMeldContainer, XGUnit kUnit){}
simulated function UpdatePanel(){}
simulated function Remove(){}
