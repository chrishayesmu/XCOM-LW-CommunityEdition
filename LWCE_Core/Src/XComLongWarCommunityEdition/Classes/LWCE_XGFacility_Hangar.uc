class LWCE_XGFacility_Hangar extends XGFacility_Hangar
    config(LWCEBaseStrategyGame);

struct LWCE_TContinentInfo
{
    var name nmContinent;
    var TText strContinentName;
    var int iNumShips;
    var array<LWCE_XGShip> arrShips;
    var array<int> m_arrShipOrderIndexes;
};

struct CheckpointRecord_LWCE_XGFacility_Hangar extends CheckpointRecord_XGFacility_Hangar
{
    var array<LWCE_XGShip> m_arrCEShips;
    var name m_nmCEBestWeaponEquipped;
};

var array<LWCE_XGShip> m_arrCEShips;
var name m_nmCEBestWeaponEquipped; // TODO: not being populated

var config bool bAutoNicknameNewPilots;
var config int iNumShipSlotsPerContinent;

// TODO migrate PilotNames to use an LWCENameListTemplate instead
var const localized array<string> PilotNames;
var const localized array<string> PilotRanks;

function Init(bool bLoadingFromSave)
{
    local int I;
    local LWCE_XGShip kShip;

    BaseInit();

    for (I = 1; I < 5; I++)
    {
        m_arrHangarOpen[I - 1]   = class'XComGlamManager'.static.SearchForMatinee("Base_Bay" $ I $ "_Open");
        m_arrHangarClosed[I - 1] = class'XComGlamManager'.static.SearchForMatinee("Base_Bay" $ I $ "_Closed");
        m_arrHangarRepair[I - 1] = class'XComGlamManager'.static.SearchForMatinee("Base_Bay" $ I $ "_Repair");
    }

    m_cinViewWeapons = class'XComGlamManager'.static.SearchForMatinee("Base_Bay1_ViewWeapons");

    foreach m_arrCEShips(kShip)
    {
        kShip.UpdateHangarShip();

        if (bLoadingFromSave)
        {
            kShip.InitWatchVariables();
        }
    }

    UpdateHangarBays();
}

function AddDropship()
{
    if (m_kSkyranger == none)
    {
        // TODO use templates
        m_kSkyranger = Spawn(class'LWCE_XGShip_Dropship');
        m_kSkyranger.Init(ITEMTREE().GetShip(eShip_Skyranger));
        m_kSkyranger.m_strCallsign = m_strCallsignSkyranger;
    }
}

function AddFirestorm(int iContinent)
{
    `LWCE_LOG_DEPRECATED_CLS(AddFirestorm);
}

function LWCE_AddFirestorm(name nmContinent)
{
    local int iInterceptorIndex, I;
    local LWCE_XGShip kFirestorm;

    iInterceptorIndex = INDEX_NONE;
    kFirestorm = none;

    // TODO delete this and use LWCE_AddShip

    // Find the interceptor pilot with the most kills
    for (I = 0; I < m_arrCEShips.Length; I++)
    {
        if (m_arrCEShips[I] != none && !m_arrCEShips[I].IsType('Firestorm'))
        {
            if (iInterceptorIndex == INDEX_NONE || m_arrCEShips[I].m_iConfirmedKills > m_arrCEShips[iInterceptorIndex].m_iConfirmedKills)
            {
                iInterceptorIndex = I;
            }
        }
    }

    kFirestorm = Spawn(class'LWCE_XGShip');
    kFirestorm.m_iHomeBay = GetAvailableBay(); // TODO this isn't looking at continent yet
    kFirestorm.m_nmContinent = LWCE_XGHeadquarters(HQ()).LWCE_GetContinent();
    kFirestorm.LWCE_Init('Firestorm', nmContinent, class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM);
    m_iFirestormCounter += 1;

    if (iInterceptorIndex >= 0)
    {
        // Swap callsign and kill count with the chosen interceptor (aka swap pilots)
        kFirestorm.m_strCallsign = m_arrCEShips[iInterceptorIndex].m_strCallsign;
        kFirestorm.m_iConfirmedKills = m_arrCEShips[iInterceptorIndex].m_iConfirmedKills;
        m_iInterceptorCounter += 1;

        if (bAutoNicknameNewPilots)
        {
            AssignRandomCallsign(m_arrCEShips[iInterceptorIndex]);
        }
        else
        {
            m_arrCEShips[iInterceptorIndex].m_strCallsign = m_strCallsignInterceptor $ "-" $ string(m_iInterceptorCounter);
            m_arrCEShips[iInterceptorIndex].m_iConfirmedKills = 0;
        }
    }
    else
    {
        if (bAutoNicknameNewPilots)
        {
            AssignRandomCallsign(kFirestorm);
        }
        else
        {
            kFirestorm.m_strCallsign = m_strCallsignFireStorm $ "-" $ string(m_iFirestormCounter);
        }
    }

    m_arrCEShips.AddItem(kFirestorm);

    ReorderCraft();
    kFirestorm.UpdateHangarShip();
    UpdateHangarBays();
    GEOSCAPE().World().m_kFundingCouncil.OnShipAdded(eShip_Firestorm, HQ().GetContinent());
}

function AddInterceptor(int iContinent)
{
    `LWCE_LOG("ERROR: LWCE-incompatible function AddInterceptor was called. This needs to be replaced with LWCE_AddShip. Stack trace follows.");
    ScriptTrace();
}

function LWCE_AddShip(name nmShipType, name nmContinent)
{
    local LWCE_XGFundingCouncil kFundingCouncil;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGShip kShip;

    kHQ = LWCE_XGHeadquarters(HQ());

    if (nmContinent == '')
    {
        nmContinent = kHQ.LWCE_GetContinent();
    }

    kShip = Spawn(class'LWCE_XGShip');

    if (nmContinent == kHQ.LWCE_GetContinent())
    {
        // TODO integrate this with continent
        kShip.m_iHomeBay = GetAvailableBay();
    }

    kShip.LWCE_Init(nmShipType, nmContinent, class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM);

    m_iInterceptorCounter += 1;
    kShip.m_strCallsign = m_strCallsignInterceptor $ "-" $ string(m_iInterceptorCounter);

    m_arrCEShips.AddItem(kShip);

    if (bAutoNicknameNewPilots)
    {
        AssignRandomCallsign(kShip);
    }

    ReorderCraft();
    kShip.UpdateHangarShip();
    UpdateHangarBays();

    kFundingCouncil = LWCE_XGFundingCouncil(GEOSCAPE().World().m_kFundingCouncil);

    // The funding council may be none at the very start of the campaign, while the world is being set up. That's okay
    // since there won't be any council requests to fulfill anyway, so just skip the call in that case.
    if (kFundingCouncil != none)
    {
        kFundingCouncil.LWCE_OnShipAdded(kShip);
    }
}

function AssignRandomCallsign(LWCE_XGShip kShip)
{
    kShip.SetCallsign(PilotNames[Rand(PilotNames.Length)]);
}

function bool CanEquip(int iItem, XGShip_Interceptor kShip, out string strHelp)
{
    `LWCE_LOG_DEPRECATED_CLS(CanEquip);

    return false;
}

function bool LWCE_CanEquip(name ItemName, LWCE_XGShip kShip, out string strHelp)
{
    local LWCEShipWeaponTemplate kShipWeapon;

    if (kShip.GetWeaponAtIndex(0) == ItemName)
    {
        strHelp = m_strCanEquipMessage;
        return false;
    }

    kShipWeapon = LWCEShipWeaponTemplate(`LWCE_ITEM(ItemName));

    if (!kShipWeapon.bCanEquipOnFirestorm && kShip.IsType('Firestorm'))
    {
        strHelp = m_sUnavailable;
        return false;
    }

    if (!kShipWeapon.bCanEquipOnInterceptor && kShip.IsType('Interceptor'))
    {
        strHelp = m_sUnavailable;
        return false;
    }

    return true;
}

function DetermineInterceptorStatus(XGShip_Interceptor kInterceptor)
{
    kInterceptor.m_iStatus = eShipStatus_Ready;

    if (kInterceptor.GetFuelPct() < 1.0f)
    {
        kInterceptor.m_iStatus = eShipStatus_Refuelling;
        kInterceptor.m_iHoursDown = 1;
    }

    if (kInterceptor.IsDamaged())
    {
        kInterceptor.m_iStatus = eShipStatus_Repairing;
        kInterceptor.m_iHoursDown = Max(1, int(float(class'XGTacticalGameCore'.default.INTERCEPTOR_REPAIR_HOURS) * (1.0f - kInterceptor.GetHPPct())));

        if (IsOptionEnabled(`LW_SECOND_WAVE_ID(DynamicWar)))
        {
            kInterceptor.m_iHoursDown /= class'XGTacticalGameCore'.default.SW_MARATHON;
        }

        if (LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_AdvancedRepair'))
        {
            kInterceptor.m_iHoursDown *= 0.670;
        }
    }
}

function EquipWeapon(EItemType eItem, XGShip_Interceptor kShip)
{
    `LWCE_LOG_DEPRECATED_CLS(EquipWeapon);
}

function LWCE_EquipWeapon(name ItemName, LWCE_XGShip kShip)
{
    local LWCEShipWeaponTemplate kTemplate;

    kTemplate = `LWCE_SHIP_WEAPON(ItemName);

    LWCE_XGStorage(STORAGE()).LWCE_RemoveItem(ItemName, 1);
    Sound().PlaySFX(SNDLIB().SFX_Facility_ConstructItem);
    kShip.LWCE_EquipWeapon(ItemName, 0);

    if (kShip.IsType('Firestorm'))
    {
        kShip.m_iHoursDown = kTemplate.iFirestormArmingTimeHours;
    }
    else
    {
        kShip.m_iHoursDown = kTemplate.iInterceptorArmingTimeHours;
    }

    if (kShip.m_iHoursDown > 0)
    {
        kShip.m_iStatus = eShipStatus_Rearming;
    }

/* TODO implement an analogue for this? it's only used to play one narrative
    if (ItemName > m_iCEBestWeaponEquipped)
    {
        m_iCEBestWeaponEquipped = ItemName;
    }
*/
}

function array<XGShip_Interceptor> GetAllInterceptors()
{
    local array<XGShip_Interceptor> arrInts;

    `LWCE_LOG_DEPRECATED_BY(GetAllInterceptors, LWCE_GetAllShips);

    arrInts.Length = 0;
    return arrInts;
}

function array<LWCE_XGShip> LWCE_GetAllShips()
{
    return m_arrCEShips;
}

function TContinentInfo GetContinentInfo(EContinent eCont)
{
    local TContinentInfo kInfo;

    `LWCE_LOG_DEPRECATED_CLS(GetContinentInfo);

    return kInfo;
}

function LWCE_TContinentInfo LWCE_GetContinentInfo(name nmContinent)
{
    local LWCE_XGContinent kContinent;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_TContinentInfo kInfo;
    local LWCE_TItemProject kProject;
    local int iOrder;

    kContinent = `LWCE_XGCONTINENT(nmContinent);
    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kHQ = LWCE_XGHeadquarters(HQ());

    kInfo.nmContinent = nmContinent;
    kInfo.strContinentName.StrValue = kContinent.GetName();
    kInfo.arrShips = LWCE_GetShipsByContinent(nmContinent);
    kInfo.iNumShips = kInfo.arrShips.Length;

    for (iOrder = 0; iOrder < kHQ.m_arrCEShipOrders.Length; iOrder++)
    {
        if (kHQ.m_arrCEShipOrders[iOrder].nmDestinationContinent == nmContinent)
        {
            kInfo.m_arrShipOrderIndexes.AddItem(iOrder);
            kInfo.iNumShips += kHQ.m_arrCEShipOrders[iOrder].iNumShips;
        }
    }

    // For the home continent, check for any Firestorms being built
    if (nmContinent == kHQ.LWCE_GetContinent())
    {
        foreach kEngineering.m_arrCEItemProjects(kProject)
        {
            if (kProject.ItemName == 'Item_Firestorm')
            {
                kInfo.iNumShips += kProject.iQuantity;
            }
        }
    }

    return kInfo;
}

function int GetFreeHangerSpots(int iContinent)
{
    `LWCE_LOG_DEPRECATED_BY(GetFreeHangerSpots, LWCE_GetFreeHangarSpots);

    return -1000;
}

/// <summary>
/// Determines how many hangar spots are unoccupied on the given continent.
/// </summary>
function int LWCE_GetFreeHangarSpots(name nmContinent)
{
    return default.iNumShipSlotsPerContinent - LWCE_GetContinentInfo(nmContinent).iNumShips;
}

function array<XGShip_Interceptor> GetInterceptorsByContinent(int iContinent)
{
    local array<XGShip_Interceptor> arrInterceptors;

    arrInterceptors.Length = 0;

    `LWCE_LOG_DEPRECATED_BY(GetInterceptorsByContinent, LWCE_GetShipsByContinent);

    return arrInterceptors;
}

function int GetNumInterceptors(int iContinent)
{
    `LWCE_LOG_DEPRECATED_BY(GetNumInterceptors, LWCE_GetNumShips);

    return -1000;
}

/// <summary>
/// Returns how many ships are assigned to the given continent.
/// </summary>
function int LWCE_GetNumShips(name nmContinent)
{
    local LWCE_XGShip kShip;
    local int iNumShips;

    foreach m_arrCEShips(kShip)
    {
        if (kShip.m_nmContinent == nmContinent)
        {
            iNumShips++;
        }
    }

    return iNumShips;
}

function int GetNumInterceptorsInRange(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_BY(GetNumInterceptorsInRange, LWCE_GetNumShipsInRange);

    return -1000;
}

/// <summary>
/// Finds all of the friendly ships which are in the same continent as the enemy ship.
/// </summary>
function int LWCE_GetNumShipsInRange(LWCE_XGShip kShip)
{
    return LWCE_GetNumShips(kShip.GetContinent());
}

function int GetNumInterceptorsInRangeAndAvailable(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_BY(GetNumInterceptorsInRangeAndAvailable, LWCE_GetNumShipsInRangeAndAvailable);

    return -1000;
}

/// <summary>
/// Returns how many ships are in range of the given enemy ship, and are also able to engage it.
/// By default, "in range" means they're on the same continent, and "able to engage" means the
/// friendly ship is undamaged and not mid-transfer (i.e. it is in eShipStatus_Ready).
/// </summary>
function int LWCE_GetNumShipsInRangeAndAvailable(LWCE_XGShip kShip)
{
    local int iIndex, iAvailable;

    for (iIndex = 0; iIndex < m_arrCEShips.Length; iIndex++)
    {
        if (m_arrCEShips[iIndex].m_nmContinent == kShip.GetContinent())
        {
            if (m_arrCEShips[iIndex].GetStatus() == eShipStatus_Ready)
            {
                iAvailable++;
            }
        }
    }

    return iAvailable;
}

function int GetTotalInterceptorCapacity(optional int kContinent = 5)
{
    `LWCE_LOG_DEPRECATED_BY(GetTotalInterceptorCapacity, LWCE_GetNumHangarSlotsForContinent);

    return -1000;
}

/// <summary>
/// Determines how many hangar slots exist for the given continent. By default this is the same
/// for every continent, but this gives us a space to add a mod hook if needed.
/// </summary>
function int LWCE_GetNumHangarSlotsForContinent(name nmContinent)
{
    return default.iNumShipSlotsPerContinent;
}

/// <summary>
/// Calculates the total maintenance cost across all ships owned by XCOM, including the Skyranger.
/// </summary>
function int GetShipMaintenanceCost()
{
    local LWCE_XGShip kShip;
    local int iOverhead;

    iOverhead = 0;

    foreach m_arrCEShips(kShip)
    {
        iOverhead += kShip.m_kTemplate.GetMaintenanceCost(class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM);
    }

    iOverhead += LWCE_XGShip_Dropship(m_kSkyranger).m_kTemplate.GetMaintenanceCost(class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM);

    return iOverhead;
}

function int GetCraftMaintenanceCost(EShipType eShip)
{
    `LWCE_LOG_DEPRECATED_BY(GetCraftMaintenanceCost, LWCEShipTemplate.GetMaintenanceCost);

    return 1000;
}

/// <summary>
/// Gets all of the friendly ships which are stationed on the given continent.
/// </summary>
function array<LWCE_XGShip> LWCE_GetShipsByContinent(name nmContinent)
{
    local array<LWCE_XGShip> arrShips;
    local LWCE_XGShip kShip;

    foreach m_arrCEShips(kShip)
    {
        if (kShip.GetHomeContinent() == nmContinent)
        {
            arrShips.AddItem(kShip);
        }
    }

    return arrShips;
}

function string GetRankForKills(int iKills)
{
    local int Index;

    Index = Clamp(iKills, 0, PilotRanks.Length - 1);

    while (Index >= 0)
    {
        if (PilotRanks[Index] != "")
        {
            return PilotRanks[Index];
        }

        Index--;
    }

    return "";
}

function array<TItem> GetUpgrades(XGShip_Interceptor kShip)
{
    local array<TItem> arrItems;
    arrItems.Add(0);

    `LWCE_LOG_DEPRECATED_CLS(GetUpgrades);

    return arrItems;
}

function array<LWCEShipWeaponTemplate> LWCE_GetUpgrades()
{
    local LWCE_XGStorage kStorage;
    local array<LWCEShipWeaponTemplate> arrItems, arrTemplates;
    local LWCEItemTemplateManager kItemMgr;
    local LWCEShipWeaponTemplate kShipWeapon;

    kItemMgr = `LWCE_ITEM_TEMPLATE_MGR;
    kStorage = LWCE_XGStorage(STORAGE());

    arrTemplates = kItemMgr.GetAllShipWeaponTemplates();

    foreach arrTemplates(kShipWeapon)
    {
        if (kStorage.LWCE_GetNumItemsAvailable(kShipWeapon.GetItemName()) > 0)
        {
            arrItems.AddItem(kShipWeapon);
        }
    }

    return arrItems;
}

function GiveMissionReward(XGShip_Dropship kSkyranger)
{
    if (kSkyranger.CargoInfo.m_kReward.iScientists > 0)
    {
        AddResource(eResource_Scientists, kSkyranger.CargoInfo.m_kReward.iScientists);
    }

    if (kSkyranger.CargoInfo.m_kReward.iEngineers > 0)
    {
        AddResource(eResource_Engineers, kSkyranger.CargoInfo.m_kReward.iEngineers);
    }

    if (kSkyranger.CargoInfo.m_kReward.iCredits > 0)
    {
        AddResource(eResource_Money, kSkyranger.CargoInfo.m_kReward.iCredits);
    }
}

/// <summary>
/// Checks if the given hangar bay is available. This refers to the bays in XCOM HQ which are used for displaying ships;
/// it has nothing to do with how the ships themselves are stored on each continent.
/// </summary>
function bool IsBayAvailable(int iBay)
{
    local LWCE_XGShip kShip;
    local name nmHQContinent;

    nmHQContinent = LWCE_XGHeadquarters(HQ()).LWCE_GetContinent();

    foreach m_arrCEShips(kShip)
    {
        if (kShip.m_nmContinent != nmHQContinent)
        {
            continue;
        }

        if (kShip.m_iHomeBay == iBay)
        {
            return false;
        }
    }

    return true;
}

function bool IsShipInTransitTo(int iContinent)
{
    `LWCE_LOG_DEPRECATED_CLS(IsShipInTransitTo);

    return false;
}

function bool LWCE_IsShipInTransitTo(name nmContinent)
{
    local int iIndex;

    for (iIndex = 0; iIndex < m_arrCEShips.Length; iIndex++)
    {
        if (m_arrCEShips[iIndex].m_nmContinent == nmContinent)
        {
            if (m_arrCEShips[iIndex].GetStatus() == eShipStatus_Transfer)
            {
                return true;
            }
        }
    }

    return false;
}

static function EShipWeapon ItemTypeToShipWeapon(EItemType eItem)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(ItemTypeToShipWeapon);
    return 0;
}

function LandDropship(XGShip_Dropship kSkyranger)
{
    local LWCE_XGFacility_Labs kLabs;
    local array<LWCE_TTechState> arrPreLandTechs, arrPostLandTechs;
    local TMissionReward kEmptyReward;

    kLabs = `LWCE_LABS;

    arrPreLandTechs = kLabs.LWCE_GetCurrentTechStates();
    UnloadArtifacts(kSkyranger);

    if (kSkyranger.CargoInfo.m_iBattleResult == eResult_Victory)
    {
        if (RewardIsValid(kSkyranger.CargoInfo.m_kReward))
        {
            GiveMissionReward(kSkyranger);
            HQ().m_kLastReward = kSkyranger.CargoInfo.m_kReward;
        }
    }

    arrPostLandTechs = kLabs.LWCE_GetCurrentTechStates();
    kLabs.LWCE_CompilePostMissionReport(arrPreLandTechs, arrPostLandTechs);

    BARRACKS().LandSoldiers(kSkyranger);
    kSkyranger.CargoInfo.m_kReward = kEmptyReward; // TODO: need to convert to LWCE_TMissionReward
    GEOSCAPE().Resume();
}

function OnInterceptorDestroyed(XGShip_Interceptor kInterceptor)
{
    `LWCE_LOG_DEPRECATED_BY(OnInterceptorDestroyed, LWCE_OnShipDestroyed);
}

function LWCE_OnShipDestroyed(LWCE_XGShip kShip)
{
    m_iJetsLost += 1;
    m_bNarrLostJet = true;
    LWCE_RemoveShip(kShip);
    GEOSCAPE().ResetShipTimeScale();
    STAT_AddStat(eRecap_InterceptorsLost, 1);
}

function bool OrderedHigher(XGShip_Interceptor kCraft1, XGShip_Interceptor kCraft2)
{
    // Same as the base OrderedHigher but without GetWeapon calls since our items are unordered

    if (kCraft1.m_iHomeContinent == HQ().m_iContinent && kCraft2.m_iHomeContinent != HQ().m_iContinent)
    {
        return true;
    }
    else if (kCraft2.m_iHomeContinent == HQ().m_iContinent && kCraft1.m_iHomeContinent != HQ().m_iContinent)
    {
        return false;
    }
    else if (kCraft1.m_iHomeContinent < kCraft2.m_iHomeContinent)
    {
        return true;
    }
    else if (kCraft2.m_iHomeContinent < kCraft1.m_iHomeContinent)
    {
        return false;
    }

    if (!kCraft1.IsDamaged() && kCraft2.IsDamaged())
    {
        return true;
    }
    else if (!kCraft2.IsDamaged() && kCraft1.IsDamaged())
    {
        return false;
    }

    if (kCraft1.m_iStatus != 2 && kCraft2.m_iStatus == 2)
    {
        return true;
    }
    else if (kCraft2.m_iStatus != 2 && kCraft1.m_iStatus == 2)
    {
        return false;
    }

    if (kCraft1.IsFirestorm() && !kCraft2.IsFirestorm())
    {
        return true;
    }
    else if (!kCraft1.IsFirestorm() && kCraft2.IsFirestorm())
    {
        return false;
    }

    return false;
}

function RemoveInterceptor(XGShip_Interceptor kInt)
{
    `LWCE_LOG_DEPRECATED_BY(RemoveInterceptor, LWCE_RemoveShip);
}

function LWCE_RemoveShip(LWCE_XGShip kShip)
{
    local LWCE_XGStorage kStorage;
    local name nmWeapon;

    kStorage = LWCE_XGStorage(STORAGE());

    m_arrCEShips.RemoveItem(kShip);

    if (kShip.m_iHP > 0)
    {
        foreach kShip.m_arrCEWeapons(nmWeapon)
        {
            kStorage.LWCE_AddItem(nmWeapon);
        }
    }

    if (kShip.m_kEntity != none)
    {
        kShip.HideEntity(true);
        kShip.m_kEntity.Destroy();
    }

    kShip.DestroyHangarShip();
    kShip.Destroy();

    ReorderCraft();
    UpdateHangarBays();
}

/// <summary>
/// Sets up the ship models in the XCOM HQ hangars so that they're ready to be used by Kismet.
/// </summary>
function SetHangarShipsForKismet()
{
    local name nmHQContinent;
    local LWCE_XGShip kShip;
    local array<XGHangarShip> arrBayInterceptors;
    local array<SequenceObject> arrEvents;
    local SequenceObject kEvent;
    local SeqEvent_ShipToKismet kShipEvent;

    arrBayInterceptors.Length = 4;
    nmHQContinent = LWCE_XGHeadquarters(HQ()).LWCE_GetContinent();

    foreach m_arrCEShips(kShip)
    {
        if (kShip.m_nmContinent == nmHQContinent && kShip.m_iHomeBay >= 0 && kShip.m_iHomeBay < arrBayInterceptors.Length)
        {
            arrBayInterceptors[kShip.m_iHomeBay] = kShip.GetHangarShip();
        }
    }

    WorldInfo.GetGameSequence().FindSeqObjectsByClass(class'SeqEvent_ShipToKismet', true, arrEvents);

    foreach arrEvents(kEvent)
    {
        kShipEvent = SeqEvent_ShipToKismet(kEvent);

        kShipEvent.Firestorm1 = (arrBayInterceptors[0] != none && arrBayInterceptors[0].IsA('XGHangarShip_Firestorm')) ? arrBayInterceptors[0] : none;
        kShipEvent.Ship1 = kShipEvent.Firestorm1 == none ? arrBayInterceptors[0] : none;

        kShipEvent.Firestorm2 = (arrBayInterceptors[1] != none && arrBayInterceptors[1].IsA('XGHangarShip_Firestorm')) ? arrBayInterceptors[1] : none;
        kShipEvent.Ship2 = kShipEvent.Firestorm2 == none ? arrBayInterceptors[1] : none;

        kShipEvent.Firestorm3 = (arrBayInterceptors[2] != none && arrBayInterceptors[2].IsA('XGHangarShip_Firestorm')) ? arrBayInterceptors[2] : none;
        kShipEvent.Ship3 = kShipEvent.Firestorm3 == none ? arrBayInterceptors[2] : none;

        kShipEvent.Firestorm4 = (arrBayInterceptors[3] != none && arrBayInterceptors[3].IsA('XGHangarShip_Firestorm')) ? arrBayInterceptors[3] : none;
        kShipEvent.Ship4 = kShipEvent.Firestorm4 == none ? arrBayInterceptors[3] : none;

        kShipEvent.PopulateLinkedVariableValues();
        SeqEvent_ShipToKismet(kEvent).CheckActivate(self, self);
    }
}

function EItemType ShipTypeToItemType(EShipType eShip)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(ShipTypeToItemType);

    return eItem_None;
}

function UnloadArtifacts(XGShip_Dropship kSkyranger)
{
    local int Index, iNumArtifacts;
    local name ItemName;
    local LWCEItemTemplate kItem;
    local LWCE_XGDropshipCargoInfo kCargo;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGStorage kStorage;

    kCargo = LWCE_XGDropshipCargoInfo(kSkyranger.CargoInfo);
    kEngineering = LWCE_XGFacility_Engineering(ENGINEERING());
    kHQ = `LWCE_HQ;
    kStorage = LWCE_XGStorage(STORAGE());

    kHQ.m_kCELastCargoArtifacts = Spawn(class'LWCEItemContainer');
    kHQ.m_kCELastCargoArtifacts.CopyFrom(kCargo.m_kArtifactsContainer);

    `LWCE_LOG_CLS("Unloading artifacts from dropship: there are " $ kCargo.m_kArtifactsContainer.m_arrEntries.Length $ " entries to process");

    for (Index = 0; Index < kCargo.m_kArtifactsContainer.m_arrEntries.Length; Index++)
    {
        ItemName = kCargo.m_kArtifactsContainer.m_arrEntries[Index].ItemName;
        iNumArtifacts = kCargo.m_kArtifactsContainer.m_arrEntries[Index].iQuantity;
        kItem = `LWCE_ITEM(ItemName);

        if (iNumArtifacts > 0)
        {
            if (kItem.IsCaptive())
            {
                if (!kHQ.LWCE_HasFacility('Facility_AlienContainment'))
                {
                    // Delete the captive from the cargo report
                    kHQ.m_kCELastCargoArtifacts.Delete(ItemName);
                    ItemName = kItem.nmCaptiveToCorpseId;
                    LABS().m_bCaptiveDied = true;

                    // Add captive's corpse to cargo
                    kHQ.m_kCELastCargoArtifacts.AdjustQuantity(ItemName, iNumArtifacts);
                }
                else
                {
                    kHQ.m_arrCELastCaptives.AddItem(ItemName);

                    if (!kStorage.LWCE_EverHadItem(ItemName))
                    {
                        STAT_AddStat(eRecap_DifferentAliensCaptured, 1);
                    }

                    // TODO: figure out if and why we need to start containment from the hangar rather than labs
                    // if (ItemName >= 0 && ItemName <= 255)
                    // {
                    //     Base().BeginAlienContainment(EItemType(ItemName));
                    // }
                }

                SITROOM().PushNarrativeHeadline(eTickerNarrative_AlienCaptured);
                kStorage.LWCE_AddItem(ItemName, iNumArtifacts);
            }
            else if (ItemName == 'Item_Elerium')
            {
                if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AlienNucleonics'))
                {
                    iNumArtifacts *= 1.20;
                }

                AddResource(eResource_Elerium, iNumArtifacts);
            }
            else if (ItemName == 'Item_AlienAlloy')
            {
                if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_AlienMetallurgy'))
                {
                    iNumArtifacts *= 1.20;
                }

                AddResource(eResource_Alloys, iNumArtifacts);
            }
            else
            {
                if (ItemName == 'Item_WeaponFragment')
                {
                    if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedSalvage'))
                    {
                        iNumArtifacts *= 1.20;
                    }
                }

                kStorage.LWCE_AddItem(ItemName, iNumArtifacts);
            }
        }
    }

    kCargo.m_kArtifactsContainer.Clear();
}

/// <summary>
/// Updates the hangar bays in XCOM HQ to display ships in their current status (ready vs repairing).
/// </summary>
function UpdateHangarBays()
{
    local int I;
    local name nmHQContinent;
    local bool bFound;
    local LWCE_XGShip kShip;
    local SeqAct_Interp kSeqAct, kDisable1, kDisable2;

    SetHangarShipsForKismet();
    nmHQContinent = LWCE_XGHeadquarters(HQ()).LWCE_GetContinent();

    // Bound of 4 here is presumably because EW had 4 ships per continent and that's how many the base map can handle
    for (I = 0; I < 4; I++)
    {
        bFound = false;

        foreach m_arrCEShips(kShip)
        {
            if (kShip.m_nmContinent == nmHQContinent && kShip.m_iHomeBay == I)
            {
                if (kShip.m_iStatus == eShipStatus_Ready)
                {
                    kSeqAct = m_arrHangarOpen[I];
                    kDisable1 = m_arrHangarRepair[I];
                    kDisable2 = m_arrHangarClosed[I];
                }
                else
                {
                    kSeqAct = m_arrHangarRepair[I];
                    kDisable1 = m_arrHangarClosed[I];
                    kDisable2 = m_arrHangarOpen[I];
                }

                bFound = true;
                break;
            }
        }

        if (!bFound)
        {
            kSeqAct = m_arrHangarClosed[I];
            kDisable1 = m_arrHangarOpen[I];
            kDisable2 = m_arrHangarRepair[I];
        }

        kDisable1.Reset();
        kDisable2.Reset();
        kSeqAct.Reset();
        kSeqAct.ForceActivateInput(0);
    }
}

function UpdateWeaponView(EShipWeapon eWeapon)
{
    `LWCE_LOG_DEPRECATED_CLS(UpdateWeaponView);
}

function LWCE_UpdateWeaponView(name ShipWeaponName)
{
    // TODO: move somewhere centralized and potentially make extensible
    if (LWCE_XGHangarShip_Firestorm(m_kViewWeaponsShip) != none)
    {
        LWCE_XGHangarShip_Firestorm(m_kViewWeaponsShip).LWCE_UpdateWeapon(ShipWeaponName);
    }
    else
    {
        LWCE_XGHangarShip(m_kViewWeaponsShip).LWCE_UpdateWeapon(ShipWeaponName);
    }
}