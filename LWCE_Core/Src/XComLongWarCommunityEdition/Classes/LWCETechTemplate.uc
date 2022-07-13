class LWCETechTemplate extends LWCEDataTemplate
    config(LWCEBaseStrategyGame);

// NOTE: All documentation for templates is assuming the base template is being retrieved from the corresponding template manager,
// and has not been modified. Some functions return clones of templates which have had changes applied; for example, to factor in
// country/continent bonuses that reduce research times, costs, etc. The comments below may not apply to such clones.

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

var config LWCE_TCost kCost;
var config LWCE_TPrereqs kPrereqs;   // The prerequisites that must be met before this research will be visible in the Labs.

var protected localized string strName;     // The research name, as it will be seen when selecting research, browsing the archives, etc.
var protected localized string strSummary;  // The summary text when selecting a new research in the Labs.
var protected localized string strReport;   // The full text seen when the research is completed, or when viewing the research in the archives.
var protected localized string strCustom;   // Extra text which is shown in yellow during the research results. Can be left blank if not needed.
var protected localized string strCodename; // The codename which is seen during the research report.

var string m_strName;
var string m_strSummary;
var string m_strReport;
var string m_strCustom;
var string m_strCodename;

function bool ArePrerequisitesFulfilled()
{
    // TODO
    return true;
}

function bool BenefitsFromCredit(name CreditName)
{
    return arrCreditsApplied.Find(CreditName) != INDEX_NONE;
}

/// <summary>
/// Creates a duplicate of this template, which can be modified without worrying about changing the original template object.
/// Note that the clone will NOT have the same object name, so be careful if using SaveConfig to persist values.
/// </summary>
function LWCETechTemplate Clone()
{
    local LWCETechTemplate kClone;

    kClone = LWCETechTemplate(InstantiateClone());

    kClone.bIsAutopsy = bIsAutopsy;
    kClone.bIsInterrogation = bIsInterrogation;
    kClone.iSubjectCharacterId = iSubjectCharacterId;

    kClone.iPointsToComplete = iPointsToComplete;

    kClone.arrCreditsApplied = CopyNameArray(arrCreditsApplied);
    kClone.arrCreditsGranted = CopyNameArray(arrCreditsGranted);

    kClone.ImagePath = ImagePath;

    kClone.kCost = kCost;
    kClone.kPrereqs = kPrereqs;

    kClone.PopulateLocalization(self);

    return kClone;
}

function name GetTechName()
{
    return DataName;
}

function PopulateLocalization(optional LWCETechTemplate kSource)
{
    if (kSource != none)
    {
        m_strName = kSource.m_strName;
        m_strSummary = kSource.m_strSummary;
        m_strReport = kSource.m_strReport;
        m_strCustom = kSource.m_strCustom;
        m_strCodename = kSource.m_strCodename;
    }
    else
    {
        m_strName = strName;
        m_strSummary = strSummary;
        m_strReport = strReport;
        m_strCustom = strCustom;
        m_strCodename = strCodename;
    }
}

function bool ValidateTemplate(out string strError)
{
    // NOTE: strCustom is not validated here due to being optional
    if (strName == "" || strSummary == "" || strReport == "" || strCodename == "")
    {
        strError = "Missing localization data";
        return false;
    }

    return ValidatePrereqs(kPrereqs, strError);
}