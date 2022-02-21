class LWCE_XGShip_Dropship extends XGShip_Dropship;

function Init(TShip kTShip)
{
    super(XGShip).Init(kTShip);

    CargoInfo = Spawn(class'LWCE_XGDropshipCargoInfo');
    LWCE_XGDropshipCargoInfo(CargoInfo).Init();

    m_arrUpgrades.Add(3);
    m_iCapacity = class'XGTacticalGameCore'.default.SKYRANGER_CAPACITY;

    InitSound();
}

function int GetCapacity()
{
    local int iCapacity;

    iCapacity = m_iCapacity;

    if (BARRACKS().HasOTSUpgrade(/* Squad Size */ 1) || IsOptionEnabled(`LW_SECOND_WAVE_ID(WeAreLegion)))
    {
        ++iCapacity;
    }

    if (BARRACKS().HasOTSUpgrade(/* Squad Size II */ 2) || IsOptionEnabled(`LW_SECOND_WAVE_ID(WeAreLegion)))
    {
        ++iCapacity;
    }

    if (m_bExtendSquadForHQAssault)
    {
        iCapacity = HQASSAULT_REINFORCEMENT_CAPACITY;
        Clamp(iCapacity, 8, 12);
    }

    if (m_bReinforcementsForHQAssault)
    {
        iCapacity = 14;
    }

    if (HANGAR().m_kSkyranger != none && HANGAR().m_kSkyranger.m_kMission != none)
    {
        if (ENGINEERING().IsFoundryTechResearched(`LW_FOUNDRY_ID(SuperSkyranger)))
        {
            if (HANGAR().m_kSkyranger.m_kMission.m_iMissionType == eMission_AlienBase)
            {
                iCapacity += 2;
            }

            if (HANGAR().m_kSkyranger.m_kMission.m_iMissionType == eMission_ExaltRaid)
            {
                iCapacity += 2;
            }

            if (HANGAR().m_kSkyranger.m_kMission.m_iMissionType == eMission_Final)
            {
                iCapacity += 4;
            }
        }

        if (HANGAR().m_kSkyranger.m_kMission.m_iMissionType == eMission_CovertOpsExtraction)
        {
            iCapacity = 4;
        }

        if (IsOptionEnabled(`LW_SECOND_WAVE_ID(WeAreLegion)))
        {
            if (HANGAR().m_kSkyranger.m_kMission.m_iMissionType == eMission_CovertOpsExtraction)
            {
                iCapacity += 2;
            }
        }

        // LWCE: moved this if statement inside the current one, to avoid a null access on starting a new game
        if (HANGAR().m_kSkyranger.m_kMission.m_iMissionType != eMission_HQAssault)
        {
            if (iCapacity > 12)
            {
                iCapacity = 12;
            }
        }
    }

    return iCapacity;
}