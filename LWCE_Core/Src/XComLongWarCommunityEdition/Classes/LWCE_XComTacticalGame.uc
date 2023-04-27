class LWCE_XComTacticalGame extends XComTacticalGame;

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt, InOpt2, InOpt3;

    `LWCE_LOG_CLS("InitGame");

    super.InitGame(Options, ErrorMessage);
    InOpt = ParseOption(Options, "DebugCombat");

    if (InOpt != "")
    {
        bDebugCombatRequested = true;
    }

    InOpt = ParseOption(Options, "NoVictory");

    if (InOpt != "")
    {
        bNoVictory = true;
    }

    InOpt = ParseOption(Options, "SpawnGroup");

    if (InOpt != "")
    {
        ForcedSpawnGroupTag = name(InOpt);
        ForcedSpawnGroupIndex = int(Split(string(ForcedSpawnGroupTag), "Group", true));
    }
    else
    {
        ForcedSpawnGroupIndex = -1;
    }

    strSaveFile = ParseOption(Options, "SaveFile");
    InOpt = ParseOption(Options, "LoadingFromShell");
    InOpt2 = ParseOption(Options, "NoLoadingScreen");
    InOpt3 = ParseOption(Options, "LoadingFromStrategy");

    if (InOpt2 != "")
    {
        m_bDisableLoadingScreen = true;
    }

    if (InOpt != "" || InOpt2 != "" || WorldInfo.IsPlayInEditor())
    {
        m_bLoadingFromShell = true;
    }

    if (InOpt3 != "")
    {
        m_bLoadingFromShell = false;
    }
}

event GameEnding()
{
    super.GameEnding();

    `LWCE_EVENT_MGR.TriggerEvent('TacticalGameEnding', self, self);
}

defaultproperties
{
    GameReplicationInfoClass=class'LWCE_XComTacticalGRI'
    HUDType=class'LWCE_XComTacticalHUD'
    PlayerControllerClass=class'LWCE_XComTacticalController'
    TacticalSaveGameClass=class'LWCE_Checkpoint_TacticalGame'
    TransportSaveGameClass=class'LWCE_Checkpoint_StrategyTransport'
}