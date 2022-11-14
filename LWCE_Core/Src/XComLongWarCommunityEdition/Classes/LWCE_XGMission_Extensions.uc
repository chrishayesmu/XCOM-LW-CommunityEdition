class LWCE_XGMission_Extensions extends Object
    abstract;

static function GenerateBattleDescription(XGMission kSelf)
{
    local LWCE_TMissionReward kReward;

    if (kSelf.m_kDesc.m_strOpName == "")
    {
        GetMissionRewards(kSelf, kReward);

        if (kSelf.m_arrArtifacts.Length < 255)
        {
            kSelf.m_arrArtifacts.Add(255 - kSelf.m_arrArtifacts.Length);
        }

        kSelf.m_kDesc.m_iMissionID = kSelf.m_iID;
        kSelf.m_kDesc.m_strOpName = kSelf.GenerateOpName(kSelf.m_kDesc.m_bIsTutorial && kSelf.m_kDesc.m_bDisableSoldierChatter);
        kSelf.m_kDesc.m_strLocation = kSelf.GetLocationString();
        kSelf.m_kDesc.m_iMissionType = kSelf.m_iMissionType;

        if (kSelf.m_iMissionType == eMission_Crash)
        {
            kSelf.m_kDesc.m_eUFOType = EShipType(XGMission_UFOCrash(kSelf).m_iUFOType);
        }
        else if (kSelf.m_iMissionType == eMission_LandedUFO)
        {
            kSelf.m_kDesc.m_eUFOType = XGMission_UFOLanded(kSelf).kUFO.m_kTShip.eType;
        }

        kSelf.m_kDesc.m_arrArtifacts = kSelf.m_arrArtifacts;
        kSelf.m_kDesc.m_iPodGroup = 0;
        kSelf.m_kDesc.m_strObjective = kSelf.m_strObjective;
        kSelf.m_kDesc.m_strDesc = kSelf.GetTitle();
        kSelf.m_kDesc.m_iDifficulty = kSelf.Game().GetDifficulty();
        kSelf.m_kDesc.m_iLowestDifficulty = kSelf.Game().m_iLowestDifficulty;

        LWCE_XGBattleDesc(kSelf.m_kDesc).m_kArtifactsContainer.m_arrEntries = kReward.arrItems;
    }

    kSelf.m_kDesc.m_strTime = kSelf.CalcTime();
}

static function bool GetMissionRewards(XGMission kMission, out LWCE_TMissionReward kReward)
{
    if (LWCE_XGMission_Abduction(kMission) != none)
    {
        kReward = LWCE_XGMission_Abduction(kMission).m_kCEReward;
        return true;
    }
    else if (LWCE_XGMission_AlienBase(kMission) != none)
    {
        kReward = LWCE_XGMission_AlienBase(kMission).m_kCEReward;
        return true;
    }
    else if (LWCE_XGMission_CaptureAndHold(kMission) != none)
    {
        kReward = LWCE_XGMission_CaptureAndHold(kMission).m_kCEReward;
        return true;
    }
    else if (LWCE_XGMission_CovertOpsExtraction(kMission) != none)
    {
        kReward = LWCE_XGMission_CovertOpsExtraction(kMission).m_kCEReward;
        return true;
    }
    else if (LWCE_XGMission_ExaltRaid(kMission) != none)
    {
        kReward = LWCE_XGMission_ExaltRaid(kMission).m_kCEReward;
        return true;
    }
    else if (LWCE_XGMission_FundingCouncil(kMission) != none)
    {
        kReward = LWCE_XGMission_FundingCouncil(kMission).m_kCEReward;
        return true;
    }
    else if (LWCE_XGMission_HQAssault(kMission) != none)
    {
        kReward = LWCE_XGMission_HQAssault(kMission).m_kCEReward;
        return true;
    }
    else if (LWCE_XGMission_TempleShip(kMission) != none)
    {
        kReward = LWCE_XGMission_TempleShip(kMission).m_kCEReward;
        return true;
    }
    else if (LWCE_XGMission_Terror(kMission) != none)
    {
        kReward = LWCE_XGMission_Terror(kMission).m_kCEReward;
        return true;
    }
    else if (LWCE_XGMission_UFOCrash(kMission) != none)
    {
        kReward = LWCE_XGMission_UFOCrash(kMission).m_kCEReward;
        return true;
    }
    else if (LWCE_XGMission_UFOLanded(kMission) != none)
    {
        kReward = LWCE_XGMission_UFOLanded(kMission).m_kCEReward;
        return true;
    }

    return false;
}

static function SetMissionRewards(XGMission kMission, const LWCE_TMissionReward kReward)
{
    if (LWCE_XGMission_Abduction(kMission) != none)
    {
        LWCE_XGMission_Abduction(kMission).m_kCEReward = kReward;
    }
    else if (LWCE_XGMission_AlienBase(kMission) != none)
    {
        LWCE_XGMission_AlienBase(kMission).m_kCEReward = kReward;
    }
    else if (LWCE_XGMission_CaptureAndHold(kMission) != none)
    {
        LWCE_XGMission_CaptureAndHold(kMission).m_kCEReward = kReward;
    }
    else if (LWCE_XGMission_CovertOpsExtraction(kMission) != none)
    {
        LWCE_XGMission_CovertOpsExtraction(kMission).m_kCEReward = kReward;
    }
    else if (LWCE_XGMission_ExaltRaid(kMission) != none)
    {
        LWCE_XGMission_ExaltRaid(kMission).m_kCEReward = kReward;
    }
    else if (LWCE_XGMission_FundingCouncil(kMission) != none)
    {
        LWCE_XGMission_FundingCouncil(kMission).m_kCEReward = kReward;
    }
    else if (LWCE_XGMission_HQAssault(kMission) != none)
    {
        LWCE_XGMission_HQAssault(kMission).m_kCEReward = kReward;
    }
    else if (LWCE_XGMission_TempleShip(kMission) != none)
    {
        LWCE_XGMission_TempleShip(kMission).m_kCEReward = kReward;
    }
    else if (LWCE_XGMission_Terror(kMission) != none)
    {
        LWCE_XGMission_Terror(kMission).m_kCEReward = kReward;
    }
    else if (LWCE_XGMission_UFOCrash(kMission) != none)
    {
        LWCE_XGMission_UFOCrash(kMission).m_kCEReward = kReward;
    }
    else if (LWCE_XGMission_UFOLanded(kMission) != none)
    {
        LWCE_XGMission_UFOLanded(kMission).m_kCEReward = kReward;
    }
}