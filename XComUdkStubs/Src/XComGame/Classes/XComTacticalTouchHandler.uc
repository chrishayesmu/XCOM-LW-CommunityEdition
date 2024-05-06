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
var privatewrite bool mMultipleTouches;
var privatewrite bool mHorizontalSlideRight;
var privatewrite bool mHorizontalSlideLeft;
var privatewrite bool mOneFingerStateEnded;
var privatewrite bool mMovingActivated;
var privatewrite bool mZoomedIn;
var privatewrite bool mZoomedOut;
var privatewrite bool mRotated;
var privatewrite int mPrevioursTouchNumber;
var float mTappingRadius;
var float mTappingRadiusZoomedOut;
var privatewrite float mDraggingMovingEdgePercent;
var privatewrite float mDraggingMovingSpeed;
var privatewrite float mTappingRecenterEdgePercent;
var privatewrite float mDoubleClickSpeed;
var privatewrite float mTapSpeed;
var privatewrite int mCurrentParameterIndex;
var privatewrite float mCameraControlDeadZone;
var privatewrite array<int> mCurrentHandles;
var privatewrite float mHorizontalSlideDistance;
var privatewrite float mVerticalSlideDistance;
var privatewrite float mHorizontalSlideTangent;
var privatewrite float mHorizontalSlideDistanceMin;
var privatewrite float mHorizontalSlideAngleDeadZoneTangent;
var privatewrite int mMovingActiveFrame;
var privatewrite float mTanTheta;
var privatewrite float mOriginalDistance;
var privatewrite float mDeltaDistance;
var privatewrite float mMoveDistanceSqr;
var privatewrite float mTanMoveDirection;
var privatewrite float mZoomStep;
var privatewrite float mZoomRotationLimitTangent;
var privatewrite float mStretchDeadZone;
var privatewrite float mStretchDistance;
var privatewrite float mPinchDeadZone;
var privatewrite float mPinchDistance;
var privatewrite float mRotateDistanceLimit;
var privatewrite float mRotateDeadZoneTangent;
var privatewrite float mRotateAngelTangent;
var privatewrite float mFixDistanceDeadZone;
var privatewrite float mFingerMoveDeadZone;
var privatewrite float mDirectionAngleDeadZoneTangent;

defaultproperties
{
    mCameraControlDeadZone=0.10
}