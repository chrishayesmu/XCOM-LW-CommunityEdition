class UIAlert extends UI_FxsScreen;

	enum EUIAlertType
{
    eAlertType_Generic,
    eAlertType_Error,
    eAlertType_Tutorial,
    eAlertType_MAX
};

var string titleMsg;
var string bodyMsg;
var string dialogueMsg;
var EUIAlertType Type;
var float X;
var float Y;
var bool isCentered;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, string _titleMsg, string _bodyMsg, string _dialogueMsg, optional UIAlert.EUIAlertType _type, optional float _x, optional float _y, optional bool _isCentered){}

simulated function OnInit(){}

private final simulated function Alert(string _titleMsg, string _bodyMsg, string _dialogueMsg, UIAlert.EUIAlertType _type, float _x, float _y, bool _isCentered){}

simulated function bool OnUnrealCommand(int ucmd, int Arg){}

DefaultProperties
{
}
