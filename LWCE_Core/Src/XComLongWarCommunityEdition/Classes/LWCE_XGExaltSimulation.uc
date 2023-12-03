class LWCE_XGExaltSimulation extends XGExaltSimulation
    dependson(LWCE_XGFacility_Labs, LWCE_XGMissionControlUI);

struct LWCE_TExaltClueDefinition
{
    var int m_iClueTextIndex;
    var array<name> m_arrValidCountries;
    var array<name> m_arrInvalidCountries;
};

struct LWCE_TExaltCellData
{
    var name m_nmCountry;
    var int m_iDaysUntilHidden;
    var int m_iDaysUntilNextActivity;
};

struct LWCE_TExaltCellPlacementScore
{
    var name m_nmCountry;
    var float m_fScore;
};

struct LWCE_TCovertOpsOperative
{
    var LWCE_XGStrategySoldier m_kCovertOpsSoldier;
    var name m_nmInfiltratedCountry;
    var int m_iDaysUntilComplete;
};

struct LWCE_TExaltCellLastVisibilityStatus
{
    var name m_nmCountry;
    var EExaltCellLastVisibilityStatus m_eVisibilityStatus;
};

struct CheckpointRecord_LWCE_XGExaltSimulation extends XGExaltSimulation.CheckpointRecord
{
    var array<LWCE_TExaltClueDefinition> m_arrCEClues;
    var array<LWCE_TExaltCellData> m_arrCECellData;
    var array<LWCE_TExaltCellLastVisibilityStatus> m_arrCECellLastVisibilityData;
    var LWCE_TCovertOpsOperative m_kCECovertOpsOperative;
    var array<name> m_arrCEAccusedCountries;
    var name m_nmExaltCountry;
};

// TODO populate this config
var config array<config LWCE_TExaltClueDefinition> m_arrCEClueDefinitions;

var array<LWCE_TExaltClueDefinition> m_arrCEClues;
var array<LWCE_TExaltCellData> m_arrCECellData;
var array<LWCE_TExaltCellLastVisibilityStatus> m_arrCECellLastVisibilityData;
var LWCE_TCovertOpsOperative m_kCECovertOpsOperative;
var array<name> m_arrCEAccusedCountries;
var name m_nmExaltCountry;

function bool AccuseCountry(ECountry eAccusedCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(AccuseCountry);

    return false;
}

function bool LWCE_AccuseCountry(name nmAccusedCountry)
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local name nmNeighborCountry;
    local XGMission kMission;

    kWorld = LWCE_XGWorld(WORLD());

    if (!IsExaltActive())
    {
        return false;
    }

    if (LWCE_HasCountryBeenAccused(nmAccusedCountry))
    {
        return false;
    }

    m_arrCEAccusedCountries.AddItem(nmAccusedCountry);

    if (nmAccusedCountry == m_nmExaltCountry)
    {
        kMission = LWCE_XGStrategyAI(AI()).LWCE_CreateExaltRaidMission(m_nmExaltCountry);
        GEOSCAPE().AddMission(kMission);
        return true;
    }
    else
    {
        kCountry = kWorld.LWCE_GetCountry(nmAccusedCountry);

        if (kCountry.LeftXCom())
        {
            kContinent = kWorld.LWCE_GetContinent(kCountry.LWCE_GetContinent());

            foreach kContinent.m_kTemplate.arrCountries(nmNeighborCountry)
            {
                kCountry = kWorld.LWCE_GetCountry(nmNeighborCountry);

                if (kCountry.IsCouncilMember())
                {
                    kCountry.AddPanic(40);
                }
            }
        }
        else
        {
            kCountry.LeaveXComProject();
        }

        // False accusations give the aliens +50 research
        STAT_AddStat(2, 50);
    }

    return false;
}

function BeginSimulation()
{
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;

    kWorld = LWCE_XGWorld(WORLD());

    if (IsExaltActive() || IsOptionEnabled(/* United Humanity */ 23))
    {
        return;
    }

    while (kCountry == none || !kCountry.IsCouncilMember())
    {
        kCountry = LWCE_XGCountry(kWorld.GetRandomCountry());
    }

    m_nmExaltCountry = kCountry.m_nmCountry;
    LWCE_SelectClues(m_nmExaltCountry);

    m_iCellPlacementCooldown = m_kTuning.m_iExaltStartDelayDays + Rand(m_kTuning.m_iExaltStartDelayDaysVariation);
    m_kNextDayTimer = 1;
    m_eSimulationState = eExaltSimulationState_FirstCellDelay;
}

function ClearCell(ECountry nmCountryToClear)
{
    `LWCE_LOG_DEPRECATED_CLS(ClearCell);
}

function LWCE_ClearCell(name nmCountryToClear)
{
    local LWCE_XComHQPresentationLayer kPres;
    local int iIndex, iCellsToReplace;

    kPres = LWCE_XComHQPresentationLayer(PRES());
    m_bCellClearedPostCombat = false;

    if (!IsExaltActive())
    {
        return;
    }

    for (iIndex = 0; iIndex < m_arrCECellData.Length; iIndex++)
    {
        if (m_arrCECellData[iIndex].m_nmCountry == nmCountryToClear)
        {
            m_arrCECellData.Remove(iIndex, 1);
            LWCE_SetLastVisibiltyStatus(nmCountryToClear, eExaltCellLastVisibilityStatus_Removed);
            m_iCellsCleared++;
            m_bCellClearedPostCombat = true;
            break;
        }
    }

    for (iIndex = 0; iIndex < m_arrCECellData.Length; iIndex++)
    {
        if (LWCE_IsCellExposedInCountry(m_arrCECellData[iIndex].m_nmCountry))
        {
            iCellsToReplace++;
            m_arrCECellData.Remove(iIndex, 1);
            LWCE_SetLastVisibiltyStatus(m_arrCECellData[iIndex].m_nmCountry, eExaltCellLastVisibilityStatus_Hidden);
            kPres.LWCE_Notify('CellHides', class'LWCEDataContainer'.static.NewName('NotifyData', m_arrCECellData[iIndex].m_nmCountry));
            iIndex--;
        }
    }

    while (iCellsToReplace > 0)
    {
        PlaceNextCell(true);
        iCellsToReplace--;
    }
}

function ClearLastVisibiltyStatusForAllCountries()
{
    m_arrCECellLastVisibilityData.Length = 0;
}

function ClearOperative()
{
    if (m_kCECovertOpsOperative.m_kCovertOpsSoldier != none)
    {
        if (!m_kCECovertOpsOperative.m_kCovertOpsSoldier.IsDead())
        {
            m_kCECovertOpsOperative.m_kCovertOpsSoldier.SetStatus(m_kCECovertOpsOperative.m_kCovertOpsSoldier.IsInjured() ? eStatus_Healing : ESoldierStatus(8));
            STORAGE().RestoreBackedUpInventory(m_kCECovertOpsOperative.m_kCovertOpsSoldier);
        }

        m_kCECovertOpsOperative.m_kCovertOpsSoldier = none;
    }
}

function ExposeCell(ECountry eCountryToExpose)
{
    `LWCE_LOG_DEPRECATED_CLS(ExposeCell);
}

function LWCE_ExposeCell(name nmCountryToExpose)
{
    local int iIndex, iDaysToExpose;

    for (iIndex = 0; iIndex < m_arrCECellData.Length; iIndex++)
    {
        if (m_arrCECellData[iIndex].m_nmCountry == nmCountryToExpose)
        {
            if (m_arrCECellData[iIndex].m_iDaysUntilHidden <= 0)
            {
                LWCE_SetLastVisibiltyStatus(nmCountryToExpose, 1);
            }

            iDaysToExpose = int(RandRange(m_kTuning.m_kCellTuning.m_iMinDaysToHide, m_kTuning.m_kCellTuning.m_iMaxDaysToHide));
            m_arrCECellData[iIndex].m_iDaysUntilHidden = iDaysToExpose;
            return;
        }
    }
}

function int GetCollectedClueCount()
{
    return LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable('Item_EXALTIntelligence');
}

function int GetCurrentOperativeCountry()
{
    `LWCE_LOG_DEPRECATED_CLS(GetCurrentOperativeCountry);

    return -1;
}

function name LWCE_GetCurrentOperativeCountry()
{
    if (IsOperativeInField())
    {
        return m_kCECovertOpsOperative.m_nmInfiltratedCountry;
    }
    else
    {
        return '';
    }
}

function GetEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEvents);
}

function LWCE_GetEvents(out array<LWCE_THQEvent> arrEvents)
{
    local LWCE_THQEvent kEvent;

    if (IsExaltActive() && IsOperativeInField() && !IsOperativeReadyForExtraction())
    {
        kEvent.EventType = 'CovertOperative';
        kEvent.iHours = m_kCECovertOpsOperative.m_iDaysUntilComplete * 24;

        arrEvents.AddItem(kEvent);
    }
}

function EExaltCellLastVisibilityStatus GetLastVisibiltyStatus(ECountry eCountryToCheck)
{
    `LWCE_LOG_DEPRECATED_CLS(GetLastVisibiltyStatus);

    return EExaltCellLastVisibilityStatus(0);
}

function EExaltCellLastVisibilityStatus LWCE_GetLastVisibiltyStatus(name nmCountryToCheck)
{
    local int iIndex;

    for (iIndex = 0; iIndex < m_arrCECellLastVisibilityData.Length; iIndex++)
    {
        if (m_arrCECellLastVisibilityData[iIndex].m_nmCountry == nmCountryToCheck)
        {
            return m_arrCECellLastVisibilityData[iIndex].m_eVisibilityStatus;
        }
    }

    return 0;
}

function int GetNumCountriesNotRuledOutByClues()
{
    local array<LWCE_XGCountry> arrCountries;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local int iValidCountries;

    kWorld = LWCE_XGWorld(WORLD());
    arrCountries = kWorld.LWCE_GetCountries();

    foreach arrCountries(kCountry)
    {
        if (kCountry.IsCouncilMember() && !LWCE_IsCountryRuledOutByCurrentClues(kCountry.m_nmCountry))
        {
            iValidCountries++;
        }
    }

    return iValidCountries;
}

function XGStrategySoldier GetOperative()
{
    return m_kCECovertOpsOperative.m_kCovertOpsSoldier;
}

function int GetPanicMod(ECountry eCountryToCheck, int iBasePanic)
{
    `LWCE_LOG_DEPRECATED_CLS(GetPanicMod);

    return 1000;
}

function int LWCE_GetPanicMod(name nmCountryToCheck, int iBasePanic)
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGCountry kCountry;
    local name nmCountry;

    if (!IsExaltActive())
    {
        return 0;
    }

    if (iBasePanic <= 0)
    {
        return 0;
    }

    if (IsOperativeInField())
    {
        return 0;
    }

    kCountry = `LWCE_XGCOUNTRY(nmCountryToCheck);
    kContinent = `LWCE_XGCONTINENT(kCountry.LWCE_GetContinent());

    foreach kContinent.m_kTemplate.arrCountries(nmCountry)
    {
        if (LWCE_IsCellActiveInCountry(nmCountry) && !LWCE_IsCellExposedInCountry(nmCountry))
        {
            if (Roll(50))
            {
                return Min(10, iBasePanic);
            }
        }
    }

    return 0;
}

function bool HasCountryBeenAccused(ECountry eCountryToCheck)
{
    `LWCE_LOG_DEPRECATED_CLS(HasCountryBeenAccused);

    return false;
}

function bool LWCE_HasCountryBeenAccused(name nmCountryToCheck)
{
    return m_arrCEAccusedCountries.Find(nmCountryToCheck) != INDEX_NONE;
}

function bool HasExaltBeenSuccessfullyAccused()
{
    return m_arrCEAccusedCountries.Find(m_nmExaltCountry) >= 0;
}

function bool IsCellActiveInCountry(ECountry eCountryToCheck)
{
    `LWCE_LOG_DEPRECATED_CLS(IsCellActiveInCountry);

    return false;
}

function bool LWCE_IsCellActiveInCountry(name nmCountryToCheck)
{
    local LWCE_TExaltCellData kData;

    if (!IsExaltActive())
    {
        return false;
    }

    foreach m_arrCECellData(kData)
    {
        if (kData.m_nmCountry == nmCountryToCheck)
        {
            return true;
        }
    }

    return false;
}

function bool IsCellExposedInCountry(ECountry eCountryToCheck)
{
    `LWCE_LOG_DEPRECATED_CLS(IsCellExposedInCountry);

    return false;
}

function bool LWCE_IsCellExposedInCountry(name nmCountryToCheck)
{
    local LWCE_TExaltCellData kData;

    if (!IsExaltActive())
    {
        return false;
    }

    foreach m_arrCECellData(kData)
    {
        if (kData.m_nmCountry == nmCountryToCheck)
        {
            return kData.m_iDaysUntilHidden > 0;
        }
    }

    return false;
}

function bool IsCountryRuledOutByClueAtIndex(ECountry eCountryToCheck, int iClueIndex)
{
    `LWCE_LOG_DEPRECATED_CLS(IsCountryRuledOutByClueAtIndex);

    return false;
}

function bool LWCE_IsCountryRuledOutByClueAtIndex(name nmCountryToCheck, int iClueIndex)
{
    return LWCE_IsCountryRuledOutByClue(nmCountryToCheck, m_arrCEClues[iClueIndex]);
}

function bool IsExaltBaseExposedInCountry(ECountry eCountryToCheck)
{
    `LWCE_LOG_DEPRECATED_CLS(IsExaltBaseExposedInCountry);

    return true;
}

function bool LWCE_IsExaltBaseExposedInCountry(name nmCountryToCheck)
{
    if (!IsExaltActive())
    {
        return false;
    }

    if (nmCountryToCheck == m_nmExaltCountry && HasExaltBeenSuccessfullyAccused())
    {
        return true;
    }

    return false;
}

function bool IsOperativeInCountry(ECountry eCountryToCheck)
{
    `LWCE_LOG_DEPRECATED_CLS(IsOperativeInCountry);

    return false;
}

function bool LWCE_IsOperativeInCountry(name nmCountryToCheck)
{
    return IsOperativeInField() && m_kCECovertOpsOperative.m_nmInfiltratedCountry == nmCountryToCheck;
}

function bool IsOperativeInField()
{
    return m_kCECovertOpsOperative.m_kCovertOpsSoldier != none;
}

function bool IsOperativeReadyForExtraction()
{
    return IsOperativeInField() && m_kCECovertOpsOperative.m_iDaysUntilComplete <= 0;
}

function PerformIncreasePanicOperation(ECountry nmOperationCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(PerformIncreasePanicOperation);
}

function LWCE_PerformIncreasePanicOperation(name nmOperationCountry)
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local int iPropagandaPanicAmount;
    local array<name> arrValidCountries;
    local name nmCountryIter;

    kWorld = LWCE_XGWorld(WORLD());
    kCountry = kWorld.LWCE_GetCountry(nmOperationCountry);
    kContinent = kWorld.LWCE_GetContinent(kCountry.LWCE_GetContinent());

    if (kCountry.LeftXCom())
    {
        return;
    }

    iPropagandaPanicAmount = 40;
    kCountry.AddPanic(iPropagandaPanicAmount);

    // Select a random country on the same continent as the target to also receive panic
    foreach kContinent.m_kTemplate.arrCountries(nmCountryIter)
    {
        kCountry = kWorld.LWCE_GetCountry(nmCountryIter);

        if (!kCountry.LeftXCom() && nmCountryIter != nmOperationCountry)
        {
            arrValidCountries.AddItem(nmCountryIter);
        }
    }

    if (arrValidCountries.Length > 0)
    {
        kCountry = kWorld.LWCE_GetCountry(arrValidCountries[Rand(arrValidCountries.Length)]);
        kCountry.AddPanic(20);
    }

    LWCE_ExposeCell(nmOperationCountry);
    PRES().UINarrative(`XComNarrativeMomentEW("ExaltIntro"));
    LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('ExaltMissionActivity').AddName(nmOperationCountry).AddInt(2).Build());
    LWCE_XGFacility_SituationRoom(SITROOM()).LWCE_PushExaltOperationHeadline(nmOperationCountry, 1);

    m_iDaysSinceLastOperation = 0;
}

function PerformRandomOperation(ECountry eOperationCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(PerformRandomOperation);
}

function LWCE_PerformRandomOperation(name nmOperationCountry)
{
    local array<EExaltCellExposeReason> arrPossibleOperations;
    local EExaltCellExposeReason eChosenOperation;

    arrPossibleOperations = LWCE_GetPossibleOperationTypes(nmOperationCountry);

    if (arrPossibleOperations.Length == 0)
    {
        LWCE_RelocateCell(nmOperationCountry);
        return;
    }

    eChosenOperation = arrPossibleOperations[Rand(arrPossibleOperations.Length)];

    switch (eChosenOperation)
    {
        case eExaltCellExposeReason_SabatogeOperation:
            LWCE_PerformSabotageOperation(nmOperationCountry);
            return;
        case eExaltCellExposeReason_IncreasedPanic:
            LWCE_PerformIncreasePanicOperation(nmOperationCountry);
            return;
        case eExaltCellExposeReason_ResearchHack:
            LWCE_PerformResearchHackOperation(nmOperationCountry);
            return;
    }
}

function PerformResearchHackOperation(ECountry nmOperationCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(PerformResearchHackOperation);
}

function LWCE_PerformResearchHackOperation(name nmOperationCountry)
{
    local int iEstimatedProjectHours, iRemainingProjectHours, iPercentageHoursHacked, iBaseHoursHacked, iHoursHacked, iLabReduction;
    local int iProgressIndex;
    local LWCE_TResearchProject kProject;
    local LWCE_XGFacility_Labs kLabs;

    kLabs = `LWCE_LABS;

    if (!kLabs.HasProject())
    {
        return;
    }

    kProject = kLabs.m_kCEProject;
    iEstimatedProjectHours = kProject.iEstimate * 24;
    iRemainingProjectHours = kLabs.GetHoursLeftOnProject();
    iPercentageHoursHacked = int(float(iEstimatedProjectHours) * m_kTuning.m_kCellTuning.m_fResearchHackPercentage);
    iBaseHoursHacked = m_kTuning.m_kCellTuning.m_iMinResearchHackDays * 24;
    iHoursHacked = Max(iPercentageHoursHacked, iBaseHoursHacked);
    iHoursHacked = Min(iHoursHacked, iEstimatedProjectHours - iRemainingProjectHours);
    iLabReduction = int(float(iHoursHacked * HQ().GetNumFacilities(eFacility_ScienceLab)) * 0.20);
    iHoursHacked -= iLabReduction;
    iHoursHacked = Max(0, iHoursHacked);

    kLabs.m_kCEProject.iActualHoursLeft += (iHoursHacked * kLabs.GetResearchPerHour());

    iProgressIndex = kLabs.m_arrCEProgress.Find('TechName', kProject.TechName);

    if (iProgressIndex != INDEX_NONE)
    {
        kLabs.m_arrCEProgress[iProgressIndex].iHoursCompleted -= iHoursHacked * kLabs.GetResearchPerHour();
    }

    LWCE_ExposeCell(nmOperationCountry);
    PRES().UINarrative(`XComNarrativeMomentEW("ExaltIntro"));
    LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('ExaltResearchHack').AddName(nmOperationCountry).AddInt(3).AddInt(iHoursHacked).AddInt(iLabReduction).Build());
    LWCE_XGFacility_SituationRoom(SITROOM()).LWCE_PushExaltOperationHeadline(nmOperationCountry, 3);

    m_iDaysSinceLastOperation = 0;
}

function PerformSabotageOperation(ECountry nmOperationCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(PerformSabotageOperation);
}

function LWCE_PerformSabotageOperation(name nmOperationCountry)
{
    local int iAmountStolen;

    LWCE_ExposeCell(nmOperationCountry);
    iAmountStolen = 40 * AI().GetMonth() + Rand(100);

    if (iAmountStolen > 0)
    {
        HQ().AddResource(eResource_Money, -iAmountStolen);
        PRES().UINarrative(`XComNarrativeMomentEW("ExaltIntro"));
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('ExaltMissionActivity').AddName(nmOperationCountry).AddInt(1).AddInt(iAmountStolen).Build());
        LWCE_XGFacility_SituationRoom(SITROOM()).LWCE_PushExaltOperationHeadline(nmOperationCountry, 2);
        m_iDaysSinceLastOperation = 0;
    }
}

function PerformSweep()
{
    local int iIndex;

    if (!CanPerformSweep())
    {
        return;
    }

    for (iIndex = 0; iIndex < m_arrCECellData.Length; iIndex++)
    {
        LWCE_ExposeCell(m_arrCECellData[iIndex].m_nmCountry);
    }

    HQ().AddResource(eResource_Money, -GetSweepCost());

    m_iSweepCount++;
    m_bHasTimePassedSinceLastSweep = false;
}

function PlaceNextCell(optional bool bIgnoreDiceRoll = false)
{
    local LWCE_TExaltCellData kData;
    local name nmCountryToTry;

    if (!IsExaltActive())
    {
        return;
    }

    if (m_arrCECellData.Length >= m_kTuning.m_kCellTuning.m_iMaxSimultaneousCells)
    {
        return;
    }

    nmCountryToTry = LWCE_SelectCountryForCellPlacementAttempt();

    if (!LWCE_IsCellActiveInCountry(nmCountryToTry))
    {
        if (LWCE_RollDiceForCellPlacement(nmCountryToTry) || bIgnoreDiceRoll)
        {
            kData.m_nmCountry = nmCountryToTry;
            kData.m_iDaysUntilNextActivity = int(RandRange(m_kTuning.m_kCellTuning.m_iMinDaysBetweenOperations, m_kTuning.m_kCellTuning.m_iMaxDaysBetweenOperations));

            if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
            {
                if (class'XGTacticalGameCore'.default.SW_MARATHON < 1.0f)
                {
                    kData.m_iDaysUntilNextActivity /= class'XGTacticalGameCore'.default.SW_MARATHON;
                }
            }

            m_arrCECellData.AddItem(kData);
        }
    }

    m_iCellPlacementCooldown = int(RandRange(m_kTuning.m_kCellTuning.m_iMinDaysBetweenCells, m_kTuning.m_kCellTuning.m_iMaxDaysBetweenCells));

    if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        if (class'XGTacticalGameCore'.default.SW_MARATHON < 1.0f)
        {
            m_iCellPlacementCooldown /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }
    }
}

function PostCombat(XGMission kMission, bool bSuccess)
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local name nmNeighborCountry;

    kWorld = LWCE_XGWorld(WORLD());

    // TODO: revisit this when we have a new XGMission class structure
    if (kMission.IsA('XGMission_CovertOpsExtraction') || kMission.IsA('XGMission_CaptureAndHold'))
    {
        if (bSuccess)
        {
            ClearCell(ECountry(kMission.m_iCountry));
            Country(kMission.m_iCountry).AddPanic(-20);
        }
        else
        {
            RelocateCell(ECountry(kMission.m_iCountry));
        }
    }

    if (kMission.IsA('XGMission_ExaltRaid'))
    {
        if (bSuccess)
        {
            EndSimulation();
            `ONLINEEVENTMGR.UnlockAchievement(AT_ApotheosisDenied);
        }
        else
        {
            kCountry = kWorld.LWCE_GetCountry(m_nmExaltCountry);

            if (kCountry.LeftXCom())
            {
                kContinent = kWorld.LWCE_GetContinent(kCountry.LWCE_GetContinent());

                foreach kContinent.m_kTemplate.arrCountries(nmNeighborCountry)
                {
                    kCountry = kWorld.LWCE_GetCountry(nmNeighborCountry);

                    if (kCountry.IsCouncilMember())
                    {
                        kCountry.AddPanic(40);
                    }
                }

                LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('ExaltRaidFailContinent').AddName(m_nmExaltCountry).AddInt(2).Build());
            }
            else
            {
                kCountry.LeaveXComProject();
                LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('ExaltRaidFailCountry').AddName(m_nmExaltCountry).Build());
            }
        }
    }
}

function string RecordExaltCellPlacementAttempt(bool bSuccess, bool bIgnoredDiceRoll, ECountry Country)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordExaltCellPlacementAttempt);

    return "";
}

function string RecordExaltPanicOperation()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordExaltPanicOperation);

    return "";
}

function string RecordExaltResearchOperation(int HoursHacked)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordExaltResearchOperation);

    return "";
}

function string RecordExaltSabotageOperation(int AmountStolen)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordExaltSabotageOperation);

    return "";
}

function string RecordExaltSweep()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(RecordExaltSweep);

    return "";
}

function SetCovertOperative(XGStrategySoldier kSoldier, ECountry eCountryToInfiltrate)
{
    `LWCE_LOG_DEPRECATED_CLS(SetCovertOperative);
}

function LWCE_SetCovertOperative(LWCE_XGStrategySoldier kSoldier, name nmCountryToInfiltrate)
{
    if (!LWCE_IsCellActiveInCountry(nmCountryToInfiltrate))
    {
        return;
    }

    if (m_kCECovertOpsOperative.m_kCovertOpsSoldier != none)
    {
        return;
    }

    m_kCECovertOpsOperative.m_iDaysUntilComplete = m_kTuning.m_iCovertOperationDuration;
    m_kCECovertOpsOperative.m_nmInfiltratedCountry = nmCountryToInfiltrate;
    m_kCECovertOpsOperative.m_kCovertOpsSoldier = kSoldier;
    kSoldier.SetStatus(eStatus_CovertOps);
    STORAGE().BackupAndReleaseInventoryForCovertOp(kSoldier);
}

protected function int LWCE_GetActiveCellsOnContinent(LWCE_XGContinent kContinent)
{
    local int iActiveCellsInContinent;
    local name nmCountry;

    foreach kContinent.m_kTemplate.arrCountries(nmCountry)
    {
        if (LWCE_IsCellActiveInCountry(nmCountry))
        {
            iActiveCellsInContinent++;
        }
    }

    return iActiveCellsInContinent;
}

protected function array<EExaltCellExposeReason> LWCE_GetPossibleOperationTypes(name nmOperationCountry)
{
    local array<EExaltCellExposeReason> arrTypes;
    local LWCE_XGCountry kCountry;

    kCountry = `LWCE_XGCOUNTRY(nmOperationCountry);

    if (HQ().GetResource(eResource_Money) >= 0)
    {
        arrTypes.AddItem(eExaltCellExposeReason_SabatogeOperation);
    }

    if (!kCountry.LeftXCom())
    {
        arrTypes.AddItem(eExaltCellExposeReason_IncreasedPanic);
    }

    if (LABS().GetCurrentResearchProgressPercentage() > m_kTuning.m_kCellTuning.m_fResearchHackPercentage)
    {
        arrTypes.AddItem(eExaltCellExposeReason_ResearchHack);
    }

    return arrTypes;
}

protected function int LWCE_GetRuledOutCountryCountForClue(LWCE_TExaltClueDefinition kClue)
{
    local array<LWCE_XGCountry> arrCountries;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local int iCouncilMemberCount;

    if (kClue.m_arrValidCountries.Length > 0)
    {
        kWorld = LWCE_XGWorld(WORLD());
        arrCountries = kWorld.LWCE_GetCountries();

        foreach arrCountries(kCountry)
        {
            if (kCountry.IsCouncilMember())
            {
                iCouncilMemberCount++;
            }
        }

        return iCouncilMemberCount - kClue.m_arrValidCountries.Length;
    }
    else
    {
        return kClue.m_arrInvalidCountries.Length;
    }
}

protected function bool LWCE_IsCountryRuledOutByClue(name nmCountryToCheck, LWCE_TExaltClueDefinition kClue)
{
    if (kClue.m_arrValidCountries.Length > 0)
    {
        return kClue.m_arrValidCountries.Find(nmCountryToCheck) == INDEX_NONE;
    }
    else
    {
        return kClue.m_arrInvalidCountries.Find(nmCountryToCheck) != INDEX_NONE;
    }
}

protected function bool LWCE_IsCountryRuledOutByCurrentClues(name nmCountryToCheck)
{
    local int iIndex, iCollectedClueCount;

    iCollectedClueCount = GetCollectedClueCount();

    for (iIndex = 0; iIndex < iCollectedClueCount; iIndex++)
    {
        if (LWCE_IsCountryRuledOutByClue(nmCountryToCheck, m_arrCEClues[iIndex]))
        {
            return true;
        }
    }

    return false;
}

protected function LWCE_NextDayForExalt()
{
    local LWCE_XComHQPresentationLayer kPres;
    local int iIndex;

    kPres = LWCE_XComHQPresentationLayer(PRES());

    if (m_eSimulationState == eExaltSimulationState_NotStarted || m_eSimulationState == eExaltSimulationState_Finished)
    {
        return;
    }

    if (m_eSimulationState == eExaltSimulationState_FirstCellDelay)
    {
        m_iCellPlacementCooldown--;

        if (m_iCellPlacementCooldown <= 0)
        {
            m_eSimulationState = eExaltSimulationState_Active;
            PlaceNextCell(true);
            PlaceNextCell(true);
            LWCE_PerformRandomOperation(m_arrCECellData[0].m_nmCountry);
        }

        return;
    }

    m_iCellPlacementCooldown--;

    if (m_iCellPlacementCooldown <= 0)
    {
        PlaceNextCell();
    }

    m_iDaysSinceLastOperation++;

    for (iIndex = 0; iIndex < m_arrCECellData.Length; iIndex++)
    {
        if (m_arrCECellData[iIndex].m_iDaysUntilHidden <= 0)
        {
            m_arrCECellData[iIndex].m_iDaysUntilNextActivity = Max(0, m_arrCECellData[iIndex].m_iDaysUntilNextActivity - 1);

            if (m_arrCECellData[iIndex].m_iDaysUntilNextActivity == 0 && m_iDaysSinceLastOperation > m_kTuning.m_kCellTuning.m_iMinDaysBetweenDifferentCellOperations)
            {
                LWCE_PerformRandomOperation(m_arrCECellData[iIndex].m_nmCountry);
                m_arrCECellData[iIndex].m_iDaysUntilNextActivity = int(RandRange(m_kTuning.m_kCellTuning.m_iMinDaysBetweenOperations, m_kTuning.m_kCellTuning.m_iMaxDaysBetweenOperations));
            }
        }
        else
        {
            if (m_arrCECellData[iIndex].m_iDaysUntilHidden == 1)
            {
                LWCE_SetLastVisibiltyStatus(m_arrCECellData[iIndex].m_nmCountry, eExaltCellLastVisibilityStatus_Hidden);
                kPres.LWCE_Notify('CellHides', class'LWCEDataContainer'.static.NewName('NotifyData', m_arrCECellData[iIndex].m_nmCountry));
            }

            m_arrCECellData[iIndex].m_iDaysUntilHidden--;
        }
    }
}

protected function LWCE_NextDayForOperative()
{
    local XGMission kMission;

    if (m_eSimulationState == eExaltSimulationState_NotStarted || m_eSimulationState == eExaltSimulationState_Finished)
    {
        return;
    }

    if (m_kCECovertOpsOperative.m_kCovertOpsSoldier != none && m_kCECovertOpsOperative.m_iDaysUntilComplete > 0)
    {
        if (m_kCECovertOpsOperative.m_iDaysUntilComplete == 1)
        {
            if (m_kDebugForceMission != none)
            {
                kMission = m_kDebugForceMission;
                m_kDebugForceMission = none;
            }
            else
            {
                kMission = CreateNextMission();
            }

            GEOSCAPE().AddMission(kMission);
        }

        m_kCECovertOpsOperative.m_iDaysUntilComplete--;
    }
}

/// <summary>
/// Moves the cell in the given country to a different country. In reality, this is done by removing the
/// cell and randomly creating a new one, with the possibility that it actually ends up in the same country again.
/// </summary>
protected function LWCE_RelocateCell(name nmCellCountry)
{
    local LWCE_XComHQPresentationLayer kPres;
    local int iIndex;

    kPres = LWCE_XComHQPresentationLayer(PRES());

    for (iIndex = 0; iIndex < m_arrCECellData.Length; iIndex++)
    {
        if (m_arrCECellData[iIndex].m_nmCountry == nmCellCountry)
        {
            m_arrCECellData.Remove(iIndex, 1);
            LWCE_SetLastVisibiltyStatus(nmCellCountry, eExaltCellLastVisibilityStatus_Hidden);
            kPres.LWCE_Notify('CellHides', class'LWCEDataContainer'.static.NewName('NotifyData', m_arrCECellData[iIndex].m_nmCountry));
            PlaceNextCell(true);
            return;
        }
    }
}

protected function array<name> LWCE_RemoveInvalidCountriesForClue(array<name> arrCountries, LWCE_TExaltClueDefinition kClue)
{
    local name nmValidCountry;
    local array<name> arrResult;

    foreach arrCountries(nmValidCountry)
    {
        if (!LWCE_IsCountryRuledOutByClue(nmValidCountry, kClue))
        {
            arrResult.AddItem(nmValidCountry);
        }
    }

    return arrResult;
}

protected function bool LWCE_RollDiceForCellPlacement(name nmCountryForPlacement)
{
    local float fChance;

    fChance = m_kTuning.m_kPlacementRollTuning.m_fBaseChance;

    if (LWCE_XGHeadquarters(HQ()).LWCE_GetSatellite(nmCountryForPlacement) >= 0)
    {
        fChance += LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_StealthSatellites') ? m_kTuning.m_kPlacementRollTuning.m_fStealthSatelliteMod : m_kTuning.m_kPlacementRollTuning.m_fSatelliteMod;
    }

    return FRand() < fChance;
}

protected function float LWCE_ScoreCountryForCellPlacementAttempt(name nmCountryToScore)
{
    local LWCE_XGCountry kCountry;
    local LWCE_XGContinent kContinent;
    local LWCE_XGHeadquarters kHQ;
    local float fScore;
    local int iCountriesRemainingInXCom;

    kHQ = LWCE_XGHeadquarters(HQ());
    kCountry = `LWCE_XGCOUNTRY(nmCountryToScore);
    kContinent = `LWCE_XGCONTINENT(kCountry.LWCE_GetContinent());
    iCountriesRemainingInXCom = kContinent.GetNumRemainingCountries();
    fScore = m_kTuning.m_kPlacementScoreTuning.m_arrPanicMod[Clamp(kCountry.GetPanicBlocks() / 20, 0, 4)];

    if (LWCE_GetActiveCellsOnContinent(kContinent) == 0)
    {
        fScore += m_kTuning.m_kPlacementScoreTuning.m_fContinentHasNoCellsMod;
    }

    if (iCountriesRemainingInXCom == 0)
    {
        fScore += m_kTuning.m_kPlacementScoreTuning.m_fContinentHasLeftXComMod;
    }
    else if (kCountry.LeftXCom())
    {
        fScore += m_kTuning.m_kPlacementScoreTuning.m_fCountryHasLeftXComMod;
    }
    else if (iCountriesRemainingInXCom == 1)
    {
        fScore += m_kTuning.m_kPlacementScoreTuning.m_fOnContinentWithOnlyOneCountryLeftInXComMod;
    }
    else if (iCountriesRemainingInXCom == 0)
    {
        fScore += m_kTuning.m_kPlacementScoreTuning.m_fContinentNoCountriesHaveLeftXComMod;
    }

    if (kCountry.HasSatelliteCoverage())
    {
        fScore += m_kTuning.m_kPlacementScoreTuning.m_fSatelliteMod;
    }
    else if (kContinent.GetNumSatellites() == 1)
    {
        fScore += m_kTuning.m_kPlacementScoreTuning.m_fOnlyCountryOnContinentWithoutSatelliteMod;
    }

    if (kCountry.LWCE_GetContinent() == kHQ.LWCE_GetContinent())
    {
        fScore += m_kTuning.m_kPlacementScoreTuning.m_fHomeContinentMod;
    }

    return fScore;
}

protected function LWCE_SelectClues(name nmDesiredCountry)
{
    local array<LWCE_XGCountry> arrCountries;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local array<LWCE_TExaltClueDefinition> arrCandidateClues;
    local LWCE_TExaltClueDefinition kClue;
    local array<name> arrRemainingCountries;
    local float fTotalClueWeight, fClueWeight, fClueChance;
    local int iPreviousValidCountryCount, iSelectedCandidateIndex, iIndex;

    kWorld = LWCE_XGWorld(WORLD());
    arrCountries = kWorld.LWCE_GetCountries();

    m_arrCEClues.Remove(0, m_arrCEClues.Length);

    foreach m_arrCEClueDefinitions(kClue)
    {
        if (!LWCE_IsCountryRuledOutByClue(nmDesiredCountry, kClue))
        {
            arrCandidateClues.AddItem(kClue);
        }
    }

    foreach arrCountries(kCountry)
    {
        if (kCountry.IsCouncilMember())
        {
            arrRemainingCountries.AddItem(kCountry.m_nmCountry);
        }
    }

    while (arrCandidateClues.Length > 0 && arrRemainingCountries.Length > 1)
    {
        iSelectedCandidateIndex = 0;
        fTotalClueWeight = 0.0;

        for (iIndex = 0; iIndex < arrCandidateClues.Length; iIndex++)
        {
            fClueWeight = LWCE_GetRuledOutCountryCountForClue(arrCandidateClues[iIndex]);
            fClueWeight += (fClueWeight * fClueWeight) * 0.20;
            fTotalClueWeight += fClueWeight;
            fClueChance = fClueWeight / fTotalClueWeight;

            if (FRand() < fClueChance)
            {
                iSelectedCandidateIndex = iIndex;
            }
        }

        iPreviousValidCountryCount = arrRemainingCountries.Length;
        arrRemainingCountries = LWCE_RemoveInvalidCountriesForClue(arrRemainingCountries, arrCandidateClues[iSelectedCandidateIndex]);

        if (arrRemainingCountries.Length < iPreviousValidCountryCount)
        {
            m_arrCEClues.AddItem(arrCandidateClues[iSelectedCandidateIndex]);
        }

        arrCandidateClues.Remove(iSelectedCandidateIndex, 1);
    }
}

protected function name LWCE_SelectCountryForCellPlacementAttempt()
{
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local array<LWCE_XGCountry> arrCountries;
    local array<LWCE_TExaltCellPlacementScore> arrCountryScores;
    local LWCE_TExaltCellPlacementScore kScore;
    local float fTotalScore;
    local name nmSelectedCountry;

    kWorld = LWCE_XGWorld(WORLD());
    arrCountries = kWorld.LWCE_GetCountries();

    foreach arrCountries(kCountry)
    {
        if (kCountry.IsCouncilMember() && !LWCE_IsCellActiveInCountry(kCountry.m_nmCountry))
        {
            kScore.m_nmCountry = kCountry.m_nmCountry;
            kScore.m_fScore = LWCE_ScoreCountryForCellPlacementAttempt(kCountry.m_nmCountry);

            arrCountryScores.AddItem(kScore);
        }
    }

    nmSelectedCountry = '';

    foreach arrCountryScores(kScore)
    {
        if (kScore.m_fScore <= 0.0)
        {
            continue;
        }

        fTotalScore += kScore.m_fScore;

        if (FRand() < (kScore.m_fScore / fTotalScore))
        {
            nmSelectedCountry = kScore.m_nmCountry;
        }
    }

    if (nmSelectedCountry == '')
    {
        // Deliberately picks a random country instead of a random *valid* country; this will put cell placement
        // on cooldown without adding a cell anywhere in the world, which is LW 1.0 behavior
        kCountry = LWCE_XGCountry(kWorld.GetRandomCouncilCountry());
        nmSelectedCountry = kCountry.m_nmCountry;
    }

    return nmSelectedCountry;
}

protected function LWCE_SetLastVisibiltyStatus(name nmCountryToSet, EExaltCellLastVisibilityStatus eStatus)
{
    local LWCE_TExaltCellLastVisibilityStatus kCellData;
    local int iIndex;

    for (iIndex = 0; iIndex < m_arrCECellLastVisibilityData.Length; iIndex++)
    {
        if (m_arrCECellLastVisibilityData[iIndex].m_nmCountry == nmCountryToSet)
        {
            m_arrCECellLastVisibilityData[iIndex].m_eVisibilityStatus = eStatus;
            return;
        }
    }

    kCellData.m_nmCountry = nmCountryToSet;
    kCellData.m_eVisibilityStatus = eStatus;

    m_arrCECellLastVisibilityData.AddItem(kCellData);
}