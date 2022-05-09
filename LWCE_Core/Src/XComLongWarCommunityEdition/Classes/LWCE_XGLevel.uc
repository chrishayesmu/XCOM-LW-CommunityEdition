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