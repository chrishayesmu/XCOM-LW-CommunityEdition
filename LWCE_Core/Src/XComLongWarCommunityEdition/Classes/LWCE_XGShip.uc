interface LWCE_XGShip;

function LWCEShipTemplate GetTemplate();
function name GetWeaponAtIndex(int Index);
function array<name> LWCE_GetWeapons();
function int NumWeapons();

/// <summary>
/// Retrieves the ship's stats. Stats are cached because retrieving them is somewhat expensive, and
/// they're needed many times during an interception. Note that these stats won't reflect anything that
/// has occurred to the ship; for example, the cached HP is always at maximum. Use XGShip.m_iHP for current HP,
/// and LWCE_XGShip.LWCE_GetWeapons for the up-to-date weapons loadout (as XCom ships may modify theirs to
/// not match the cached stats).
/// </summary>
function LWCE_TShipStats GetCachedStats();

/// <summary>
/// Used internally; should not be called by anyone outside of LWCE.
/// </summary>
function SetCachedStats(const LWCE_TShipStats kStats);

/// <summary>
/// Called when this ship needs to re-initialize itself from its template data. This is usually
/// when the ship is entering the Geoscape, or when the player needs to view the ship's stats.
/// </summary>
function ReinitCachedStatsFromTemplate(name nmTeam);
