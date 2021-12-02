class Highlander_UISoldierGeneMods extends UISoldierGeneMods;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager, bool viewGenesOnly, int iSelectedRow, int iSelectedCol)
{
    BaseInit(_controllerRef, _manager);

    m_bViewOnly = viewGenesOnly;
    m_kSoldier = kSoldier;
    m_kPerkMgr = kSoldier.PERKS();
    m_kTechTree = `HQGAME.GetGameCore().GetHQ().GetLabs().m_kTree;
    m_kGeneLabs = `HQGAME.GetGameCore().GetHQ().m_kBarracks.m_kGeneLabs;

    if (iSelectedRow > -1)
    {
        m_iSelectedRow = iSelectedRow;
    }

    if (iSelectedCol > -1)
    {
        m_iSelectedColumn = iSelectedCol;
    }

    if (!`HQPRES.IsMgrRegistered(class'Highlander_XGSoldierUI'))
    {
        m_kLocalMgr = Spawn(class'Highlander_XGSoldierUI', XComHQPresentationLayer(controllerRef.m_Pres));
        m_kLocalMgr.m_kInterface = self;
        m_kLocalMgr.m_kSoldier = kSoldier;

        XComHQPresentationLayer(controllerRef.m_Pres).AddPreformedMgr(m_kLocalMgr);
        m_kLocalMgr.Init(4);
    }

    if (!m_bViewOnly)
    {
        m_kSoldier.SetHQLocation(9, true);
        m_kSoldier.PlaceOnPlinth(eSoldierLoc_GeneticsLab);
        class'SeqEvent_HQUnits'.static.PlayRoomSequence("GeneLab");
        m_strCameraTag = "GeneLab_UIDisplayCam";
        DisplayTag = 'UIDisplay_GeneLab';
        MatchCameras();
    }
    else
    {
        m_kSoldier.SetHQLocation(9, true);
        m_kSoldier.PlaceOnPlinth(eSoldierLoc_Armory);
        ShowXRayView();
        m_strCameraTag = "Armory_UIDisplayCam_Promote";
        DisplayTag = 'UIDisplay_SoldierPromote';
    }

    m_kSoldierHeader = Spawn(class'UIStrategyComponent_SoldierInfo', self);
    m_kSoldierHeader.Init(_controllerRef, _manager, self, m_kSoldier);

    m_kSoldierStats = Spawn(class'UIStrategyComponent_SoldierStats', self);
    m_kSoldierStats.Init(GetMgr(), _controllerRef, _manager, self);

    m_kAbilityList = Spawn(class'UIStrategyComponent_SoldierAbilityList', self);
    m_kAbilityList.Init(GetMgr(), _controllerRef, _manager, self);

    manager.LoadScreen(self);
}

simulated function XGSoldierUI GetMgr(optional int iStartingView = 4)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGSoldierUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGSoldierUI', self, iStartingView));
    }

    return m_kLocalMgr;
}

event Destroyed()
{
    `HQPRES.m_kStrategyHUD.AS_HideResourcesPanel();

    if (!m_bViewOnly)
    {
        `HQPRES.RemoveMgr(class'Highlander_XGSoldierUI');
    }

    m_kLocalMgr = none;
    super.Destroyed();
}