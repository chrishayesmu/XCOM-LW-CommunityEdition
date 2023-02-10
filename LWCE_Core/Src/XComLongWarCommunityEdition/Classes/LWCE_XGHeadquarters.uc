class LWCE_XGHeadquarters extends XGHeadQuarters
    dependson(LWCETypes);

struct CheckpointRecord_LWCE_XGHeadquarters extends XGHeadQuarters.CheckpointRecord
{
    var array<name> m_arrCELastCaptives;
    var LWCEItemContainer m_kCELastCargoArtifacts;
};

var array<name> m_arrCELastCaptives;
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

    // Normally there's a Mutate call with "XGHeadQuarters.InitNewGame" here. We try not to remove those calls,
    // but if it's left in, the XComFCMutator mod (which is included in Long War) will spawn its own XGFundingCouncil_Mod
    // class, which we inherit from for our own.

    // TODO: add our own mod hook here to replace the Mutate call

    World().m_kFundingCouncil = Spawn(class'LWCE_XGFundingCouncil');
    World().m_kFundingCouncil.InitNewGame();
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
    local LWCE_XGFacility_Labs kLabs;
    local TSatellite kSatellite;
    local XGCountry kCountry;
    local TSatNode kNode;

    kLabs = LWCE_XGFacility_Labs(LABS());
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
    LWCE_XGStorage(STORAGE()).LWCE_RemoveItem('Item_Satellite');

    if (bInstant)
    {
        ActivateSatellite(m_arrSatellites.Length - 1, false);
    }
    else
    {
        World().m_kFundingCouncil.OnSatelliteTransferExecuted(m_arrSatellites[m_arrSatellites.Length - 1]);
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
        if (kLabs.LWCE_IsInterrogationTech(kLabs.m_kCEProject.TechName) || kLabs.LWCE_IsAutopsyTech(kLabs.m_kCEProject.TechName))
        {
            kLabs.m_kCEProject.iActualHoursLeft = 0;
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
        `LWCE_STORAGE.LWCE_AddItem('Item_Minigun', 1000);
        `LWCE_STORAGE.LWCE_AddItem('Item_BaseAugments', 1000);
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
    local name PrereqName;
    local int iPrereqId;
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGFacility_Labs kLabs;
    local XGGeoscape kGeoscape;
    local LWCE_XGStorage kStorage;

    kBarracks = `LWCE_BARRACKS;
    kEngineering = `LWCE_ENGINEERING;
    kGeoscape = GEOSCAPE();
    kLabs = `LWCE_LABS;
    kStorage = LWCE_XGStorage(STORAGE());

    foreach kPrereqs.arrFacilityReqs(iPrereqId)
    {
        if (!HasFacility(iPrereqId))
        {
            return false;
        }
    }

    foreach kPrereqs.arrFoundryReqs(PrereqName)
    {
        if (!kEngineering.LWCE_IsFoundryTechResearched(PrereqName))
        {
            return false;
        }
    }

    foreach kPrereqs.arrItemReqs(PrereqName)
    {
        if (!kStorage.LWCE_EverHadItem(PrereqName))
        {
            return false;
        }
    }

    foreach kPrereqs.arrTechReqs(PrereqName)
    {
        if (!kLabs.LWCE_IsResearched(PrereqName))
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

/// <summary>
/// Checks whether the player can afford to pay the specified cost.
/// </summary>
/// <returns>True if affordable, false if not.</returns>
function bool CanAffordCost(const LWCE_TCost kCost)
{
    local int Index;
    local LWCE_XGStorage kStorage;

    kStorage = LWCE_XGStorage(STORAGE());

    if (kCost.iCash > GetResource(eResource_Money))
    {
        return false;
    }

    if (kCost.iAlloys > GetResource(eResource_Alloys))
    {
        return false;
    }

    if (kCost.iElerium > GetResource(eResource_Elerium))
    {
        return false;
    }

    if (kCost.iMeld > GetResource(eResource_Meld))
    {
        return false;
    }

    if (kCost.iWeaponFragments > kStorage.LWCE_GetNumItemsAvailable('Item_WeaponFragment'))
    {
        return false;
    }

    for (Index = 0; Index < kCost.arrItems.Length; Index++)
    {
        if (kCost.arrItems[Index].iQuantity > kStorage.LWCE_GetNumItemsAvailable(kCost.arrItems[Index].ItemName))
        {
            return false;
        }
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

function GetEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEvents);
}

function LWCE_GetEvents(out array<LWCE_THQEvent> arrEvents)
{
    local LWCE_XGFundingCouncil kFundingCouncil;
    local LWCE_TData kData;
    local LWCE_THQEvent kBlankEvent, kEvent;
    local int Index, iEvent;
    local bool bAdded;

    kFundingCouncil = LWCE_XGFundingCouncil(World().m_kFundingCouncil);

    for (Index = 0; Index < m_arrHiringOrders.Length; Index++)
    {
        kEvent =  kBlankEvent;
        kEvent.EventType = 'Hiring';
        kEvent.iHours = m_arrHiringOrders[Index].iHours;

        kData.eType = eDT_Int;
        kData.iData = m_arrHiringOrders[Index].iStaffType;
        kEvent.arrData.AddItem(kData);

        kData.eType = eDT_Int;
        kData.iData = m_arrHiringOrders[Index].iNumStaff;
        kEvent.arrData.AddItem(kData);

        bAdded = false;

        for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
        {
            if (arrEvents[iEvent].iHours > kEvent.iHours)
            {
                arrEvents.InsertItem(iEvent, kEvent);
                bAdded = true;
                break;
            }
        }

        if (!bAdded)
        {
            arrEvents.AddItem(kEvent);
        }
    }

    for (Index = 0; Index < m_akInterceptorOrders.Length; Index++)
    {
        kEvent =  kBlankEvent;
        kEvent.EventType = 'InterceptorOrdering';
        kEvent.iHours = m_akInterceptorOrders[Index].iHours;

        kData.eType = eDT_Int;
        kData.iData = m_akInterceptorOrders[Index].iDestinationContinent;
        kEvent.arrData.AddItem(kData);

        kData.eType = eDT_Int;
        kData.iData = m_akInterceptorOrders[Index].iNumInterceptors;
        kEvent.arrData.AddItem(kData);

        bAdded = false;

        for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
        {
            if (arrEvents[iEvent].iHours > kEvent.iHours)
            {
                arrEvents.InsertItem(iEvent, kEvent);
                bAdded = true;
                break;
            }
        }

        if (!bAdded)
        {
            arrEvents.AddItem(kEvent);
        }
    }

    for (Index = 0; Index < m_arrShipTransfers.Length; Index++)
    {
        kEvent =  kBlankEvent;
        kEvent.EventType = 'ShipTransfers';
        kEvent.iHours = m_arrShipTransfers[Index].iHours;

        kData.eType = eDT_Int;
        kData.iData = m_arrShipTransfers[Index].iDestination;
        kEvent.arrData.AddItem(kData);

        kData.eType = eDT_Int;
        kData.iData = m_arrShipTransfers[Index].iNumShips;
        kEvent.arrData.AddItem(kData);

        bAdded = false;

        for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
        {
            if (arrEvents[iEvent].iHours > kEvent.iHours)
            {
                arrEvents.InsertItem(iEvent, kEvent);
                bAdded = true;
                break;
            }
        }

        if (!bAdded)
        {
            arrEvents.AddItem(kEvent);
        }
    }

    for (Index = 0; Index < kFundingCouncil.m_arrCECurrentRequests.Length; Index++)
    {
        kEvent =  kBlankEvent;
        kEvent.EventType = 'FCRequest';
        kEvent.iHours = kFundingCouncil.m_arrCECurrentRequests[Index].iHoursToRespond;

        kData.eType = eDT_Int;
        kData.iData = Country(kFundingCouncil.m_arrCECurrentRequests[Index].eRequestingCountry).GetContinent();
        kEvent.arrData.AddItem(kData);

        bAdded = false;

        for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
        {
            if (arrEvents[iEvent].iHours > kEvent.iHours)
            {
                arrEvents.InsertItem(iEvent, kEvent);
                bAdded = true;
                break;
            }
        }

        if (!bAdded)
        {
            arrEvents.AddItem(kEvent);
        }
    }

    for (Index = 0; Index < m_arrSatellites.Length; Index++)
    {
        if (m_arrSatellites[Index].iTravelTime > 0)
        {
        kEvent =  kBlankEvent;
            kEvent.EventType = 'SatOperational';
            kEvent.iHours = m_arrSatellites[Index].iTravelTime;

            kData.eType = eDT_Int;
            kData.iData = m_arrSatellites[Index].iCountry;
            kEvent.arrData.AddItem(kData);

            bAdded = false;

            for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
            {
                if (arrEvents[iEvent].iHours > kEvent.iHours)
                {
                    arrEvents.InsertItem(iEvent, kEvent);
                    bAdded = true;
                    break;
                }
            }

            if (!bAdded)
            {
                arrEvents.AddItem(kEvent);
            }
        }
    }
}

function OrderInterceptors(int iContinent, int iQuantity)
{
    local TShipOrder kOrder;
    local int iCost;

    iCost = `LWCE_ITEM('Item_Interceptor').kCost.iCash;

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

function bool PayCost(const LWCE_TCost kCost)
{
    local int Index;
    local LWCE_XGStorage kStorage;

    kStorage = LWCE_XGStorage(STORAGE());

    if (!CanAffordCost(kCost))
    {
        return false;
    }

    AddResource(eResource_Money, -1 * kCost.iCash);
    AddResource(eResource_Alloys, -1 * kCost.iAlloys);
    AddResource(eResource_Elerium, -1 * kCost.iElerium);
    AddResource(eResource_Meld, -1 * kCost.iMeld);

    if (kCost.iWeaponFragments > 0)
    {
        kStorage.LWCE_RemoveItem('Item_WeaponFragment', kCost.iWeaponFragments);
    }

    for (Index = 0; Index < kCost.arrItems.Length; Index++)
    {
        kStorage.LWCE_RemoveItem(kCost.arrItems[Index].ItemName, kCost.arrItems[Index].iQuantity);
    }

    return true;
}

function ReduceInterceptorOrder(int iOrder)
{
    local int iCost;

    if (iOrder < 0 || iOrder >= m_akInterceptorOrders.Length)
    {
        return;
    }

    iCost = `LWCE_ITEM('Item_Interceptor').kCost.iCash;

    // LWCE issue #1: same fix as in OrderInterceptors, above.
    AddResource(eResource_Money, iCost);
    PRES().GetStrategyHUD().UpdateDefaultResources();

    --m_akInterceptorOrders[iOrder].iNumInterceptors;

    if (m_akInterceptorOrders[iOrder].iNumInterceptors <= 0)
    {
        m_akInterceptorOrders.Remove(iOrder, 1);
    }
}

function RefundCost(const LWCE_TCost kCost)
{
    local int Index;
    local LWCE_XGStorage kStorage;

    kStorage = LWCE_XGStorage(STORAGE());

    AddResource(eResource_Money, kCost.iCash, /* bRefund */ true);
    AddResource(eResource_Alloys, kCost.iAlloys, /* bRefund */ true);
    AddResource(eResource_Elerium, kCost.iElerium, /* bRefund */ true);
    AddResource(eResource_Meld, kCost.iMeld, /* bRefund */ true);

    if (kCost.iWeaponFragments > 0)
    {
        kStorage.LWCE_AddItem('Item_WeaponFragment', kCost.iWeaponFragments);
    }

    for (Index = 0; Index < kCost.arrItems.Length; Index++)
    {
        kStorage.LWCE_AddItem(kCost.arrItems[Index].ItemName, kCost.arrItems[Index].iQuantity);
    }
}

function UpdateInterceptorOrders()
{
    local LWCE_XGStorage kStorage;
    local array<int> aiRemove;
    local int iOrder, iOrderCount, iContinent, iTransfer;

    kStorage = LWCE_XGStorage(STORAGE());

    for (iOrder = 0; iOrder < m_akInterceptorOrders.Length; iOrder++)
    {
        m_akInterceptorOrders[iOrder].iHours -= 1;

        if (m_akInterceptorOrders[iOrder].iHours <= 0)
        {
            aiRemove.AddItem(iOrder);

            for (iOrderCount = 0; iOrderCount < m_akInterceptorOrders[iOrder].iNumInterceptors; iOrderCount++)
            {
                iContinent = m_akInterceptorOrders[iOrder].iDestinationContinent;
                kStorage.LWCE_AddItem('Item_Interceptor', 1, iContinent);
            }

            PRES().Notify(eGA_NewInterceptors, m_akInterceptorOrders[iOrder].iNumInterceptors, m_akInterceptorOrders[iOrder].iDestinationContinent);
        }
    }

    for (iOrder = aiRemove.Length - 1; iOrder >= 0; iOrder--)
    {
        m_akInterceptorOrders.Remove(aiRemove[iOrder], 1);
    }

    aiRemove.Remove(0, aiRemove.Length);

    for (iTransfer = 0; iTransfer < m_arrShipTransfers.Length; iTransfer++)
    {
        m_arrShipTransfers[iTransfer].iHours -= 1;

        if (m_arrShipTransfers[iTransfer].iHours > 0)
        {
        }
        else
        {
            aiRemove.AddItem(iTransfer);
        }
    }

    for (iOrder = aiRemove.Length - 1; iOrder >= 0; iOrder--)
    {
        m_arrShipTransfers.Remove(aiRemove[iOrder], 1);
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