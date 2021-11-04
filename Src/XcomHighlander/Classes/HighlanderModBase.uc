class HighlanderModBase extends Object
    abstract
    dependson(HighlanderTypes);



// SECTION: Variables owned by the mod
//
// These variables should be set in the defaultproperties block of overriding classes.

var string ModFriendlyName;
var TModVersion VersionInfo;
var HL_TRange ModIDRange;     // See README for info on setting this

// END SECTION



/**
 * Called when the mod is first loaded by the Highlander. This is a chance to do any initialization, or just
 * to log that the mod loaded successfully.
 *
 * TBD: this currently fires every time the mod loader inits, including at the main menu and each tactical/strategy transition.
 * Need to figure out if we want that behavior, or maybe we should split those into separate events.
 */
function OnModLoaded();

/**
 * Called after any Foundry project has been started and added to the Foundry queue.
 */
function OnFoundryProjectAddedToQueue(TFoundryProject kProject, HL_TFoundryTech kFoundryTech) {}

/**
 * Called after any Foundry project has been canceled.
 */
function OnFoundryProjectCanceled(TFoundryProject kProject, HL_TFoundryTech kFoundryTech) {}

/**
 * Called after any Foundry project has been completed. In the normal course of the game this shouldn't
 * be called unless OnFoundryProjectAddedToQueue has been called already for the same project, but if
 * console commands are used, that may not be the case.
 */
function OnFoundryProjectCompleted(TFoundryProject kProject, HL_TFoundryTech kFoundryTech) {}

/**
 * Called after the tech tree has built its list of Foundry techs. Techs can be removed from the list,
 * or new techs added. These represent the Foundry techs that are available over the course of the entire
 * campaign, not techs which are currently researched or available.
 *
 * Note that since this list is always built dynamically, if your mod is uninstalled or modified, anything
 * you've previously changed in the list will be restored to its original state. If your mod adds Foundry techs
 * and you want to make sure you're backwards compatible with existing saves, then rather than removing unwanted
 * Foundry techs in updates, you should hide them using the HL_TFoundryTech.bForceUnavailable flag.
 */
function OnFoundryTechsBuilt(out array<HL_TFoundryTech> Techs) {}

/**
 * Called as part of XGFacility_Barracks.UpdateFoundryPerksForSoldier. This can occur for a variety of reasons, most
 * common being the completion of a Foundry project, but also due to serialization or other factors.
 *
 * This function provides an opportunity to set perks on the soldier based on the player's Foundry projects. Since none of
 * the strategic layer objects are available on the tactical layer, Foundry projects cannot be queried directly during battle.
 * Adding a perk here allows that information to be transferred to the tactical layer.
 *
 * This will be called AFTER the base game Foundry projects have been processed. This allows mods to (for example) remove
 * a Foundry-granted perk if your mod is changing how that Foundry project functions.
 */
function UpdateFoundryPerksForSoldier(XGStrategySoldier kSoldier, Highlander_XGFacility_Engineering kEngineering) {}

defaultproperties
{
    ModFriendlyName=""
    VersionInfo=(Major=0, Minor=0, Revision=0)
}