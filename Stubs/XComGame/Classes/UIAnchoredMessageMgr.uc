class UIAnchoredMessageMgr extends UIMessageMgrBase
    notplaceable
    hidecategories(Navigation);

enum EUIAnchor
{
    TOP_LEFT,
    TOP_CENTER,
    TOP_RIGHT,
    CENTER_LEFT,
    Center,
    CENTER_RIGHT,
    BOTTOM_LEFT,
    BOTTOM_CENTER,
    BOTTOM_RIGHT,
    EUIAnchor_MAX
};

struct THUDAnchoredMsg
{
    var string m_sId;
    var string m_txtMsg;
    var float m_fX;
    var float m_fY;
    var bool m_bVisible;
    var EUIAnchor m_eAnchor;
    var UIMessageMgrBase.EUIIcon m_eIcon;
    var float m_fTime;

};

var private int idCounter;
var UIMessageMgr_Container m_MessageContainer;
var array<THUDAnchoredMsg> m_arrMsgs;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function Message(string _sMsg, float _xLoc, float _yLoc, UIAnchoredMessageMgr.EUIAnchor _anchor, optional float _displayTime=5.0, optional string _sId, optional UIMessageMgrBase.EUIIcon _iIcon, optional ETeam _eBroadcastToTeams){}
final simulated function CreateMessage(THUDAnchoredMsg kMsg){}
simulated function RemoveMessage(string strId){}
simulated function AS_RemoveMessageBox(string strId){}
simulated function Pause(){}
simulated function Resume(){}
simulated function Hide(){}
final simulated function RemoveMessageData(string _id){}
simulated function bool IsMessageShown(string _id){}
function EnableDepthSorting(bool bShouldSortToTop){}
