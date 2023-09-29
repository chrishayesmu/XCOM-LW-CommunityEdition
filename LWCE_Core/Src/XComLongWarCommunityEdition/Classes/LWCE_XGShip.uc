/// <summary>
/// Single class representing ships of all types, including interceptors, Firestorms, UFOs, and anything
/// added by mods. The only exception is the Skyranger, which is represented using LWCE_XGShip_Dropship,
/// due to its very unique use cases.
///
/// XGShip_Interceptor and XGShip_UFO should be considered deprecated in LWCE.
/// </summary>
class LWCE_XGShip extends XGShip;

struct CheckpointRecord_LWCE_XGShip extends XGShip.CheckpointRecord
{
    var name m_nmContinent;
    var name m_nmShipTemplate;
    var name m_nmTeam;
    var array<name> m_arrCEWeapons;
};

var name m_nmContinent;
var name m_nmShipTemplate;
var name m_nmTeam;
var array<name> m_arrCEWeapons;
var LWCE_TShipStats m_kTCachedStats; // Cached stats from the template

var private LWCEShipTemplate m_kTemplate;

function Init(TShip kTShip)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

function LWCE_Init(name nmShipTemplate, name nmContinent, name nmTeam)
{
    local int I;

    m_nmContinent = nmContinent;
    m_nmShipTemplate = nmShipTemplate;
    m_nmTeam = nmTeam;
    m_v2Coords = GetHomeCoords();
    m_v2Destination = m_v2Coords;
    m_fFlightTime = 43200.0;
    m_kGeoscape = GEOSCAPE();

    m_kTemplate = `LWCE_SHIP(m_nmShipTemplate);
    ReinitCachedStatsFromTemplate();

    m_iHP = GetHullStrength();
    m_arrCEWeapons = m_kTCachedStats.arrWeapons;

    for (I = 0; I < m_arrCEWeapons.Length; I++)
    {
        m_afWeaponCooldown.AddItem(0.0f);
    }

    class'LWCE_XGShip_Extensions'.static.Init(self, nmTeam);

    InitSound();
    InitWatchVariables();
}

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
/// Called when this ship needs to re-initialize itself from its template data. This is usually
/// when the ship is entering the Geoscape, or when the player needs to view the ship's stats.
/// </summary>
function ReinitCachedStatsFromTemplate()
{
    m_kTCachedStats = m_kTemplate.GetStats(m_nmTeam);
}

function InitSound()
{
    // TODO: only UFOs have so many parameters normally, might make interceptors sound weird
    m_sndEngine = CreateAudioComponent(SoundCue(DynamicLoadObject(m_kTemplate.strEngineSound, class'SoundCue')), false, true,,, true);
}

function bool IsDamaged()
{
    return m_iHP != m_kTCachedStats.iHealth;
}