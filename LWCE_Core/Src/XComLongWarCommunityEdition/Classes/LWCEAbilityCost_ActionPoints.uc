class LWCEAbilityCost_ActionPoints extends LWCEAbilityCost;

var int iNumPoints;           // How many action points this ability costs.

var bool bConsumeAllPoints;   // If true, all remaining action points will be used when activating this ability; however, the unit still
                              // needs to have at least iNumPoints remaining.

var bool bMoveCost;           // If true, this is a movement ability and it will consume move action points based on distance traveled.
                              // iNumPoints will be ignored, but bConsumeAllPoints will still apply.

var array<name> AllowedTypes; // Which types of action points can be used to pay for this cost

var array<name> DoNotConsumeAllAbilities; // If the ability owner has any of these abilities, the ability will not consume all points,
                                          // regardless of the value of bConsumeAllPoints.

function name CanAfford(LWCE_XGAbility kAbility, const LWCE_TAvailableTarget kTarget)
{
    local LWCE_XGUnit kUnit;
    local int Index, iUsableActionPoints;

    kUnit = LWCE_XGUnit(kAbility.m_kUnit);

    // TODO: doesn't incorporate move costs
    for (Index = 0; Index < kUnit.m_arrActionPoints.Length; Index++)
    {
        if (AllowedTypes.Find(kUnit.m_arrActionPoints[Index]) != INDEX_NONE)
        {
            iUsableActionPoints++;
        }
    }

    return iUsableActionPoints >= iNumPoints ? 'AA_Success' : 'AA_CannotAfford_ActionPoints';
}

function ApplyCost(LWCE_XGAbility kAbility, const LWCE_TAvailableTarget kTarget)
{
    local int I, J, iFinalCost, iPointsConsumed;
    local LWCE_XGUnit kUnit;

    if (ShouldSkipCost())
    {
        return;
    }

    kUnit = LWCE_XGUnit(kAbility.m_kUnit);

    if (ConsumeAllPoints(kUnit))
    {
        kUnit.m_arrActionPoints.Length = 0;
        return;
    }

    // TODO: calculate final cost for move abilities, etc
    iFinalCost = iNumPoints;

    // Like XCOM 2, we assume that point types specified at the end of AllowedTypes are higher priority to consume.
    // (This is easier to set up for template authors since we use defaultproperties to populate some basic types.)
    for (I = AllowedTypes.Length - 1; I >= 0 && iPointsConsumed < iFinalCost; I--)
    {
        for (J = kUnit.m_arrActionPoints.Length - 1; J >= 0 && iPointsConsumed < iFinalCost; J--)
        {
            if (kUnit.m_arrActionPoints[J] == AllowedTypes[I])
            {
                kUnit.m_arrActionPoints.Remove(J, 1);
                iPointsConsumed++;
            }
        }
    }
}

function bool ConsumeAllPoints(LWCE_XGUnit kUnit)
{
    local int Index;

    for (Index = 0; Index < DoNotConsumeAllAbilities.Length; Index++)
    {
        if (kUnit.HasAbility(DoNotConsumeAllAbilities[Index]))
        {
            return false;
        }
    }

    return true;
}

defaultproperties
{
	AllowedTypes(0)="Standard"
	AllowedTypes(1)="RunAndGun"
}