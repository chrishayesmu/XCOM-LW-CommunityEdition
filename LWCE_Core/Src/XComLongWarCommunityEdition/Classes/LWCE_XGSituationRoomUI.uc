class LWCE_XGSituationRoomUI extends XGSituationRoomUI;

function UpdateMainMenu()
{
    local LWCE_XGFundingCouncil kFundingCouncil;
    local TMenu mnuMain;
    local TMenuOption kOption;
    local array<ESitView> arrViews;

    kFundingCouncil = LWCE_XGFundingCouncil(World().m_kFundingCouncil);

    kOption.strText = m_strLabelLaunchSatellite;
    kOption.strHelp = m_strLabelMonitorUFO;
    kOption.iState = eUIState_Normal;
    mnuMain.arrOptions.AddItem(kOption);
    arrViews.AddItem(eSitView_Satellites);

    kOption.strText = m_strLabelCodeDecryption;
    kOption.strHelp = m_strLabelCodeDecrypted;
    kOption.iState = eUIState_Normal;
    mnuMain.arrOptions.AddItem(kOption);
    arrViews.AddItem(eSitView_NewObjective);

    if (EXALT().IsExaltActive())
    {
        kOption.strText = m_strLabelInfiltratorMode;
        kOption.strHelp = m_strLabelInfiltratorHelp;
        kOption.iState = eUIState_Normal;
        mnuMain.arrOptions.AddItem(kOption);
        arrViews.AddItem(eSitView_Exalt);
    }

    kOption.strText = m_strLabelViewFinances;
    kOption.strHelp = m_strLabelViewExpenditures;
    kOption.iState = eUIState_Normal;
    mnuMain.arrOptions.AddItem(kOption);
    arrViews.AddItem(eSitView_Finances);

    if (SITROOM().IsGreyMarketUnlocked())
    {
        kOption.strText = m_stdLabelVisitGreyMarket;
        kOption.strHelp = m_stdLabelVisitGreyMarketHelp;
        kOption.iState = eUIState_Normal;
        mnuMain.arrOptions.AddItem(kOption);
        arrViews.AddItem(eSitView_GreyMarket);
    }

    kOption.strText = m_strLabelPendingRequests $ " (" $ kFundingCouncil.m_arrCECurrentRequests.Length $ ")";
    kOption.strHelp = m_strLabelPendingRequestsHelp;
    kOption.iState = eUIState_Normal;

    mnuMain.arrOptions.AddItem(kOption);
    arrViews.AddItem(eSitView_PendingRequests);

    m_mnuMain = mnuMain;
    m_arrOptions = arrViews;
}

function UpdateRequest()
{
    // This doesn't appear to ever be used
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(UpdateRequest);
}

function UpdateView()
{
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGStorage kStorage;

    kLabs = LWCE_XGFacility_Labs(LABS());
    kStorage = LWCE_XGStorage(STORAGE());

    UpdateCountries();

    switch (m_iCurrentView)
    {
        case eSitView_Main:
            if (PRES().bShouldUpdateSituationRoomMenu)
            {
                UpdateMainMenu();
            }

            UpdateObjectives();
            UpdateCountries();
            UpdateCode();
            UpdateWorldMoney();
            UpdateTicker();
            UpdateDoom();
            break;
        case eSitView_Mission:
            UpdateMission();
            break;
        case eSitView_Request:
            UpdateRequest();
            break;
        case eSitView_RequestComplete:
            UpdateRequestComplete();
            break;
        case eSitView_RequestAccepted:
            UpdateRequestAccepted();
            break;
        case eSitView_RequestExpired:
            UpdateRequestExpired();
            break;
        case eSitView_NewObjective:
            break;
        case eSitView_ObjectivesMoreInfo:
            UpdateObjectives();
            break;
        case eSitView_CovertOpsExtractionMission:
            UpdateInfiltratorMission();
            break;
    }

    super(XGScreenMgr).UpdateView();

    if (m_iCurrentView == eSitView_Main && !SITROOM().m_bDisplayMissionDetails && !SITROOM().m_bDisplayExaltRaidDetails)
    {
        if (kLabs.LWCE_IsResearched('Tech_Xenobiology') && !kStorage.HasAlienCaptive() && !kLabs.HasInterrogatedCaptive())
        {
            if (Narrative(`XComNarrativeMoment("ArcThrower_LeadOut_CEN")))
            {
                return;
            }
        }

        if (kLabs.LWCE_IsResearched('Tech_AlienOperations') && !kStorage.LWCE_EverHadItem('Item_SkeletonKey'))
        {
            if (Narrative(`XComNarrativeMoment("AlienBaseDetected_LeadOut_CEN")))
            {
                return;
            }
        }

        if (kStorage.LWCE_EverHadItem('Item_Firestorm'))
        {
            if (Narrative(`XComNarrativeMoment("FirestormBuilt_LeadOut_CEN")))
            {
                return;
            }
        }

        if (Game().GetNumMissionsTaken(eMission_TerrorSite) > 0)
        {
            if (Narrative(`XComNarrativeMoment("FirstTerrorMission_LeadOut_CEN")))
            {
                return;
            }
        }

        if (kLabs.HasInterrogatedCaptive())
        {
            if (Narrative(`XComNarrativeMoment("PostInterrogation_LeadOut_CEN")))
            {
                return;
            }
        }
    }
}