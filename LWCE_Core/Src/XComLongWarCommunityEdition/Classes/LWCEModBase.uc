class LWCEModBase extends Object
    abstract
    dependson(LWCETypes);

/******************************************************
 * SECTION: Variables owned by the mod
 *
 * These variables should be set in the defaultproperties block of overriding classes.
 ******************************************************/

// TODO: source these from somewhere else
var string ModFriendlyName;  // A string that can be shown to the player as the mod's name
var TModVersion VersionInfo; // Version information for the mod

// END SECTION

/// <summary>
/// Called when the mod is loaded by LWCE. This is a chance to do any initialization, or just
/// to log that the mod loaded successfully.
///
/// TODO: this currently fires every time the mod loader inits, including at the main menu and each tactical/strategy transition.
/// Need to figure out if we want that behavior, or maybe we should split those into separate events.
/// </summary>
function OnModLoaded();

defaultproperties
{
    ModFriendlyName=""
    VersionInfo=(Major=0, Minor=0, Revision=0)
}