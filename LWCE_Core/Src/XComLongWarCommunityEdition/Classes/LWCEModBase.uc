class LWCEModBase extends Object
    abstract
    dependson(LWCETypes);



/******************************************************
 * SECTION: Variables owned by the mod
 *
 * These variables should be set in the defaultproperties block of overriding classes.
 ******************************************************/

var string ModFriendlyName;  // A string that can be shown to the player as the mod's name
var TModVersion VersionInfo; // Version information for the mod
var LWCE_TRange ModIDRange;    // See https://github.com/chrishayesmu/XCOM-LW-CommunityEdition/wiki/Choosing-an-ID-range-for-your-mod
                               // You must set this for your mod to be loaded!
var Class<LWCEStrategyListener> StrategyListenerClass; // A class to instantiate while in XCOM HQ.
var Class<LWCETacticalListener> TacticalListenerClass; // A class to instantiate at the beginning of tactical battles.

// END SECTION



/// <summary>
/// Called when the mod is loaded by LWCE. This is a chance to do any initialization, or just
/// to log that the mod loaded successfully.
///
/// TBD: this currently fires every time the mod loader inits, including at the main menu and each tactical/strategy transition.
/// Need to figure out if we want that behavior, or maybe we should split those into separate events.
/// </summary>
function OnModLoaded();

defaultproperties
{
    ModFriendlyName=""
    ModIDRange=(MinInclusive=-1, MaxInclusive=-1)
    VersionInfo=(Major=0, Minor=0, Revision=0)
    StrategyListenerClass=none
    TacticalListenerClass=none
}