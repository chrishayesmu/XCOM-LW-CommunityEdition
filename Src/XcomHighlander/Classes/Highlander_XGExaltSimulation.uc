class Highlander_XGExaltSimulation extends XGExaltSimulation;

function PerformResearchHackOperation(ECountry eOperationCountry)
{
    local int iEstimatedProjectHours, iRemainingProjectHours, iPercentageHoursHacked, iBaseHoursHacked, iHoursHacked, iLabReduction;
    local int iProgressIndex;
    local TResearchProject kProject;
    local Highlander_XGFacility_Labs kLabs;

    kLabs = `HL_LABS;

    if (!kLabs.HasProject())
    {
        return;
    }

    kProject = kLabs.m_kProject;
    iEstimatedProjectHours = kProject.iEstimate * 24;
    iRemainingProjectHours = kLabs.GetHoursLeftOnProject();
    iPercentageHoursHacked = int(float(iEstimatedProjectHours) * m_kTuning.m_kCellTuning.m_fResearchHackPercentage);
    iBaseHoursHacked = m_kTuning.m_kCellTuning.m_iMinResearchHackDays * 24;
    iHoursHacked = Max(iPercentageHoursHacked, iBaseHoursHacked);
    iHoursHacked = Min(iHoursHacked, iEstimatedProjectHours - iRemainingProjectHours);
    iLabReduction = int(float(iHoursHacked * HQ().GetNumFacilities(eFacility_ScienceLab)) * 0.20);
    iHoursHacked -= iLabReduction;
    iHoursHacked = Max(0, iHoursHacked);

    kLabs.m_kProject.iActualHoursLeft += (iHoursHacked * kLabs.GetResearchPerHour());

    iProgressIndex = kLabs.m_arrHLProgress.Find('iTechId', kProject.iTech);

    if (iProgressIndex != INDEX_NONE)
    {
        kLabs.m_arrHLProgress[iProgressIndex].iHoursCompleted -= (iHoursHacked * kLabs.GetResearchPerHour());
    }

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordExaltResearchOperation(iHoursHacked * kLabs.GetResearchPerHour()));
    }

    ExposeCell(eOperationCountry);
    PRES().UINarrative(`XComNarrativeMoment("ExaltIntro"));
    GEOSCAPE().Alert(GEOSCAPE().MakeAlert(eGA_ExaltResearchHack, eOperationCountry, 3, iHoursHacked, iLabReduction));
    SITROOM().PushExaltOperationHeadline(eOperationCountry, eExaltCellExposeReason_ResearchHack);

    m_iDaysSinceLastOperation = 0;
}