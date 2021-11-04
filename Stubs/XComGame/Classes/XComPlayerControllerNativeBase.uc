class XComPlayerControllerNativeBase extends GamePlayerController
    native(Core)
    config(Game)
    hidecategories(Navigation);

//complete stub

var bool m_bIsMouseActive;
var bool m_bIsConsoleBuild;
var bool m_bIsTouchEnabled;

event bool IsMouseActive(){}
event bool IsTouchEnabled(){}
event PreBeginPlay(){}
function SetIsMouseActive(bool bIsMouseActive){}
protected reliable server function ServerSetIsMouseActive(bool bIsMouseActive){}
function SetTouchEnabled(bool bTouchEnabled){}
protected reliable server function ServerSetTouchEnabled(bool bTouchEnabled){}
native simulated event TouchToggled();
function PreControllerIdChange(){}
function PostControllerIdChange(){}
event InitUniquePlayerId(){}
reliable server function ServerSetUniquePlayerId(UniqueNetId UniqueId, bool bWasInvited){}
reliable server function ServerSetPlayerSkill(int PlayerSkill){}
reliable client simulated function ClientSetOnlineStatus(){}
event Possess(Pawn aPawn, bool bVehicleTransition){}
native simulated function SetTeamType(ETeam eNewTeam);
native simulated function SetVisibleToTeams(byte eVisibleToTeamsFlags);
simulated function OnLocalPlayerTeamTypeReceived(ETeam eLocalPlayerTeam){}
simulated event ReplicatedEvent(name VarName){}
