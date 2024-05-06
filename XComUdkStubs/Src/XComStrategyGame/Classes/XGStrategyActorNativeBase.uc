class XGStrategyActorNativeBase extends Actor
    native
    config(GameData)
    notplaceable
    hidecategories(Navigation);

const NUM_STARTING_INTERCEPTOR_BAYS = 4;
const INTERCEPTOR_MISSION_LIMIT = 1;
const INTERCEPTOR_FLIGHT_TIME = 43200.0;
const NUM_CODE_PIECES = 1;
const NUM_TERRAIN_WIDE = 7;
const NUM_TERRAIN_HIGH = 5;
const BASE_REMOVAL_DAYS = 0;
const Paused = 0;
const ONE_MINUTE = 60;
const TEN_MINUTES = 600;
const FIFTEEN_MINUTES = 900;
const THIRTY_MINUTES = 1800;
const ONE_HOUR = 3600;
const TWELVE_HOURS = 43200;
const TWENTY_FOUR_HOURS = 86400;
const MAXIMUM_TIMESLICE = 60;
const SCAN_TIMESLICE = 1800;

enum EMissionDifficulty
{
    eMissionDiff_Easy,
    eMissionDiff_Moderate,
    eMissionDiff_Hard,
    eMissionDiff_VeryHard,
    eMissionDiff_MAX
};

enum EMissionRewardType
{
    eMissionReward_Soldier,
    eMissionReward_Cash,
    eMissionReward_Engineer,
    eMissionReward_Scientist,
    eMissionReward_MAX
};

enum ECharAssetFamilyType
{
    eCAFT_None,
    eCAFT_Sectoid,
    eCAFT_Thinman,
    eCAFT_Chryssalid,
    eCAFT_Cyberdisc,
    eCAFT_Drone,
    eCAFT_Muton,
    eCAFT_Floater,
    eCAFT_Sectopod,
    eCAFT_Ethereal,
    eCAFT_Human,
    eCAFT_MAX
};

enum ECinematicMoment
{
    eCinematic_IntroA,
    eCinematic_IntroB,
    eCinematic_IntroC,
    eCinematic_PreFinal,
    eCinematic_Final,
    eCinematic_Terror,
    eCinematic_Interrogation,
    eCinematic_ArcThrower,
    eCinematic_PostInterrogation,
    eCinematic_AlienCode,
    eCinematic_AlienBase,
    eCinematic_HyperwaveRetrieved,
    eCinematic_Firestorm,
    eCinematic_Psionics,
    eCinematic_ElderShip,
    eCinematic_PsiLinkRecovered,
    eCinematic_FinalFlight,
    eCinematic_FacilityReward,
    eCinematic_ItemReward,
    eCinematic_DropshipLaunch,
    eCinematic_DropshipLand,
    eCinematic_InterceptorLaunch,
    eCinematic_Lose,
    eCinematic_HQAssault_Win,
    eCinematic_MAX
};

enum EObjectiveStatus
{
    eObjStatus_NotStarted,
    eObjStatus_InProgress,
    eObjStatus_Complete,
    eObjStatus_Unavailable,
    eObjStatus_MAX
};

enum ESubObjective
{
    eSubObj_BuildAlienContainment,
    eSubObj_ResearchArcThrower,
    eSubObj_BuildArcThrower,
    eSubObj_CaptureLiveAlien,
    eSubObj_InterrogateCaptive,
    eSubObj_CaptureOutsider,
    eSubObj_ResearchShard,
    eSubObj_ObtainShards,
    eSubObj_BuildSkeletonKey,
    eSubObj_AssaultAlienBase,
    eSubObj_ResearchHyperwaveBeacon,
    eSubObj_BuildHyperwaveUplink,
    eSubObj_DetectAnOverseer,
    eSubObj_ResearchFirestorm,
    eSubObj_BuildFirestorm,
    eSubObj_ShootDownOverseer,
    eSubObj_AssaultOverseer,
    eSubObj_ResearchPsionics,
    eSubObj_BuildPsiLabs,
    eSubObj_TestTroops,
    eSubObj_ResearchPsiLink,
    eSubObj_BuildGollopChamber,
    eSubObj_DevelopPsiStrength,
    eSubObj_UseDevice,
    eSubObj_AssaultTempleShip,
    eSubObj_MAX
};

enum EGameObjective
{
    eObj_None,
    eObj_CaptureAlien,
    eObj_CaptureOutsider,
    eObj_ObtainShards,
    eObj_AssaultAlienBase,
    eObj_BuildHyperwaveUplink,
    eObj_ShootDownOverseer,
    eObj_UseDevice,
    eObj_TempleShip,
    eObj_MAX
};

enum ETechState
{
    eTechState_Unavailable,
    eTechState_Available,
    eTechState_Affordable,
    eTechState_MAX
};

enum EAdjacencyType
{
    eAdj_None,
    eAdj_Power,
    eAdj_Satellites,
    eAdj_Science,
    eAdj_Engineering,
    eAdj_All,
    eAdj_MAX
};

enum EUFOMissionResult
{
    eUMR_Undetected,
    eUMR_Detected,
    eUMR_Intercepted,
    eUMR_ShotDown,
    eUMR_Assaulted,
    eUMR_MAX
};

enum EShipStatus
{
    eShipStatus_Ready,
    eShipStatus_OnMission,
    eShipStatus_Refuelling,
    eShipStatus_Damaged,
    eShipStatus_Repairing,
    eShipStatus_Destroyed,
    eShipStatus_Transfer,
    eShipStatus_Rearming,
    eShipStatus_MAX
};

enum EStaffType
{
    eStaff_None,
    eStaff_Soldier,
    eStaff_Scientist,
    eStaff_Engineer,
    eStaff_MAX
};

enum EContinentBonus
{
    eCB_None,
    eCB_WeHaveWays,
    eCB_AirAndSpace,
    eCB_Panic,
    eCB_FutureCombat,
    eCB_Funding,
    eCB_Experts,
    eCB_MAX
};

enum EResourceType
{
    eResource_Money,
    eResource_Elerium,
    eResource_Alloys,
    eResource_Engineers,
    eResource_Scientists,
    eResource_Power,
    eResource_MonthlyNet,
    eResource_Meld,
    eResource_Max
};

enum EShipWeapon
{
    eShipWeapon_None,
    eShipWeapon_Cannon,
    eShipWeapon_Stingray,
    eShipWeapon_Avalanche,
    eShipWeapon_Laser,
    eShipWeapon_Plasma,
    eShipWeapon_EMP,
    eShipWeapon_Fusion,
    eShipWeapon_UFOPlasmaI,
    eShipWeapon_UFOPlasmaII,
    eShipWeapon_UFOFusionI,
    eShipWeapon_MAX
};

enum eHQEvent
{
    eHQEvent_Research,
    eHQEvent_ItemProject,
    eHQEvent_Facility,
    eHQEvent_Foundry,
    eHQEvent_EndOfMonth,
    eHQEvent_Hiring,
    eHQEvent_InterceptorOrdering,
    eHQEvent_ShipTransfers,
    eHQEvent_PsiTraining,
    eHQEvent_GeneModification,
    eHQEvent_CyberneticModification,
    eHQEvent_MecRepair,
    eHQEvent_FCRequest,
    eHQEvent_SatOperational,
    eHQEvent_CovertOperative,
    eHQEvent_MAX
};

enum EHQAnimLocation
{
    eHQAnimLoc_None,
    eHQAnimLoc_SitRoom,
    eHQAnimLoc_MissionControl,
    eHQAnimLoc_CentralOffice,
    eHQAnimLoc_Infirmary,
    eHQAnimLoc_Infirmary_Bed1,
    eHQAnimLoc_Infirmary_Bed2,
    eHQAnimLoc_Infirmary_Bed3,
    eHQAnimLoc_Infirmary_Bed4,
    eHQAnimLoc_Labs,
    eHQAnimLoc_Engineering,
    eHQAnimLoc_Hangar,
    eHQAnimLoc_AlienContain,
    eHQAnimLoc_Foundry,
    eHQAnimLoc_PsiLabs,
    eHQAnimLoc_Gollop,
    eHQAnimLoc_Hyperwave,
    eHQAnimLoc_OTS,
    eHQAnimLoc_PoolTable,
    eHQAnimLoc_Treadmill,
    eHQAnimLoc_Bar,
    eHQAnimLoc_OfficersQuarters,
    eHQAnimLoc_RookieQuarters,
    eHQAnimLoc_Memorial,
    eHQAnimLoc_MAX
};

enum EHQAnimType
{
    eHQAnim_None,
    eHQAnim_TwoPersonConversation,
    eHQAnim_ThreePersonConversation,
    eHQAnim_DirectingSomeone,
    eHQAnim_SeatedTwoPersonConversation,
    eHQAnim_SeatedWorking,
    eHQAnim_WatchingAlone,
    eHQAnim_TwoPeopleWatching,
    eHQAnim_LayingDown,
    eHQAnim_WorkingOnPad,
    eHQAnim_SittingAtBar,
    eHQAnim_RunningOnTreadmill,
    eHQAnim_ShootingPool,
    eHQAnim_MAX
};

enum EHQAnimCharacter
{
    eHQAnimChar_None,
    eHQAnimChar_Central,
    eHQAnimChar_ChiefScientist,
    eHQAnimChar_ChiefEngineer,
    eHQAnimChar_Soldier,
    eHQAnimChar_Doctor,
    eHQAnimChar_Nurse,
    eHQAnimChar_Scientist,
    eHQAnimChar_Engineer,
    eHQAnimChar_CommClerk,
    eHQAnimChar_MAX
};

enum EGeoscapeAlert
{
    eGA_UFODetected,
    eGA_Abduction,
    eGA_Terror,
    eGA_FCMission,
    eGA_UFOCrash,
    eGA_UFOLost,
    eGA_UFOLanded,
    eGA_DropArrive,
    eGA_AlienBase,
    eGA_Temple,
    eGA_MissedAliens,
    eGA_SecretPact,
    eGA_UFOScanning,
    eGA_HQAssault,
    eGA_NewSoldiers,
    eGA_SoldierHealed,
    eGA_NewEngineers,
    eGA_NewScientists,
    eGA_NewInterceptors,
    eGA_NewItemsReceived,
    eGA_NewItemBuilt,
    eGA_NewFacilityBuilt,
    eGA_ExcavationComplete,
    eGA_FacilityRemoved,
    eGA_AlloyRunCompleted,
    eGA_ItemProjectCompleted,
    eGA_FoundryProjectCompleted,
    eGA_WorkshopRebate,
    eGA_ResearchCompleted,
    eGA_PsiTraining,
    eGA_ShipTransferred,
    eGA_ShipArmed,
    eGA_ShipOnline,
    eGA_SatelliteOnline,
    eGA_CountryPanic,
    eGA_SatelliteDestroyed,
    eGA_FCActivity,
    eGA_ModalNotify,
    eGA_PayDay,
    eGA_FCJetTransfer,
    eGA_FCExpiredRequest,
    eGA_FCDelayedRequest,
    eGA_FCSatCountry,
    eGA_FCMissionActivity,
    eGA_ExaltMissionActivity,
    eGA_ExaltAlert,
    eGA_ExaltResearchHack,
    eGA_CellHides,
    eGA_GeneMod,
    eGA_Augmentation,
    eGA_ExaltRaidFailCountry,
    eGA_ExaltRaidFailContinent,
    eGA_MAX
};

enum EMonthlyGrade
{
    eGrade_A,
    eGrade_B,
    eGrade_C,
    eGrade_D,
    eGrade_F,
    eGrade_MAX
};

enum EAlienObjective
{
    eObjective_Recon,
    eObjective_Scout,
    eObjective_Harvest,
    eObjective_Flyby,
    eObjective_Hunt,
    eObjective_Abduct,
    eObjective_Terrorize,
    eObjective_Infiltrate,
    eObjective_MAX
};

enum EUFOMission
{
    eUM_QuickScout,
    eUM_LongScout,
    eUM_QuickSpecimen,
    eUM_LongSpecimen,
    eUM_Flyby,
    eUM_Direct,
    eUM_Dropoff,
    eUM_Seek,
    eUM_MAX
};

enum EItemCategory
{
    eItemCat_All,
    eItemCat_Weapons,
    eItemCat_Armor,
    eItemCat_Vehicles,
    eItemCat_VehicleUpgrades,
    eItemCat_Alien,
    eItemCat_Corpses,
    eItemCat_Facilities,
    eItemCat_Staff,
    eItemCat_MAX
};

enum ETechResultType
{
    eTechResult_Item,
    eTechResult_Facility,
    eTechResult_Tech,
    eTechResult_MAX
};

enum ETransactionType
{
    eTransaction_None,
    eTransaction_Build,
    eTransaction_Sell,
    eTransaction_MAX
};

enum ECityType
{
    eCity_NewYork,
    eCity_Miami,
    eCity_LA,
    eCity_Seattle,
    eCity_Chicago,
    eCity_Houston,
    eCity_Dallas,
    eCity_KansasCity,
    eCity_Baltimore,
    eCity_SanFrancisco,
    eCity_Montreal,
    eCity_Edmonton,
    eCity_Toronto,
    eCity_Vancouver,
    eCity_Calgary,
    eCity_Ottowa,
    eCity_MexicoCity,
    eCity_Chihuahua,
    eCity_Tijuana,
    eCity_Acapulco,
    eCity_Guadalajara,
    eCity_Leon,
    eCity_London,
    eCity_Birmingham,
    eCity_Glasgow,
    eCity_Liverpool,
    eCity_Manchester,
    eCity_Leeds,
    eCity_Paris,
    eCity_Lyons,
    eCity_Marseille,
    eCity_Lille,
    eCity_StJohns,
    eCity_Berlin,
    eCity_Hamburg,
    eCity_Munich,
    eCity_Cologne,
    eCity_Moscow,
    eCity_Novgorod,
    eCity_Volgograd,
    eCity_SaintPetersburg,
    eCity_Mumbai,
    eCity_Delhi,
    eCity_Bangalore,
    eCity_Kolkata,
    eCity_Tokyo,
    eCity_Osaka,
    eCity_Nagoya,
    eCity_Sapporo,
    eCity_Fukuoka,
    eCity_Sydney,
    eCity_Melbourne,
    eCity_Brisbane,
    eCity_Perth,
    eCity_HongKong,
    eCity_Beijing,
    eCity_Shanghai,
    eCity_Guangzhou,
    eCity_Chongqing,
    eCity_Lagos,
    eCity_Kano,
    eCity_Ibadan,
    eCity_Kaduna,
    eCity_PortHarcourt,
    eCity_BeninCity,
    eCity_Johannesburg,
    eCity_Durban,
    eCity_CapeTown,
    eCity_Pretoria,
    eCity_PortElizabeth,
    eCity_Bloemfontein,
    eCity_Cairo,
    eCity_Alexandria,
    eCity_Gizeh,
    eCity_PortSaid,
    eCity_Bogota,
    eCity_BuenosAires,
    eCity_Cordoba,
    eCity_Mendoza,
    eCity_Rosario,
    eCity_SaoPaulo,
    eCity_RiodeJaneiro,
    eCity_Salvador,
    eCity_Brasilia,
    eCity_Manaus,
    eCity_Fortaleza,
    eCity_MAX
};

enum EEntityGraphic
{
    eEntityGraphic_HQ,
    eEntityGraphic_Hangar,
    eEntityGraphic_Interceptor,
    eEntityGraphic_Firestorm,
    eEntityGraphic_Skyranger,
    eEntityGraphic_Sat_Destroyed,
    eEntityGraphic_Sat_En_Route,
    eEntityGraphic_Sat_Persistent,
    eEntityGraphic_UFO_Small,
    eEntityGraphic_UFO_Small_Seeking,
    eEntityGraphic_UFO_Large,
    eEntityGraphic_UFO_Large_Seeking,
    eEntityGraphic_UFO_Overseer,
    eEntityGraphic_Mission_UFO_Crash,
    eEntityGraphic_Mission_UFO_Crash_Overseer,
    eEntityGraphic_Mission_UFO_Landed,
    eEntityGraphic_Mission_Terror,
    eEntityGraphic_Mission_Abduction,
    eEntityGraphic_Mission_Council,
    eEntityGraphic_Mission_Alien_Base,
    eEntityGraphic_Mission_Temple_Ship,
    eEntityGraphic_Mission_Covert_Ops,
    eEntityGraphic_Mission_Exalt_HQ,
    eEntityGraphic_Storm_Large,
    eEntityGraphic_Storm_Medium,
    eEntityGraphic_Storm_Small,
    eEntityGraphic_MAX
};

struct TSubObjective
{
    var XGStrategyActorNativeBase.ESubObjective eType;
    var string strObjective;
    var string strInDepth;
    var XGStrategyActorNativeBase.EObjectiveStatus eStatus;
};

struct TGameObjective
{
    var XGStrategyActorNativeBase.EGameObjective eType;
    var XGStrategyActorNativeBase.EObjectiveStatus eStatus;
    var string strName;
    var XGTacticalScreenMgr.EImage eObjImage;
    var array<TSubObjective> arrSubObjectives;
};

struct THQAnimCharacter
{
    var XGStrategyActorNativeBase.EHQAnimCharacter eChar;
    var int iData;
};

struct THQAnim
{
    var XGStrategyActorNativeBase.EHQAnimType eType;
    var XGStrategyActorNativeBase.EHQAnimLocation ELocation;
    var array<THQAnimCharacter> arrChars;
};

struct TSatBonus
{
    var int iNumScientists;
    var int iNumEngineers;
};

struct TSatellite
{
    var int iType;
    var Vector2D v2Loc;
    var XGEntity kSatEntity;
    var int iCountry;
    var int iTravelTime;
};

struct TSatNode
{
    var Vector2D v2Coords;
    var int iCountry;
};

struct THQEvent
{
    var XGStrategyActorNativeBase.eHQEvent EEvent;
    var int iData;
    var int iHours;
    var int iData2;
};

struct TShipWeapon
{
    var string strName;
    var XGStrategyActorNativeBase.EShipWeapon eType;
    var int iAmmo;
    var float fFiringTime;
    var int iRange;
    var int iDamage;
    var int iAP;
    var int iToHit;
};

struct TStaffOrder
{
    var int iNumStaff;
    var int iStaffType;
    var int iHours;
};

struct TShipOrder
{
    var int iNumInterceptors;
    var int iDestinationContinent;
    var int iShipType;
    var int iHours;
};

struct TShipTransfer
{
    var int iNumShips;
    var int iShipType;
    var int iDestination;
    var int iHours;
};

struct TItem
{
    var string strName;
    var string strNamePlural;
    var int iItem;
    var int iCash;
    var int iElerium;
    var int iAlloy;
    var int iMeld;
    var int iHours;
    var int iMaxEngineers;
    var int iTechReq;
    var int iFTechReq;
    var int iItemReq;
    var int iStructureReq;
    var string strBriefSummary;
    var string strDeepSummary;
    var int iCategory;
    var int iImage;
};

struct TFacility
{
    var string strName;
    var EFacilityType eFacility;
    var int iItem;
    var int iCash;
    var int iMaintenance;
    var int iElerium;
    var int iAlloys;
    var int iSize;
    var int iPower;
    var int iTime;
    var int iTechReq;
    var int iItemReq;
    var int iStructureReq;
    var string strBriefSummary;
    var string strDeepSummary;
    var int iCategory;
    var int iImage;
};

struct TResearchCost
{
    var int iCash;
    var int iElerium;
    var int iAlloys;
    var array<int> arrItems;
    var array<int> arrItemQuantities;
};

struct TTech
{
    var string strName;
    var int iTech;
    var int iHours;
    var bool bCustomReqs;
    var int iItemReq;
    var int iTechReq;
    var int iContBonus;
    var int iImage;
    var string strSummary;
    var string strReport;
    var string strCustom;
    var string strCodename;
    var TResearchCost kCost;
    var EResearchCredits eCreditGranted;
};

struct TGeneModTech
{
    var string strName;
    var EGeneModTech eGeneTech;
    var ETechType eTechReq;
    var int iHours;
    var int iMeld;
    var int iCash;
    var XGTacticalGameCoreNativeBase.EPerkType ePerk;
};

struct TFoundryTech
{
    var string strName;
    var int iFoundryTech;
    var int iHours;
    var int iCash;
    var int iElerium;
    var int iAlloys;
    var int iEngineers;
    var int iItemReq;
    var int iTechReq;
    var int iImage;
    var string strSummary;
    var TResearchCost kCost;
};

struct TResearchCredit
{
    var EResearchCredits eCreditType;
    var int iBonus;
    var string strName;
    var string strSummary;
    var int iImage;
};

struct TOTSTech
{
    var string strName;
    var int iOTSTech;
    var int iRankRequired;
    var int iCash;
    var int iNumCombos;
    var int iComboType;
    var int iImage;
    var string strSummary;
};

struct TContinentBonus
{
    var int iImage;
    var string strTitle;
    var string strDesc;
};

struct TCountry
{
    var int iEnum;
    var string strName;
    var string strNameWithArticle;
    var string strNameWithArticleLower;
    var string strNamePossessive;
    var string strNameAdjective;
    var int iContinent;
    var int iFunding;
    var int iScience;
    var int iEngineering;
    var bool bDeveloped;
    var bool bCouncilMember;
};

struct TShipUIInfo
{
    var TText txtName;
    var TText txtStatus;
    var TText txtKills;
    var TText txtWeapons;
    var TText txtArmor;
    var TText txtEngines;
    var TText txtSpeed;
    var TText txtFuel;
    var TText txtRange;
};

struct TShip
{
    var string strName;
    var string strSize;
    var EShipType eType;
    var int iSpeed;
    var int iEngagementSpeed;
    var int iHP;
    var int iAP;
    var int iArmor;
    var int iRange;
    var array<int> arrSalvage;
    var array<int> arrWeapons;
    var int iImage;
};

struct TInterceptMission
{
    var XGShip_UFO kUFOTarget;
    var array<XGShip_Interceptor> arrInterceptors;
    var int iInterceptMode;
    var int iInterceptResult;
};

struct TGeoscapeAlert
{
    var XGStrategyActorNativeBase.EGeoscapeAlert eType;
    var array<int> arrData;
};

struct TMonthlySummary
{
    var int iPanicChange;
    var int iUFOsSeen;
    var int iUFOsDetected;
    var int iUFOsShotdown;
    var int iUFOsEscaped;
    var int iInterceptionRating;
    var int iAbductions;
    var int iAbductionsThwarted;
    var int iTerror;
    var int iTerrorThwarted;
    var int iUFORaids;
    var int iTechsResearched;
    var int iSatellitesLaunched;
    var int iSatellitesLost;
    var int iMismanagedFunds;
    var int iAbductionsIgnored;
    var int iAbductionsFailed;
    var int iTerrorIgnored;
    var int iTerrorFailed;
    var int iAlienBasesAssaulted;
    var int iCouncilMissionsCompleted;
    var int iFunding;
    var int iScientists;
    var int iEngineers;
    var array<int> arrCountriesNotHelped;
    var array<int> arrCountriesJoining;
    var array<int> arrCountriesLeaving;
    var array<int> arrCountriesAdding;
};

struct TCouncilMeeting
{
    var string strSummary;
    var array<TMonthlySummary> arrContinentSummaries;
    var int iFunding;
    var int iScientists;
    var int iEngineers;
    var TMonthlySummary kSummary;
    var XGStrategyActorNativeBase.EMonthlyGrade eGrade;
    var array<ECountry> arrLeavingCountries;
};

struct TProjectCost
{
    var int iCash;
    var int iElerium;
    var int iAlloys;
    var array<int> arrItems;
    var array<int> arrItemQuantities;
    var int iStaffTypeReq;
    var int iStaffNumReq;
    var int iBarracksReq;
};

struct TCostSummary
{
    var array<TText> arrRequirements;
    var string strHelp;
};

struct TObjectSummary
{
    var TImage imgObject;
    var TText txtRequirementsLabel;
    var TText txtSummary;
    var TCostSummary kCost;
    var bool bCanAfford;
    var int ItemType;
};

struct TItemProject
{
    var int iIndex;
    var EItemType eItem;
    var int iEngineers;
    var int iMaxEngineers;
    var int iQuantity;
    var int iQuantityLeft;
    var int iHoursLeft;
    var bool bNotify;
    var bool Brush;
    var bool bAdjusted;
    var TProjectCost kRebate;
    var TProjectCost kOriginalCost;
};

struct TFacilityProject
{
    var EFacilityType eFacility;
    var int iHoursLeft;
    var bool bNotify;
    var bool Brush;
    var int X;
    var int Y;
    var int iIndex;
    var TProjectCost kRebate;
    var TProjectCost kOriginalCost;
};

struct TFoundryProject
{
    var int eTech;
    var int iEngineers;
    var int iMaxEngineers;
    var int iHoursLeft;
    var bool Brush;
    var bool bNotify;
    var int iIndex;
    var bool bAdjusted;
    var TProjectCost kRebate;
    var TProjectCost kOriginalCost;
};

struct TAlloyProject
{
    var int iEngineers;
    var int iHoursLeft;
    var int iAlloyHoursLeft;
    var int iAlloysProduced;
    var bool bNotify;
    var int iIndex;
    var TProjectCost kRebate;
};

struct TConstructionProject
{
    var int iProjectType;
    var int iHoursLeft;
    var int iIndex;
    var int X;
    var int Y;
    var TProjectCost kRebate;
};

struct TEngQueueItem
{
    var bool bItem;
    var bool bFoundry;
    var int iIndex;
};

struct TCountryResult
{
    var ECountry eCountryAffected;
    var int iPanicChange;
    var bool bLeftXCom;
};

struct TContinentResult
{
    var EContinent eContinentAffected;
    var int iPanicChange;
};

struct TMissionResult
{
    var EMissionType eType;
    var array<TCountryResult> arrCountryResults;
    var array<TContinentResult> arrContinentResults;
    var int iWorldPanicChange;
    var int iCiviliansSaved;
    var int iCiviliansTotal;
    var int iCityTarget;
    var int iCountryTarget;
    var int iContinentTarget;
    var bool bAllPointsHeld;
    var bool bSuccess;
};

struct TObjective
{
    var XGStrategyActorNativeBase.EAlienObjective eType;
    var string strName;
    var string strEOMDescription;
    var bool bAbandon;
    var array<int> arrStartDates;
    var array<EShipType> arrUFOs;
    var array<XGStrategyActorNativeBase.EUFOMission> arrMissions;
    var array<int> arrRadii;
    var array<int> arrRandDays;
};

struct TUFORecord
{
    var EShipType eUFO;
    var XGStrategyActorNativeBase.EAlienObjective eObjective;
    var ECountry ECountry;
    var XGStrategyActorNativeBase.EUFOMissionResult eResult;
    var int iMonth;
};

var config int START_DAY;
var config int START_MONTH;
var config int START_YEAR;
var config int LOSE_CONDITION_NUM_DESERTERS;
var config int HQASSAULT_REINFORCEMENT_CAPACITY;
var config int BLUESHIRT_WILL_MOD;
var config int BLUESHIRT_HP_MOD;
var config int BLUESHIRT_AIM_MOD;