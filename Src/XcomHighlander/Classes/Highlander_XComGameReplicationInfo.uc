class Highlander_XComGameReplicationInfo extends XComGameReplicationInfo;

simulated function ReceivedGameClass()
{
    super(GameReplicationInfo).ReceivedGameClass();

    if (Role == ROLE_Authority)
    {
        if (m_kGameCore == none)
        {
            m_kGameCore = Spawn(class'Highlander_XGTacticalGameCore', self);
            m_kGameCore.Init();
        }

        if (m_kPerkTree == none)
        {
            m_kPerkTree = Spawn(class'XComPerkManager', self);
            m_kPerkTree.Init();
        }
    }

    if (m_kCameraManager == none)
    {
        m_kCameraManager = Spawn(class'XComCameraManager', self);
        m_kCameraManager.Init();

        if (Role < ROLE_Authority && GetALocalPlayerController() != none && GetALocalPlayerController().Pawn != none)
        {
            m_kCameraManager.AddCursor(XCom3DCursor(GetALocalPlayerController().Pawn));
        }
    }
}