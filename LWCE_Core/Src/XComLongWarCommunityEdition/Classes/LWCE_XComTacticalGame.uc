class LWCE_XComTacticalGame extends XComTacticalGame;

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    return super.Login(Portal, Options, UniqueId, ErrorMessage);
}

event PostLogin(PlayerController NewPlayer)
{
    super.PostLogin(NewPlayer);
}

event GetSeamlessTravelActorList(bool bToTransitionMap, out array<Actor> ActorList)
{
    super.GetSeamlessTravelActorList(bToTransitionMap, ActorList);
}

event PostSeamlessTravel()
{
    super.PostSeamlessTravel();
}

event HandleSeamlessTravelPlayer(out Controller C)
{
    super.HandleSeamlessTravelPlayer(C);
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt, InOpt2, InOpt3;

    `LWCE_LOG_CLS("InitGame");
    Tag = 'XComTacticalGame';

    super(XComGameInfo).InitGame(Options, ErrorMessage);
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
    `LWCE_LOG_CLS("GameEnding");
    ScriptTrace();

    if (class'Engine'.static.IsSonOfFacemelt())
    {
        XComPresentationLayer(XComPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController()).m_Pres).UIPlayMovie("XEW_ShieldLogo.bik", true, true);
    }

    super.GameEnding();
}

auto state PendingMatch
{
    event BeginState(name PrevState)
    {
        super.BeginState(PrevState);
    }

    event EndState(name NextState)
    {
        super.EndState(NextState);
    }
}

defaultproperties
{
    GameReplicationInfoClass=class'LWCE_XComTacticalGRI'
    HUDType=class'LWCE_XComTacticalHUD'
    PlayerControllerClass=class'LWCE_XComTacticalController'
    TacticalSaveGameClass=class'LWCE_Checkpoint_TacticalGame'
    TransportSaveGameClass=class'LWCE_Checkpoint_StrategyTransport'
}
/*
defaultproperties
{
    m_bLoadingFromShell=true
    bUseSeamlessTravel=true
    HUDType=class'XComTacticalHUD'
    GameReplicationInfoClass=class'XComTacticalGRI'
    PlayerControllerClass=class'XComTacticalController'
    TacticalSaveGameClass=class'Checkpoint_TacticalGame'
    TransportSaveGameClass=class'Checkpoint_StrategyTransport'
}
 */
