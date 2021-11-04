class XComTouchHandler extends Object
    abstract
    native;
//complete stub

const INVALID_HANDLE = -1;
const MAX_TOUCH_NUM = 2;

enum EMousePickType
{
    EMousePick_None,
    EMousePick_At_Beginning,
    EMousePick_Always,
    EMousePick_MAX
};

struct native TouchHandleData
{
    var int mHandle;
    var Vector2D mOriginalTouchLocation;
    var Vector2D mTouchLocation;
    var bool mHandledByScaleform;
};

var EDeviceType mDeviceType;
var EMousePickType mMousePickType;
var string mDeviceName;
var array<TouchHandleData> mTouchDataArray;
var int mCurrentTouchNumber;
var int mFirstTouchHandle;
var Vector2D m_v2MouseLoc;
var Vector2D m_v2MouseFrameDelta;
var protectedwrite array<string> mDebugStrings;

simulated function initTouchHandler(){}
simulated function suspendTouchHandler(){}
simulated function resumeTouchHandler(){}
simulated function beginTouchData(int Handle, Vector2D TouchLocation, optional int TouchpadIndex){}
simulated function rebeginTouchData(int Handle){}
simulated function updateTouchData(int Handle, Vector2D TouchLocation){}
simulated function handleInputTouch(int Handle, Interaction.ETouchType Type, Vector2D TouchLocation, float DeviceTimestamp, int TouchpadIndex){}
simulated function Vector2D getCurrentMouseLocation(){}
simulated function UpdateMouseLocation(Vector2D Location){}
simulated function updateTouchState();
simulated function updateMouseInteractionInterface(Vector2D pickLocation){}
simulated function clearMouseInteractionInterface(){}

state StateDefault{
simulated function resumeTouchHandler();
simulated event BeginState(name PreviousStateName){}
simulated event EndState(name NextStateName){}
simulated function updateTouchState(){}

}

state StateSuspend{
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
simulated function handleInputTouch(int Handle, Interaction.ETouchType Type, Vector2D TouchLocation, float DeviceTimestamp, int TouchpadIndex);
simulated function updateTouchState();
simulated function updateMouseInteractionInterface(Vector2D pickLocation);

}
state StateHandledByScaleForm{
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
    simulated function updateTouchState(){}
	simulated function resumeTouchHandler();
	simulated function updateMouseInteractionInterface(Vector2D pickLocation);

}