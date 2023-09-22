class LWCEShipTemplate extends LWCEDataTemplate
    config(LWCEShips);

const SHIP_TEAM_ALIEN = 'Alien';
const SHIP_TEAM_XCOM = 'XCom';

// Baseline stats: these are the stats a ship has at the very start of the game. For XCOM, these stats
// may be modified by Foundry projects; for aliens, they're modified by the research level. Both types
// can of course have their stats further changed conditionally via mods.
var config int iHealth;
var config int iSpeed;
var config int iEngagementSpeed;
var config int iArmor;
var config int iArmorPen;
var config int iRange;

var config array<LWCE_TItemQuantity> arrSalvage; // If an XCOM ground mission targets this ship (i.e. it lands or crashes),
                                                 // these are the possible rewards from completing the mission
var config array<name> arrWeapons;               // Names of the ship's weapon templates. For XCOM craft, these are the defaults
                                                 // when the ship is first built. For aliens, this is the default loadout for ships of
                                                 // this type. In both cases, the loadout can be modified from what the template says.

var array< delegate<ModifyStatDel> > arrModifyHealthFn;
var array< delegate<ModifyStatDel> > arrModifySpeedFn;
var array< delegate<ModifyStatDel> > arrModifyEngagementSpeedFn;
var array< delegate<ModifyStatDel> > arrModifyArmorFn;
var array< delegate<ModifyStatDel> > arrModifyArmorPenFn;
var array< delegate<ModifyStatDel> > arrModifyRangeFn;

/// <summary>
/// A delegate which mods can use to dynamically adjust ship stats.
/// </summary>
/// <param name="iBaseValue">The base value of the stat, as specified in the template.</param>
/// <param name="iValue">The value of the stat after all previous delegates have modified it.</param>
/// <param name="nmShipTeam">Which team this ship is on. Used for e.g. applying Armored Fighters to XCOM
/// craft without applying it to UFOs. This should always be used instead of depending on the ship's type,
/// as you may get surprised by mods that do things like let XCOM take over UFOs and fly them.</param>
delegate int ModifyStatDel(int iBaseValue, int iValue, name nmShipTeam);

function int GetArmor(name nmShipTeam)
{
    return GetStat(iHealth, nmShipTeam, arrModifyArmorFn);
}

function int GetArmorPenetration()
{
    return GetStat(iHealth, nmShipTeam, arrModifyArmorPenFn);
}

function int GetHealth()
{
    return GetStat(iHealth, nmShipTeam, arrModifyHealthFn);
}

private function int GetStat(int iBaseValue, name nmShipTeam, array< delegate<ModifyStatDel> > arrDelegates)
{
    local int iCurrentValue;
    local delegate<ModifyStatDel> Del;
    
    iCurrentValue = iBaseValue;

    foreach arrDelegates(Del)
    {
        iCurrentValue = Del(iBaseValue, iCurrentValue, )
    }

    return iCurrentValue;
}