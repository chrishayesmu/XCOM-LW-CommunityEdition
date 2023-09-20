class LWCE_XGGeoscape extends XGGeoscape
    dependson(LWCETypes);

struct LWCE_TGeoscapeAlert
{
    var name AlertType;
    var LWCEDataContainer kData;
};

var array<LWCE_TGeoscapeAlert> m_arrCEAlerts;

static function name AlertNameFromEnum(EGeoscapeAlert eAlert)
{
    switch (eAlert)
    {
        case eGA_UFODetected:
            return 'UFODetected';
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
            return 'NewInterceptors';
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
            return 'FCDelayedRequest';
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
            return 'CellHides';
        case eGA_GeneMod:
            return 'GeneMod';
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
        case 'UFODetected':
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
        case 'FCDelayedRequest':
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
        case 'CellHides':
            return eGA_CellHides;
        case 'GeneMod':
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

    m_arrCraftEncounters.Add(15);
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
    local array<XGShip_Interceptor> arrInterceptors;
    local XGShip_Interceptor kInt;
    local bool bCanceled;

    arrInterceptors = HANGAR().GetAllInterceptors();

    foreach arrInterceptors(kInt)
    {
        if (kInt.m_kEngagement != none)
        {
            if (kInt.m_kEngagement.m_kUFOTarget == kUFO)
            {
                kInt.m_kEngagement.ReturnToBase(kInt);
                bCanceled = true;
            }
        }
    }

    if (bCanceled)
    {
        LWCE_Alert(`LWCE_ALERT('UFOLost').AddInt(kUFO.m_iCounter).Build());
    }
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

function int DetectUFO(XGShip_UFO kUFO)
{
    local LWCE_XGHeadquarters kHQ;
    local int iChance, Index;

    kHQ = LWCE_XGHeadquarters(HQ());

    if (kUFO.m_kObjective == none || kUFO.m_kObjective.m_bComplete)
    {
        return -1;
    }

    // Can't see Overseer UFOs without a Hyperwave facility
    if (kUFO.GetType() == eShip_UFOEthereal && kHQ.LWCE_GetNumFacilities('Facility_HyperwaveRelay') == 0)
    {
        return -1;
    }

    // If the UFO lands it's replaced by a mission site, so the UFO itself is not shown
    if (kUFO.m_bLanded)
    {
        return -1;
    }

    if (kUFO.IsInCountry())
    {
        // If there's a satellite in the country, the UFO is always spotted
        for (Index = 0; Index < kHQ.m_arrSatellites.Length; Index++)
        {
            if (kHQ.m_arrSatellites[Index].iTravelTime <= 0)
            {
                if (kHQ.m_arrSatellites[Index].iCountry == kUFO.GetCountry())
                {
                    return Index;
                }
            }
        }

        // Always see hunting satellites, even if there isn't a satellite in the country
        if (kUFO.m_kObjective.GetType() == eObjective_Hunt)
        {
            return 0;
        }

        // There's a fixed chance per interceptor on the continent to detect the UFO
        if (HANGAR().GetNumInterceptorsInRangeAndAvailable(kUFO) > 0)
        {
            // m_eSpecies is used as a sentinel value to make sure interceptors only get one chance to detect the UFO
            if (kUFO.m_eSpecies == eChar_Civilian)
            {
                return -1;
            }

            iChance = class'XGTacticalGameCore'.default.UFO_INTERCEPTION_PCT;

            // Chance is doubled by the UFO Tracking project
            if (LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsFoundryTechResearched('Foundry_UFOTracking'))
            {
                iChance *= 2.0;
            }

            if (Roll(iChance * HANGAR().GetNumInterceptorsInRangeAndAvailable(kUFO)))
            {
                return 0;
            }
            else
            {
                kUFO.m_eSpecies = eChar_Civilian;
            }
        }
    }

    return -1;
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

    // TODO: validate that V2DSize gives the correct results here
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

    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function MakeAlert was called. Use the LWCE_ALERT macro instead. Stack trace follows.");
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

function OnUFODetected(int iUFO)
{
    local XGShip_UFO kUFO;
    local XGMission kMission;

    kUFO = AI().GetUFO(iUFO);
    kUFO.m_iCounter = ++m_iDetectedUFOs;

    if (kUFO.m_kTShip.eType == eShip_UFOEthereal)
    {
        HQ().m_bHyperwaveActivated = true;
    }

    if (kUFO.IsFlying())
    {
        LWCE_Alert(`LWCE_ALERT('UFODetected').AddInt(iUFO).Build());

        if (kUFO.m_kObjective.m_kTObjective.eType == /* HQ assault */ 9)
        {
            PRES().Notify(52);
        }
    }
    else
    {
        foreach m_arrMissions(kMission)
        {
            if (XGMission_UFOLanded(kMission) != none && XGMission_UFOLanded(kMission).kUFO == kUFO)
            {
                LWCE_Alert(`LWCE_ALERT('UFOLanded').AddInt(kMission.m_iID).Build());
                break;
            }
        }
    }
}

simulated function PreloadSquadIntoSkyranger(EGeoscapeAlert eAlertType, bool bUnload)
{
    `LWCE_LOG_CLS("PreloadSquadIntoSkyranger: eAlertType = " $ eAlertType $ ", bUnload = " $ bUnload);
    LWCE_PreloadSquadIntoSkyranger(AlertNameFromEnum(eAlertType), bUnload);
}

simulated function LWCE_PreloadSquadIntoSkyranger(name nmAlertType, bool bUnload)
{
    `LWCE_LOG_CLS("LWCE_PreloadSquadIntoSkyranger: nmAlertType = " $ nmAlertType $ ", bUnload = " $ bUnload);
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
    m_kTemple = Spawn(class'LWCE_XGEntity');
    m_kTemple.Init(eEntityGraphic_Mission_Temple_Ship);
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