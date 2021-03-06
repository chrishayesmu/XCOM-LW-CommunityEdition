class LWCE_XGObjectiveManager extends XGObjectiveManager;

function TSubObjective BuildSubObjective(ESubObjective eSubObj)
{
    local name SubName;
    local int iSubId;
    local TSubObjective kSub;

    kSub = TECHTREE().GetSubObjective(eSubObj);
    kSub.eStatus = eObjStatus_NotStarted;
    iSubId = 0; // Stores a facility, item, or tech ID depending on the objective

    switch (eSubObj)
    {
        case eSubObj_BuildAlienContainment:
            iSubId = 13; // Facility ID
            break;
        case eSubObj_BuildHyperwaveUplink:
            iSubId = 18; // Facility ID
            break;
        case eSubObj_BuildPsiLabs:
            iSubId = 17; // Facility ID
            break;
        case eSubObj_BuildGollopChamber:
            iSubId = 19; // Facility ID
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
            iSubId = 183; // Item ID
            break;
        case eSubObj_BuildSkeletonKey:
            iSubId = 184; // Item ID
            break;
        case eSubObj_BuildFirestorm:
            iSubId = 104; // Item ID
            break;
        case eSubObj_AssaultOverseer:
            iSubId = 180; // Item ID
            break;
    }

    switch (eSubObj)
    {
        case eSubObj_BuildAlienContainment:
        case eSubObj_BuildHyperwaveUplink:
        case eSubObj_BuildPsiLabs:
        case eSubObj_BuildGollopChamber:
            if (HQ().HasFacility(iSubId))
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (ENGINEERING().IsBuildingFacility(EFacilityType(iSubId)))
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
            if (STORAGE().EverHadItem(iSubId))
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (`LWCE_ENGINEERING.LWCE_IsBuildingItem(iSubId))
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_ResearchArcThrower:
            if (`LWCE_LABS.LWCE_IsResearched('Tech_Xenoneurology'))
            {
                if (STORAGE().m_arrItemArchives[eItem_ArcThrower] > 0)
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
            if (STORAGE().HasAlienCaptive() || `LWCE_LABS.HasInterrogatedCaptive())
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
            if (STORAGE().EverHadItem(eItem_HyperwaveBeacon))
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (HANGAR().m_kSkyranger.m_kMission != none && HANGAR().m_kSkyranger.m_kMission.m_iMissionType == eMission_AlienBase)
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_DetectAnOverseer:
            if (HQ().HasFacility(eFacility_HyperwaveRadar))
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_ShootDownOverseer:
            if (GEOSCAPE().HasOverseerCrash() || STORAGE().EverHadItem(eItem_PsiLink))
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