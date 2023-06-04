class LWCE_XGObjectiveManager extends XGObjectiveManager;

function TSubObjective BuildSubObjective(ESubObjective eSubObj)
{
    local name SubName;
    local TSubObjective kSub;
    local LWCE_XGStorage kStorage;

    kStorage = LWCE_XGStorage(STORAGE());

    kSub = TECHTREE().GetSubObjective(eSubObj);
    kSub.eStatus = eObjStatus_NotStarted;

    switch (eSubObj)
    {
        case eSubObj_BuildAlienContainment:
            SubName = 'Facility_AlienContainment';
            break;
        case eSubObj_BuildHyperwaveUplink:
            SubName = 'Facility_HyperwaveRelay';
            break;
        case eSubObj_BuildPsiLabs:
            SubName = 'Facility_PsionicLabs';
            break;
        case eSubObj_BuildGollopChamber:
            SubName = 'Facility_GollopChamber';
            break;
        case eSubObj_BuildArcThrower:
            SubName = 'Tech_Xenogenetics';
            break;
        case eSubObj_ResearchShard:
            SubName = 'Tech_AlienOperations';
            break;
        case eSubObj_ResearchHyperwaveBeacon:
            SubName = 'Tech_AlienCommunications';
            break;
        case eSubObj_ResearchFirestorm:
            SubName = 'Tech_AlienPropulsion';
            break;
        case eSubObj_ResearchPsionics:
            SubName = 'Tech_Xenopsionics';
            break;
        case eSubObj_ResearchPsiLink:
            SubName = 'Tech_AlienCommandAndControl';
            break;
        case eSubObj_CaptureOutsider:
            SubName = 'Item_OutsiderShard';
            break;
        case eSubObj_BuildSkeletonKey:
            SubName = 'Item_SkeletonKey';
            break;
        case eSubObj_BuildFirestorm:
            SubName = 'Item_Firestorm';
            break;
        case eSubObj_AssaultOverseer:
            SubName = 'Item_EtherealDevice';
            break;
    }

    switch (eSubObj)
    {
        case eSubObj_BuildAlienContainment:
        case eSubObj_BuildHyperwaveUplink:
        case eSubObj_BuildPsiLabs:
        case eSubObj_BuildGollopChamber:
            if (LWCE_XGHeadquarters(HQ()).LWCE_HasFacility(SubName))
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (LWCE_XGFacility_Engineering(ENGINEERING()).LWCE_IsBuildingFacility(SubName))
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_BuildArcThrower:
        case eSubObj_ResearchShard:
        case eSubObj_ResearchHyperwaveBeacon:
        case eSubObj_ResearchFirestorm:
        case eSubObj_ResearchPsionics:
        case eSubObj_ResearchPsiLink:
            if (`LWCE_LABS.LWCE_IsResearched(SubName))
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (`LWCE_LABS.LWCE_GetCurrentTech() != none && `LWCE_LABS.LWCE_GetCurrentTech().GetTechName() == SubName)
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_CaptureOutsider:
        case eSubObj_BuildSkeletonKey:
        case eSubObj_BuildFirestorm:
        case eSubObj_AssaultOverseer:
            if (kStorage.LWCE_EverHadItem(SubName))
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (`LWCE_ENGINEERING.LWCE_IsBuildingItem(SubName))
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_ResearchArcThrower:
            if (`LWCE_LABS.LWCE_IsResearched('Tech_Xenoneurology'))
            {
                if (kStorage.LWCE_EverHadItem('Item_ArcThrower'))
                {
                    kSub.eStatus = eObjStatus_Complete;
                }
                else
                {
                    kSub.eStatus = eObjStatus_InProgress;
                }
            }
            else if (`LWCE_LABS.LWCE_GetCurrentTech() != none && `LWCE_LABS.LWCE_GetCurrentTech().GetTechName() == 'Tech_Xenoneurology')
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_CaptureLiveAlien:
            if (kStorage.HasAlienCaptive() || `LWCE_LABS.HasInterrogatedCaptive())
            {
                kSub.eStatus = eObjStatus_Complete;
            }

            break;
        case eSubObj_InterrogateCaptive:
            if (`LWCE_LABS.HasInterrogatedCaptive())
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (`LWCE_LABS.LWCE_GetCurrentTech() != none && `LWCE_LABS.LWCE_IsInterrogationTech(`LWCE_LABS.LWCE_GetCurrentTech().GetTechName()))
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_ObtainShards:
            if (SITROOM().IsCodeCracked())
            {
                kSub.eStatus = eObjStatus_Complete;
            }

            break;
        case eSubObj_AssaultAlienBase:
            if (kStorage.LWCE_EverHadItem('Item_HyperwaveBeacon'))
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (HANGAR().m_kSkyranger.m_kMission != none && HANGAR().m_kSkyranger.m_kMission.m_iMissionType == eMission_AlienBase)
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_DetectAnOverseer:
            if (LWCE_XGHeadquarters(HQ()).LWCE_HasFacility('Facility_HyperwaveRelay'))
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_ShootDownOverseer:
            if (GEOSCAPE().HasOverseerCrash() || kStorage.LWCE_EverHadItem('Item_EtherealDevice'))
            {
                kSub.eStatus = eObjStatus_Complete;
            }

            break;
        case eSubObj_TestTroops:
            if (BARRACKS().GetNumPsiSoldiers() > 0)
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (`LWCE_PSILABS.m_arrCETraining.Length > 0)
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_DevelopPsiStrength:
            if (BARRACKS().m_kVolunteer != none || BARRACKS().HasPotentialVolunteer())
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (`LWCE_LABS.LWCE_GetCurrentTech() != none && `LWCE_LABS.LWCE_GetCurrentTech().GetTechName() == 'Tech_MindAndMachine')
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_UseDevice:
            if (BARRACKS().m_kVolunteer != none)
            {
                kSub.eStatus = eObjStatus_Complete;
            }

            break;
    }

    return kSub;
}