class LWCE_XGGeoscape extends XGGeoscape
    dependson(LWCETypes);

struct LWCE_TGeoscapeAlert
{
    var name AlertType;
    var LWCEDataContainer kData;
};

struct CheckpointRecord_LWCE_XGGeoscape extends XGGeoscape.CheckpointRecord
{
    var array<name> m_arrCEShipEncounters;
    var array<LWCE_TGeoscapeAlert> m_arrCEAlerts;
};

var array<name> m_arrCEShipEncounters;
var array<LWCE_TGeoscapeAlert> m_arrCEAlerts;

static function name AlertNameFromEnum(EGeoscapeAlert eAlert)
{
    switch (eAlert)
    {
        case eGA_UFODetected:
            return 'EnemyShipDetected';
        case eGA_Abduction:
            return 'Abduction';
        case eGA_Terror:
            return 'Terror';
        case eGA_FCMission:
            return 'FCMission';
        case eGA_UFOCrash:
            return 'UFOCrash';
        case eGA_UFOLost:
            return 'UFOLost';
        case eGA_UFOLanded:
            return 'UFOLanded';
        case eGA_DropArrive:
            return 'DropArrive';
        case eGA_AlienBase:
            return 'AlienBase';
        case eGA_Temple:
            return 'TempleShip';
        case eGA_MissedAliens:
            return 'MissedAliens';
        case eGA_SecretPact:
            return 'CountryLost';
        case eGA_UFOScanning:
            return 'UFOScanning';
        case eGA_HQAssault:
            return 'HQAssault';
        case eGA_NewSoldiers:
            return 'NewSoldiers';
        case eGA_SoldierHealed:
            return 'SoldierHealed';
        case eGA_NewEngineers:
            return 'NewEngineers';
        case eGA_NewScientists:
            return 'NewScientists';
        case eGA_NewInterceptors:
            return 'ShipOrderComplete';
        case eGA_NewItemsReceived:
            return 'NewItemsReceived';
        case eGA_NewItemBuilt:
            return 'NewItemBuilt';
        case eGA_NewFacilityBuilt:
            return 'NewFacilityBuilt';
        case eGA_ExcavationComplete:
            return 'ExcavationComplete';
        case eGA_FacilityRemoved:
            return 'FacilityRemoved';
        case 24:
            return 'CountryRejoinedXCom';
        case eGA_ItemProjectCompleted:
            return 'ItemProjectCompleted';
        case eGA_FoundryProjectCompleted:
            return 'FoundryProjectCompleted';
        case eGA_WorkshopRebate:
            return 'WorkshopRebate';
        case eGA_ResearchCompleted:
            return 'ResearchCompleted';
        case eGA_PsiTraining:
            return 'PsiTraining';
        case eGA_ShipTransferred:
            return 'ShipTransferred';
        case eGA_ShipArmed:
            return 'ShipArmed';
        case eGA_ShipOnline:
            return 'ShipOnline';
        case eGA_SatelliteOnline:
            return 'SatelliteOnline';
        case eGA_CountryPanic:
            return 'CountryPanic';
        case eGA_SatelliteDestroyed:
            return 'SatelliteDestroyed';
        case eGA_FCActivity:
            return 'FCActivity';
        case eGA_ModalNotify:
            return 'ModalNotify';
        case eGA_PayDay:
            return 'PayDay';
        case eGA_FCJetTransfer:
            return 'FCJetTransfer';
        case eGA_FCExpiredRequest:
            return 'FCExpiredRequest';
        case eGA_FCDelayedRequest:
            return 'FCNewRequest';
        case eGA_FCSatCountry:
            return 'FCSatCountry';
        case eGA_FCMissionActivity:
            return 'FCMissionActivity';
        case eGA_ExaltMissionActivity:
            return 'ExaltMissionActivity';
        case eGA_ExaltAlert:
            return 'ExaltAlert';
        case eGA_ExaltResearchHack:
            return 'ExaltResearchHack';
        case eGA_CellHides:
            return 'ExaltCellHides';
        case eGA_GeneMod:
            return 'GeneModComplete';
        case eGA_Augmentation:
            return 'Augmentation';
        case eGA_ExaltRaidFailCountry:
            return 'ExaltRaidFailCountry';
        case eGA_ExaltRaidFailContinent:
            return 'ExaltRaidFailContinent';
        case 53:
            return 'AirBaseDefenseFailed';
        case 54:
            return 'ItemRepairsComplete';
    }
}

static function EGeoscapeAlert EnumFromAlertName(name AlertType)
{
    switch (AlertType)
    {
        case 'EnemyShipDetected':
            return eGA_UFODetected;
        case 'Abduction':
            return eGA_Abduction;
        case 'Terror':
            return eGA_Terror;
        case 'FCMission':
            return eGA_FCMission;
        case 'UFOCrash':
            return eGA_UFOCrash;
        case 'UFOLost':
            return eGA_UFOLost;
        case 'UFOLanded':
            return eGA_UFOLanded;
        case 'DropArrive':
            return eGA_DropArrive;
        case 'AlienBase':
            return eGA_AlienBase;
        case 'TempleShip':
            return eGA_Temple;
        case 'MissedAliens':
            return eGA_MissedAliens;
        case 'CountryLost':
            return eGA_SecretPact;
        case 'UFOScanning':
            return eGA_UFOScanning;
        case 'HQAssault':
            return eGA_HQAssault;
        case 'NewSoldiers':
            return eGA_NewSoldiers;
        case 'SoldierHealed':
            return eGA_SoldierHealed;
        case 'NewEngineers':
            return eGA_NewEngineers;
        case 'NewScientists':
            return eGA_NewScientists;
        case 'NewInterceptors':
            return eGA_NewInterceptors;
        case 'NewItemsReceived':
            return eGA_NewItemsReceived;
        case 'NewItemBuilt':
            return eGA_NewItemBuilt;
        case 'NewFacilityBuilt':
            return eGA_NewFacilityBuilt;
        case 'ExcavationComplete':
            return eGA_ExcavationComplete;
        case 'FacilityRemoved':
            return eGA_FacilityRemoved;
        case 'CountryRejoinedXCom':
            return EGeoscapeAlert(24);
        case 'ItemProjectCompleted':
            return eGA_ItemProjectCompleted;
        case 'FoundryProjectCompleted':
            return eGA_FoundryProjectCompleted;
        case 'WorkshopRebate':
            return eGA_WorkshopRebate;
        case 'ResearchCompleted':
            return eGA_ResearchCompleted;
        case 'PsiTraining':
            return eGA_PsiTraining;
        case 'ShipTransferred':
            return eGA_ShipTransferred;
        case 'ShipArmed':
            return eGA_ShipArmed;
        case 'ShipOnline':
            return eGA_ShipOnline;
        case 'SatelliteOnline':
            return eGA_SatelliteOnline;
        case 'CountryPanic':
            return eGA_CountryPanic;
        case 'SatelliteDestroyed':
            return eGA_SatelliteDestroyed;
        case 'FCActivity':
            return eGA_FCActivity;
        case 'ModalNotify':
            return eGA_ModalNotify;
        case 'PayDay':
            return eGA_PayDay;
        case 'FCJetTransfer':
            return eGA_FCJetTransfer;
        case 'FCExpiredRequest':
            return eGA_FCExpiredRequest;
        case 'FCNewRequest':
            return eGA_FCDelayedRequest;
        case 'FCSatCountry':
            return eGA_FCSatCountry;
        case 'FCMissionActivity':
            return eGA_FCMissionActivity;
        case 'ExaltMissionActivity':
            return eGA_ExaltMissionActivity;
        case 'ExaltAlert':
            return eGA_ExaltAlert;
        case 'ExaltResearchHack':
            return eGA_ExaltResearchHack;
        case 'ExaltCellHides':
            return eGA_CellHides;
        case 'GeneModComplete':
            return eGA_GeneMod;
        case 'Augmentation':
            return eGA_Augmentation;
        case 'ExaltRaidFailCountry':
            return eGA_ExaltRaidFailCountry;
        case 'ExaltRaidFailContinent':
            return eGA_ExaltRaidFailContinent;
        case 'AirBaseDefenseFailed':
            return EGeoscapeAlert(53);
        case 'ItemRepairsComplete':
            return EGeoscapeAlert(54);
    }

    `LWCE_LOG_ERROR("EnumFromAlertName: did not find a match for alert name " $ AlertType);
    return EGeoscapeAlert(0);
}

function Init()
{
    UI = Spawn(class'LWCE_XGGeoscapeUI');
}

function InitNewGame()
{
    m_kDateTime = Spawn(class'LWCE_XGDateTime');
    m_kDateTime.SetTime(0, 0, 0, START_MONTH, START_DAY, START_YEAR);

    InitPlayer();
}

event Tick(float fDeltaT)
{
    local int I, iSlices;
    local float fGameTime, fRemainderTime, fUseMaximumTimeslice;

    if (UI == none)
    {
        return;
    }

    if (!PRES().IsInState('State_PauseMenu', true))
    {
        Game().m_fGameDuration += fDeltaT;
    }

    if (!IsScanning())
    {
        UpdateSound();
    }

    if ( (HasAlerts() || HasRequests()) && !IsBusy() || LWCE_GetTopAlert().AlertType == 'DropArrive' )
    {
        if (!IsPaused())
        {
            Pause();
        }

        return;
    }

    fGameTime = fDeltaT * m_fTimeScale;

    if (m_kDateTime != none && `HQGAME.m_kEarth != none && !IsPaused())
    {
        `HQGAME.m_kEarth.UpdateUniverseRotation(m_kDateTime);
    }

    if (fGameTime == 0.0f)
    {
        return;
    }

    if (fGameTime >= 60.0f)
    {
        if (fGameTime <= 900.0f)
        {
            fUseMaximumTimeslice = 60.0f;
        }
        else
        {
            fUseMaximumTimeslice = 1800.0f;
        }

        fRemainderTime = fGameTime > fUseMaximumTimeslice ? fGameTime % fUseMaximumTimeslice : 0.0f;
        iSlices = Max(int(fGameTime / fUseMaximumTimeslice), 1);

        for (I = 0; I < iSlices; I++)
        {
            GameTick(fUseMaximumTimeslice);

            if (HasAlerts())
            {
                UpdateUI(fDeltaT);
                return;
            }
        }

        if (fRemainderTime > 0.0f)
        {
            GameTick(fRemainderTime);
        }
    }
    else
    {
        GameTick(fGameTime);
    }

    UpdateUI(fDeltaT);
}

function int AddMission(XGMission kMission, optional bool bFirst)
{
    local name nmGeoscapeAlert;
    local EEntityGraphic eGraphic;
    local XGMissionControlUI kMissionControlUI;
    local LWCEDataContainer kEventData;
    local LWCE_TGeoscapeAlert kAlert;
    local XComNarrativeMoment kNarrativeMoment;

    // EVENT: BeforeAddMissionToGeoscape
    //
    // SUMMARY: Emitted right before a mission will be added to the Geoscape. Can be used to modify the mission's
    //          rewards, location, enemy squad, etc. Can also prevent the mission from being added in the first place.
    //          Note that the mission's XGBattleDesc may not be generated yet.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: LWCE_XGMission - The mission object which is about to be added. Can be modified or even replaced
    //                                 with a mission of a different type.
    //       Data[1]: boolean - Return parameter for event handlers. If an event handler sets this field to false, the
    //                          mission will not be added to the Geoscape. Currently, the first mission of the campaign
    //                          cannot be prevented in this way.
    //
    // SOURCE: LWCE_XGGeoscape
    kEventData = class'LWCEDataContainer'.static.New('BeforeAddMissionToGeoscape');
    kEventData.AddObject(kMission);
    kEventData.AddBool(true);

    `LWCE_EVENT_MGR.TriggerEvent('BeforeAddMissionToGeoscape', kEventData, self);

    if (!kEventData.Data[1].B && !bFirst)
    {
        return -1;
    }

    kMission = XGMission(kEventData.Data[0].Obj); // in case a mod replaced the mission object
    kMission.m_iID = ++m_iNumMissions;
    m_arrMissions.AddItem(kMission);

    kMission.GenerateBattleDescription();

    // Don't add the first mission to the Geoscape UI, we're going to launch straight into it
    if (bFirst)
    {
        return -1;
    }

    if (!kMission.IsDetected())
    {
        return -1;
    }

    // Once the final mission has spawned, ignore all other missions that occur
    if (GetFinalMission() != none && GetFinalMission() != kMission)
    {
        return -1;
    }

    eGraphic = eEntityGraphic_MAX;

    if (kMission.m_iMissionType == eMission_Crash)
    {
        kNarrativeMoment = `XComNarrativeMoment("FirstUFOShotDown");

        if (XGMission_UFOCrash(kMission).m_iUFOType == eShip_UFOEthereal)
        {
            eGraphic = eEntityGraphic_Mission_UFO_Crash_Overseer;
        }
        else
        {
            eGraphic = eEntityGraphic_Mission_UFO_Crash;
        }

        nmGeoscapeAlert = 'UFOCrash';
    }
    else if (kMission.m_iMissionType == eMission_Abduction)
    {
        eGraphic = eEntityGraphic_Mission_Abduction;
        // TODO: right now alerts for abductions are handled elsewhere, but it should move here
        // nmGeoscapeAlert = 'Abduction';

    }
    else if (kMission.m_iMissionType == eMission_TerrorSite)
    {
        if (Game().GetNumMissionsTaken(eMission_TerrorSite) == 0)
        {
            kNarrativeMoment = `XComNarrativeMoment("Terror");
        }

        eGraphic = eEntityGraphic_Mission_Terror;
        nmGeoscapeAlert = 'Terror';
    }
    else if (kMission.m_iMissionType == eMission_CovertOpsExtraction)
    {
        eGraphic = eEntityGraphic_Mission_Covert_Ops;
        nmGeoscapeAlert = 'ExaltAlert';
    }
    else if (kMission.m_iMissionType == eMission_CaptureAndHold)
    {
        eGraphic = eEntityGraphic_Mission_Covert_Ops;
        nmGeoscapeAlert = 'ExaltAlert';
    }
    else if (kMission.m_iMissionType == eMission_HQAssault)
    {
        StartHQAssault(); // TODO: make this work with events
    }
    else if (kMission.m_iMissionType == eMission_AlienBase)
    {
        eGraphic = eEntityGraphic_Mission_Alien_Base;
        nmGeoscapeAlert = 'AlienBase';
    }
    else if (kMission.m_iMissionType == eMission_LandedUFO)
    {
        if (kMission.m_kDesc.m_strMapName == "EWI_HQAssault_MP (Airbase Defense)")
        {
            eGraphic = eEntityGraphic_Interceptor;
        }
        else
        {
            eGraphic = eEntityGraphic_Mission_UFO_Landed;
        }
    }
    else if (kMission.m_iMissionType == eMission_Special)
    {
        eGraphic = eEntityGraphic_Mission_Council;
    }
    else if (kMission.m_iMissionType == eMission_ExaltRaid)
    {
        eGraphic = eEntityGraphic_Mission_Exalt_HQ;
    }
    else if (kMission.m_iMissionType == eMission_Final)
    {
        ClearAllMissions();
        kMissionControlUI = XGMissionControlUI(PRES().GetMgr(class'LWCE_XGMissionControlUI'));
        kMissionControlUI.UpdateView();
    }

    DetermineMap(kMission);

    // TODO: move all the alerting logic out of this function and into an event handler

    // EVENT: AfterAddMissionToGeoscape
    //
    // SUMMARY: Emitted right after a mission has been added to the Geoscape, but before alerting the player (if the mission
    //          type generates alerts). Use this hook to modify the mission's XGBattleDesc, or other fields which weren't
    //          available during BeforeAddMissionToGeoscape.
    //
    // DATA: LWCEDataContainer
    //       Data[0]: LWCE_XGMission - The mission object which is about to be added. Can be modified, but not replaced.
    //       Data[1]: name - The name of the one-time Geoscape alert to show for this mission. If an event handler sets this field
    //                       to empty, no alert will be shown to the player for this new mission. Generally you should only do this
    //                       if you're planning to alert the player in some other way.
    //       Data[2]: int - Integer value of the EEntityGraphic enum. The graphic selected here will be shown on the Geoscape.
    //                      A negative value will show no image on the Geoscape.
    //       Data[3]: XComNarrativeMoment - Out parameter. The narrative moment to play before alerting the player. If an event handler sets this
    //                                      field to None, no narrative moment will play.
    //
    // SOURCE: LWCE_XGGeoscape
    kEventData = class'LWCEDataContainer'.static.New('AfterAddMissionToGeoscape');
    kEventData.AddObject(kMission);
    kEventData.AddName(nmGeoscapeAlert);
    kEventData.AddInt(eGraphic < eEntityGraphic_MAX ? int(eGraphic) : -1);
    kEventData.AddObject(kNarrativeMoment);

    `LWCE_EVENT_MGR.TriggerEvent('AfterAddMissionToGeoscape', kEventData, self);

    // Sync back data in case an event listener changed it
    kMission = XGMission(kEventData.Data[0].Obj);
    nmGeoscapeAlert = kEventData.Data[1].Nm;
    kNarrativeMoment = XComNarrativeMoment(kEventData.Data[3].Obj);

    if (kEventData.Data[2].I >= 0 && kEventData.Data[2].I < eEntityGraphic_MAX)
    {
        eGraphic = EEntityGraphic(kEventData.Data[2].I);
        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eGraphic);
    }

    if (kNarrativeMoment != none)
    {
        PRES().UINarrative(kNarrativeMoment);
    }

    if (nmGeoscapeAlert != '')
    {
        kEventData = class'LWCEDataContainer'.static.New('GeoscapeAlert');
        kEventData.AddInt(kMission.m_iID);

        kAlert.AlertType = nmGeoscapeAlert;
        kAlert.kData = kEventData;
        LWCE_Alert(kAlert);
    }

    UpdateUI(0.0);

    return kMission.m_iID;
}

function Alert(TGeoscapeAlert kAlert)
{
    `LWCE_LOG_DEPRECATED_CLS(Alert);
}

function LWCE_Alert(LWCE_TGeoscapeAlert kAlert)
{
    LWCE_PreloadSquadIntoSkyranger(kAlert.AlertType, false);

    // Make sure that if there's an end-of-month alert queued up, new alerts come before it
    if (m_arrCEAlerts.Length > 0 && m_arrCEAlerts[m_arrCEAlerts.Length - 1].AlertType == 'PayDay')
    {
        m_arrCEAlerts.InsertItem(0, kAlert);
    }
    else
    {
        m_arrCEAlerts.AddItem(kAlert);
    }

    if (`HQGAME.GetGameCore().m_bIronMan && CanExit())
    {
        XComGameReplicationInfo(class'Engine'.static.GetCurrentWorldInfo().GRI).GetAutosaveMgr().DoAutosave(true);
    }
}

function CancelInterception(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_CLS(CancelInterception);
}

function LWCE_CancelInterception(LWCE_XGShip kEnemyShip)
{
    local array<LWCE_XGShip> arrFriendlyShips;
    local LWCE_XGShip kFriendlyShip;
    local bool bCanceled;

    arrFriendlyShips = LWCE_XGFacility_Hangar(HANGAR()).LWCE_GetAllShips();

    foreach arrFriendlyShips(kFriendlyShip)
    {
        if (kFriendlyShip.m_kEngagement != none)
        {
            if (kFriendlyShip.m_kEngagement.m_arrEnemyShips[0] == kEnemyShip)
            {
                kFriendlyShip.m_kEngagement.LWCE_ReturnToBase(kFriendlyShip);
                bCanceled = true;
            }
        }
    }

    if (bCanceled)
    {
        LWCE_Alert(`LWCE_ALERT('UFOLost').AddInt(kEnemyShip.m_iCounter).Build());
    }
}

function bool CanIdentifyCraft(EShipType eCraft)
{
    `LWCE_LOG_DEPRECATED_BY(CanIdentifyCraft, LWCE_CanIdentifyShip);

    return true;
}

/// <summary>
/// Whether XCom is capable of identifying the given ship, should they encounter one. This requires either
/// a successful encounter with a ship of the same type previously, or an active Hyperwave Relay.
/// </summary>
function bool LWCE_CanIdentifyShip(name nmShip)
{
    return HQ().IsHyperwaveActive() || m_arrCEShipEncounters.Find(nmShip) != INDEX_NONE;
}

function ClearTopAlert(optional bool bDoNotResume = false)
{
    if (m_arrCEAlerts.Length > 0)
    {
        m_arrCEAlerts.Remove(0, 1);
    }

    if (!HasAlerts() && !bDoNotResume && IsPaused())
    {
        GEOSCAPE().Resume();
    }
}

function ColorCountry(ECountry eCntry, Color Col)
{
    `LWCE_LOG_DEPRECATED_CLS(ColorCountry);
}

/// <summary>
/// Changes the given country's color on the Geoscape globe.
/// </summary>
function LWCE_ColorCountry(name nmCountry, Color Col)
{
    // This (and similar functions) is not substantially rewritten for LWCE, because the Earth object uses
    // textures and materials specifically made for the base game and its ECountry values
    `HQGAME.GetEarth().HighlightCountry(class'LWCE_XGWorld'.static.CountryIdFromName(nmCountry), Col);
}

function ClearCountryColor(ECountry eCntry, Color Col)
{
    `LWCE_LOG_DEPRECATED_CLS(ClearCountryColor);
}

/// <summary>
/// TODO; not clear
/// </summary>
function LWCE_ClearCountryColor(name nmCountry, Color Col)
{
    `HQGAME.GetEarth().ClearCountryHighlight(class'LWCE_XGWorld'.static.CountryIdFromName(nmCountry));
}

function ClearCountryPulse(ECountry eCntry)
{
    `LWCE_LOG_DEPRECATED_CLS(ClearCountryPulse);
}

/// <summary>
/// Removes the pulse from the given country and recolors it according to its panic level.
/// </summary>
function LWCE_ClearCountryPulse(name nmCountry)
{
    `HQGAME.GetEarth().ClearCountryHighlight(class'LWCE_XGWorld'.static.CountryIdFromName(nmCountry));
    UpdateCountryColors();
}

function int DetectUFO(XGShip_UFO kUFO)
{
    `LWCE_LOG_DEPRECATED_BY(DetectUFO, LWCE_DetectShip);

    return 1000;
}

function int LWCE_DetectShip(LWCE_XGShip kShip)
{
    local LWCE_XGFacility_Hangar kHangar;
    local LWCE_XGHeadquarters kHQ;
    local int iChance, Index;

    kHangar = LWCE_XGFacility_Hangar(HANGAR());
    kHQ = LWCE_XGHeadquarters(HQ());

    if (kShip.m_kObjective == none || kShip.m_kObjective.m_bComplete)
    {
        return -1;
    }

    // Can't see Overseer UFOs without a Hyperwave facility
    if (kShip.m_kTemplate.bIsCloaked && kHQ.LWCE_GetNumFacilities('Facility_HyperwaveRelay') == 0)
    {
        return -1;
    }

    // If the ship lands it's replaced by a mission site, so the ship itself is not shown
    if (kShip.m_bLanded)
    {
        return -1;
    }

    if (kShip.IsTrackable())
    {
        // If there's a satellite in the country, the ship is always spotted
        for (Index = 0; Index < kHQ.m_arrCESatellites.Length; Index++)
        {
            if (kHQ.m_arrCESatellites[Index].iTravelTime <= 0)
            {
                if (kHQ.m_arrCESatellites[Index].nmCountry == kShip.m_nmCountryTarget)
                {
                    return Index;
                }
            }
        }

        // Always see ships hunting satellites, even if there isn't a satellite in the country
        if (kShip.m_kObjective.LWCE_GetType() == 'Hunt')
        {
            return 0;
        }

        // There's a fixed chance per ship on the continent to detect the inbound ship
        if (kHangar.LWCE_GetNumShipsInRangeAndAvailable(kShip) > 0)
        {
            // Ships only get one chance at detection
            if (kShip.m_bRolledDetectionByShips)
            {
                return -1;
            }

            kShip.m_bRolledDetectionByShips = true;

            iChance = class'XGTacticalGameCore'.default.UFO_INTERCEPTION_PCT;

            // Chance is doubled by the UFO Tracking project
            if (LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_UFOTracking'))
            {
                iChance *= 2.0;
            }

            if (Roll(iChance * kHangar.LWCE_GetNumShipsInRangeAndAvailable(kShip)))
            {
                return 0;
            }
        }
    }

    return -1;
}

function DetermineMap(XGMission kMission, optional EMissionTime eTime = eMissionTime_None)
{
    local string strMap;
    local int PlayCount;
    local EMissionType eMission;
    local EShipType eUFO;

    // TODO: there's a lot to clean up here once we migrate everything to LWCE mission objects
    `ONLINEEVENTMGR.StorageWriteCooldownTimer = 3.0;

    if (kMission.m_bScripted)
    {
        class'XComMapManager'.static.IncrementMapPlayHistory(kMission.m_kDesc.m_strMapName, `PROFILESETTINGS.Data.m_arrMapHistory, PlayCount);
        `ONLINEEVENTMGR.SaveProfileSettings();
        return;
    }

    if (kMission.m_iMissionType == eMission_Special)
    {
        kMission.m_kDesc.m_strMapName = XGMission_FundingCouncil(kMission).m_kTMission.strMapName;
        kMission.m_kDesc.m_strMapCommand = class'XComMapManager'.static.GetMapCommandLine(kMission.m_kDesc.m_strMapName, true, true, kMission.m_kDesc);
        class'XComMapManager'.static.IncrementMapPlayHistory(kMission.m_kDesc.m_strMapName, `PROFILESETTINGS.Data.m_arrMapHistory, PlayCount);
        `ONLINEEVENTMGR.SaveProfileSettings();
        return;
    }

    eMission = EMissionType(kMission.m_iMissionType);

    if (eMission == eMission_LandedUFO)
    {
        eUFO = XGMission_UFOLanded(kMission).kUFO.m_kTShip.eType;
    }
    else if (eMission == eMission_Crash)
    {
        eUFO = EShipType(XGMission_UFOCrash(kMission).m_iUFOType);
    }
    else
    {
        eUFO = eShip_None;
    }

    if (XComHeadquartersCheatManager(GetALocalPlayerController().CheatManager) != none && kMission.m_bCheated)
    {
        strMap = kMission.m_kDesc.m_strMapName;
    }
    else
    {
        // The Country parameter in GetRandomMapDisplayName doesn't seem to be used, so just force it to 0
        // TODO: this seems to crash the game if no matching map is found
        strMap = class'XComMapManager'.static.GetRandomMapDisplayName(eMission, eTime, eUFO, kMission.GetRegion(), ECountry(0), `PROFILESETTINGS.Data.m_arrMapHistory, PlayCount);
    }

    kMission.m_kDesc.m_iPlayCount = PlayCount;
    kMission.m_kDesc.m_strMapName = strMap;
    kMission.m_kDesc.m_strMapCommand = class'XComMapManager'.static.GetMapCommandLine(strMap, true, true, kMission.m_kDesc);

    if (!(XComHeadquartersCheatManager(GetALocalPlayerController().CheatManager) != none) && kMission.m_bCheated)
    {
        class'XComMapManager'.static.IncrementMapPlayHistory(kMission.m_kDesc.m_strMapName, `PROFILESETTINGS.Data.m_arrMapHistory, PlayCount);
    }

    `ONLINEEVENTMGR.SaveProfileSettings(false);
}

function GameTick(float fGameTime)
{
    UpdateShips(fGameTime);

    m_fAITimer -= fGameTime;

    if (m_fAITimer <= 0.0f)
    {
        AIUpdate();
        m_fAITimer += 1800.0f;
    }

    m_fGameTimer -= fGameTime;

    if (m_fGameTimer <= 0.0f)
    {
        HQ().Update();
        m_fGameTimer += 3600.0f;
    }

    m_kDateTime.AddTime(fGameTime);

    if (IsPayDay() && !IsBusy() && !IsPaused())
    {
        World().m_kFundingCouncil.OnEndOfMonth();
        World().CouncilMeeting();
        AI().UpdateObjectives(, true);

        if (!m_kDateTime.IsFirstDay())
        {
            LWCE_Alert(`LWCE_ALERT('PayDay').Build());
            AI().MakeMonthlyPlan();
        }
    }
}

function GetEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEvents);
}

function LWCE_GetEvents(out array<LWCE_THQEvent> arrEvents)
{
    local int iEvent;
    local LWCE_THQEvent kEvent;
    local XGDateTime kPayDay;

    kPayDay = Spawn(class'LWCE_XGDateTime');
    kPayDay.CopyDateTime(m_kDateTime);
    kPayDay.AddMonth();
    kPayDay.SetTime(0, 0, 0, kPayDay.GetMonth(), 1, kPayDay.GetYear());

    kEvent.EventType = 'EndOfMonth';
    kEvent.iHours = kPayDay.DifferenceInHours(m_kDateTime);

    for (iEvent = 0; iEvent < arrEvents.Length; iEvent++)
    {
        if (arrEvents[iEvent].iHours > kEvent.iHours)
        {
            arrEvents.InsertItem(iEvent, kEvent);
            kPayDay.Destroy();
            return;
        }
    }

    arrEvents.AddItem(kEvent);
    kPayDay.Destroy();
}

function int GetSatTravelTime(int iCountry)
{
    `LWCE_LOG_DEPRECATED_CLS(GetSatTravelTime);

    return -100;
}

function int LWCE_GetSatTravelTime(name nmCountry)
{
    local XGCountry kDestCountry;
    local Vector2D v2Dist;

    kDestCountry = LWCE_XGWorld(WORLD()).LWCE_GetCountry(nmCountry);
    v2Dist = GetShortestDist(HQ().GetCoords(), kDestCountry.GetCoords());
    return int(3.0f + ((V2DSize(v2Dist) / 1.40) * 7.0f));
}

function TGeoscapeAlert GetTopAlert()
{
    local TGeoscapeAlert kAlert;

    `LWCE_LOG_DEPRECATED_CLS(GetTopAlert);

    return kAlert;
}

function LWCE_TGeoscapeAlert LWCE_GetTopAlert()
{
    local LWCE_TGeoscapeAlert kAlert;

    if (m_arrCEAlerts.Length > 0)
    {
        kAlert = m_arrCEAlerts[0];
    }

    return kAlert;
}

function bool HasAlerts()
{
    return m_arrCEAlerts.Length > 0;
}

function TGeoscapeAlert MakeAlert(EGeoscapeAlert eAlert, optional int iData1, optional int iData2, optional int iData3, optional int iData4)
{
    local TGeoscapeAlert kAlert;

    `LWCE_LOG_DEPRECATED_BY(MakeAlert, LWCE_ALERT macro);
    ScriptTrace();

    return kAlert;
}

function MissionAlert(int iMission)
{
    local XGMission kMission;

    if (iMission < 0 || iMission >= m_arrMissions.Length)
    {
        return;
    }

    kMission = m_arrMissions[iMission];

    if (kMission.m_iMissionType == eMission_Crash)
    {
        LWCE_Alert(`LWCE_ALERT('UFOCrash').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_Abduction)
    {
        LWCE_Alert(`LWCE_ALERT('Abduction').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_CovertOpsExtraction)
    {
        LWCE_Alert(`LWCE_ALERT('ExaltAlert').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_CaptureAndHold)
    {
        LWCE_Alert(`LWCE_ALERT('ExaltAlert').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_ExaltRaid)
    {
        SITROOM().m_bDisplayExaltRaidDetails = true;
        HQ().JumpToFacility(SITROOM(), 1.0, eSitView_Exalt);
    }
    else if (kMission.m_iMissionType == eMission_TerrorSite)
    {
        LWCE_Alert(`LWCE_ALERT('Terror').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_AlienBase)
    {
        LWCE_Alert(`LWCE_ALERT('AlienBase').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_LandedUFO)
    {
        LWCE_Alert(`LWCE_ALERT('UFOLanded').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_Special)
    {
        SITROOM().m_bDisplayMissionDetails = true;
        HQ().JumpToFacility(SITROOM(), 1.0, eSitView_Mission);
    }
    else if (kMission.m_iMissionType == eMission_Final)
    {
        LWCE_Alert(`LWCE_ALERT('Temple').AddInt(kMission.m_iID).Build());
    }
}

function OnAlienBaseDetected(XGMission_AlienBase kBase)
{
    LWCE_Alert(`LWCE_ALERT('AlienBase').AddInt(kBase.m_iID).Build());
}

function OnFundingCouncilRequestAdded(const TFCRequest kRequest)
{
    `LWCE_LOG_DEPRECATED_CLS(OnFundingCouncilRequestAdded);
}

function LWCE_OnFundingCouncilRequestAdded()
{
    m_bActiveFundingCouncilRequestPopup = true;
}

/// <summary>
/// Called whenever an enemy ship is detected. (Despite the name, it applies to ships of all types.)
/// Notifies the player with a Geoscape alert.
/// </summary>
function OnUFODetected(int iShip)
{
    local LWCE_XGShip kShip;
    local XGMission kMission;

    kShip = LWCE_XGStrategyAI(AI()).LWCE_GetShip(iShip);
    kShip.m_iCounter = ++m_iDetectedUFOs;

    if (kShip.m_nmShipTemplate == 'UFOEthereal')
    {
        HQ().m_bHyperwaveActivated = true;
    }

    if (kShip.IsFlying())
    {
        LWCE_Alert(`LWCE_ALERT('EnemyShipDetected').AddInt(iShip).Build());

        if (kShip.m_kObjective.m_kCETObjective.nmType == 'AssaultXComHQ')
        {
            LWCE_XComHQPresentationLayer(PRES()).LWCE_Notify('ShipEnRouteToXComHQ', none);
        }
    }
    else
    {
        `LWCE_LOG_ERROR("Landed UFO missions in Geoscape require update to XGMission framework");
        ScriptTrace();

        // foreach m_arrMissions(kMission)
        // {
        //     if (XGMission_UFOLanded(kMission) != none && XGMission_UFOLanded(kMission).kUFO == kShip)
        //     {
        //         LWCE_Alert(`LWCE_ALERT('UFOLanded').AddInt(kMission.m_iID).Build());
        //         break;
        //     }
        // }
    }
}

simulated function PreloadSquadIntoSkyranger(EGeoscapeAlert eAlertType, bool bUnload)
{
    LWCE_PreloadSquadIntoSkyranger(AlertNameFromEnum(eAlertType), bUnload);
}

simulated function LWCE_PreloadSquadIntoSkyranger(name nmAlertType, bool bUnload)
{
    switch (nmAlertType)
    {
        case 'Abduction':
        case 'Terror':
        case 'FCMission':
        case 'UFOCrash':
        case 'UFOLanded':
        case 'AlienBase':
        case 'Temple':
        case 'FCMissionActivity':
        case 'ExaltMissionActivity':
            if (bUnload)
            {
                UnloadPreloadedSquad();
            }
            else
            {
                PreloadSquad();
            }

            break;
    }
}

function PulseCountry(ECountry eCntry, Color col1, Color col2, float fTime)
{
    `LWCE_LOG_DEPRECATED_CLS(PulseCountry);
}

/// <summary>
/// Causes the specified country to pulse between two colors.
/// </summary>
function LWCE_PulseCountry(name nmCountry, Color col1, Color col2, float fTime)
{
    `LWCE_LOG_NOT_IMPLEMENTED(LWCE_PulseCountry);

    // `HQGAME.GetEarth().PulseCountry(nmCountry, col1, col2, fTime);
}

function RadarUpdate()
{
    local int Index;
    local LWCE_XGShip kShip;
    local LWCE_XGStrategyAI kAI;

    kAI = LWCE_XGStrategyAI(AI());

    for (Index = 0; Index < kAI.m_arrCEShips.Length; Index++)
    {
        kShip = kAI.m_arrCEShips[Index];

        if (kShip.IsDetected())
        {
            if (m_bSeeAll)
            {
                kShip.m_iDetectedBy = 0;
            }
            else
            {
                kShip.SetDetection(LWCE_TrackShip(kShip));
            }

            if (!kShip.IsDetected())
            {
                // Parameter isn't actually used in OnUFOVanished, which is also why we don't bother overriding it
                OnUFOVanished(0);
            }
        }
        else
        {
            if (m_bSeeAll)
            {
                kShip.m_iDetectedBy = 0;
            }
            else
            {
                kShip.SetDetection(LWCE_DetectShip(kShip));
            }

            if (kShip.IsDetected())
            {
                OnUFODetected(Index);
            }
        }
    }
}

function RemoveMission(XGMission kMission, bool bXComSuccess, optional bool bExpired, optional bool bFirstMission, optional bool bDontApplyToContinent)
{
    local XGShip_Dropship kSkyranger;

    if (!bFirstMission)
    {
        AI().ApplyMissionPanic(kMission, bXComSuccess, bExpired, bDontApplyToContinent);

        if (kMission.m_iMissionType == eMission_LandedUFO)
        {
            if (bXComSuccess)
            {
                AI().RemoveUFO(XGMission_UFOLanded(kMission).kUFO);
            }
        }

        kSkyranger = HANGAR().m_kSkyranger;

        if (kSkyranger.m_kMission == kMission && bExpired)
        {
            LWCE_Alert(`LWCE_ALERT('MissedAliens').Build());
            kSkyranger.SetMission(m_kReturnMission);
        }
    }

    m_arrMissions.RemoveItem(kMission);

    if (kMission.m_kDesc != none)
    {
        kMission.m_kDesc.Destroy();
    }

    if (kMission.GetEntity() != none)
    {
        kMission.HideEntity(true);
        kMission.GetEntity().Destroy();
    }

    kMission.Destroy();
    PRES().MissionNotify();

    if (bExpired && !IsBusy())
    {
        BARRACKS().ClearSquad(kSkyranger);
    }
}

function RemoveUFO(XGShip_UFO kShip)
{
    `LWCE_LOG_DEPRECATED_BY(RemoveUFO, LWCE_RemoveShip);
}

function LWCE_RemoveShip(LWCE_XGShip kShip)
{
    if (kShip.GetHP() > 0)
    {
        LWCE_CancelInterception(kShip);
    }

    UpdateSound();
}

function SkyrangerArrival(XGShip_Dropship kSkyranger, optional bool bRequestOrders)
{
    local XGMission kMission;
    local int iSkyrangerIndex;

    kMission = kSkyranger.m_kMission;
    kSkyranger.m_fExpectedFlightTime = 0.0;

    if (kMission.m_iMissionType == eMission_ReturnToBase)
    {
        kSkyranger.Land();
        kSkyranger.SetMission(none);

        if (!`HQGAME.GetGameCore().m_bTutorial || Game().GetNumMissionsTaken() > 1)
        {
            PRES().UINotifySkyReturn();
        }
    }
    else if (bRequestOrders)
    {
        iSkyrangerIndex = 0;
        m_arrCEAlerts.Length = 0;
        LWCE_Alert(`LWCE_ALERT('DropArrive').AddInt(iSkyrangerIndex).Build());
    }
    else
    {
        Game().BeginCombat(kSkyranger.m_kMission);
    }
}

function SpawnTempleEntity()
{
    `LWCE_LOG("SpawnTempleEntity");
    ScriptTrace();
    m_kTemple = Spawn(class'LWCE_XGEntity');
    m_kTemple.Init(eEntityGraphic_Mission_Temple_Ship);
}

function int TrackUFO(XGShip_UFO kShip)
{
    `LWCE_LOG_DEPRECATED_BY(TrackUFO, LWCE_TrackShip);

    return 1000;
}

/// <summary>
/// Checks whether the given ship can be tracked, and if so, returns the index of the satellite capable of
/// tracking it. Otherwise, returns INDEX_NONE. Does not check if the ship has cloaking capability.
/// </summary>
function int LWCE_TrackShip(LWCE_XGShip kShip)
{
    if (kShip.IsTrackable())
    {
        return kShip.m_iDetectedBy;
    }
    else
    {
        return -1;
    }
}

/// <summary>
/// Recolors all current Council countries to match their panic color.
/// </summary>
function UpdateCountryColors()
{
    local array<LWCE_XGCountry> arrCountries;
    local LWCE_XGCountry kCountry;

    arrCountries = `LWCE_WORLD.GetCouncilCountries(/* bRequireCurrentMember */ true);

    foreach arrCountries(kCountry)
    {
        LWCE_ColorCountry(kCountry.m_nmCountry, kCountry.GetPanicColor());
    }
}

/// <summary>
/// Updates the given ship's position, handling some unique behavior for XCom's ships in the process.
/// </summary>
/// <returns>True if the ship has reached its destination, false otherwise.</returns>
function bool UpdateShip(XGShip kShip, float fDeltaT)
{
    local Vector2D v2Dist, v2Dest, v2Pos, v2DistRemaining, v2Dir;
    local bool bEnforceMinTime;
    local float fMiles, fRealTime, fScale;

    bEnforceMinTime = kShip.IsA('LWCE_XGShip_Dropship') || LWCE_XGShip(kShip).IsXComShip();

    if (kShip.IsFlying())
    {
        if (bEnforceMinTime && m_fTimeForShips != 0.0f)
        {
            kShip.m_fCurrentFlightTime += (fDeltaT / m_fTimeScale);

            if (kShip.m_fCurrentFlightTime >= 3.0)
            {
                bEnforceMinTime = false;
                m_fTimeForShips = 0.0;
                Resume();
            }
        }

        v2Dest = kShip.m_v2Destination;
        v2Pos = kShip.m_v2Coords;
        v2DistRemaining = GetShortestDist(v2Pos, v2Dest);
        v2Dist = kShip.GetScreenSpeedPerSecond() * fDeltaT;

        if (bEnforceMinTime)
        {
            if (kShip.m_fExpectedFlightTime == 0.0f)
            {
                fMiles = V2DSize(ConvertToMiles(v2DistRemaining));
                kShip.m_fExpectedFlightTime = ((fMiles / float(kShip.GetSpeed())) * 60.0f) * 60.0f;

                if (m_fTimeScale != 0.0f)
                {
                    fRealTime = kShip.m_fExpectedFlightTime / m_fTimeScale;

                    if (fRealTime < 3.0)
                    {
                        fScale = kShip.m_fExpectedFlightTime / 3.0;

                        if (m_fTimeForShips == 0.0f || fScale < m_fTimeForShips)
                        {
                            m_fTimeForShips = fScale;
                            kShip.m_fAdjustedFlightTime = fScale;
                        }
                    }
                }
            }
        }

        if (V2DSizeSq(v2Dist) >= V2DSizeSq(v2DistRemaining))
        {
            kShip.m_v2Coords = v2Dest;
            return true;
        }

        v2Dir = V2DNormal(v2DistRemaining);
        kShip.m_vHeading.X = v2Dir.X;
        kShip.m_vHeading.Y = v2Dir.Y;
        kShip.m_vHeading = Normal(kShip.m_vHeading);

        v2Dir *= v2Dist;
        kShip.m_v2Coords += v2Dir;
    }
    else
    {
        kShip.m_fCurrentFlightTime = 0.0;

        if (bEnforceMinTime)
        {
            kShip.m_fExpectedFlightTime = 0.0;

            if (kShip.m_fAdjustedFlightTime != 0.0f && kShip.m_fAdjustedFlightTime == m_fTimeForShips)
            {
                m_fTimeForShips = 0.0;
                Resume();
            }

            kShip.m_fAdjustedFlightTime = 0.0;
        }
    }

    return false;
}

/// <summary>
/// Updates all ships active on the Geoscape.
/// </summary>
function UpdateShips(float fDeltaT)
{
    local LWCE_XGFacility_Hangar kHangar;
    local LWCE_XGShip kShip;
    local LWCE_XGStrategyAI kAI;
    local XGShip_Dropship kSkyranger;
    local int Index;

    kHangar = LWCE_XGFacility_Hangar(HANGAR());
    kAI = LWCE_XGStrategyAI(AI());

    kSkyranger = kHangar.m_kSkyranger;
    kSkyranger.Update(fDeltaT);

    if (UpdateShip(kSkyranger, fDeltaT))
    {
        kSkyranger.Update(fDeltaT);
        SkyrangerArrival(kSkyranger, true);
    }
    else if (!kSkyranger.IsFlying() && kSkyranger.m_kMission != none)
    {
        kSkyranger.Update(fDeltaT);
        SkyrangerArrival(kSkyranger, true);
    }

    for (Index = kAI.m_arrCEShips.Length - 1; Index >= 0; Index--)
    {
        kShip = kAI.m_arrCEShips[Index];
        kShip.Update(fDeltaT);

        if (UpdateShip(kShip, fDeltaT))
        {
            kShip.OnArrival();
        }
    }

    foreach kHangar.m_arrCEShips(kShip)
    {
        kShip.Update(fDeltaT);

        if (UpdateShip(kShip, fDeltaT))
        {
            kShip.OnArrival();
        }
    }

    if (!IsPaused())
    {
        Resume();
    }
}

/// <summary>
/// Updates the Geoscape's UI (that is, the hologlobe) with all visible ships, alien bases, XCOM bases/outposts, and missions.
/// </summary>
function UpdateUI(float fDeltaT)
{
    local LWCE_XGShip kShip;
    local XGShip_Dropship kSkyranger;
    local XGMission kMission;
    local XGOutpost kOutpost;
    local XGCountry kCountry;
    local LWCE_XGFacility_Hangar kHangar;
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGStrategyAI kAI;
    local LWCE_TSatellite kSatellite;

    kAI = LWCE_XGStrategyAI(AI());
    kHangar = LWCE_XGFacility_Hangar(HANGAR());
    kHQ = LWCE_XGHeadquarters(HQ());

    UI.Clear();
    kSkyranger = kHangar.m_kSkyranger;

    if (kSkyranger.GetCoords() == HQ().GetCoords())
    {
        kSkyranger.HideEntity(true);
    }
    else
    {
        UI.DrawSkyranger(kSkyranger.GetEntity(), 0, -1, WrapCoords(kSkyranger.GetCoords()));
    }

    foreach kHangar.m_arrCEShips(kShip)
    {
        if (kShip.GetCoords() != kShip.GetHomeCoords())
        {
            UI.DrawInterceptor(kShip.GetEntity(), 0, -1, WrapCoords(kShip.GetCoords()));
            continue;
        }

        kShip.HideEntity(true);
    }

    UI.DrawBase(kHQ.GetEntity(), kHQ.GetCoords());

    foreach kHQ.m_arrOutposts(kOutpost)
    {
        UI.DrawBase(kOutpost.GetEntity(), kOutpost.GetCoords());
    }

    foreach kHQ.m_arrCESatellites(kSatellite)
    {
        if (kSatellite.iTravelTime == 0)
        {
            UI.DrawSatellite(kSatellite.kSatEntity, kSatellite.v2Loc);
        }
    }

    foreach kAI.m_arrCEShips(kShip)
    {
        if (!kShip.IsDetected())
        {
            kShip.HideEntity(true);
            continue;
        }
        else if (kShip.m_bLanded)
        {
            // Hide landed UFOs because they'll have a mission marker
            kShip.HideEntity(true);
            continue;
        }

        UI.DrawUFO(kShip.GetEntity(), 0, -1, WrapCoords(kShip.GetCoords()));
    }

    foreach m_arrMissions(kMission)
    {
        if (kMission.m_iMissionType == eMission_ReturnToBase)
        {
            kMission.HideEntity(true);
            continue;
        }

        if (!kMission.IsDetected())
        {
            kMission.HideEntity(true);
            continue;
        }

        UI.DrawMission(kMission.GetEntity(), kMission.m_iMissionType, kMission.GetCoords());
    }

    foreach World().m_arrCountries(kCountry)
    {
        if (kCountry.LeftXCom())
        {
            UI.DrawCountry(kCountry.m_kEntity, kCountry.GetCoords());
        }
    }

    if (m_kTemple != none)
    {
        UI.DrawTemple(m_kTemple, vect2d(0.4150, 0.5570));
    }

    UI.EndFrame(fDeltaT);
}