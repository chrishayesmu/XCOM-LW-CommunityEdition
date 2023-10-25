/// <summary>
/// Single class representing ships of all types, including interceptors, Firestorms, UFOs, and anything
/// added by mods. The only exception is the Skyranger, which is represented using LWCE_XGShip_Dropship,
/// due to its very unique use cases. XGShip_Interceptor and XGShip_UFO should be considered deprecated in LWCE.
///
/// Because this class fulfills several roles that used to be distinct, it will necessarily have some fields
/// which are not relevant at any given time. For example, a UFO doesn't have a home continent, and an interceptor
/// doesn't have an objective. Mods could change this, however; interceptors could patrol searching for UFOs, or
/// UFOs could be assigned to alien bases much like interceptors have a home base. Consolidating everything into
/// one class makes these scenarios much simpler to implement.
/// </summary>
class LWCE_XGShip extends XGShip;

struct CheckpointRecord_LWCE_XGShip extends XGShip.CheckpointRecord
{
    var name m_nmShipTemplate;
    var name m_nmTeam;
    var array<name> m_arrCEWeapons;
    var LWCE_XGInterception m_kEngagement;
    var name m_nmEngagementStance;
    var name m_nmContinent;
    var string m_strCallsign;
    var int m_iConfirmedKills;
    var int m_iHomeBay;
    var int m_iHoursDown;
    var float m_fFlightTime;
    var LWCE_XGAlienObjective m_kObjective;
    var Vector2D m_v2Target;
    var Vector2D m_v2Intermediate;
    var array<name> m_arrFlightPlan;
    var name m_nmApproach;
    var name m_nmCountryTarget;
    var int m_iCounter;
    var int m_iDetectedBy;
    var float m_fTimeInCountry;
    var bool m_bEverDetected;
    var bool m_bWasEngaged;
    var bool m_bLanded;
};

var name m_nmShipTemplate;
var name m_nmTeam;
var array<name> m_arrCEWeapons;

// These variables are used for air combat
var LWCE_XGInterception m_kEngagement;
var name m_nmEngagementStance; // e.g. Aggressive, Balanced, Defensive

// These variables are typically for XCOM's ships
var name m_nmContinent;
var string m_strCallsign;
var int m_iConfirmedKills;
var int m_iHomeBay;
var int m_iHoursDown;
var float m_fFlightTime;

// These variables are typically only used for enemy ships
var LWCE_XGAlienObjective m_kObjective;
var Vector2D m_v2Target;
var Vector2D m_v2Intermediate;
var array<name> m_arrFlightPlan;
var name m_nmApproach;
var name m_nmCountryTarget;
var int m_iCounter;
var int m_iDetectedBy;
var float m_fTimeInCountry;
var bool m_bEverDetected;
var bool m_bWasEngaged;
var bool m_bLanded;

var private XGHangarShip m_kHangarShip;

// Stats are cached because retrieving them is somewhat expensive, and they're needed many times during
// an interception. Note that these stats won't reflect anything that has occurred to the ship; for example,
// the cached HP is always at maximum. Use XGShip.m_iHP for current HP, and LWCE_XGShip.LWCE_GetWeapons for
// the up-to-date weapons loadout (as XCom ships may modify theirs to not match the cached stats).
var LWCE_TShipStats m_kTCachedStats;

var LWCEShipTemplate m_kTemplate;

function Init(TShip kTShip)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

function LWCE_Init(name nmShipTemplate, name nmContinent, name nmTeam)
{
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
    SetWeapons(m_kTCachedStats.arrWeapons);

    InitEntity();
    InitSound();
    InitWatchVariables();
}

function ApplyCheckpointRecord()
{
    m_kTemplate = `LWCE_SHIP(m_nmShipTemplate);
    ReinitCachedStatsFromTemplate();
}

function Update(float fDeltaT)
{
    super.Update(fDeltaT);

    // TODO: merge logic from UFOs and interceptors here
}

/// <summary>
/// For friendly ships, returns blank. For enemy ships, returns the name of the country which
/// they are currently targeting for their mission, if any.
/// </summary>
function name GetCountry()
{
    if (m_nmTeam == class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM)
    {
        return '';
    }

    return m_nmCountryTarget;
}

/// <summary>
/// For friendly ships, returns the continent they are occupying hangar space in. 
/// For enemy ships, returns the name of the continent containing the country which
/// they are currently targeting for their mission, if any.
/// </summary>
function name GetContinent()
{
    if (m_nmContinent != '')
    {
        return m_nmContinent;
    }

    if (m_nmCountryTarget != '')
    {
        return `LWCE_XGCOUNTRY(m_nmCountryTarget).LWCE_GetContinent();
    }

    return '';
}

function Vector2D GetHomeCoords()
{
    local Vector2D homeCoords;

    if (m_nmContinent != '')
    {
        homeCoords = `LWCE_XGCONTINENT(m_nmContinent).GetHQLocation();
    }

    return homeCoords;
}

function name GetWeaponAtIndex(int Index)
{
    return m_arrCEWeapons[Index];
}

function array<name> LWCE_GetWeapons()
{
    return m_arrCEWeapons;
}

function int NumWeapons()
{
    return m_arrCEWeapons.Length;
}

/// <summary>
/// Called when this ship needs to re-initialize itself from its template data. This is usually
/// when the ship is entering the Geoscape, or when the player needs to view the ship's stats.
/// </summary>
function ReinitCachedStatsFromTemplate()
{
    m_kTCachedStats = m_kTemplate.GetStats(m_nmTeam);

    // For XCOM ships that already have their weapons set, we don't set them again from the template,
    // in case the player has changed the loadout manually. For everything else, we do.
    if (m_arrCEWeapons.Length == 0 || m_nmTeam != class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM)
    {
        SetWeapons(m_kTCachedStats.arrWeapons);
    }
}

function LWCE_EquipWeapon(name ItemName, int Index)
{
    if (m_arrCEWeapons.Length <= Index)
    {
        m_arrCEWeapons.Length = Index + 1;
        m_afWeaponCooldown.Length = Index + 1;
    }

    // When an XCOM ship is unequipping an old weapon, return it to storage
    if (m_nmTeam == class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM && m_arrCEWeapons[Index] != '')
    {
        LWCE_XGStorage(STORAGE()).LWCE_AddItem(m_arrCEWeapons[Index]);
    }

    m_arrCEWeapons[Index] = ItemName;

    if (m_kHangarShip != none)
    {
        // TODO: move somewhere centralized and potentially make extensible
        if (LWCE_XGHangarShip_Firestorm(m_kHangarShip) != none)
        {
            LWCE_XGHangarShip_Firestorm(m_kHangarShip).LWCE_UpdateWeapon(m_arrCEWeapons[0]);
        }
        else
        {
            LWCE_XGHangarShip(m_kHangarShip).LWCE_UpdateWeapon(m_arrCEWeapons[0]);
        }
    }
}

/// <summary>
/// Calculates the current percentage HP of this ship, in the range [0, 1]. Note that the max HP
/// of the ship will use the most up-to-date value, which may not be the same as it was when the
/// ship was damaged (e.g. if an alien research upgrade has activated in the meantime).
/// </summary>
function float GetHPPercentage()
{
    return float(GetHP()) / float(GetHullStrength());
}

/// <summary>
/// Retrieves the maximum "hull strength" (i.e. health) of this ship.
/// </summary>
function int GetHullStrength()
{
    return m_kTCachedStats.iHealth;
}

function int GetRange()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetRange);

    return -100;
}

/// <summary>
/// Gets this ship's speed on the Geoscape.
/// </summary>
function int GetSpeed()
{
    return m_kTCachedStats.iSpeed;
}

/// <summary>
/// Initializes the Geoscape entity which visualizes this ship.
/// </summary>
function InitEntity()
{
    if (m_kTemplate.entityGraphic != EEntityGraphic(0))
    {
        SetEntity(Spawn(class'XGShipEntity'), m_kTemplate.entityGraphic);
    }
}

function InitSound()
{
    // TODO: only UFOs have so many parameters normally, might make interceptors/skyranger sound weird
    m_sndEngine = CreateAudioComponent(SoundCue(DynamicLoadObject(m_kTemplate.strEngineSound, class'SoundCue')), false, true,,, true);
}

function bool IsDamaged()
{
    return m_iHP < m_kTCachedStats.iHealth;
}

function bool IsType(name nmShipType)
{
    return nmShipType == m_nmShipTemplate;
}

/// <summary>
/// Retrieves the callsign for this ship, optionally stripping the pilot's rank from it.
/// </summary>
function string GetCallsign(optional bool includeRank = false)
{
    if (!includeRank && InStr(m_strCallsign, " ") >= 0)
    {
        return Split(m_strCallsign, " ", /* bOmitSplitStr */ true);
    }

    return m_strCallsign;
}

function name GetHomeContinent()
{
    return m_nmContinent;
}

/// <summary>
/// Updates this ship's callsign. This should always be used instead of updating the callsign directly, because
/// it automatically handles prepending the pilot's rank to their callsign.
/// </summary>
function SetCallsign(string strNewCallsign)
{
    // Only XCOM ships have callsigns for now, though this would be a cool place for mods to extend
    if (m_nmTeam != class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM)
    {
        return;
    }

    // Only change the callsign if it's different. This covers a small case where the callsign is set after every
    // kill to update the rank, but the rank may not be included in the callsign yet if the player has never named
    // this interceptor. In any other case, the two strings will be different because m_strCallsign will include
    // the rank label, and the incoming callsign should not.
    if (strNewCallsign != m_strCallsign)
    {
        m_strCallsign = `LWCE_HANGAR.GetRankForKills(m_iConfirmedKills) @ strNewCallsign;
    }
}

/// <summary>
/// Sets the ship's flight plan, which typically includes where it's going, what to do there, and what to do
/// when its mission is complete. In normal LW 1.0, this would only be used for UFOs.
/// </summary>
function SetFlightPlan(array<name> arrFlightPlan, Vector2D v2Target, name nmTargetCountry, float fFlightTime)
{
    m_v2Target = v2Target;
    m_arrFlightPlan = arrFlightPlan;
    m_nmCountryTarget = nmTargetCountry;
    m_fTimeInCountry = fFlightTime * 3600.0f;

    CalcNewWayPoint();
}

function SetObjective(LWCE_XGAlienObjective kObjective)
{
    m_kObjective = kObjective;

    if (kObjective.m_kCETObjective.nmType == 'Bomb' || kObjective.m_kCETObjective.nmType == 'Hunt')
    {
        if (m_kEntity.m_eEntityGraphic == eEntityGraphic_UFO_Small)
        {
            SetEntity(Spawn(class'LWCE_XGShipEntity'), eEntityGraphic_UFO_Small_Seeking);
        }
        else
        {
            SetEntity(Spawn(class'LWCE_XGShipEntity'), eEntityGraphic_UFO_Large_Seeking);
        }
    }
}

/// <summary>
/// Changes the equipped weapons on this ship and sets all of their cooldowns to 0. You should always
/// use this, or LWCE_EquipWeapon, instead of modifying m_arrCEWeapons directly.
/// </summary>
function SetWeapons(array<name> arrWeapons)
{
    local int I;

    m_arrCEWeapons = arrWeapons;
    m_afWeaponCooldown.Length = 0;

    for (I = 0; I < m_arrCEWeapons.Length; I++)
    {
        m_afWeaponCooldown.AddItem(0.0f);
    }
}

/// <summary>
/// Destroys the Actor which represents this ship in the hangar view. Does not impact this
/// ship's functionality in any way.
/// </summary>
function DestroyHangarShip()
{
    if (m_kHangarShip != none)
    {
        m_kHangarShip.Destroy();
        m_kHangarShip = none;
    }
}

/// <summary>
/// Gets or creates an Actor which is the visual representation of this ship in the hangar view.
/// </summary>
function XGHangarShip GetWeaponViewShip()
{
    if (m_kHangarShip == none)
    {
        // TODO: a single class should be able to model any ship as needed
        if (m_nmShipTemplate == 'Interceptor')
        {
            m_kHangarShip = Spawn(class'LWCE_XGHangarShip', self);
            m_kHangarShip.Init();
            LWCE_XGHangarShip(m_kHangarShip).LWCE_UpdateWeapon(m_arrCEWeapons[0]);
        }
        else
        {
            m_kHangarShip = Spawn(class'LWCE_XGHangarShip_Firestorm', self);
            m_kHangarShip.Init();
            LWCE_XGHangarShip_Firestorm(m_kHangarShip).LWCE_UpdateWeapon(m_arrCEWeapons[0]);
        }
    }

    return m_kHangarShip;
}

/// <summary>
/// Sets this ship to track the lead enemy ship in the given interception. Non-XCOM ships will simply ignore this function.
/// </summary>
function Hunt(XGInterception kInterception)
{
    if (m_nmTeam != class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM)
    {
        return;
    }

    m_kEngagement = LWCE_XGInterception(kInterception);
    m_v2Destination = m_kEngagement.m_arrEnemyShips[0].GetCoords();
}

/// <summary>
/// Sends this ship back to its base. Non-XCOM ships will simply ignore this function.
/// </summary>
function ReturnToBase()
{
    if (m_nmTeam != class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM)
    {
        return;
    }

    m_kEngagement = none;
    m_v2Destination = GetHomeCoords();
}

/// <summary>
/// Updates the Actor which represents this ship in XCOM's hangar, either creating it (if needed) or
/// destroying it if this ship is no longer assigned a hangar slot.
/// </summary>
function UpdateHangarShip()
{
    if (m_iHomeBay >= 0)
    {
        if (m_kHangarShip == none)
        {
            GetWeaponViewShip();
        }
    }
    else
    {
        DestroyHangarShip();
    }
}

/// <summary>
/// Calculates the next destination for this ship according to its current flight plan,
/// updating m_v2Coords, m_v2Destination, and m_v2Intermediate in the process.
/// </summary>
protected function CalcNewWayPoint()
{
    local TRect kCountryRect;

    kCountryRect = `LWCE_XGCOUNTRY(m_nmCountryTarget).GetBounds();

    switch (CurrentPlan())
    {
        case 'Arrive':
            CalculateArrival(m_v2Target, kCountryRect);
            break;
        case 'FlyOver':
            CalculateFlyover(m_v2Target, kCountryRect);
            break;
        case 'SpendTime':
            CalculateSpendTime(kCountryRect);
            break;
        case 'Land':
            CalculateLanding(m_v2Target, kCountryRect);
            break;
        case 'Depart':
            CalculateDeparture(kCountryRect);
            break;
        case 'LiftOff':
            CalculateLiftoff();
            break;
    }
}

protected function CalculateArrival(Vector2D v2Target, TRect kBound)
{
    local Vector2D v2Relative;

    v2Relative.X = (v2Target.X - kBound.fLeft) / RectWidth(kBound);
    v2Relative.Y = (v2Target.Y - kBound.fTop) / RectHeight(kBound);

    do
    {
        ChooseApproach(v2Relative);

        if (v2Relative.X < 0.50)
        {
            m_v2Coords.X = kBound.fRight + RandRange(0.0, MilesToXMapCoords(200));
        }
        else
        {
            m_v2Coords.X = kBound.fLeft + RandRange(-MilesToXMapCoords(200), 0.0);
        }

        if (v2Relative.Y < 0.50)
        {
            m_v2Coords.Y = kBound.fBottom + RandRange(0.0, MilesToYMapCoords(200));
        }
        else
        {
            m_v2Coords.Y = kBound.fTop + RandRange(-MilesToYMapCoords(200), 0.0);
        }
    } 
    until (DistanceInMiles(v2Target, m_v2Coords) < 250);

    if (m_nmApproach == 'SeekingLatitude')
    {
        m_v2Destination.X = m_v2Coords.X;
        m_v2Destination.Y = v2Target.Y;
        m_v2Intermediate.Y = v2Target.Y;
        m_v2Intermediate.X = m_v2Destination.X + ((v2Target.X - m_v2Destination.X) * RandRange(0.850, 0.950));
    }
    else
    {
        m_v2Destination.Y = m_v2Coords.Y;
        m_v2Destination.X = v2Target.X;
        m_v2Intermediate.X = v2Target.X;
        m_v2Intermediate.Y = m_v2Destination.Y + ((v2Target.Y - m_v2Destination.Y) * RandRange(0.850, 0.950));
    }
}

protected function CalculateDeparture(TRect kBound)
{
    if (Roll(50))
    {
        m_v2Target.X = kBound.fLeft + RandRange(-MilesToXMapCoords(500), 0.0);
    }
    else
    {
        m_v2Target.X = kBound.fRight + RandRange(0.0, MilesToXMapCoords(500));
    }

    if (Roll(50))
    {
        m_v2Target.Y = kBound.fTop + RandRange(-MilesToYMapCoords(500), 0.0);
    }
    else
    {
        m_v2Target.Y = kBound.fBottom + RandRange(0.0, MilesToYMapCoords(500));
    }

    if (Roll(50))
    {
        m_v2Destination.X = m_v2Target.X;
        m_v2Destination.Y = m_v2Coords.Y;
        m_v2Intermediate.X = m_v2Target.X;
        m_v2Intermediate.Y = m_v2Destination.Y + ((m_v2Target.Y - m_v2Destination.Y) * 0.950);
    }
    else
    {
        m_v2Destination.Y = m_v2Target.Y;
        m_v2Destination.X = m_v2Coords.X;
        m_v2Intermediate.Y = m_v2Target.Y;
        m_v2Intermediate.X = m_v2Destination.X + ((m_v2Target.X - m_v2Destination.X) * 0.950);
    }
}

protected function CalculateFlyover(Vector2D v2Target, TRect kBound)
{
    m_v2Destination = m_v2Coords + (m_v2Target - m_v2Coords) * 2.0f;
}

protected function CalculateLanding(Vector2D v2Target, TRect kBound)
{
    m_v2Destination = m_v2Target;
}

protected function CalculateLiftoff()
{
    m_v2Destination = m_v2Coords + V2DNormal(m_v2Target - m_v2Coords) * 0.2f;
}

protected function CalculateSpendTime(TRect kBound)
{
    m_v2Destination.X = kBound.fLeft + (FRand() * RectWidth(kBound));
    m_v2Destination.Y = kBound.fTop  + (FRand() * RectHeight(kBound));
}

protected function ChooseApproach(Vector2D v2Relative)
{
    // Continent check carried over from base game; not sure if we need to bother turning it into
    // a proper generalized rule, no one will ever notice
    if (m_nmContinent == 'SouthAmerica' || m_nmContinent == 'Africa')
    {
        m_nmApproach = 'SeekingLongitude';
    }
    else if (Roll(50))
    {
        m_nmApproach = 'SeekingLatitude';
    }
    else
    {
        m_nmApproach = 'SeekingLongitude';
    }

    if (Abs(0.50 - v2Relative.X) >= 0.40)
    {
        m_nmApproach = 'SeekingLatitude';
    }
    else if (Abs(0.50 - v2Relative.Y) >= 0.40)
    {
        m_nmApproach = 'SeekingLatitude';
    }
}

protected function name CurrentPlan()
{
    return m_arrFlightPlan.Length > 0 ? m_arrFlightPlan[0] : '';
}