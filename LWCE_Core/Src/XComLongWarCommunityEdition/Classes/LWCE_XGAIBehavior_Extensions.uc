class LWCE_XGAIBehavior_Extensions extends Object
    abstract;

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
        `LWCE_LOG_CLS("Unit at index " $ Index $ " has distance " $ fDist);

        if (fDist < fClosestDist)
        {
            fClosestDist = fDist;
            kClosest = kUnit;
        }
    }

    `LWCE_LOG_CLS("Closest civilian: " $ kClosest);
    return kClosest;
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