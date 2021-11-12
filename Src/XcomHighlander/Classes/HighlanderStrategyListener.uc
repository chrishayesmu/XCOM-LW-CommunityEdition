class HighlanderStrategyListener extends XGStrategyActor
    abstract;

/// -----------------------------------------------------
/// Foundry events
/// -----------------------------------------------------

/// <summary>
/// Called after any Foundry project has been started and added to the Foundry queue.
/// </summary>
function OnFoundryProjectAddedToQueue(TFoundryProject kProject, HL_TFoundryTech kFoundryTech) {}

/// <summary>
/// Called after any Foundry project has been canceled.
/// </summary>
function OnFoundryProjectCanceled(TFoundryProject kProject, HL_TFoundryTech kFoundryTech) {}

/// <summary>
/// Called after any Foundry project has been completed. In the normal course of the game this shouldn't
/// be called unless OnFoundryProjectAddedToQueue has been called already for the same project, but if
/// console commands are used, that may not be the case.
/// </summary>
function OnFoundryProjectCompleted(TFoundryProject kProject, HL_TFoundryTech kFoundryTech) {}

/// <summary>
/// Called after the tech tree has built its list of Foundry techs. Techs can be removed from the list,
/// or new techs added. These represent the Foundry techs that are available over the course of the entire
/// campaign, not techs which are currently researched or available.
///
/// Note that since this list is always built dynamically, if your mod is uninstalled or modified, anything
/// you've previously changed in the list will be restored to its original state. If your mod adds Foundry techs
/// and you want to make sure you're backwards compatible with existing saves, then rather than removing unwanted
/// Foundry techs in updates, you should hide them using the HL_TFoundryTech.bForceUnavailable flag.
/// </summary>
function OnFoundryTechsBuilt(out array<HL_TFoundryTech> Techs) {}

/// <summary>
/// Called as part of XGFacility_Barracks.UpdateFoundryPerksForSoldier. This can occur for a variety of reasons, most
/// common being the completion of a Foundry project, but also due to serialization or other factors.
///
/// This function provides an opportunity to set perks on the soldier based on the player's Foundry projects. Since none of
/// the strategic layer objects are available on the tactical layer, Foundry projects cannot be queried directly during battle.
/// Adding a perk here allows that information to be transferred to the tactical layer.
///
/// This will be called AFTER the base game Foundry projects have been processed. This allows mods to (for example) remove
/// a Foundry-granted perk if your mod is changing how that Foundry project functions.
/// </summary>
function UpdateFoundryPerksForSoldier(XGStrategySoldier kSoldier, Highlander_XGFacility_Engineering kEngineering) {}



/// -----------------------------------------------------
/// Research events
/// -----------------------------------------------------

/// <summary>
/// Called at the very end of Highlander_XGTechTree.HL_GetTech. Provides an opportunity to dynamically modify techs during a campaign,
/// such as applying research credits or the We Have Ways continent bonus (both of which are already done in the base function). While
/// any fields of the tech can be changed here, mods should generally restrict themselves to either iHours (the remaining scientist-hours
/// before the tech is completed) or kCost (such as how Foundry projects get discounts).
/// </summary>
/// <param name="kTech">The current state of the tech, including any modifications made by mods before this one.</param>
/// <param name="bIncludesProgress">
///     If true, kTech.iHours has already been adjusted to reflect any time spent on this research. Otherwise, kTech.iHours will only
///     reflect the base state of the tech, with any relevant bonuses/penalties applied.
/// </param>
function Override_GetTech(out HL_TTech kTech, bool bIncludesProgress) {}

/// <summary>
/// Called at the end of Highlander_XGTechTree.HasPrereqs to determine if a research tech is available to the player yet or not.
/// Mods can use this hook to add custom prerequisites that aren't supported in the HL_TTech structure, such as requiring a certain
/// facility to be built, mission type to be completed, etc. If any of the prerequisites in HL_TTech are not met, this function will
/// not be called and the tech will not be available.
/// </summary>
/// <param name="kTech">The tech which is under consideration.</param>
/// <param name="iHasPrereqs">Whether the tech's prereqs are satisfied. Should be 0 if prereqs are not met, or 1 if they are.</param>
function Override_HasPrereqs(HL_TTech kTech, out int iHasPrereqs) {}

/// <summary>
/// Called after a research is completed. Note that at this point the player has not yet been notified that the research is complete,
/// so they have not seen the research report, or been informed about what this research has unlocked.
/// </summary>
function OnResearchCompleted(int iTech) {}

/// <summary>
/// Called when a research is started, after all costs have been paid (and, if there was another research in progress, after those costs
/// have been refunded).
/// </summary>
function OnResearchStarted(int iTech) {}

/// <summary>
/// Called after the tech tree has built its list of research techs. See documentation for OnFoundryTechsBuilt; it functions
/// in largely the same way as OnResearchTechsBuilt.
/// </summary>
function OnResearchTechsBuilt(out array<HL_TTech> Techs) {}