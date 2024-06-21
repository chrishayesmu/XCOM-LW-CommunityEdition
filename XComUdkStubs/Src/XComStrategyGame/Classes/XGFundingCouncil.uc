class XGFundingCouncil extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum EFCRequestType
{
    eFCRType_None,
    eFCRType_SellArtifacts,
    eFCRType_SatLaunch,
    eFCRType_JetTransfer,
    eFCRType_MAX
};

enum EFCRequest
{
    eFCR_None,
    eFCR_SellBodies,
    eFCR_SellRobotics,
    eFCR_SellRoboticsII,
    eFCR_SellFragments,
    eFCR_SellNavComputers,
    eFCR_SellPharma,
    eFCR_SellWeapons,
    eFCR_SellWeaponsII,
    eFCR_SellPower,
    eFCR_SellAlloys,
    eFCR_SellArcs,
    eFCR_SatCountry,
    eFCR_JetTransfer,
    eFCR_SellMutons,
    eFCR_SellChryssalids,
    eFCR_SellHeavyFloaters,
    eFCR_SellSectopods,
    eFCR_SellStims,
    eFCR_SellPlasmaPistols,
    eFCR_SellPlasmaRifles,
    eFCR_SellLightPlasmaRifles,
    eFCR_SellHeavyPlasmas,
    eFCR_SellHeavyLasers,
    eFCR_SellScatterLasers,
    eFCR_SellAlloyCannons,
    eFCR_SellScopes,
    eFCR_SellNanoFiberVests,
    eFCR_SellMechtoidCores,
    eFCR_SellSeekerWrecks,
    eFCR_SellGhostGrenades,
    eFCR_SellGasGrenades,
    eFCR_SellReaperRounds,
    eFCR_SellMimicBeacons,
    eFCR_SellFlashbangs,
    eFCR_SellEXALTRifles,
    eFCR_SellEXALTSniperRifles,
    eFCR_SellEXALTLMGs,
    eFCR_SellEXALTRocketLaunchers,
    eFCR_SellEXALTLaserRifles,
    eFCR_SellEXALTLaserSniperRifles,
    eFCR_SellEXALTHeavyLasers,
    eFCR_MAX
};

enum EFCRewardType
{
    eFCReward_None,
    eFCReward_Money,
    eFCReward_Code,
    eFCReward_Soldier,
    eFCReward_Scientist,
    eFCReward_Engineer,
    eFCReward_Panic,
    eFCReward_Satellite,
    eFCReward_Elerium,
    eFCReward_CustomSoldier,
    eFCReward_ExaltIntel,
    eFCReward_MAX
};

struct TFundingCouncilRewardSoldier
{
    var string firstName;
    var string lastName;
    var string NickName;
    var ESoldierClass soldierClass;
    var ESoldierRanks SoldierRank;
    var TAppearance Appearance;
    var ECountry Country;
    var int HP;
    var int Aim;
    var int Will;
    var bool bPsiGift;
    var int RequiredRestDays;
};

struct TFCMission
{
    var EFCMission eMission;
    var EFCMissionType eType;
    var array<EFCRewardType> arrRewards;
    var array<TFundingCouncilRewardSoldier> arrRewardSoldiers;
    var XComNarrativeMoment NarrIntro;
    var string strName;
    var string strIntro;
    var string strCompletion;
    var string strFailure;
    var string strSituationBrief;
    var string strObjectivesBrief;
    var string strTickerSuccess;
    var string strTickerFail;
    var string strTickerIgnore;
    var string strMapName;
    var int iFirstAct;
    var int iPanicOnFailure;
    var bool bExplicitSoldier;
    var ECountry ECountry;
    var array<int> arrRewardAmounts;
};

struct TFCRequest
{
    var EFCRequest eRequest;
    var EFCRequestType eType;
    var array<EFCRewardType> arrRewards;
    var array<int> arrRewardAmounts;
    var array<ETechType> arrRequirements;
    var XComNarrativeMoment NarrIntro;
    var string strName;
    var string strIntro;
    var string strCompletion;
    var string strTickerSuccess;
    var string strTickerIgnore;
    var bool bExalt;
    var bool bEliteExalt;
    var ECountry ECountry;
    var EItemType eRequestedItem;
    var EItemType eDisplayItem;
    var int iRequestedAmount;
    var int iHours;
    var int iCooldown;
    var bool bIsTransferRequest;
    var bool bIsTransferComplete;
};

struct CheckpointRecord
{
    var array<EFCMission> m_arrPreviousMissions;
    var array<EFCRequest> m_arrPreviousRequests;
    var int m_iLastAddedMissionID;
    var int m_iFirstRequestCountdown;
    var int m_iSecondRequestCountdown;
    var array<TFCRequest> m_arrPendingRequests;
    var array<TFCRequest> m_arrCurrentRequests;
    var bool m_bProgenyEnabled;
    var EFCMission m_eNextProgenyMission;
    var bool m_bSlingshotEnabled;
    var EFCMission m_eNextSlingshotMission;
    var EFCMission m_eLastSlingshotMission;
    var int m_iNextSlingshotDay;
    var int m_iNextAnnetteMusing;
    var bool m_bFuriesWon;
    var int m_iFCMissionsThisMonth;
    var int m_iFCRequestsThisMonth;
    var int m_iRequestCoolDown[EFCRequest];
};

var config int REQUEST_WINDOW1_MIN_DAY;
var config int REQUEST_WINDOW1_MAX_DAY;
var config int REQUEST_WINDOW2_MIN_DAY;
var config int REQUEST_WINDOW2_MAX_DAY;
var config int REQUEST_MISSION_CHANCE;
var config int FCREQUEST_DAYS;
var config int DELUGE_GAP_HOURS;
var config int MIN_MONEY_REWARD;
var config int MAX_MONEY_REWARD;
var config int MAX_MONEY_REWARD_HARD;
var config int MAX_MONEY_REWARD_CLASSIC;
var config int MIN_MONEY_REWARD_EASY;
var config float FIRST_MONTH_MULTIPLIER;
var config float SECOND_MONTH_MULTIPLIER;
var config int SMALL_DEMAND_AMOUNT;
var config int BIG_DEMAND_AMOUNT;
var config int HUGE_DEMAND_AMOUNT;
var config float PROFIT_MARGIN;
var config float FCM_MONEY_SCALAR;
var config float FCM_INTEL_CHANCE;
var config int BASE_REQUEST_COOLDOWN_DAYS;
var config int FC_REQUEST_EXTENDED_COOLDOWN_DAYS;
var config int MISSION_FAIL_LOW_PANIC;
var config int MISSION_FAIL_HIGH_PANIC;
var config int MISSION_REWARD_LOW_DAYS;
var config float MISSION_REWARD_LOW_MULT;
var config int MISSION_REWARD_MED_DAYS;
var config float MISSION_REWARD_MED_MULT;
var config int MISSION_REWARD_SOLDIER_LOW_LEVEL;
var config int MISSION_REWARD_SOLDIER_MED_LEVEL;
var config int MISSION_REWARD_SOLDIER_HIGH_LEVEL;
var config int SLINGSHOT_LOWFRIENDS_START_DAY;
var config int SLINGSHOT_CNFNDLIGHT_DAYS;
var config int SLINGSHOT_GANGPLANK_DAYS;
var int m_iFCMissionsThisMonth;
var int m_iFCRequestsThisMonth;
var int m_iRequestCoolDown[EFCRequest];
var bool m_bProgenyEnabled;
var bool m_bSlingshotEnabled;
var privatewrite bool m_bPlayAnnetteMusing;
var private bool m_bFuriesWon;
var EFCMission m_eNextProgenyMission;
var EFCMission m_eNextSlingshotMission;
var EFCMission m_eLastSlingshotMission;
var ECountry m_ePendingSatelliteRequestCountry;
var int m_iNextSlingshotDay;
var privatewrite int m_iNextAnnetteMusing;
var int m_iFirstRequestCountdown; // Countdown (hours) to the next FC mission
var int m_iSecondRequestCountdown; // Countdown (hours) to the next FC request
var array<EFCMission> m_arrPreviousMissions;
var array<EFCRequest> m_arrPreviousRequests;
var int m_iLastAddedMissionID;
var int m_iLastCompletedSatelliteTransferRequestID;
var array<TFCRequest> m_arrPendingRequests;
var array<TFCRequest> m_arrExpiredRequests;
var array<TFCRequest> m_arrCurrentRequests;
var array<TFCMission> m_arrTMissions;
var array<TFCRequest> m_arrTRequests;
var const localized string m_strMissionNames[EFCMission];
var const localized string m_strMissionIntro[EFCMission];
var const localized string m_strMissionComplete[EFCMission];
var const localized string m_strMissionSuccess[EFCMission];
var const localized string m_strMissionFail[EFCMission];
var const localized string m_strMissionIgnore[EFCMission];
var const localized string m_strMissionSituation[EFCMission];
var const localized string m_strMissionObjectives[EFCMission];
var const localized string m_strRequestNames[EFCRequest];
var const localized string m_strRequestIntro[EFCRequest];
var const localized string m_strRequestCompletion[EFCRequest];
var const localized string m_strRequestSuccess[EFCRequest];
var const localized string m_strRequestIgnore[EFCRequest];
var const localized string m_strLabelRequestExpiredExplanation;
var const localized string m_strSpecialMissionFailed;
var XGFundingCouncil_RequestAdaptor m_kSatRequestCompleteAdaptor;