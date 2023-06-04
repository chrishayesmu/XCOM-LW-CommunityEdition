/// <summary>
/// An applied effect is sort of like the instantiated form of an LWCEEffect. Where an LWCEEffect is almost like a
/// template, describing how the effect functions, its initial values, etc, an LWCEAppliedEffect is responsible for
/// tracking the actual state of such an effect on an individual unit.
/// </summary>
class LWCEAppliedEffect extends Object;

var LWCE_XGUnit m_kAppliedByUnit;       // The unit which applied this effect in the first place.
var LWCE_XGUnit m_kAppliedToUnit;       // The unit which is being affected; may be the same as the applier.
var LWCEEffect_Persistent m_kEffect;    // The underlying effect which is being applied.
var LWCE_XGAbility m_kAppliedByAbility; // The ability which applied this effect, if any. If the effect's duplicate response is to
                                        // refresh the effect duration, this is the most recent ability to apply the effect.

var bool m_bIsInfinite;    // If true, this effect will not expire over time.
var int m_iTicksRemaining; // How many ticks are left for this effect, if not infinite. Ticks down at the start of
                           // the turn of the unit who applied the effect.
var int m_iShedChance;       // If this number is > 0, each tick has this % chance to remove the effect.

var LWCE_TCharacterStats m_kStatChanges; // TODO: this struct may not be featured enough for this framework
var array<TTile> m_arrAffectedTiles; // Which tiles are affected by this effect

function Init(LWCEEffect_Persistent kEffect, LWCE_XGAbility kAppliedByAbility, LWCE_XGUnit kAppliedByUnit, LWCE_XGUnit kAppliedToUnit)
{
    m_kEffect = kEffect;
    m_kAppliedByAbility = kAppliedByAbility;
    m_kAppliedByUnit = kAppliedByUnit;
    m_kAppliedToUnit = kAppliedToUnit;

    m_bIsInfinite = kEffect.bInfiniteDuration;
    m_iTicksRemaining = kEffect.iNumTurns;
    m_iShedChance = kEffect.iInitialShedChance;
}

/// <summary>
/// TODO
/// </summary>
/// <returns>True if the effect remains on the unit; false if it should be removed.</returns>
function bool OnEffectTicked() // TODO: need to track what triggered the tick
{
    local bool bRemoveEffect;
    local LWCEEffect kTickEffect;

    bRemoveEffect = false;

    foreach m_kEffect.ApplyOnTick(kTickEffect)
    {
        kTickEffect.ApplyEffect(m_kAppliedByUnit, m_kAppliedToUnit, m_kAppliedByAbility);
    }

    if (!m_bIsInfinite)
    {
        m_iTicksRemaining--;

        if (m_iTicksRemaining <= 0)
        {
            bRemoveEffect = true;
        }
    }

    // Check if this effect needs to be removed
    if (m_iShedChance > 0 && `SYNC_RAND(100) <= m_iShedChance)
    {
        bRemoveEffect = true;
    }

    m_iShedChance += m_kEffect.iPerTickShedChance;

    return !bRemoveEffect;
}

function RefreshEffect()
{
    m_iTicksRemaining = m_kEffect.iNumTurns;
    m_iShedChance = m_kEffect.iInitialShedChance;

    // TODO: some effects will probably need to be reapplied when refreshed, e.g. flashbangs (so they can clear overwatch)
}