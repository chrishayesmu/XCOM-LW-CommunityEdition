class XComHeadQuarterTouchHandler extends XComTouchHandler
    config(Game);

var globalconfig float SoldierRotationFactor;
var globalconfig float SummaryResponseTopLeftX;
var globalconfig float SummaryResponseTopLeftY;
var globalconfig float SummaryResponseBottomRightX;
var globalconfig float SummaryResponseBottomRightY;
var globalconfig float PromotionResponseTopLeftX;
var globalconfig float PromotionResponseTopLeftY;
var globalconfig float PromotionResponseBottomRightX;
var globalconfig float PromotionResponseBottomRightY;
var globalconfig float LoadoutResponseTopLeftX;
var globalconfig float LoadoutResponseTopLeftY;
var globalconfig float LoadoutResponseBottomRightX;
var globalconfig float LoadoutResponseBottomRightY;
var globalconfig float CustomizeResponseTopLeftX;
var globalconfig float CustomizeResponseTopLeftY;
var globalconfig float CustomizeResponseBottomRightX;
var globalconfig float CustomizeResponseBottomRightY;
var globalconfig array<config Engine.EDeviceType> DeviceType;
var globalconfig array<config float> GeographicRotationMultiplier;
var globalconfig array<config float> ZoomRotationLimit;
var globalconfig array<config float> StretchDeadZone;
var globalconfig array<config float> StretchDistance;
var globalconfig array<config float> PinchDeadZone;
var globalconfig array<config float> PinchDistance;
var privatewrite float mSoldierRotationFactor;
var privatewrite float mGeographicRotationMultiplier;
var privatewrite int mCurrentParameterIndex;
var privatewrite array<int> mCurrentHandles;
var privatewrite float mTanTheta;
var privatewrite float mDeltaDistance;
var privatewrite float mZoomRotationLimitTangent;
var privatewrite bool mZoomedIn;
var privatewrite bool mZoomedOut;
var privatewrite bool mMovingActivated;
var privatewrite bool mOneFingerStateEnded;
var privatewrite float mStretchDeadZone;
var privatewrite float mStretchDistance;
var privatewrite float mOriginalDistance;
var privatewrite float mPinchDeadZone;
var privatewrite float mPinchDistance;
var privatewrite float mMoveDistanceSqr;
var privatewrite float mTanMoveDirection;
var privatewrite int mMovingActiveFrame;

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
}

state StateTwoFinger extends StateDefault
{
    simulated event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
    simulated function updateTouchState(){}
}

state StateTwoFingerZooming extends StateTwoFinger
{
    simulated event BeginState(name PreviousStateName){}
    simulated function updateTouchState(){}
}

defaultproperties
{
}