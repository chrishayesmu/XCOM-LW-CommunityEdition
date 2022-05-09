class LWCE_XGFacility_CyberneticsLab extends XGFacility_CyberneticsLab;

function Update()
{
    LWCE_UpdatePatients();
    UpdateRepairingMecs();
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
    local TGeoscapeAlert kAlertData;
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
        m_arrPatients[iPatient].m_iHoursLeft = Max(m_arrPatients[iPatient].m_iHoursLeft - 1, 0);

        if (m_arrPatients[iPatient].m_iHoursLeft == 0 && !GEOSCAPE().IsBusy())
        {
            bPatientsCompleted = true;

            if (!Game().m_bCompletedFirstMec)
            {
                XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).UnlockAchievement(AT_WhoNeedsLimbs);
                Game().m_bCompletedFirstMec = true;
                MecCinematicSoldier = m_arrPatients[iPatient].m_kSoldier;
                GEOSCAPE().Pause();
                FirstMecCinematic();
                return;
            }

            kCESoldier = LWCE_XGStrategySoldier(m_arrPatients[iPatient].m_kSoldier);
            kCESoldier.LWCE_SetSoldierClass(eSC_Mec);

            kAlertData.eType = eGA_Augmentation;
            kAlertData.arrData[0] = m_arrPatients[iPatient].m_kSoldier.m_kSoldier.iID;
            GEOSCAPE().Alert(kAlertData);

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