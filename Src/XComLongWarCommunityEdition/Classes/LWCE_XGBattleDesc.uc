class LWCE_XGBattleDesc extends XGBattleDesc;

struct CheckpointRecord_LWCE_XGBattleDesc extends XGBattleDesc.CheckpointRecord
{
    var LWCEItemContainer m_kArtifactsContainer;
    var array<XGItem> arrRecordedItems;
    var array<string> arrItemStrings;
};

var LWCEItemContainer m_kArtifactsContainer;
var array<XGItem> arrRecordedItems;
var array<string> arrItemStrings;

function LWCE_XGBattleDesc Init()
{
    `LWCE_LOG_CLS("Initializing battle desc");

    if (m_kArtifactsContainer == none)
    {
        m_kArtifactsContainer = Spawn(class'LWCEItemContainer');
    }

    if (m_arrArtifacts.Length == 0)
    {
        m_arrArtifacts.Add(1);
    }

    return self;
}

function CreateCheckpointRecord()
{
    local XGItem kItem;

    arrRecordedItems.Remove(0, arrRecordedItems.Length);
    arrItemStrings.Remove(0, arrItemStrings.Length);

    foreach AllActors(class'XGItem', kItem)
    {
        arrRecordedItems.AddItem(kItem);
        arrItemStrings.AddItem(kItem.m_strUIImage);
    }

    `LWCE_LOG_CLS("CreateCheckpointRecord: Recorded " $ arrRecordedItems.Length $ " items to persist");
}

function ApplyCheckpointRecord()
{
    local int Index;

    for (Index = 0; Index < arrRecordedItems.Length; Index++)
    {
        // Items don't persist into strategy layer, so need to check first
        if (arrRecordedItems[Index] != none)
        {
            arrRecordedItems[Index].m_strUIImage = arrItemStrings[Index];
        }
    }

    `LWCE_LOG_CLS("ApplyCheckpointRecord: Loaded " $ arrRecordedItems.Length $ " item IDs");
}

function TSoldierPawnContent BuildAlienContent(ECharacter AlienType, optional EItemType eAltWeapon = 0)
{
    `LWCE_LOG_DEPRECATED_CLS(BuildAlienContent);
    return super.BuildAlienContent(AlienType, eAltWeapon);
}

function TSoldierPawnContent LWCE_BuildAlienContent(int AlienType, optional int eAltWeapon = 0)
{
    local TSoldierPawnContent Alien;
    local ELoadoutTypes eLoadout;
    local LoadoutTemplate Loadout;
    local bool bUseAltLoadout;

    bUseAltLoadout = eAltWeapon != 0;

    if (AlienType == eChar_Mechtoid_Alt)
    {
        AlienType = eChar_Mechtoid;
    }

    eLoadout = class'XGLoadoutMgr'.static.GetLoadoutTemplateFromCharacter(ECharacter(AlienType), bUseAltLoadout);
    class'XGLoadoutMgr'.static.GetLoadoutTemplate(eLoadout, Loadout);
    Alien = LWCE_BuildAlienContentFromLoadout(Loadout, 0, eGender_Male);
    Alien.iPawn = class'XGGameData'.static.MapCharacterToPawn(ECharacter(AlienType));
    return Alien;
}

function TSoldierPawnContent BuildAlienContentFromLoadout(const out LoadoutTemplate Loadout, EItemType eArmor, EGender eGen)
{
    `LWCE_LOG_DEPRECATED_CLS(BuildAlienContentFromLoadout);
    return super.BuildAlienContentFromLoadout(Loadout, eArmor, eGen);
}

function TSoldierPawnContent LWCE_BuildAlienContentFromLoadout(const out LoadoutTemplate Loadout, int iArmorItemId, int iGender)
{
    local TSoldierPawnContent UnitContent;
    local int PrimaryWeapon;

    PrimaryWeapon = `GAMECORE.GetPrimaryWeapon(Loadout.Inventory);
    UnitContent.iPawn = MapSoldierToPawn(iArmorItemId, iGender, false);
    UnitContent.iKit = class'XComContentManager'.static.MapArmorAndWeaponToArmorKit(EItemType(iArmorItemId), EItemType(PrimaryWeapon));
    UnitContent.kAppearance.iHead = 6;
    UnitContent.kInventory = Loadout.Inventory;
    UnitContent.kInventory.iArmor = iArmorItemId;
    return UnitContent;
}

function TSoldierPawnContent BuildUnitContentFromEnums(EItemType eWeapon, EItemType ePistol, EItemType eArmor, EItemType eItem, EGender eGen, bool bGeneMods)
{
    `LWCE_LOG_DEPRECATED_CLS(BuildUnitContentFromEnums);

    return super.BuildUnitContentFromEnums(eWeapon, ePistol, eArmor, eItem, eGen, bGeneMods);
}

function TSoldierPawnContent LWCE_BuildUnitContentFromEnums(int iWeaponItemId, int iPistolItemId, int iArmorItemId, int iItemId, int iGender, bool bGeneMods)
{
    local TSoldierPawnContent UnitContent;

    UnitContent.iPawn = MapSoldierToPawn(iArmorItemId, iGender, bGeneMods);
    UnitContent.iKit = class'XComContentManager'.static.MapArmorAndWeaponToArmorKit(EItemType(iArmorItemId), EItemType(iWeaponItemId));
    UnitContent.kAppearance.iHead = 6;
    `GAMECORE.TInventoryLargeItemsAddItem(UnitContent.kInventory, iWeaponItemId);
    `GAMECORE.TInventorySmallItemsAddItem(UnitContent.kInventory, iItemId);
    UnitContent.kInventory.iArmor = iArmorItemId;
    return UnitContent;
}

function Generate(optional bool bSkipDropshipCargoInfo = false)
{
    local XComMapMetaData MapData;

    if (m_kArtifactsContainer == none)
    {
        m_kArtifactsContainer = Spawn(class'LWCEItemContainer');
    }

    m_bOvermindEnabled = true;
    MapData = class'XComMapManager'.static.GetCurrentMapMetaData();
    m_iMissionType = MapData.MissionType;

    if (MapData.MapFamily == 'EWI_MeldTutorial')
    {
        m_eCouncilType = eFCM_MeldTutorial;
    }

    GenerateOpName();
    GenerateLocation();
    GenerateStartTime();
    GenerateAliens();
    GenerateLoot();

    if (!bSkipDropshipCargoInfo)
    {
        GenerateDropshipCargoInfo();
    }
}

function GenerateDropshipCargoInfo()
{
    m_kDropShipCargoInfo = Spawn(class'LWCE_XGDropshipCargoInfo');
}

function InitAlienLoadoutInfos()
{
    local int PlayerIndex, iAlienPods;

    for (PlayerIndex = 0; PlayerIndex < 4; PlayerIndex++)
    {
        if (m_arrTeamLoadoutInfos[PlayerIndex].m_eTeam == eTeam_Alien)
        {
            return;
        }

        if (m_arrTeamLoadoutInfos[PlayerIndex].m_eTeam == eTeam_None)
        {
            m_arrTeamLoadoutInfos[PlayerIndex].m_eTeam = eTeam_Alien;

            if (!m_bUseAlienInfo)
            {
                for (iAlienPods = 0; iAlienPods < m_kAlienSquad.arrPods.Length; iAlienPods++)
                {
                    if (m_kAlienSquad.arrPods[iAlienPods].eMain != 0)
                    {
                        m_arrTeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienSquad.arrPods[iAlienPods].eMain, m_kAlienSquad.arrPods[iAlienPods].eMainAltWeapon));
                    }

                    if (m_kAlienSquad.arrPods[iAlienPods].eSupport1 != 0)
                    {
                        m_arrTeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienSquad.arrPods[iAlienPods].eSupport1, m_kAlienSquad.arrPods[iAlienPods].eSupport1AltWeapon));
                    }

                    if (m_kAlienSquad.arrPods[iAlienPods].eSupport2 != 0)
                    {
                        m_arrTeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienSquad.arrPods[iAlienPods].eSupport2, m_kAlienSquad.arrPods[iAlienPods].eSupport2AltWeapon));
                    }
                }
            }
            else
            {
                m_arrTeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienInfo.iPodLeaderType));
                m_arrTeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienInfo.iPodSupporterType));
                m_arrTeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienInfo.iRoamingType));
            }

            break;
        }
    }
}

function InitHumanLoadoutInfosFromProfileSettingsSaveData(XComOnlineProfileSettings kProfileSettings)
{
    local int PlayerIndex, UnitIndex;
    local TSoldierPawnContent UnitContent;
    local TTransferSoldier TransferSoldier;

    for (PlayerIndex = 0; PlayerIndex < 4; PlayerIndex++)
    {
        if (m_arrTeamLoadoutInfos[PlayerIndex].m_eTeam == 0)
        {
            m_arrTeamLoadoutInfos[PlayerIndex].m_eTeam = 8;

            for (UnitIndex = 0; UnitIndex < kProfileSettings.m_aSoldiers.Length; UnitIndex++)
            {
                TransferSoldier = kProfileSettings.m_aSoldiers[UnitIndex];
                UnitContent = LWCE_BuildUnitContentFromEnums(TransferSoldier.kChar.kInventory.arrLargeItems[0], TransferSoldier.kChar.kInventory.iPistol, TransferSoldier.kChar.kInventory.iArmor, TransferSoldier.kChar.kInventory.arrSmallItems[0], TransferSoldier.kSoldier.kAppearance.iGender, class'XComPerkManager'.static.HasAnyGeneMod(TransferSoldier.kChar.aUpgrades));
                m_arrTeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(UnitContent);
            }
        }
    }
}