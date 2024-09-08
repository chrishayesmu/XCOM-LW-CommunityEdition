class LWCE_XGFundingCouncil extends XGFundingCouncil_Mod
    config(LWCECouncilRequests)
    dependson(LWCETypes, LWCECouncilRequestTemplate);

struct LWCE_TRewardSoldier
{
    var int iClassId;
    var int iRank;
};

struct LWCE_TRequestCooldown
{
    var name nmRequest;
    var int iHoursRemaining;
};

struct LWCE_TRequestReward
{
    var array<LWCE_TItemQuantity> arrItemRewards;
    var array<LWCE_TRewardSoldier> arrSoldiers;
    var int iCash;
    var int iCountryDefense;
    var int iEngineers;
    var int iPanic;
    var int iScientists;
};

struct LWCE_TFCRequest
{
    var name nmRequest;
    var name nmRequestingCountry;
    var EFCRequestType eType;
    var int iHoursToRespond;

    var array<LWCE_TItemQuantity> arrRequestedItems;
    var LWCE_TRequestReward kReward;

    var string strName;
    var string strIntro;
    var string strCompletion;
    var string strTickerSuccess;
    var string strTickerIgnore;

    var bool bIsTransferRequest;
    var bool bIsTransferComplete;
};

struct CheckpointRecord_LWCE_XGFundingCouncil extends CheckpointRecord
{
    var array<LWCE_TFCRequest> m_arrCECurrentRequests;
    var array<LWCE_TFCRequest> m_arrCEExpiredRequests;
    var array<LWCE_TFCRequest> m_arrCEPendingRequests;
    var array<LWCE_TRequestCooldown> m_arrCERequestCooldowns;
    var LWCE_TFCRequest m_kLastCompletedSatelliteTransferRequest;
};

// Substitution thresholds: if a request's rewards include engineers/scientists/soldiers,
// and the player already has a number of staff meeting or exceeding the corresponding threshold,
// the reward can be rerolled into something else.
var config int iEngineerSubstitutionThreshold;
var config int iScientistSubstitutionThreshold;
var config int iSoldierSubstitutionThreshold;
var config float fSoldierToCashPercentage;
var config int iSoldierToEngineerRatio;
var config int iSoldierToScientistRatio;
var config float fEngineerToCashPercentage;
var config float fScientistToCashPercentage;
var config int iSubstitutionChance;

var config LWCE_TRange kTimeBetweenRequests;
var config int iHoursLostPerPanic;

var array<LWCE_TFCRequest> m_arrCECurrentRequests;
var array<LWCE_TFCRequest> m_arrCEExpiredRequests;
var array<LWCE_TFCRequest> m_arrCEPendingRequests;
var array<LWCE_TRequestCooldown> m_arrCERequestCooldowns;

var LWCE_TFCRequest m_kLastCompletedSatelliteTransferRequest;
var name m_nmPendingSatelliteRequestCountry;

var private LWCECouncilRequestTemplateManager m_kTemplateMgr;

function Init()
{
    // Need to call the base class init, which expands the council mission map pool
    super.Init();

    m_kSatRequestCompleteAdaptor = new (self) class'LWCE_XGFundingCouncil_RequestAdaptor';

    m_kTemplateMgr = `LWCE_COUNCIL_REQUEST_TEMPLATE_MGR;

    // Delete base game request data; we're only using templates
    m_arrTRequests.Length = 0;
}

function InitNewGame()
{
    Init();
    m_bProgenyEnabled = XComHeadquartersGame(WorldInfo.Game).m_bEnableProgenyFromShell;
    m_bSlingshotEnabled = `ONLINEEVENTMGR.HasSlingshotPack() && XComHeadquartersGame(WorldInfo.Game).m_bEnableSlingshotFromShell;

    SetupMonthlyRequests();
    m_arrPreviousMissions.AddItem(eFCM_None);
}

function Update()
{
    local LWCEDataContainer kEventData;
    local LWCE_TFCRequest kCreatedRequest;
    local int iRequest, Index;

    for (Index = m_arrCERequestCooldowns.Length - 1; Index >= 0; Index--)
    {
        if (m_arrCERequestCooldowns[Index].iHoursRemaining > 0)
        {
            m_arrCERequestCooldowns[Index].iHoursRemaining--;

            if (m_arrCERequestCooldowns[Index].iHoursRemaining <= 0)
            {
                m_arrCERequestCooldowns.Remove(Index, 1);
            }
        }
    }

    for (iRequest = m_arrCECurrentRequests.Length - 1; iRequest >= 0; iRequest--)
    {
        m_arrCECurrentRequests[iRequest].iHoursToRespond--;

        if (m_arrCECurrentRequests[iRequest].iHoursToRespond <= 0)
        {
            if (LWCE_CanRequestExpire(m_arrCECurrentRequests[iRequest]))
            {
                OnRequestExpired(iRequest);
            }
            else
            {
                m_arrCECurrentRequests[iRequest].iHoursToRespond = 6;
            }
        }
    }

    --m_iFirstRequestCountdown;
    --m_iSecondRequestCountdown;

    if (!GEOSCAPE().IsBusy() && GEOSCAPE().GetFinalMission() == none)
    {
        if (m_iFirstRequestCountdown <= 0 && GEOSCAPE().GetNumMissionsOfType(eMission_Special) == 0)
        {
            m_iFirstRequestCountdown = 9999;
            DetermineNewFCMission();
        }

        if (m_iSecondRequestCountdown <= 0)
        {
            m_iSecondRequestCountdown = `LWCE_UTILS.RandInRange(kTimeBetweenRequests);

            kCreatedRequest = LWCE_DetermineNewFCRequest();

            // EVENT: CouncilRequestGenerated
            //
            // SUMMARY: Emitted after an attempt to generate a council request. Note that the attempt may not have succeeded, for example if a request template is wrongly configured;
            //          see the event's data for how to determine this. Regardless of whether a request was generated, a cooldown period will be set before another request occurs.
            //          The new request will be stored in either LWCE_XGFundingCouncil.m_arrCECurrentRequests or LWCE_XGFundingCouncil.m_arrCEPendingRequests, depending on whether
            //          the player can currently fulfill it. This event can be used to modify the request, though removing it completely is not advised, because the player is going to
            //          be notified about the request during the next Geoscape tick.
            //
            // DATA: LWCEDataContainer
            //       Data[0]: name - The name of the LWCECouncilRequestTemplate which was generated. If blank, no request was generated.
            //       Data[1]: name - The country which is submitting the request. If blank, no request was generated.
            //
            // SOURCE: LWCE_XGFundingCouncil
            kEventData = class'LWCEDataContainer'.static.New('CouncilRequestGenerated');
            kEventData.AddName(kCreatedRequest.nmRequest);
            kEventData.AddName(kCreatedRequest.nmRequestingCountry);

            `LWCE_EVENT_MGR.TriggerEvent('CouncilRequestGenerated', kEventData, self);
        }
    }
}

function int AcceptPendingRequest()
{
    m_arrCECurrentRequests.AddItem(m_arrCEPendingRequests[0]);
    m_arrCEPendingRequests.Remove(0, 1);
    return m_arrCECurrentRequests.Length - 1;
}

function bool AttemptTurnInRequest(int iRequestIndex)
{
    local LWCE_TFCRequest kRequest;
    local LWCE_XGStorage kStorage;
    local int Index;

    if (iRequestIndex < m_arrCECurrentRequests.Length)
    {
        kRequest = m_arrCECurrentRequests[iRequestIndex];
    }

    if (kRequest.nmRequest == '' || kRequest.bIsTransferRequest)
    {
        return false;
    }

    kStorage = LWCE_XGStorage(STORAGE());

    if (LWCE_CanAcceptRequest(kRequest))
    {
        for (Index = 0; Index < kRequest.arrRequestedItems.Length; Index++)
        {
            if (kRequest.arrRequestedItems[Index].ItemName != 'Item_Satellite' &&
                kRequest.arrRequestedItems[Index].ItemName != 'Item_Interceptor' &&
                kRequest.arrRequestedItems[Index].ItemName != 'Item_Firestorm')
            {
                kStorage.LWCE_RemoveItem(kRequest.arrRequestedItems[Index].ItemName, kRequest.arrRequestedItems[Index].iQuantity);
            }
        }

        LWCE_GrantFCRewards(m_arrCECurrentRequests[iRequestIndex].kReward, m_arrCECurrentRequests[iRequestIndex].nmRequestingCountry);
        OnRequestCompleted(iRequestIndex);

        return true;
    }

    return false;
}

function TFCRequest BuildRequest(EFCRequest eRequest, ECountry ECountry, optional out int isValidRequest)
{
    local TFCRequest kRequest;

    // This function is deprecated; however, due to needing to call inherited initialization code, we can't prevent
    // calling it a bunch of times on load. Logging is disabled to avoid filling the logs with useless messages.
    // `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(BuildRequest);

    return kRequest;
}

function bool CanAcceptRequest(TFCRequest kRequest)
{
    `LWCE_LOG_DEPRECATED_CLS(CanAcceptRequest);
    return false;
}

function bool LWCE_CanAcceptRequest(LWCE_TFCRequest kRequest)
{
    local LWCE_XGStorage kStorage;
    local int Index;

    kStorage = LWCE_XGStorage(STORAGE());

    for (Index = 0; Index < kRequest.arrRequestedItems.Length; Index++)
    {
        if (kStorage.LWCE_GetNumItemsAvailable(kRequest.arrRequestedItems[Index].ItemName) < kRequest.arrRequestedItems[Index].iQuantity)
        {
            return false;
        }
    }

    return true;
}

function bool CanRequestExpire(TFCRequest kRequest)
{
    `LWCE_LOG_DEPRECATED_CLS(CanRequestExpire);
    return false;
}

function bool LWCE_CanRequestExpire(LWCE_TFCRequest kRequest)
{
    local LWCE_XGFacility_Hangar kHangar;
    local LWCE_XGHeadquarters kHQ;

    kHangar = LWCE_XGFacility_Hangar(HANGAR());
    kHQ = LWCE_XGHeadquarters(HQ());

    if (kRequest.bIsTransferComplete)
    {
        return false;
    }

    if (kRequest.bIsTransferRequest)
    {
        if (kRequest.eType == eFCRType_JetTransfer && kHangar.LWCE_IsShipInTransitTo(kRequest.nmRequestingCountry))
        {
            return false;
        }

        if (kRequest.eType == eFCRType_SatLaunch && kHQ.LWCE_IsSatelliteInTransitTo(kRequest.nmRequestingCountry))
        {
            return false;
        }
    }

    return true;
}

function bool CanTransferSatellite(int iCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(CanTransferSatellite);

    return false;
}

function bool LWCE_CanTransferSatellite(name nmCountry)
{
    local LWCE_XGHeadquarters kHQ;
    local int iSatellite;

    kHQ = LWCE_XGHeadquarters(HQ());

    // We can transfer a satellite unless there's already one over the given country
    for (iSatellite = 0; iSatellite < kHQ.m_arrCESatellites.Length; iSatellite++)
    {
        if (kHQ.m_arrCESatellites[iSatellite].nmCountry == nmCountry)
        {
            return false;
        }
    }

    return true;
}

function EFCRequest ChooseNextRequest(optional EFCRequestType eType = eFCRType_None, optional EFCRewardType eRewardType = eFCReward_None)
{
    `LWCE_LOG_DEPRECATED_CLS(ChooseNextRequest);
    return eFCR_None;
}

function name LWCE_ChooseNextRequest()
{
    local array<name> arrPossibleRequests, arrBackupRequests;
    local array<LWCECouncilRequestTemplate> arrRequestTemplates;
    local int iCooldown, Index;
    local name RequestName;
    local LWCECouncilRequestTemplate kTemplate;

    arrRequestTemplates = m_kTemplateMgr.GetAllRequestTemplates();

    for (Index = 0; Index < arrRequestTemplates.Length; Index++)
    {
        kTemplate = arrRequestTemplates[Index];
        RequestName = kTemplate.DataName;

        if (!LWCE_PassesRequestRequirements(kTemplate))
        {
            // Request is invalid (probably due to missing prereqs)
            continue;
        }

        iCooldown = GetRemainingCooldown(RequestName);

        if (iCooldown <= 0)
        {
            arrPossibleRequests.AddItem(RequestName);
            continue;
        }
        else
        {
            // This has been requested within the cooldown period; use it as a last resort
            arrBackupRequests.AddItem(RequestName);
        }
    }

    // If we have no "plan A" requests available, pick from the "plan B" pool
    if (arrPossibleRequests.Length > 0)
    {
        RequestName = arrPossibleRequests[Rand(arrPossibleRequests.Length)];
    }
    else if (arrBackupRequests.Length > 0)
    {
        RequestName = arrBackupRequests[Rand(arrBackupRequests.Length)];
    }

    return RequestName;
}

function ClearExpiredRequests()
{
    m_arrCEExpiredRequests.Remove(0, m_arrCEExpiredRequests.Length);
}

function bool CreateRequestFromTemplate(out LWCE_TFCRequest kRequest, const LWCECouncilRequestTemplate kRequestTemplate, name nmRequestingCountry)
{
    local LWCE_TItemQuantity kItemQuantity;
    local LWCE_TRewardSoldier kRewardSoldier;
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_XGCountry kCountry;
    local XGCountryTag kTag;
    local bool bIsDynamicWar;
    local int Index, iCash, iEngineers, iScientists, iSoldiers;
    local int iBonusCash, iBonusEngineers, iBonusScientists, iBonusSoldiers;

    kBarracks = LWCE_XGFacility_Barracks(BARRACKS());
    kCountry = `LWCE_XGCOUNTRY(nmRequestingCountry);

    kTag = new class'XGCountryTag';
    kTag.kCountry = kCountry;

    kRequest.nmRequest = kRequestTemplate.GetRequestName();
    kRequest.eType = kRequestTemplate.eType;
    kRequest.nmRequestingCountry = nmRequestingCountry;
    kRequest.iHoursToRespond = kRequestTemplate.iHoursToRespond;

    if (kRequest.eType == eFCRType_SatLaunch || kRequest.eType == eFCRType_JetTransfer)
    {
        kRequest.bIsTransferRequest = true;
    }

    kRequest.strName = class'XComLocalizer'.static.ExpandStringByTag(kRequestTemplate.strName, kTag);
    kRequest.strIntro = class'XComLocalizer'.static.ExpandStringByTag(kRequestTemplate.strIntro, kTag);
    kRequest.strCompletion = class'XComLocalizer'.static.ExpandStringByTag(kRequestTemplate.strCompletion, kTag);
    kRequest.strTickerSuccess = class'XComLocalizer'.static.ExpandStringByTag(kRequestTemplate.strTickerSuccess, kTag);
    kRequest.strTickerIgnore = class'XComLocalizer'.static.ExpandStringByTag(kRequestTemplate.strTickerIgnore, kTag);

    // Determine what's being requested
    bIsDynamicWar = IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar));

    for (Index = 0; Index < kRequestTemplate.arrRequestedItems.Length; Index++)
    {
        kItemQuantity.ItemName = kRequestTemplate.arrRequestedItems[Index].ItemName;
        kItemQuantity.iQuantity = DetermineItemQuantityToRequest(kRequestTemplate.arrRequestedItems[Index], bIsDynamicWar);

        kRequest.arrRequestedItems.AddItem(kItemQuantity);
    }

    // Choose the request rewards
    Index = Rand(kRequestTemplate.arrRewards.Length);
    kRequest.kReward.arrItemRewards = kRequestTemplate.arrRewards[Index].arrItemRewards;

    iEngineers = `LWCE_UTILS.RandInRange(kRequestTemplate.arrRewards[Index].kEngineers);
    iScientists = `LWCE_UTILS.RandInRange(kRequestTemplate.arrRewards[Index].kScientists);
    iSoldiers = `LWCE_UTILS.RandInRange(kRequestTemplate.arrRewards[Index].kSoldiers);

    // Reroll rewards per their configured thresholds. Note that this must be after we've assigned the request's items,
    // because those are used when rerolling rewards into cash.
    if (iEngineerSubstitutionThreshold > 0 && iEngineers > 0 && GetResource(eResource_Engineers) >= iEngineerSubstitutionThreshold && Roll(iSubstitutionChance))
    {
        if (Rand(2) == 0)
        {
            `LWCE_LOG_CLS("Rerolling " $ iEngineers $ " engineers into 1 soldier");
            iBonusSoldiers++;
        }
        else
        {
            `LWCE_LOG_CLS("Rerolling " $ iEngineers $ " engineers into cash");
            iBonusCash += fEngineerToCashPercentage * GetRewardEquivalentCashValue(kRequest, kRequestTemplate.arrRewards[Index].kEngineers.MinInclusive);
        }

        iEngineers = 0;
    }

    if (iScientistSubstitutionThreshold > 0 && iScientists > 0 && GetResource(eResource_Scientists) >= iScientistSubstitutionThreshold && Roll(iSubstitutionChance))
    {
        if (Rand(2) == 0)
        {
            `LWCE_LOG_CLS("Rerolling " $ iScientists $ " scientists into 1 soldier");
            iBonusSoldiers++;
        }
        else
        {
            `LWCE_LOG_CLS("Rerolling " $ iScientists $ " scientists into cash");
            iBonusCash += fScientistToCashPercentage * GetRewardEquivalentCashValue(kRequest, kRequestTemplate.arrRewards[Index].kScientists.MinInclusive);
        }

        iScientists = 0;
    }

    if (iSoldierSubstitutionThreshold > 0 && iSoldiers > 0 && BARRACKS().GetNumSoldiers() >= iSoldierSubstitutionThreshold && Roll(iSubstitutionChance))
    {
        switch (Rand(3))
        {
            case 0:
                `LWCE_LOG_CLS("Rerolling " $ iSoldiers $ " soldiers into engineers");
                iBonusEngineers += iSoldiers * iSoldierToEngineerRatio;
                break;
            case 1:
                `LWCE_LOG_CLS("Rerolling " $ iSoldiers $ " soldiers into scientists");
                iBonusScientists += iSoldiers * iSoldierToScientistRatio;
                break;
            default:
                `LWCE_LOG_CLS("Rerolling " $ iSoldiers $ " soldiers into cash");

                // In base game, minimum soldier quantities are never used and the cash equivalent is always 2
                iBonusCash += fSoldierToCashPercentage * GetRewardEquivalentCashValue(kRequest, 2);
                break;
        }

        iSoldiers = 0;
    }

    iBonusCash += `LWCE_UTILS.RandInRange(kRequestTemplate.arrRewards[Index].kCash);

    if (kRequestTemplate.arrRewards[Index].bCashForItems)
    {
        // Base game cash rewards always use the default value for the iMinQuantity parameter, which is 2
        iCash = GetRewardEquivalentCashValue(kRequest, 2);
    }

    kRequest.kReward.iCash = iCash + iBonusCash;
    kRequest.kReward.iCountryDefense = `LWCE_UTILS.RandInRange(kRequestTemplate.arrRewards[Index].kCountryDefense);
    kRequest.kReward.iEngineers = iEngineers + iBonusEngineers;
    kRequest.kReward.iScientists = iScientists + iBonusScientists;
    kRequest.kReward.iPanic = `LWCE_UTILS.RandInRange(kRequestTemplate.arrRewards[Index].kPanic);

    // Go through soldiers and roll their class/rank
    iSoldiers += iBonusSoldiers;

    for (Index = 0; Index < iSoldiers; Index++)
    {
        // TODO: move soldier rank data to config
        kRewardSoldier.iRank = 3;

        if (kCountry.m_iShields > 50 && AI().GetMonth() > 11)
        {
            kRewardSoldier.iRank = 4;
        }

        kRewardSoldier.iClassId = kBarracks.SelectRandomBaseClassId();

        kRequest.kReward.arrSoldiers.AddItem(kRewardSoldier);
    }

    // You lose a little time to turn in requests based on panic. Setting a floor of 8 hours is new to LWCE, in case
    // someone configures an extremely high penalty.
    kRequest.iHoursToRespond = Max(8, kRequest.iHoursToRespond - iHoursLostPerPanic * kCountry.GetPanicBlocks());

    return true;
}

function bool CreateReward(out TFCRequest kRequest, EFCRewardType kRewardType, optional int minQuantity = 2, optional int iQuantity = 2)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(CreateReward);
    return false;
}

function XGMission_FundingCouncil CreateMission(TFCMission MissionData)
{
    local XGMission_FundingCouncil kMission;
    local XGCountry kCountry;
    local ECharacter eChar;
    local XGDateTime kDateTime;
    local int iDaysSinceStart, iClass, iLevel, I;
    local float fReward;

    kDateTime = Spawn(class'LWCE_XGDateTime');
    kDateTime.SetTime(0, 0, 0, START_MONTH, START_DAY, START_YEAR);
    iDaysSinceStart = kDateTime.DifferenceInDays(GEOSCAPE().m_kDateTime);

    if (iDaysSinceStart < MISSION_REWARD_LOW_DAYS)
    {
        fReward = MISSION_REWARD_LOW_MULT;
    }
    else if (iDaysSinceStart < MISSION_REWARD_MED_DAYS)
    {
        fReward = MISSION_REWARD_MED_MULT;
    }
    else
    {
        fReward = 1.0f;
    }

    if (fReward != 1.0f)
    {
        for (I = 0; I < MissionData.arrRewards.Length; I++)
        {
            switch (MissionData.arrRewards[I])
            {
                case eFCReward_Money:
                case eFCReward_Engineer:
                case eFCReward_Scientist:
                    MissionData.arrRewardAmounts[I] *= fReward;

                    if (MissionData.arrRewardAmounts[I] < 1)
                    {
                        MissionData.arrRewardAmounts[I] = 1;
                    }

                    break;

                case eFCReward_Soldier:
                    if (!MissionData.bExplicitSoldier)
                    {
                        iClass = MissionData.arrRewardAmounts[I] / 100;

                        if (iDaysSinceStart < MISSION_REWARD_LOW_DAYS)
                        {
                            iLevel = MISSION_REWARD_SOLDIER_LOW_LEVEL;
                        }
                        else if (iDaysSinceStart < MISSION_REWARD_MED_DAYS)
                        {
                            iLevel = MISSION_REWARD_SOLDIER_MED_LEVEL;
                        }
                        else
                        {
                            iLevel = MISSION_REWARD_SOLDIER_HIGH_LEVEL;
                        }

                        MissionData.arrRewardAmounts[I] = RewardSoldier(iClass, iLevel);
                    }

                    break;
            }
        }
    }

    kMission = Spawn(class'LWCE_XGMission_FundingCouncil');
    kMission.m_kTMission = MissionData;
    kCountry = Country(kMission.m_kTMission.ECountry);

    if (kMission.m_kTMission.eMission == eFCM_ChryssalidHive)
    {
        kMission.m_iCity = eCity_StJohns;
    }
    else
    {
        kMission.m_iCity = kCountry.GetRandomCity();
    }

    kMission.m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
    kMission.m_iCountry = kCountry.GetID();
    kMission.m_iContinent = kCountry.GetContinent();
    kMission.m_iDuration = 2 * `LWCE_STRATCFG(MissionGeoscapeDuration_Council);
    kMission.m_v2Coords = CITY(kMission.m_iCity).m_v2Coords;
    kMission.m_iDetectedBy = 0;
    kMission.m_iMissionType = eMission_Special;
    kMission.m_kDesc.m_eCouncilType = kMission.m_kTMission.eMission;

    eChar = eChar_Thinman;
    switch (kMission.m_kTMission.eMission)
    {
        case eFCM_TruckStopAssault:
            eChar = eChar_Sectoid;
            break;
        case eFCM_HeliAssault:
            eChar = eChar_Muton;
            break;
    }

    kMission.m_kDesc.m_kAlienSquad = AI().DetermineSpecialMissionSquad(eChar, kMission.m_kTMission.eMission, kMission.m_kTMission.eType == eFCMType_Assault);

    m_iLastAddedMissionID = GEOSCAPE().AddMission(kMission);
    kDateTime.Destroy();

    return kMission;
}

function ECountry DetermineFCRequestCountry()
{
    `LWCE_LOG_DEPRECATED_CLS(DetermineFCRequestCountry);

    return ECountry(0);
}

function name LWCE_DetermineFCRequestCountry()
{
    local array<XGCountry> arrCountries;
    local XGCountry kCountry;

    foreach World().m_arrCountries(kCountry)
    {
        if (kCountry.IsCouncilMember() && !kCountry.LeftXCom())
        {
            arrCountries.AddItem(kCountry);
        }
    }

    return LWCE_XGCountry(arrCountries[Rand(arrCountries.Length)]).m_nmCountry;
}

function DetermineMonthlyGrade(out TCouncilMeeting kMeeting)
{
    `LWCE_LOG_DEPRECATED_CLS(DetermineMonthlyGrade);
}

function LWCE_DetermineMonthlyGrade(out LWCE_TCouncilMeeting kMeeting)
{
    local int iContinent, iScore, iPositive;

    for (iContinent = 0; iContinent < kMeeting.arrContinentSummaries.Length; iContinent++)
    {
        kMeeting.kSummary.iAbductionsThwarted += kMeeting.arrContinentSummaries[iContinent].iAbductionsThwarted;
        kMeeting.kSummary.iTerrorThwarted += kMeeting.arrContinentSummaries[iContinent].iTerrorThwarted;
        kMeeting.kSummary.iSatellitesLaunched += kMeeting.arrContinentSummaries[iContinent].iSatellitesLaunched;
        kMeeting.kSummary.iTechsResearched += kMeeting.arrContinentSummaries[iContinent].iTechsResearched;
        kMeeting.kSummary.iUFORaids += kMeeting.arrContinentSummaries[iContinent].iUFORaids;
        kMeeting.kSummary.iUFOsShotdown += kMeeting.arrContinentSummaries[iContinent].iUFOsShotdown;
        kMeeting.kSummary.iUFOsDetected += kMeeting.arrContinentSummaries[iContinent].iUFOsDetected;
        kMeeting.kSummary.iUFOsEscaped += kMeeting.arrContinentSummaries[iContinent].iUFOsDetected - kMeeting.arrContinentSummaries[iContinent].iUFOsShotdown;
        kMeeting.kSummary.iSatellitesLost += kMeeting.arrContinentSummaries[iContinent].iSatellitesLost;
        kMeeting.kSummary.iAlienBasesAssaulted += kMeeting.arrContinentSummaries[iContinent].iAlienBasesAssaulted;
        kMeeting.kSummary.iCouncilMissionsCompleted += kMeeting.arrContinentSummaries[iContinent].iCouncilMissionsCompleted;
    }

    iPositive = kMeeting.kSummary.iAbductionsThwarted + kMeeting.kSummary.iTerrorThwarted + kMeeting.kSummary.iUFOsShotdown + kMeeting.kSummary.iAlienBasesAssaulted + kMeeting.kSummary.iCouncilMissionsCompleted;

    if (!IsOptionEnabled(/* Dynamic War */ 9))
    {
        // Stat 21 after this point is XCOM's threat category (0 to 4). Prior to this, it is the raw threat, accumulated from taking down UFOs.
        STAT_SetStat(21, Clamp((STAT_GetStat(21)) / 2, 0, 4));

        // If an alien base was assaulted in the previous month, set threat category to max
        if (kMeeting.kSummary.iAlienBasesAssaulted > 0)
        {
            STAT_SetStat(21, 4);
        }
    }
    else
    {
        if (kMeeting.kSummary.iAlienBasesAssaulted > 0)
        {
            STAT_SetStat(21, Max(STAT_GetStat(21), 4));
        }
    }

    if (GetResource(eResource_Money) < 0)
    {
        kMeeting.kSummary.iMismanagedFunds += 1;
    }

    iScore = 0;
    iScore -= kMeeting.kSummary.iMismanagedFunds;
    iScore -= kMeeting.kSummary.iTerrorIgnored;
    iScore -= kMeeting.kSummary.iTerrorFailed;
    iScore -= kMeeting.kSummary.iAbductionsIgnored;
    iScore -= kMeeting.kSummary.iAbductionsFailed;
    iScore -= kMeeting.kSummary.iSatellitesLost;

    if (iScore <= -6 || (iScore < 0 && iPositive == 0) )
    {
        kMeeting.eGrade = eGrade_F;
    }
    else if (iScore <= -4 || (iScore < -1 && iPositive == 1) )
    {
        kMeeting.eGrade = eGrade_D;
    }
    else if (iScore <= -2)
    {
        kMeeting.eGrade = eGrade_C;
    }
    else if (iScore <= -1)
    {
        kMeeting.eGrade = eGrade_B;
    }
    else
    {
        kMeeting.eGrade = eGrade_A;
    }

    kMeeting.strSummary = class'XGLocalizedData'.default.MonthlyGradeSummary[int(kMeeting.eGrade)];
}

function bool DetermineNewFCMission(optional EFCMission eMission)
{
    local TFCMission kMission;
    local ECountry eMCountry;

    if (eMission == eFCM_MeldTutorial)
    {
        eMCountry = ECountry(Continent(HQ().GetContinent()).GetRandomCouncilCountry());
    }
    else
    {
        eMCountry = DetermineFCMissionCountry();
    }

    if (eMission == eFCM_None)
    {
        if (IsProgenyActive())
        {
            if ( (m_eNextProgenyMission == eFCM_Progeny_Portent && AI().GetMonth() > 0) || (PSILABS() != none && AI().GetMonth() > 6) )
            {
                eMission = m_eNextProgenyMission;
            }
        }

        if (eMission == eFCM_None)
        {
            if (IsChryssalidHiveValid() && !HasPlayedChryssalidHive())
            {
                eMission = eFCM_ChryssalidHive;
            }
        }

        if (eMission == eFCM_None)
        {
            eMission = ChooseNextMissionByType(GetRegionByCountry(eMCountry), eMCountry);
        }
    }

    kMission = BuildMission(eMission, eMCountry);
    OnValidMissionAdded(kMission);
    m_arrPreviousMissions.AddItem(kMission.eMission);
    CreateMission(kMission);

    LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('FCMissionActivity').AddInt(kMission.ECountry).Build());

    SITROOM().m_bRequiresAttention = true;
    SITROOM().SetDisabled(false);

    return true;
}

function bool DetermineNewFCRequest(optional EFCRequest eRequest)
{
    `LWCE_LOG_DEPRECATED_CLS(DetermineNewFCRequest);
    return false;
}

function LWCE_TFCRequest LWCE_DetermineNewFCRequest()
{
    local LWCE_TFCRequest kBlank, kRequest;
    local LWCECouncilRequestTemplate kRequestTemplate;
    local name nmRequestingCountry, RequestName;

    SITROOM().SetDisabled(false);
    nmRequestingCountry = LWCE_DetermineFCRequestCountry();
    RequestName = LWCE_ChooseNextRequest();

    if (RequestName == '')
    {
        `LWCE_LOG_VERBOSE("LWCE_DetermineNewFCRequest: couldn't find request template to use");
        return kBlank;
    }

    if (!GetRequestTemplate(RequestName, kRequestTemplate))
    {
        `LWCE_LOG_VERBOSE("LWCE_DetermineNewFCRequest: couldn't get request config for template " $ RequestName);
        return kBlank;
    }

    if (kRequestTemplate.eType == eFCRType_SatLaunch && !LWCE_CanTransferSatellite(nmRequestingCountry))
    {
        `LWCE_LOG_VERBOSE("LWCE_DetermineNewFCRequest: chose satellite request but can't launch sat to " $ nmRequestingCountry);
        return kBlank;
    }

    if (kRequestTemplate.arrRewards.Length == 0)
    {
        `LWCE_LOG_VERBOSE("LWCE_DetermineNewFCRequest: request template " $ RequestName $ " has no rewards configured. Placing on cooldown with no action");
        LWCE_SetRequestCooldown(RequestName);
        return kBlank;
    }

    if (!CreateRequestFromTemplate(kRequest, kRequestTemplate, nmRequestingCountry))
    {
        `LWCE_LOG_VERBOSE("LWCE_DetermineNewFCRequest: couldn't create request from template " $ RequestName);
        return kBlank;
    }

    kRequest.bIsTransferRequest = kRequest.eType == eFCRType_JetTransfer || kRequest.eType == eFCRType_SatLaunch;
    kRequest.bIsTransferComplete = false;

    if (HasConflictingRequest(kRequest))
    {
        `LWCE_LOG_VERBOSE("LWCE_DetermineNewFCRequest: conflicting request exists for template " $ RequestName);
        LWCE_SetRequestCoolDown(RequestName);
        return kBlank;
    }

    LWCE_OnValidRequestAdded(kRequest);

    `LWCE_LOG_VERBOSE("LWCE_DetermineNewFCRequest: added new request using template " $ kRequest.nmRequest);
    return kRequest;
}

function ForceRequest(optional string strRequest)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(ForceRequest);
}

function int GetBestSaleAmount(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetBestSaleAmount);
    return -1;
}

simulated function GetCompletedSatRequestData(out TFCRequest kRequestRef)
{
    `LWCE_LOG_DEPRECATED_CLS(GetCompletedSatRequestData);
}

simulated function LWCE_GetCompletedSatRequestData(out LWCE_TFCRequest kRequestRef)
{
    kRequestRef = m_kLastCompletedSatelliteTransferRequest;
}

function int GetItemQuestPrice(EItemType eItem)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetItemQuestPrice was called. This needs to be replaced with LWCEItemTemplate.GetQuestPrice. Stack trace follows.");
    ScriptTrace();

    return -1;
}

function ECountry GetLastAcceptedRequestCountry()
{
    `LWCE_LOG_DEPRECATED_CLS(GetLastAcceptedRequestCountry);

    return ECountry(0);
}

function name LWCE_GetLastAcceptedRequestCountry()
{
    if (m_arrCECurrentRequests.Length > 0)
    {
        return m_arrCECurrentRequests[m_arrCECurrentRequests.Length - 1].nmRequestingCountry;
    }

    return '';
}

function EFCRequest GetLastAcceptedRequestType()
{
    `LWCE_LOG_DEPRECATED_CLS(GetLastAcceptedRequestType);
    return eFCR_None;
}

function name LWCE_GetLastAcceptedRequestType()
{
    if (m_arrCECurrentRequests.Length > 0)
    {
        return m_arrCECurrentRequests[m_arrCECurrentRequests.Length - 1].nmRequest;
    }

    return '';
}

function int GetNumberOfCorpsesToSell()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetNumberOfCorpsesToSell);
    return -1;
}

function int GetNumberOfFragmentsToSell()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetNumberOfFragmentsToSell);
    return -1;
}

function EFCRequest GetRequestByTitle(string strTitle)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetRequestByTitle);
    return eFCR_None;
}

function EFCRequest GetSatelliteRequest()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetSatelliteRequest);
    return eFCR_None;
}

function EFCRequest GetShipTransferRequest()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetShipTransferRequest);
    return eFCR_None;
}

function bool GetTempRequestItems(out EItemType eItem, out int iAmount)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetTempRequestItems);
    return false;
}

// TODO: add LWCE version that doesn't use ESoldierClass or TCharacter
function GiveCustomSoldier(const out TFundingCouncilRewardSoldier CustomSoldier)
{
    local LWCE_XGStrategySoldier Soldier;

    `LWCE_LOG_ERROR("GiveCustomSoldier not updated to use templates yet!");
    ScriptTrace();
/*
    Soldier = LWCE_XGFacility_Barracks(BARRACKS()).LWCE_CreateSoldier(CustomSoldier.soldierClass, CustomSoldier.SoldierRank, CustomSoldier.Country);
    Soldier.m_kSoldier.kAppearance = CustomSoldier.Appearance;
    Soldier.m_kSoldier.strFirstName = CustomSoldier.firstName;
    Soldier.m_kSoldier.strLastName = CustomSoldier.lastName;
    Soldier.m_kSoldier.strNickName = CustomSoldier.NickName;
    Soldier.m_kChar.aStats[eStat_HP] = CustomSoldier.HP;
    Soldier.m_kChar.aStats[eStat_Offense] = CustomSoldier.Aim;
    Soldier.m_kChar.aStats[eStat_Will] = CustomSoldier.Will;

    if (CustomSoldier.bPsiGift)
    {
        Soldier.bForcePsiGift = true;
    }

    if (CustomSoldier.Appearance.iHead == 308)
    {
        // Zhang
        Soldier.m_kChar.aStats[eStat_HP] = 5;
        Soldier.m_kChar.aStats[eStat_Offense] = 65;
        Soldier.m_kChar.aStats[eStat_Will] = 38;
        Soldier.m_kChar.aStats[eStat_Mobility] = 13;
        Soldier.LWCE_GivePerk(`LW_PERK_ID(LoneWolf), 'Innate');
    }
    else if (CustomSoldier.Appearance.iHead == 420)
    {
        // Annette Durand
        Soldier.m_kChar.bHasPsiGift = true;
        Soldier.m_kSoldier.iPsiRank = 2;
        Soldier.m_kSoldier.iPsiXP = TACTICAL().GetPsiXPRequired(2);
        Soldier.m_kChar.aStats[eStat_Mobility] = 13;
        Soldier.LWCE_GivePerk(Rand(2) == 0 ? `LW_PERK_ID(NeuralFeedback) : `LW_PERK_ID(Mindfray), 'Innate');
        Soldier.LWCE_GivePerk(Rand(2) == 0 ? `LW_PERK_ID(PsiInspiration) : `LW_PERK_ID(DistortionField), 'Innate');
    }
    else if (Soldier.m_kSoldier.strNickName == "Tisiphone")
    {
        Soldier.m_kChar.bHasPsiGift = true;
        Soldier.m_kSoldier.iPsiRank = 2;
        Soldier.m_kSoldier.iPsiXP = TACTICAL().GetPsiXPRequired(2);
        Soldier.LWCE_GivePerk(`LW_PERK_ID(NeuralFeedback), 'Innate');
        Soldier.LWCE_GivePerk(Rand(2) == 0 ? `LW_PERK_ID(PsiInspiration) : `LW_PERK_ID(DistortionField), 'Innate');
    }
    else if (Soldier.m_kSoldier.strNickName == "Megaera")
    {
        Soldier.m_kChar.bHasPsiGift = true;
        Soldier.m_kSoldier.iPsiRank = 2;
        Soldier.m_kSoldier.iPsiXP = TACTICAL().GetPsiXPRequired(2);
        Soldier.LWCE_GivePerk(`LW_PERK_ID(RegenBiofield), 'Innate');
        Soldier.LWCE_GivePerk(Rand(2) == 0 ? `LW_PERK_ID(PsiInspiration) : `LW_PERK_ID(DistortionField), 'Innate');
    }
    else if (Soldier.m_kSoldier.strNickName == "Alecto")
    {
        Soldier.m_kChar.bHasPsiGift = true;
        Soldier.m_kSoldier.iPsiRank = 1;
        Soldier.m_kSoldier.iPsiXP = TACTICAL().GetPsiXPRequired(1);
        Soldier.LWCE_GivePerk(`LW_PERK_ID(MindFray), 'Innate');
    }
    else if (Soldier.m_kSoldier.strNickName == "The General")
    {
        // Van Doorn
        Soldier.m_kChar.aStats[eStat_Mobility] = 13;
        Soldier.LWCE_GivePerk(`LW_PERK_ID(Steadfast), 'Innate');
    }

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(CinematicMode)))
    {
        Soldier.m_kChar.aStats[eStat_Offense] += int(class'XGTacticalGameCore'.default.ABDUCTION_REWARD_SCI);
    }

    Soldier.m_kChar.aStats[eStat_Defense] = 0;
 */
}

// NOTE: the base GrantFCRewards is still used for FC missions and is not deprecated as of now
function LWCE_GrantFCRewards(LWCE_TRequestReward kReward, name nmRewardingCountry)
{
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_XGStorage kStorage;
    local int Index;

    kBarracks = LWCE_XGFacility_Barracks(BARRACKS());
    kStorage = LWCE_XGStorage(STORAGE());

    if (kReward.iCash > 0)
    {
        AddResource(eResource_Money, kReward.iCash);
        STAT_AddStat(eRecap_FCFunding, kReward.iCash);
    }

    if (kReward.iEngineers > 0)
    {
        AddResource(eResource_Engineers, kReward.iEngineers);
    }

    if (kReward.iScientists > 0)
    {
        AddResource(eResource_Scientists, kReward.iScientists);
    }

    if (kReward.iPanic != 0)
    {
        `LWCE_XGCOUNTRY(nmRewardingCountry).AddPanic(kReward.iPanic);
    }

    for (Index = 0; Index < kReward.arrItemRewards.Length; Index++)
    {
        kStorage.LWCE_AddItem(kReward.arrItemRewards[Index].ItemName, kReward.arrItemRewards[Index].iQuantity);
    }

    for (Index = 0; Index < kReward.arrSoldiers.Length; Index++)
    {
        kBarracks.LWCE_CreateSoldier(kReward.arrSoldiers[Index].iClassId, kReward.arrSoldiers[Index].iRank, LWCE_XGCountry(WORLD().GetRandomCountry()).m_nmCountry);
    }
}

function bool HasConflictingRequest(const out LWCE_TFCRequest kRequest)
{
    local int Index;

    for (Index = 0; Index < m_arrCECurrentRequests.Length; Index++)
    {
        if (kRequest.nmRequest == m_arrCECurrentRequests[Index].nmRequest && kRequest.nmRequestingCountry == m_arrCECurrentRequests[Index].nmRequestingCountry)
        {
            return true;
        }
    }

    return false;
}

function bool HasExpiredRequests()
{
    return m_arrCEExpiredRequests.Length > 0;
}

function bool HasFinishedTransferRequest()
{
    local LWCE_TFCRequest kRequest;

    foreach m_arrCECurrentRequests(kRequest)
    {
        if (kRequest.bIsTransferRequest && kRequest.bIsTransferComplete)
        {
            return true;
        }
    }

    return false;
}

function bool HasPendingRequest()
{
    return m_arrCEPendingRequests.Length > 0;
}

function bool HasRequestOfType(EFCRequest iRequest)
{
    `LWCE_LOG_DEPRECATED_CLS(HasRequestOfType);
    return false;
}

function bool LWCE_HasRequestOfType(name RequestName)
{
    local int Index;

    for (Index = 0; Index < m_arrCECurrentRequests.Length; Index++)
    {
        if (m_arrCECurrentRequests[Index].nmRequest == RequestName)
        {
            return true;
        }
    }

    return false;
}

function int IgnorePendingRequest()
{
    m_arrCECurrentRequests.AddItem(m_arrCEPendingRequests[0]);
    m_arrCEPendingRequests.Remove(0, 1);
    OnRequestExpired(0);
    return m_arrCEPendingRequests.Length - 1;
}

function bool IsCountryInContinent(ECountry iCountry, int iContinent)
{
    `LWCE_LOG_DEPRECATED_CLS(IsCountryInContinent);

    return false;
}

function bool LWCE_IsCountryInContinent(name nmCountry, name nmContinent)
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGWorld kWorld;

    kWorld = LWCE_XGWorld(WORLD());
    kContinent = kWorld.LWCE_GetContinent(nmContinent);

    return kContinent.ContainsCountry(nmCountry);
}

function OnCountryLeft(ECountry eLeft)
{
    `LWCE_LOG_DEPRECATED_CLS(OnCountryLeft);
}

function LWCE_OnCountryLeft(name nmCountry)
{
    local int I;

    // Remove any council requests from the country that left
    for (I = m_arrCEPendingRequests.Length - 1; I >= 0; I--)
    {
        if (m_arrCEPendingRequests[I].nmRequestingCountry == nmCountry)
        {
            m_arrCEPendingRequests.Remove(I, 1);
        }
    }

    for (I = m_arrCECurrentRequests.Length - 1; I >= 0; I--)
    {
        if (m_arrCECurrentRequests[I].nmRequestingCountry == nmCountry)
        {
            m_arrCECurrentRequests.Remove(I, 1);
        }
    }

    LWCE_XGFacility_SituationRoom(SITROOM()).LWCE_PushCountryWithdrawHeadline(nmCountry);
}

function OnRequestCompleted(int iRequestIndex)
{
    local LWCE_XGFacility_SituationRoom kSitRoom;
    local TText kText;
    local LWCE_XGCountry kCountry;

    kSitRoom = LWCE_XGFacility_SituationRoom(SITROOM());
    kCountry = `LWCE_XGCOUNTRY(m_arrCECurrentRequests[iRequestIndex].nmRequestingCountry);

    if (m_arrCECurrentRequests[iRequestIndex].eType == eFCRType_SatLaunch)
    {
        m_kLastCompletedSatelliteTransferRequest = m_arrCECurrentRequests[iRequestIndex];
        PRES().UIFundingCouncilRequestComplete(m_kSatRequestCompleteAdaptor);
    }

    kText.iState = eUIState_Good;
    kText.StrValue = m_arrCECurrentRequests[iRequestIndex].strTickerSuccess;
    kSitRoom.LWCE_PushFundingCouncilHeadline(m_arrCECurrentRequests[iRequestIndex].nmRequestingCountry, kText);

    Achieve(AT_HappyToOblige);

    // Add shields to the requesting country
    kCountry.m_iShields = Clamp(kCountry.m_iShields + m_arrCECurrentRequests[iRequestIndex].kReward.iCountryDefense, 0, 100);

    m_arrCECurrentRequests.Remove(iRequestIndex, 1);

    // New to LWCE: base game doesn't update HUD on request turn-in
    PRES().GetStrategyHUD().ClearResources();
    PRES().GetStrategyHUD().UpdateFunds();
}

function OnRequestExpired(int iRequestIndex)
{
    local LWCE_XGFacility_SituationRoom kSitRoom;
    local LWCEDataContainer kData;
    local TText kText;

    kSitRoom = LWCE_XGFacility_SituationRoom(SITROOM());

    if (iRequestIndex != -1)
    {
        kData = class'LWCEDataContainer'.static.NewName('NotifyData', m_arrCECurrentRequests[iRequestIndex].nmRequestingCountry);
        LWCE_XComHQPresentationLayer(PRES()).LWCE_Notify('FCExpiredRequest', kData);

        m_arrCEExpiredRequests.AddItem(m_arrCECurrentRequests[iRequestIndex]);
    }

    kText.iState = eUIState_Bad;
    kText.StrValue = m_arrCECurrentRequests[iRequestIndex].strTickerIgnore;
    kSitRoom.LWCE_PushFundingCouncilHeadline(m_arrCECurrentRequests[iRequestIndex].nmRequestingCountry, kText);

    m_arrCECurrentRequests.Remove(iRequestIndex, 1);
}

function OnSatelliteTransferExecuted(TSatellite kSatellite)
{
    `LWCE_LOG_DEPRECATED_CLS(OnSatelliteTransferExecuted);
}

function LWCE_OnSatelliteTransferExecuted(LWCE_TSatellite kSatellite)
{
    LWCE_OnSatelliteSuccessfullyTransferred(kSatellite, false, true);
}

function OnSatelliteSuccessfullyTransferred(TSatellite kSatellite, optional bool bSitRoomAttention = true, optional bool bTurnInRequest = false)
{
    `LWCE_LOG_DEPRECATED_CLS(OnSatelliteSuccessfullyTransferred);
}

function LWCE_OnSatelliteSuccessfullyTransferred(LWCE_TSatellite kSatellite, optional bool bSitRoomAttention = true, optional bool bTurnInRequest = false)
{
    local int iRequest;

    // TODO: commented until we change countries to names
    for (iRequest = 0; iRequest < m_arrCECurrentRequests.Length; iRequest++)
    {
        if (m_arrCECurrentRequests[iRequest].eType == eFCRType_SatLaunch)
        {
            if (m_arrCECurrentRequests[iRequest].nmRequestingCountry == kSatellite.nmCountry)
            {
                SITROOM().m_bRequiresAttention = bSitRoomAttention;
                m_arrCECurrentRequests[iRequest].bIsTransferComplete = true;

                if (bTurnInRequest)
                {
                    LWCE_GrantFCRewards(m_arrCECurrentRequests[iRequest].kReward, m_arrCECurrentRequests[iRequest].nmRequestingCountry);
                    OnRequestCompleted(iRequest);
                }

                break;
            }
        }
    }
}

function OnShipAdded(EShipType eShip, int iContinent)
{
    `LWCE_LOG_DEPRECATED_CLS(OnShipAdded);
}

function LWCE_OnShipAdded(LWCE_XGShip kShip)
{
    local LWCE_XGFacility_Hangar kHangar;
    local LWCE_XGContinent kContinent;
    local LWCE_XGWorld kWorld;
    local int Index;

    kHangar = LWCE_XGFacility_Hangar(HANGAR());
    kWorld = LWCE_XGWorld(WORLD());

    // When an interceptor order completes, check if there's an outstanding council request
    // for an interceptor to that continent, and turn it in if so
    for (Index = 0; Index < m_arrCECurrentRequests.Length; Index++)
    {
        if (m_arrCECurrentRequests[Index].bIsTransferRequest && !m_arrCECurrentRequests[Index].bIsTransferComplete)
        {
            if (kShip.m_nmShipTemplate == 'Interceptor' && m_arrCECurrentRequests[Index].eType == eFCRType_JetTransfer)
            {
                kContinent = kWorld.GetContinentContainingCountry(m_arrCECurrentRequests[Index].nmRequestingCountry);

                // TODO: not entirely sure why this check is here
                if (!kHangar.LWCE_IsShipInTransitTo(kContinent.m_nmContinent))
                {
                    m_arrCECurrentRequests[Index].bIsTransferComplete = true;
                    AttemptTurnInRequest(Index);
                    return;
                }
            }
        }
    }
}

function OnShipSuccessfullyTransferred(XGShip_Interceptor kShip, optional bool bSitRoomAttention = true, optional bool bAttemptTurnInRequest = false)
{
    `LWCE_LOG_DEPRECATED_CLS(OnShipSuccessfullyTransferred);
}

function LWCE_OnShipSuccessfullyTransferred(LWCE_XGShip kShip, optional bool bSitRoomAttention = true, optional bool bAttemptTurnInRequest = false)
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGWorld kWorld;
    local int iRequest;

    kWorld = LWCE_XGWorld(WORLD());

    for (iRequest = 0; iRequest < m_arrCECurrentRequests.Length; iRequest++)
    {
        if (m_arrCECurrentRequests[iRequest].eType == eFCRType_JetTransfer)
        {
            kContinent = kWorld.GetContinentContainingCountry(m_arrCECurrentRequests[iRequest].nmRequestingCountry);

            if (kContinent.m_nmContinent == kShip.m_nmContinent)
            {
                LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('FCJetTransfer').AddName(m_arrCECurrentRequests[iRequest].nmRequestingCountry).Build());
                SITROOM().m_bRequiresAttention = bSitRoomAttention;
                m_arrCECurrentRequests[iRequest].bIsTransferComplete = true;

                if (bAttemptTurnInRequest)
                {
                    AttemptTurnInRequest(iRequest);
                }

                break;
            }
        }
    }
}

function OnShipTransferExecuted(XGShip_Interceptor kShip)
{
    `LWCE_LOG_DEPRECATED_CLS(OnShipTransferExecuted);
}

/// <summary>
/// Called when the transfer of a ship between two continents has begun.
/// </summary>
function LWCE_OnShipTransferExecuted(LWCE_XGShip kShip)
{
    LWCE_OnShipSuccessfullyTransferred(kShip, /* bSitRoomAttention */ false, /* bAttemptTurnInRequest */ true);
}

function OnValidRequestAdded(out TFCRequest kRequest)
{
    `LWCE_LOG_DEPRECATED_CLS(OnValidRequestAdded);
}

function LWCE_OnValidRequestAdded(out LWCE_TFCRequest kRequest)
{
    local LWCEDataContainer kData;

    m_iFCRequestsThisMonth++;

    LWCE_SetRequestCoolDown(kRequest.nmRequest);

    if (LWCE_CanAcceptRequest(kRequest))
    {
        m_arrCEPendingRequests.AddItem(kRequest);
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_OnFundingCouncilRequestAdded();
    }
    else
    {
        m_arrCECurrentRequests.AddItem(kRequest);

        kData = class'LWCEDataContainer'.static.NewName('NotifyData', kRequest.nmRequestingCountry);
        LWCE_XComHQPresentationLayer(PRES()).LWCE_Notify('FCDelayedRequest', kData);
    }
}

function int PassesRequestRequirements(TFCRequest kRequest)
{
    `LWCE_LOG_DEPRECATED_CLS(PassesRequestRequirements);
    return -1;
}

function bool LWCE_PassesRequestRequirements(const LWCECouncilRequestTemplate kRequestTemplate)
{
    local int Index;

    // Don't allow any request that's already active
    for (Index = 0; Index < m_arrCECurrentRequests.Length; Index++)
    {
        // Base game checks by localized name, presumably because that codifies both the request type and the country involved.
        // We add a check by request name in case two mods add requests with the same localized name.
        if (m_arrCECurrentRequests[Index].nmRequest == kRequestTemplate.GetRequestName() && m_arrCECurrentRequests[Index].strName == kRequestTemplate.strName)
        {
            return false;
        }
    }

    if (kRequestTemplate.eType == eFCRType_JetTransfer && HANGAR().m_arrInts.Length > 0)
    {
        return true;
    }

    // Having 0 rewards is allowed for the Jet Transfer request to match LW 1.0 behavior; see ini for details.
    if (kRequestTemplate.arrRewards.Length == 0 && kRequestTemplate.eType != eFCRType_JetTransfer)
    {
        return false;
    }

    if (kRequestTemplate.arrRequestedItems.Length == 0 && kRequestTemplate.eType != eFCRType_SatLaunch)
    {
        return false;
    }

    return `LWCE_HQ.ArePrereqsFulfilled(kRequestTemplate.kPrereqs);
}

function SetRequestCoolDown(out EFCRequest kRequest, int amnt)
{
    `LWCE_LOG_DEPRECATED_CLS(SetRequestCoolDown);
}

function LWCE_SetRequestCooldown(name RequestName)
{
    local LWCECouncilRequestTemplate kRequestTemplate;
    local LWCEDataContainer kEventData;
    local LWCE_TRequestCooldown kCooldown;
    local int iCooldown, Index;

    if (!GetRequestTemplate(RequestName, kRequestTemplate))
    {
        return;
    }

    if (kRequestTemplate.iCooldownInHours <= 0)
    {
        return;
    }

    iCooldown = kRequestTemplate.iCooldownInHours;

    Index = m_arrCERequestCooldowns.Find('nmRequest', RequestName);

    if (Index != INDEX_NONE)
    {
        m_arrCERequestCooldowns[Index].iHoursRemaining = iCooldown;
    }
    else
    {
        kCooldown.nmRequest = RequestName;
        kCooldown.iHoursRemaining = iCooldown;
        m_arrCERequestCooldowns.AddItem(kCooldown);
    }

    // EVENT: CouncilRequestOnCooldown
    //
    // SUMMARY: Emitted after a council request has been placed on cooldown. Typically this occurs as soon as a request is generated and made available to
    //          the player, but sometimes this isn't the case. For example, the request may be generated but discarded because no valid rewards exist, or
    //          because a pre-existing council request conflicts with the new one.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: name - The name of the LWCECouncilRequestTemplate instance which was placed on cooldown.
    //       Data[1]: int - Return parameter for event handlers. The cooldown, in hours, of the request. Event handlers can modify this value, or even return
    //                      a zero or negative value, which will immediately take the request off cooldown again.
    //
    // SOURCE: LWCE_XGFundingCouncil
    kEventData = class'LWCEDataContainer'.static.New('CouncilRequestOnCooldown');
    kEventData.AddName(RequestName);
    kEventData.AddInt(iCooldown);

    `LWCE_EVENT_MGR.TriggerEvent('CouncilRequestOnCooldown', kEventData, self);

    iCooldown = kEventData.Data[1].I;

    // Find the index again even if we already had it before; an event handler may have modified our array
    Index = m_arrCERequestCooldowns.Find('nmRequest', RequestName);

    if (iCooldown <= 0)
    {
        m_arrCERequestCooldowns.Remove(Index, 1);
    }
    else
    {
        m_arrCERequestCooldowns[Index].iHoursRemaining = iCooldown;
    }
}

protected function int DetermineItemQuantityToRequest(LWCE_TRequestItemConfig kRequestItemConfig, bool bIsDynamicWar)
{
    local bool bShouldScaleForDynamicWar;
    local int iCurrentMonth, iQuantity, iScalingPerMonth;
    local LWCE_TRange kQuantityRange, kScalingRange;

    iCurrentMonth = AI().GetMonth();
    kQuantityRange = kRequestItemConfig.kQuantityRange;
    kScalingRange = kRequestItemConfig.kPerMonthScaling;

    if (bIsDynamicWar && kRequestItemConfig.bScaleForDynamicWar)
    {
        bShouldScaleForDynamicWar = true;

        // This is the most straightforward match to LW's logic, which used hardcoded values instead for min quantity
        kQuantityRange.MinInclusive = (kQuantityRange.MinInclusive * 2) / 3;
        kQuantityRange.MaxInclusive = kQuantityRange.MaxInclusive * class'XGTacticalGameCore'.default.SW_MARATHON;
    }

    iScalingPerMonth = `LWCE_UTILS.RandInRange(kScalingRange);
    iQuantity = iCurrentMonth * iScalingPerMonth;

    if (bShouldScaleForDynamicWar)
    {
        iQuantity *= class'XGTacticalGameCore'.default.SW_MARATHON;
    }

    iQuantity = Clamp(iQuantity, kQuantityRange.MinInclusive, kQuantityRange.MaxInclusive);

    return iQuantity;
}

protected function int GetRemainingCooldown(name RequestName)
{
    local int Index;

    Index = m_arrCERequestCooldowns.Find('nmRequest', RequestName);

    if (Index == INDEX_NONE)
    {
        return 0;
    }

    return m_arrCERequestCooldowns[Index].iHoursRemaining;
}

protected function bool GetRequestTemplate(name RequestName, out LWCECouncilRequestTemplate kRequestTemplate)
{
    kRequestTemplate = m_kTemplateMgr.FindCouncilRequestTemplate(RequestName);

    return kRequestTemplate != none;
}

/// <summary>
/// Calculates the equivalent cash value of a reward. This is each individual item's quest price, plus the minimum
/// quantity of the original reward, then multiplied by the number of items requested and by the profit margin.
/// </summary>
protected function int GetRewardEquivalentCashValue(const out LWCE_TFCRequest kRequest, int iMinQuantity)
{
    local LWCEItemTemplate kItem;
    local int iCash, Index;

    for (Index = 0; Index < kRequest.arrRequestedItems.Length; Index++)
    {
        kItem = `LWCE_ITEM(kRequest.arrRequestedItems[Index].ItemName);

        // Profit margin is deliberately applied at each step, to most closely match LW 1.0 (due to integer truncation)
        iCash += PROFIT_MARGIN * kRequest.arrRequestedItems[Index].iQuantity * (kItem.GetQuestPrice() + iMinQuantity);
    }

    return iCash;
}