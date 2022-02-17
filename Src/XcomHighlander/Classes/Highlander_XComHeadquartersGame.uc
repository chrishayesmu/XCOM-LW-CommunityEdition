class Highlander_XComHeadquartersGame extends XComHeadquartersGame;

simulated function TItemCard GetItemCard()
{
    local TItemCard kItemCard;

    `HL_LOG_DEPRECATED_CLS(GetItemCard);

    return kItemCard;
}

simulated function HL_TItemCard HL_GetItemCard()
{
    local Highlander_XGSoldierUI kSoldierUI;
    local Highlander_XGHangarUI kHangarUI;
    local Highlander_XGEngineeringUI kEngineeringUI;
    local HL_TItemCard kBlankCard;
    local XComPlayerController PC;

    PC = XComPlayerController(PlayerController);

    if (XGFacility_Barracks(`HQGAME.GetGameCore().GetHQ().CurrentFacility()) != none)
    {
        kSoldierUI = Highlander_XGSoldierUI(XComHQPresentationLayer(PC.m_Pres).GetMgr(class'Highlander_XGSoldierUI',,, true));

        if (kSoldierUI != none && kSoldierUI.m_iCurrentView == 5)
        {
            return kSoldierUI.HL_SOLDIERUIGetItemCard();
        }
    }
    else if (XGFacility_Hangar(`HQGAME.GetGameCore().GetHQ().CurrentFacility()) != none)
    {
        kHangarUI = Highlander_XGHangarUI(XComHQPresentationLayer(PC.m_Pres).GetMgr(class'Highlander_XGHangarUI',,, true));

        if ( kHangarUI != none && (kHangarUI.m_iCurrentView == 1 || kHangarUI.m_iCurrentView == 5) )
        {
            return kHangarUI.HL_HANGARUIGetItemCard();
        }
    }
    else if (XGFacility_Engineering(`HQGAME.GetGameCore().GetHQ().CurrentFacility()) != none)
    {
        kEngineeringUI = Highlander_XGEngineeringUI(XComHQPresentationLayer(PC.m_Pres).GetMgr(class'Highlander_XGEngineeringUI',,, true));

        if (kEngineeringUI != none && kEngineeringUI.m_iCurrentView == 1)
        {
            return kEngineeringUI.HL_ENGINEERINGUIGetItemCard();
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
        m_kGameCore = Spawn(class'Highlander_XGStrategy', self);
        m_kGameCore.NewGame();
    }

    ModStartMatch();
}

defaultproperties
{
    GameReplicationInfoClass=class'Highlander_XComGameReplicationInfo'
    PlayerControllerClass=class'Highlander_XComHeadquartersController'
    TacticalSaveGameClass=class'Highlander_Checkpoint_TacticalGame'
    TransportSaveGameClass=class'Highlander_Checkpoint_StrategyTransport'
}