class Highlander_UIMissionControl extends UIMissionControl;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, optional int iView = 0)
{
    BaseInit(_controllerRef, _manager);

    m_iView = iView;

    GetMgr(m_iView);
    _manager.LoadScreen(self);

    m_kHelpBar = Spawn(class'UINavigationHelp', self);
    m_kHelpBar.Init(_controllerRef, _manager, self, UpdateButtonHelp);

    m_kMissionList = Spawn(class'Highlander_UIMissionControl_MissionList', self);
    m_kMissionList.Init(_controllerRef, _manager, self);

    m_kEventList = Spawn(class'Highlander_UIStrategyComponent_EventList', self);
    m_kEventList.Init(_controllerRef, _manager, self);

    m_kClock = Spawn(class'Highlander_UIStrategyComponent_Clock', self);
    m_kClock.Init(_controllerRef, _manager, self);
}

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'Highlander_XGMissionControlUI', (self), iStaringView));
    }

    m_kLocalMgr.m_kInterface = (self);
    return m_kLocalMgr;
}

simulated function GoToView(int iView)
{
    local int iAlertType;
    local bool bAlertHandled;
    local UIStrategyHUD kStrategyHUD;

    m_iView = iView;

    if (!b_IsInitialized)
    {
        return;
    }

    kStrategyHUD = XComHQPresentationLayer(controllerRef.m_Pres).GetStrategyHUD();

    switch (m_iView)
    {
        case eMCView_MainMenu:
            if (kStrategyHUD != none)
            {
                kStrategyHUD.Hide();
            }

            if (IsFocused())
            {
                UpdateButtonHelp();
                m_kClock.UpdateData();
                UpdateNotices();
                Show();
            }

            XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Orange);

            break;
        case eMCView_Alert:
            if (kStrategyHUD != none)
            {
                kStrategyHUD.Hide();
            }

            iAlertType = GetMgr().m_kCurrentAlert.iAlertType;
            bAlertHandled = true;

            switch (iAlertType)
            {
                case eGA_ItemProjectCompleted:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_EngineeringAlert', self);
                    break;
                case eGA_ResearchCompleted:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_ScienceAlert', self);
                    break;
                case eGA_FoundryProjectCompleted:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_FoundryAlert', self);
                    break;
                case eGA_NewFacilityBuilt:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_FacilityBuiltAlert', self);
                    break;
                case eGA_UFODetected:
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_UFORadarContactAlert', self);
                    break;
                case eGA_AlienBase:
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_AlienBaseAlert', self);
                    break;
                case eGA_CountryPanic:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_CountryPanicAlert', self);
                    break;
                case eGA_Terror:
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_TerrorAlert', self);
                    break;
                case eGA_SecretPact:
                case eGA_ExaltRaidFailCountry:
                case eGA_ExaltRaidFailContinent:
                case 53: // Unknown, something added by Long War
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_SecretPactAlert', self);
                    break;
                case eGA_SatelliteDestroyed:
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_SatelliteDownAlert', self);
                    break;
                case eGA_DropArrive:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_DropshipArrivedAlert', self);
                    break;
                case eGA_UFOLanded:
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_UFOAlert', self);
                    m_kActiveAlert.s_alertName = "UFOLandingAlert";
                    break;
                case eGA_UFOCrash:
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_UFOAlert', self);
                    m_kActiveAlert.s_alertName = "UFOCrashAlert";
                    break;
                case eGA_UFOLost:
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_AlertBase', self);
                    m_kActiveAlert.s_alertName = "ContactLostAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case eGA_Abduction:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_AlertWithMultipleButtons', self);
                    m_kActiveAlert.s_alertName = "AbductionAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    break;
                case eGA_PsiTraining:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_AlertWithMultipleButtons', self);
                    m_kActiveAlert.s_alertName = "PsiTestingAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case eGA_Temple:
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_AlertWithMultipleButtons', self);
                    m_kActiveAlert.s_alertName = "TempleShipAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    m_kActiveAlert.m_bShowBackButtonOnMissionControl = true;
                    break;
                case eGA_FCActivity:
                case eGA_FCMissionActivity:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_AlertBase', self);
                    m_kActiveAlert.s_alertName = "FundingCouncilAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case eGA_ExaltMissionActivity:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_ExaltSelection', self);
                    m_kActiveAlert.s_alertName = "ExaltSelection";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case eGA_ExaltResearchHack:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_ExaltResearchHack', self);
                    m_kActiveAlert.s_alertName = "ExaltSelection";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case eGA_ExaltAlert:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_ExaltAlert', self);
                    m_kActiveAlert.s_alertName = "ExaltAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case eGA_Augmentation:
                    m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_AugmentationCompleteAlert', self);
                    m_kActiveAlert.s_alertName = "AugmentationAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = false;
                    break;
                default:
                    bAlertHandled = false;
                    break;
            }

            if (bAlertHandled)
            {
                m_kActiveAlert.Init(controllerRef, manager, self);
            }

            break;
        case eMCView_FCRequest:
            XComHQPresentationLayer(controllerRef.m_Pres).UIFundingCouncilRequest((GetMgr()));

            if (kStrategyHUD != none)
            {
                kStrategyHUD.Hide();
            }

            Hide();
            break;
        case eMCView_Abduction:
            if (kStrategyHUD != none)
            {
                kStrategyHUD.Hide();
            }

            if (m_kActiveAlert == none)
            {
                m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_AbductionSelection', self);
                m_kActiveAlert.Init(controllerRef, manager, self);
            }
            else
            {
                UIMissionControl_AbductionSelection(m_kActiveAlert).UpdateData();
            }

            break;
        case eMCView_ChooseShip:
            XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);

            if (kStrategyHUD != none)
            {
                kStrategyHUD.Hide();
            }

            HideNonAlertPanels();

            break;
    }
}

function UFOContact_BeginShipSelection(XGShip_UFO kTarget)
{
    if (UIMissionControl_UFORadarContactAlert(m_kActiveAlert) == none)
    {
        m_kActiveAlert = Spawn(class'Highlander_UIMissionControl_UFORadarContactAlert', self);
        m_kActiveAlert.Init(controllerRef, manager, self);
    }

    UIMissionControl_UFORadarContactAlert(m_kActiveAlert).BeginInterception(kTarget);
}

event Destroyed()
{
    m_kLocalMgr = none;
    `HQPRES.RemoveMgr(class'Highlander_XGMissionControlUI');
    super.Destroyed();
}