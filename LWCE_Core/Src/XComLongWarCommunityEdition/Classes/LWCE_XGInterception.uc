class LWCE_XGInterception extends XGInterception;

function CompleteEngagement()
{
    local int I;
    local LWCE_XGShip_Interceptor kInterceptor;

    if (m_bSimulatedCombat)
    {
        return;
    }

    if (m_eUFOResult == eUR_Crash)
    {
        ClearOtherEngagements(m_kUFOTarget);
        AI().OnUFOShotDown(m_arrInterceptors[0], m_kUFOTarget);
    }
    else if (m_eUFOResult == eUR_Destroyed)
    {
        AI().OnUFODestroyed(m_kUFOTarget);
    }
    else
    {
        AI().OnUFOAttacked(m_kUFOTarget);
    }

    if (m_eUFOResult != eUR_Crash && m_eUFOResult != eUR_Destroyed)
    {
        for (I = 0; I < m_arrInterceptors.Length; I++)
        {
            if (m_arrInterceptors[I].GetHP() <= 0)
            {
                HANGAR().OnInterceptorDestroyed(m_arrInterceptors[I]);
            }
            else
            {
                m_arrInterceptors[I].ReturnToBase();
            }
        }
    }
    else
    {
        for (I = 0; I < m_arrInterceptors.Length; I++)
        {
            kInterceptor = LWCE_XGShip_Interceptor(m_arrInterceptors[I]);

            if (kInterceptor.GetHP() <= 0)
            {
                HANGAR().OnInterceptorDestroyed(kInterceptor);
            }
            else
            {
                kInterceptor.ReturnToBase();
                kInterceptor.m_iConfirmedKills += 1;

                // Reset the interceptor's callsign, prompting it to update the rank label
                kInterceptor.SetCallsign(kInterceptor.GetCallsign());
            }
        }
    }

    GEOSCAPE().RemoveInterception(self);
}