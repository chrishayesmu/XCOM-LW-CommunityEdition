class LWCE_XGBattleDesc extends XGBattleDesc
    dependson(LWCEContentManager);

struct LWCE_TMissionReward
{
    var int iEngineers;
    var int iScientists;
    var int iCash;
    var array<LWCE_TItemQuantity> arrItems;
    var array<LWCE_TRewardSoldier> arrSoldiers;
};

struct LWCE_TeamLoadoutInfo
{
    var array<LWCE_TSoldierPawnContent> m_arrUnits;
    var ETeam m_eTeam;
};

struct CheckpointRecord_LWCE_XGBattleDesc extends XGBattleDesc.CheckpointRecord
{
    var LWCEItemContainer m_kArtifactsContainer;
    var array<XGItem> arrRecordedItems;
    var array<string> arrItemStrings;
    var string m_strDate;
};

var protected LWCE_TeamLoadoutInfo m_arrCETeamLoadoutInfos[ENumPlayers];
var LWCEItemContainer m_kArtifactsContainer;
var array<XGItem> arrRecordedItems;
var array<string> arrItemStrings;
var string m_strDate;

// TODO: LWCE version of TSoldierPawnContent

function LWCE_XGBattleDesc Init()
{
    if (m_kArtifactsContainer == none)
    {
        m_kArtifactsContainer = Spawn(class'LWCEItemContainer');
    }

    // TODO: remember why we do this and document it
    if (m_arrArtifacts.Length == 0)
    {
        m_arrArtifacts.Add(1);
    }

    return self;
}

/*
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
 */

function TSoldierPawnContent BuildAlienContent(ECharacter AlienType, optional EItemType eAltWeapon = 0)
{
    `LWCE_LOG_DEPRECATED_CLS(BuildAlienContent);
    return super.BuildAlienContent(AlienType, eAltWeapon);
}

function LWCE_TSoldierPawnContent LWCE_BuildAlienContent(int AlienType, optional int eAltWeapon = 0)
{
    local LWCE_TSoldierPawnContent Alien;
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
    Alien.nmPawn = `LWCE_CONTENT_TEMPLATE_MGR.FindMatchingPawn(ECharacter(AlienType)).GetContentTemplateName();
    return Alien;
}

function TSoldierPawnContent BuildAlienContentFromLoadout(const out LoadoutTemplate Loadout, EItemType eArmor, EGender eGen)
{
    `LWCE_LOG_DEPRECATED_CLS(BuildAlienContentFromLoadout);
    return super.BuildAlienContentFromLoadout(Loadout, eArmor, eGen);
}

function LWCE_TSoldierPawnContent LWCE_BuildAlienContentFromLoadout(const out LoadoutTemplate Loadout, int iArmorItemId, int iGender)
{
    local LWCE_TSoldierPawnContent UnitContent;
    local int PrimaryWeapon;

    PrimaryWeapon = `GAMECORE.GetPrimaryWeapon(Loadout.Inventory);
    `LWCE_LOG_CLS("PrimaryWeapon = " $ PrimaryWeapon);

    // TODO: how does this all work?
    UnitContent.nmPawn = '';
    //UnitContent.iKit = class'XComContentManager'.static.MapArmorAndWeaponToArmorKit(EItemType(iArmorItemId), EItemType(PrimaryWeapon));
    //UnitContent.kAppearance.iHead = 6;
    //UnitContent.kInventory = Loadout.Inventory;
    //UnitContent.kInventory.iArmor = iArmorItemId;
    return UnitContent;
}

static function TSoldierPawnContent AddBattleScannerContent()
{
    local TSoldierPawnContent kContent;

    `LWCE_LOG_DEPRECATED_CLS(AddBattleScannerContent);

    return kContent;
}

static function LWCE_TSoldierPawnContent LWCE_AddBattleScannerContent()
{
    local LWCE_TSoldierPawnContent kContent;

    kContent.nmPawn = 'TODO';

    return kContent;
}

static function TSoldierPawnContent BuildSoldierContent(TTransferSoldier kTransfer)
{
    local TSoldierPawnContent kContent;

    `LWCE_LOG_DEPRECATED_CLS(BuildSoldierContent);

    return kContent;
}

static function LWCE_TSoldierPawnContent LWCE_BuildSoldierContent(LWCE_TTransferSoldier kTransfer)
{
    local LWCEArmorTemplate kArmor;
    local LWCE_XGTacticalGameCore kGameCore;
    local LWCE_TSoldierPawnContent kContent;

    kArmor = `LWCE_ARMOR(kTransfer.kChar.kInventory.nmArmor);
    kGameCore = `LWCE_GAMECORE;

    if (kArmor.HasAbility('Grapple') && !class'LWCEInventoryUtils'.static.HasItemOfName(kTransfer.kChar.kInventory, 'Item_Grapple'))
    {
        class'LWCEInventoryUtils'.static.AddCustomItem(kTransfer.kChar.kInventory, 'Item_Grapple');
    }

    if (kGameCore.LWCE_CharacterIsPsionic(kTransfer.kChar) && !class'LWCEInventoryUtils'.static.HasItemOfName(kTransfer.kChar.kInventory, 'Item_PsiAmp'))
    {
        class'LWCEInventoryUtils'.static.AddCustomItem(kTransfer.kChar.kInventory, 'Item_PsiAmp');
    }

    // TODO: won't work for SHIVs
    kContent.nmPawn = `LWCE_CONTENT_TEMPLATE_MGR.FindMatchingPawn(eChar_Soldier, EGender(kTransfer.kSoldier.kAppearance.iGender), kTransfer.kChar.kInventory.nmArmor).GetContentTemplateName();
    kContent.nmKit = LWCE_DetermineSoldierKit(kTransfer);
    kContent.kAppearance = kTransfer.kSoldier.kAppearance;
    kContent.kInventory = kTransfer.kChar.kInventory;
    kContent.arrPerkWeapons = LWCE_DetermineSoldierPerkWeapons(kTransfer);
    kContent.arrPerkContent = LWCE_DetermineSoldierPerkContent(kTransfer);

    return kContent;
}

function TSoldierPawnContent BuildUnitContentFromEnums(EItemType eWeapon, EItemType ePistol, EItemType eArmor, EItemType eItem, EGender eGen, bool bGeneMods)
{
    local TSoldierPawnContent kContent;

    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(BuildUnitContentFromEnums);

    return kContent;
}

function array<int> DetermineAlienPawnContent()
{
    local array<int> arrAliens;

    arrAliens = super.DetermineAlienPawnContent();

    // Always load sectoid/zombie for the LoS helper units
    arrAliens.AddItem(ePawnType_Sectoid);
    arrAliens.AddItem(ePawnType_Zombie);

    return arrAliens;
}

static function int DetermineSoldierKit(TTransferSoldier kTransfer, int iPawnType)
{
    `LWCE_LOG_DEPRECATED_CLS(DetermineSoldierKit);

    return 0;
}

static function name LWCE_DetermineSoldierKit(LWCE_TTransferSoldier kTransfer)
{
    // TODO: replace the entire content loading system
    // TODO: why do we need any of this when the soldier's appearance has the kit in it??
    //local int iArmor, iPrimaryWeapon;
    //local name nmPrimaryWeapon;
//
    //iArmor = class'LWCE_XGItemTree'.static.BaseIDFromItemName(kTransfer.kChar.kInventory.nmArmor);
//
    //nmPrimaryWeapon = class'LWCE_XGTacticalGameCore'.static.LWCE_GetPrimaryWeapon(kTransfer.kChar.kInventory);
    //iPrimaryWeapon = class'LWCE_XGItemTree'.static.BaseIDFromItemName(nmPrimaryWeapon);

    return kTransfer.kSoldier.kAppearance.nmArmorKit;
}

function array<TSoldierPawnContent> DetermineSoldierPawnContent()
{
    local array<TSoldierPawnContent> arrSoldiers;

    arrSoldiers.Add(0);
    `LWCE_LOG_DEPRECATED_CLS(DetermineSoldierPawnContent);

    return arrSoldiers;
}

function array<LWCE_TSoldierPawnContent> LWCE_DetermineSoldierPawnContent()
{
    local LWCE_XGDropshipCargoInfo kCargoInfo;
    local array<LWCE_TSoldierPawnContent> arrSoldiers;
    local int iSoldier;
    local bool bAddBattleScanner;

    kCargoInfo = LWCE_XGDropshipCargoInfo(m_kDropShipCargoInfo);

    for (iSoldier = 0; iSoldier < kCargoInfo.m_arrCESoldiers.Length; iSoldier++)
    {
        arrSoldiers[iSoldier] = LWCE_BuildSoldierContent(kCargoInfo.m_arrCESoldiers[iSoldier]);

        if (kCargoInfo.m_arrCESoldiers[iSoldier].kChar.arrPerks.Find('Id', `LW_PERK_ID(BattleScanner)) != INDEX_NONE)
        {
            bAddBattleScanner = true;
        }
    }

    if (kCargoInfo.m_bHasCovertOperative)
    {
        arrSoldiers[iSoldier] = LWCE_BuildSoldierContent(kCargoInfo.m_kCECovertOperative);
        iSoldier++;
    }

    if (bAddBattleScanner)
    {
        arrSoldiers[iSoldier] = LWCE_AddBattleScannerContent();
    }

    return arrSoldiers;
}

static function array<int> DetermineSoldierPerkContent(TTransferSoldier kTransfer)
{
    local array<int> arrPerks;

    `LWCE_LOG_DEPRECATED_CLS(GetItemCardFromOption);

    arrPerks.Add(0);
    return arrPerks;
}

static function array<int> LWCE_DetermineSoldierPerkContent(LWCE_TTransferSoldier kTransfer)
{
    local array<int> arrPerkContent, arrPossiblePerks;
    local int I;
    local bool bRift;

    arrPossiblePerks = `CONTENTMGR.GetPerkContentIds();

    for (I = 0; I < kTransfer.kChar.arrPerks.Length; I++)
    {
        if (arrPossiblePerks.Find(kTransfer.kChar.arrPerks[I].Id) != INDEX_NONE)
        {
            arrPerkContent.AddItem(kTransfer.kChar.arrPerks[I].Id);

            if (kTransfer.kChar.arrPerks[I].Id == `LW_PERK_ID(Rift))
            {
                bRift = true;
            }
        }
    }

    if (!bRift && kTransfer.kSoldier.iPsiRank == 7)
    {
        arrPerkContent.AddItem(ePerk_Rift);
    }

    return arrPerkContent;
}

static function array<int> DetermineSoldierPerkWeapons(TTransferSoldier kTransfer)
{
    local array<int> arrPerks;

    `LWCE_LOG_DEPRECATED_CLS(DetermineSoldierPerkWeapons);

    arrPerks.Add(0);
    return arrPerks;
}

static function array<name> LWCE_DetermineSoldierPerkWeapons(LWCE_TTransferSoldier kTransfer)
{
    local TConfigPerkWeapon kConfigPerkWeapon;
    local array<name> arrPerkWeapons;

    foreach `GAMECORE.PerkWeapons(kConfigPerkWeapon)
    {
        if (kTransfer.kChar.arrPerks.Find('Id', kConfigPerkWeapon.ePerk) != INDEX_NONE)
        {
            arrPerkWeapons.AddItem(class'LWCE_XGItemTree'.static.ItemNameFromBaseID(kConfigPerkWeapon.eWeapon));
        }
    }

    return arrPerkWeapons;
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
        if (m_arrCETeamLoadoutInfos[PlayerIndex].m_eTeam == eTeam_Alien)
        {
            return;
        }

        if (m_arrCETeamLoadoutInfos[PlayerIndex].m_eTeam == eTeam_None)
        {
            m_arrCETeamLoadoutInfos[PlayerIndex].m_eTeam = eTeam_Alien;

            if (!m_bUseAlienInfo)
            {
                for (iAlienPods = 0; iAlienPods < m_kAlienSquad.arrPods.Length; iAlienPods++)
                {
                    if (m_kAlienSquad.arrPods[iAlienPods].eMain != 0)
                    {
                        m_arrCETeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienSquad.arrPods[iAlienPods].eMain, m_kAlienSquad.arrPods[iAlienPods].eMainAltWeapon));
                    }

                    if (m_kAlienSquad.arrPods[iAlienPods].eSupport1 != 0)
                    {
                        m_arrCETeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienSquad.arrPods[iAlienPods].eSupport1, m_kAlienSquad.arrPods[iAlienPods].eSupport1AltWeapon));
                    }

                    if (m_kAlienSquad.arrPods[iAlienPods].eSupport2 != 0)
                    {
                        m_arrCETeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienSquad.arrPods[iAlienPods].eSupport2, m_kAlienSquad.arrPods[iAlienPods].eSupport2AltWeapon));
                    }
                }
            }
            else
            {
                m_arrCETeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienInfo.iPodLeaderType));
                m_arrCETeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienInfo.iPodSupporterType));
                m_arrCETeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(LWCE_BuildAlienContent(m_kAlienInfo.iRoamingType));
            }

            break;
        }
    }
}

function InitHumanLoadoutInfosFromProfileSettingsSaveData(XComOnlineProfileSettings kProfileSettings)
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(InitHumanLoadoutInfosFromProfileSettingsSaveData);
}

function InitHumanLoadoutInfosFromDropshipCargoInfo()
{
    local int PlayerIndex, UnitIndex;
    local LWCE_TSoldierPawnContent UnitContent;
    local LWCE_XGDropshipCargoInfo kCargoInfo;

    kCargoInfo = LWCE_XGDropshipCargoInfo(m_kDropShipCargoInfo);

    for (PlayerIndex = 0; PlayerIndex < 4; PlayerIndex++)
    {
        if (m_arrCETeamLoadoutInfos[PlayerIndex].m_eTeam == eTeam_None)
        {
            m_arrCETeamLoadoutInfos[PlayerIndex].m_eTeam = eTeam_XCom;

            for (UnitIndex = 0; UnitIndex < kCargoInfo.m_arrCESoldiers.Length; UnitIndex++)
            {
                UnitContent = LWCE_BuildSoldierContent(kCargoInfo.m_arrCESoldiers[UnitIndex]);
                m_arrCETeamLoadoutInfos[PlayerIndex].m_arrUnits.AddItem(UnitContent);
            }

            break;
        }
    }
}

static function int MapSoldierToPawn(int iArmor, int iGender, bool bGeneMod)
{
    `LWCE_LOG_DEPRECATED_CLS(MapSoldierToPawn);

    return -1;
}

static function LWCEPawnContentTemplate LWCE_MapSoldierToPawn(name nmArmor, int iGender)
{
    // TODO deprecate this function
    if (nmArmor == '')
    {
        return none;
    }

    return `LWCE_CONTENT_TEMPLATE_MGR.FindMatchingPawn(eChar_Soldier, EGender(iGender), nmArmor);
}