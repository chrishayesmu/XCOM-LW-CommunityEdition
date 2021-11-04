class Highlander_XGHeadQuarters extends XGHeadQuarters
    dependson(XGGameData);

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