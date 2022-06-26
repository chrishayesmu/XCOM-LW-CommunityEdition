class LWCE_XGGeoscape extends XGGeoscape;

struct LWCE_TModAlert
{
    var TGeoscapeAlert kAlert;
    var int iAlertId;
};

const MOD_ALERT_TYPE = 255;

var array<LWCE_TModAlert> arrModAlerts;

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

        Alert(MakeAlert(eGA_UFOCrash, kMission.m_iID));
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
        Alert(MakeAlert(eGA_Terror, kMission.m_iID));
    }
    else if (kMission.m_iMissionType == eMission_CovertOpsExtraction)
    {
        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_Covert_Ops);
        Alert(MakeAlert(eGA_ExaltAlert, kMission.m_iID));
    }
    else if (kMission.m_iMissionType == eMission_CaptureAndHold)
    {
        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_Covert_Ops);
        Alert(MakeAlert(eGA_ExaltAlert, kMission.m_iID));
    }
    else if (kMission.m_iMissionType == eMission_HQAssault)
    {
        StartHQAssault();
    }
    else if (kMission.m_iMissionType == eMission_AlienBase)
    {
        kMission.SetEntity(Spawn(class'LWCE_XGMissionEntity'), eEntityGraphic_Mission_Alien_Base);
        Alert(MakeAlert(eGA_AlienBase, kMission.m_iID));
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

        Alert(MakeAlert(eGA_UFOLanded, kMission.m_iID));
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

function int Mod_Alert(TGeoscapeAlert kAlert)
{
    local LWCE_TModAlert kModAlert;

    kAlert.eType = MOD_ALERT_TYPE; // override whatever's passed in
    kModAlert.kAlert = kAlert;
    kModAlert.iAlertId = Rand(2000000000);
    arrModAlerts.AddItem(kModAlert);

    Alert(kAlert);

    return kModAlert.iAlertId;
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

function OnFundingCouncilRequestAdded(const TFCRequest kRequest)
{
    `LWCE_LOG_DEPRECATED_CLS(OnFundingCouncilRequestAdded);
}

function LWCE_OnFundingCouncilRequestAdded()
{
    m_bActiveFundingCouncilRequestPopup = true;
}

function SpawnTempleEntity()
{
    m_kTemple = Spawn(class'LWCE_XGEntity');
    m_kTemple.Init(eEntityGraphic_Mission_Temple_Ship);
}

event Tick(float fDeltaT)
{
    super.Tick(fDeltaT);
}