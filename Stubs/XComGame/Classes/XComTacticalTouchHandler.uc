class XComTacticalTouchHandler extends XComTouchHandler
    config(Game);

var globalconfig float DraggingMovingEdgePercent;
var globalconfig float DraggingMovingSpeed;
var globalconfig float TappingRecenterEdgePercent;
var globalconfig float DoubleClickSpeed;
var globalconfig float TapSpeed;
var globalconfig array<config EDeviceType> DeviceType;
var globalconfig array<config float> TappingRadius;
var globalconfig array<config float> TappingRadiusZoomedOut;
var globalconfig array<config float> HorizontalSlideDistance;
var globalconfig array<config float> HorizontalSlideAngleDeadZone;
var globalconfig array<config float> ZoomStep;
var globalconfig array<config float> ZoomRotationLimit;
var globalconfig array<config float> StretchDeadZone;
var globalconfig array<config float> StretchDistance;
var globalconfig array<config float> PinchDeadZone;
var globalconfig array<config float> PinchDistance;
var globalconfig array<config float> RotateDistanceLimit;
var globalconfig array<config float> RotateDeadZone;
var globalconfig array<config float> RotateAngel;
var globalconfig array<config float> FixDistanceDeadZone;
var globalconfig array<config float> FingerMoveDeadZone;
var globalconfig array<config float> DirectionAngleDeadZone;
var bool mMultipleTouches;
var bool mHorizontalSlideRight;
var bool mHorizontalSlideLeft;
var bool mOneFingerStateEnded;
var bool mMovingActivated;
var bool mZoomedIn;
var bool mZoomedOut;
var bool mRotated;
var int mPrevioursTouchNumber;
var float mTappingRadius;
var float mTappingRadiusZoomedOut;
var float mDraggingMovingEdgePercent;
var float mDraggingMovingSpeed;
var float mTappingRecenterEdgePercent;
var float mDoubleClickSpeed;
var float mTapSpeed;
var int mCurrentParameterIndex;
var float mCameraControlDeadZone;
var array<int> mCurrentHandles;
var float mHorizontalSlideDistance;
var float mVerticalSlideDistance;
var float mHorizontalSlideTangent;
var float mHorizontalSlideDistanceMin;
var float mHorizontalSlideAngleDeadZoneTangent;
var int mMovingActiveFrame;
var float mTanTheta;
var float mOriginalDistance;
var float mDeltaDistance;
var float mMoveDistanceSqr;
var float mTanMoveDirection;
var float mZoomStep;
var float mZoomRotationLimitTangent;
var float mStretchDeadZone;
var float mStretchDistance;
var float mPinchDeadZone;
var float mPinchDistance;
var float mRotateDistanceLimit;
var float mRotateDeadZoneTangent;
var float mRotateAngelTangent;
var float mFixDistanceDeadZone;
var float mFingerMoveDeadZone;
var float mDirectionAngleDeadZoneTangent;

simulated function initTouchHandler(){}
simulated function updateCurrentHandlers(){}
simulated function updateTwoFingerTouchState(){}

state StateDefault
{
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
    simulated function updateTouchState(){}
}

state StateOneFinger extends StateDefault
{
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
    simulated function updateTouchState(){}
    protected simulated function updateOneFingerTouchState(){}
}

state StateTwoFinger extends StateDefault
{
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
    simulated function updateTouchState(){}
}

state StateTwoFingerRotating extends StateTwoFinger
{
    simulated event BeginState(name PreviousStateName){}
    simulated function updateTouchState(){}
}

state StateTwoFingerZooming extends StateTwoFinger
{
    simulated event BeginState(name PreviousStateName){}
    simulated function updateTouchState(){}
}

state StateTwoFingerZoomingFloor extends StateTwoFinger
{
    simulated event BeginState(name PreviousStateName){}
    simulated function updateTouchState(){}
}