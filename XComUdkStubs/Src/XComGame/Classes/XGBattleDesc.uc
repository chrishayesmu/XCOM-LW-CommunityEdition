class XGBattleDesc extends Actor
    native(Core)
    notplaceable
    hidecategories(Navigation);

const MAX_MEDAL_NAMES = 6;
const MAX_UNIQUE_CIVILIANS = 5;
const NUM_CITIES = 14;
const NUM_STATES = 13;
const NUM_COUNTRIES = 2;
const NUM_VALID_ALIEN_TYPES = 16;

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

struct CheckpointRecord
{
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
    var EContinent m_eContinent;
    var ETimeOfDay m_eTimeOfDay;
    var bool m_bOvermindEnabled;
    var bool m_bIsIronman;
    var bool m_bIsFirstMission;
    var bool m_bIsTutorial;
    var bool m_bDisableSoldierChatter;
    var bool m_bAllowedMissionAbort;
    var bool m_bScripted;
    var float m_fMatchDuration;
    var int m_iNumPlayers;
    var TCivilianPawnContent m_kCivilianInfo;
    var array<int> m_arrSecondWave;
    var int m_iPlayCount;
    var EFCMission m_eCouncilType;
    var MedalBattleData m_kMedalBattleData;
    var bool m_bSilenceNewbieMoments;
};

var protected TeamLoadoutInfo m_arrTeamLoadoutInfos[ENumPlayers];
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
var EContinent m_eContinent;
var ETimeOfDay m_eTimeOfDay;
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

defaultproperties
{
    m_strObjective="Explore the abduction site and eliminate any alien opposition. All targets hostile."
    m_strDesc="Alien Abduction Site"
    m_iDifficulty=1
    m_iMissionType=2
    m_iNumTerrorCivilians=18
    m_bAllowedMissionAbort=true
    RemoteRole=ROLE_SimulatedProxy
    bTickIsDisabled=true
    bAlwaysRelevant=true
}