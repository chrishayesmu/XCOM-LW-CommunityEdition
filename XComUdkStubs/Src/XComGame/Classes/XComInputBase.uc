class XComInputBase extends MobilePlayerInput within XComPlayerControllerNativeBase
    transient
    native(UI)
    config(Input)
    hidecategories(Object,UIRoot);

const RELEASE_THRESHOLD = 0.3f;
const SIGNAL_REPEAT_FREQUENCY = 0.1f;
const RSTICK_THRESHOLD = 0.5;
const LSTICK_THRESHOLD = 500;
const LSTICK_MAX_THRESHOLD = 3300;
const RSTICK_MAX_THRESHOLD = 550;
const LTRIGGER_MAX_THRESHOLD = 1.0;
const RTRIGGER_MAX_THRESHOLD = 1.0;
const STICK_REPEAT_THRESHOLD = 0.0f;

struct native TInputSubscriber
{
    var int iButton;
    var float fTimeThreshold;
    var delegate<SubscriberCallback> CallbackFunction;
};

struct native TInputIdleTracker
{
    var int iButton;
    var float fTime;
    var bool bValid;

    structdefaultproperties
    {
        iButton=-1
        fTime=-1.0
    }
};

struct native TInputEventTracker
{
    var int iButton;
    var float fTime;

    structdefaultproperties
    {
        iButton=-1
    }
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

delegate SubscriberCallback()
{
}

delegate RegistGetUserInputOK(string Caption)
{
}

delegate RegistGetUserInputCancel()
{
}

delegate bool RawInputHandler(name Key, int Actionmask, bool bCtrl, bool bAlt, bool bShift)
{
}

defaultproperties
{
    m_fLTrigger=-1.0
    m_fRTrigger=-1.0
}