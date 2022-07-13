class LWCE_XGFacility_CyberneticsLab extends XGFacility_CyberneticsLab
    dependson(LWCETypes);

function Update()
{
    LWCE_UpdatePatients();
    UpdateRepairingMecs();
}

function GetEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEvents);
}

function LWCE_GetEvents(out array<LWCE_THQEvent> arrEvents)
{
    LWCE_GetPatientEvents(arrEvents);
    LWCE_GetRepairingMecEvents(arrEvents);
}

function LWCE_GetPatientEvents(out array<LWCE_THQEvent> arrEvents)
{
    local int iModTime, iEvent;
    local LWCE_THQEvent kEvent;
    local bool bAdded;
    local array<int> arrEventTimes;
    local TCyberneticsLabPatient kPatient;

    foreach m_arrPatients(kPatient)
    {
        if (arrEventTimes.Find(kPatient.m_iHoursLeft) == INDEX_NONE)
        {
            arrEventTimes.AddItem(kPatient.m_iHoursLeft);
        }
    }

    for (iModTime = 0; iModTime < arrEventTimes.Length; iModTime++)
    {
        kEvent.EventType = 'CyberneticModification';
        kEvent.iHours = arrEventTimes[iModTime];

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

function LWCE_GetRepairingMecEvents(out array<LWCE_THQEvent> arrEvents)
{
    local int iRepairTime, iEvent;
    local bool bAdded;
    local array<int> arrEventTimes;
    local LWCE_TData kData;
    local LWCE_THQEvent kBlankEvent, kEvent;
    local TCyberneticsLabRepairingMec kMec;

    foreach m_arrRepairingMecs(kMec)
    {
        if (arrEventTimes.Find(kMec.m_iHoursLeft) == INDEX_NONE)
        {
            arrEventTimes.AddItem(kMec.m_iHoursLeft);
        }
    }

    for (iRepairTime = 0; iRepairTime < m_arrRepairingMecs.Length; iRepairTime++)
    {
        kEvent = kBlankEvent;
        kEvent.EventType = 'MecRepair';
        kEvent.iHours = m_arrRepairingMecs[iRepairTime].m_iHoursLeft;

        kData.eType = eDT_Int;
        kData.iData = m_arrRepairingMecs[iRepairTime].m_eMecItem;
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

function MecCinematicComplete()
{
    local XComHumanPawn kPawn;

    class'XComMapManager'.static.RemoveStreamingMapByName("Addon_CyberneticsLab_CAP");
    MecCinematicSoldier.SetStatus(eStatus_Active);

    kPawn = XComHumanPawn(MecCinematicSoldier.m_kPawn);
    kPawn.Mesh.SetPhysicsAsset(MecCinematicPhysics, true);

    MecCinematicSoldier = none;

    GEOSCAPE().Resume();
    LWCE_UpdatePatients();
}

function LWCE_UpdatePatients()
{
    local LWCE_TData kData;
    local LWCE_TGeoscapeAlert kAlert, kBlankAlert;
    local int iPatient;
    local bool bPatientsCompleted, bIsTraining;
    local XGStrategySoldier kSoldier;
    local LWCE_XGStrategySoldier kCESoldier;

    if (GEOSCAPE().IsPaused())
    {
        return;
    }

    iPatient = m_arrPatients.Length - 1;

    while (iPatient >= 0)
    {
        kAlert = kBlankAlert;
        kAlert.AlertType = 'Augmentation';

        m_arrPatients[iPatient].m_iHoursLeft = Max(m_arrPatients[iPatient].m_iHoursLeft - 1, 0);

        if (m_arrPatients[iPatient].m_iHoursLeft == 0 && !GEOSCAPE().IsBusy())
        {
            bPatientsCompleted = true;

            if (!Game().m_bCompletedFirstMec)
            {
                Achieve(AT_WhoNeedsLimbs);
                Game().m_bCompletedFirstMec = true;
                MecCinematicSoldier = m_arrPatients[iPatient].m_kSoldier;
                GEOSCAPE().Pause();
                FirstMecCinematic();
                return;
            }

            kCESoldier = LWCE_XGStrategySoldier(m_arrPatients[iPatient].m_kSoldier);
            kCESoldier.LWCE_SetSoldierClass(eSC_Mec);

            kData.eType = eDT_Int;
            kData.iData = m_arrPatients[iPatient].m_kSoldier.m_kSoldier.iID;
            kAlert.arrData.AddItem(kData);

            LWCE_XGGeoscape(GEOSCAPE()).LWCE_Alert(kAlert);

            m_arrPatients.Remove(iPatient, 1);
        }

        iPatient--;
    }

    if (bPatientsCompleted)
    {
        BARRACKS().ReorderRanks();
    }

    foreach BARRACKS().m_arrSoldiers(kSoldier)
    {
        if (kSoldier.GetStatus() == eStatus_Augmenting)
        {
            bIsTraining = false;

            for (iPatient = 0; iPatient < m_arrPatients.Length; iPatient++)
            {
                if (kSoldier == m_arrPatients[iPatient].m_kSoldier)
                {
                    bIsTraining = true;
                    break;
                }
            }

            if (!bIsTraining)
            {
                kSoldier.SetStatus(eStatus_Active);
            }
        }
    }
}