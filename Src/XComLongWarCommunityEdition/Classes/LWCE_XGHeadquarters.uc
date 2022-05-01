class LWCE_XGHeadquarters extends XGHeadQuarters
    dependson(XGGameData);

struct CheckpointRecord_LWCE_XGHeadquarters extends XGHeadQuarters.CheckpointRecord
{
    var array<int> m_arrCELastCaptives;
    var LWCEItemContainer m_kCELastCargoArtifacts;
};

var array<int> m_arrCELastCaptives;
var LWCEItemContainer m_kCELastCargoArtifacts;

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
        m_kObjectiveManager = Spawn(class'LWCE_XGObjectiveManager');
        m_kObjectiveManager.Init();
    }

    if (m_kEntity == none)
    {
        SetEntity(Spawn(class'LWCE_XGBaseEntity'), eEntityGraphic_HQ);
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
            m_arrSatellites[iSat].kSatEntity = Spawn(class'LWCE_XGEntity');
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

    m_kBase = Spawn(class'LWCE_XGBase');
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
        World().m_kFundingCouncil = Spawn(class'LWCE_XGFundingCouncil');
        World().m_kFundingCouncil.InitNewGame();
    }
}

function AddOutpost(int iContinent)
{
    local XGOutpost kOutpost;

    kOutpost = Spawn(class'LWCE_XGOutpost');
    kOutpost.Init(iContinent);
    m_arrOutposts.AddItem(kOutpost);
}

function AddSatelliteNode(int iCountry, int iType, optional bool bInstant)
{
    local TSatellite kSatellite;
    local XGCountry kCountry;
    local TSatNode kNode;

    kNode = World().GetSatelliteNode(iCountry);
    kSatellite.iType = iType;
    kSatellite.v2Loc = kNode.v2Coords;
    kSatellite.iCountry = iCountry;

    if (!bInstant)
    {
        kSatellite.iTravelTime = GEOSCAPE().GetSatTravelTime(iCountry) * 24;
    }

    kCountry = Country(iCountry);
    kCountry.SetSatelliteCoverage(true);

    if (!bInstant)
    {
        Continent(kCountry.GetContinent()).m_kMonthly.iSatellitesLaunched += 1;
    }

    kSatellite.kSatEntity = Spawn(class'LWCE_XGEntity');
    kSatellite.kSatEntity.AssignGameActor(self, m_arrSatellites.Length);
    kSatellite.kSatEntity.Init(eEntityGraphic_Sat_Persistent);
    kSatellite.kSatEntity.SetHidden(true);
    kSatellite.kSatEntity.SetBase(none);
    m_arrSatellites.AddItem(kSatellite);
    STORAGE().RemoveItem(iType);

    if (bInstant)
    {
        ActivateSatellite(m_arrSatellites.Length - 1, false);
    }
    else
    {
        World().m_kFundingCouncil.OnSatelliteTransferExecuted(m_arrSatellites[m_arrSatellites.Length - 1]);
    }

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordSatelliteLaunch(kCountry));
    }

    STAT_AddStat(eRecap_SatellitesLaunched, 1);

    if (STAT_GetStat(eRecap_SecondSatellite) == 0 && m_arrSatellites.Length == 2)
    {
        STAT_SetStat(eRecap_SecondSatellite, Game().GetDays());
    }
    else if (STAT_GetStat(eRecap_ThirdSatellite) == 0 && m_arrSatellites.Length == 3)
    {
        STAT_SetStat(eRecap_ThirdSatellite, Game().GetDays());
    }

    // If just now getting the We Have Ways continent bonus, and current research is an autopsy or interrogation,
    // complete the research right away
    if (Continent(kCountry.GetContinent()).HasBonus() && Continent(kCountry.GetContinent()).m_eBonus == eCB_WeHaveWays)
    {
        if (LABS().IsInterrogationTech(LABS().m_kProject.iTech) || LABS().IsAutopsyTech(LABS().m_kProject.iTech))
        {
            LABS().m_kProject.iActualHoursLeft = 0;
        }
    }
}

function AddFacility(int iFacility)
{
    // Replace all facilities with LWCE subclasses
    m_arrBaseFacilities[iFacility] += 1;

    if (iFacility == eFacility_PsiLabs)
    {
        BARRACKS().m_kPsiLabs = Spawn(class'LWCE_XGFacility_PsiLabs');
    }
    else if (iFacility == eFacility_GeneticsLab)
    {
        BARRACKS().m_kGeneLabs = Spawn(class'LWCE_XGFacility_GeneLabs');
    }
    else if (iFacility == eFacility_CyberneticsLab)
    {
        BARRACKS().m_kCyberneticsLab = Spawn(class'LWCE_XGFacility_CyberneticsLab');
        `LWCE_STORAGE.AddItem(`LW_ITEM_ID(Minigun), 1000);
        `LWCE_STORAGE.AddItem(`LW_ITEM_ID(BaseAugments), 1000);
    }
    else if (iFacility == eFacility_DeusEx)
    {
        m_kGollop = Spawn(class'LWCE_XGFacility_GollopChamber');
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

function bool ArePrereqsFulfilled(LWCE_TPrereqs kPrereqs)
{
    local int iPrereqId;
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGFacility_Labs kLabs;
    local XGGeoscape kGeoscape;
    local XGStorage kStorage;

    kBarracks = `LWCE_BARRACKS;
    kEngineering = `LWCE_ENGINEERING;
    kGeoscape = GEOSCAPE();
    kLabs = `LWCE_LABS;
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

function CreateFacilities()
{
    local XGFacility kFacility;

    // Replace all facilities with our own subclasses. We do this even for facilities we currently
    // don't have any changes to, since if we change our minds about a facility later, it's not easy
    // to insert a new class into existing save games.

    kFacility = Spawn(class'LWCE_XGFacility_MissionControl');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kMC = XGFacility_MissionControl(kFacility);

    kFacility = Spawn(class'LWCE_XGFacility_Labs');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kLabs = XGFacility_Labs(kFacility);

    kFacility = Spawn(class'LWCE_XGFacility_Engineering');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kEngineering = XGFacility_Engineering(kFacility);

    kFacility = Spawn(class'LWCE_XGFacility_Barracks');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kBarracks = XGFacility_Barracks(kFacility);

    kFacility = Spawn(class'LWCE_XGFacility_Hangar');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kHangar = XGFacility_Hangar(kFacility);

    kFacility = Spawn(class'LWCE_XGFacility_SituationRoom');
    kFacility.Init(false);
    m_arrFacilities.AddItem(kFacility);
    m_kSitRoom = XGFacility_SituationRoom(kFacility);
}

function OrderInterceptors(int iContinent, int iQuantity)
{
    local TShipOrder kOrder;
    local int iCost;

    iCost = `LWCE_ITEM(`LW_ITEM_ID(Interceptor)).kCost.iCash;

    if (!WorldInfo.IsConsoleBuild(CONSOLE_Xbox360) && !WorldInfo.IsConsoleBuild(CONSOLE_PS3))
    {
        GetRecapSaveData().RecordEvent(RecordPurchasingInterceptor(iQuantity));
    }

    // LWCE issue #1: normally when you order interceptors, the strategy HUD (particularly the player's current money)
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

    // LWCE issue #14: update resource HUD after ordering soldiers
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

    iCost = `LWCE_ITEM(`LW_ITEM_ID(Interceptor)).kCost.iCash;

    // LWCE issue #1: same fix as in OrderInterceptors, above.
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