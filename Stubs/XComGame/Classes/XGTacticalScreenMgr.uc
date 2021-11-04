class XGTacticalScreenMgr extends Actor;

//complete stub

enum ETableCategories
{
    eCat_City,
    eCat_TechName,
    eCat_ItemName,
    eCat_Progress,
    eCat_Quantity,
    eCat_Due,
    eCat_Cash,
    eCat_Alloys,
    eCat_Elerium,
    eCat_Time,
    eCat_Engineers,
    eCat_Scientists,
    eCat_Power,
    eCat_Flag,
    eCat_Name,
    eCat_Nickname,
    eCat_Country,
    eCat_Loadout,
    eCat_Status,
    eCat_Promotion,
    eCat_Rank,
    eCat_Ability,
    eCat_NewPerks,
    eCat_OnStaff,
    eCat_Fear,
    eCat_Funding,
    eCat_Reward,
    eCat_MissionFactor,
    eCat_MissionResult,
    eCat_MissionRating,
    eCat_Artifact,
    eCat_Recovered,
    eCat_Blank,
    eCat_MAX
};

enum EUIState
{
    eUIState_Normal,
    eUIState_Disabled,
    eUIState_Good,
    eUIState_Bad,
    eUIState_Warning,
    eUIState_Highlight,
    eUIState_Cash,
    eUIState_Alloys,
    eUIState_Elerium,
    eUIState_Nickname,
    eUIState_Hyperwave,
    eUIState_Psyonic,
    eUIState_Meld,
    eUIState_MAX
};
enum EButton
{
    eButton_None,
    eButton_A,
    eButton_X,
    eButton_Y,
    eButton_B,
    eButton_Start,
    eButton_Back,
    eButton_Up,
    eButton_Down,
    eButton_Left,
    eButton_Right,
    eButton_LBumper,
    eButton_RBumper,
    eButton_LTrigger,
    eButton_RTrigger,
    eButton_LStick,
    eButton_RStick,
    eButton_MAX
};
enum EImage
{
    eImage_None,
    eImage_XComBadge,
    eImage_MiniWorld,
    eImage_Pistol,
    eImage_Rifle,
    eImage_Shotgun,
    eImage_LMG,
    eImage_SniperRifle,
    eImage_RocketLauncher,
    eImage_LaserPistol,
    eImage_LaserRifle,
    eImage_LaserHeavy,
    eImage_LaserSniperRifle,
    eImage_ArcThrower,
    eImage_PlasmaPistol,
    eImage_PlasmaLightRifle,
    eImage_PlasmaHeavy,
    eImage_PlasmaRifle,
    eImage_PlasmaSniperRifle,
    eImage_FragGrenade,
    eImage_SmokeGrenade,
    eImage_AlienGrenade,
    eImage_Medikit,
    eImage_Kevlar,
    eImage_SkeletonSuit,
    eImage_Carapace,
    eImage_Beast,
    eImage_Archangel,
    eImage_Titan,
    eImage_Ghost,
    eImage_Goliath,
    eImage_PsiArmor,
    eImage_Flamethrower,
    eImage_AlloyCannon,
    eImage_FlashBang,
    eImage_BlasterLauncher,
    eImage_Alloys,
    eImage_Elerium,
    eImage_FogPod,
    eImage_Mummy,
    eImage_CommStation,
    eImage_MedicalStation,
    eImage_UFOFlight,
    eImage_UFONavigation,
    eImage_UFOPowerSource,
    eImage_UFOFusionCannon,
    eImage_AlienFood,
    eImage_AlienEntertainment,
    eImage_AlienStasisTank,
    eImage_AlienSurgery,
    eImage_HyperwaveBeacon,
    eImage_PsiLink,
    eImage_ExaltIntel,
    eImage_AlloyFabrication,
    eImage_DamagedUFONavigation,
    eImage_DamagedUFOPowerSource,
    eImage_DamagedUFOFusionCannon,
    eImage_DamagedAlienFood,
    eImage_DamagedAlienEntertainment,
    eImage_DamagedAlienStasisTank,
    eImage_DamagedAlienSurgery,
    eImage_DamagedHyperwaveBeacon,
    eImage_SHIV_I,
    eImage_SHIV_II,
    eImage_SHIV_III,
    eImage_SHIV_Laser,
    eImage_SHIV_Plasma,
    eImage_Skyranger,
    eImage_Interceptor,
    eImage_Firestorm,
    eImage_InterceptorLaunch,
    eImage_Squad,
    eImage_Alpha,
    eImage_ChiefScientist,
    eImage_ChiefEngineer,
    eImage_CommClerk,
    eImage_MugshotMale,
    eImage_MugshotFemale,
    eImage_Pilot,
    eImage_FundingMember,
    eImage_SmallScout,
    eImage_LargeScout,
    eImage_Abductor,
    eImage_SupplyShip,
    eImage_Battleship,
    eImage_EtherealUFO,
    eImage_PhoenixCannon,
    eImage_AvalancheMissile,
    eImage_LaserCannon,
    eImage_PlasmaBeam,
    eImage_EmpCannon,
    eImage_FusionLance,
    eImage_TowerMissile,
    eImage_TowerLaser,
    eImage_TowerPlasma,
    eImage_TowerHyperwave,
    eImage_TileRock,
    eImage_TileRockSteam,
    eImage_TileAccessLift,
    eImage_TileConstruction,
    eImage_TileExcavated,
    eImage_TileBeingExcavated,
    eImage_FacilityAccessLift,
    eImage_FacilityAlienContainment,
    eImage_FacilityEleriumGenerator,
    eImage_FacilityGear,
    eImage_FacilityFoundry,
    eImage_FacilityGenerator,
    eImage_FacilityRadar,
    eImage_FacilityLivingQuarters,
    eImage_FacilityPsiLabs,
    eImage_FacilitySuperComputer,
    eImage_FacilityLargeRadar,
    eImage_FacilityThermoGenerator,
    eImage_FacilityOTS,
    eImage_FacilityOTS2,
    eImage_FacilityXBC,
    eImage_FacilityUber,
    eImage_FacilityCyberneticsLab,
    eImage_FacilityGeneticsLab,
    eImage_Soldier,
    eImage_Scientist,
    eImage_Engineer,
    eImage_Sectoid,
    eImage_SectoidCommander,
    eImage_Floater,
    eImage_FloaterHeavy,
    eImage_Muton,
    eImage_MutonElite,
    eImage_MutonCommander,
    eImage_Chryssalid,
    eImage_Zombie,
    eImage_Thinman,
    eImage_Cyberdisc,
    eImage_Ethereal,
    eImage_Sectopod,
    eImage_Drone,
    eImage_Outsider,
    eImage_Mechtoid,
    eImage_Seeker,
    eImage_ExaltOperative,
    eImage_ExaltSniper,
    eImage_ExaltHeavy,
    eImage_ExaltMedic,
    eImage_ExaltEliteOperative,
    eImage_ExaltEliteSniper,
    eImage_ExaltEliteHeavy,
    eImage_ExaltEliteMedic,
    eImage_SectoidBust,
    eImage_SectoidCommanderBust,
    eImage_FloaterBust,
    eImage_FloaterHeavyBust,
    eImage_MutonBust,
    eImage_MutonEliteBust,
    eImage_MutonCommanderBust,
    eImage_ChryssalidBust,
    eImage_ZombieBust,
    eImage_ThinmanBust,
    eImage_CyberdiscBust,
    eImage_EtherealBust,
    eImage_SectopodBust,
    eImage_DroneBust,
    eImage_NorthAmerica,
    eImage_SouthAmerica,
    eImage_Africa,
    eImage_Asia,
    eImage_Europe,
    eImage_Geoscape,
    eImage_RadarUFO,
    eImage_Warp,
    eImage_Temple,
    eImage_UFO,
    eImage_AlienBase,
    eImage_UFOCrash,
    eImage_Interception,
    eImage_Lasers,
    eImage_UFOEngine,
    eImage_LivingQuarters,
    eImage_MCUFOScramble,
    eImage_MCIntercept,
    eImage_MCAbduction,
    eImage_MCUFOLanded,
    eImage_MCUFOCrash,
    eImage_MCInterceptionLost,
    eImage_MCTerror,
    eImage_MCTerror2,
    eImage_Lock,
    eImage_AlienTower,
    eImage_Research,
    eImage_Static,
    eImage_DarkLeader,
    eImage_Intro,
    eImage_MissionControl,
    eImage_Labs,
    eImage_Shipping,
    eImage_Artifacts,
    eImage_Panic,
    eImage_News,
    eImage_Army,
    eImage_MummyDeck,
    eImage_AutopsyDeck,
    eImage_BootDeck,
    eImage_DisassemblyDeck,
    eImage_GeniusDeck,
    eImage_Abduction,
    eImage_Abduction2,
    eImage_Beacon,
    eImage_BeginTurn,
    eImage_WeaponsCache,
    eImage_Township,
    eImage_Deck1,
    eImage_Deck2,
    eImage_Device,
    eImage_XenoBiology,
    eImage_AlienWeaponry,
    eImage_OldUFO,
    eImage_OldInterception,
    eImage_OldFunding,
    eImage_OldAssault,
    eImage_OldResearch,
    eImage_OldManufacture,
    eImage_OldRetaliation,
    eImage_OldSoldier,
    eImage_OldHangar,
    eImage_OldTerror,
    eImage_Satellite,
    eImage_IntConsumableHit,
    eImage_IntConsumableDodge,
    eImage_IntConsumableBoost,
    eImage_MAX
};

enum EOTSImages
{
    eOTSImage_Will_I,
    eOTSImage_SquadSize_I,
    eOTSImage_XP_I,
    eOTSImage_HP_I,
    eOTSImage_Squadsize_II,
    eOTSImage_XP_II,
    eOTSImage_HP_II,
    eOTSImage_MAX
};

enum EFoundryImages
{
    eFoundryImage_SHIV,
    eFoundryImage_SHIVHeal,
    eFoundryImage_CaptureDrone,
    eFoundryImage_MedikitII,
    eFoundryImage_ArcThrowerII,
    eFoundryImage_LaserCoolant,
    eFoundryImage_SHIVLaser,
    eFoundryImage_SHIVPlasma,
    eFoundryImage_Flight,
    eFoundryImage_AlienGrenade,
    eFoundryImage_AdvancedConstruction,
    eFoundryImage_VehicleRepair,
    eFoundryImage_PistolI,
    eFoundryImage_PistolII,
    eFoundryImage_PistolIII,
    eFoundryImage_SHIVSuppression,
    eFoundryImage_StealthSatellites,
    eFoundryImage_ScopeUpgrade,
    eFoundryImage_AdvancedServomotors,
    eFoundryImage_ShapedArmor,
    eFoundryImage_EleriumFuel,
    eFoundryImage_SentinelDrone,
    eFoundryImage_TacticalRigging,
    eFoundryImage_MECCloseCombat,
    eFoundryImage_MAX
};
enum ETechImages
{
    eTechImage_AlienWeaponFragments,
    eTechImage_AlienMaterials,
    eTechImage_AlienConstruction,
    eTechImage_ArcThrower,
    eTechImage_ArmorArchangel,
    eTechImage_ArmorCarapace,
    eTechImage_ArmorGhost,
    eTechImage_ArmorSkeleton,
    eTechImage_ArmorTitan,
    eTechImage_ArmorPsi,
    eTechImage_BaseShard,
    eTechImage_ChitinPlating,
    eTechImage_CombatStims,
    eTechImage_DefenseMatrix,
    eTechImage_Elerium,
    eTechImage_EMPCannon,
    eTechImage_ExperimentalWarfare,
    eTechImage_Firestorm,
    eTechImage_FusionLance,
    eTechImage_AlienGrenade,
    eTechImage_HackDrone,
    eTechImage_HyperwaveCommunication,
    eTechImage_LaserCannon,
    eTechImage_LaserPistol,
    eTechImage_LaserWeaponry,
    eTechImage_MedikitI,
    eTechImage_MindShield,
    eTechImage_PlasmaBlasterLauncher,
    eTechImage_PlasmaCannon,
    eTechImage_PlasmaHeavy,
    eTechImage_PlasmaLightRifle,
    eTechImage_PlasmaPistol,
    eTechImage_PlasmaRifle,
    eTechImage_PlasmaShotgun,
    eTechImage_PlasmaSniper,
    eTechImage_PsiLink,
    eTechImage_SatelliteAssistedTargeting,
    eTechImage_ShipLaserCannon,
    eTechImage_UFOFlight,
    eTechImage_UFONavigation,
    eTechImage_UFOPower,
    eTechImage_UFOTracking,
    eTechImage_Xenobiology,
    eTechImage_InterrogateSectoid,
    eTechImage_InterrogateFloater,
    eTechImage_InterrogateMuton,
    eTechImage_InterrogateThinMan,
    eTechImage_InterrogateEthereal,
    eTechImage_InterrogateBerserker,
    eTechImage_InterrogateMutonElite,
    eTechImage_InterrogateHeavyFloater,
    eTechImage_InterrogateSectoidCommander,
    eTechImage_AutopsySectoid,
    eTechImage_AutopsyFloater,
    eTechImage_AutopsyMuton,
    eTechImage_AutopsyThinMan,
    eTechImage_AutopsyChryssalid,
    eTechImage_AutopsyZombie,
    eTechImage_AutopsyEthereal,
    eTechImage_AutopsyCyberdisc,
    eTechImage_AutopsyDrone,
    eTechImage_AutopsySectopod,
    eTechImage_AutopsyBerserker,
    eTechImage_AutopsyMutonElite,
    eTechImage_AutopsyHeavyFloater,
    eTechImage_AutopsySectoidCommander,
    eTechImage_AutopsyMechtoid,
    eTechImage_AutopsySeeker,
    eTechImage_Meld,
    eTechImage_MAX
};
enum EInventoryImages
{
    eInventoryImage_EMPCannon,
    eInventoryImage_FusionLance,
    eInventoryImage_GunPod,
    eInventoryImage_LaserCannon,
    eInventoryImage_MissilePod,
    eInventoryImage_PlasmaCannon,
    eInventoryImage_AlienGrenade,
    eInventoryImage_AlienWeaponFragments,
    eInventoryImage_ArcThrower,
    eInventoryImage_ArmorArchangel,
    eInventoryImage_ArmorCarapace,
    eInventoryImage_ArmorGhost,
    eInventoryImage_ArmorKevlar,
    eInventoryImage_ArmorPsi,
    eInventoryImage_ArmorSkeleton,
    eInventoryImage_ArmorTitan,
    eInventoryImage_AssaultRifleModern,
    eInventoryImage_BattleScanner,
    eInventoryImage_ChitinPlating,
    eInventoryImage_CombatStims,
    eInventoryImage_DefenseMatrix,
    eInventoryImage_Firestorm,
    eInventoryImage_FlameThrower,
    eInventoryImage_FragGrenade,
    eInventoryImage_GrappleHook,
    eInventoryImage_Interceptor,
    eInventoryImage_LaserHeavy,
    eInventoryImage_LaserPistol,
    eInventoryImage_LaserRifle,
    eInventoryImage_LaserShotgun,
    eInventoryImage_LaserSniper,
    eInventoryImage_LMG,
    eInventoryImage_MedikitI,
    eInventoryImage_MedikitII,
    eInventoryImage_MindShield,
    eInventoryImage_MotionDetector,
    eInventoryImage_NanoFabricVest,
    eInventoryImage_Pistol,
    eInventoryImage_PlasmaBlasterLauncher,
    eInventoryImage_PlasmaHeavy,
    eInventoryImage_PlasmaPistol,
    eInventoryImage_PlasmaRifle,
    eInventoryImage_PlasmaRifleLight,
    eInventoryImage_PlasmaShotgun,
    eInventoryImage_PlasmaSniper,
    eInventoryImage_RocketLauncher,
    eInventoryImage_Satellite,
    eInventoryImage_SatelliteTargeting,
    eInventoryImage_Scope,
    eInventoryImage_SHIVI,
    eInventoryImage_SHIVII,
    eInventoryImage_SHIVIII,
    eInventoryImage_MECI,
    eInventoryImage_MECII,
    eInventoryImage_MECIII,
    eInventoryImage_SHIVGattlingGun,
    eInventoryImage_SHIVLaserCannon,
    eInventoryImage_Shotgun,
    eInventoryImage_SkeletonKey,
    eInventoryImage_SmokeGrenade,
    eInventoryImage_SniperRifle,
    eInventoryImage_UFOTracking,
    eInventoryImage_Xenobiology,
    eInventoryImage_RespiratorImplant,
    eInventoryImage_ReaperRounds,
    eInventoryImage_Flashbang,
    eInventoryImage_MimicBeacon,
    eInventoryImage_GasGrenade,
    eInventoryImage_GhostGrenade,
    eInventoryImage_NeedleGrenade,
    eInventoryImage_ExaltAssaultRifle,
    eInventoryImage_ExaltSniperRifle,
    eInventoryImage_ExaltHeavyMG,
    eInventoryImage_ExaltLaserAssaultRifle,
    eInventoryImage_ExaltLaserSniperRifle,
    eInventoryImage_ExaltLaserHeavyMG,
    eInventoryImage_ExaltRocketLauncher,
    eInventoryImage_MECChainGun,
    eInventoryImage_MECRailGun,
    eInventoryImage_MECParticleCannon,
    eInventoryImage_MECCivvies,
    eInventoryImage_MECCivvies_1,
    eInventoryImage_MECCivvies_2,
    eInventoryImage_MAX
};

enum ECreditImages
{
    eCreditImage_Weapons_I,
    eCreditImage_PlasmaWeapons,
    eCreditImage_AllWeapons,
    eCreditImage_Armor_I,
    eCreditImage_AllArmor,
    eCreditImage_UFOTech,
    eCreditImage_Flight,
    eCreditImage_Psionics,
    eCreditImage_AllAlienTech,
    eCreditImage_MAX
};

struct TText
{
    var string StrValue;
    var int iState;

    structdefaultproperties
    {
        StrValue=""
        iState=0
    }
};

struct TButtonText
{
    var string StrValue;
    var int iState;
    var int iButton;

    structdefaultproperties
    {
        StrValue=""
        iState=0
        iButton=0
    }
};

struct TLabeledText
{
    var string StrValue;
    var string strLabel;
    var int iState;
    var bool bNumber;

    structdefaultproperties
    {
        StrValue=""
        strLabel=""
        iState=0
        bNumber=false
    }
};

struct TMenuOption
{
    var string strText;
    var string strHelp;
    var int iState;
};

struct TMenu
{
    var string strLabel;
    var array<TMenuOption> arrOptions;
    var bool bTakesNoInput;
};

struct TTableMenuHeader
{
    var array<string> arrStrings;
    var array<int> arrStates;
};

struct TTableMenuOption
{
    var array<string> arrStrings;
    var array<int> arrStates;
    var int iState;
    var string strHelp;
};

struct TTableMenu
{
    var array<int> arrCategories;
    var TTableMenuHeader kHeader;
    var array<TTableMenuOption> arrOptions;
    var bool bTakesNoInput;
};

struct TImage
{
    var int iImage;
    var string strLabel;
    var int iState;
    var string strPath;
};

struct TProgressGraph
{
    var TText txtTitle;
    var int iProgressState;
    var int iPercentProgress;
};

struct TGraphNode
{
    var int iID;
    var TText txtName;
    var TText txtHelp;
    var int iState;
    var array<int> arrLinks;
};

struct TButtonBar
{
    var array<TButtonText> arrButtons;
};

struct TTab
{
    var string strTab;
    var int iState;
};

struct TTabbedTableMenu
{
    var array<TTab> arrTabs;
    var array<TTableMenu> arrTableMenus;
};

var int m_iCurrentView;
var IScreenMgrInterface m_kInterface;
var const localized string m_arrCategoryNames[ETableCategories];

function Init(optional int iView){}
function IScreenMgrInterface GetUIScreen(){}
function UpdateView(){}
function GoToView(int iView){}
static function array<string> GetHeaderStrings(array<int> arrCategories){}
static function array<int> GetHeaderStates(array<int> arrCategories){}
