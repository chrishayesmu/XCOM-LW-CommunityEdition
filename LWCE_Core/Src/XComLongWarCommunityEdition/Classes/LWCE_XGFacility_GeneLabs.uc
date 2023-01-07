class LWCE_XGFacility_GeneLabs extends XGFacility_GeneLabs
    dependson(LWCETypes);

function GetEvents(out array<THQEvent> arrEvents)
{
    `LWCE_LOG_DEPRECATED_CLS(GetEvents);
}

function LWCE_GetEvents(out array<LWCE_THQEvent> arrEvents)
{
    local int iModTime, iEvent, iHours, iTotalHours;
    local LWCE_THQEvent kEvent;
    local bool bAdded;
    local array<int> arrEventTimes;
    local TGeneLabsPatient kPatient;

    foreach m_arrPatients(kPatient)
    {
        iTotalHours = 0;

        foreach kPatient.m_arrHoursLeft(iHours)
        {
            iTotalHours += iHours;
        }

        if (arrEventTimes.Find(iTotalHours) == INDEX_NONE)
        {
            arrEventTimes.AddItem(iTotalHours);
        }
    }

    for (iModTime = 0; iModTime < arrEventTimes.Length; iModTime++)
    {
        kEvent.EventType = 'GeneModification';
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

function Update()
{
    local int iPatient;
    local bool bPatientsCompleted, bIsTraining;
    local XGStrategySoldier kSoldier;
    local LWCE_XGStrategySoldier kCESoldier;
    local EPerkType ePerk, eOtherPerk;

    if (GEOSCAPE().IsPaused())
    {
        return;
    }

    for (iPatient = m_arrPatients.Length - 1; iPatient >= 0; iPatient--)
    {
        m_arrPatients[iPatient].m_arrHoursLeft[0] = Max(m_arrPatients[iPatient].m_arrHoursLeft[0] - 1, 0);

        if (m_arrPatients[iPatient].m_arrHoursLeft[0] == 0 && !GEOSCAPE().IsBusy())
        {
            kCESoldier = LWCE_XGStrategySoldier(m_arrPatients[iPatient].m_kSoldier);

            if (!LABS().m_bCompletedFirstGeneMod && m_arrPatients[iPatient].m_arrHoursLeft.Length == 1)
            {
                // TODO: rewrite this not to return after the narrative, so other gene mods can process in this update
                `ONLINEEVENTMGR.UnlockAchievement(AT_ALittleBitAlien);
                ePerk = m_arrPatients[iPatient].m_arrPendingGeneMods[0];
                kCESoldier.LWCE_GivePerk(ePerk, 'Innate', 'GeneMod');
                m_bDoingFirstNarrative = true;
                LABS().m_bCompletedFirstGeneMod = true;
                DoGeneModCinematic(kCESoldier, `XComNarrativeMomentEW("FirstGeneModSoldier"));
                return;
            }

            ePerk = m_arrPatients[iPatient].m_arrPendingGeneMods[0];
            eOtherPerk = kCESoldier.PERKS().GetOppositeGeneModPerk(ePerk);

            if (eOtherPerk != 0)
            {
                kCESoldier.RemovePerk(eOtherPerk, 'Innate', 'GeneMod');
            }

            kCESoldier.LWCE_GivePerk(ePerk, 'Innate', 'GeneMod');
            m_arrPatients[iPatient].m_arrPendingGeneMods.Remove(0, 1);
            m_arrPatients[iPatient].m_arrHoursLeft.Remove(0, 1);

            if (IsOptionEnabled(`LW_SECOND_WAVE_ID(MindHatesMatter)))
            {
                kCESoldier.m_bPsiTested = true;
            }

            if (class'LWCE_XComPerkManager'.static.LWCE_NumGeneMods(kCESoldier.m_kCEChar) > 4)
            {
                `ONLINEEVENTMGR.UnlockAchievement(AT_EnemyWithin);
                LABS().m_bEnemyWithinAchieved = true;
            }

            if (m_arrPatients[iPatient].m_arrPendingGeneMods.Length == 0)
            {
                PRES().Notify(eGA_GeneMod, kCESoldier.m_kCESoldier.iID);
                m_arrPatients.Remove(iPatient, 1);
                iPatient--;

                bPatientsCompleted = true;
                STORAGE().RestoreBackedUpInventory(kCESoldier);
                kCESoldier.SetStatus(eStatus_Active);
            }

            if (LABS().m_bCompletedFirstGeneMod && !m_bDoingFirstNarrative)
            {
                PendingNarrativeMoment = GetNarrativeForGeneMod(ePerk);

                if (PRES().GetTimesPlayed(PendingNarrativeMoment) == 0)
                {
                    if (ePerk != ePerk_GeneMod_IronSkin && ePerk != /* Smart Macrophages */ 155)
                    {
                        DoGeneModCinematic(kCESoldier, GetNarrativeForGeneMod(ePerk));
                    }
                }
                return;
            }
        }
    }

    if (bPatientsCompleted)
    {
        BARRACKS().ReorderRanks();
    }

    // Go through and make sure any soldiers who are done with their gene mods get set back to active
    foreach BARRACKS().m_arrSoldiers(kSoldier)
    {
        if (kSoldier.GetStatus() == eStatus_GeneMod)
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