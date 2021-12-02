class Highlander_XGFundingCouncil extends XGFundingCouncil;

function XGMission_FundingCouncil CreateMission(TFCMission MissionData)
{
    local XGMission_FundingCouncil kMission;
    local XGCountry kCountry;
    local ECharacter eChar;
    local XGDateTime kDateTime;
    local int iDaysSinceStart, iClass, iLevel, I;
    local float fReward;

    kDateTime = Spawn(class'Highlander_XGDateTime');
    kDateTime.SetTime(0, 0, 0, START_MONTH, START_DAY, START_YEAR);
    iDaysSinceStart = kDateTime.DifferenceInDays(GEOSCAPE().m_kDateTime);

    if (iDaysSinceStart < MISSION_REWARD_LOW_DAYS)
    {
        fReward = MISSION_REWARD_LOW_MULT;
    }
    else if (iDaysSinceStart < MISSION_REWARD_MED_DAYS)
    {
        fReward = MISSION_REWARD_MED_MULT;
    }
    else
    {
        fReward = 1.0;
    }

    if (fReward != float(1))
    {
        for (I = 0; I < MissionData.arrRewards.Length; I++)
        {
            switch (MissionData.arrRewards[I])
            {
                case eFCReward_Money:
                case eFCReward_Engineer:
                case eFCReward_Scientist:
                    MissionData.arrRewardAmounts[I] *= fReward;

                    if (MissionData.arrRewardAmounts[I] < 1)
                    {
                        MissionData.arrRewardAmounts[I] = 1;
                    }

                    break;

                case eFCReward_Soldier:
                    if (!MissionData.bExplicitSoldier)
                    {
                        iClass = MissionData.arrRewardAmounts[I] / 100;

                        if (iDaysSinceStart < MISSION_REWARD_LOW_DAYS)
                        {
                            iLevel = MISSION_REWARD_SOLDIER_LOW_LEVEL;
                        }
                        else if (iDaysSinceStart < MISSION_REWARD_MED_DAYS)
                        {
                            iLevel = MISSION_REWARD_SOLDIER_MED_LEVEL;
                        }
                        else
                        {
                            iLevel = MISSION_REWARD_SOLDIER_HIGH_LEVEL;
                        }

                        MissionData.arrRewardAmounts[I] = RewardSoldier(iClass, iLevel);
                    }

                    break;
            }
        }
    }

    kMission = Spawn(class'XGMission_FundingCouncil');
    kMission.m_kTMission = MissionData;
    kCountry = Country(kMission.m_kTMission.ECountry);

    if (kMission.m_kTMission.eMission == eFCM_ChryssalidHive)
    {
        kMission.m_iCity = eCity_StJohns;
    }
    else
    {
        kMission.m_iCity = kCountry.GetRandomCity();
    }

    kMission.m_kDesc = Spawn(class'Highlander_XGBattleDesc').Init();
    kMission.m_iCountry = kCountry.GetID();
    kMission.m_iContinent = kCountry.GetContinent();
    kMission.m_iDuration = class'XGTacticalGameCore'.default.ABDUCTION_TIMER;
    kMission.m_v2Coords = CITY(kMission.m_iCity).m_v2Coords;
    kMission.m_iDetectedBy = 0;
    kMission.m_iMissionType = eMission_Special;
    kMission.m_kDesc.m_eCouncilType = kMission.m_kTMission.eMission;

    eChar = eChar_Thinman;
    switch (kMission.m_kTMission.eMission)
    {
        case eFCM_TruckStopAssault:
            eChar = eChar_Sectoid;
            break;
        case eFCM_HeliAssault:
            eChar = eChar_Muton;
            break;
    }

    kMission.m_kDesc.m_kAlienSquad = AI().DetermineSpecialMissionSquad(eChar, kMission.m_kTMission.eMission, kMission.m_kTMission.eType == eFCMType_Assault);

    if (ISCONTROLLED())
    {
        kMission.m_kDesc.m_bIsTutorial = true;
    }

    m_iLastAddedMissionID = GEOSCAPE().AddMission(kMission);
    kDateTime.Destroy();
    return kMission;
}