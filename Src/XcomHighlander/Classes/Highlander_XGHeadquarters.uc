class Highlander_XGHeadquarters extends XGHeadQuarters
    dependson(XGGameData);

struct CheckpointRecord_Highlander_XGHeadquarters extends XGHeadQuarters.CheckpointRecord
{
    var array<int> m_arrHLLastCaptives;
    var HighlanderItemContainer m_kHLLastCargoArtifacts;
};

var array<int> m_arrHLLastCaptives;
var HighlanderItemContainer m_kHLLastCargoArtifacts;

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

    if ( (GEOSCAPE().m_arrCraftEncounters.Length > 0 && GEOSCAPE().m_arrCraftEncounters[9] != 0) || (m_kMC != none && m_kMC.m_bDetectedOverseer))
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
        `WORLDINFO.Game.BaseMutator.Mutate("XGHeadQuarters.InitNewGame", `WORLDINFO.GetALocalPlayerController());
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

function bool ArePrereqsFulfilled(HL_TPrereqs kPrereqs)
{
    local int iPrereqId;
    local Highlander_XGFacility_Barracks kBarracks;
    local Highlander_XGFacility_Engineering kEngineering;
    local Highlander_XGFacility_Labs kLabs;
    local XGGeoscape kGeoscape;
    local XGStorage kStorage;

    kBarracks = `HL_BARRACKS;
    kEngineering = `HL_ENGINEERING;
    kGeoscape = GEOSCAPE();
    kLabs = `HL_LABS;
    kStorage = STORAGE();

    foreach kPrereqs.arrFacilityReqs(iPrereqId)
    {
        if (!HasFacility(iPrereqId))
        {
            return false;
        }
    }

    foreach kPrereqs.arrFoundryReqs(iPrereqId)
    {
        if (!kEngineering.IsFoundryTechResearched(iPrereqId))
        {
            return false;
        }
    }

    foreach kPrereqs.arrItemReqs(iPrereqId)
    {
        if (!kStorage.EverHadItem(iPrereqId))
        {
            return false;
        }
    }

    foreach kPrereqs.arrTechReqs(iPrereqId)
    {
        if (!kLabs.IsResearched(iPrereqId))
        {
            return false;
        }
    }

    foreach kPrereqs.arrUfoReqs(iPrereqId)
    {
        if (kGeoscape.m_arrCraftEncounters[iPrereqId] == 0)
        {
            return false;
        }
    }

    if (kPrereqs.iRequiredSoldierRank > 0 && !kBarracks.HasSoldierOfRankOrHigher(kPrereqs.iRequiredSoldierRank))
    {
        return false;
    }

    if (kPrereqs.iTotalSoldierRanks > 0 && kBarracks.CalcTotalSoldierRanks() < kPrereqs.iTotalSoldierRanks)
    {
        return false;
    }

    if (kPrereqs.bRequiresAutopsy && kLabs.GetNumAutopsiesPerformed() == 0)
    {
        return false;
    }

    if (kPrereqs.bRequiresInterrogation && !kLabs.HasInterrogatedCaptive())
    {
        return false;
    }

    return true;
}

function OrderInterceptors(int iContinent, int iQuantity)
{
    local TShipOrder kOrder;
    local int iCost;

    iCost = `HL_ITEM(`LW_ITEM_ID(Interceptor)).kCost.iCash;

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordPurchasingInterceptor(iQuantity));
    }

    // Highlander issue #1: normally when you order interceptors, the strategy HUD (particularly the player's current money)
    // doesn't update until you back out to the main HQ screen. This fix simply updates the HUD immediately.
    AddResource(eResource_Money, -iCost * iQuantity);
    PRES().GetStrategyHUD().UpdateDefaultResources();

    kOrder.iNumInterceptors = iQuantity;
    kOrder.iDestinationContinent = iContinent;
    kOrder.iHours = 72;

    STAT_AddStat(eRecap_InterceptorsHired, iQuantity);
    m_akInterceptorOrders.AddItem(kOrder);
}

function OrderStaff(int iType, int iQuantity)
{
    local TStaffOrder kOrder;
    local int I;

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordHiredAdditionalSoldiers(iQuantity));
    }

    // Highlander issue #14: update resource HUD after ordering soldiers
    AddResource(eResource_Money, -STAFF(iType).iCash * iQuantity);
    PRES().GetStrategyHUD().UpdateDefaultResources();

    if (iType == eStaff_Soldier)
    {
        STAT_AddStat(eRecap_SoldiersHired, iQuantity);
    }

    for (I = 0; I < m_arrHiringOrders.Length; I++)
    {
        if (m_arrHiringOrders[I].iStaffType == iType && m_arrHiringOrders[I].iHours == STAFF(iType).iHours)
        {
            m_arrHiringOrders[I].iNumStaff += iQuantity;
            return;
        }
    }

    kOrder.iStaffType = iType;
    kOrder.iNumStaff = iQuantity;
    kOrder.iHours = STAFF(iType).iHours;
    m_arrHiringOrders.AddItem(kOrder);
}

function ReduceInterceptorOrder(int iOrder)
{
    local int iCost;

    if (iOrder < 0 || iOrder >= m_akInterceptorOrders.Length)
    {
        return;
    }

    iCost = `HL_ITEM(`LW_ITEM_ID(Interceptor)).kCost.iCash;

    // Highlander issue #1: same fix as in OrderInterceptors, above.
    AddResource(eResource_Money, iCost);
    PRES().GetStrategyHUD().UpdateDefaultResources();

    --m_akInterceptorOrders[iOrder].iNumInterceptors;

    if (m_akInterceptorOrders[iOrder].iNumInterceptors <= 0)
    {
        m_akInterceptorOrders.Remove(iOrder, 1);
    }
}

state InBase
{
    event BeginState(name PS)
    {
        super.BeginState(PS);
    }

    event ContinuedState()
    {
        super.ContinuedState();
    }

    event Tick(float fDeltaT)
    {
        super.Tick(fDeltaT);
    }

    stop;
}

state InFacility
{
    ignores BeginState;

    event Tick(float fDeltaT)
    {
        super.Tick(fDeltaT);
    }

    stop;
}