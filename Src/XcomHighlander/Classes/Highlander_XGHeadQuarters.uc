class Highlander_XGHeadQuarters extends XGHeadQuarters;

function InitNewGame()
{
    local XGFacility kFacility;
    local int I;

    LogInternal(string(Class) $ " : (highlander override)");

    m_arrBaseFacilities.Add(24);
    CreateFacilities();

    foreach m_arrFacilities(kFacility)
    {
        kFacility.InitNewGame();
    }

    m_kBase = Spawn(class'XGBase');
    m_kBase.Init();
    m_kActiveFacility = m_arrFacilities[0];
    m_fAnnounceTimer = 10.0;

    for (I = 0; I < 5; I++)
    {
        if (I != m_iContinent)
        {
            AddOutpost(I);
        }
    }

    if (class'Engine'.static.GetCurrentWorldInfo().Game.BaseMutator != none)
    {
        class'Engine'.static.GetCurrentWorldInfo().Game.BaseMutator.Mutate("XGHeadQuarters.InitNewGame", class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
    }

    if (World().m_kFundingCouncil == none || World().m_kFundingCouncil.IsA('XGFundingCouncil_Mod'))
    {
        World().m_kFundingCouncil = Spawn(class'Highlander_XGFundingCouncil');
        World().m_kFundingCouncil.InitNewGame();
    }
}