class LWCE_XGHeadquarters extends XGHeadQuarters
    dependson(LWCETypes);

struct LWCE_TBonus
{
    var name BonusName;
    var int Level;
};

struct LWCE_TFacilityCount
{
    var name Facility;
    var int Count;
};

struct CheckpointRecord_LWCE_XGHeadquarters extends XGHeadQuarters.CheckpointRecord
{
    var array<LWCE_XGBase> m_arrBases;
    var array<LWCE_TBonus> m_arrBonuses;
    var array<LWCE_TFacilityCount> m_arrCEBaseFacilities;
    var array<LWCE_TShipOrder> m_arrCEShipOrders;
    var array<LWCE_TSatellite> m_arrCESatellites;
    var array<name> m_arrCEFacilityBinksPlayed;
    var array<name> m_arrCELastCaptives;
    var LWCEItemContainer m_kCELastCargoArtifacts;
    var int m_iNextBaseId;
    var name m_nmContinent;
    var name m_nmCountry;
};

var array<LWCE_XGBase> m_arrBases;
var array<LWCE_TBonus> m_arrBonuses;
var array<LWCE_TFacilityCount> m_arrCEBaseFacilities; // A count of each facility type XCOM has, across all bases.
var array<LWCE_TShipOrder> m_arrCEShipOrders;
var array<LWCE_TSatellite> m_arrCESatellites;
var array<name> m_arrCEFacilityBinksPlayed;
var array<name> m_arrCELastCaptives;
var LWCEItemContainer m_kCELastCargoArtifacts;
var int m_iNextBaseId;
var name m_nmContinent;
var name m_nmCountry;

var const localized string m_strHQBaseName;

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

    for (iSat = 0; iSat < m_arrCESatellites.Length; iSat++)
    {
        if (m_arrCESatellites[iSat].kSatEntity == none)
        {
            m_arrCESatellites[iSat].kSatEntity = Spawn(class'LWCE_XGEntity');
            m_arrCESatellites[iSat].kSatEntity.AssignGameActor(self, m_arrCESatellites.Length);
            m_arrCESatellites[iSat].kSatEntity.Init(eEntityGraphic_Sat_Persistent);
            m_arrCESatellites[iSat].kSatEntity.SetHidden(true);
            m_arrCESatellites[iSat].kSatEntity.SetBase(none);
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

    CreateFacilities();

    foreach m_arrFacilities(kFacility)
    {
        kFacility.InitNewGame();
    }

    m_kBase = AddBase(m_strHQBaseName, /* bIsPrimaryBase */ true, /* bUsesAccessLifts */ true, /* Width */ 7, /* Height */ 5, GetCoords());

    m_kActiveFacility = m_arrFacilities[0];
    m_fAnnounceTimer = 10.0;

    for (I = 0; I < 5; I++)
    {
        if (I != m_iContinent)
        {
            AddOutpost(I);
        }
    }

    World().m_kFundingCouncil = Spawn(class'LWCE_XGFundingCouncil');
    World().m_kFundingCouncil.InitNewGame();
}

/// <summary>
/// Adds a new XCOM base with the given parameters. Aside from the base's name, other attributes should be considered immutable.
/// </summary>
/// <param name="strName">The player-visible name of this base.</param>
/// <param name="bIsPrimaryBase">Whether this is XCOM's main HQ. Only one base should have this set per campaign.</param>
/// <param name="bUsesAccessLifts">Whether this facility requires access lifts. If not, access lifts won't be available to build here,
/// and all levels can be built at simultaneously. Excavation cost also will not scale based on Y coordinate.</param>
/// <param name="Width">How many tiles wide the base is. If more than 7, the Build Facilities UI will get buggy.</param>
/// <param name="Height">How many tiles tall the base is. All bases have an invisible "0" row of tiles, which should be included in the height.</param>
/// <param name="Coords">The coordinates on the Geoscape where this base is located.</param>
function LWCE_XGBase AddBase(string strName, bool bIsPrimaryBase, bool bUsesAccessLifts, int Width, int Height, Vector2D Coords)
{
    local LWCE_XGBase kBase;

    kBase = Spawn(class'LWCE_XGBase');
    kBase.LWCE_Init(strName, bIsPrimaryBase, bUsesAccessLifts, ++m_iNextBaseId, Width, Height, Coords);

    m_arrBases.AddItem(kBase);

    return kBase;
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
    `LWCE_LOG_DEPRECATED_CLS(AddSatelliteNode);
}

function LWCE_AddSatelliteNode(name nmCountry, name nmType, optional bool bInstant)
{
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGWorld kWorld;
    local LWCE_XGCountry kCountry;
    local LWCE_TSatellite kSatellite;
    local LWCE_TSatNode kNode;

    kLabs = LWCE_XGFacility_Labs(LABS());
    kWorld = LWCE_XGWorld(WORLD());
    kCountry = kWorld.LWCE_GetCountry(nmCountry);
    kNode = kWorld.LWCE_GetSatelliteNode(nmCountry);

    kSatellite.nmType = nmType;
    kSatellite.v2Loc = kNode.v2Coords;
    kSatellite.nmCountry = nmCountry;

    if (!bInstant)
    {
        kSatellite.iTravelTime = LWCE_XGGeoscape(GEOSCAPE()).LWCE_GetSatTravelTime(nmCountry) * 24;
    }

    kCountry = kWorld.LWCE_GetCountry(nmCountry);
    kCountry.SetSatelliteCoverage(true);

    if (!bInstant)
    {
        kWorld.LWCE_GetContinent(kCountry.m_nmContinent).m_kMonthly.iSatellitesLaunched += 1;
    }

    kSatellite.kSatEntity = Spawn(class'LWCE_XGEntity');
    kSatellite.kSatEntity.AssignGameActor(self, m_arrCESatellites.Length);
    kSatellite.kSatEntity.Init(eEntityGraphic_Sat_Persistent);
    kSatellite.kSatEntity.SetHidden(true);
    kSatellite.kSatEntity.SetBase(none);

    m_arrCESatellites.AddItem(kSatellite);
    LWCE_XGStorage(STORAGE()).LWCE_RemoveItem(nmType);

    if (bInstant)
    {
        ActivateSatellite(m_arrCESatellites.Length - 1, false);
    }
    else
    {
        LWCE_XGFundingCouncil(kWorld.m_kFundingCouncil).LWCE_OnSatelliteTransferExecuted(m_arrCESatellites[m_arrCESatellites.Length - 1]);
    }

    STAT_AddStat(eRecap_SatellitesLaunched, 1);

    if (STAT_GetStat(eRecap_SecondSatellite) == 0 && m_arrCESatellites.Length == 2)
    {
        STAT_SetStat(eRecap_SecondSatellite, Game().GetDays());
    }
    else if (STAT_GetStat(eRecap_ThirdSatellite) == 0 && m_arrCESatellites.Length == 3)
    {
        STAT_SetStat(eRecap_ThirdSatellite, Game().GetDays());
    }

    // If just now getting the We Have Ways continent bonus, and current research is an autopsy or interrogation,
    // complete the research right away
    // TODO rewrite this and also make it not do this in Long War, just apply the bonus
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
    `LWCE_LOG_DEPRECATED_CLS(AddFacility);
}

function LWCE_AddFacility(name nmFacility)
{
    local LWCEFacilityTemplate kTemplate;
    local XGFacility kFacility;

    kTemplate = `LWCE_FACILITY(nmFacility);

    if (kTemplate.FacilityClass != "")
    {
        kFacility = Spawn(class<XGFacility>(DynamicLoadObject(kTemplate.FacilityClass, class'Class')));

        if (kFacility.IsA('XGFacility_PsiLabs'))
        {
            BARRACKS().m_kPsiLabs = XGFacility_PsiLabs(kFacility);
        }
        else if (kFacility.IsA('XGFacility_GeneLabs'))
        {
            BARRACKS().m_kGeneLabs = XGFacility_GeneLabs(kFacility);
        }
        else if (kFacility.IsA('XGFacility_CyberneticsLab'))
        {
            BARRACKS().m_kCyberneticsLab = XGFacility_CyberneticsLab(kFacility);
        }
        else if (kFacility.IsA('XGFacility_GollopChamber'))
        {
            m_kGollop = XGFacility_GollopChamber(kFacility);
        }

        if (kTemplate.bIsTopLevel)
        {
            m_arrFacilities.AddItem(kFacility);
        }
    }

    ModifyFacilityCount(nmFacility, 1);
}

/// <summary>
/// Checks if the provided prerequisites are currently fulfilled. Optional parameters allow for
/// "what-if" checks, e.g. "will these prereqs be fulfilled if the given Foundry project is completed".
/// </summary>
function bool ArePrereqsFulfilled(LWCE_TPrereqs kPrereqs,
                                  optional name TechName,
                                  optional name FacilityName,
                                  optional name FoundryName,
                                  optional name ItemName)
{
    local name PrereqName;
    local int iPrereqId;
    local LWCE_XGFacility_Barracks kBarracks;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGStorage kStorage;
    local LWCE_XGGeoscape kGeoscape;

    kBarracks = `LWCE_BARRACKS;
    kEngineering = `LWCE_ENGINEERING;
    kGeoscape = LWCE_XGGeoscape(GEOSCAPE());
    kLabs = `LWCE_LABS;
    kStorage = LWCE_XGStorage(STORAGE());

    foreach kPrereqs.arrFacilityReqs(PrereqName)
    {
        if (!LWCE_HasFacility(PrereqName) && PrereqName != FacilityName)
        {
            return false;
        }
    }

    foreach kPrereqs.arrFoundryReqs(PrereqName)
    {
        if (!kEngineering.LWCE_IsFoundryTechResearched(PrereqName) && PrereqName != FoundryName)
        {
            return false;
        }
    }

    foreach kPrereqs.arrItemReqs(PrereqName)
    {
        if (!kStorage.LWCE_EverHadItem(PrereqName) && PrereqName != ItemName)
        {
            return false;
        }
    }

    foreach kPrereqs.arrTechReqs(PrereqName)
    {
        if (!kLabs.LWCE_IsResearched(PrereqName) && PrereqName != TechName)
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

    if (kPrereqs.bRequiresAutopsy && kLabs.GetNumAutopsiesPerformed() == 0 && (TechName == '' || !`LWCE_TECH(TechName).bIsAutopsy))
    {
        return false;
    }

    if (kPrereqs.bRequiresInterrogation && !kLabs.HasInterrogatedCaptive() && (TechName == '' || !`LWCE_TECH(TechName).bIsInterrogation))
    {
        return false;
    }

    return true;
}

/// <summary>
/// Checks if the staff listed in the requirements are present in XCOM HQ.
/// </summary>
function bool AreStaffPresent(array<LWCE_TStaffRequirement> arrStaffRequirements)
{
    local int Index;

    for (Index = 0; Index < arrStaffRequirements.Length; Index++)
    {
        switch (arrStaffRequirements[Index].StaffType)
        {
            case 'Engineer':
                if (GetResource(eResource_Engineers) < arrStaffRequirements[Index].NumRequired)
                {
                    return false;
                }

                break;
            case 'Scientist':
                if (GetResource(eResource_Scientists) < arrStaffRequirements[Index].NumRequired)
                {
                    return false;
                }

                break;
            default:
                `LWCE_LOG_CLS("Unrecognized staff type '" $ arrStaffRequirements[Index].StaffType $ "' in AreStaffPresent");
                break;
        }
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

function LWCE_XGBase GetBaseById(int Id)
{
    local LWCE_XGBase kBase;

    foreach m_arrBases(kBase)
    {
        if (kBase.m_iId == Id)
        {
            return kBase;
        }
    }

    return none;
}

function int GetBonusLevel(name nmBonus)
{
    local int Index;

    Index = m_arrBonuses.Find('BonusName', nmBonus);

    if (Index == INDEX_NONE)
    {
        return 0;
    }

    return m_arrBonuses[Index].Level;
}

function int GetContinent()
{
    `LWCE_LOG_DEPRECATED_CLS(GetContinent);
    return -100;
}

function name LWCE_GetContinent()
{
    return m_nmContinent;
}

function GetEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEvents);
}

function LWCE_GetEvents(out array<LWCE_THQEvent> arrEvents)
{
    local LWCE_XGFundingCouncil kFundingCouncil;
    local LWCE_THQEvent kBlankEvent, kEvent;
    local int Index, iEvent;
    local bool bAdded;

    kFundingCouncil = LWCE_XGFundingCouncil(World().m_kFundingCouncil);

    for (Index = 0; Index < m_arrHiringOrders.Length; Index++)
    {
        kEvent = kBlankEvent;
        kEvent.EventType = 'Hiring';
        kEvent.iHours = m_arrHiringOrders[Index].iHours;

        kEvent.kData = class'LWCEDataContainer'.static.New('THQEventData');
        kEvent.kData.AddInt(m_arrHiringOrders[Index].iStaffType);
        kEvent.kData.AddInt(m_arrHiringOrders[Index].iNumStaff);

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

        kEvent.kData = class'LWCEDataContainer'.static.New('THQEventData');
        kEvent.kData.AddInt(m_akInterceptorOrders[Index].iDestinationContinent);
        kEvent.kData.AddInt(m_akInterceptorOrders[Index].iNumInterceptors);

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

        kEvent.kData = class'LWCEDataContainer'.static.New('THQEventData');
        kEvent.kData.AddInt(m_arrShipTransfers[Index].iDestination);
        kEvent.kData.AddInt(m_arrShipTransfers[Index].iNumShips);

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
        kEvent = kBlankEvent;
        kEvent.EventType = 'FCRequest';
        kEvent.iHours = kFundingCouncil.m_arrCECurrentRequests[Index].iHoursToRespond;

        kEvent.kData = class'LWCEDataContainer'.static.New('THQEventData');
        kEvent.kData.AddInt(Country(kFundingCouncil.m_arrCECurrentRequests[Index].eRequestingCountry).GetContinent());

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

    for (Index = 0; Index < m_arrCESatellites.Length; Index++)
    {
        if (m_arrCESatellites[Index].iTravelTime > 0)
        {
            kEvent =  kBlankEvent;
            kEvent.EventType = 'SatOperational';
            kEvent.iHours = m_arrCESatellites[Index].iTravelTime;

            kEvent.kData = class'LWCEDataContainer'.static.New('THQEventData');
            kEvent.kData.AddName(m_arrCESatellites[Index].nmCountry);

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

function int GetFacilityMaintenanceCost()
{
    local LWCEFacilityTemplateManager kTemplateMgr;
    local LWCEFacilityTemplate kTemplate;
    local int Index, iMaintenance;

    kTemplateMgr = `LWCE_FACILITY_TEMPLATE_MGR;

    for (Index = 0; Index < m_arrCEBaseFacilities.Length; Index++)
    {
        if (m_arrCEBaseFacilities[Index].Count > 0)
        {
            kTemplate = kTemplateMgr.FindFacilityTemplate(m_arrCEBaseFacilities[Index].Facility);

            iMaintenance += kTemplate.GetMonthlyCost() * m_arrCEBaseFacilities[Index].Count;
        }
    }

    return -iMaintenance;
}

function int GetNumFacilities(EFacilityType eFacility)
{
    `LWCE_LOG_DEPRECATED_CLS(GetNumFacilities);

    return -1;
}

function int LWCE_GetNumFacilities(name nmFacility, optional bool bIncludeBuilding = false)
{
    local int Count, Index;

    Index = m_arrCEBaseFacilities.Find('Facility', nmFacility);

    if (Index != INDEX_NONE)
    {
        Count = m_arrCEBaseFacilities[Index].Count;
    }

    if (bIncludeBuilding)
    {
        Count += LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_GetNumFacilitiesBuilding(nmFacility);
    }

    return Count;
}

/// <summary>
/// Returns the power capacity of XCOM's main base.
/// </summary>
function int GetPowerCapacity()
{
    return LWCE_XGBase(m_kBase).GetPowerCapacity();
}

/// <summary>
/// Returns how much power is being used by XCOM's main base.
/// </summary>
function int GetPowerUsed()
{
    return LWCE_XGBase(m_kBase).GetPowerUsed();
}

function int GetSatelliteLimit()
{
    local LWCEFacilityTemplateManager kTemplateMgr;
    local LWCEFacilityTemplate kTemplate;
    local int Index, iSatelliteLimit;

    kTemplateMgr = `LWCE_FACILITY_TEMPLATE_MGR;

    for (Index = 0; Index < m_arrCEBaseFacilities.Length; Index++)
    {
        if (m_arrCEBaseFacilities[Index].Count > 0)
        {
            kTemplate = kTemplateMgr.FindFacilityTemplate(m_arrCEBaseFacilities[Index].Facility);
            iSatelliteLimit += kTemplate.GetSatelliteCapacity() * m_arrCEBaseFacilities[Index].Count;
        }
    }

    iSatelliteLimit += class'XGTacticalGameCore'.default.UPLINK_ADJACENCY_BONUS * LWCE_XGBase(Base()).LWCE_GetAdjacencies('Satellite');

    return iSatelliteLimit;
}

function bool HasFacility(int iFacility)
{
    `LWCE_LOG_DEPRECATED_CLS(HasFacility);

    return false;
}

function bool LWCE_HasFacility(name nmFacility)
{
    local int Index;

    Index = m_arrCEBaseFacilities.Find('Facility', nmFacility);

    return Index == INDEX_NONE ? false : m_arrCEBaseFacilities[Index].Count > 0;
}

/// <summary>
/// Increase or decrease the level of a bonus. If increasing a bonus which is not already earned,
/// it will be newly applied; if decreasing a bonus to level 0 or below, it will be unapplied. Note
/// that bonuses with negative levels will actually be persisted, not deleted, just in case this is
/// useful behavior for some mod.
///
/// An event, 'BonusLevelChanged', will be emitted before this function returns.
/// </summary>
/// <param name="nmBonus">The name of the bonus to modify.</param>
/// <param name="iAdjustment">How much to change the bonus level by.</param>
/// <returns>The new level of the bonus after incrementing it.</param>
function int AdjustBonusLevel(name nmBonus, int iAdjustment)
{
    local LWCEDataContainer kEventData;
    local LWCE_TBonus kBonus;
    local int Index, iOriginalLevel, iAdjustedLevel;

    Index = m_arrBonuses.Find('BonusName', nmBonus);

    if (Index == INDEX_NONE)
    {
        iOriginalLevel = 0;
        iAdjustedLevel = iAdjustment;

        kBonus.BonusName = nmBonus;
        kBonus.Level = iAdjustedLevel;
        m_arrBonuses.AddItem(kBonus);
    }
    else
    {
        iOriginalLevel = m_arrBonuses[Index].Level;
        iAdjustedLevel = iOriginalLevel + iAdjustment;

        m_arrBonuses[Index].Level = iAdjustedLevel;
    }

    // EVENT: BonusLevelChanged
    //
    // SUMMARY: Emitted when a bonus (such as a country or continent bonus) has just changed.
    //          Most bonuses don't need to care when this happens, but it could be relevant to some;
    //          for example, a bonus granting worldwide vision of all UFOs would want to update the
    //          geoscape immediately when activated.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: int - The level of the bonus before the change.
    //       Data[1]: int - The level of the bonus after the change.
    //
    // SOURCE: LWCE_XGHeadquarters
    kEventData = class'LWCEDataContainer'.static.New('BonusLevelChanged');
    kEventData.AddInt(iOriginalLevel);
    kEventData.AddInt(iAdjustedLevel);

    `LWCE_EVENT_MGR.TriggerEvent('BonusLevelChanged', kEventData, self);

    return iAdjustedLevel;
}

function bool IsHyperwaveActive()
{
    return LWCE_HasFacility('Facility_HyperwaveRadar') && m_bHyperwaveActivated;
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

function RemoveFacility(int iFacility)
{
    `LWCE_LOG_DEPRECATED_CLS(RemoveFacility);
}

function LWCE_RemoveFacility(name nmFacility)
{
    ModifyFacilityCount(nmFacility, -1);
}

function SetStartingData(name nmContinent, name nmCountry, name nmStartingBonus)
{
    m_nmContinent = nmContinent;
    m_nmCountry = nmCountry;

    // TODO make starting bonus level a configurable value
    AdjustBonusLevel(nmStartingBonus, 2);

    LWCE_XGStorage(STORAGE()).LWCE_AddItem('Item_Satellite');
    LWCE_AddSatelliteNode(nmCountry, 'Item_Satellite', true);
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

protected function ModifyFacilityCount(name nmFacility, int Delta)
{
    local LWCE_TFacilityCount kFacilityCount;
    local int Index;

    Index = m_arrCEBaseFacilities.Find('Facility', nmFacility);

    if (Index == INDEX_NONE)
    {
        if (Delta < 0)
        {
            `LWCE_LOG_CLS("ERROR: asked to change facility count for " $ nmFacility $ " by " $ Delta $ ", but no such facilities are in HQ");
            return;
        }

        kFacilityCount.Facility = nmFacility;
        kFacilityCount.Count = Delta;
        m_arrCEBaseFacilities.AddItem(kFacilityCount);
    }
    else
    {
        if (Delta + m_arrCEBaseFacilities[Index].Count < 0)
        {
            `LWCE_LOG_CLS("ERROR: asked to change facility count for " $ nmFacility $ " by " $ Delta $ ", but this would result in a negative number of facilities of this type");
            return;
        }

        m_arrCEBaseFacilities[Index].Count += Delta;
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