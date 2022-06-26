class LWCE_UIPendingRequests extends UIPendingRequests
    dependson(LWCE_XGFundingCouncil, LWCE_XGPendingRequestsUI);

simulated function XGPendingRequestsUI GetMgr(optional int iStaringView = 0)
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGPendingRequestsUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGPendingRequestsUI', self, iStaringView));
    }

    return m_kLocalMgr;
}

event Destroyed()
{
    m_kLocalMgr = none;
    `HQPRES.RemoveMgr(class'LWCE_XGPendingRequestsUI');
    super.Destroyed();
}

function UpdateData()
{
    local LWCE_XGFundingCouncil kFundingCouncil;
    local LWCE_XGPendingRequestsUI kMgr;
    local LWCE_TFCRequest kRequest;
    local XGCountry kCountry;
    local string Status, TimeLeft;
    local bool bCanComplete, bInProgress, bIsComplete;
    local string strViewRequest, strRequest;
    local int iNumRequests, I;

    kFundingCouncil = LWCE_XGFundingCouncil(`HQGAME.GetGameCore().GetWorld().m_kFundingCouncil);
    kMgr = LWCE_XGPendingRequestsUI(GetMgr());
    iNumRequests = kMgr.GetNumOfRequests();

    if (iNumRequests > 0)
    {
        strViewRequest = m_strViewRequest;
    }
    else
    {
        strViewRequest = "";
    }

    AS_SetLabels(m_strPendingRequests, m_strFunding, m_strMissions, strViewRequest, class'UIUtilities'.default.m_strGenericCancel);
    AS_Clear();

    for (I = 0; I < iNumRequests; I++)
    {
        kRequest = kMgr.m_arrCERequests[I];
        bCanComplete = true;
        bInProgress = false;
        bIsComplete = false;

        if (kRequest.bIsTransferRequest)
        {
            if (kRequest.eType == eFCRType_JetTransfer)
            {
                if (HANGAR().IsShipInTransitTo(`HQGAME.GetGameCore().GetHQ().Country(kRequest.eRequestingCountry).GetContinent()))
                {
                    Status = m_strStatus_OperationInProgress;
                    bInProgress = true;
                }
                else if (kFundingCouncil.LWCE_CanAcceptRequest(kRequest))
                {
                    Status = m_strStatus_TransferComplete;
                    bIsComplete = true;
                }
                else if (HANGAR().m_arrInts.Length > 0)
                {
                    Status = m_strStatus_AwaitingJetTransfer;
                    bInProgress = true;
                }
                else
                {
                    Status = m_strStatus_CanNotComplete;
                    bCanComplete = false;
                }
            }
            else  if (kRequest.eType == eFCRType_SatLaunch)
            {
                if (`HQGAME.GetGameCore().GetHQ().IsSatelliteInTransitTo(kRequest.eRequestingCountry))
                {
                    Status = m_strStatus_SatelliteEnRoute;
                    bInProgress = true;
                }
                else if (kFundingCouncil.LWCE_CanAcceptRequest(kRequest))
                {
                    Status = m_strStatus_SatelliteCoverageComplete;
                    bIsComplete = true;
                }
                else if (`HQGAME.GetGameCore().GetHQ().CanLaunchSatelliteTo(kRequest.eRequestingCountry))
                {
                    Status = m_strStatus_AwaitingSatelliteCoverage;
                }
                else
                {
                    Status = m_strStatus_CanNotComplete;
                    bCanComplete = false;
                }
            }
            else if (kFundingCouncil.LWCE_CanAcceptRequest(kRequest))
            {
                Status = m_strStatus_CanComplete;
            }
            else
            {
                Status = m_strStatus_CanNotComplete;
                bCanComplete = false;
            }
        }
        else if (kFundingCouncil.LWCE_CanAcceptRequest(kRequest))
        {
            Status = m_strStatus_CanComplete;
        }
        else
        {
            Status = m_strStatus_CanNotComplete;
            bCanComplete = false;
        }

        TimeLeft = m_strHoursLeft $ ":" @ kRequest.iHoursToRespond;

        if (kRequest.eType == eFCRType_SatLaunch)
        {
            kCountry = `HQGAME.GetGameCore().GetHQ().Country(kRequest.eRequestingCountry);
            strRequest = m_strSatelliteTransferLabel $ kCountry.m_kTCountry.strName;
            AS_AddFundingRequest(I, strRequest, Status, TimeLeft, bCanComplete, bInProgress, bIsComplete);
        }
        else
        {
            AS_AddFundingRequest(I, kRequest.strName, Status, TimeLeft, bCanComplete, bInProgress, bIsComplete);
        }
    }

    if (iNumRequests > 0)
    {
        if (kMgr.m_iHighlight >= iNumRequests)
        {
            kMgr.m_iHighlight = 0;
        }

        AS_SetSelection(kMgr.m_iHighlight);
    }
}