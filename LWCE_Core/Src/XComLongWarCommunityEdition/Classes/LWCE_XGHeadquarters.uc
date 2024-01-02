class LWCE_XGHeadquarters extends XGHeadQuarters
    dependson(LWCETypes);

const COUNTRY_SATELLITE_BONUS_LEVEL_AMOUNT = 1;   // The normal bonus level gained from placing a satellite over a country.
const COUNTRY_STARTING_BONUS_LEVEL_AMOUNT = 2;    // The normal bonus level gained from starting in a particular country.
const CONTINENT_SATELLITE_BONUS_LEVEL_AMOUNT = 2; // The normal bonus level gained from completing satellite coverage over an entire continent.

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
    var array<LWCE_TShipTransfer> m_arrCEShipTransfers;
    var array<LWCE_TShipOrder> m_arrCEShipOrders;
    var array<LWCE_TSatellite> m_arrCESatellites;
    var array<name> m_arrCEFacilityBinksPlayed;
    var array<name> m_arrCELastCaptives;
    var LWCEItemContainer m_kCELastCargoArtifacts;
    var int m_iNextBaseId;
    var name m_nmContinent;
    var name m_nmCountry;
    var name m_nmStartingBonus;
};

var array<LWCE_XGBase> m_arrBases;
var array<LWCE_TBonus> m_arrBonuses;
var array<LWCE_TFacilityCount> m_arrCEBaseFacilities; // A count of each facility type XCOM has, across all bases.
var array<LWCE_TShipOrder> m_arrCEShipOrders;
var array<LWCE_TShipTransfer> m_arrCEShipTransfers;
var array<LWCE_TSatellite> m_arrCESatellites;
var array<name> m_arrCEFacilityBinksPlayed;
var array<name> m_arrCELastCaptives;
var LWCEItemContainer m_kCELastCargoArtifacts;
var int m_iNextBaseId;
var name m_nmContinent;
var name m_nmCountry;
var name m_nmStartingBonus;

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

    m_kBase = AddBase(m_strHQBaseName, /* bIsPrimaryBase */ true, /* bUsesAccessLifts */ true, /* Width */ 7, /* Height */ 5, GetCoords());

    CreateFacilities();

    foreach m_arrFacilities(kFacility)
    {
        kFacility.InitNewGame();
    }

    m_kActiveFacility = m_arrFacilities[0];
    m_fAnnounceTimer = 10.0;

    // TODO replace this loop
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
    local LWCE_XGWorld kWorld;
    local LWCE_XGCountry kCountry;
    local LWCE_TSatellite kSatellite;
    local LWCE_TSatNode kNode;

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

function bool CanLaunchSatelliteTo(int iCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(CanLaunchSatelliteTo);

    return false;
}

/// <summary>
/// Checks whether the player can launch a satellite to the specified country. In vanilla EW, this
/// would have checked if the country had left the nation; that check was removed in LW since that's
/// how you do alien base assaults. A new check is added in LWCE that the country doesn't already have
/// a satellite, which helps make the result more consistent with the function's name.
/// </summary>
function bool LWCE_CanLaunchSatelliteTo(name nmCountry)
{
    local LWCE_XGStorage kStorage;

    kStorage = LWCE_XGStorage(STORAGE());

    return kStorage.LWCE_GetNumItemsAvailable('Item_Satellite') > 0 && !`LWCE_XGCountry(nmCountry).HasSatelliteCoverage();
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

/// <summary>
/// Retrieves the current level of the specified bonus. If unearned, it will be 0.
/// </summary>
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
    local LWCE_XGCountry kCountry;
    local LWCE_XGFundingCouncil kFundingCouncil;
    local LWCE_XGWorld kWorld;
    local LWCE_THQEvent kBlankEvent, kEvent;
    local int Index, iEvent;
    local bool bAdded;

    kWorld = LWCE_XGWorld(WORLD());
    kFundingCouncil = LWCE_XGFundingCouncil(kWorld.m_kFundingCouncil);

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

    for (Index = 0; Index < m_arrCEShipOrders.Length; Index++)
    {
        kEvent = kBlankEvent;
        kEvent.EventType = 'InterceptorOrdering';
        kEvent.iHours = m_arrCEShipOrders[Index].iHours;

        kEvent.kData = class'LWCEDataContainer'.static.New('THQEventData');
        kEvent.kData.AddName(m_arrCEShipOrders[Index].nmDestinationContinent);
        kEvent.kData.AddInt(m_arrCEShipOrders[Index].iNumShips);

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

    for (Index = 0; Index < m_arrCEShipTransfers.Length; Index++)
    {
        kEvent = kBlankEvent;
        kEvent.EventType = 'ShipTransfers';
        kEvent.iHours = m_arrCEShipTransfers[Index].iHours;

        kEvent.kData = class'LWCEDataContainer'.static.New('THQEventData');
        kEvent.kData.AddName(m_arrCEShipTransfers[Index].nmDestinationContinent);
        kEvent.kData.AddInt(m_arrCEShipTransfers[Index].iNumShips);

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
        kCountry = kWorld.LWCE_GetCountry(kFundingCouncil.m_arrCECurrentRequests[Index].nmRequestingCountry);
        kEvent = kBlankEvent;
        kEvent.EventType = 'FCRequest';
        kEvent.iHours = kFundingCouncil.m_arrCECurrentRequests[Index].iHoursToRespond;

        kEvent.kData = class'LWCEDataContainer'.static.New('THQEventData');
        kEvent.kData.AddName(kCountry.LWCE_GetContinent());

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
            kEvent = kBlankEvent;
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

function int GetSatellite(ECountry eSatCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(GetSatellite);

    return 1000;
}

/// <summary>
/// Returns the index in m_arrCESatellites of the satellite over the given country, if any.
/// </summary>
/// <param name="nmSatCountry">The country to check for a satellite over.</param>
/// <returns>An index into m_arrCESatellites, or INDEX_NONE if there is no satellite over the country.</returns>
function int LWCE_GetSatellite(name nmSatCountry)
{
    local int iSatellite;

    for (iSatellite = 0; iSatellite < m_arrCESatellites.Length; iSatellite++)
    {
        if (m_arrCESatellites[iSatellite].nmCountry == nmSatCountry)
        {
            return iSatellite;
        }
    }

    return INDEX_NONE;
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

/// <summary>
/// Returns the continent which contains the player's starting country.
/// </summary>
function name LWCE_GetHomeContinent()
{
    return m_nmContinent;
}

function ECountry GetHomeCountry()
{
    `LWCE_LOG_DEPRECATED_CLS(GetHomeCountry);

    return ECountry(0);
}

/// <summary>
/// Returns the country which contains XCOM HQ, i.e. the player's starting country.
/// </summary>
function name LWCE_GetHomeCountry()
{
    return m_nmCountry;
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

function int HasBonus(EContinentBonus eBonus)
{
    `LWCE_LOG_DEPRECATED_BY(HasBonus, GetBonusLevel);

    return -100;
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

function bool IsHyperwaveActive()
{
    return LWCE_HasFacility('Facility_HyperwaveRadar') && m_bHyperwaveActivated;
}

function bool IsSatelliteInTransitTo(int iCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(IsSatelliteInTransitTo);

    return false;
}

function bool LWCE_IsSatelliteInTransitTo(name nmCountry)
{
    local int iSatellite;

    for (iSatellite = 0; iSatellite < m_arrCESatellites.Length; iSatellite++)
    {
        if (m_arrCESatellites[iSatellite].nmCountry == nmCountry && m_arrCESatellites[iSatellite].iTravelTime > 0)
        {
            return true;
        }
    }

    return false;
}

function OrderInterceptors(int iContinent, int iQuantity)
{
    `LWCE_LOG_DEPRECATED_CLS(OrderInterceptors);
}

/// <summary>
/// Places an order for new ships, paying the cost for them immediately.
/// </summary>
/// <param name="nmShipItem">The name of the item template corresponding to the ship to order, e.g. 'Item_Interceptor'.</param>
/// <param name="nmContinent">Which continent's hangar the ship will be in when it arrives.</param>
/// <param name="iQuantity">How many of this ship to order.</param>
function LWCE_OrderShips(name nmShipItem, name nmContinent, int iQuantity)
{
    local LWCE_TShipOrder kOrder;
    local int iCost;

    // TODO: this should include other components of the cost as well, for mods
    iCost = `LWCE_ITEM(nmShipItem).kCost.iCash;

    // LWCE issue #1: normally when you order interceptors, the strategy HUD (particularly the player's current money)
    // doesn't update until you back out to the main HQ screen. This fix simply updates the HUD immediately.
    AddResource(eResource_Money, -iCost * iQuantity);
    PRES().GetStrategyHUD().UpdateDefaultResources();

    kOrder.iNumShips = iQuantity;
    kOrder.nmDestinationContinent = nmContinent;
    kOrder.nmShipType = nmShipItem;
    kOrder.iHours = 72; // TODO make this part of the ship template?

    STAT_AddStat(eRecap_InterceptorsHired, iQuantity);
    m_arrCEShipOrders.AddItem(kOrder);
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

    if (iOrder < 0 || iOrder >= m_arrCEShipOrders.Length)
    {
        return;
    }

    iCost = `LWCE_ITEM('Item_Interceptor').kCost.iCash;

    // LWCE issue #1: same fix as in OrderInterceptors, above.
    AddResource(eResource_Money, iCost);
    PRES().GetStrategyHUD().UpdateDefaultResources();

    --m_arrCEShipOrders[iOrder].iNumShips;

    if (m_arrCEShipOrders[iOrder].iNumShips <= 0)
    {
        m_arrCEShipOrders.Remove(iOrder, 1);
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

function RemoveSatellite(int iCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(RemoveSatellite);
}

/// <summary>
/// Removes the satellite over the given country, if any.
/// </summary>
function LWCE_RemoveSatellite(name nmCountry)
{
    local LWCE_XGWorld kWorld;
    local int iSatellite;

    kWorld = LWCE_XGWorld(WORLD());

    for (iSatellite = 0; iSatellite < m_arrCESatellites.Length; iSatellite++)
    {
        if (m_arrCESatellites[iSatellite].nmCountry == nmCountry)
        {
            kWorld.LWCE_GetCountry(nmCountry).SetSatelliteCoverage(false);
            m_arrCESatellites[iSatellite].kSatEntity.SetBase(none);
            m_arrCESatellites[iSatellite].kSatEntity.SetHidden(true);
            m_arrCESatellites[iSatellite].kSatEntity.Destroy();
            m_arrCESatellites.Remove(iSatellite, 1);
            break; // In LW 1.0 this is a return but then we don't update graphics
        }
    }

    UpdateSatCoverageGraphics();
}

/// <summary>
/// Sets visibility for the Geoscape entity of the satellite over the given country.
/// </summary>
function SetSatelliteVisible(name nmCountry, bool bVisible)
{
    local int Index;

    Index = LWCE_GetSatellite(nmCountry);

    if (Index != INDEX_NONE)
    {
        m_arrCESatellites[Index].kSatEntity.SetHidden(!bVisible);
    }
}

function SetStartingData(name nmContinent, name nmCountry, name nmStartingBonus)
{
    m_nmContinent = nmContinent;
    m_nmCountry = nmCountry;
    m_nmStartingBonus = nmStartingBonus;

    // TODO make starting bonus level a configurable value
    AdjustBonusLevel(m_nmStartingBonus, COUNTRY_STARTING_BONUS_LEVEL_AMOUNT);

    LWCE_XGStorage(STORAGE()).LWCE_AddItem('Item_Satellite');
    LWCE_AddSatelliteNode(nmCountry, 'Item_Satellite', true);
}

function UpdateInterceptorOrders()
{
    local LWCEDataContainer kData;
    local LWCE_XGStorage kStorage;
    local array<int> aiRemove;
    local int iOrder, iOrderCount, iTransfer;
    local name nmContinent, nmShipType;

    kStorage = LWCE_XGStorage(STORAGE());

    for (iOrder = 0; iOrder < m_arrCEShipOrders.Length; iOrder++)
    {
        m_arrCEShipOrders[iOrder].iHours -= 1;

        if (m_arrCEShipOrders[iOrder].iHours <= 0)
        {
            aiRemove.AddItem(iOrder);

            for (iOrderCount = 0; iOrderCount < m_arrCEShipOrders[iOrder].iNumShips; iOrderCount++)
            {
                nmContinent = m_arrCEShipOrders[iOrder].nmDestinationContinent;
                nmShipType = m_arrCEShipOrders[iOrder].nmShipType;
                kStorage.LWCE_AddItem(nmShipType, 1, nmContinent);
            }

            kData = class'LWCEDataContainer'.static.New('NotifyData');
            kData.AddInt(m_arrCEShipOrders[iOrder].iNumShips);
            kData.AddName(m_arrCEShipOrders[iOrder].nmDestinationContinent);

            LWCE_XComHQPresentationLayer(PRES()).LWCE_Notify('ShipOrderComplete', kData);
        }
    }

    for (iOrder = aiRemove.Length - 1; iOrder >= 0; iOrder--)
    {
        m_arrCEShipOrders.Remove(aiRemove[iOrder], 1);
    }

    aiRemove.Remove(0, aiRemove.Length);

    for (iTransfer = 0; iTransfer < m_arrCEShipTransfers.Length; iTransfer++)
    {
        m_arrCEShipTransfers[iTransfer].iHours -= 1;

        if (m_arrCEShipTransfers[iTransfer].iHours > 0)
        {
        }
        else
        {
            aiRemove.AddItem(iTransfer);
        }
    }

    for (iOrder = aiRemove.Length - 1; iOrder >= 0; iOrder--)
    {
        m_arrCEShipTransfers.Remove(aiRemove[iOrder], 1);
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