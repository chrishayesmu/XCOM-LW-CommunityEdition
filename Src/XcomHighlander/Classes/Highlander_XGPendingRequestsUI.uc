class Highlander_XGPendingRequestsUI extends XGPendingRequestsUI;

function UpdateRequest(TFCRequest kRequest)
{
    local int iNumAvailable, iReward;
    local HL_TItem kItem;
    local TPendingRequest kUI;
    local TText txtReward;
    local XGParamTag kTag;

    iNumAvailable = STORAGE().GetNumItemsAvailable(kRequest.eDisplayItem);
    kItem = `HL_ITEM(kRequest.eRequestedItem);

    kTag = XGParamTag(XComEngine(class'Engine'.static.GetEngine()).LocalizeContext.FindTag("XGParam"));
    kUI.ECountry = kRequest.ECountry;
    kUI.eRequest = kRequest.eRequest;
    kUI.img.strPath = class'UIUtilities'.static.GetItemImagePath(kRequest.eRequestedItem);

    kTag.StrValue0 = Country(kRequest.ECountry).m_kTCountry.strName;
    kUI.txtTitle.StrValue = class'XComLocalizer'.static.ExpandString(m_strTitleLabel);
    kUI.txtTitle.iState = eUIState_Warning;

    kUI.txtSubTitle.StrValue = kRequest.iRequestedAmount != 1 ? kItem.strNamePlural : kItem.strName;
    kUI.txtDescription.StrValue = kRequest.strIntro;
    kUI.txtDescription.iState = eUIState_Normal;

    kTag.IntValue0 = kRequest.iRequestedAmount;
    kTag.StrValue0 = kRequest.iRequestedAmount != 1 ? kItem.strNamePlural : kItem.strName;
    kUI.ltxtRequired.strLabel = m_strLabelRequested;
    kUI.ltxtRequired.StrValue = class'XComLocalizer'.static.ExpandString(m_strValueRequested);
    kUI.ltxtRequired.iState = eUIState_Warning;

    if (kRequest.eDisplayItem != 0)
    {
        kTag.IntValue0 = iNumAvailable;
        kTag.StrValue0 = kTag.IntValue0 != 1 ? kItem.strNamePlural : kItem.strName;
        kUI.ltxtInStorage.strLabel = m_strLabelInStorage;
        kUI.ltxtInStorage.StrValue = class'XComLocalizer'.static.ExpandString(m_strValueRequested);

        if (iNumAvailable >= kRequest.iRequestedAmount)
        {
            kUI.ltxtInStorage.iState = eUIState_Warning;
        }
        else
        {
            kUI.ltxtInStorage.iState = eUIState_Bad;
        }
    }

    kTag.IntValue0 = kRequest.iHours / 24;
    kUI.ltxtDueDate.strLabel = m_strLabelTimeLimit;
    kUI.ltxtDueDate.StrValue = class'XComLocalizer'.static.ExpandString(m_strTimeLimitDays);
    kUI.ltxtDueDate.iState = eUIState_Warning;
    kUI.txtRewardLabel.StrValue = m_strLabelRewards;
    kUI.txtRewardLabel.iState = eUIState_Good;

    for (iReward = 0; iReward < kRequest.arrRewards.Length; iReward++)
    {
        txtReward.StrValue = RewardToString(kRequest.arrRewards[iReward], kRequest.arrRewardAmounts[iReward]);
        txtReward.iState = eUIState_Good;
        kUI.arrRewards.AddItem(txtReward);
    }

    kUI.txtAccept.iButton = 1;

    if (kRequest.eRequest == eFCR_SatCountry)
    {
        kUI.txtAccept.StrValue = m_strLabelTransferSatellite;
    }
    else
    {
        kUI.txtAccept.StrValue = m_strLabelSellItems;
    }

    if (World().m_kFundingCouncil.CanAcceptRequest(kRequest))
    {
        kUI.txtAccept.iState = eUIState_Good;
    }
    else
    {
        kUI.txtAccept.iState = eUIState_Disabled;
    }

    kUI.txtIgnore.StrValue = m_strLabelIgnoreRequest;
    kUI.txtIgnore.iButton = 4;
    kUI.txtIgnore.iState = eUIState_Good;

    m_kRequest = kUI;
}