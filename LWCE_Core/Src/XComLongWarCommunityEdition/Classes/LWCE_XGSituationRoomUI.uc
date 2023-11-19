class LWCE_XGSituationRoomUI extends XGSituationRoomUI;

struct LWCE_TSitCountry
{
    var TText txtName;
    var Color clrPanic;
    var int iPanic;
    var ESitCountryState eState;
    var TText txtFunding;
    var name nmCountry;
    var bool bClearedByClues;
    var bool bShowExaltBase;
    var EUICellState eCellState;
};

var array<LWCE_TSitCountry> m_arrCECountriesUI;

function TSitCountry BuildSitCountry(XGCountry kCountry)
{
    local TSitCountry kUI;

    `LWCE_LOG_DEPRECATED_CLS(BuildSitCountry);

    return kUI;
}

function LWCE_TSitCountry LWCE_BuildSitCountry(LWCE_XGCountry kCountry)
{
    local LWCE_TSitCountry kUI;
    local LWCE_XGExaltSimulation kExaltSim;
    local int iCollectedClueCount, iClueIndex;
    local bool bHasCell;
    local name nmSitCountry;

    kExaltSim = LWCE_XGExaltSimulation(EXALT());

    kUI.txtName.StrValue = kCountry.GetName();
    kUI.txtName.iState = eUIState_Highlight;
    kUI.clrPanic = kCountry.GetPanicColor();
    kUI.iPanic = kCountry.GetPanicBlocks();

    if (!kCountry.HasSatelliteCoverage())
    {
        kUI.txtFunding.StrValue = "+";
    }

    if (kCountry.LeftXCom())
    {
        kUI.eState = eSitCountry_Withdrawn;
        kUI.txtName.iState = eUIState_Bad;
        kUI.txtFunding.StrValue $= ConvertCashToString(kCountry.m_kTCountry.iFunding);
    }
    else
    {
        kUI.eState = eSitCountry_Normal;
        kUI.txtFunding.StrValue $= ConvertCashToString(kCountry.GetCurrentFunding());
    }

    nmSitCountry = kCountry.m_nmCountry;
    bHasCell = kExaltSim.LWCE_IsCellExposedInCountry(nmSitCountry);

    if (bHasCell)
    {
        if (kExaltSim.LWCE_IsOperativeInCountry(nmSitCountry))
        {
            if (kExaltSim.IsOperativeReadyForExtraction())
            {
                kUI.eCellState = EUI_CELL_AGENT_DONE;
            }
            else
            {
                kUI.eCellState = EUI_CELL_AGENT_OUT;
            }
        }
        else
        {
            kUI.eCellState = EUI_CELL_ACTIVE;
        }
    }
    else
    {
        kUI.eCellState = EUI_CELL_NONE;
    }

    iCollectedClueCount = kExaltSim.GetCollectedClueCount();

    if (iCollectedClueCount > 0)
    {
        for (iClueIndex = 0; iClueIndex < iCollectedClueCount; iClueIndex++)
        {
            if (kExaltSim.LWCE_IsCountryRuledOutByClueAtIndex(nmSitCountry, iClueIndex))
            {
                kUI.bClearedByClues = true;
                break;
            }
        }
    }

    kUI.bShowExaltBase = kExaltSim.LWCE_IsExaltBaseExposedInCountry(nmSitCountry);
    kUI.nmCountry = nmSitCountry;

    return kUI;
}

function int GetCountryUISlot(ECountry ECountry)
{
    `LWCE_LOG_DEPRECATED_CLS(GetCountryUISlot);

    return -1;
}

function int LWCE_GetCountryUISlot(name nmCountry)
{
    local int iCountry;

    for (iCountry = 0; iCountry < m_arrCECountriesUI.Length; iCountry++)
    {
        if (m_arrCECountriesUI[iCountry].nmCountry == nmCountry)
        {
            return iCountry;
        }
    }

    return 0;
}

function array<XGCountry> SortSitCountries()
{
    local array<XGCountry> arrCountries;

    `LWCE_LOG_DEPRECATED_CLS(SortSitCountries);

    arrCountries.Length = 0;
    return arrCountries;
}

function array<LWCE_XGCountry> LWCE_SortSitCountries()
{
    local array<LWCE_XGContinent> arrContinents;
    local array<LWCE_XGCountry> arrCountries;
    local LWCE_XGContinent kContinent;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local int iCountry;

    kWorld = LWCE_XGWorld(WORLD());
    arrContinents = kWorld.LWCE_GetContinents();

    // TODO: need some way to sort, maybe north-to-south/east-to-west? or make the templates specify, ugh
    foreach arrContinents(kContinent)
    {
        for (iCountry = 0; iCountry < kContinent.m_kTemplate.arrCountries.Length; iCountry++)
        {
            kCountry = kWorld.LWCE_GetCountry(kContinent.m_kTemplate.arrCountries[iCountry]);

            if (!kCountry.IsCouncilMember())
            {
                continue;
            }

            arrCountries.AddItem(kCountry);
        }
    }

    return arrCountries;
}

function UpdateCountries()
{
    local array<LWCE_TSitCountry> arrCountriesUI;
    local array<XGCountry> arrCountries;
    local int iCountry;

    arrCountries = SortSitCountries();
    
    for (iCountry = 0; iCountry < arrCountries.Length; iCountry++)
    {
        arrCountriesUI.AddItem(LWCE_BuildSitCountry(LWCE_XGCountry(arrCountries[iCountry])));
    }
    
    m_arrCECountriesUI = arrCountriesUI;
}

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