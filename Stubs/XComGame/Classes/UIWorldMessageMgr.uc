class UIWorldMessageMgr extends UIMessageMgrBase;
//complete stub

struct THUDMsg
{
    var string m_sId;
    var string m_txtMsg;
    var UI_FxsPanel.EWidgetColor m_eColor;
    var Vector m_vLocation;
    var bool m_bVisible;
    var bool m_bIsImportantMessage;
    var int m_eBehavior;
    var float m_fVertDiff;
    var float m_fDisplayTime;

};

var const UI_FxsPanel.EWidgetColor DAMAGE_DISPLAY_DEFAULT_COLOR;
var const string DAMAGE_DISPLAY_DEFAULT_ID;
var const bool DAMAGE_DISPLAY_DEFAULT_USE_SCREEN_LOC_PARAM;
var const Vector2D DAMAGE_DISPLAY_DEFAULT_SCREEN_LOC;
var const float DAMAGE_DISPLAY_DEFAULT_DISPLAY_TIME;
var float m_fVertDiff;
var array<THUDMsg> m_arrMsgs;
var array<int> m_arrActiveMessages;
var array<int> m_arrInactiveMessages;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function XComUIBroadcastWorldMessage Message(string _sMsg, Vector _vLocation, optional EWidgetColor _eColor, optional int _eBehavior, optional string _sId, optional ETeam _eBroadcastToTeams, optional bool _bUseScreenLocationParam, optional Vector2D _vScreenLocationParam, optional float _displayTime=5.0, optional class<XComUIBroadcastWorldMessage> _cBroadcastMessageClass){}
final simulated function CreateNewMessage(out THUDMsg kMsg){}
final simulated function UpdateExistingMessageContents(out THUDMsg kMsg){}
simulated function UpdateMessages(){}
simulated function bool UpdateMessageLocation(out THUDMsg kMsg, out Vector2D vScreenLocation){}
simulated function RemoveMessage(string _id){}
final simulated function DeactivateMessage(int msgIndex){}
final simulated function HideMessage(out THUDMsg kMsg){}
final simulated function ShowMessage(out THUDMsg kMsg){}
final simulated function AS_HideMessage(string Id){}
final simulated function AS_ShowMessage(string Id){}
static function XComUIBroadcastWorldMessage DamageDisplay(Vector vLocation, string strMessage, optional ETeam eBroadcastToTeams, optional class<XComUIBroadcastWorldMessage> cBroadcastMessageClass){}

simulated state Active
{
    simulated event Tick(float fDeltaT){}
}
