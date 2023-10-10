class LWCE_XGInterception extends XGInterception;

struct LWCE_TInterceptionKill
{
    var LWCE_XGShip kAttacker;
    var LWCE_XGShip kVictim;
};

struct CheckpointRecord_LWCE_XGInterception extends XGInterception.CheckpointRecord
{
    var array<LWCE_XGShip> m_arrFriendlyShips;
    var array<LWCE_XGShip> m_arrEnemyShips;
    var array<LWCE_TInterceptionKill> m_arrKills;
};

var array<LWCE_XGShip> m_arrFriendlyShips;    // Ships entering the interception on the "friendly" side (typically, XCOM)
var array<LWCE_XGShip> m_arrEnemyShips;       // Opposed ships. The first entry in this list is considered the "primary" target,
                                              // and if they're shot down, the interception is a success regardless of the fate of
                                              // any other ships in the list.
var array<LWCE_TInterceptionKill> m_arrKills; // Tracks which ships have killed which other ships in the engagement.

function bool CheckForGood()
{
    local LWCE_XGShip kShip;

    if (self == none)
    {
        return false;
    }

    if (m_arrEnemyShips.Length == 0)
    {
        return false;
    }

    if (m_arrEnemyShips[0].m_v2Coords.X == 0.0f && m_arrEnemyShips[0].m_v2Coords.Y == 0.0f)
    {
        return false;
    }

    if (m_arrFriendlyShips.Length == 0)
    {
        return false;
    }

    foreach m_arrFriendlyShips(kShip)
    {
        if (kShip == none)
        {
            return false;
        }
    }

    return true;
}

function OnArrival()
{
    local LWCE_XGShip kShip;

    if (!CheckForGood())
    {
        foreach m_arrFriendlyShips(kShip)
        {
            kShip.ReturnToBase();
        }

        GEOSCAPE().RemoveInterception(self);
        return;
    }

    PRES().StartInterceptionEngagement(self);
}

function Launch()
{
    local LWCE_XGShip kShip;

    if (m_arrFriendlyShips.Length == 0)
    {
        return;
    }

    foreach m_arrFriendlyShips(kShip)
    {
        kShip.Hunt(self);
    }
}

function ReturnToBase(optional XGShip_Interceptor kJet)
{
    `LWCE_LOG_DEPRECATED_CLS(ReturnToBase);
}

function LWCE_ReturnToBase(optional LWCE_XGShip kTargetShip)
{
    local LWCE_XGShip kShip;

    if (kTargetShip != none)
    {
        if (HasFriendlyShip(kTargetShip))
        {
            kTargetShip.ReturnToBase();
            m_arrFriendlyShips.RemoveItem(kTargetShip);
        }
        else if (HasEnemyShip(kTargetShip))
        {
            kTargetShip.ReturnToBase();
            m_arrEnemyShips.RemoveItem(kTargetShip);
        }
    }
    else
    {
        foreach m_arrFriendlyShips(kShip)
        {
            kShip.ReturnToBase();
        }

        foreach m_arrEnemyShips(kShip)
        {
            kShip.ReturnToBase();
        }

        m_arrFriendlyShips.Length = 0;
        m_arrEnemyShips.Length = 0;
    }

    if (m_arrFriendlyShips.Length == 0 || m_arrEnemyShips.Length == 0)
    {
        CompleteEngagement();
    }
}

function ToggleInterceptor(XGShip_Interceptor kInterceptor)
{
    `LWCE_LOG_DEPRECATED_BY(ToggleInterceptor, ToggleFriendlyShip);
}

function ToggleFriendlyShip(LWCE_XGShip kShip)
{
    if (HasFriendlyShip(kShip))
    {
        m_arrFriendlyShips.RemoveItem(kShip);
    }
    else
    {
        if (m_arrFriendlyShips.Length >= 1)
        {
            m_arrFriendlyShips.Remove(0, 1);
        }

        m_arrFriendlyShips.AddItem(kShip);
    }
}

function bool HasEnemyShip(LWCE_XGShip kShip)
{
    return m_arrEnemyShips.Find(kShip) != INDEX_NONE;
}

function bool HasFriendlyShip(LWCE_XGShip kShip)
{
    return m_arrFriendlyShips.Find(kShip) != INDEX_NONE;
}

function bool HasInterceptor(XGShip_Interceptor kInterceptor)
{
    `LWCE_LOG_DEPRECATED_BY(HasInterceptor, HasFriendlyShip);

    return false;
}

/// <summary>
/// Records that a kill occurred in the engagement. Due to how aim and dodge modules are handled
/// (in the UI layer, rather than the engagement), the UI is responsible for reporting kills. These
/// are used post-interception to increment the confirmed kills for ships.
/// </summary>
function RecordKill(LWCE_XGShip kAttacker, LWCE_XGShip kVictim)
{
    local LWCE_TInterceptionKill kKill;

    kKill.kAttacker = kAttacker;
    kKill.kVictim = kVictim;

    m_arrKills.AddItem(kKill);
}

function ClearOtherEngagements(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_CLS(ClearOtherEngagements);
}

function LWCE_ClearOtherEngagements(LWCE_XGShip kShip)
{
    local XGInterception kInterception;
    local array<XGInterception> arrInterceptions;

    arrInterceptions = GEOSCAPE().m_arrInterceptions;

    foreach arrInterceptions(kInterception)
    {
        if (kInterception == self)
        {
            continue;
        }

        if (LWCE_XGInterception(kInterception).HasFriendlyShip(kShip) || LWCE_XGInterception(kInterception).HasEnemyShip(kShip))
        {
            kInterception.CompleteEngagement();
        }
    }
}

function CompleteEngagement()
{
    local int I;
    local LWCE_XGFacility_Hangar kHangar;
    local LWCE_XGShip kShip;
    local LWCE_XGStrategyAI kAI;

    kAI = LWCE_XGStrategyAI(AI());
    kHangar = LWCE_XGFacility_Hangar(HANGAR());

    if (m_bSimulatedCombat)
    {
        return;
    }

    if (m_eUFOResult == eUR_Crash)
    {
        LWCE_ClearOtherEngagements(m_arrEnemyShips[0]);
        kAI.LWCE_OnUFOShotDown(m_arrFriendlyShips, m_arrEnemyShips[0]);
    }
    else if (m_eUFOResult == eUR_Destroyed)
    {
        kAI.LWCE_OnUFODestroyed(m_arrEnemyShips[0]);
    }
    else
    {
        kAI.LWCE_OnUFOAttacked(m_arrEnemyShips[0]);
    }

    for (I = 0; I < m_arrFriendlyShips.Length; I++)
    {
        kShip = m_arrFriendlyShips[I];

        if (kShip.GetHP() <= 0)
        {
            kHangar.LWCE_OnShipDestroyed(kShip);
        }
        else
        {
            kShip.ReturnToBase();
        }
    }

    // Add confirmed kills to ships post-engagement. Note that unlike vanilla, we actually
    // keep track of UFO kills also, though they have no mechanical effect.
    for (I = 0; I < m_arrKills.Length; I++)
    {
        if (m_arrKills[I].kAttacker.GetHP() <= 0)
        {
            continue;
        }

        m_arrKills[I].kAttacker.m_iConfirmedKills += 1;

        // Reset the ship's callsign, prompting it to update the rank label
        m_arrKills[I].kAttacker.SetCallsign(m_arrKills[I].kAttacker.GetCallsign());
    }

    GEOSCAPE().RemoveInterception(self);
}

function Vector2D GetLookAt()
{
    if (m_arrFriendlyShips.Length > 0)
    {
        return m_arrFriendlyShips[0].GetCoords();
    }
    else
    {
        return HQ().GetCoords();
    }
}