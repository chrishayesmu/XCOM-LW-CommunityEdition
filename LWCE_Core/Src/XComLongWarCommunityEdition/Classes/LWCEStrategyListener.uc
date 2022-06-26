class LWCEStrategyListener extends XGStrategyActor
    abstract;

/// -----------------------------------------------------
/// Soldier class events
/// -----------------------------------------------------

function OnClassDefinitionsBuilt(out array<LWCE_TClassDefinition> arrSoldierClasses) {}

/// -----------------------------------------------------
/// Funding council events
/// -----------------------------------------------------

/// <summary>
/// Called after the list of possible council requests is built (see LWCE_XGFundingCouncil). Can be
/// used to modify the list or any individual request(s) in it, though generally this is advised to
/// be done via config overrides instead.
/// </summary>
function OnCouncilRequestsBuilt(out array<LWCE_TFCRequestConfig> arrPossibleRequests) {}

/// -----------------------------------------------------
/// Foundry events
/// -----------------------------------------------------

/// <summary>
/// Called at the end of LWCE_XGTechTree.HasFoundryPrereqs to determine if a Foundry project is available to the player yet or not.
/// Mods can use this hook to add custom prerequisites that aren't supported in LWCE_TPrereqs structure. If any of the prerequisites
/// in kTech.kPrereqs are not met, this function will not be called and the project will not be available.
/// </summary>
/// <param name="kTech">The Foundry project which is under consideration.</param>
/// <param name="iHasPrereqs">Whether the project's prereqs are satisfied. Should be 0 if prereqs are not met, or 1 if they are.</param>
function Override_HasFoundryPrereqs(LWCE_TFoundryTech kTech, out int iHasPrereqs) {}

/// <summary>
/// Called after any Foundry project has been started and added to the Foundry queue.
/// </summary>
function OnFoundryProjectAddedToQueue(TFoundryProject kProject, LWCE_TFoundryTech kFoundryTech) {}

/// <summary>
/// Called after any Foundry project has been canceled.
/// </summary>
function OnFoundryProjectCanceled(TFoundryProject kProject, LWCE_TFoundryTech kFoundryTech) {}

/// <summary>
/// Called after any Foundry project has been completed. In the normal course of the game this shouldn't
/// be called unless OnFoundryProjectAddedToQueue has been called already for the same project, but if
/// console commands are used, that may not be the case.
/// </summary>
function OnFoundryProjectCompleted(TFoundryProject kProject, LWCE_TFoundryTech kFoundryTech) {}

/// <summary>
/// Called after the tech tree has built its list of Foundry techs. Techs can be removed from the list,
/// or new techs added. These represent the Foundry techs that are available over the course of the entire
/// campaign, not techs which are currently researched or available. At the point when this is called, Foundry
/// project costs have not yet been adjusted for the Dynamic War option; any techs that you add to the list
/// will also have their cost adjusted for Dynamic War if the option is enabled.
///
/// Note that since this list is always built dynamically, if your mod is uninstalled or modified, anything
/// you've previously changed in the list will be restored to its original state. If your mod adds Foundry techs
/// and you want to make sure you're backwards compatible with existing saves, then rather than removing unwanted
/// Foundry techs in updates, you should hide them using LWCE_TFoundryTech.bForceUnavailable flag.
/// </summary>
function OnFoundryTechsBuilt(out array<LWCE_TFoundryTech> Techs) {}

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
function UpdateFoundryPerksForSoldier(XGStrategySoldier kSoldier, LWCE_XGFacility_Engineering kEngineering) {}


/// -----------------------------------------------------
/// Item events
/// -----------------------------------------------------

/// <summary>
/// Called at the end of LWCE_XGItemTree.LWCE_GetItem. Can be used to dynamically adjust a number of item properties, including
/// build cost, build time, whether an item is infinite, etc.
/// </summary>
/// <param name="kItem">The current state of the item, including any modifications made by mods before this one.</param>
/// <param name="iTransactionType">The type of transaction this item is being retrieved for, corresponding to a value in XGStrategyActorNativeBase.ETransactionType.</param>
function Override_GetItem(out LWCE_TItem kItem, int iTransactionType) {}

/// <summary>
/// Called when equipping a soldier with their default pistol, such as when a new soldier is hired, or when the
/// player unequips all equipped items at the Skyranger screen. Can override what weapon the soldier equips.
///
/// Note that this is also called when creating a blueshirt soldier for base defense. You can check kSoldier.m_bBlueShirt for this.
/// </summary>
/// <param name="kSoldier">The soldier to be equipped.</param>
/// <param name="iItemId">The ID of the pistol they will be equipped with.</param>
/// <returns>True if iItemId was modified by this function, false otherwise.</returns>
function bool Override_GetInfinitePistol(XGStrategySoldier kSoldier, out int iItemId) { return false; }

/// <summary>
/// Called when equipping a soldier with their default primary weapon, such as when a new soldier is hired, or when the
/// player unequips all equipped items at the Skyranger screen. Can override what weapon the soldier equips.
///
/// Note that this is also called when creating a blueshirt soldier for base defense. You can check kSoldier.m_bBlueShirt for this.
/// </summary>
/// <param name="kSoldier">The soldier to be equipped.</param>
/// <param name="iItemId">The ID of the primary weapon they will be equipped with.</param>
/// <returns>True if iItemId was modified by this function, false otherwise.</returns>
function bool Override_GetInfinitePrimary(XGStrategySoldier kSoldier, out int iItemId) { return false; }

/// <summary>
/// Called when equipping a soldier with their default secondary weapon, such as when a new soldier is hired, or when the
/// player unequips all equipped items at the Skyranger screen. Can override what weapon the soldier equips. Note that a pistol
/// is not a secondary weapon; secondary weapons are large items such as rocket launchers.
///
/// Note that this is also called when creating a blueshirt soldier for base defense. You can check kSoldier.m_bBlueShirt for this.
/// </summary>
/// <param name="kSoldier">The soldier to be equipped.</param>
/// <param name="iItemId">The ID of the secondary weapon they will be equipped with.</param>
/// <returns>True if iItemId was modified by this function, false otherwise.</returns>
function bool Override_GetInfiniteSecondary(XGStrategySoldier kSoldier, out int iItemId) { return false; }

/// <summary>
/// Called after an item is built. When this is called, the UI notification has been queued (but not viewed), the resulting
/// items have already been added to storage, and any rebate has already been paid.
/// </summary>
/// <param name="kItemProject">The project which has just completed.</param>
/// <param name="iQuantity">The number of items added to storage.</param>
/// <param name="bInstant">Whether the project was completed instantly or not.</param>
function OnItemCompleted(LWCE_TItemProject kItemProject, int iQuantity, optional bool bInstant) {}

/// <summary>
/// Called after the item tree has built its list of items. See documentation for OnFoundryTechsBuilt; it functions
/// in largely the same way as OnItemsBuilt.
/// </summary>
function OnItemsBuilt(out array<LWCE_TItem> arrItems) {}

/// -----------------------------------------------------
/// Research events
/// -----------------------------------------------------

/// <summary>
/// Called at the very end of LWCE_XGTechTree.LWCE_GetTech. Provides an opportunity to dynamically modify techs during a campaign,
/// such as applying research credits or the We Have Ways continent bonus (both of which are already done in the base function). While
/// any fields of the tech can be changed here, mods should generally restrict themselves to either iHours (the remaining scientist-hours
/// before the tech is completed) or kCost (such as how Foundry projects get discounts).
/// </summary>
/// <param name="kTech">The current state of the tech, including any modifications made by mods before this one.</param>
/// <param name="bIncludesProgress">
///     If true, kTech.iHours has already been adjusted to reflect any time spent on this research. Otherwise, kTech.iHours will only
///     reflect the base state of the tech, with any relevant bonuses/penalties applied.
/// </param>
function Override_GetTech(out LWCE_TTech kTech, bool bIncludesProgress) {}

/// <summary>
/// Called at the end of LWCE_XGTechTree.HasPrereqs to determine if a research tech is available to the player yet or not.
/// Mods can use this hook to add custom prerequisites that aren't supported in LWCE_TPrereqs structure. If any of the prerequisites
/// in kTech.kPrereqs are not met, this function will not be called and the tech will not be available.
/// </summary>
/// <param name="kTech">The tech which is under consideration.</param>
/// <param name="iHasPrereqs">Whether the tech's prereqs are satisfied. Should be 0 if prereqs are not met, or 1 if they are.</param>
function Override_HasPrereqs(LWCE_TTech kTech, out int iHasPrereqs) {}

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
function OnResearchTechsBuilt(out array<LWCE_TTech> Techs) {}

/// -----------------------------------------------------
/// Miscellaneous events
/// -----------------------------------------------------

/// <summary>
/// Called whenever a new mission is created, before it has been added to the Geoscape.
/// </summary>
/// <returns>
///     If any mod returns false, the mission will not be added to the Geoscape and will be destroyed.
///     Otherwise the mission is added to the Geoscape. Note that the first mission of the campaign cannot
///     be prevented in this way.
/// </returns>
function bool OnMissionCreated(XGMission kMission) { return true; }

/// <summary>
/// Called whenever a new mission is added to the Geoscape.
/// </summary>
function OnMissionAddedToGeoscape(XGMission kMission) {}

/// <summary>
/// Called to display an alert on the Geoscape. Whenever a mod calls LWCE_XGGeoscape.Mod_Alert, an integer alert ID
/// is returned. The calling mod is responsible for storing this ID and handling the PopulateAlert event. The fields in
/// kAlert must be populated by the mod so that the alert can be shown to the player.
/// </summary>
/// <param name="iAlertId">The ID of the alert. Generally, mods should not handle alerts they didn't create.</param>
/// <param name="kGeoAlert">The alert data passed to LWCE_XGGeoscape.Mod_Alert.</param>
/// <param name="kAlert">A data structure to fill out with the data to display.</param>
function PopulateAlert(int iAlertId, TGeoscapeAlert kGeoAlert, out TMCAlert kAlert) {}