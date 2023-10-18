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
    var TCovertOpsOperative m_kCECovertOpsOperative;
    var array<name> m_arrCEAccusedCountries;
};

var array<LWCE_TExaltClueDefinition> m_arrCEClues;
var array<LWCE_TExaltCellData> m_arrCECellData;
var array<LWCE_TExaltCellLastVisibilityStatus> m_arrCECellLastVisibilityData;
var TCovertOpsOperative m_kCECovertOpsOperative;
var array<name> m_arrCEAccusedCountries;

function ExposeCell(ECountry eCountryToExpose)
{
    `LWCE_LOG_DEPRECATED_CLS(ExposeCell);
}

function LWCE_ExposeCell(name nmCountryToExpose)
{
    local int iIndex, iDaysToExpose;

    for (iIndex = 0; iIndex < m_arrCellData.Length; iIndex++)
    {
        if (m_arrCellData[iIndex].m_eCountry == eCountryToExpose)
        {
            if (m_arrCellData[iIndex].m_iDaysUntilHidden <= 0)
            {
                SetLastVisibiltyStatus(eCountryToExpose, 1);
            }

            iDaysToExpose = int(RandRange(float(m_kTuning.m_kCellTuning.m_iMinDaysToHide), float(m_kTuning.m_kCellTuning.m_iMaxDaysToHide)));
            m_arrCellData[iIndex].m_iDaysUntilHidden = iDaysToExpose;
            return;
        }
    }
}

function int GetCollectedClueCount()
{
    return LWCE_XGStorage(STORAGE()).LWCE_GetNumItemsAvailable('Item_EXALTIntelligence');
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
        kEvent.iHours = m_kCovertOpsOperative.m_iDaysUntilComplete * 24;

        arrEvents.AddItem(kEvent);
    }
}

function PerformIncreasePanicOperation(ECountry eOperationCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(PerformIncreasePanicOperation);
}

function LWCE_PerformIncreasePanicOperation(name nmOperationCountry)
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGCountry kCountry;
    local LWCE_XGWorld kWorld;
    local ECountry eSelectedCountry;
    local int iValidCountries, iPropagandaPanicAmount;
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
    foreach kContinent.m_arrCECountries(nmCountryIter)
    {
        kCountry = kWorld.LWCE_GetCountry(nmCountryIter);

        if (!kCountry.LeftXCom() && nmCountryIter != eOperationCountry)
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

function PerformResearchHackOperation(ECountry eOperationCountry)
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
    LWCE_XGFacility_SituationRoom(SITROOM()).LWCE_PushExaltOperationHeadline(nmOperationCountry, eExaltCellExposeReason_ResearchHack);

    m_iDaysSinceLastOperation = 0;
}

function PerformSabotageOperation(ECountry eOperationCountry)
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
        LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('ExaltMissionActivity').AddInt(eOperationCountry).AddInt(1).AddInt(iAmountStolen).Build());
        SITROOM().PushExaltOperationHeadline(eOperationCountry, 2);
        m_iDaysSinceLastOperation = 0;
    }
}

function PlaceNextCell(optional bool bIgnoreDiceRoll = false)
{
    local TExaltCellData kData;
    local ECountry eCountryToTry;

    if (!IsExaltActive())
    {
        return;
    }

    if (m_arrCellData.Length >= m_kTuning.m_kCellTuning.m_iMaxSimultaneousCells)
    {
        return;
    }

    eCountryToTry = SelectCountryForCellPlacementAttempt();

    if (!IsCellActiveInCountry(eCountryToTry))
    {
        if (LWCE_RollDiceForCellPlacement(eCountryToTry) || bIgnoreDiceRoll)
        {
            kData.m_eCountry = eCountryToTry;
            kData.m_iDaysUntilNextActivity = int(RandRange(float(m_kTuning.m_kCellTuning.m_iMinDaysBetweenOperations), float(m_kTuning.m_kCellTuning.m_iMaxDaysBetweenOperations)));

            if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
            {
                if (class'XGTacticalGameCore'.default.SW_MARATHON < 1.0f)
                {
                    kData.m_iDaysUntilNextActivity /= class'XGTacticalGameCore'.default.SW_MARATHON;
                }
            }

            m_arrCellData.AddItem(kData);
        }
    }

    m_iCellPlacementCooldown = int(RandRange(float(m_kTuning.m_kCellTuning.m_iMinDaysBetweenCells), float(m_kTuning.m_kCellTuning.m_iMaxDaysBetweenCells)));

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
    local XGContinent kContinent;
    local XGCountry kCountry;
    local int iNeighborCountry;

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
            kCountry = Country(m_eExaltCountry);

            if (kCountry.LeftXCom())
            {
                kContinent = Continent(kCountry.GetContinent());

                foreach kContinent.m_arrCountries(iNeighborCountry)
                {
                    if (Country(iNeighborCountry).IsCouncilMember())
                    {
                        Country(iNeighborCountry).AddPanic(40);
                    }
                }

                LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('ExaltRaidFailContinent').AddInt(m_eExaltCountry).AddInt(2).Build());
            }
            else
            {
                kCountry.LeaveXComProject();
                LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(`LWCE_ALERT('ExaltRaidFailCountry').AddInt(m_eExaltCountry).Build());
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

function bool LWCE_RollDiceForCellPlacement(name nmCountryForPlacement)
{
    local float fChance;

    fChance = m_kTuning.m_kPlacementRollTuning.m_fBaseChance;

    if (LWCE_XGHeadquarters(HQ()).LWCE_GetSatellite(nmCountryForPlacement) >= 0)
    {
        fChance += LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_StealthSatellites') ? m_kTuning.m_kPlacementRollTuning.m_fStealthSatelliteMod : m_kTuning.m_kPlacementRollTuning.m_fSatelliteMod;
    }

    return FRand() < fChance;
}