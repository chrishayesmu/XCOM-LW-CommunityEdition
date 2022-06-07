class LWCE_XGLevel extends XGLevel;

simulated function OnStreamingFinished()
{
    local int Index;
    local XGBattle_SP BattleSP;

    InitFractureSystems();

    if (m_kCutoutBox == none)
    {
        m_kCutoutBox = Spawn(class'XComCutoutBox', self);
    }

    WorldInfo.MyKismetVariableMgr.RebuildVariableMap();
    WorldInfo.MyKismetVariableMgr.RebuildClassMap();
    BattleSP = XGBattle_SP(`BATTLE);

    if (BattleSP != none && BattleSP.m_kDesc.m_arrArtifacts.Length > 0 && !m_bLoadingSaveGame)
    {
        `LWCE_LOG_CLS("Before InitCollectibles: BattleSP.m_kDesc.m_arrArtifacts.Length = " $ BattleSP.m_kDesc.m_arrArtifacts.Length);
        class'XComCollectible'.static.InitCollectibles(BattleSP.m_kDesc.m_arrArtifacts);
        `LWCE_LOG_CLS("After InitCollectibles: BattleSP.m_kDesc.m_arrArtifacts.Length = " $ BattleSP.m_kDesc.m_arrArtifacts.Length);

        for (Index = 0; Index < BattleSP.m_kDesc.m_arrArtifacts.Length; Index++)
        {
            if (BattleSP.m_kDesc.m_arrArtifacts[Index] > 0)
            {
                `LWCE_LOG_CLS("Artifact " $ Index $ " has quantity " $ BattleSP.m_kDesc.m_arrArtifacts[Index]);
            }
        }
    }

    m_bStreamingLevelsComplete = true;
}

state Streaming
{
    function StreamMapsIfNeeded()
    {
        local bool bIsRestart;

        bIsRestart = InStr(WorldInfo.GetLocalURL(), "restart", false, true) != INDEX_NONE;

        // Only stream maps when loading saves or doing a mission restart. When launching a mission from the strategy layer,
        // the servertravel command will include the streaming maps already, and loading them twice can cause all kinds of problems.
        if (m_bLoadingSaveGame || bIsRestart)
        {
            class'XComMapManager'.static.AddStreamingMaps(class'XComMapManager'.static.GetCurrentMapMetaData().DisplayName, /* bAllowDropshipIntro */ !m_bLoadingSaveGame);

            GetALocalPlayerController().ClientFlushLevelStreaming();
        }
    }

Begin:
    if (WorldInfo.NetMode == NM_Standalone)
    {
        StreamMapsIfNeeded();

        while (WorldInfo.bRequestedBlockOnAsyncLoading)
        {
            Sleep(0.10);
        }
    }

    if (XComEngine(class'Engine'.static.GetEngine()).MapManager != none)
    {
        SleepFrames = 0;

        while (!XComEngine(class'Engine'.static.GetEngine()).MapManager.IsInitialized())
        {
            Sleep(0.10);
            SleepFrames++;
        }

        XComEngine(class'Engine'.static.GetEngine()).MapManager.AddGlamCamMaps((WorldInfo.NetMode != NM_Standalone) || m_bLoadingSaveGame);
    }

    SleepFrames = 0;
    while (!IsLevelStreamingReplicated())
    {
        Sleep(0.10);
        SleepFrames++;
    }

    InitDynamicElements();

    SleepFrames = 0;
    Sleep(0.0);
    SleepFrames++;

    while (!IsStreamingComplete())
    {
        Sleep(0.0);
    }

    OnStreamingFinished();

    if (m_bLoadingSaveGame)
    {
        GetALocalPlayerController().RemoteEvent('CIN_DS_OnLoadedSaveGame');
    }

    GotoState('None');
    stop;
}