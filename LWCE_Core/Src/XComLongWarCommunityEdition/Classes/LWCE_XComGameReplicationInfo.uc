class LWCE_XComGameReplicationInfo extends XComGameReplicationInfo;

simulated function ReceivedGameClass()
{
    super(GameReplicationInfo).ReceivedGameClass();

    if (Role == ROLE_Authority)
    {
        if (m_kGameCore == none)
        {
            `LWCE_LOG_CLS("Spawning GameCore");
            m_kGameCore = Spawn(class'LWCE_XGTacticalGameCore', self);
            m_kGameCore.Init();
        }

        if (m_kPerkTree == none)
        {
            m_kPerkTree = Spawn(class'LWCE_XComPerkManager', self);
            m_kPerkTree.Init();
        }
    }

    if (m_kCameraManager == none)
    {
        m_kCameraManager = Spawn(class'LWCE_XComCameraManager', self);
        m_kCameraManager.Init();

        if (Role < ROLE_Authority && GetALocalPlayerController() != none && GetALocalPlayerController().Pawn != none)
        {
            m_kCameraManager.AddCursor(XCom3DCursor(GetALocalPlayerController().Pawn));
        }
    }
}