class UIMessageMgr_Container extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation)
	dependsOn(UIMessageMgr);

var int idCounter;
var array<UI_FxsMessageBox> Messages;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function Message(string _sMsg, optional UIMessageMgrBase.EUIIcon _iIcon=5, optional UIMessageMgr.EUIPulse _iPulse, optional float _fTime=2.0, optional string _id="default"){}
simulated function CreateMessageBox(UI_FxsMessageBox kMessageBox){}
function Build(){}
function UI_FxsMessageBox GetMessage(name Id){}
function RemoveMessageFromList(UI_FxsMessageBox targetMessage){}
function RemoveMessage(UI_FxsMessageBox targetMessage){}
