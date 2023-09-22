class LWCETechTemplate extends LWCEDataTemplate
    config(LWCEResearch);

// Whether this is an autopsy or interrogation, and which character ID is the subject.
// This has the following effects:
//
//     1. Autopsies/interrogations can benefit from special research time reductions, such as We Have Ways.
//     2. Starting an autopsy/interrogation plays the associated cutscene for the subject character ID.
//     3. Autopsies are required to view enemy perks, and to see special enemy names for navigators/leaders.
//     4. Autopsied enemy types grant a damage bonus from the Vital Point Targeting perk.
//
// In Long War 1.0, some enemies (Outsiders, zombies, EXALT) don't have autopsy research, and always count as being
// autopsied. With LWCE, this behavior is retained even if a mod adds an autopsy tech for those enemies.
// If any mod author wants to add those autopsies and wants this changed, please contact the LWCE team.
var config bool bIsAutopsy;
var config bool bIsInterrogation;
var config int iSubjectCharacterId;

// How many scientist-hours this research takes. Each scientist completes one scientist-hour per hour, multiplied by research
// bonuses from laboratories and adjacencies. This value will be multiplied by DefaultGameCore.ini's TECH_TIME_BALANCE.
// For example, if this value is 240 (10 * 24), then 1 scientist can complete the research in 10 days, or 10 scientists in 1
// day, or 20 in 0.5 days, etc. This value is also reduced multiplicatively by research credits (see arrCredits below), situational
// modifiers such as We Have Ways for autopsies/interrogations, and others.
var config int iPointsToComplete;

var config array<name> arrCreditsApplied; // A list of research credit IDs that can apply to speed up this research.
var config array<name> arrCreditsGranted; // The research credit ID granted by this tech, if any. See EResearchCredits for values.

var config string ImagePath;
var config string TechBegunNarrative;
var config string TechCompleteNarrative;

var config LWCE_TCost kCost;
var config LWCE_TPrereqs kPrereqs;   // The prerequisites that must be met before this research will be visible in the Labs.

var delegate<IsPriority> IsPriorityFn;      // If this function returns true, this tech is marked as a priority in the Labs.

var const localized string strName;     // The research name, as it will be seen when selecting research, browsing the archives, etc.
var const localized string strSummary;  // The summary text when selecting a new research in the Labs.
var const localized string strReport;   // The full text seen when the research is completed, or when viewing the research in the archives.
var const localized string strCustom;   // Extra text which is shown in yellow during the research results. Can be left blank if not needed.
var const localized string strCodename; // The codename which is seen during the research report.

delegate bool IsPriority();

function bool BenefitsFromCredit(name CreditName)
{
    return arrCreditsApplied.Find(CreditName) != INDEX_NONE;
}

/// <summary>
/// Determines the cost to begin this research, based on the current campaign.
/// Should not be called outside of a campaign's strategy layer.
/// </summary>
function LWCE_TCost GetCost()
{
    local LWCE_TCost kAdjustedCost;

    kAdjustedCost = kCost;

    if (`LWCE_HQ.IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        `LWCE_UTILS.ScaleCostForDynamicWar(kAdjustedCost);
    }

    // TODO: add a way for mods to reduce cost

    return kAdjustedCost;
}

/// <summary>
/// Calculates how many points of research are needed to complete this tech, based on the current campaign.
/// Should not be called outside of a campaign's strategy layer.
/// </summary>
/// <param name="bIncludeTimeSpent">If true, any time already invested in researching the tech will be deducted
/// from the result. If false, such time is not included.</param>
function int GetPointsToComplete(optional bool bIncludeTimeSpent = true)
{
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGTechTree kTechTree;
    local int iPoints, iProgressIndex;

    kHQ = `LWCE_HQ;
    kLabs = LWCE_XGFacility_Labs(kHQ.m_kLabs);
    kTechTree = LWCE_XGTechTree(kLabs.m_kTree);

    iPoints = kTechTree.LWCE_GetCreditAdjustedTechHours(GetTechName(), iPointsToComplete, /* bFoundry */ false);

    if ( (bIsAutopsy || bIsInterrogation) && kHQ.HasBonus(`LW_HQ_BONUS_ID(WeHaveWays)) > 0)
    {
        iPoints *= (1.0f - (float(kHQ.HasBonus(`LW_HQ_BONUS_ID(WeHaveWays))) / 100.0f));
    }

    if (bIncludeTimeSpent)
    {
        iProgressIndex = kLabs.m_arrCEProgress.Find('TechName', GetTechName());

        if (iProgressIndex != INDEX_NONE)
        {
            iPoints -= kLabs.m_arrCEProgress[iProgressIndex].iHoursCompleted;
        }
    }

    // TODO: incorporate a new form of mod hook

    return iPoints;
}

function name GetTechName()
{
    return DataName;
}

function bool ValidateTemplate(out string strError)
{
    // NOTE: strCustom is not validated here due to being optional
    if (strName == "" || strSummary == "" || strReport == "" || strCodename == "")
    {
        strError = "Missing localization data";
        return false;
    }

    return ValidatePrereqs(kPrereqs, strError) && super.ValidateTemplate(strError);
}