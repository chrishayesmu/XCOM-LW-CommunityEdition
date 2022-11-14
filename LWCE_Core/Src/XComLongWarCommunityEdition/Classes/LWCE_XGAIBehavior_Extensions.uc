class LWCE_XGAIBehavior_Extensions extends Object
    abstract;

static function bool CanHitAoETarget(XGAIBehavior kSelf, out aoe_target kTarget)
{
    local Vector vStartTrace;
    local float fMaxDist, fDist;
    local XGAbility_Targeted kAbility;
    local LWCEWeaponTemplate kWeapon;

    if (kSelf.m_kUnit.m_bWeaponDisabled)
    {
        return false;
    }

    fDist = VSize(kTarget.vLocation - kSelf.m_kUnit.Location);
    kAbility = XGAbility_Targeted(kSelf.m_kUnit.FindAbility(kTarget.iAbility, none));

    switch (kTarget.iAbility)
    {
        case eAbility_FragGrenade:
        case eAbility_AlienGrenade:
            fMaxDist = kSelf.GetGrenadeThrowRange();

            if (fDist >= fMaxDist)
            {
                return false;
            }

            if (kAbility == none)
            {
                kAbility = XGAbility_Targeted(kSelf.m_kUnit.FindAbility(eAbility_FragGrenade, none));
            }

            if (kAbility != none && kAbility.CheckAvailable())
            {
                vStartTrace = (kTarget.vLocation + kSelf.m_kUnit.Location) * 0.50;
                vStartTrace.Z += `METERSTOUNITS(2.0f);

                if (kSelf.UpdateAoETargetLocation(kTarget, vStartTrace) && kSelf.PrecomputeGrenadePath(kAbility, kTarget.vLocation))
                {
                    if (kSelf.TestPotentialGrenadeDestination(XComTacticalGRI(class'Engine'.static.GetCurrentWorldInfo().GRI).m_kPrecomputedPath.GetEndPosition(), kAbility.m_kWeapon.GetOverallDamageRadius()))
                    {
                        return true;
                    }
                }
            }

            break;
        case eAbility_RocketLauncher:
        case eAbility_ShredderRocket:
            kWeapon = `LWCE_WEAPON('Item_RocketLauncher');
            fMaxDist = kWeapon.CalcAoERange(LWCE_XGUnit(kSelf.m_kUnit));

            if (fDist >= fMaxDist)
            {
                return false;
            }

            if (kAbility != none && kAbility.CheckAvailable())
            {
                if (class'XComWorldData'.static.GetWorldData().CanSeeActorToLocation(kSelf.m_kUnit.GetPawn(), kTarget.vLocation))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }

            break;
    }

    return false;
}

static function XGUnit GetClosestCivilian(XGAIBehavior kSelf)
{
    local int Index;
    local float fClosestDist, fDist;
    local XGAIPlayer_Animal kCivPlayer;
    local XGUnit kClosest, kUnit;

    kCivPlayer = XGAIPlayer_Animal(XGBattle_SP(`BATTLE).GetAnimalPlayer());

    // Base game implementation: uses the XGSquad to find the closest civilian. This is a native function and probably much
    // faster than the equivalent logic in UnrealScript, so we use it as our quick "happy case" check.
    kClosest = XGUnit(kCivPlayer.GetClosestSquadMember(kSelf.m_kUnit.GetLocation()));

    if (kClosest == none || !class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kClosest))
    {
        return kClosest;
    }

    // If the native function accidentally found a visibility helper, we need to do our own lookup that ignores vis helper units
    fClosestDist = 1000000000.0f;
    kClosest = none;

    for (Index = 0; Index < class'XGSquadNativeBase'.const.MaxUnitCount; Index++)
    {
        kUnit = kCivPlayer.m_kSquad.m_arrUnits[Index];

        if (kUnit == none || !kUnit.IsAliveAndWell() || class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kUnit))
        {
            continue;
        }

        fDist = VSize(kSelf.m_kUnit.Location - kUnit.Location);

        if (fDist < fClosestDist)
        {
            fClosestDist = fDist;
            kClosest = kUnit;
        }
    }

    return kClosest;
}

static function float GetGrenadeThrowRange(XGAIBehavior kSelf)
{
    local LWCEWeaponTemplate kGrenade;

    // For AI purposes, all grenades are treated as a basic frag. This could probably be extended later.
    kGrenade = `LWCE_WEAPON('Item_FragGrenade');

    return kGrenade.CalcAoERange(LWCE_XGUnit(kSelf.m_kUnit), kSelf.m_kUnit.GetInventory().GetGrenadeEngagementRange());
}

static function int GetWeaponRangeModAtLocation(XGAIBehavior kSelf, Vector vLocation, XGUnit kEnemy)
{
    local LWCE_XGWeapon kWeapon;

    kWeapon = LWCE_XGWeapon(kSelf.m_kUnit.GetInventory().GetPrimaryWeapon());
    return kWeapon.m_kTemplate.CalcRangeModAtLocation(LWCE_XGUnit(kSelf.m_kUnit), LWCE_XGUnit(kEnemy), vLocation);
}

static function InitMimicBeaconToHunt(XGAIBehavior kSelf)
{
    local Vector vLocation;
    local float fBestBeaconDistanceSquared, fBeaconDistanceSquared;
    local int iBestBeaconIndex, iBeaconIndex;

    if (!kSelf.CaresAboutMimicBeacons())
    {
        kSelf.m_iMimicBeaconIndex = -1;
        return;
    }

    vLocation = kSelf.m_kUnit.GetLocation();
    iBestBeaconIndex = -1;
    fBestBeaconDistanceSquared = `LWCE_WEAPON('Item_MimicBeacon').iRadius;
    fBestBeaconDistanceSquared *= fBestBeaconDistanceSquared;

    for (iBeaconIndex = 0; iBeaconIndex < kSelf.m_kPlayer.m_arrMimicBeacons.Length; iBeaconIndex++)
    {
        fBeaconDistanceSquared = VSizeSq(kSelf.m_kPlayer.m_arrMimicBeacons[iBeaconIndex].vLoc - vLocation);

        if (fBeaconDistanceSquared < fBestBeaconDistanceSquared)
        {
            if (kSelf.m_kPlayer.m_arrMimicBeacons[iBeaconIndex].UnitFired.PassesWillTest(kSelf.m_kUnit.GetWill(), -5, false, kSelf.m_kUnit))
            {
                fBestBeaconDistanceSquared = fBeaconDistanceSquared;
                iBestBeaconIndex = iBeaconIndex;
            }
        }
    }

    kSelf.m_iMimicBeaconIndex = iBestBeaconIndex;
    kSelf.DetermineOverwatchDangerZone();
}

static function InitTargets(XGAIBehavior kSelf)
{
    local XGUnit kUnit;

    kSelf.m_arrValidTargets.Remove(0, kSelf.m_arrValidTargets.Length);

    if (kSelf.ShouldAttackCivilians())
    {
        foreach kSelf.m_kUnit.m_arrCiviliansInRange(kUnit)
        {
            if (LWCE_IsValidCivilianTarget(kSelf, kUnit) && kSelf.m_arrValidTargets.Find(kUnit) == INDEX_NONE)
            {
                kSelf.m_arrValidTargets.AddItem(kUnit);
            }
        }

        kUnit = kSelf.GetClosestCivilian();

        if (LWCE_IsValidCivilianTarget(kSelf, kUnit) && kSelf.m_arrValidTargets.Find(kUnit) == INDEX_NONE)
        {
            kSelf.m_arrValidTargets.AddItem(kUnit);
        }

        foreach kSelf.m_kUnit.m_arrVisibleCivilians(kUnit)
        {
            if (LWCE_IsValidCivilianTarget(kSelf, kUnit) && kSelf.m_arrValidTargets.Find(kUnit) == INDEX_NONE)
            {
                kSelf.m_arrValidTargets.AddItem(kUnit);
            }
        }
    }

    foreach kSelf.m_kPlayer.m_arrVisibleCache(kUnit)
    {
        if (kUnit.IsAliveAndWell() && !class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kUnit))
        {
            kSelf.m_arrValidTargets.AddItem(kUnit);
        }
    }

    // Melee-only units appear to not care about concealment
    if (kSelf.m_kUnit.IsMeleeOnly())
    {
        foreach kSelf.m_kPlayer.m_arrAllEnemies(kUnit)
        {
            if (kUnit.IsAliveAndWell() && !class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kUnit) && kSelf.m_arrValidTargets.Find(kUnit) == INDEX_NONE)
            {
                kSelf.m_arrValidTargets.AddItem(kUnit);
            }
        }
    }
}

static function XGUnit SelectCivilianTarget(XGAIBehavior kSelf)
{
    local XGUnit kBest, kEnemy, kCivilian;
    local array<XGUnit> arrVisibleCivilians;

    kBest = kSelf.m_kLastCivilianTarget;

    if (!LWCE_IsValidCivilianTarget(kSelf, kBest))
    {
        kBest = none;
    }

    if (kBest == none)
    {
        if (kSelf.m_kUnit.m_arrCiviliansInRange.Length == 1 && LWCE_IsValidCivilianTarget(kSelf, kSelf.m_kUnit.m_arrCiviliansInRange[0]))
        {
            kBest = kSelf.m_kUnit.m_arrCiviliansInRange[0];
        }
        else if (kSelf.m_kUnit.m_arrCiviliansInRange.Length > 1)
        {
            foreach kSelf.m_kUnit.m_arrCiviliansInRange(kCivilian)
            {
                if (LWCE_IsValidCivilianTarget(kSelf, kCivilian))
                {
                    foreach kSelf.m_kUnit.m_arrEnemiesSeenBy(kEnemy)
                    {
                        arrVisibleCivilians.AddItem(kCivilian);
                        break;
                    }
                }
            }

            if (arrVisibleCivilians.Length > 0)
            {
                kBest = arrVisibleCivilians[`SYNC_RAND_STATIC(arrVisibleCivilians.Length)];
            }
        }
    }

    if (kBest == none || !LWCE_IsValidCivilianTarget(kSelf, kBest))
    {
        kBest = kSelf.GetClosestCivilian();
    }

    kSelf.m_kLastCivilianTarget = kBest;
    `LWCE_LOG_CLS("Selected civilian target: " $ kBest);
    return kBest;
}

protected static function bool LWCE_IsValidCivilianTarget(XGAIBehavior kSelf, XGUnit kUnit)
{
    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kUnit))
    {
        return false;
    }

    return kSelf.IsValidCivilianTarget(kUnit);
}