class XComOnlineProfileSettingsDataBlob extends Object
    native(Core)
	dependson(XComContentManager)
	dependson(XComMapManager);
//complete stub

struct native UISPLoadout_Unit
{
    var ESoldierRanks eRank;
    var string strRank;
    var ECharacter eChar;
    var string strChar;
    var EItemType ePistol;
    var string strPistol;
    var EItemType eWeapon;
    var string strWeapon;
    var EItemType eArmor;
    var string strArmor;
    var EItemType eItem;
    var string strItem;
    var bool bIsValid;
    var ESoldierClass eClass;
    var string strClass;
    var int aUpgrades[EPerkType];

};

struct native UIMPLoadout_Unit
{
    var string strUnitName;
    var ECharacter eCharacterType;
    var EGender eCharacterGender;
    var int iCharacterCost;
    var EItemType ePistol;
    var int iPistolCost;
    var string strPistolName;
    var EItemType eWeapon;
    var int iWeaponCost;
    var string strWeaponName;
    var EItemType eArmor;
    var int iArmorCost;
    var string strArmorName;
    var EItemType ePrimaryItem;
    var int iPrimaryItemCost;
    var string strPrimaryItemName;
    var EItemType eSecondaryItem;
    var int iSecondaryItemCost;
    var string strSecondaryItemName;
    var int iPointValue;
    var int iSquadPointValue;
    var int iIconType;
    var bool bIsHuman;
    var string sImg;
    var bool bIsValid;
    var bool bIsEmpty;
    var bool bCustomizedName;
    var EMPTemplate eTemplate;
    var string strTemplateName;
    var ESoldierClass eClass;
    var ESoldierRanks eRank;
    var string strClassName;
    var EMPGeneModTemplateType eGeneModTemplateType;
    var int iGeneModTemplateCost;
    var string strGeneModTemplateName;
    var EMPMECSuitTemplateType eMECSuitTemplateType;
    var int iMECSuitTemplateCost;
    var string strMECSuitTemplateName;
    var int iLoadoutId;
};
struct native UIMPLoadout_Squad
{
    var string strLoadoutName;
    var int iLoadoutId;
    var string strLanguageCreatedWith;
};

struct native ProfileStatValue
{
    var int iCrc;
    var int iValue;
};

var array<ELoadoutTypes> m_aLoadoutTypes;
var array<EItemType> m_aArmorTypes;
var array<UISPLoadout_Unit> m_aSPLoadoutData;
var array<UIMPLoadout_Unit> m_aMPLoadoutDataLocal;
var array<UIMPLoadout_Unit> m_aMPLoadoutDataRemote;
var array<UIMPLoadout_Squad> m_aMPLoadoutSquadDataLocal;
var array<UIMPLoadout_Squad> m_aMPLoadoutSquadDataRemote;
var array<ProfileStatValue> m_aProfileStats;
var array<int> m_arrGameOptions;
var array<int> m_arrGamesSubmittedToMCP_Victory;
var array<int> m_arrGamesSubmittedToMCP_Loss;
var array<MapHistory> m_arrMapHistory;
var ECharacter m_eAlienType;
var int m_iPodGroup;
var int m_iSpawnGroup;
var TCivilianPawnContent m_kCivilianContent;
var int m_iGames;
var bool m_bMuteSoundFX;
var bool m_bMuteMusic;
var bool m_bMuteVoice;
var bool m_bVSync;
var bool m_bAutoSave;
var bool m_bActivateMouse;
var transient bool m_bIsConsoleBuild;
var bool m_bThirdPersonCam;
var bool m_bGlamCam;
var bool m_bForeignLanguages;
var bool m_bShowEnemyHealth;
var bool m_bEnableSoldierSpeech;
var bool m_bSubtitles;
var bool bDisableSoldierChatter;
var bool m_bPlayerHasUncheckedBoxTutorialSetting;
var bool m_bPlayerHasUncheckedBoxMeldTutorialSetting;
var bool bHasPlayedDLCCampaign;
var protected bool m_bActivateTouch;
var float m_fScrollSpeed;
var int m_iMasterVolume;
var int m_iVoiceVolume;
var int m_iFXVolume;
var int m_iMusicVolume;
var int m_iGammaPercentage;
var float m_fGamma;
var int m_iLastUsedMPLoadoutId;

final function int FindProfileStatIndex(string strStat, optional out int out_crc){}
function IncGamesPlayed(){}
event bool IsMouseActive(){}
event bool IsTouchActive(){}
function ActivateMouse(bool Activate){}
function ActivateTouch(bool Activate){}
function int GetGamesPlayed(){}
function int GetProfileStatValue(EProfileStats eStat) {}
function bool IsProfileStatNotZero(EProfileStats eStat){}
function SetProfileStatValue(EProfileStats eStat, int Value){}
function IncProfileStatValue(EProfileStats eStat, int Value){}
function bool IfGameStatsSubmitted(int iGame, bool bVictory){}
function GameStatsSubmitted(int iGame, bool bVictory){}
function SetGameplayOption(EGameplayOption eOption, bool bEnable){}
function ClearGameplayOptions(){}
function bool IsSecondWaveUnlocked(){}
function bool IsGameplayToggleUnlocked(EGameplayOption eOption){}
function bool HasCompletedGame(){}
native function bool GetGameplayOption(EGameplayOption eOption);
function Options_ResetToDefaults(bool bInShell){}
