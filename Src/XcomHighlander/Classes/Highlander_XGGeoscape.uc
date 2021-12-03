class Highlander_XGGeoscape extends XGGeoscape;

struct HL_TModAlert
{
    var TGeoscapeAlert kAlert;
    var int iAlertId;
};

const MOD_ALERT_TYPE = 255;

var array<HL_TModAlert> arrModAlerts;

function int AddMission(XGMission kMission, optional bool bFirst)
{
    local XGMissionControlUI kMissionControlUI;

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
            kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Mission_UFO_Crash_Overseer);
        }
        else
        {
            kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Mission_UFO_Crash);
        }

        Alert(MakeAlert(eGA_UFOCrash, kMission.m_iID));
    }
    else if (kMission.m_iMissionType == eMission_Abduction)
    {
        kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Mission_Abduction);
    }
    else if (kMission.m_iMissionType == eMission_TerrorSite)
    {
        if (Game().GetNumMissionsTaken(eMission_TerrorSite) == 0)
        {
            PRES().UINarrative(`XComNarrativeMoment("Terror"));
        }

        kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Mission_Terror);
        Alert(MakeAlert(eGA_Terror, kMission.m_iID));
    }
    else if (kMission.m_iMissionType == eMission_CovertOpsExtraction)
    {
        kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Mission_Covert_Ops);
        Alert(MakeAlert(eGA_ExaltAlert, kMission.m_iID));
    }
    else if (kMission.m_iMissionType == eMission_CaptureAndHold)
    {
        kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Mission_Covert_Ops);
        Alert(MakeAlert(eGA_ExaltAlert, kMission.m_iID));
    }
    else if (kMission.m_iMissionType == eMission_HQAssault)
    {
        StartHQAssault();
    }
    else if (kMission.m_iMissionType == eMission_AlienBase)
    {
        kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Mission_Alien_Base);
        Alert(MakeAlert(eGA_AlienBase, kMission.m_iID));
    }
    else if (kMission.m_iMissionType == eMission_LandedUFO)
    {
        if (kMission.m_kDesc.m_strMapName == "EWI_HQAssault_MP (Airbase Defense)")
        {
            kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Interceptor);
        }
        else
        {
            kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Mission_UFO_Landed);
        }

        Alert(MakeAlert(eGA_UFOLanded, kMission.m_iID));
    }
    else if (kMission.m_iMissionType == eMission_Special)
    {
        kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Mission_Council);
    }
    else if (kMission.m_iMissionType == eMission_ExaltRaid)
    {
        kMission.SetEntity(Spawn(class'XGMissionEntity'), eEntityGraphic_Mission_Exalt_HQ);
    }
    else if (kMission.m_iMissionType == eMission_Final)
    {
        ClearAllMissions();
        kMissionControlUI = XGMissionControlUI(PRES().GetMgr(class'Highlander_XGMissionControlUI'));
        kMissionControlUI.UpdateView();
    }

    UpdateUI(0.0);
    DetermineMap(kMission);

    return kMission.m_iID;
}

function int Mod_Alert(TGeoscapeAlert kAlert)
{
    local HL_TModAlert kModAlert;

    kAlert.eType = MOD_ALERT_TYPE; // override whatever's passed in
    kModAlert.kAlert = kAlert;
    kModAlert.iAlertId = Rand(2000000000);
    arrModAlerts.AddItem(kModAlert);

    Alert(kAlert);

    return kModAlert.iAlertId;
}

function Init()
{
    UI = Spawn(class'Highlander_XGGeoscapeUI');
}

function InitNewGame()
{
    m_kDateTime = Spawn(class'Highlander_XGDateTime');
    m_kDateTime.SetTime(0, 0, 0, START_MONTH, START_DAY, START_YEAR);

    InitPlayer();

    m_arrCraftEncounters.Add(15);
}

event Tick(float fDeltaT)
{
    super.Tick(fDeltaT);
}