class LWCE_XGShip_Dropship extends XGShip_Dropship;

struct CheckpointRecord_LWCE_XGShip_Dropship extends XGShip_Dropship.CheckpointRecord_XGShip_Dropship
{
    var LWCE_XGBase m_kAssignedBase;
    var name m_nmShipTemplate;
};

var LWCE_XGBase m_kAssignedBase;
var name m_nmShipTemplate; // Name of an LWCEShipTemplate which describes this ship's capabilities.

var LWCEShipTemplate m_kTemplate;

function Init(TShip kTShip)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

function LWCE_Init(name nmShipTemplate)
{
    m_nmShipTemplate = nmShipTemplate;
    m_kTemplate = `LWCE_SHIP(m_nmShipTemplate);

    m_iHP = GetHullStrength();
    SetEntity(Spawn(class'LWCE_XGShipEntity'), eEntityGraphic_Skyranger);

    m_kGeoscape = GEOSCAPE();
    InitWatchVariables();

    CargoInfo = Spawn(class'LWCE_XGDropshipCargoInfo');
    LWCE_XGDropshipCargoInfo(CargoInfo).Init();

    m_arrUpgrades.Add(3);
    m_iCapacity = class'XGTacticalGameCore'.default.SKYRANGER_CAPACITY;

    InitSound();
}

function ApplyCheckpointRecord()
{
    m_kTemplate = `LWCE_SHIP(m_nmShipTemplate);
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

function int GetHullStrength()
{
    return m_kTemplate.iHealth;
}

function int GetRange()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetRange);

    return -100;
}

function int GetSpeed()
{
    return m_kTemplate.iSpeed;
}

function EShipType GetType()
{
    `LWCE_LOG_DEPRECATED_BY(GetType, m_nmShipTemplate);

    return EShipType(0);
}

function array<TShipWeapon> GetWeapons()
{
    local array<TShipWeapon> arrWeapons;

    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetWeapons);

    arrWeapons.Length = 0;

    return arrWeapons;
}

function bool IsDamaged()
{
    return m_iHP < GetHullStrength();
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

function ReturnToBase()
{
    local LWCE_XGMission_ReturnToBase kMission;

    if (m_kMission != none && m_kMission.IsA('LWCE_XGMission_ReturnToBase'))
    {
        `LWCE_LOG_VERBOSE("Skyranger ordered to return-to-base, but already on an RTB mission");
        return;
    }

    kMission = Spawn(class'LWCE_XGMission_ReturnToBase');
    kMission.Init('ReturnToBase');
    kMission.m_v2Coords = m_kAssignedBase.GetCoords();
    kMission.m_kDesc.m_kDropShipCargoInfo = CargoInfo;

    SetMission(kMission);
}

function SetMission(XGMission kMission)
{
    if (m_kMission != none && m_kMission.IsA('LWCE_XGMission_ReturnToBase'))
    {
        `LWCE_LOG_VERBOSE("Destroying Skyranger's current return-to-base mission: " $ m_kMission);
        m_kMission.Destroy();
    }

    m_kMission = kMission;

    if (kMission != none)
    {
        m_v2Destination = kMission.m_v2Coords;
    }
    else
    {
        m_v2Destination = m_v2Coords;
    }
}