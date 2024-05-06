class XComTacticalInput extends XComInputBase within XComPlayerControllerNativeBase
    transient
    native(UI)
    config(Input)
    hidecategories(Object,UIRoot);

const MOUSE_ZOOM_SPEED_MODIFIER = 0.01;
const MOUSE_WINDOW_SCROLL_EDGE_PERCENT = 0.01f;
const TOUCH_CHANGE_DEAD_ZONE_RADIUS = 10.0;
const MOUSE_WINDOW_LEASHED_SCROLL_EDGE_PERCENT = 0.18f;

enum EPressState
{
    ePressState_Up,
    ePressState_JustDown,
    ePressState_Down,
    ePressState_MAX
};

enum EReleaseState
{
    eReleaseState_Released,
    eReleaseState_JustReleased,
    eReleaseState_MAX
};

enum EPathingState
{
    ePathingState_None,
    ePathingState_Disabled,
    ePathingState_Enabled,
    ePathingState_MAX
};

var UIInputGate m_kInputGate;
var bool m_bLockUnitSelection;
var bool m_bInputBlocked;
var bool m_bMouseZooming;
var bool m_bReceivedPress;
var transient bool mCameraLocked;
var transient bool mDraggingCursor;
var bool m_bForceCursorPos;
var bool m_bForceDragCheck;
var() Vector2D AimSpeedMax;
var() Vector2D AimAccel;
var() Vector2D AimDecel;
var transient Vector2D ScreenAimPos;
var transient Vector2D CurrentAimSpeed;
var transient Vector2D LeftStickVector;
var transient XGUnit RightStickSelection;
var const localized string m_sHelpNoAbilitiesAvailable;
var UITutorialSaveData m_kTutorialSaveData;
var Vector2D m_vMouseCursorPos;
var Vector2D m_vMouseCursorDelta;
var float m_fRightMouseHoldTime;
var() float ScrollSpeedUnitsPerSecond;
var int PathingChangeHandle;
var transient EPressState mPressState;
var transient EReleaseState mReleaseState;
var transient EPathingState mPathingState;
var transient int mPrevioursTile[3];
var transient Vector mPrevioursLocation;
var float m_fTouchUpTimer;
var float m_fTouchDownTimer;

defaultproperties
{
    AimSpeedMax=(X=1.50,Y=1.50)
    AimAccel=(X=0.40,Y=0.40)
    AimDecel=(X=10.0,Y=10.0)
    ScrollSpeedUnitsPerSecond=1200.0
    mPrevioursTile=-1
    mTouchHandlerClass=class'XComTacticalTouchHandler'
    // Bindings=/* Array type was not detected. */
}