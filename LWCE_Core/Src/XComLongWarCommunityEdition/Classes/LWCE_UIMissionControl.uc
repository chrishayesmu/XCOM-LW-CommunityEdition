class LWCE_UIMissionControl extends UIMissionControl;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, optional int iView = 0)
{
    BaseInit(_controllerRef, _manager);

    m_iView = iView;

    GetMgr(m_iView);
    _manager.LoadScreen(self);

    m_kHelpBar = Spawn(class'UINavigationHelp', self);
    m_kHelpBar.Init(_controllerRef, _manager, self, UpdateButtonHelp);

    m_kMissionList = Spawn(class'LWCE_UIMissionControl_MissionList', self);
    m_kMissionList.Init(_controllerRef, _manager, self);

    m_kEventList = Spawn(class'LWCE_UIStrategyComponent_EventList', self);
    m_kEventList.Init(_controllerRef, _manager, self);

    m_kClock = Spawn(class'LWCE_UIStrategyComponent_Clock', self);
    m_kClock.Init(_controllerRef, _manager, self);
}

simulated function XGMissionControlUI GetMgr(optional int iStaringView = -1)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGMissionControlUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGMissionControlUI', (self), iStaringView));
    }

    m_kLocalMgr.m_kInterface = (self);
    return m_kLocalMgr;
}

simulated function GoToView(int iView)
{
    local name AlertType;
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

            AlertType = LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert.AlertType;
            bAlertHandled = true;

            switch (AlertType)
            {
                case 'ItemProjectCompleted':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_EngineeringAlert', self);
                    break;
                case 'ResearchCompleted':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_ScienceAlert', self);
                    break;
                case 'FoundryProjectCompleted':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_FoundryAlert', self);
                    break;
                case 'NewFacilityBuilt':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_FacilityBuiltAlert', self);
                    break;
                case 'UFODetected':
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_UFORadarContactAlert', self);
                    break;
                case 'AlienBase':
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_AlienBaseAlert', self);
                    break;
                case 'CountryPanic':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_CountryPanicAlert', self);
                    break;
                case 'Terror':
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_TerrorAlert', self);
                    break;
                case 'SecretPact':
                case 'ExaltRaidFailCountry':
                case 'ExaltRaidFailContinent':
                case 'AirBaseDefenseFailed':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_SecretPactAlert', self);
                    break;
                case 'SatelliteDestroyed':
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_SatelliteDownAlert', self);
                    break;
                case 'DropArrive':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_DropshipArrivedAlert', self);
                    break;
                case 'UFOLanded':
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_UFOAlert', self);
                    m_kActiveAlert.s_alertName = "UFOLandingAlert";
                    break;
                case 'UFOCrash':
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_UFOAlert', self);
                    m_kActiveAlert.s_alertName = "UFOCrashAlert";
                    break;
                case 'UFOLost':
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_AlertBase', self);
                    m_kActiveAlert.s_alertName = "ContactLostAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case 'Abduction':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_AlertWithMultipleButtons', self);
                    m_kActiveAlert.s_alertName = "AbductionAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    break;
                case 'PsiTraining':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_AlertWithMultipleButtons', self);
                    m_kActiveAlert.s_alertName = "PsiTestingAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case 'Temple':
                    XComEngine(class'Engine'.static.GetEngine()).SetAlienFXColor(eAlienFX_Yellow);
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_AlertWithMultipleButtons', self);
                    m_kActiveAlert.s_alertName = "TempleShipAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    m_kActiveAlert.m_bShowBackButtonOnMissionControl = true;
                    break;
                case 'FCActivity':
                case 'FCMissionActivity':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_AlertBase', self);
                    m_kActiveAlert.s_alertName = "FundingCouncilAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case 'ExaltMissionActivity':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_ExaltSelection', self);
                    m_kActiveAlert.s_alertName = "ExaltSelection";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case 'ExaltResearchHack':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_ExaltResearchHack', self);
                    m_kActiveAlert.s_alertName = "ExaltSelection";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case 'ExaltAlert':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_ExaltAlert', self);
                    m_kActiveAlert.s_alertName = "ExaltAlert";
                    m_kActiveAlert.m_bIsSimpleAlert = true;
                    break;
                case 'Augmentation':
                    m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_AugmentationCompleteAlert', self);
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
                m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_AbductionSelection', self);
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

simulated function LoadFlashAlertPanel()
{
    HideNonAlertPanels();

    if (m_iView == eMCView_Abduction)
    {
        Invoke("LoadAbductionSelection");
        return;
    }

    switch (LWCE_XGMissionControlUI(GetMgr()).m_kCECurrentAlert.AlertType)
    {
        case 'UFODetected':
            Invoke("LoadRadarContactAlert");
            return;
        case 'UFOLanded':
            Invoke("LoadUFOLandedAlert");
            return;
        case 'UFOCrash':
            Invoke("LoadUFOCrashAlert");
            return;
        case 'UFOLost':
            Invoke("LoadContactLostAlert");
            return;
        case 'DropArrive':
            Invoke("LoadSkyrangerArrivalAlert");
            return;
        case 'AlienBase':
            Invoke("LoadAlienBaseAlert");
            return;
        case 'ResearchCompleted':
            Invoke("LoadScienceAlert");
            return;
        case 'ItemProjectCompleted':
            Invoke("LoadEngineeringAlert");
            return;
        case 'FoundryProjectCompleted':
            Invoke("LoadFoundryAlert");
            return;
        case 'NewFacilityBuilt':
            Invoke("LoadFacilityBuiltAlert");
            return;
        case 'Terror':
            Invoke("LoadTerrorAlert");
            return;
        case 'Abduction':
            Invoke("LoadAbductionAlert");
            return;
        case 'CountryPanic':
            Invoke("LoadCountryPanicAlert");
            return;
        case 'PsiTraining':
            Invoke("LoadPsiTestingAlert");
            return;
        case 'SecretPact':
        case 'ExaltRaidFailCountry':
        case 'ExaltRaidFailContinent':
        case 'AirBaseDefenseFailed':
            Invoke("LoadSecretPactAlert");
            return;
        case 'SatelliteDestroyed':
            Invoke("LoadSatelliteDownAlert");
            return;
        case 'Temple':
            Invoke("LoadTempleShipAlert");
            return;
        case 'FCActivity':
        case 'FCMissionActivity':
            Invoke("LoadFundingCouncilAlert");
            return;
        case 'ExaltMissionActivity':
        case 'ExaltResearchHack':
            Invoke("LoadExaltSelection");
            return;
        case 'ExaltAlert':
            Invoke("LoadExaltAlert");
            return;
        case 'Augmentation':
            Invoke("LoadAugmentationAlert");
            return;
    }
}

function UFOContact_BeginShipSelection(XGShip_UFO kTarget)
{
    if (UIMissionControl_UFORadarContactAlert(m_kActiveAlert) == none)
    {
        m_kActiveAlert = Spawn(class'LWCE_UIMissionControl_UFORadarContactAlert', self);
        m_kActiveAlert.Init(controllerRef, manager, self);
    }

    UIMissionControl_UFORadarContactAlert(m_kActiveAlert).BeginInterception(kTarget);
}

event Destroyed()
{
    m_kLocalMgr = none;
    `HQPRES.RemoveMgr(class'LWCE_XGMissionControlUI');
    super.Destroyed();
}