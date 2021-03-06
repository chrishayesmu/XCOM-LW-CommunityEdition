class LWCE_XGGeoscape extends XGGeoscape
    dependson(LWCETypes);

struct LWCE_TGeoscapeAlert
{
    var name AlertType;
    var array<LWCE_TData> arrData;
};

var array<LWCE_TGeoscapeAlert> m_arrCEAlerts;

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
    local XGMissionControlUI kMissionControlUI;

    if (!`LWCE_MOD_LOADER.OnMissionCreated(kMission) && !bFirst)
    {
        return -1;
    }

    kMission.m_iID = ++m_iNumMissions;
    m_arrMissions.AddItem(kMission);

    kMission.GenerateBattleDescription();

    if (bFirst)
    {
        return -1;
    }

    if (!kMission.IsDetected())
    {
        return -1;
    }

    if (GetFinalMission() != none && GetFinalMission() != kMission)
    {
        return -1;
    }

    if (kMission.m_iMissionType == eMission_Crash)
    {
        PRES().UINarrative(`XComNarrativeMoment("FirstUFOShotDown"));

        if (XGMission_UFOCrash(kMission).m_iUFOType == eShip_UFOEthereal)
        {
            kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_UFO_Crash_Overseer);
        }
        else
        {
            kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_UFO_Crash);
        }

        LWCE_Alert(`LWCE_ALERT('UFOCrash').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_Abduction)
    {
        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_Abduction);
    }
    else if (kMission.m_iMissionType == eMission_TerrorSite)
    {
        if (Game().GetNumMissionsTaken(eMission_TerrorSite) == 0)
        {
            PRES().UINarrative(`XComNarrativeMoment("Terror"));
        }

        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_Terror);
        LWCE_Alert(`LWCE_ALERT('Terror').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_CovertOpsExtraction)
    {
        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_Covert_Ops);
        LWCE_Alert(`LWCE_ALERT('ExaltAlert').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_CaptureAndHold)
    {
        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_Covert_Ops);
        LWCE_Alert(`LWCE_ALERT('ExaltAlert').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_HQAssault)
    {
        StartHQAssault();
    }
    else if (kMission.m_iMissionType == eMission_AlienBase)
    {
        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_Alien_Base);
        LWCE_Alert(`LWCE_ALERT('AlienBase').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_LandedUFO)
    {
        if (kMission.m_kDesc.m_strMapName == "EWI_HQAssault_MP (Airbase Defense)")
        {
            kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Interceptor);
        }
        else
        {
            kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_UFO_Landed);
        }

        LWCE_Alert(`LWCE_ALERT('UFOLanded').AddInt(kMission.m_iID).Build());
    }
    else if (kMission.m_iMissionType == eMission_Special)
    {
        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_Council);
    }
    else if (kMission.m_iMissionType == eMission_ExaltRaid)
    {
        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_Exalt_HQ);
    }
    else if (kMission.m_iMissionType == eMission_Final)
    {
        ClearAllMissions();
        kMissionControlUI = XGMissionControlUI(PRES().GetMgr(class'LWCE_XGMissionControlUI'));
        kMissionControlUI.UpdateView();
    }

    UpdateUI(0.0);
    DetermineMap(kMission);

    `LWCE_MOD_LOADER.OnMissionAddedToGeoscape(kMission);

    return kMission.m_iID;
}

function Alert(TGeoscapeAlert kAlert)
{
    `LWCE_LOG_DEPRECATED_CLS(Alert);
}

function LWCE_Alert(LWCE_TGeoscapeAlert kAlert)
{
    LWCE_PreloadSquadIntoSkyranger(kAlert.AlertType, false);

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

function name AlertNameFromEnum(EGeoscapeAlert eAlert)
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
    local int iChance, Index;

    if (kUFO.m_kObjective == none || kUFO.m_kObjective.m_bComplete)
    {
        return -1;
    }

    // Can't see Overseer UFOs without a Hyperwave facility
    if (kUFO.GetType() == eShip_UFOEthereal && HQ().GetNumFacilities(eFacility_HyperwaveRadar) == 0)
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
        for (Index = 0; Index < HQ().m_arrSatellites.Length; Index++)
        {
            if (HQ().m_arrSatellites[Index].iTravelTime <= 0)
            {
                if (HQ().m_arrSatellites[Index].iCountry == kUFO.GetCountry())
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
    `LWCE_LOG_DEPRECATED_CLS(PreloadSquadIntoSkyranger);
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