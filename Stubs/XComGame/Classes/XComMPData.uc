class XComMPData extends Object
    native(MP)
    config(MPGame)
	dependsOn(XComOnlineProfileSettingsDataBlob);
//complete stub

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
    var XGTacticalGameCoreData.ESoldierClass m_eClassType;
    var string m_strClassName;
    var int m_iClassCost;

};

struct native TMPClassPerkTemplate
{
    var XGTacticalGameCoreData.EMPTemplate m_eTemplate;
    var XGTacticalGameCoreData.ESoldierClass m_eClassType;
    var string m_strClassName;
    var int m_iTemplateCost;
    var XGTacticalGameCoreNativeBase.EPerkType m_iPerks[10];
    var XGTacticalGameCoreNativeBase.ESoldierRanks m_eRank;

};

struct native TMPGeneModTemplate
{
    var XGTacticalGameCoreData.EMPGeneModTemplateType m_eGeneModTemplateType;
    var string m_strGeneModTemplateName;
    var int m_iGeneModTemplateCost;
    var XGTacticalGameCoreNativeBase.EPerkType m_iGeneMods[5];

};

struct native TMPMECSuitTemplate
{
    var XGTacticalGameCoreData.EMPMECSuitTemplateType m_eMECSuitTemplateType;
    var string m_strMECSuitTemplateName;
    var int m_iMECSuitTemplateCost;
    var XGGameData.EItemType m_eMECSuitArmorType;
    var XGGameData.EItemType m_eMECSuitItemTypes[5];

};

struct native TMPArmorLoadoutData
{
    var XGGameData.EItemType m_eArmorType;
    var string m_strArmorName;
    var int m_iArmorCost;

};

struct native TMPPistolLoadoutData
{
    var XGGameData.EItemType m_ePistolType;
    var string m_strPistolName;
    var int m_iPistolCost;

};

struct native TMPWeaponLoadoutData
{
    var XGGameData.EItemType m_eWeaponType;
    var string m_strWeaponName;
    var int m_iWeaponCost;


};

struct native TMPItemLoadoutData
{
    var XGGameData.EItemType m_eItemType;
    var string m_strItemName;
    var int m_iItemCost;


};

struct native TMPCharacterLoadoutData
{
    var XGGameData.ECharacter m_eCharacterType;
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
    var XGGameData.ECharacter m_eCharacterType;
    var XGTacticalGameCoreNativeBase.EGender m_eCharacterGender;
    var XGTacticalGameCoreData.ESoldierClass m_eSoldierClass;
    var XGTacticalGameCoreData.EMPTemplate m_eTemplate;
    var XGTacticalGameCoreData.EMPGeneModTemplateType m_eGeneModTemplateType;
    var XGTacticalGameCoreData.EMPMECSuitTemplateType m_eMECSuitTemplateType;
    var XGTacticalGameCoreNativeBase.ESoldierRanks m_eRank;
    var XGGameData.EItemType m_eArmorType;
    var XGGameData.EItemType m_ePistolType;
    var XGGameData.EItemType m_eWeaponType;
    var XGGameData.EItemType m_ePrimaryItemType;
    var XGGameData.EItemType m_eSecondaryItemType;
    var int m_iTotalUnitCost;
    var int m_iUnitLoadoutID;
    var bool m_bCustomizedName;
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
var bool m_bInitialized;
var const config bool m_bAllowGlamCams;
var const config int m_iINIVersion;
var const string m_strINIFilename;

static final function bool IsPatientZero(string kName, int kPlatform){}
static final function string GetNetworkTypeName(XComMPData.EMPNetworkType NetworkType){}
static final function TMPUnitLoadoutReplicationInfo_AssignFrom_UIMPLoadout_Unit(out TMPUnitLoadoutReplicationInfo kDest, const out UIMPLoadout_Unit kSource){}
static final function string TMPUnitLoadoutReplicationInfo_ToString(const out TMPUnitLoadoutReplicationInfo kInfo, optional string strDelimiter){}
static final function string TMPClassPerkTemplate_ToString(TMPClassPerkTemplate kTemplate){}
static final function string TMPGeneModTemplate_ToString(TMPGeneModTemplate kTemplate){}
static final function string TMPMECSuitTemplate_ToString(TMPMECSuitTemplate kTemplate){}
final event Init(){}
function WaitForGameCoreInit(){}
private final function RemoveDebugMaps(){}
final function string MapPistolTypeToName(XGGameData.EItemType _ePistolType){}
final function string MapMPTemplateTypeToName(XGTacticalGameCoreData.EMPTemplate eTemplate){}
final function XGTacticalGameCoreNativeBase.ESoldierRanks MapMPTemplateTypeToRank(XGTacticalGameCoreData.EMPTemplate eTemplate){}
final function string MapSoldierClassTypeToName(int eClass){}
final function string MapWeaponTypeToName(XGGameData.EItemType _eWeaponType){}
final function string MapClassTypeToName(XGTacticalGameCoreData.ESoldierClass _eClassType){}
final function string MapArmorTypeToName(XGGameData.EItemType _eArmorType){}
final function string MapItemTypeToName(XGGameData.EItemType _eItemType){}
final function string MapCharacterTypeToName(XGGameData.ECharacter _eCharacterType){}
final function int MapPistolTypeToCost(XGGameData.EItemType _ePistolType){}
final function int MapWeaponTypeToCost(XGGameData.EItemType _eWeaponType){}
final function int MapClassTypeToCost(XGTacticalGameCoreData.ESoldierClass _eClassType){}
final function int MapArmorTypeToCost(XGGameData.EItemType _eArmorType){}
final function int MapItemTypeToCost(XGGameData.EItemType _eItemType){}
final function int MapCharacterTypeToCost(XGGameData.ECharacter _eCharacterType){}
final function int MapTemplateToCost(int _eTemplate){}
final function int MapGeneModTemplateToCost(XGTacticalGameCoreData.EMPGeneModTemplateType eGeneModTemplateType){}
final function string MapGeneModTemplateToName(XGTacticalGameCoreData.EMPGeneModTemplateType eGeneModTemplateType){}
final function int MapMECSuitTemplateToCost(XGTacticalGameCoreData.EMPMECSuitTemplateType eMECSuitTemplateType){}
final function string MapMECSuitTemplateToName(XGTacticalGameCoreData.EMPMECSuitTemplateType eMECSuitTemplateType){}
final function XGGameData.EItemType MapMECSuitTemplateToArmorType(XGTacticalGameCoreData.EMPMECSuitTemplateType eMECSuitTemplateType){}
final function int SumUnitCost(XGGameData.ECharacter _eCharacterType, XGGameData.EItemType _ePistolType, XGGameData.EItemType _eWeaponType, XGGameData.EItemType _eArmorType, XGGameData.EItemType _ePrimaryItemType, XGGameData.EItemType _eSecondaryItemType, int _eTemplate, XGTacticalGameCoreData.EMPGeneModTemplateType _eGeneModTemplate, XGTacticalGameCoreData.EMPMECSuitTemplateType _eMECSuitTemplate){}
final function bool IsValidUnitLoadout(const out TMPUnitLoadoutReplicationInfo kUnitLoadout){}
final function BuildTransferSoldiersFromUnitLoadoutReplicationInfo(const out array<TMPUnitLoadoutReplicationInfo> arrUnitLoadoutInfos, out array<TTransferSoldier> arrTransferSoldiers, out TMPPlayerData kMPPlayerData){}
final function DebugPrintData(){}
