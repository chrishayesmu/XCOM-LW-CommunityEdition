class LWCE_XGAIBehavior_ThinMan extends XGAIBehavior_ThinMan;

`include(generators_aibehavior.uci)

function UpdateValidPlagueTargets()
{
    local LWCEWeaponTemplate kAcidSpitWeapon;
    local XGUnit kUnit;
    local LWCE_XGUnit kCEUnit;
    local Vector vTraceStart, vTraceEnd, vHitLocation, vHitNormal;
    local Actor kHitActor;
    local bool bHittable;
    local int iCover;
    local float fCollisionHeight, fSpitRange;

    vTraceStart = m_kUnit.Location;
    fCollisionHeight = m_kUnit.GetPawn().GetCollisionHeight();
    vTraceStart.Z += fCollisionHeight;
    m_arrValidPlagueTargets.Length = 0;

    kAcidSpitWeapon = `LWCE_WEAPON('Item_AcidSpit');
    fSpitRange = kAcidSpitWeapon.CalcAoERange(LWCE_XGUnit(m_kUnit));

    foreach m_kUnit.m_arrVisibleEnemies(kUnit)
    {
        kCEUnit = LWCE_XGUnit(kUnit);

        if (kCEUnit.IsPoisoned())
        {
            continue;
        }

        if (kCEUnit.HasPerk(`LW_PERK_ID(SmartMacrophages)))
        {
            if (Rand(2) == 0)
            {
                continue;
            }
        }

        bHittable = false;
        vTraceEnd = kCEUnit.Location;

        // Check if the target is in spit range
        if (VSize(vTraceStart - vTraceEnd) >= fSpitRange)
        {
            continue;
        }

        vTraceEnd.Z += kCEUnit.GetPawn().GetCollisionHeight();
        kHitActor = `TRACEMGR.XTrace(eXTrace_World, vHitLocation, vHitNormal, vTraceEnd, vTraceStart, vect(1.0, 1.0, 1.0));

        if (kHitActor == none || kHitActor == kCEUnit.GetPawn())
        {
            bHittable = true;
        }

        if (!bHittable && m_kUnit.IsInCover())
        {
            for (iCover = 0; iCover < 4; iCover++)
            {
                if (m_kUnit.VisibilityQueryCache.CoverDirectionInfo[iCover].bHasCover != 0)
                {
                    if (m_kUnit.VisibilityQueryCache.CoverDirectionInfo[iCover].LeftPeek.bHasPeekaround != 0)
                    {
                        vTraceStart = m_kUnit.VisibilityQueryCache.CoverDirectionInfo[iCover].LeftPeek.PeekaroundLocation;
                        vTraceStart.Z += fCollisionHeight;
                        kHitActor = `TRACEMGR.XTrace(eXTrace_World, vHitLocation, vHitNormal, vTraceEnd, vTraceStart, vect(1.0, 1.0, 1.0));

                        if (kHitActor == none || kHitActor == kCEUnit.GetPawn())
                        {
                            bHittable = true;
                        }
                    }

                    if (!bHittable && m_kUnit.VisibilityQueryCache.CoverDirectionInfo[iCover].RightPeek.bHasPeekaround != 0)
                    {
                        vTraceStart = m_kUnit.VisibilityQueryCache.CoverDirectionInfo[iCover].RightPeek.PeekaroundLocation;
                        vTraceStart.Z += fCollisionHeight;
                        kHitActor = `TRACEMGR.XTrace(eXTrace_World, vHitLocation, vHitNormal, vTraceEnd, vTraceStart, vect(1.0, 1.0, 1.0));

                        if (kHitActor == none || kHitActor == kCEUnit.GetPawn())
                        {
                            bHittable = true;
                        }
                    }
                }
            }
        }

        if (bHittable)
        {
            m_arrValidPlagueTargets.AddItem(kCEUnit);
        }
    }
}