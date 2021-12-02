class Highlander_XGObjectiveManager extends XGObjectiveManager;

function TSubObjective BuildSubObjective(ESubObjective eSubObj)
{
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
            iSubId = 13; // Research ID
            break;
        case eSubObj_ResearchShard:
            iSubId = 3; // Research ID
            break;
        case eSubObj_ResearchHyperwaveBeacon:
            iSubId = 7; // Research ID
            break;
        case eSubObj_ResearchFirestorm:
            iSubId = 5; // Research ID
            break;
        case eSubObj_ResearchPsionics:
            iSubId = 4; // Research ID
            break;
        case eSubObj_ResearchPsiLink:
            iSubId = 8; // Research ID
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
            if (`HL_LABS.IsResearched(iSubId))
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (`HL_LABS.HL_GetCurrentTech().iTechId == iSubId)
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
            else if (ENGINEERING().IsBuildingItem(EItemType(iSubId)))
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_ResearchArcThrower:
            if (`HL_LABS.IsResearched(`LW_TECH_ID(Xenoneurology)))
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
            else if (`HL_LABS.HL_GetCurrentTech().iTechId == `LW_TECH_ID(Xenoneurology))
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_CaptureLiveAlien:
            if (STORAGE().HasAlienCaptive() || `HL_LABS.HasInterrogatedCaptive())
            {
                kSub.eStatus = eObjStatus_Complete;
            }

            break;
        case eSubObj_InterrogateCaptive:
            if (`HL_LABS.HasInterrogatedCaptive())
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (`HL_LABS.IsInterrogationTech(`HL_LABS.HL_GetCurrentTech().iTechId))
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
            else if (PSILABS().m_arrTraining.Length > 0)
            {
                kSub.eStatus = eObjStatus_InProgress;
            }

            break;
        case eSubObj_DevelopPsiStrength:
            if (BARRACKS().m_kVolunteer != none || BARRACKS().HasPotentialVolunteer())
            {
                kSub.eStatus = eObjStatus_Complete;
            }
            else if (`HL_LABS.HL_GetCurrentTech().iTechId == `LW_TECH_ID(MindAndMachine))
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