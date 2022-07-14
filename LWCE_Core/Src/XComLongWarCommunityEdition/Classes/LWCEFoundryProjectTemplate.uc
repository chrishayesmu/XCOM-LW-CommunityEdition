class LWCEFoundryProjectTemplate extends LWCEDataTemplate
    config(LWCEBaseStrategyGame);

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

var const localized string strName;         // The friendly name of the Foundry project.
var const localized string strSummary;      // Friendly text describing the project to the player.

function bool BenefitsFromCredit(name CreditName)
{
    return arrCreditsApplied.Find(CreditName) != INDEX_NONE;
}

/// <summary>
/// Determines the cost to begin this research, based on the current campaign.
/// Should not be called outside of a campaign's strategy layer.
/// </summary>
function LWCE_TCost GetCost(bool bRush)
{
    local LWCE_TCost kAdjustedCost;
    local float fNewWarfareBonus;

    kAdjustedCost = kCost;

    if (`LWCE_HQ.IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
    {
        `LWCE_UTILS.ScaleCostForDynamicWar(kAdjustedCost);
    }

    if (bRush)
    {
        kAdjustedCost.iCash *= 1.5;
        kAdjustedCost.iAlloys *= 1.5;
        kAdjustedCost.iElerium *= 1.5;
        kAdjustedCost.iMeld += 16;
    }

    fNewWarfareBonus = `LWCE_HQ.HasBonus(`LW_HQ_BONUS_ID(NewWarfare)) / 100.0f;

    if (fNewWarfareBonus > 0)
    {
        kAdjustedCost.iCash *= (1.0f - fNewWarfareBonus);
        kAdjustedCost.iAlloys *= (1.0f - fNewWarfareBonus);
        kAdjustedCost.iElerium *= (1.0f - fNewWarfareBonus);
    }

    // TODO: add a way for mods to reduce cost

    return kAdjustedCost;
}

function name GetProjectName()
{
    return DataName;
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