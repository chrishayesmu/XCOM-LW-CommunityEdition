class Highlander_XGFacility_Hangar extends XGFacility_Hangar;

function AddDropship()
{
    if (m_kSkyranger == none)
    {
        m_kSkyranger = Spawn(class'Highlander_XGShip_Dropship');
        m_kSkyranger.Init(ITEMTREE().GetShip(eShip_Skyranger));
        m_kSkyranger.m_strCallsign = m_strCallsignSkyranger;
    }
}

function LandDropship(XGShip_Dropship kSkyranger)
{
    local Highlander_XGFacility_Labs kLabs;
    local array<HL_TTechState> arrPreLandTechs, arrPostLandTechs;
    local TMissionReward kEmptyReward;

    kLabs = `HL_LABS;

    arrPreLandTechs = kLabs.HL_GetCurrentTechStates();
    UnloadArtifacts(kSkyranger);

    if (kSkyranger.CargoInfo.m_iBattleResult == eResult_Victory)
    {
        if (RewardIsValid(kSkyranger.CargoInfo.m_kReward))
        {
            GiveMissionReward(kSkyranger);
            HQ().m_kLastReward = kSkyranger.CargoInfo.m_kReward;
        }
    }

    arrPostLandTechs = kLabs.HL_GetCurrentTechStates();
    kLabs.HL_CompilePostMissionReport(arrPreLandTechs, arrPostLandTechs);

    BARRACKS().LandSoldiers(kSkyranger);
    kSkyranger.CargoInfo.m_kReward = kEmptyReward;
    GEOSCAPE().Resume();

    if (ISCONTROLLED() && Game().GetNumMissionsTaken() == 1)
    {
        kLabs.m_arrMissionResults.Remove(0, kLabs.m_arrMissionResults.Length);
    }
}