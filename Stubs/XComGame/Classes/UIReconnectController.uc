class UIReconnectController extends UIProgressDialogue
    notplaceable
    hidecategories(Navigation);

var bool m_bOnOptionsScreen;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, TProgressDialogData kData){}
simulated function bool OnCancel(optional string strOption){}
