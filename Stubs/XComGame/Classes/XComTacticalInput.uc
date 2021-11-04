class XComTacticalInput extends XComInputBase within XComPlayerControllerNativeBase
    transient
    native(UI)
    config(Input)
    hidecategories(Object,UIRoot);
//complete stub

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

simulated function UIFxsMovie GetHUD(){}
simulated function UIProtoScreen GetProtoUI();
simulated function XGUnit GetActiveUnit(){}
simulated event Camera GetPlayerCamera(){}
simulated function bool PostProcessCheckGameLogic(float DeltaTime){}
native function GetMouseCoordinates(out Vector2D vec);

simulated function ActivateInputGateSystem(bool bTurnOn){}
simulated function bool ButtonIsDisabled(int Cmd){}
simulated function bool PreProcessCheckGameLogic(int Cmd, int Actionmask){}
function Abort();
simulated function Tutorial_HowToMoveSoldiers();
simulated function Tutorial_HowToSwitchSoldiers();
simulated function Tutorial_HowToEndTurn();
function bool PrevUnit();
function bool NextUnit();
event BeginState(name nmPrevState){}
event EndState(name NextStateName){}
simulated function CheckMouseSmartToggle(int Cmd){}
simulated function PostProcessMouseMovement(){}
simulated function Mouse_CheckForWindowScroll(float fDeltaTime){}
simulated function Touch_CheckForWindowScroll(float fDeltaTime){}
simulated function bool isInSimilarLocation(Vector location1, Vector location2, optional float accurate=0.50){}
simulated function CheckRecenterCamera(Vector2D HitLocation, Vector cursorLocation){}
simulated function Mouse_CheckForZoom(){}
simulated function Controller_CheckForWindowScroll(){}
simulated function TouchController_CheckForWindowScroll(){}
function bool ClickToPath();
simulated function InitTouchSystem(){}
simulated function bool isCameraLocked(){}
simulated function CancelFiring();
simulated function NextTarget();
simulated function PrevTarget();
simulated function bool GetAdjustedMousePickPoint(out Vector kPickPoint, bool bAllowAirPicking, bool bSnapToGrid){}
simulated function Mouse_CheckForPathing(float DeltaTime);
simulated function Touch_CheckForPathing(float DeltaTime);
function QuicksaveComplete(bool bWasSuccessful){}
simulated function Mouse_CheckForFreeAim();
//simulated function Touch_CheckForFreeAim();
function bool ClickUnitToTarget(IMouseInteractionInterface MouseTarget){}
simulated function bool TargetUnit(XGUnit kTargetedUnit){}
simulated function bool ClickInterativeLevelActor(IMouseInteractionInterface MouseTarget){}
simulated function CancelMousePathing(optional bool bClearPathData=true){}
function DrawHUD(HUD HUD){}
function bool SelectSoldier(int iIndex){}
event Cleanup();

auto state InTransition
{    event BeginState(name PreviousStateName){}
    event EndState(name NextStateName){}
}

state SinglePlayerLost
{
    simulated function bool PostProcessCheckGameLogic(float DeltaTime){}
}

state Multiplayer_Inactive
{
    simulated function bool PostProcessCheckGameLogic(float DeltaTime){}
    simulated function bool PreProcessCheckGameLogic(int Cmd, int Actionmask){}
    event BeginState(name PreviousStateName){}
    function bool Start_Button(int Actionmask){}
    function bool Key_Z(int Actionmask){}
    function bool Trigger_Left(float fTrigger, int Actionmask){}
    function bool Key_T(int Actionmask, optional float Amount){}
    function bool Key_G(int Actionmask, optional float Amount){}
    function bool DPad_Right(int Actionmask){}
    function bool DPad_Left(int Actionmask){}
    function bool DPad_Up(int Actionmask){}
    function bool DPad_Down(int Actionmask){}
    function bool EscapeKey(int Actionmask){}
    function bool Key_W(int Actionmask){}
    function bool Key_A(int Actionmask){}
    function bool Key_S(int Actionmask){}
    function bool Key_D(int Actionmask){}
    function bool Key_Q(int Actionmask){}
    function bool Key_E(int Actionmask){}
    function bool Key_F(int Actionmask){}
    function bool Key_C(int Actionmask){}
    simulated function bool ArrowUp(int Actionmask){}
    simulated function bool ArrowDown(int Actionmask){}
    simulated function bool ArrowLeft(int Actionmask){}
    simulated function bool ArrowRight(int Actionmask){}
}

state Multiplayer_GameOver
{
    event BeginState(name PreviousStateName){}
    event EndState(name PreviousStateName){}
    event Cleanup(){}
    function OnExternalUIChanged(bool bIsOpening){}
    simulated function bool PreProcessCheckGameLogic(int Cmd, int Actionmask){}
    simulated function bool PostProcessCheckGameLogic(float DeltaTime){}
}

state SinglePlayer_CloseCombat
{
    event BeginState(name nmPrevState){}
    event EndState(name NextStateName){}
    function bool A_Button(int Actionmask){}
    function bool B_Button(int Actionmask){}
}
state ActiveUnit_Moving
{
    ignores Abort;

    simulated function bool PreProcessCheckGameLogic(int Cmd, int Actionmask){}
    function bool A_Button(int Actionmask){}
    function bool B_Button(int Actionmask){}
    function bool Key_X(int Actionmask){}
    function bool X_Button(int Actionmask){}
    function bool Key_Y(int Actionmask){}
    function bool Key_R(int Actionmask){}
    function bool Key_K(int Actionmask){}
    function bool Y_Button(int Actionmask){}
    function bool Mouse4(int Actionmask){}
    function bool Bumper_Right(int Actionmask){}
    function bool NextUnit(){}
    function bool Mouse5(int Actionmask){}
    function bool Bumper_Left(int Actionmask){}
    function bool PrevUnit(){}
    function bool Key_Spacebar(int Actionmask){}
    function bool Trigger_Right(float fTrigger, int Actionmask){}
    function bool Key_Left_Shift(int Actionmask){}
    function bool Key_Tab(int Actionmask){}
    private final function OpenShotHUD(){}
    function bool Key_Z(int Actionmask){}
    function bool Trigger_Left(float fTrigger, int Actionmask){}
    function bool Stick_R3(int Actionmask){}
    function bool Stick_L3(int Actionmask){}
    function bool Key_W(int Actionmask){}
    function bool Key_A(int Actionmask){}
    function bool Key_S(int Actionmask){}
    function bool Key_D(int Actionmask){}
    function bool Key_Q(int Actionmask){}
    function bool Key_E(int Actionmask){}
    function bool Key_F(int Actionmask){}
    function bool Key_C(int Actionmask){}
    function bool DPad_Right(int Actionmask){}
    function bool DPad_Left(int Actionmask){}
    function bool DPad_Up(int Actionmask){}
    function bool DPad_Down(int Actionmask){}
    function bool Back_Button(int Actionmask){}
    function bool Key_Backspace(int Actionmask){}
    function bool Start_Button(int Actionmask){}
    function bool ClickToPath(){}
    function bool LMouse(int Actionmask){}
    function bool LDoubleClick(int Actionmask){}
    function bool RMouse(int Actionmask){}
    function bool MMouse(int Actionmask){}
    function bool MouseScrollUp(int Actionmask){}
    function bool MouseScrollDown(int Actionmask){}
    function bool Key_G(int Actionmask, optional float Amount){}
    function bool Key_V(int Actionmask){}
    function bool SelectSoldier(int iIndex){}
    function bool Key_F1(int Actionmask){}
    function bool Key_F2(int Actionmask){}
    function bool Key_F3(int Actionmask){}
    function bool Key_F4(int Actionmask){}
    function bool Key_F5(int Actionmask){}
    function bool Key_F6(int Actionmask){}
    function bool Key_F7(int Actionmask){}
    function bool Key_F8(int Actionmask){}
    function bool Key_F9(int Actionmask){}
    function bool Key_F10(int Actionmask){}
    function bool ClickSoldier(IMouseInteractionInterface MouseTarget){}
    simulated function bool ArrowUp(int Actionmask){}
    simulated function bool ArrowDown(int Actionmask){}
    simulated function bool ArrowLeft(int Actionmask){}
    simulated function bool ArrowRight(int Actionmask){}
    simulated function bool EscapeKey(int Actionmask){}
    simulated function bool EnterKey(int Actionmask){}
    simulated function bool Key_Home(int Actionmask){}
    simulated function bool PostProcessCheckGameLogic(float DeltaTime){}
    simulated function bool isInSimilarLocationWithPathStart(Vector CurrentLocation, optional float accurate=0.50){}
    simulated function bool isInSimilarLocationWithPathEnd(Vector CurrentLocation, optional float accurate=0.50){}
    simulated function bool isInSimilarLocationWithPath(Vector CurrentLocation, bool StartPoint, optional float accurate=0.50){}
    simulated function bool isCursorChanged(XGAction_Path kPathAction, XCom3DCursor CURSOR, Vector CurrentLocation, optional float accurate=0.50){}
    simulated function bool isInSimilarTile(int tile1[3], int tile2[3], optional int accurate=0){}
    simulated function bool isInSimilarTileWithPathStart(int currentTile[3], optional int accurate=0){}
    simulated function bool isInSimilarTileWithPathEnd(int currentTile[3], optional int accurate=0){}
    simulated function bool isInSimilarTileWithPath(int currentTile[3], bool StartPoint, optional int accurate=0){}
    simulated function bool isCursorTileChanged(XGAction_Path kPathAction, XCom3DCursor CURSOR, Vector CurrentLocation, int currentTile[3], optional int accurate=0){}
    simulated function Vector SnapToGrid(Vector CurrentLocation, out int Tile[3]){}
    simulated function Mouse_CheckForPathing(float DeltaTime){}
    simulated function Touch_CheckForPathing(float DeltaTime){}
    function TraceVector(string txt, Vector V){};
    event BeginState(name nmPrevState){}
    event EndState(name NextStateName){}
}

state ActiveUnit_Firing
{
    ignores CancelFiring;

    event BeginState(name PrevStateName){}
    event EndState(name NextStateName){}
    function bool A_Button(int Actionmask){}
    function bool B_Button(int Actionmask){}
    function bool X_Button(int Actionmask){}
    function bool Y_Button(int Actionmask){}
    function bool Bumper_Right(int Actionmask){}
    function bool Bumper_Left(int Actionmask){}
    function bool Trigger_Right(float fTrigger, int Actionmask){}
    function bool Trigger_Left(float fTrigger, int Actionmask){}
    function bool Stick_R3(int Actionmask){}
    function bool Stick_L3(int Actionmask){}
    function bool Key_W(int Actionmask){}
    function bool Key_A(int Actionmask){}
    function bool Key_S(int Actionmask){}
    function bool Key_D(int Actionmask){}
    function bool Key_F(int Actionmask){}
    function bool Key_Q(int Actionmask){}
    function bool Key_C(int Actionmask){}
    function bool Key_E(int Actionmask){}
    simulated function bool ArrowUp(int Actionmask){}
    simulated function bool ArrowDown(int Actionmask){}
    simulated function bool ArrowLeft(int Actionmask){}
    simulated function bool ArrowRight(int Actionmask){}
    function bool DPad_Right(int Actionmask){}
    function bool DPad_Left(int Actionmask){}
    function bool DPad_Up(int Actionmask){}
    function bool DPad_Down(int Actionmask){}
    function bool Back_Button(int Actionmask){}
    function bool RMouse(int Actionmask){}
    function CalcRightStickAngle(){}
    function DrawHUD(HUD HUD){}
    function CalcCursorSpeed(float fDeltaT){}
    simulated function bool PostProcessCheckGameLogic(float DeltaTime){}
    function bool LMouse(int Actionmask){}
    function confirmFreeAimAction(){}
    function bool LDoubleClick(int Actionmask){}
    function bool LMouseDelayed(int Actionmask){}
    simulated function Touch_CheckForFreeAim(float DeltaTime){}
    simulated function bool isInRange(Vector deltaDistance, XGAction_Fire currentAction){}
    simulated function NextTarget(){}
    simulated function PrevTarget(){}
    simulated function Mouse_CheckForFreeAim(){}
}

state ActiveUnit_Firing_WithMoveCharacteristics extends ActiveUnit_Firing
{
    simulated function bool PostProcessCheckGameLogic(float DeltaTime){}
    function bool MouseScrollUp(int Actionmask){}
    function bool MouseScrollDown(int Actionmask){}
    function bool DPad_Up(int Actionmask){}
    function bool DPad_Down(int Actionmask){}
}

state DirectionalUnitSelect
{
    simulated function HideCursor(){}
    simulated function RestoreCursor(){}
    event BeginState(name PrevStateName){}
    event EndState(name NextStateName){}
    function bool Bumper_Right(int Actionmask){}
    function AimSelect(){}
    simulated function bool PostProcessCheckGameLogic(float DeltaTime){}
}
