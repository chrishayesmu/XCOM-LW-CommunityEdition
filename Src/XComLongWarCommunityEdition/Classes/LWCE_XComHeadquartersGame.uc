class LWCE_XComHeadquartersGame extends XComHeadquartersGame;

simulated function TItemCard GetItemCard()
{
    local TItemCard kItemCard;

    `LWCE_LOG_DEPRECATED_CLS(GetItemCard);

    return kItemCard;
}

simulated function LWCE_TItemCard LWCE_GetItemCard()
{
    local LWCE_XGSoldierUI kSoldierUI;
    local LWCE_XGHangarUI kHangarUI;
    local LWCE_XGEngineeringUI kEngineeringUI;
    local LWCE_TItemCard kBlankCard;
    local XComPlayerController PC;

    PC = XComPlayerController(PlayerController);

    if (XGFacility_Barracks(`HQGAME.GetGameCore().GetHQ().CurrentFacility()) != none)
    {
        kSoldierUI = LWCE_XGSoldierUI(XComHQPresentationLayer(PC.m_Pres).GetMgr(class'LWCE_XGSoldierUI',,, true));

        if (kSoldierUI != none && kSoldierUI.m_iCurrentView == 5)
        {
            return kSoldierUI.LWCE_SOLDIERUIGetItemCard();
        }
    }
    else if (XGFacility_Hangar(`HQGAME.GetGameCore().GetHQ().CurrentFacility()) != none)
    {
        kHangarUI = LWCE_XGHangarUI(XComHQPresentationLayer(PC.m_Pres).GetMgr(class'LWCE_XGHangarUI',,, true));

        if ( kHangarUI != none && (kHangarUI.m_iCurrentView == 1 || kHangarUI.m_iCurrentView == 5) )
        {
            return kHangarUI.LWCE_HANGARUIGetItemCard();
        }
    }
    else if (XGFacility_Engineering(`HQGAME.GetGameCore().GetHQ().CurrentFacility()) != none)
    {
        kEngineeringUI = LWCE_XGEngineeringUI(XComHQPresentationLayer(PC.m_Pres).GetMgr(class'LWCE_XGEngineeringUI',,, true));

        if (kEngineeringUI != none && kEngineeringUI.m_iCurrentView == 1)
        {
            return kEngineeringUI.LWCE_ENGINEERINGUIGetItemCard();
        }
    }

    return kBlankCard;
}

function StartMatch()
{
    local bool bStandardLoad, bTransferLoad;
    local XComOnlineEventMgr OnlineEventMgr;

    super(GameInfo).StartMatch();

    InitResources();
    InitEarth();

    PlayerController.ClientSetOnlineStatus();
    OnlineEventMgr = XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager);
    bStandardLoad = OnlineEventMgr.bPerformingStandardLoad;
    bTransferLoad = OnlineEventMgr.bPerformingTransferLoad;

    if (bStandardLoad || bTransferLoad)
    {
        if (bStandardLoad)
        {
            OnlineEventMgr.FinishLoadGame();
            KillTransports();
        }
        else
        {
            OnlineEventMgr.FinishLoadFromStoredStrategy();
            OnlineEventMgr.LoadTransport();
        }

        foreach AllActors(class'XGStrategy', m_kGameCore)
        {
            break;
        }

        m_kGameCore.OnLoadedGame();
    }
    else
    {
        m_kGameCore = Spawn(class'LWCE_XGStrategy', self);
        m_kGameCore.NewGame();
    }

    ModStartMatch();
}

defaultproperties
{
    GameReplicationInfoClass=class'LWCE_XComGameReplicationInfo'
    PlayerControllerClass=class'LWCE_XComHeadquartersController'
    TacticalSaveGameClass=class'LWCE_Checkpoint_TacticalGame'
    TransportSaveGameClass=class'LWCE_Checkpoint_StrategyTransport'
}