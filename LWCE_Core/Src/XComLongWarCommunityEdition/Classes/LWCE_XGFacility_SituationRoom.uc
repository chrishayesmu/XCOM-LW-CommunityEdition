class LWCE_XGFacility_SituationRoom extends XGFacility_SituationRoom;

struct LWCE_TTickerItem
{
    var ETicker_Types eType;
    var name nmCountry;
    var string strCode;
    var TText kTickerText;
};

struct CheckpointRecord_LWCE_XGFacility_SituationRoom extends CheckpointRecord_XGFacility_SituationRoom
{
    var array<LWCE_TTickerItem> m_arrCETickerItems;
    var int maxTickerItems;
};

var array<LWCE_TTickerItem> m_arrCETickerItems; // List of ticker items to display; index 0 is the oldest,
                                                // and is displayed last in the UI

var int maxTickerItems; // How many items will be kept in m_arrCETickerItems at once; after this is
                        // reached, the oldest item is purged every time a new one is added

// Tracking which tickers have been shown; when all tickers of a certain type have been used, they're cleared and
// start again. Exactly how a ticker message is encoded into a string for these arrays depends on the type of ticker.
var private array<string> m_arrCEUsedPanicTickers;
var private array<string> m_arrCEUsedAmbientTickers;
var private array<string> m_arrCEUsedMissionTickers;
var private array<string> m_arrCEUsedWithdrawTickers;
var private array<string> m_arrCEUsedNarrativeTickers;
var private array<string> m_arrCEUsedExaltTickers;

function bool IsCodeActive()
{
    local LWCE_XGFacility_Labs kLabs;

    kLabs = LWCE_XGFacility_Labs(LABS());

    return kLabs.LWCE_IsResearched('Tech_AlienOperations') && !kLabs.LWCE_IsTechAvailable('Tech_AlienCommunications');
}

function OnShipTransferExecuted(XGShip_Interceptor kShip)
{
    `LWCE_LOG_DEPRECATED_CLS(OnShipTransferExecuted);
}

function LWCE_OnShipTransferExecuted(LWCE_XGShip kShip)
{
    LWCE_XGFundingCouncil(World().m_kFundingCouncil).LWCE_OnShipTransferExecuted(kShip);
}

function PushAmbientHeadline(int iAct)
{
    local LWCE_TTickerItem kTickerItem;
    local array<string> arrItems;

    switch (iAct)
    {
        case 0:
            arrItems = TickerAmbientAct0;
            break;
        case 1:
            arrItems = TickerAmbientAct1;
            break;
        case 2:
            arrItems = TickerAmbientAct2;
            break;
        case 3:
            arrItems = TickerAmbientAct3;
            break;
    }

    LWCE_GetAmbientTickerString(iAct, arrItems, kTickerItem);

    AddTickerItem(kTickerItem);
}

function PushCountryWithdrawHeadline(ECountry ECountry)
{
    `LWCE_LOG_DEPRECATED_CLS(PushCountryWithdrawHeadline);
}

function LWCE_PushCountryWithdrawHeadline(name nmCountry)
{
    local int I;
    local XGCountryTag kTag;
    local LWCE_TTickerItem kTickerItem;

    I = `SYNC_RAND(TickerCountryWithdraw.Length);

    kTag = new class'XGCountryTag';
    kTag.kCountry = `LWCE_XGCOUNTRY(nmCountry);

    kTickerItem.nmCountry = nmCountry;
    kTickerItem.eType = eTicker_Withdraw;
    kTickerItem.strCode = string(I);
    kTickerItem.kTickerText.iState = eUIState_Bad;
    kTickerItem.kTickerText.StrValue = class'XComLocalizer'.static.ExpandStringByTag(TickerCountryWithdraw[I], kTag);

    AddTickerItem(kTickerItem);
}

function PushExaltOperationHeadline(ECountry ECountry, int iOperation)
{
    `LWCE_LOG_DEPRECATED_CLS(PushExaltOperationHeadline);
}

function LWCE_PushExaltOperationHeadline(name nmCountry, int iOperation)
{
    local array<string> arrItems;
    local LWCE_TTickerItem kTickerItem;
    local XGCountryTag kTag;

    switch (iOperation)
    {
        case 1: // TODO: where the hell is the enum for these
            arrItems = TickerExaltSabotage;
            break;
        case 2:
            arrItems = TickerExaltPropaganda;
            break;
        case 3:
            arrItems = TickerExaltResearchHack;
            break;
    }

    if (arrItems.Length == 0)
    {
        return;
    }

    LWCE_GetExaltOperationTickerString(iOperation, arrItems, kTickerItem);

    kTag = new class'XGCountryTag';
    kTag.kCountry = `LWCE_XGCOUNTRY(nmCountry);
    kTickerItem.kTickerText.StrValue = class'XComLocalizer'.static.ExpandStringByTag(kTickerItem.kTickerText.StrValue, kTag);

    AddTickerItem(kTickerItem);
}

function PushFundingCouncilHeadline(ECountry ECountry, TText kHeadline)
{
    `LWCE_LOG_DEPRECATED_CLS(PushFundingCouncilHeadline);
}

function LWCE_PushFundingCouncilHeadline(name nmCountry, TText kHeadline)
{
    local LWCE_TTickerItem kTickerItem;

    kTickerItem.nmCountry = nmCountry;
    kTickerItem.eType = eTicker_FundingCouncil;
    kTickerItem.kTickerText = kHeadline;

    AddTickerItem(kTickerItem);
}

function PushMissionSpecificHeadline(XGMission kMission, bool bSuccess, int iGeneModCount, int iMecCount)
{
    local array<string> arrItems;
    local LWCE_TTickerItem kTickerItem;
    local XGCountryTag kTag;
    local int iMissionType;

    iMissionType = kMission.m_iMissionType;

    switch (kMission.m_iMissionType)
    {
        case eMission_Abduction:
            if (bSuccess)
            {
                arrItems = TickerAbductionWon;

                if (iGeneModCount > 0 && iMecCount == 0)
                {
                    arrItems = TickerAbductionWonWithGeneMods;
                    iMissionType += 30;
                }
                else if (iGeneModCount == 0 && iMecCount > 0)
                {
                    arrItems = TickerAbductionWonWithMecs;
                    iMissionType += 31;
                }
                else if (iGeneModCount > 0 && iMecCount > 0)
                {
                    if (`SYNC_RAND(4) > 1)
                    {
                        arrItems = TickerAbductionWonWithMecs;
                        iMissionType += 31;
                    }
                    else
                    {
                        arrItems = TickerAbductionWonWithGeneMods;
                        iMissionType += 30;
                    }
                }
            }
            else
            {
                arrItems = TickerAbductionLost;
            }

            break;
        case eMission_TerrorSite:
            if (bSuccess)
            {
                arrItems = TickerTerrorWon;
            }
            else
            {
                arrItems = TickerTerrorLost;
            }

            break;
        case eMission_Crash:

            if (bSuccess)
            {
                arrItems = TickerCrashedUFOWon;
            }
            else
            {
                arrItems = TickerCrashedUFOLost;
            }

            break;
        case eMission_LandedUFO:
            if (bSuccess)
            {
                arrItems = TickerLandedUFOWon;
            }
            else
            {
                arrItems = TickerLandedUFOLost;
            }

            break;
        case eMission_CovertOpsExtraction:
        case eMission_CaptureAndHold:
            iMissionType = eMission_CovertOpsExtraction;

            if (bSuccess)
            {
                arrItems = TickerCovertOpsWon;
            }
            else
            {
                arrItems = TickerCovertOpsLost;
            }

            break;
    }

    if (arrItems.Length == 0)
    {
        return;
    }

    LWCE_GetSpecificMissionTickerString(iMissionType, bSuccess, arrItems, kTickerItem);

    kTag = new class'XGCountryTag';
    kTag.kCountry = Country(kMission.m_iCountry);
    kTag.kCity = kMission.GetCity();
    kTickerItem.kTickerText.StrValue = class'XComLocalizer'.static.ExpandStringByTag(kTickerItem.kTickerText.StrValue, kTag);

    AddTickerItem(kTickerItem);
}

function PushNarrativeHeadline(ETicker_Narratives eNarrative)
{
    local LWCE_TTickerItem kTickerItem;

    if (m_arrUsedNarrativeTickers.Find(eNarrative) != INDEX_NONE)
    {
        return;
    }

    m_arrUsedNarrativeTickers.AddItem(eNarrative);

    kTickerItem.eType = eTicker_Narrative;
    kTickerItem.strCode = string(int(eNarrative));
    kTickerItem.kTickerText.iState = eUIState_Good;
    kTickerItem.kTickerText.StrValue = TickerNarratives[eNarrative];

    AddTickerItem(kTickerItem);
}

function PushPanicHeadline(ECountry ECountry, int iPanic)
{
    `LWCE_LOG_DEPRECATED_CLS(PushPanicHeadline);
}

function LWCE_PushPanicHeadline(name nmCountry, int iPanic)
{
    local LWCECountryTemplate kCountryTemplate;
    local LWCE_TTickerItem kTickerItem;
    local array<string> arrItems;
    local int iPanicBucket;

    kCountryTemplate = `LWCE_COUNTRY(nmCountry);
    iPanicBucket = CalculatePanicBucket(iPanic);

    switch (iPanicBucket)
    {
        case 0: // don't show tickers for zero panic
            break;
        case 1:
            arrItems = kCountryTemplate.TickerPanicLow;
            break;
        case 2:
        case 3:
            arrItems = kCountryTemplate.TickerPanicMedium;
            break;
        case 4:
            arrItems = kCountryTemplate.TickerPanicHigh;
            break;
        case 5:
            arrItems = kCountryTemplate.TickerPanicMax;
            break;
    }

    if (arrItems.Length == 0)
    {
        return;
    }

    LWCE_GetCountryPanicTickerString(nmCountry, iPanic, arrItems, kTickerItem);

    AddTickerItem(kTickerItem);
}

/// <summary>
/// Removes the newest ticker item which is specific to the given country. This prevents the ticker from
/// filling up with news about just one country.
/// </summary>
function LWCE_RemoveCountrySpecificHeadline(name nmCountry)
{
    local int Index;

    for (Index = m_arrCETickerItems.Length - 1; Index >= 0; Index--)
    {
        if (m_arrCETickerItems[Index].nmCountry == nmCountry && IsCountrySpecificTickerType(m_arrCETickerItems[Index].eType))
        {
            m_arrCETickerItems.Remove(Index, 1);
            return;
        }
    }
}

/// <summary>
/// Adds the ticker item to the list of all items, respecting the list's max size. Also resets the tracking
/// for how long it's been since we added a ticker item, which is used for deciding when to add a new ambient
/// ticker item so things don't get too stale.
/// </summary>
private function AddTickerItem(const out LWCE_TTickerItem kTickerItem)
{
    m_arrCETickerItems.AddItem(kTickerItem);

    if (m_arrCETickerItems.Length > maxTickerItems)
    {
        // Since index 0 contains the oldest item, remove from that side
        m_arrCETickerItems.Remove(0, m_arrCETickerItems.Length - maxTickerItems);
    }

    m_iLastPushedTicker = TICKER_AMBIENT_PUSH_HOURS;
}

private function int CalculatePanicBucket(int iPanic)
{
    // For ticker purposes, panic is in buckets of [0, 1, 2, 3, 4, 5], corresponding to [0-19, 20-39, .. 100].
    // Bucket 0 doesn't typically show ticker items but it's included for completeness.
    return iPanic / 20;
}

private function int LWCE_DecodeAmbientStringIndex(string strCode)
{
    return int(SplitString(strCode)[1]);
}

private function string LWCE_EncodeAmbientString(int iAct, int iIndex)
{
    return iAct $ "_" $ iIndex;
}

private function bool LWCE_IsAmbientStringUsed(string strCode)
{
    return m_arrCEUsedAmbientTickers.Find(strCode) != INDEX_NONE;
}

private function string LWCE_EncodeExaltString(int iOpType, int iIndex)
{
    return iOpType $ "_" $ iIndex;
}

private function int LWCE_DecodeExaltStringIndex(string strCode)
{
    return int(SplitString(strCode)[1]);
}

private function bool LWCE_IsExaltStringUsed(string strCode)
{
    return m_arrCEUsedExaltTickers.Find(strCode) != INDEX_NONE;
}

private function string LWCE_EncodeMissionString(int iMissionType, bool bSuccess, int iIndex)
{
    return iMissionType $ "_" $ (bSuccess ? "1" : "0") $ "_" $ iIndex;
}

private function int LWCE_DecodeMissionStringIndex(string strCode)
{
    return int(SplitString(strCode)[2]);
}

private function bool LWCE_IsMissionStringUsed(string strCode)
{
    return m_arrCEUsedMissionTickers.Find(strCode) != INDEX_NONE;
}

private function int LWCE_DecodePanicStringIndex(string strCode)
{
    return int(SplitString(strCode)[2]);
}

private function string LWCE_EncodePanicString(name nmCountry, int iPanic, int iIndex)
{
    return string(nmCountry) $ "_" $ CalculatePanicBucket(iPanic) $ "_" $ iIndex;
}

private function bool LWCE_IsPanicStringUsed(string strCode)
{
    return m_arrCEUsedPanicTickers.Find(strCode) != INDEX_NONE;
}

private function LWCE_GetAmbientTickerString(int iAct, array<string> arrItems, out LWCE_TTickerItem kTicker)
{
    local array<string> arrEncodedItems, arrUsedItems;
    local string strCode;
    local int I;

    for (I = 0; I < arrItems.Length; I++)
    {
        strCode = LWCE_EncodeAmbientString(iAct, I);
        arrEncodedItems.AddItem(strCode);

        if (LWCE_IsAmbientStringUsed(strCode))
        {
            arrUsedItems.AddItem(strCode);
        }
    }

    if (arrUsedItems.Length == arrEncodedItems.Length)
    {
        arrUsedItems.Length = 0;

        for (I = 0; I < arrEncodedItems.Length; I++)
        {
            m_arrCEUsedAmbientTickers.RemoveItem(arrEncodedItems[I]);
        }

        for (I = 0; I < m_arrCETickerItems.Length; I++)
        {
            if (m_arrCETickerItems[I].eType == eTicker_Ambient && m_arrCEUsedAmbientTickers.Find(m_arrCETickerItems[I].strCode) == INDEX_NONE)
            {
                m_arrCEUsedAmbientTickers.AddItem(m_arrCETickerItems[I].strCode);
                arrUsedItems.AddItem(m_arrCETickerItems[I].strCode);
            }
        }
    }

    foreach arrUsedItems(strCode)
    {
        arrEncodedItems.RemoveItem(strCode);
    }

    strCode = arrEncodedItems[`SYNC_RAND(arrEncodedItems.Length)];
    I = LWCE_DecodeAmbientStringIndex(strCode);

    kTicker.eType = eTicker_Ambient;
    kTicker.kTickerText.StrValue = arrItems[I];
    kTicker.kTickerText.iState = eUIState_Normal;
    kTicker.strCode = strCode;

    m_arrCEUsedAmbientTickers.AddItem(strCode);
}

private function LWCE_GetCountryPanicTickerString(name nmCountry, int iPanic, array<string> arrItems, out LWCE_TTickerItem kTicker)
{
    local array<string> arrEncodedItems, arrUsedItems;
    local string strCode;
    local int I;

    for (I = 0; I < arrItems.Length; I++)
    {
        strCode = LWCE_EncodePanicString(nmCountry, iPanic, I);
        arrEncodedItems.AddItem(strCode);

        if (LWCE_IsPanicStringUsed(strCode))
        {
            arrUsedItems.AddItem(strCode);
        }
    }

    if (arrUsedItems.Length == arrEncodedItems.Length)
    {
        arrUsedItems.Length = 0;

        for (I = 0; I < arrEncodedItems.Length; I++)
        {
            m_arrCEUsedPanicTickers.RemoveItem(arrEncodedItems[I]);
        }

        for (I = 0; I < m_arrCETickerItems.Length; I++)
        {
            if (m_arrCETickerItems[I].eType == eTicker_Panic && m_arrCEUsedPanicTickers.Find(m_arrCETickerItems[I].strCode) == INDEX_NONE)
            {
                m_arrCEUsedAmbientTickers.AddItem(m_arrCETickerItems[I].strCode);
                arrUsedItems.AddItem(m_arrCETickerItems[I].strCode);
            }
        }
    }

    foreach arrUsedItems(strCode)
    {
        arrEncodedItems.RemoveItem(strCode);
    }

    strCode = arrEncodedItems[`SYNC_RAND(arrEncodedItems.Length)];
    I = LWCE_DecodePanicStringIndex(strCode);

    kTicker.eType = eTicker_Panic;
    kTicker.kTickerText.StrValue = arrItems[I];
    kTicker.kTickerText.iState = eUIState_Bad;
    kTicker.strCode = strCode;

    m_arrCEUsedPanicTickers.AddItem(strCode);
}

private function LWCE_GetExaltOperationTickerString(int iOperation, array<string> arrItems, out LWCE_TTickerItem kTicker)
{
    local array<string> arrEncodedItems, arrUsedItems;
    local string strCode;
    local int I;

    for (I = 0; I < arrItems.Length; I++)
    {
        strCode = LWCE_EncodeExaltString(iOperation, I);
        arrEncodedItems.AddItem(strCode);

        if (LWCE_IsExaltStringUsed(strCode))
        {
            arrUsedItems.AddItem(strCode);
        }
    }

    if (arrUsedItems.Length == arrEncodedItems.Length)
    {
        arrUsedItems.Length = 0;

        for (I = 0; I < arrEncodedItems.Length; I++)
        {
            m_arrCEUsedExaltTickers.RemoveItem(arrEncodedItems[I]);
        }

        for (I = 0; I < TICKER_MAX_HEADLINES; I++)
        {
            if (m_arrCETickerItems[I].eType == eTicker_Exalt && m_arrCEUsedExaltTickers.Find(m_arrCETickerItems[I].strCode) == INDEX_NONE)
            {
                m_arrCEUsedExaltTickers.AddItem(m_arrCETickerItems[I].strCode);
                arrUsedItems.AddItem(m_arrCETickerItems[I].strCode);
            }
        }
    }

    foreach arrUsedItems(strCode)
    {
        arrEncodedItems.RemoveItem(strCode);
    }

    strCode = arrEncodedItems[`SYNC_RAND(arrEncodedItems.Length)];
    I = LWCE_DecodeExaltStringIndex(strCode);

    kTicker.eType = eTicker_Exalt;
    kTicker.kTickerText.StrValue = arrItems[I];
    kTicker.kTickerText.iState = eUIState_Bad;
    kTicker.strCode = strCode;

    m_arrCEUsedExaltTickers.AddItem(strCode);
}

private function LWCE_GetSpecificMissionTickerString(int iMissionType, bool bSuccess, array<string> arrItems, out LWCE_TTickerItem kTicker)
{
    local array<string> arrEncodedItems, arrUsedItems;
    local string strCode;
    local int I;

    for (I = 0; I < arrItems.Length; I++)
    {
        strCode = LWCE_EncodeMissionString(iMissionType, bSuccess, I);
        arrEncodedItems.AddItem(strCode);

        if (LWCE_IsMissionStringUsed(strCode))
        {
            arrUsedItems.AddItem(strCode);
        }
    }

    if (arrUsedItems.Length == arrEncodedItems.Length)
    {
        arrUsedItems.Length = 0;

        for (I = 0; I < arrEncodedItems.Length; I++)
        {
            m_arrCEUsedMissionTickers.RemoveItem(arrEncodedItems[I]);
        }

        for (I = 0; I < m_arrCETickerItems.Length; I++)
        {
            if (m_arrCETickerItems[I].eType == eTicker_Mission && m_arrCEUsedMissionTickers.Find(m_arrCETickerItems[I].strCode) == INDEX_NONE)
            {
                m_arrCEUsedMissionTickers.AddItem(m_arrCETickerItems[I].strCode);
                arrUsedItems.AddItem(m_arrCETickerItems[I].strCode);
            }
        }
    }

    foreach arrUsedItems(strCode)
    {
        arrEncodedItems.RemoveItem(strCode);
    }

    strCode = arrEncodedItems[`SYNC_RAND(arrEncodedItems.Length)];
    I = LWCE_DecodeMissionStringIndex(strCode);

    kTicker.eType = eTicker_Mission;
    kTicker.kTickerText.StrValue = arrItems[I];

    if (bSuccess)
    {
        kTicker.kTickerText.iState = eUIState_Good;
    }
    else
    {
        kTicker.kTickerText.iState = eUIState_Bad;
    }

    kTicker.strCode = strCode;
    m_arrCEUsedMissionTickers.AddItem(strCode);
}

defaultproperties
{
    maxTickerItems=5
}