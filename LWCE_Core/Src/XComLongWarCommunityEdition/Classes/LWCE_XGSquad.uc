class LWCE_XGSquad extends XGSquad;

function OnMoraleEvent(EMoraleEvent EEvent, XGUnit kIgnoreUnit)
{
    local int I, iNumReadyForPanic, iNumPanicked;
    local LWCE_XGCharacter_Soldier kSoldier, kDead;
    local LWCE_XGUnit kUnit;

    iNumReadyForPanic = 0;

    for (I = 0; I < GetNumMembers(); I++)
    {
        kUnit = LWCE_XGUnit(GetMemberAt(I));

        if (!kUnit.IsAliveAndWell() || kUnit.IsPanicking() || kUnit.IsPanicked() || kUnit.IsStrangled() || kUnit.HasHandledMoraleEventThisTurn(EEvent) || kUnit == kIgnoreUnit || !kUnit.CanSee(kIgnoreUnit))
        {
            continue;
        }

        iNumReadyForPanic++;
    }

    if (iNumReadyForPanic > 1)
    {
        iNumReadyForPanic /= 2;
    }

    for (I = 0; I < GetNumMembers(); I++)
    {
        kUnit = LWCE_XGUnit(GetMemberAt(I));
        kUnit.OnMoraleEvent(EEvent, true);
    }

    iNumPanicked = 0;

    while (iNumPanicked < iNumReadyForPanic)
    {
        kUnit = LWCE_XGUnit(GetMemberAt(Rand(GetNumMembers())));

        if (!kUnit.IsAliveAndWell() || kUnit.IsPanicking() || kUnit.IsPanicked() || kUnit.IsStrangled() || kUnit.HasHandledMoraleEventThisTurn(EEvent) || kUnit == kIgnoreUnit || !kUnit.CanSee(kIgnoreUnit))
        {
            continue;
        }

        if (EEvent == eMoraleEvent_AllyKilled)
        {
            if (GetPermanentIndex(kUnit) == INDEX_NONE)
            {
                continue;
            }

            kDead = LWCE_XGCharacter_Soldier(kIgnoreUnit.GetCharacter());
            kSoldier = LWCE_XGCharacter_Soldier(kUnit.GetCharacter());

            if (kDead != none && kSoldier != none && kDead.m_kCESoldier.iRank >= kSoldier.m_kCESoldier.iRank + 3)
            {
                EEvent = eMoraleEvent_ImportantAllyKilled;
            }
        }

        kUnit.OnMoraleEvent(EEvent, false);
        iNumPanicked++;
    }
}