class LWCEShipTemplate extends LWCEDataTemplate
    dependson(LWCETypes)
    config(LWCEShips);

const SHIP_TEAM_ALIEN = 'Alien';
const SHIP_TEAM_XCOM = 'XCom';

/// <summary>
/// Struct primarily for configuring when alien ships gain regular upgrades. In LW 1.0,
/// all ships receive upgrades to their aim, damage, and HP every 30 points of alien research.
/// Some ships receive special upgrades on top of this, granting bigger stats or new weapons.
/// </summary>
struct LWCE_TShipScheduledUpgrade
{
    var name nmTeam;                  // Which team the ship needs to be on for this upgrade to apply
    var LWCE_TShipStats kStatChanges; // The effect of the upgrade. For every stat except for weapons,
                                      // this is additive with the base stats of the ship. For weapons,
                                      // if not specified, there will be no effect; otherwise, the default
                                      // weapon loadout is entirely replaced by whatever is configured.
    var int iAlienResearch;           // The minimum alien research level for this upgrade to apply.
};

// Baseline stats: these are the stats a ship has at the very start of the game. For XCOM, these stats
// may be modified by Foundry projects; for aliens, they're modified by the research level. Both types
// can of course have their stats further changed conditionally via mods.
var config int iHealth;
var config int iAim;
var config int iDamage;
var config int iSpeed;           // This ship's speed on the Geoscape. UFOs will intentionally loiter at a fraction of their top speed
                                 // while conducting missions or preparing to land.
var config int iEngagementSpeed; // This ship's speed during an interception. Used to calculate how long the interception will last.
var config int iArmor;           // Armor providing resistance to attacks from other ships.
var config int iArmorPen;        // This ship's ability to overcome enemy armor; also provided by ship weapons.

var config array<LWCE_TItemQuantity> arrSalvage;          // If an XCOM ground mission targets this ship (i.e. it lands or crashes),
                                                          // these are the possible rewards from completing the mission
var config array<name> arrWeapons;                        // Names of the ship's weapon templates. For XCOM craft, these are the defaults
                                                          // when the ship is first built. For aliens, this is the default loadout for ships of
                                                          // this type. In both cases, the loadout can be modified from what the template says.
var config array<LWCE_TShipScheduledUpgrade> arrUpgrades; // Scheduled upgrades to apply to this ship automatically. Will be combined with the
                                                          // global upgrades specified in LWCEShipDataSet.

var array< delegate<ModifyStatsDel> > arrModifyStatsFn;

/// <summary>
/// A delegate which mods can use to dynamically adjust ship stats.
/// </summary>
/// <param name="kStats">The current ship stats, which may have already been modified by other delegates.</param>
/// <param name="nmShipTeam">Which team this ship is on. Used for e.g. applying Armored Fighters to XCOM
/// craft without applying it to UFOs. This should always be used instead of depending on the ship's type,
/// as you may get surprised by mods that do things like let XCOM take over UFOs and fly them.</param>
delegate int ModifyStatsDel(out LWCE_TShipStats kStats, name nmShipTeam);

/// <summary>
/// Retrieves the stats for a ship using this template. This is the only way that stats should be
/// retrieved during gameplay; accessing the underlying fields directly is incorrectly, as it provides
/// no opportunity for runtime modification of stats (e.g. Foundry projects).
///
/// For XCOM ships, these stats should be treated as defaults. In particular, the weapon loadout is
/// changeable by the player on a per-ship basis, so it generally doesn't make sense to display the
/// default weaponry (except when previewing a brand new ship).
///
/// There may be situational modifiers applied outside of this function, such as Long War's aim bonuses
/// and penalties for aggressive and defensive interception stances, respectively. Those are deliberately
/// left to be handled by the systems responsible for them.
/// </summary>
function LWCE_TShipStats GetStats(name nmShipTeam)
{
    local LWCE_TShipStats kStats;
    local delegate<ModifyStatsDel> Del;

    kStats.iAim = iAim;
    kStats.iArmor = iArmor;
    kStats.iArmorPen = iArmorPen;
    kStats.iDamage = iDamage;
    kStats.iEngagementSpeed = iEngagementSpeed;
    kStats.iHealth = iHealth;
    kStats.iSpeed = iSpeed;

    // TODO: apply scheduled upgrades before calling delegates

    foreach arrModifyStatsFn(Del)
    {
        Del(kStats, nmShipTeam);
    }
}