class UIMessageMgr extends UIMessageMgrBase
    native(UI)
    notplaceable
    hidecategories(Navigation);

enum EUIPulse
{
    ePulse_None,
    ePulse_Cyan,
    ePulse_Blue,
    ePulse_Red,
    ePulse_MAX
};

var UIMessageMgr_Container m_MessageContainer;
var int defaultMessageID;
var UI_FxsMessageBox m_kEndTurnMessage;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function XComUIBroadcastMessage Message(string _sMsg, optional EUIIcon _iIcon=EUIIcon(5), optional EUIPulse _iPulse, optional float _fTime=2.0, optional string _id, optional ETeam _eBroadcastToTeams, optional class<XComUIBroadcastMessage> cBroadcastMessageClass){}
simulated function UI_FxsMessageBox GetMessage(name Id){}
simulated function RemoveMessage(name Id){}
simulated function Show(){}
simulated function Hide(){}
