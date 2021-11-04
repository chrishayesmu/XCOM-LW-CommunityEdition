class XGBattleDesc extends Actor
	dependsOn(XGLoadoutMgr)
	DependsOn(XComContentManager);
//complete stub
struct native TMissionReward
{
    var int iScientists;
    var int iEngineers;
    var int iSoldierClass;
    var int iSoldierLevel;
    var int iCredits;
    var int iData;
    var int iCountry;
    var int iCity;
};

struct native TAlienInfo
{
    var int iMissionDifficulty;
    var int iNumAliens;
    var int iNumStaticPods;
    var float fSecondaryAlienRatio;
    var int iMissionCommander;
    var int iMissionCommanderSupporter;
    var int iPodLeaderType;
    var int iPodSupporterType;
    var int iSecondaryPodLeaderType;
    var int iSecondaryPodSupporterType;
    var int iRoamingType;
    var int iRoamingSupporterType;
    var int iNumRoaming;
    var bool bProcedural;
    var int iNumRandomAI;
    var int iUFOType;
};
struct native MedalBattleData
{
    var int m_iNumTerrorMissionSuccess;
    var int m_iNumContinentBonuses;
    var int m_iNumExaltCellsRemoved;
    var string m_arrMedalNames[6];
};

struct native TeamLoadoutInfo
{
    var array<TSoldierPawnContent> m_arrUnits;
    var ETeam m_eTeam;
};

var protected TeamLoadoutInfo m_arrTeamLoadoutInfos[4];
var repnotify int m_iNumPlayers;
var array<int> m_arrArtifacts;
var string m_strLocation;
var int m_iPodGroup;
var string m_strOpName;
var string m_strObjective;
var string m_strDesc;
var string m_strMapName;
var string m_strMapCommand;
var string m_strTime;
var int m_iMissionID;
var XGDropshipCargoInfo m_kDropShipCargoInfo;
var int m_iDifficulty;
var int m_iLowestDifficulty;
var int m_iMissionType;
var int m_iNumTerrorCivilians;
var TAlienSquad m_kAlienSquad;
var EShipType m_eUFOType;
var ETimeOfDay m_eTimeOfDay;
var EContinent m_eContinent;
var EFCMission m_eCouncilType;
var bool m_bOvermindEnabled;
var bool m_bIsFirstMission;
var bool m_bIsTutorial;
var bool m_bDisableSoldierChatter;
var bool m_bAllowedMissionAbort;
var bool m_bIsIronman;
var bool m_bScripted;
var bool m_bSilenceNewbieMoments;
var bool m_bUseAlienInfo;
var float m_fMatchDuration;
var TCivilianPawnContent m_kCivilianInfo;
var array<int> m_arrSecondWave;
var int m_iPlayCount;
var MedalBattleData m_kMedalBattleData;
var TAlienInfo m_kAlienInfo;
var const localized string m_aCities[14];
var const localized string m_aStates[13];
var const localized string m_aCountries[2];
var const localized string m_sLocation;
var const localized string m_strSkirmishOpName;

function ChangeDifficulty(int iNewDifficulty){}
function UpdateUnitStats(){}
function TeamLoadoutInfo GetTeamLoadoutInfo(int iIndex){}
event bool ShouldSpawnMeldCanisters(){}
function bool IsMeldTutorialMission(){}
function TSoldierPawnContent BuildAlienContentFromLoadout(const out LoadoutTemplate Loadout, EItemType eArmor, EGender eGen){}
function TSoldierPawnContent BuildUnitContentFromEnums(EItemType eWeapon, EItemType ePistol, EItemType eArmor, EItemType eItem, EGender eGen, bool bGeneMods){}
function InitHumanLoadoutInfosFromProfileSettingsSaveData(XComOnlineProfileSettings kProfileSettings){}
function InitHumanLoadoutInfosFromDropshipCargoInfo(){}
function InitCivilianContent(XComOnlineProfileSettings Settings){}
function TSoldierPawnContent BuildAlienContent(ECharacter AlienType, optional EItemType eAltWeapon){}
function InitAlienLoadoutInfos(){}
simulated function array<EPawnType> GetPawnTypes(ETeam eUnitTeam){}
function ReplicateLoadoutInfo(ETeam _eTeam, const out array<EPawnType> arrPawnTypes, const out array<ELoadoutTypes> arrLoadoutTypes);
simulated function bool AllLoadoutInfosReplicated(){}
function string GetTimeString(){}
function string GetBattleDescription(){}
function string GetBattleObjective(){}
function string GetOpName(){}
function Generate(optional bool bSkipDropshipCargoInfo){}
protected function GenerateOpName(){}
function GenerateAliens(){}
static final function ECharacter GetSupportAlien(ECharacter eAlienType, optional bool bAlt){}
static function ECharacter GetSecondaryAlienForContentLoading(ECharacter eAlienType){}
function GenerateLocation(){}
function GenerateStartTime(){}
function GenerateLoot(){}
function GenerateDropshipCargoInfo(){}
function bool IsUfoMission(){}
function TPawnContent DeterminePawnContent(){}
function array<int> DetermineAlienPawnContent(){}
function array<TSoldierPawnContent> DetermineSoldierPawnContent(){}
function TCivilianPawnContent DetermineCivilianPawnContent(){}
static function TCivilianPawnContent BuildCivilianContent(){}
static function TSoldierPawnContent BuildSoldierContent(TTransferSoldier kTransfer){}
static function array<int> DetermineSoldierPerkWeapons(TTransferSoldier kTransfer){}
static function array<int> DetermineSoldierPerkContent(TTransferSoldier kTransfer){}
static function TSoldierPawnContent AddBattleScannerContent(){}
static function int DetermineSoldierKit(TTransferSoldier kTransfer, int iPawnType){}
static function int MapAlienToPawn(int iAlienType){}
static function int MapSoldierToPawn(int iArmor, int iGender, bool bGeneMod){}

