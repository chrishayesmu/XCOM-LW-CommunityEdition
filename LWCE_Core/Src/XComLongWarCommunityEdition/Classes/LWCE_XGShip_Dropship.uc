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

function BuildTransferData()
{
    local TTransferSoldier kTransfer;
    local XGStrategySoldier kSoldier;
    local LWCE_XGStrategySoldier kCESoldier;
    local LWCE_XGDropshipCargoInfo kCargoInfo;

    kCargoInfo = LWCE_XGDropshipCargoInfo(CargoInfo);

    `LWCE_LOG_CLS("Building transfer data for mission. We have " $ m_arrSoldiers.Length $ " soldiers to build");
    `LWCE_LOG_CLS("Barracks contains " $ BARRACKS().m_arrSoldiers.Length $ " soldiers");

    BARRACKS().MarkWussySoldiers(self);

    // Transfer LWCE data into the dropship. Make sure to do so after vanilla data is done
    // being written, since we're syncing from that data to form our own.
    foreach m_arrSoldiers(kSoldier)
    {
        kCESoldier = LWCE_XGStrategySoldier(kSoldier);
        kTransfer = kCESoldier.BuildTransferSoldier();

        kCargoInfo.m_arrSoldiers.AddItem(kTransfer);
        kCargoInfo.m_arrCESoldiers.AddItem(kCESoldier.LWCE_BuildTransferSoldier(kTransfer));
    }

    if (m_kCovertOperative != none)
    {
        kCESoldier = LWCE_XGStrategySoldier(m_kCovertOperative);
        kCargoInfo.m_kCovertOperative = kCESoldier.BuildTransferSoldier();

        if (kCESoldier.HasPsiGift())
        {
            if (!class'LWCEInventoryUtils'.static.HasItemOfName(kCESoldier.m_kCEChar.kInventory, 'Item_PsiAmp'))
            {
                class'LWCEInventoryUtils'.static.AddCustomItem(kCESoldier.m_kCEChar.kInventory, 'Item_PsiAmp');
            }
        }

        kCargoInfo.m_kCovertOperative.kChar.aUpgrades[/* EXALT Comm Hack */ 151] = 1;
        kCargoInfo.m_bHasCovertOperative = true;

        kCargoInfo.m_kCECovertOperative = kCESoldier.LWCE_BuildTransferSoldier(kCargoInfo.m_kCovertOperative);
    }
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
        if (`LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_SuperSkyranger'))
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

function ReconstructTransferData()
{
    local int I;
    local LWCE_XGStrategySoldier kSoldier;
    local LWCE_XGDropshipCargoInfo kCargoInfo;

    kCargoInfo = LWCE_XGDropshipCargoInfo(CargoInfo);

    `LWCE_LOG_CLS("ReconstructTransferData: kCargoInfo.m_arrCESoldiers.Length = " $ kCargoInfo.m_arrCESoldiers.Length $ ", kCargoInfo.m_arrSoldiers.Length = " $ kCargoInfo.m_arrSoldiers.Length);

    for (I = 0; I < kCargoInfo.m_arrCESoldiers.Length; I++)
    {
        `LWCE_LOG_CLS("Soldier " $ I $ " has ID " $ kCargoInfo.m_arrCESoldiers[I].kSoldier.iID);
        kSoldier = LWCE_XGStrategySoldier(BARRACKS().GetSoldierByID(kCargoInfo.m_arrCESoldiers[I].kSoldier.iID));
        kSoldier.LWCE_RebuildAfterCombat(kCargoInfo.m_arrSoldiers[I], kCargoInfo.m_arrCESoldiers[I]);
    }

    if (m_kCovertOperative != none)
    {
        kSoldier = LWCE_XGStrategySoldier(m_kCovertOperative);
        kSoldier.LWCE_RebuildAfterCombat(kCargoInfo.m_kCovertOperative, kCargoInfo.m_kCECovertOperative);
    }

    kCargoInfo.m_arrSoldiers.Remove(0, kCargoInfo.m_arrSoldiers.Length);
    kCargoInfo.m_arrCESoldiers.Remove(0, kCargoInfo.m_arrCESoldiers.Length);
}