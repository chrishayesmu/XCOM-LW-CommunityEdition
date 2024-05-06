class XComTouchHandler extends Object
    abstract
    native;

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

    structdefaultproperties
    {
        mHandle=-1
    }
};

var privatewrite EDeviceType mDeviceType;
var EMousePickType mMousePickType;
var privatewrite string mDeviceName;
var privatewrite array<TouchHandleData> mTouchDataArray;
var privatewrite int mCurrentTouchNumber;
var privatewrite int mFirstTouchHandle;
var privatewrite Vector2D m_v2MouseLoc;
var privatewrite Vector2D m_v2MouseFrameDelta;
var protectedwrite array<string> mDebugStrings;

defaultproperties
{
    mDeviceType=DEVICE_PCTouch
    mMousePickType=EMousePick_At_Beginning
    mFirstTouchHandle=-1
}