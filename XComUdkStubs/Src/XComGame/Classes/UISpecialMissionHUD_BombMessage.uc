class UISpecialMissionHUD_BombMessage extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

var private XGUnit m_kActiveUnit;
var private int m_kWatchVar_InteractPoints;
var private int m_iVertAdjustment;
var private string m_sMessage;
var private string m_sMessageID;
var const localized string m_strBombMessage;
var const localized string m_strActivateMessage;
var const localized string m_strOperateMesssage;
var const localized string m_strHackMessage;
var XComPresentationLayer m_kPres;

defaultproperties
{
    m_kWatchVar_InteractPoints=-1
    m_iVertAdjustment=110
    m_sMessageID="ILA_Hovering_Message"
}