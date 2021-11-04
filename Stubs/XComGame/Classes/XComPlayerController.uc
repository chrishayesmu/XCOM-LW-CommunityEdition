class XComPlayerController extends XComPlayerControllerNativeBase
    native(Core)
    config(Game)
    hidecategories(Navigation);
//complete stub

var XComPresentationLayerBase m_Pres;
var class<XComPresentationLayerBase> m_kPresentationLayerClass;
var XComWeatherControl m_kWeatherControl;
var transient float LastCheckpointSaveTime;
var bool bProfileSettingsUpdated;
var bool bIsAcceptingInvite;
var bool bVoluntarilyDisconnectingFromGame;
var bool bBlockingInputAfterMovie;
var transient bool m_bPauseFromLossOfFocus;
var transient bool m_bPauseFromGame;
var protected transient float m_fAltTabTime;

simulated function SetInputState(name nStateName);
event PostLogin(){}
event Possess(Pawn aPawn, bool bVehicleTransition){}
simulated event ReceivedPlayer(){}
simulated function InitPostProcessChains(){}
event PreBeginPlay(){}
simulated event PostBeginPlay(){}
event Destroyed(){}
simulated event OnCleanupWorld(){}
simulated event Cleanup(){}
simulated function InitPres(){}
simulated event ReplicatedEvent(name VarName){}
private final simulated function bool CanCommunicate(){}
reliable client simulated event ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject){}
reliable client simulated event TeamMessage(PlayerReplicationInfo PRI, coerce string S, name Type, optional float MsgLifeTime){}
function bool AttemptGameInviteAccepted(const out OnlineGameSearchResult InviteResult, bool bWasSuccessful){}
function StartAcceptGameInvite(){}
function OnInviteJoinComplete(name SessionName, bool bWasSuccessful){}
private final function ShellLoginDuringGameInviteComplete(bool bWasSuccessful){}
function FinishAcceptGameInvite(bool bWasSuccessful){}
function NotifyInviteFailed(){}
function NotifyNotAllPlayersCanJoinInvite(){}
function NotifyNotEnoughSpaceInInvite(){}
function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons, optional bool bDoClientRPC=true, optional bool bOverrideUserMusic){}
private final simulated function EnterCinematicModeForUserAudio(){}
private native final simulated function UpdateUserAudioForCinematicMode(bool bInCinematicMode);
function OnControllerChanged(int ControllerId, bool bIsConnected){}
event PreClientTravel(string PendingURL, Actor.ETravelType TravelType, bool bIsSeamlessTravel){}
private final simulated function OnControllerConnected(){}
private final simulated function OnControllerDisconnected(){}
simulated function XComWeatherControl WeatherControl(){}
native simulated function ShowFog(bool bShow);
event NotifyLoadedWorld(name WorldPackageName, bool bFinalDest){}
private final function int SortLoadingScreenSoldiers(XComPawn kPawn1, XComPawn kPawn2){}
exec function MapSoldiersToDropshipSeats(){}
simulated function bool IsInCinematicMode();
simulated function bool IsStartingNewGame();
simulated function bool ShouldBlockPauseMenu(){}
simulated event BlockInputAfterMovie(){}
simulated function UnblockInputAfterMovie(){}
exec function A_Button_Press(){}
exec function A_Button_Release(){}
exec function B_Button_Press(){}
exec function B_Button_Release(){}
exec function X_Button_Press(){}
exec function X_Button_Release(){}
exec function Y_Button_Press(){}
exec function Y_Button_Release(){}
exec function DPad_Right_Press(){}
exec function DPad_Right_Release(){}
exec function DPad_Left_Press(){}
exec function DPad_Left_Release(){}
exec function DPad_Up_Press(){}
exec function DPad_Up_Release(){}
exec function DPad_Down_Press(){}
exec function DPad_Down_Release(){}
exec function Back_Button_Press(){}
exec function Back_Button_Release(){}
exec function Forward_Button_Press(){}
exec function Forward_Button_Release(){}
exec function Thumb_Left_Press(){}
exec function Thumb_Left_Release(){}
exec function Thumb_Right_Press(){}
exec function Thumb_Right_Release(){}
exec function Shoulder_Left_Press(){}
exec function Shoulder_Left_Release(){}
exec function Shoulder_Right_Press(){}
exec function Shoulder_Right_Release(){}
exec function Trigger_Left_Press(){}
exec function Trigger_Left_Release(){}
exec function Trigger_Right_Press(){}
exec function Trigger_Right_Release(){}
exec function Left_Mouse_Button_Press(){}
exec function Left_Mouse_Button_Release(){}
exec function Right_Mouse_Button_Press(){}
exec function Right_Mouse_Button_Release(){}
exec function Middle_Mouse_Button_Press(){}
exec function Middle_Mouse_Button_Release(){}
exec function Mouse_Scroll_Up(){}
exec function Mouse_Scroll_Up_Release(){}
exec function Mouse_Scroll_Down(){}
exec function Mouse_Scroll_Down_Release(){}
exec function Mouse_4_Press(){}
exec function Mouse_4_Release(){}
exec function Mouse_5_Press(){}
exec function Mouse_5_Release(){}
exec function Arrow_Up(){}
exec function Arrow_Up_Release(){}
exec function Arrow_Down(){}
exec function Arrow_Down_Release(){}
exec function Arrow_Left()
{
    XComInputBase(PlayerInput).InputEvent(503);
}

exec function Arrow_Left_Release()
{
    XComInputBase(PlayerInput).InputEvent(503, 32);
}

exec function Arrow_Right()
{
    XComInputBase(PlayerInput).InputEvent(501);
}

exec function Arrow_Right_Release()
{
    XComInputBase(PlayerInput).InputEvent(501, 32);
}

exec function Escape_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(510);
}

exec function Escape_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(510, 32);
}

exec function Enter_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(511);
}

exec function Enter_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(511, 32);
}

exec function ALT_F4_QUIT()
{
    ConsoleCommand("exit");
}

exec function F1_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(600);
}

exec function F1_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(600, 32);
}

exec function F2_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(601);
}

exec function F2_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(601, 32);
}

exec function F3_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(602);
}

exec function F3_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(602, 32);
}

exec function F4_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(603);
}

exec function F4_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(603, 32);
}

exec function F5_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(604);
}

exec function F5_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(604, 32);
}

exec function F6_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(605);
}

exec function F6_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(605, 32);
}

exec function F7_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(606);
}

exec function F7_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(606, 32);
}

exec function F8_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(607);
}

exec function F8_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(607, 32);
}

exec function F9_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(608);
}

exec function F9_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(608, 32);
}

exec function F10_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(609);
}

exec function F10_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(609, 32);
}

exec function F11_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(610);
}

exec function F11_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(610, 32);
}

exec function F12_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(611);
}

exec function F12_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(611, 32);
}

exec function N1_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(612);
}

exec function N1_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(612, 32);
}

exec function N2_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(613);
}

exec function N2_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(613, 32);
}

exec function N3_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(614);
}

exec function N3_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(614, 32);
}

exec function N4_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(615);
}

exec function N4_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(615, 32);
}

exec function N5_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(616);
}

exec function N5_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(616, 32);
}

exec function N6_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(617);
}

exec function N6_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(617, 32);
}

exec function N7_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(618);
}

exec function N7_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(618, 32);
}

exec function N8_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(619);
}

exec function N8_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(619, 32);
}

exec function N9_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(620);
}

exec function N9_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(620, 32);
}

exec function N0_Key_Press()
{
    XComInputBase(PlayerInput).InputEvent(621);
}

exec function N0_Key_Release()
{
    XComInputBase(PlayerInput).InputEvent(621, 32);
}

exec function A_Key_Press()
{

        XComInputBase(PlayerInput).InputEvent(515);
}

exec function A_Key_Release()
{
        XComInputBase(PlayerInput).InputEvent(515, 32);
}

exec function D_Key_Press()
{
        XComInputBase(PlayerInput).InputEvent(518);
}

exec function D_Key_Release()
{
}

exec function E_Key_Press()
{
}

exec function E_Key_Release()
{
}

exec function F_Key_Press()
{
}

exec function F_Key_Release()
{
}

exec function J_Key_Press()
{
}

exec function J_Key_Release()
{

}

exec function C_Key_Press()
{
}

exec function C_Key_Release()
{
}

exec function G_Key_Press()
{
}

exec function G_Key_Release()
{
}

exec function K_Key_Press()
{
}

exec function K_Key_Release()
{
}

exec function O_Key_Press()
{

}

exec function O_Key_Release()
{}

exec function Q_Key_Press()
{

}

exec function Q_Key_Release()
{

}

exec function R_Key_Press()
{
}

exec function R_Key_Release()
{
}

exec function S_Key_Press()
{
}

exec function S_Key_Release()
{
}

exec function T_Key_Press()
{
}

exec function T_Key_Release()
{
}

exec function V_Key_Press()
{
}

exec function V_Key_Release()
{
}

exec function W_Key_Press()
{
}

exec function W_Key_Release()
{
}

exec function Y_Key_Press()
{
}

exec function Y_Key_Release()
{
}

exec function X_Key_Press()
{
}

exec function X_Key_Release()
{
}

exec function Backspace_Key_Press()
{
}

exec function Backspace_Key_Release()
{
}

exec function Spacebar_Key_Press()
{
}

exec function Spacebar_Key_Release()
{

}

exec function Left_Shift_Key_Press()
{
}

exec function Left_Shift_Key_Release()
{
}

exec function Home_Key_Press()
	{}

exec function Home_Key_Release()
{
}

exec function Tab_Key_Press()
{

}

exec function Tab_Key_Release()
{

}
event PreRender(Canvas Canvas){}
event PlayerTick(float DeltaTime){}
function bool InAltTab(){}
function bool SetPause(bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate=CanUnpauseDelegate, optional bool bFromLossOfFocus){}
function bool GetPauseMenuRaised(){}
function NotifyConnectionError(EProgressMessageType MessageType, optional string Message, optional string Title){}
simulated function OnDestroyedOnlineGame(name SessionName, bool bWasSuccessful){}
function bool IsInLobby(){}
