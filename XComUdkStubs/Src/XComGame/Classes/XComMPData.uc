class XComMPData extends Object
    native(MP)
    config(MPGame);

const MAX_PERKS_PER_TEMPLATE = 10;
const MAX_GENE_MODS_PER_TEMPLATE = 5;
const MAX_MEC_SUIT_ITEMS_PER_TEMPLATE = 5;

enum EMPNumUnitsPerSquad
{
    EMPNumUnitsPerSquad,
    EMPNumUnitsPerSquad_1,
    EMPNumUnitsPerSquad_2,
    EMPNumUnitsPerSquad_3,
    EMPNumUnitsPerSquad_4,
    EMPNumUnitsPerSquad_5,
    EMPNumUnitsPerSquad_MAX
};

enum EMPNumHumanPlayers
{
    EMPNumHumanPlayers,
    EMPNumHumanPlayers_1,
    EMPNumHumanPlayers_MAX
};

enum EMPGameType
{
    eMPGameType_Deathmatch,
    eMPGameType_Assault,
    eMPGameType_MAX
};

enum EMPNetworkType
{
    eMPNetworkType_Public,
    eMPNetworkType_Private,
    eMPNetworkType_LAN,
    eMPNetworkType_Offline,
    eMPNetworkType_MAX
};

struct native TMPClassLoadoutData
{
    var ESoldierClass m_eClassType;
    var string m_strClassName;
    var int m_iClassCost;
};

struct native TMPClassPerkTemplate
{
    var EMPTemplate m_eTemplate;
    var ESoldierClass m_eClassType;
    var string m_strClassName;
    var int m_iTemplateCost;
    var EPerkType m_iPerks[10];
    var ESoldierRanks m_eRank;
};

struct native TMPGeneModTemplate
{
    var EMPGeneModTemplateType m_eGeneModTemplateType;
    var string m_strGeneModTemplateName;
    var int m_iGeneModTemplateCost;
    var EPerkType m_iGeneMods[5];
};

struct native TMPMECSuitTemplate
{
    var EMPMECSuitTemplateType m_eMECSuitTemplateType;
    var string m_strMECSuitTemplateName;
    var int m_iMECSuitTemplateCost;
    var EItemType m_eMECSuitArmorType;
    var EItemType m_eMECSuitItemTypes[5];
};

struct native TMPArmorLoadoutData
{
    var EItemType m_eArmorType;
    var string m_strArmorName;
    var int m_iArmorCost;
};

struct native TMPPistolLoadoutData
{
    var EItemType m_ePistolType;
    var string m_strPistolName;
    var int m_iPistolCost;
};

struct native TMPWeaponLoadoutData
{
    var EItemType m_eWeaponType;
    var string m_strWeaponName;
    var int m_iWeaponCost;
};

struct native TMPItemLoadoutData
{
    var EItemType m_eItemType;
    var string m_strItemName;
    var int m_iItemCost;
};

struct native TMPCharacterLoadoutData
{
    var ECharacter m_eCharacterType;
    var string m_strCharacterName;
    var int m_iCharacterCost;
};

struct native TMPMapData
{
    var name m_nmMapName;
    var string m_strMapDisplayName;
    var int m_iMapNameIndex;
    var XComMPData.EMPGameType m_eGameType;
    var bool m_bDebugOnly;
};

struct native TMPPatientZeroData
{
    var string m_strPatientName;
    var int m_iPlatform;
};

struct native TMPUnitLoadoutReplicationInfo
{
    var string m_strUnitName;
    var ECharacter m_eCharacterType;
    var EGender m_eCharacterGender;
    var ESoldierClass m_eSoldierClass;
    var EMPTemplate m_eTemplate;
    var EMPGeneModTemplateType m_eGeneModTemplateType;
    var EMPMECSuitTemplateType m_eMECSuitTemplateType;
    var ESoldierRanks m_eRank;
    var EItemType m_eArmorType;
    var EItemType m_ePistolType;
    var EItemType m_eWeaponType;
    var EItemType m_ePrimaryItemType;
    var EItemType m_eSecondaryItemType;
    var int m_iTotalUnitCost;
    var int m_iUnitLoadoutID;
    var bool m_bCustomizedName;

    structdefaultproperties
    {
        m_iUnitLoadoutID=-1
    }
};

struct native TMPPingRanges
{
    var string m_strUITag;
    var int m_iPing;
};

struct native TMPPlayerData
{
    var string m_strPlayerLanguage;
    var bool m_bSoldiersUseOwnLanguage;
};

var config array<config TMPClassLoadoutData> m_arrClassLoadouts;
var config array<config TMPClassPerkTemplate> m_arrPerkTemplate;
var config array<config TMPGeneModTemplate> m_arrGeneModTemplates;
var config array<config TMPMECSuitTemplate> m_arrMECSuitTemplates;
var config array<config TMPArmorLoadoutData> m_arrArmorLoadouts;
var config array<config TMPPistolLoadoutData> m_arrPistolLoadouts;
var config array<config TMPWeaponLoadoutData> m_arrWeaponLoadouts;
var config array<config TMPItemLoadoutData> m_arrItemLoadouts;
var config array<config TMPCharacterLoadoutData> m_arrCharacterLoadouts;
var config array<config TMPMapData> m_arrMaps;
var array<TMPPatientZeroData> m_arrPatientZero;
var config array<config int> m_arrMaxSquadCosts;
var config array<config int> m_arrTurnTimers;
var config array<config TMPPingRanges> m_arrPingRanges;
var const localized string m_arrGameTypeNames[EMPGameType];
var private const localized string m_arrNetworkTypeNames[EMPNetworkType];
var private const localized string m_arrNetworkTypeNamesXbox[EMPNetworkType];
var private const localized array<localized string> m_arrLocalizedMapDisplayNames;
var privatewrite bool m_bInitialized;
var const config bool m_bAllowGlamCams;
var const config int m_iINIVersion;
var const string m_strINIFilename;

defaultproperties
{
    m_strINIFilename="XComMPGame.ini"
}