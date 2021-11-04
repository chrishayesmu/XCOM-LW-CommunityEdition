class XComHeadquartersController extends XComPlayerController
    config(Game);
//complete stub

var bool m_bAffectsHUD;
var bool m_bInCinematicMode;

function bool SetPause(bool bPause, optional delegate<CanUnpause> CanUnpauseDelegate, optional bool bFromLossOfFocus){}
function SetCinematicMode(bool bInCinematicMode, bool bHidePlayer, bool bAffectsHUD, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsButtons, optional bool bDoClientRPC, optional bool bOverrideUserMusic){}
simulated function CinematicModeToggled(bool bInCinematicMode, bool bAffectsMovement, bool bAffectsTurning, bool bAffectsHUD){}
simulated function SetInputState(name nStateName){}
event NotifyLoadedWorld(name WorldPackageName, bool bFinalDest){}
function StartBriefing(){}
function FinishBriefing(){}
function ContinueToDestination(){}
event NotifyLoadedDestinationMap(name WorldPackageName){}
reliable client simulated function ClientSetOnlineStatus(){}
simulated function bool IsInCinematicMode(){}
simulated function bool ShouldBlockPauseMenu(){}
simulated function bool IsStartingNewGame(){}

state CinematicMode
{
    event BeginState(name PreviousStateName){}
    event EndState(name NextStateName){}
}

auto state PlayerWaiting{}

state MissionControl{
    event BeginState(name P){}
    function PlayerMove(float DeltaTime){}
}

state StrategyShell{
    event BeginState(name P){}
}

state Headquarters{

    event BeginState(name P){}
    function PlayerMove(float DeltaTime){}
}