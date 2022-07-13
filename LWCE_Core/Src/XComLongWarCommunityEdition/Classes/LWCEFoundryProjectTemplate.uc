class LWCEFoundryProjectTemplate extends LWCEDataTemplate
    config(LWCEBaseStrategyGame);

// NOTE: All documentation for templates is assuming the base template is being retrieved from the corresponding template manager,
// and has not been modified. Some functions return clones of templates which have had changes applied; for example, to factor in
// country/continent bonuses that reduce research times, costs, etc. The comments below may not apply to such clones.

// The total number of engineer-hours required to complete this project. For example, if your project requires 15
// engineers and should take 48 hours to complete when at 15 engineers, this would be 15 * 48 = 720 hours.
var config int iPointsToComplete;

// The number of engineers required to make progress at normal speed on this project.
var config int iEngineers;

// A list of research credit IDs that can apply to speed up this project.
var config array<name> arrCreditsApplied;

// Path to an image to show in the Foundry UI for this project. Must include the "img:///" prefix.
// Typical Foundry images are 256x128.
var config string ImagePath;

// The base cost (unmodified by any continent bonuses or other situational modifiers) to start this project.
var config LWCE_TCost kCost;

// The prerequisites that must be met before this project will be visible in the Foundry.
var config LWCE_TPrereqs kPrereqs;

// If true, this project will never be shown in the list of available Foundry projects. This is the recommended
// way to deprecate Foundry projects from a mod, rather than deleting them (which may break existing game saves).
// If the player has already completed the project, it will still be visible in the Foundry.
var config bool bForceUnavailable;

var protected localized string strName;         // The friendly name of the Foundry project.
var protected localized string strSummary;      // Friendly text describing the project to the player.

var string m_strName;
var string m_strSummary;

function bool BenefitsFromCredit(name CreditName)
{
    return arrCreditsApplied.Find(CreditName) != INDEX_NONE;
}

/// <summary>
/// Creates a duplicate of this template, which can be modified without worrying about changing the original template object.
/// Note that the clone will NOT have the same object name, so be careful if using SaveConfig to persist values.
/// </summary>
function LWCEFoundryProjectTemplate Clone()
{
    local LWCEFoundryProjectTemplate kClone;

    kClone = LWCEFoundryProjectTemplate(InstantiateClone());

    kClone.iPointsToComplete = iPointsToComplete;
    kClone.iEngineers = iEngineers;

    kClone.arrCreditsApplied = CopyNameArray(arrCreditsApplied);

    kClone.ImagePath = ImagePath;

    kClone.kCost = kCost;
    kClone.kPrereqs = kPrereqs;

    kClone.bForceUnavailable = bForceUnavailable;

    kClone.PopulateLocalization(self);

    return kClone;
}

function name GetProjectName()
{
    return DataName;
}

function PopulateLocalization(optional LWCEFoundryProjectTemplate kSource)
{
    if (kSource != none)
    {
        m_strName = kSource.m_strName;
        m_strSummary = kSource.m_strSummary;
    }
    else
    {
        m_strName = strName;
        m_strSummary = strSummary;
    }
}

function bool ValidateTemplate(out string strError)
{
    if (strName == "" || strSummary == "")
    {
        strError = "Missing localization data";
        return false;
    }

    return ValidatePrereqs(kPrereqs, strError);
}