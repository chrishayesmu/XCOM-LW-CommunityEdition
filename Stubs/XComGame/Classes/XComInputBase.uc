class XComInputBase extends MobilePlayerInput within XComPlayerControllerNativeBase
	native(UI)
    config(Input);

//complete stub
struct TInputSubscriber
{
    var int iButton;
    var float fTimeThreshold;
	var delegate<SubscriberCallback> CallbackFunction;
};

struct TInputIdleTracker
{
    var int iButton;
    var float fTime;
    var bool bValid;
};

struct TInputEventTracker
{
    var int iButton;
    var float fTime;
};

var bool bAutoTest;
var bool m_bRTriggerActive;
var bool m_bConsumedByFlashCached;
var bool m_bConsumedBy3DFlashCached;
var bool m_bConsumedByFlash;
var bool mIsConsumedByFlash;
var float fAutoBaseY;
var float fAutoStrafe;
var array<TInputSubscriber> m_arrSubscribers;
var array<TInputIdleTracker> m_arrIdleTrackers;
var array<TInputEventTracker> m_arrEventTrackers;
var float m_fLTrigger;
var float m_fRTrigger;
var float m_fRTriggerAngleDegrees;
var float m_fLSXAxis;
var float m_fLSYAxis;
var float m_fRSXAxis;
var float m_fRSYAxis;
var int m_iDoubleClickNumClicks;
var float m_fDoubleClickLastClick;
var delegate<RawInputHandler> RawInputListener;
var array< delegate<RawInputHandler> > ListenersArray;
var delegate<RegistGetUserInputOK> m_userRegistUserInputOK;
var delegate<RegistGetUserInputCancel> m_userRegistUserInputCancel;
var transient XComTouchHandler mTouchHandler;
var class<XComTouchHandler> mTouchHandlerClass;
var delegate<SubscriberCallback> __SubscriberCallback__Delegate;
var delegate<RegistGetUserInputOK> __RegistGetUserInputOK__Delegate;
var delegate<RegistGetUserInputCancel> __RegistGetUserInputCancel__Delegate;
var delegate<RawInputHandler> __RawInputHandler__Delegate;

delegate SubscriberCallback();
delegate RegistGetUserInputOK(string Caption);
delegate RegistGetUserInputCancel();
exec function SubmitCustomizeString(string Caption){}
exec function CancleCustomizeString(){}
simulated function bool GetUserInput(string Title, string initString, delegate<RegistGetUserInputOK> oKDelegate, delegate<RegistGetUserInputCancel> cancelDelegate){}
delegate bool RawInputHandler(name Key, int Actionmask, bool bCtrl, bool bAlt, bool bShift);
function SetRawInputHandler(delegate<RawInputHandler> Handler){}
function RemoveRawInputHandler(delegate<RawInputHandler> Handler){}
function PreProcessInput(float DeltaTime){}
native function bool IsAppWindowFocused();
function bool UseTouchInput(){}
native simulated function Vector2D ConvertUIPointToScreenCoordinate(Vector2D kPoint);
native simulated function Vector2D ConvertScreenCoordinateToUIPoint(Vector2D kPoint);
simulated function bool TestMouseConsumedBy3DFlash(){}
private final simulated function bool TestMouseConsumedHelper(UIFxsMovie kMovie){}
native simulated function bool TestHitPointToFlash(Vector2D kPoint, UIFxsMovie kMovie);
simulated function Subscribe(int iButton, float fTimeThreshold, delegate<SubscriberCallback> delCallbackFunction){}
simulated function Unsubscribe(delegate<SubscriberCallback> delCallbackFunction){}
simulated function AddIdler(int iButton){}
simulated function RemoveIdler(int iButton){}
simulated function TInputIdleTracker GetIdler(int iButton){}
simulated function PostProcessSubscribers(float DeltaTime){}
simulated function ResetIdlerTime(int iButton){}
simulated function UIFxsMovieMgr GetUIMgr(){}
simulated event UIFxsMovie GetHUD(){}
simulated event UIFxsMovie Get3DMovie(){}
private final function bool PreProcessEventMatching(int Cmd, int Actionmask){}
event PlayerInput(float DeltaTime){}
function bool HandleExternalUIOpen(int Cmd, optional int Actionmask=1){}
final function InputEvent(int Cmd, optional int Actionmask=1){}
simulated function int PreProcessMouseInput(int Cmd, int Actionmask){}
simulated function ProcessDelayedMouseRelease(){}
simulated function PostProcessMouseMovement(){}
simulated function CheckMouseSmartToggle(int Cmd){}
simulated function bool IsMouseRangeEvent(int Cmd){}
simulated function bool IsControllerRangeEvent(int Cmd){}
simulated function bool IsKeyboardRangeEvent(int Cmd){}
simulated function bool IsEventWithinInputTypeRange(int Cmd){}
simulated function bool ProcessMouseInputThroughHUD(int Cmd, int Actionmask){}
function XComHUD GetXComHUD(){}
protected function IMouseInteractionInterface GetMouseInterfaceTarget(){}

protected function IMouseInteractionInterface GetShootEnemyTarget(){}
protected function IMouseInteractionInterface GetMouseInteractionTarget(){}
simulated function int FilterCmdForUI(int Cmd, int Actionmask){}

function bool A_Button(int Actionmask);

function bool B_Button(int Actionmask);

function bool X_Button(int Actionmask);

function bool Y_Button(int Actionmask);

function bool Bumper_Left(int Actionmask);

function bool Bumper_Right(int Actionmask);

function bool Trigger_Left(float fTrigger, int Actionmask);

function bool Trigger_Right(float fTrigger, int Actionmask);

function bool Stick_Left(float _x, float _y, int Actionmask);

function bool Stick_Right(float _x, float _y, int Actionmask);

function bool Stick_L3(int Actionmask);

function bool Stick_R3(int Actionmask);

function bool Back_Button(int Actionmask);

function bool Start_Button(int Actionmask);

function bool DPad_Right(int Actionmask);

function bool DPad_Left(int Actionmask);

function bool DPad_Up(int Actionmask);

function bool DPad_Down(int Actionmask);

function bool LMouse(int Actionmask);

function bool LMouseDelayed(int Actionmask);

function bool LDoubleClick(int Actionmask);

function bool RMouse(int Actionmask);

function bool MMouse(int Actionmask);

function bool MouseScrollUp(int Actionmask);

function bool MouseScrollDown(int Actionmask);

function bool Mouse4(int Actionmask);

function bool Mouse5(int Actionmask);

function bool ArrowUp(int Actionmask);

function bool ArrowDown(int Actionmask);

function bool ArrowLeft(int Actionmask);

function bool ArrowRight(int Actionmask);

function bool EscapeKey(int Actionmask);

function bool EnterKey(int Actionmask);

function bool Key_Backspace(int Actionmask);

function bool Key_Spacebar(int Actionmask);

function bool Key_Tab(int Actionmask);

function bool Key_Left_Shift(int Actionmask);

function bool Key_Home(int Actionmask);

function bool Key_A(int Actionmask);

function bool Key_B(int Actionmask);

function bool Key_C(int Actionmask);

function bool Key_D(int Actionmask);

function bool Key_E(int Actionmask);

function bool Key_F(int Actionmask);

function bool Key_G(int Actionmask, optional float Amount){}

function bool Key_H(int Actionmask);

function bool Key_I(int Actionmask);

function bool Key_J(int Actionmask);

function bool Key_K(int Actionmask);

function bool Key_L(int Actionmask);

function bool Key_M(int Actionmask);

function bool Key_N(int Actionmask);

function bool Key_O(int Actionmask);

function bool Key_P(int Actionmask);

function bool Key_Q(int Actionmask);

function bool Key_R(int Actionmask);

function bool Key_S(int Actionmask);

function bool Key_T(int Actionmask, optional float Amount){}

function bool Key_U(int Actionmask);

function bool Key_V(int Actionmask);

function bool Key_W(int Actionmask);

function bool Key_X(int Actionmask);

function bool Key_Y(int Actionmask);

function bool Key_Z(int Actionmask);

function bool Key_1(int Actionmask);

function bool Key_2(int Actionmask);

function bool Key_3(int Actionmask);

function bool Key_4(int Actionmask);

function bool Key_5(int Actionmask);

function bool Key_6(int Actionmask);

function bool Key_7(int Actionmask);

function bool Key_8(int Actionmask);

function bool Key_9(int Actionmask);

function bool Key(int Actionmask);

function bool Key_F1(int Actionmask);

function bool Key_F2(int Actionmask);

function bool Key_F3(int Actionmask);

function bool Key_F4(int Actionmask);

function bool Key_F5(int Actionmask);

function bool Key_F6(int Actionmask);

function bool Key_F7(int Actionmask);

function bool Key_F8(int Actionmask);

function bool Key_F9(int Actionmask);

function bool Key_F10(int Actionmask);

function bool Key_F11(int Actionmask);

function bool Key_F12(int Actionmask);

event Trigger_Left_Analog(float fAnalog)
{
    m_fLTrigger = fAnalog;
}

event Trigger_Right_Analog(float fAnalog)
{
    m_fRTrigger = fAnalog;
}

simulated function bool ButtonIsDisabled(int Cmd)
{
    return false;
}

simulated function bool PreProcessCheckGameLogic(int Cmd, int Actionmask)
{
    return false;
}
simulated function bool AllowEscKeyIfChangingInputDevice(int Cmd){}
function PostProcessInput(float DeltaTime){}
simulated function bool PostProcessCheckGameLogic(float DeltaTime){}
simulated function PostProcessJoysticks(){}
final simulated function DeactivateTracker(int Cmd, int Actionmask){}
final simulated function CheckForTap(int Cmd, int Actionmask){}
final simulated function ActivateTracker(int Cmd, int Actionmask){}
simulated function PostProcessTrackers(float DeltaTime){}
simulated function InputRepeatTimer(){}
simulated function ClearAllRepeatTimers(){}
function InitTouchSystem(){}
exec function tuneTouchConfig(string configName, float configValue){};

state DebugMenuEnabled{
	simulated function bool PreProcessCheckGameLogic(int Cmd, int Actionmask){}
	function PreProcessInput(float DeltaTime);
	event PushedState(){}
	event PoppedState(){}
}
