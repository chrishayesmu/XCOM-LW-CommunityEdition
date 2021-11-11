class Highlander_XGHeadQuarters extends XGHeadQuarters
    dependson(XGGameData);

function Init(bool bLoadingFromSave)
{
    local XGFacility kFacility;
    local XGOutpost kOutpost;
    local int iSat;

    foreach m_arrFacilities(kFacility)
    {
        kFacility.Init(bLoadingFromSave);
    }

    if (m_kObjectiveManager == none)
    {
        m_kObjectiveManager = Spawn(class'Highlander_XGObjectiveManager');
        m_kObjectiveManager.Init();
    }

    if (m_kEntity == none)
    {
        SetEntity(Spawn(class'XGBaseEntity'), 0);
    }

    foreach m_arrOutposts(kOutpost)
    {
        if (kOutpost.m_kEntity == none)
        {
            kOutpost.Init(kOutpost.m_iContinent);
        }
    }

    for (iSat = 0; iSat < m_arrSatellites.Length; iSat++)
    {
        if (m_arrSatellites[iSat].kSatEntity == none)
        {
            m_arrSatellites[iSat].kSatEntity = Spawn(class'XGEntity');
            m_arrSatellites[iSat].kSatEntity.AssignGameActor(self, m_arrSatellites.Length);
            m_arrSatellites[iSat].kSatEntity.Init(eEntityGraphic_Sat_Persistent);
            m_arrSatellites[iSat].kSatEntity.SetHidden(true);
            m_arrSatellites[iSat].kSatEntity.SetBase(none);
        }
    }

    if ((GEOSCAPE().m_arrCraftEncounters[9] != 0) || m_kMC.m_bDetectedOverseer)
    {
        m_bHyperwaveActivated = true;
    }

    if (bLoadingFromSave)
    {
        UpdateSatCoverageGraphics();
    }

    if (m_arrFacilityBinks.Length == 0)
    {
        m_arrFacilityBinks.Add(24);
    }

    m_fCentralTimer = 5.0 + float(Rand(10));
}

function InitNewGame()
{
    local XGFacility kFacility;
    local int I;

    m_arrBaseFacilities.Add(24);
    CreateFacilities();

    foreach m_arrFacilities(kFacility)
    {
        kFacility.InitNewGame();
    }

    m_kBase = Spawn(class'Highlander_XGBase');
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

    // TODO: add mod hook here

    if (World().m_kFundingCouncil == none)
    {
        World().m_kFundingCouncil = Spawn(class'Highlander_XGFundingCouncil');
        World().m_kFundingCouncil.InitNewGame();
    }
}

function CreateFacilities()
{
    local XGFacility kFacility;

    // Replace all facilities with our own subclasses. We do this even for facilities we currently
    // don't have any changes to, since if we change our minds about a facility later, it's not easy
    // to insert a new class into existing save games.

    kFacility = Spawn(class'Highlander_XGFacility_MissionControl');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kMC = XGFacility_MissionControl(kFacility);

    kFacility = Spawn(class'Highlander_XGFacility_Labs');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kLabs = XGFacility_Labs(kFacility);

    kFacility = Spawn(class'Highlander_XGFacility_Engineering');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kEngineering = XGFacility_Engineering(kFacility);

    kFacility = Spawn(class'Highlander_XGFacility_Barracks');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kBarracks = XGFacility_Barracks(kFacility);

    kFacility = Spawn(class'Highlander_XGFacility_Hangar');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kHangar = XGFacility_Hangar(kFacility);

    kFacility = Spawn(class'Highlander_XGFacility_SituationRoom');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kSitRoom = XGFacility_SituationRoom(kFacility);
}

function AddFacility(int iFacility)
{
    // Replace all facilities with Highlander subclasses
    m_arrBaseFacilities[iFacility] += 1;

    if (iFacility == eFacility_PsiLabs)
    {
        BARRACKS().m_kPsiLabs = Spawn(class'Highlander_XGFacility_PsiLabs');
    }
    else if (iFacility == eFacility_GeneticsLab)
    {
        BARRACKS().m_kGeneLabs = Spawn(class'Highlander_XGFacility_GeneLabs');
    }
    else if (iFacility == eFacility_CyberneticsLab)
    {
        BARRACKS().m_kCyberneticsLab = Spawn(class'Highlander_XGFacility_CyberneticsLab');
        STORAGE().AddInfiniteItem(/* MEC Minigun */ 28);
        STORAGE().AddInfiniteItem(eItem_MecCivvies);
    }
    else if (iFacility == eFacility_DeusEx)
    {
        m_kGollop = Spawn(class'Highlander_XGFacility_GollopChamber');
        m_arrFacilities.AddItem(m_kGollop);
    }
    else if (iFacility == eFacility_OTS)
    {
        BARRACKS().UpdateOTSPerks();
    }
    else if (iFacility == eFacility_Foundry)
    {
        BARRACKS().UpdateFoundryPerks();
    }
}