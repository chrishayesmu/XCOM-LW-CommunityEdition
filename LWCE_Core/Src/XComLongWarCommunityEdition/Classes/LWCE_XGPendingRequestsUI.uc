class LWCE_XGPendingRequestsUI extends XGPendingRequestsUI
    implements(LWCE_IFCRequestInterface);

struct LWCE_TPendingRequest
{
    var ECountry eRequestingCountry;
    var EFCRequestType eType;
    var TText txtTitle;
    var TText txtSubTitle;
    var TText txtTopSecretLabel;
    var TText txtDescription;
    var TText txtCompletion;
    var TLabeledText ltxtDueDate;
    var TLabeledText ltxtRequired;
    var TLabeledText ltxtInStorage;
    var TText txtRewardLabel;
    var array<TText> arrRewards;
    var TButtonText txtAccept;
    var TButtonText txtIgnore;
    var TImage img;
};

var const localized string m_strDefenseIncrease;
var const localized string m_strDefenseReduction;
var const localized string m_strPanicIncrease;
var const localized string m_strPanicReduction;

var array<LWCE_TFCRequest> m_arrCERequests;
var LWCE_TPendingRequest m_kCERequest;

function BuildItemList()
{
    local LWCE_XGFundingCouncil kFundingCouncil;
    local int Index;

    kFundingCouncil = LWCE_XGFundingCouncil(World().m_kFundingCouncil);

    m_arrCERequests.Remove(0, m_arrCERequests.Length);

    for (Index = 0; Index < kFundingCouncil.m_arrCECurrentRequests.Length; Index++)
    {
        m_arrCERequests.AddItem(kFundingCouncil.m_arrCECurrentRequests[Index]);
    }
}

function BuildSelectedRequest()
{
    local LWCE_XGFundingCouncil kFundingCouncil;
    local LWCE_TFCRequest kRequest;

    kFundingCouncil = LWCE_XGFundingCouncil(World().m_kFundingCouncil);
    kRequest = kFundingCouncil.m_arrCECurrentRequests[m_iHighlight];

    if (kRequest.arrRequestedItems.Length > 0)
    {
        m_bCanDoSelectedRequest = kFundingCouncil.LWCE_CanAcceptRequest(kRequest);

        if (m_bCanDoSelectedRequest)
        {
            LWCE_UpdateRequest(kRequest);
        }
    }
    else
    {
        m_bCanDoSelectedRequest = false;
    }
}

function bool CanSelectCurrentRequest()
{
    if (m_arrCERequests.Length <= 0)
    {
        return false;
    }

    if (m_iHighlight > m_arrCERequests.Length)
    {
        return false;
    }

    if (m_arrCERequests[m_iHighlight].RequestName == '')
    {
        return false;
    }

    return true;
}

function TFCRequest GetHLRequest()
{
    local TFCRequest kRequest;

    `LWCE_LOG_DEPRECATED_CLS(GetHLRequest);

    return kRequest;
}

function LWCE_TFCRequest LWCE_GetHLRequest()
{
    return m_arrCERequests[m_iHighlight];
}

function int GetNumOfRequests()
{
    return m_arrCERequests.Length;
}

simulated function GetRequestData(out TFCRequest kRequestRef)
{
    `LWCE_LOG_DEPRECATED_CLS(GetRequestData);
}

simulated function LWCE_GetRequestData(out LWCE_TFCRequest kRequestRef)
{
    kRequestRef = LWCE_XGFundingCouncil(World().m_kFundingCouncil).m_arrCECurrentRequests[m_iHighlight];
}

simulated function bool OnAcceptRequest()
{
    if (m_arrCERequests.Length > 0 && World().m_kFundingCouncil.AttemptTurnInRequest(m_iHighlight))
    {
        PlayGoodSound();
        m_iHighlight = 0;
        GoToView(ePRequest_Main);
        return true;
    }
    else
    {
        PlayCloseSound();
    }

    return false;
}

function OnHighlightDown()
{
    if (m_iCurrentView == ePRequest_Selected)
    {
        return;
    }

    if (m_iHighlight < m_arrCERequests.Length - 1)
    {
        m_iHighlight += 1;
        UpdateView();
    }
    else
    {
        PlayBadSound();
    }
}

function string RewardToString(EFCRewardType eReward, int iAmount)
{
    `LWCE_LOG_DEPRECATED_CLS(RewardToString);
    return "";
}

function array<string> LWCE_RewardToString(LWCE_TRequestReward kReward, ECountry eRequestingCountry)
{
    local LWCEItemTemplate kItem;
    local XGParamTag kTag;
    local array<string> arrStrings;
    local string strReward;
    local int Index;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));

    if (kReward.iCash > 0)
    {
        strReward = ConvertCashToString(kReward.iCash);
        arrStrings.AddItem(strReward);
    }

    if (kReward.iEngineers > 0)
    {
        kTag.IntValue0 = kReward.iEngineers;
        strReward = class'XComLocalizer'.static.ExpandString(m_strNumEngineers);
        arrStrings.AddItem(strReward);
    }

    if (kReward.iScientists > 0)
    {
        kTag.IntValue0 = kReward.iScientists;
        strReward = class'XComLocalizer'.static.ExpandString(m_strNumScientist);
        arrStrings.AddItem(strReward);
    }

    if (kReward.iPanic != 0)
    {
        kTag.IntValue0 = kReward.iPanic;
        strReward = kReward.iPanic > 0 ? class'XComLocalizer'.static.ExpandString(m_strPanicIncrease) : class'XComLocalizer'.static.ExpandString(m_strPanicReduction);
        arrStrings.AddItem(strReward);
    }

    for (Index = 0; Index < kReward.arrItemRewards.Length; Index++)
    {
        kItem = `LWCE_ITEM(kReward.arrItemRewards[Index].ItemName);
        kTag.IntValue0 = kReward.arrItemRewards[Index].iQuantity;
        kTag.StrValue0 = kReward.arrItemRewards[Index].iQuantity != 1 ? kItem.strNamePlural : kItem.strName;

        strReward = class'XComLocalizer'.static.ExpandString(m_strValueRequested);
        arrStrings.AddItem(strReward);
    }

    for (Index = 0; Index < kReward.arrSoldiers.Length; Index++)
    {
        kTag.StrValue0 = RewardSoldierToString(kReward.arrSoldiers[Index]);
        strReward = class'XComLocalizer'.static.ExpandString(m_strNewRecruit);
        arrStrings.AddItem(strReward);
    }

    // Country defense: always show last since it's pretty much always the same
    if (kReward.iCountryDefense != 0)
    {
        kTag.IntValue0 = kReward.iCountryDefense;
        kTag.StrValue0 = Country(eRequestingCountry).m_kTCountry.strName;
        strReward = kReward.iCountryDefense > 0 ? class'XComLocalizer'.static.ExpandString(m_strDefenseIncrease) : class'XComLocalizer'.static.ExpandString(m_strDefenseReduction);
        arrStrings.AddItem(strReward);
    }

    // Remove trailing whitespace from any strings, since some of the base game localization has it
    for (Index = 0; Index < arrStrings.Length; Index++)
    {
        if (Right(arrStrings[Index], 1) == " ")
        {
            arrStrings[Index] = Left(arrStrings[Index], Len(arrStrings[Index]) - 1);
        }
    }

    return arrStrings;
}

function UpdateRequest(TFCRequest kRequest)
{
    `LWCE_LOG_DEPRECATED_CLS(UpdateRequest);
}

function LWCE_UpdateRequest(LWCE_TFCRequest kRequest)
{
    local array<string> arrRewardStrings;
    local bool bAllRequestedItemsAvailable;
    local int iNumAvailable, Index;
    local LWCEItemTemplate kDisplayItem, kItem;
    local LWCE_TPendingRequest kUI;
    local TText kText;
    local XGParamTag kTag;

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kUI.eType = kRequest.eType;

    if (kRequest.eType == eFCRType_SatLaunch)
    {
        kDisplayItem = `LWCE_ITEM('Item_Satellite');
    }
    else if (kRequest.eType == eFCRType_JetTransfer)
    {
        kDisplayItem = `LWCE_ITEM('Item_Interceptor');
    }
    else
    {
        kDisplayItem = `LWCE_ITEM(kRequest.arrRequestedItems[0].ItemName);
    }

    kUI.eRequestingCountry = kRequest.eRequestingCountry;
    kUI.img.strPath = kDisplayItem.ImagePath;

    kTag.StrValue0 = Country(kRequest.eRequestingCountry).m_kTCountry.strName;
    kUI.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strTitleLabel);
    kUI.txtTitle.iState = eUIState_Warning;

    kUI.txtSubTitle.StrValue = (kRequest.arrRequestedItems.Length > 0 && kRequest.arrRequestedItems[0].iQuantity != 1) ? kDisplayItem.strNamePlural : kDisplayItem.strName;
    kUI.txtDescription.StrValue = kRequest.strIntro;
    kUI.txtDescription.iState = eUIState_Normal;

    kUI.txtCompletion.StrValue = kRequest.strCompletion;

    // Text for requested items
    kUI.ltxtRequired.strLabel = m_strLabelRequested;
    kUI.ltxtRequired.iState = eUIState_Warning;

    kUI.ltxtInStorage.strLabel = m_strLabelInStorage;

    bAllRequestedItemsAvailable = true;

    for (Index = 0; Index < kRequest.arrRequestedItems.Length; Index++)
    {
        kItem = `LWCE_ITEM(kRequest.arrRequestedItems[Index].ItemName);

        kTag.IntValue0 = kRequest.arrRequestedItems[Index].iQuantity;
        kTag.StrValue0 = kRequest.arrRequestedItems[Index].iQuantity != 1 ? kItem.strNamePlural : kItem.strName;
        kUI.ltxtRequired.StrValue $= class'XComLocalizer'.static.ExpandString(m_strValueRequested);

        iNumAvailable = LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable(kRequest.arrRequestedItems[Index].ItemName);
        kTag.IntValue0 = iNumAvailable;
        kTag.StrValue0 = iNumAvailable != 1 ? kItem.strNamePlural : kItem.strName;
        kUI.ltxtInStorage.StrValue $= class'XComLocalizer'.static.ExpandString(m_strValueRequested);

        if (iNumAvailable < kRequest.arrRequestedItems[Index].iQuantity)
        {
            bAllRequestedItemsAvailable = false;
        }

        if (Index != kRequest.arrRequestedItems.Length - 1)
        {
            kUI.ltxtRequired.StrValue $= ", ";
            kUI.ltxtInStorage.StrValue $= ", ";
        }
    }

    if (bAllRequestedItemsAvailable)
    {
        kUI.ltxtInStorage.iState = eUIState_Warning;
    }
    else
    {
        kUI.ltxtInStorage.iState = eUIState_Bad;
    }

    // Text for time limit
    kTag.IntValue0 = kRequest.iHoursToRespond / 24;
    kUI.ltxtDueDate.strLabel = m_strLabelTimeLimit;
    kUI.ltxtDueDate.StrValue = class'XComLocalizer'.static.ExpandString(m_strTimeLimitDays);
    kUI.ltxtDueDate.iState = eUIState_Warning;

    // Text for rewards
    kUI.txtRewardLabel.StrValue = m_strLabelRewards;
    kUI.txtRewardLabel.iState = eUIState_Good;

    arrRewardStrings = LWCE_RewardToString(kRequest.kReward, kRequest.eRequestingCountry);

    for (Index = 0; Index < arrRewardStrings.Length; Index++)
    {
        kText.StrValue = arrRewardStrings[Index];
        kText.iState = eUIState_Good;
        kUI.arrRewards.AddItem(kText);
    }

    // Accept button
    kUI.txtAccept.iButton = 1;

    if (kRequest.eType == eFCRType_SatLaunch)
    {
        kUI.txtAccept.StrValue = m_strLabelTransferSatellite;
    }
    else
    {
        kUI.txtAccept.StrValue = m_strLabelSellItems;
    }

    if (LWCE_XGFundingCouncil(World().m_kFundingCouncil).LWCE_CanAcceptRequest(kRequest))
    {
        kUI.txtAccept.iState = eUIState_Good;
    }
    else
    {
        kUI.txtAccept.iState = eUIState_Disabled;
    }

    // Ignore button
    kUI.txtIgnore.StrValue = m_strLabelIgnoreRequest;
    kUI.txtIgnore.iButton = 4;
    kUI.txtIgnore.iState = eUIState_Good;

    m_kCERequest = kUI;
}

static protected function string RewardSoldierToString(LWCE_TRewardSoldier kSoldier)
{
    local string strName;

    strName = `LWCE_BARRACKS.GetClassName(kSoldier.iClassId);

    if (kSoldier.iRank > 0)
    {
        strName @= "(" $ `GAMECORE.GetRankString(kSoldier.iRank) $ ")";
    }

    return strName;
}