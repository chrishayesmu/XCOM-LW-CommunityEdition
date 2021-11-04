class UISpecialMissionHUD_BombMessage extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);
//complete stub

var XGUnit m_kActiveUnit;
var int m_kWatchVar_InteractPoints;
var int m_iVertAdjustment;
var string m_sMessage;
var string m_sMessageID;
var const localized string m_strBombMessage;
var const localized string m_strActivateMessage;
var const localized string m_strOperateMesssage;
var const localized string m_strHackMessage;
var XComPresentationLayer m_kPres;

simulated function string GetInteractionMessage(XComInteractiveLevelActor KActor){}
simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function UpdateUnit(){}
function CheckIfMessageShouldHover(){}
simulated function UpdateBombHoverMessage(){}
simulated function Remove(){}
