class LWCE_UIFundingCouncilRequest extends UIFundingCouncilRequest
    dependson(LWCE_XGFundingCouncil, LWCE_XGPendingRequestsUI);

var LWCE_TFCRequest m_kCECachedRequestData;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, IFCRequestInterface kDataInterface, optional EFCRequestType eType = eFCRType_None)
{
    BaseInit(_controller, _manager);
    manager.LoadScreen(self);
    m_kDataInterface = kDataInterface;
    LWCE_IFCRequestInterface(kDataInterface).LWCE_GetRequestData(m_kCECachedRequestData);
    m_eRequestType = eType;

    if (m_eRequestType == eFCRType_None)
    {
        GotoState('Main');
    }
    else
    {
        GotoState('RequestComplete');
    }
}

simulated function XGPendingRequestsUI GetMgr()
{
    if (m_kLocalMgr == none)
    {
        m_kLocalMgr = XGPendingRequestsUI(XComHQPresentationLayer(controllerRef.m_Pres).GetMgr(class'LWCE_XGPendingRequestsUI', none, -1, true));

        if (m_kLocalMgr == none)
        {
            m_kLocalMgr = Spawn(class'LWCE_XGPendingRequestsUI');
            m_kLocalMgr.m_kInterface = self;
        }
    }

    return m_kLocalMgr;
}

simulated function bool OnAccept(optional string Arg = "")
{
    local LWCE_XGFundingCouncil kFundingCouncil;
    local LWCE_XGPendingRequestsUI kMgr;
    local bool bRequestComplete;

    kMgr = LWCE_XGPendingRequestsUI(GetMgr());
    kFundingCouncil = LWCE_XGFundingCouncil(kMgr.WORLD().m_kFundingCouncil);

    if (kMgr.m_kCERequest.txtAccept.iState != eUIState_Good)
    {
        kMgr.PlayBadSound();
        return false;
    }

    bRequestComplete = m_kDataInterface.OnAcceptRequest();

    if (bRequestComplete)
    {
        kMgr.PlayGoodSound();
        ShowRequestComplete();
        GotoState('RequestComplete');
    }
    else if (kMgr.m_kCERequest.eType == eFCRType_SatLaunch)
    {
        kMgr.PlayGoodSound();
        kFundingCouncil.m_nmPendingSatelliteRequestCountry = kMgr.m_kCERequest.nmRequestingCountry;
        `HQPRES.PopState();
        kMgr.HQ().JumpToFacility(kMgr.SITROOM(), 0.0, eSitView_Satellites);
    }

    return true;
}

function ShowRequest()
{
    local LWCE_XGPendingRequestsUI kMgr;
    local LWCE_TPendingRequest kData;

    kMgr = LWCE_XGPendingRequestsUI(GetMgr());
    kMgr.LWCE_UpdateRequest(m_kCECachedRequestData);
    kData = kMgr.m_kCERequest;

    AS_OpenSalesRequest(Caps(kData.txtTitle.StrValue),
                        Caps(kData.txtSubTitle.StrValue),
                        Caps(kData.ltxtRequired.strLabel),
                        class'UIUtilities'.static.GetHTMLColoredText(kData.ltxtRequired.StrValue, kData.ltxtRequired.iState),
                        Caps(kData.ltxtInStorage.strLabel),
                        class'UIUtilities'.static.GetHTMLColoredText(kData.ltxtInStorage.StrValue, kData.ltxtInStorage.iState),
                        Caps(kData.ltxtDueDate.strLabel),
                        class'UIUtilities'.static.GetHTMLColoredText(kData.ltxtDueDate.StrValue, kData.ltxtDueDate.iState),
                        class'UIUtilities'.static.GetHTMLColoredText(kData.txtDescription.StrValue, kData.txtDescription.iState),
                        LWCE_BuildRewardsString(),
                        kData.img.strPath,
                        /* imageScale */ 1.0,
                        Caps(kData.txtTopSecretLabel.StrValue));

    AS_SetButtonData(0, Caps(kData.txtAccept.StrValue), kData.txtAccept.iState != eUIState_Good);
    AS_SetButtonData(1, Caps(kData.txtIgnore.StrValue), kData.txtIgnore.iState != eUIState_Good);

    if (!manager.IsMouseActive())
    {
        AS_SetButtonFocus(m_iSelectedBtn, true);
    }
}

function ShowRequestComplete()
{
    local LWCE_XGPendingRequestsUI kMgr;
    local LWCE_TPendingRequest kData;
    local XGCountryTag kTag;

    kMgr = LWCE_XGPendingRequestsUI(GetMgr());
    kMgr.LWCE_UpdateRequest(m_kCECachedRequestData);
    kData = kMgr.m_kCERequest;

    kTag = new class'XGCountryTag';
    kTag.kCountry = `LWCE_XGCOUNTRY(kData.nmRequestingCountry);

    AS_OpenRequestCompleteDialog(kMgr.m_strRequestCompletedTitleLabel,
                                 Caps(kData.txtSubTitle.StrValue),
                                 kData.txtCompletion.StrValue,
                                 LWCE_BuildRewardsString(),
                                 class'XComPresentationLayerBase'.default.m_strOK);

    if (!manager.IsMouseActive())
    {
        AS_SetButtonFocus(0, true);
    }
}

protected function string LWCE_BuildRewardsString(optional bool requestCompleted = false)
{
    local LWCE_XGPendingRequestsUI kMgr;
    local string rewardStr, rewardLabel, tmpStr;
    local TText kReward;

    kMgr = LWCE_XGPendingRequestsUI(GetMgr());
    rewardStr = "";

    if (kMgr.m_kCERequest.arrRewards.Length > 0)
    {
        if (requestCompleted)
        {
            rewardLabel = Caps(class'XGPendingRequestsUI'.default.m_strLabelAwarded);
        }
        else
        {
            rewardLabel = Caps(kMgr.m_kCERequest.txtRewardLabel.StrValue);
        }

        rewardStr = class'UIUtilities'.static.GetHTMLColoredText(rewardLabel, kMgr.m_kCERequest.txtRewardLabel.iState);
        tmpStr = "";

        foreach kMgr.m_kCERequest.arrRewards(kReward)
        {
            if (Len(tmpStr) > 0)
            {
                tmpStr $= ", ";
            }

            tmpStr $= kReward.StrValue;
        }

        rewardStr @= class'UIUtilities'.static.GetHTMLColoredText(tmpStr, eUIState_Good);
    }

    return rewardStr;
}

state RequestComplete
{
    simulated function CloseScreen()
    {
        `HQPRES.PopState();

        if (m_kCECachedRequestData.eType == eFCRType_SatLaunch)
        {
            `HQPRES.m_kSituationRoom.GetSatelliteMgr().OnConfirmBonus();
        }
    }
}