class XGTacticalGameCoreNativeBase extends Actor
    hidecategories(Navigation)
    native(Core)
    config(GameCore)
    abstract
    notplaceable
    DependsOn(XComWorldData);

//complete stub

enum EGender
{
    eGender_None,
    eGender_Male,
    eGender_Female,
    eGender_MAX
};

enum ECharacterRace
{
    eRace_Caucasian,
    eRace_African,
    eRace_Asian,
    eRace_Hispanic,
    eRace_MAX
};

enum ECivilianType
{
    eCivilian_Warm,
    eCivilian_Cold,
    eCivilian_Formal,
    eCivilian_Soldier,
    eCivilian_MAX
};

enum EItemSize
{
    eItemSize_Small,
    eItemSize_Large,
    eItemSize_Armor,
    eItemSize_MAX
};

enum ESoldierRanks
{
    eRank_Rookie,
    eRank_Squaddie,
    eRank_Corporal,
    eRank_Sergeant,
    eRank_Lieutenant,
    eRank_Captain,
    eRank_Major,
    eRank_Colonel,
    ESoldierRanks_MAX
};

enum EPsiRanks
{
    eRank_PsiLevel_None,
    eRank_Trainee,
    eRank_Specialist,
    eRank_Operative,
    eRank_Volunteer,
    EPsiRanks_MAX
};

enum EPerkType
{
    ePerk_None,
    ePerk_SoShallYouFight,
    ePerk_PrecisionShot,
    ePerk_SquadSight,
    ePerk_GeneMod_SecondHeart,
    ePerk_LowProfile,
    ePerk_RunAndGun,
    ePerk_AutopsyRequired,
    ePerk_BattleScanner,
    ePerk_DisablingShot,
    ePerk_Opportunist,
    ePerk_Executioner,
    ePerk_OTS_Leader,
    ePerk_DoubleTap,
    ePerk_InTheZone,
    ePerk_DamnGoodGround,
    ePerk_SnapShot,
    ePerk_WillToSurvive,
    ePerk_FireRocket,
    ePerk_HoloTargeting,
    ePerk_GeneMod_Adrenal,
    ePerk_FocusedSuppression,
    ePerk_ShredderRocket,
    ePerk_RapidReaction,
    ePerk_Grenadier,
    ePerk_DangerZone,
    ePerk_ReadyForAnything,
    ePerk_ExtraConditioning,
    ePerk_GeneMod_BrainDamping,
    ePerk_GeneMod_BrainFeedback,
    ePerk_GeneMod_Pupils,
    ePerk_Sprinter,
    ePerk_Aggression,
    ePerk_TacticalSense,
    ePerk_CloseEncounters,
    ePerk_LightningReflexes,
    ePerk_RapidFire,
    ePerk_Flush,
    ePerk_GeneMod_DepthPerception,
    ePerk_BringEmOn,
    ePerk_CloseCombatSpecialist,
    ePerk_KillerInstinct,
    ePerk_GeneMod_BioelectricSkin,
    ePerk_Resilience,
    ePerk_SmokeBomb,
    ePerk_GeneMod_BoneMarrow,
    ePerk_StunImmune,
    ePerk_CoveringFire,
    ePerk_FieldMedic,
    ePerk_Pyrokinesis,
    ePerk_GeneMod_MuscleFiber,
    ePerk_CombatDrugs,
    ePerk_DenseSmoke,
    ePerk_DeepPockets,
    ePerk_Sentinel,
    ePerk_Savior,
    ePerk_Revive,
    ePerk_HeightAdvantage,
    ePerk_LockNLoad,
    ePerk_Sapper,
    ePerk_SuppressedActive,
    ePerk_CriticallyWounded,
    ePerk_Flying,
    ePerk_Stealth,
    ePerk_HEAWarheads,
    ePerk_CombatStimActive,
    ePerk_JavelinRockets,
    ePerk_Panicked,
    ePerk_MindFray,
    ePerk_PsiPanic,
    ePerk_PsiInspiration,
    ePerk_MindControl,
    ePerk_TelekineticField,
    ePerk_Rift,
    ePerk_MindMerge,
    ePerk_MindMerger,
    ePerk_Hardened,
    ePerk_GreaterMindMerge,
    ePerk_GreaterMindMerger,
    ePerk_Evade,
    ePerk_Launch,
    ePerk_Bombard,
    ePerk_Leap,
    ePerk_Plague,
    ePerk_Poison,
    ePerk_BloodCall,
    ePerk_Intimidate,
    ePerk_FallenComrades,
    ePerk_Bloodlust,
    ePerk_BullRush,
    ePerk_HEATAmmo,
    ePerk_SmokeAndMirrors,
    ePerk_Rocketeer,
    ePerk_Mayhem,
    ePerk_Ranger,
    ePerk_GeneMod_MimeticSkin,
    ePerk_ClusterBomb,
    ePerk_PsiLance,
    ePerk_DeathBlossom,
    ePerk_Overload,
    ePerk_PsiControl,
    ePerk_PsiDrain,
    ePerk_Repair,
    ePerk_CannonFire,
    ePerk_Implant,
    ePerk_ChryssalidSpawn,
    ePerk_BattleFatigue,
    ePerk_OnlyForGermanModeStrings_ItemRangeBonus,
    ePerk_OnlyForGermanModeStrings_ItemRangePenalty,
    ePerk_Foundry_Scope,
    ePerk_Foundry_PistolI,
    ePerk_Foundry_PistolII,
    ePerk_TandemWarheads,
    ePerk_Foundry_AmmoConservation,
    ePerk_FireInTheHole,
    ePerk_Foundry_ArcThrowerII,
    ePerk_DeadEye,
    ePerk_Foundry_CaptureDrone,
    ePerk_Foundry_SHIVHeal,
    ePerk_PsychokineticStrike,
    ePerk_Foundry_EleriumFuel,
    ePerk_Foundry_MECCloseCombat,
    ePerk_Foundry_AdvancedServomotors,
    ePerk_Foundry_ShapedArmor,
    ePerk_Foundry_SentinelDrone,
    ePerk_Foundry_AlienGrenades,
    ePerk_LightEmUp,
    ePerk_SeekerStealth,
    ePerk_StealthGrenade,
    ePerk_ReaperRounds,
    ePerk_Disoriented,
    ePerk_Barrage,
    ePerk_AutoThreatAssessment,
    ePerk_AdvancedFireControl,
    ePerk_DamageControl,
    ePerk_VitalPointTargeting,
    ePerk_OneForAll,
    ePerk_JetbootModule,
    ePerk_ExpandedStorage,
    ePerk_RepairServos,
    ePerk_Overdrive,
    ePerk_PlatformStability,
    ePerk_AbsorptionFields,
    ePerk_ShockAbsorbentArmor,
    ePerk_ReactiveTargetingSensors,
    ePerk_BodyShield,
    ePerk_DistortionField,
    ePerk_GeneMod_AdrenalineSurge,
    ePerk_GeneMod_IronSkin,
    ePerk_GeneMod_RegenPheromones,
    ePerk_FieldSurgeon,
    ePerk_CovertHacker,
    ePerk_Medal_UrbanA,
    ePerk_Sharpshooter,
    ePerk_Steadfast,
    ePerk_SmartMacrophages,
    ePerk_LegioPatriaNostra,
    ePerk_BandOfWarriors,
    ePerk_SoOthersMayLive,
    ePerk_LoneWolf,
    ePerk_EspritDeCorps,
    ePerk_IntoTheBreach,
    ePerk_Paramedic,
    ePerk_AimingAnglesBonus,
    ePerk_CatchingBreath,
    ePerk_Foundry_TacticalRigging,
    ePerk_SeekerStrangle,
    ePerk_HitAndRun,
    ePerk_MindMerge_Mechtoid,
    ePerk_Electropulse,
    ePerk_OTS_Leader_Bonus,
    ePerk_OTS_Leader_TheLeader,
    ePerk_MAX
};


struct TSightLineItemIcon
{
    var EItemType eIcon;
    var float fDistanceFromTarget;
};
struct TSoldierStatProgression
{
    var ESoldierRanks eRank;
    var ESoldierClass eClass;
    var int iHP;
    var int iAim;
    var int iDefense;
    var int iWill;
    var int iMobility;
};

struct native TVolume
{
    var EVolumeType eType;
    var int iDuration;
    var float fRadius;
    var float fHeight;
    var Color clrVolume;
    var int aEffects[255];
};

struct TCharacterBalance 
{
	var ECharacter eType;
    var int iDamage;
    var int iCritHit;
    var int iAim;
    var int iDefense;
    var int iHP;
    var int iMobility;
    var int iWill;

};

struct TAppearance
{
    var int iHead;
    var int iGender;
    var int iRace;
    var int iHaircut;
    var int iHairColor;
    var int iFacialHair;
    var int iBody;
    var int iBodyMaterial;
    var int iSkinColor;
    var int iEyeColor;
    var int iFlag;
    var int iArmorSkin;
    var int iVoice;
    var int iLanguage;
    var int iAttitude;
    var int iArmorDeco;
    var int iArmorTint;
};

struct TInventory
{
    var int iArmor;
    var int iPistol;
    var const int arrLargeItems[16];
    var const int iNumLargeItems;
    var const int arrSmallItems[16];
    var const int iNumSmallItems;
    var const int arrCustomItems[16];
    var const int iNumCustomItems;
};

struct TCharacter
{
    var string strName;
    var int iType;
    var TInventory kInventory;
    var int aUpgrades[EPerkType];
    var int aAbilities[EAbility];
    var int aProperties[ECharacterProperty];
    var int aStats[ECharacterStat];
    var int aTraversals[ETraversalType];
    var ESoldierClass eClass;
    var bool bHasPsiGift;
    var float fBioElectricParticleScale;
};

struct TClass
{
    var string strName;
    var ESoldierClass eType;
    var int eTemplate;
    var EWeaponProperty eWeaponType;
    var int aAbilities[16];
    var int aAbilityUnlocks[16];
};

struct TSoldier
{
    var int iID;
    var string strFirstName;
    var string strLastName;
    var string strNickName;
    var int iRank;
    var int iPsiRank;
    var int iCountry;
    var int iXP;
    var int iPsiXP;
    var int iNumKills;
    var TAppearance kAppearance;
    var TClass kClass;
    var bool bBlueshirt;
};

struct TConfigCharacter extends TCharacter
{
    var int HP;
    var int Offense;
    var int Defense;
    var int Mobility;
    var int SightRadius;
    var int Will;
    var int ShieldHP;
    var int CritHitChance;
    var int CritWoundChance;
    var int FlightFuel;
    var int Reaction;
    var EAbility ABILITIES[8];
    var ECharacterProperty Properties[6];
    var bool bCanUse_eTraversal_Normal;
    var bool bCanUse_eTraversal_ClimbOver;
    var bool bCanUse_eTraversal_ClimbOnto;
    var bool bCanUse_eTraversal_ClimbLadder;
    var bool bCanUse_eTraversal_DropDown;
    var bool bCanUse_eTraversal_Grapple;
    var bool bCanUse_eTraversal_Landing;
    var bool bCanUse_eTraversal_BreakWindow;
    var bool bCanUse_eTraversal_KickDoor;
    var bool bCanUse_eTraversal_JumpUp;
    var bool bCanUse_eTraversal_WallClimb;
    var bool bCanUse_eTraversal_BreakWall;
};

struct TWeapon
{
    var string strName;
    var int iType;
    var int aAbilities[EAbility];
    var int aProperties[EWeaponProperty];
    var int iDamage;
    var int iEnvironmentDamage;
    var int iRange;
    var int iReactionRange;
    var int iReactionAngle;
    var int iRadius;
    var int iCritical;
    var int iOffenseBonus;
    var int iSuppression;
    var int iSize;
    var int iHPBonus;
    var int iWillBonus;
};

struct TArmor
{
    var string strName;
    var int iType;
    var int aAbilities[EAbility];
    var int aProperties[EArmorProperty];
    var int iHPBonus;
    var int iDefenseBonus;
    var int iFlightFuel;
    var int iWillBonus;
    var int iLargeItems;
    var int iSmallItems;
    var int iMobilityBonus;
};

struct native TConfigAbility
{
    var EAbilityEffect Effects[4];
    var EAbilityProperty Properties[8];
    var EAbilityDisplayProperty DisplayProperties[2];
};

struct TAbility
{
    var string strName;
    var int iType;
    var int iCategory;
    var int iTargetType;
    var int iRange;
    var int iDuration;
    var int iCooldown;
    var int iCharges;
    var int aEffects[EAbilityEffect];
    var int aProperties[EAbilityProperty];
    var int aDisplayProperties[EAbilityDisplayProperty];
    var int aTargetStats[ECharacterStat];
    var string strHelp;
    var string strTargetMessage;
    var int iTargetMsgColor;
    var string strPerformerMessage;
    var int iPerformerMsgColor;
    var int iPossibleDamage;
    var int iReactionCost;
};

struct TSightlineEnemy
{
    var float fDistance;
    var bool bFlanked;
    var int iDefense;
    var bool bHeightAdvantage;
    var bool bLineOfSight;
    var float fDistanceToSightBlock;
};

struct TSightLineSpecialIcon
{
    var ESightLineSpecialIcon eIcon;
    var float fDistanceFromTarget;
};

struct TSightLine
{
    var float fLength;
    var ESightLineEffect eEffect;
    var array<TSightLineItemIcon> arrItemIcons;
    var array<TSightLineSpecialIcon> arrSpecialIcons;
};
struct TItemBalance
{
    var EItemType eItem;
    var int iEng;
    var int iCash;
    var int iAlloys;
    var int iElerium;
    var int iTime;
};


struct TTechBalance
{
    var ETechType eTech;
    var int iTime;
    var int iAlloys;
    var int iElerium;
    var int iNumFragments;
    var int iNumItems;
};

struct TFoundryBalance
{
    var EFoundryTech eTech;
    var int iTime;
    var int iEngineers;
    var int iCash;
    var int iAlloys;
    var int iElerium;
    var int iFragments;
    var int iNumItems;
    var EItemType eReqItem;
    var ETechType eReqTech;
};


struct TOTSBalance
{
    var EOTSTech eTech;
    var int iCash;
    var ESoldierRanks eRank;
};

struct TFacilityBalance
{
    var EFacilityType eFacility;
    var int iTime;
    var int iCash;
    var int iAlloys;
    var int iElerium;
    var int iMaintenance;
    var int iPower;
};

struct TContinentBalance
{
    var EContinent eCont;
    var int iEngineers1;
    var int iScientists1;
    var int iEngineers2;
    var int iScientists2;
    var int iEngineers3;
    var int iScientists3;
    var int iEngineers4;
    var int iScientists4;
};

struct TConfigPerkWeapon
{
    var EPerkType ePerk;
    var EItemType eWeapon;
    var ESoldierClass ePadding;
    var ESoldierClass ePadding2;
};

struct TConfigWeapon extends TWeapon
{
    var EAbility ABILITIES[6];
    var EWeaponProperty Properties[6];
};

struct TConfigArmor extends TArmor
{
    var EAbility ABILITIES[4];
    var EArmorProperty Properties[4];
};

var config int LOW_COVER_BONUS;
var config int HIGH_COVER_BONUS;
var config float HUNKER_BONUS;
var config int AIR_EVADE_DEF;
var config int NO_COVER_DEF;
var config float REACTION_PENALTY;
var config float DASHING_REACTION_MODIFIER;
var config int FOUNDRY_PISTOL_AIM_BONUS;
var config int FOUNDRY_SCOPE_CRIT_BONUS;
var config int FOUNDRY_PISTOL_CRIT_BONUS;
var config int HARDENED_ENEMY_CRIT_VALUE;
var config int FLANKING_CRIT_BONUS;
var config int POISONED_AIM_PENALTY;
var array<TCharacter> m_arrCharacters;
var array<TWeapon> m_arrWeapons;
var array<TArmor> m_arrArmors;
var repnotify XGAbilityTree m_kAbilities;
var config array<config TConfigCharacter> Characters;
var config array<config TConfigWeapon> Weapons;
var config array<config TConfigArmor> Armors;
var const localized string m_aRankNames[255];
var const localized string m_aRankAbbr[255];
var const localized string m_aPsiRankNames[10];
var const localized string m_aPsiRankAbbr[10];
var const localized string m_strYearSuffix;
var const localized string m_strMonthSuffix;
var const localized string m_strDaySuffix;
var config array<config TCharacterBalance> BalanceMods_Easy;
var config array<config TCharacterBalance> BalanceMods_Normal;
var config array<config TCharacterBalance> BalanceMods_Hard;
var config array<config TCharacterBalance> BalanceMods_Classic;
var config array<config TContinentBalance> ContBalance_Easy;
var config array<config TContinentBalance> ContBalance_Normal;
var config array<config TContinentBalance> ContBalance_Hard;
var config array<config TContinentBalance> ContBalance_Classic;
var config array<config TItemBalance> ItemBalance_Easy;
var config array<config TItemBalance> ItemBalance_Normal;
var config array<config TItemBalance> ItemBalance_Hard;
var config array<config TItemBalance> ItemBalance_Classic;
var config array<config TTechBalance> TechBalance;
var config array<config TFacilityBalance> FacilityBalance;
var config array<config TFoundryBalance> FoundryBalance;
var config array<config TOTSBalance> OTSBalance;
var config array<config float> FundingBalance;
var config array<config int> FundingAmounts;
var config array<config TConfigPerkWeapon> PerkWeapons;
var config int CYBERDISC_ELERIUM;
var config int HFLOATER_ELERIUM;
var config int DRONE_ELERIUM;
var config int SECTOPOD_ELERIUM;
var config int MECHTOID_ELERIUM;
var config int CYBERDISC_ALLOYS;
var config int HFLOATER_ALLOYS;
var config int DRONE_ALLOYS;
var config int SECTOPOD_ALLOYS;
var config int MECHTOID_ALLOYS;
var config int MECHTOID_MELD;
var config int HFLOATER_MELD;
var config int EXALT_LOOT1;
var config int EXALT_LOOT2;
var config int EXALT_LOOT3;
var config float MIN_SCATTER;
var config float REFLECT_DMG;
var config array<config float> FragmentBalance;
var config array<config float> TerrorInfectionChance;
var config array<config float> ThinManPlagueSlider;
var config array<config float> DeathBlossomSlider;
var config array<config float> BloodCallSlider;
var config array<config float> AlienGrenadeSlider;
var config array<config float> SmokeGrenadeSlider;
var config array<config int> MaxActiveAIUnits;
var config float CLOSE_RANGE;
var config int ASSAULT_LONG_RANGE_MAX_PENALTY;
var config float AIM_CLIMB;
var config float ASSAULT_AIM_CLIMB;
var config float SNIPER_AIM_FALL;
var config int ABDUCTION_LURK_PCT;
var config int SMALL_UFO_LURK_PCT;
var config int LARGE_UFO_LURK_PCT;
var config int GRAPPLE_DIST;
var config int MAX_CRIT_WOUND;
var config int SHOOT_WHEN_PANICKED;
var config int HUNKER_DOWN_WHEN_PANICKED;
var config int PANIC_SHOT_HIT_PENALTY;
var config int MIND_CONTROL_DIFFICULTY;
var config int URBAN_DEFENSE;
var config int URBAN_AIM;
var config int DEFENDER_MEDIKIT;
var config int INTERNATIONAL_WILL;
var config int INTERNATIONAL_AIM;
var config int TERRA_WILL;
var config int TERRA_DEFENSE;
var config int TERRA_XP;
var config int COUNCIL_STAT_BONUS;
var config int COUNCIL_STAT_MAX;
var config int COUNCIL_FIGHT_BONUS;
var config int COUNCIL_FIGHT_TILES;
var config float ABDUCTION_REWARD_CASH;
var config float ABDUCTION_REWARD_SCI;
var config float ABDUCTION_REWARD_ENG;
var config float COUNCIL_DAY;
var config float COUNCIL_RAND_DAYS;
var config float COUNCIL_FUNDING_MULTIPLIER_EASY;
var config float COUNCIL_FUNDING_MULTIPLIER_NORMAL;
var config float COUNCIL_FUNDING_MULTIPLIER_HARD;
var config float COUNCIL_FUNDING_MULTIPLIER_CLASSIC;
var config int ShowUFOsOnMission;
var config int AI_TERRORIZE_MOST_PANICKED;
var config int LATE_UFO_CHANCE;
var config int EARLY_UFO_CHANCE;
var config int UFO_LIMIT;
var config int UFO_INTERCEPTION_PCT;
var config array<config int> UFOAlloys;
var config float MIN_WRECKED_ALLOYS;
var config float MAX_WRECKED_ALLOYS;
var config float MAX_LOST_WRECKED_ELERIUM;
var config float MIN_LOST_WRECKED_ELERIUM;
var config int HQASSAULT_MIN_DAYS;
var config int HQASSAULT_MAX_DAYS;
var config float TECH_TIME_BALANCE;
var config float ITEM_TIME_BALANCE;
var config float ITEM_CREDIT_BALANCE;
var config float ITEM_ELERIUM_BALANCE;
var config float ITEM_ALLOY_BALANCE;
var config float ITEM_MELD_BALANCE;
var config float FACILITY_COST_BALANCE;
var config float FACILITY_MAINTENANCE_BALANCE;
var config float FACILITY_TIME_BALANCE;
var config array<config float> ALLOY_UFO_BALANCE;
var config array<config float> UFO_ELERIUM_PER_POWER_SOURCE;
var config int NUM_STARTING_SCIENTISTS;
var config int LAB_MINIMUM;
var config int LAB_MULTIPLE;
var config float LAB_BONUS;
var config float LAB_ADJACENCY_BONUS;
var config int NUM_STARTING_ENGINEERS;
var config int WORKSHOP_MINIMUM;
var config int WORKSHOP_MULTIPLE;
var config int WORKSHOP_REBATE_PCT;
var config int WORKSHOP_ENG_BONUS;
var config int UPLINK_MULTIPLE;
var config int NEXUS_MULTIPLE;
var config int NUM_STARTING_SOLDIERS;
var config int BARRACKS_CAPACITY;
var config int LOW_AIM;
var config int HIGH_AIM;
var config int LOW_MOBILITY;
var config int HIGH_MOBILITY;
var config int LOW_WILL;
var config int HIGH_WILL;
var config int ROOKIE_AIM;
var config int ROOKIE_MOBILITY;
var config int ROOKIE_STARTING_WILL;
var config float PSI_GIFT_CHANCE;
var config int PSI_TEST_LIMIT;
var config int PSI_TRAINING_HOURS;
var config int PSI_NUM_TRAINING_SLOTS;
var config int BASE_DAYS_INJURED;
var config int RAND_DAYS_INJURED;
var config int SOLDIER_COST;
var config int SOLDIER_COST_HARD;
var config int SOLDIER_COST_CLASSIC;
var config array<config TSoldierStatProgression> SoldierStatProgression;
var config int iRandWillIncrease;
var config int iBaseOTSWillIncrease;
var config int iRandOTSWillIncrease;
var config int BASE_DAYS_INJURED_TANK;
var config int RAND_DAYS_INJURED_TANK;
var config int ALLOY_SHIV_HP_BONUS;
var config int HOVER_SHIV_HP_BONUS;
var config int HQ_STARTING_MONEY;
var config array<config int> BASE_FUNDING;
var config array<config int> HQ_BASE_POWER;
var config int POWER_NORMAL;
var config int POWER_THERMAL;
var config int POWER_ELERIUM;
var config int POWER_ADJACENCY_BONUS;
var config int NUM_STARTING_STEAM_VENTS;
var config int INTERCEPTOR_REFUEL_HOURS;
var config int INTERCEPTOR_REPAIR_HOURS;
var config int INTERCEPTOR_REARM_HOURS;
var config int INTERCEPTOR_TRANSFER_TIME;
var config int BASE_SKYRANGER_MAINTENANCE;
var config int SKYRANGER_CAPACITY;
var config int UPLINK_CAPACITY;
var config int UPLINK_ADJACENCY_BONUS;
var config int NEXUS_CAPACITY;
var config int BASE_EXCAVATE_CASH_COST;
var config int BASE_REMOVE_CASH_COST;
var config int BASE_EXCAVATE_DAYS;
var config int BASE_REMOVAL_DAYS;
var config int UFO_CRASH_TIMER;
var config int TERROR_TIMER;
var config int UFO_LANDED_TIMER;
var config int ABDUCTION_TIMER;
var config float UFO_PS_SURVIVE;
var config float UFO_NAV_SURVIVE;
var config float UFO_STASIS_SURVIVE;
var config float UFO_SURGERY_SURVIVE;
var config float UFO_ENTERTAINMENT_SURVIVE;
var config float UFO_FOOD_SURVIVE;
var config float UFO_HYPERWAVE_SURVIVE;
var config float UFO_FUSION_SURVIVE;
var config float UFO_PSI_LINK_SURVIVE;
var config float UFO_FIND_STEALTH_SAT;
var config float UFO_FIND_SAT;
var config float UFO_SECOND_PASS_FIND_STEALTH_SAT;
var config float UFO_SECOND_PASS_FIND_SAT;
var config int PANIC_TERROR_CONTINENT;
var config int PANIC_TERROR_COUNTRY;
var config int PANIC_UFO_SHOOTDOWN;
var config int PANIC_UFO_ASSAULT;
var config int PANIC_SAT_DESTROYED_CONTINENT;
var config int PANIC_SAT_DESTROYED_COUNTRY;
var config int PANIC_SAT_ADDED_COUNTRY;
var config int PANIC_SAT_ADDED_CONTINENT;
var config int PANIC_ALIENBASE_CONQUERED;
var config int PANIC_ALIENBASE_CONQUERED_CLASSIC_AND_IMPOSSIBLE;
var config int PANIC_EXALT_RAIDED;
var config int PANIC_EXALT_RAIDED_CLASSIC_AND_IMPOSSIBLE;
var config int PANIC_UFO_IGNORED;
var config int PANIC_UFO_ESCAPED;
var config int PANIC_ABDUCTION_COUNTRY_EASY;
var config int PANIC_ABDUCTION_COUNTRY_NORMAL;
var config int PANIC_ABDUCTION_COUNTRY_HARD;
var config int PANIC_ABDUCTION_COUNTRY_CLASSIC;
var config int PANIC_ABDUCTION_CONTINENT_EASY;
var config int PANIC_ABDUCTION_CONTINENT_NORMAL;
var config int PANIC_ABDUCTION_CONTINENT_HARD;
var config int PANIC_ABDUCTION_CONTINENT_CLASSIC;
var config int PANIC_ABDUCTION_THWARTED_CONTINENT;
var config int PANIC_ABDUCTION_THWARTED_COUNTRY;
var config int STARTING_PANIC_EASY;
var config int STARTING_PANIC_NORMAL;
var config int STARTING_PANIC_HARD;
var config int STARTING_PANIC_CLASSIC;
var config int PANIC_DEFECT_THRESHHOLD_EASY;
var config int PANIC_DEFECT_THRESHHOLD_NORMAL;
var config int PANIC_DEFECT_THRESHHOLD_HARD;
var config int PANIC_DEFECT_THRESHHOLD_CLASSIC;
var config int PANIC_DEFECT_THRESHHOLD_NOT_HELPED_EASY;
var config int PANIC_DEFECT_THRESHHOLD_NOT_HELPED_NORMAL;
var config int PANIC_DEFECT_THRESHHOLD_NOT_HELPED_HARD;
var config int PANIC_DEFECT_THRESHHOLD_NOT_HELPED_CLASSIC;
var config int PANIC_DEFECTIONS_PER_MONTH_EASY;
var config int PANIC_DEFECTIONS_PER_MONTH_NORMAL;
var config int PANIC_DEFECTIONS_PER_MONTH_HARD;
var config int PANIC_DEFECTIONS_PER_MONTH_CLASSIC;
var config int PANIC_DEFECT_CHANCE_PER_BLOCK_EASY;
var config int PANIC_DEFECT_CHANCE_PER_BLOCK_NORMAL;
var config int PANIC_DEFECT_CHANCE_PER_BLOCK_HARD;
var config int PANIC_DEFECT_CHANCE_PER_BLOCK_CLASSIC;
var config array<config float> SAT_HELP_DEFECT;
var config array<config float> SAT_NEARBY_HELP_DEFECT;
var config array<config int> SAT_PANIC_REDUCTION_PER_MONTH;
var config array<config int> PANIC_5_REDUCTION_CHANCE;
var config array<config int> PANIC_4_REDUCTION_CHANCE;
var config array<config int> PANIC_LOW_REDUCTION_CHANCE;
var config int CB_FUNDING_BONUS;
var config int CB_FUTURECOMBAT_BONUS;
var config int CB_AIRANDSPACE_BONUS;
var config int CB_EXPERT_BONUS;
var config int ENABLE_SECOND_WAVE;
var config float SW_FLANK_CRIT;
var config float SW_COVER_INCREASE;
var config float SW_SATELLITE_INCREASE;
var config float SW_ELERIUM_HALFLIFE;
var config float SW_ELERIUM_LOSS;
var config float SW_ABDUCTION_SITES;
var config float SW_RARE_PSI;
var config float SW_MARATHON;
var config float SW_MORE_POWER;
var config float SW_AIMING_ANGLE_THRESHOLD;
var config float SW_AIMING_ANGLE_MINBONUS;
var config float SW_AIMING_ANGLE_MAXBONUS;
var config int SPECIES_POINT_LIMIT;
var config float KILL_CAM_MIN_DIST;
var config float GENEMOD_BONEMARROW_RECOVERY_BONUS;

simulated event Init();

// Export UXGTacticalGameCoreNativeBase::execCharacterHasProperty(FFrame&, void* const)
native simulated function bool CharacterHasProperty(int iCharType, int iCharacterProperty);

// Export UXGTacticalGameCoreNativeBase::execGetTCharacter(FFrame&, void* const)
native simulated function TCharacter GetTCharacter(int iCharacter);

// Export UXGTacticalGameCoreNativeBase::execArmorHasProperty(FFrame&, void* const)
native simulated function bool ArmorHasProperty(int iArmor, int iArmorProperty);

// Export UXGTacticalGameCoreNativeBase::execIsOptionEnabled(FFrame&, void* const)
native simulated function bool IsOptionEnabled(XGGameData.EGameplayOption eOption);

// Export UXGTacticalGameCoreNativeBase::execGetLowCoverBonus(FFrame&, void* const)
native simulated function int GetLowCoverBonus();

// Export UXGTacticalGameCoreNativeBase::execGetHighCoverBonus(FFrame&, void* const)
native simulated function int GetHighCoverBonus();

// Export UXGTacticalGameCoreNativeBase::execGetFlankingCritBonus(FFrame&, void* const)
native simulated function int GetFlankingCritBonus(bool bMine);

// Export UXGTacticalGameCoreNativeBase::execGetHardenedCritBonus(FFrame&, void* const)
native simulated function int GetHardenedCritBonus();

// Export UXGTacticalGameCoreNativeBase::execTInventoryLargeItemsAdd(FFrame&, void* const)
native static final function int TInventoryLargeItemsAdd(out TInventory kInventory, int iCount);

// Export UXGTacticalGameCoreNativeBase::execTInventoryLargeItemsRemove(FFrame&, void* const)
native static final function int TInventoryLargeItemsRemove(out TInventory kInventory, int Idx, int iCount);

// Export UXGTacticalGameCoreNativeBase::execTInventoryLargeItemsAddItem(FFrame&, void* const)
native static final function int TInventoryLargeItemsAddItem(out TInventory kInventory, int iItem);

// Export UXGTacticalGameCoreNativeBase::execTInventoryLargeItemsRemoveItem(FFrame&, void* const)
native static final function int TInventoryLargeItemsRemoveItem(out TInventory kInventory, int iItem);

// Export UXGTacticalGameCoreNativeBase::execTInventoryLargeItemsSetItem(FFrame&, void* const)
native static final function int TInventoryLargeItemsSetItem(out TInventory kInventory, int Idx, int iItem);

// Export UXGTacticalGameCoreNativeBase::execTInventoryLargeItemsClear(FFrame&, void* const)
native static final function TInventoryLargeItemsClear(out TInventory kInventory);

// Export UXGTacticalGameCoreNativeBase::execTInventorySmallItemsAdd(FFrame&, void* const)
native static final function int TInventorySmallItemsAdd(out TInventory kInventory, int iCount);

// Export UXGTacticalGameCoreNativeBase::execTInventorySmallItemsRemove(FFrame&, void* const)
native static final function int TInventorySmallItemsRemove(out TInventory kInventory, int Idx, int iCount);

// Export UXGTacticalGameCoreNativeBase::execTInventorySmallItemsAddItem(FFrame&, void* const)
native static final function int TInventorySmallItemsAddItem(out TInventory kInventory, int iItem);

// Export UXGTacticalGameCoreNativeBase::execTInventorySmallItemsRemoveItem(FFrame&, void* const)
native static final function int TInventorySmallItemsRemoveItem(out TInventory kInventory, int iItem);

// Export UXGTacticalGameCoreNativeBase::execTInventorySmallItemsSetItem(FFrame&, void* const)
native static final function int TInventorySmallItemsSetItem(out TInventory kInventory, int Idx, int iItem);

// Export UXGTacticalGameCoreNativeBase::execTInventorySmallItemsClear(FFrame&, void* const)
native static final function TInventorySmallItemsClear(out TInventory kInventory);

// Export UXGTacticalGameCoreNativeBase::execTInventoryCustomItemsAdd(FFrame&, void* const)
native static final function int TInventoryCustomItemsAdd(out TInventory kInventory, int iCount);

// Export UXGTacticalGameCoreNativeBase::execTInventoryCustomItemsRemove(FFrame&, void* const)
native static final function int TInventoryCustomItemsRemove(out TInventory kInventory, int Idx, int iCount);

// Export UXGTacticalGameCoreNativeBase::execTInventoryCustomItemsAddItem(FFrame&, void* const)
native static final function int TInventoryCustomItemsAddItem(out TInventory kInventory, int iItem);

// Export UXGTacticalGameCoreNativeBase::execTInventoryCustomItemsRemoveItem(FFrame&, void* const)
native static final function int TInventoryCustomItemsRemoveItem(out TInventory kInventory, int iItem);

// Export UXGTacticalGameCoreNativeBase::execTInventoryCustomItemsSetItem(FFrame&, void* const)
native static final function int TInventoryCustomItemsSetItem(out TInventory kInventory, int Idx, int iItem);

// Export UXGTacticalGameCoreNativeBase::execTInventoryCustomItemsClear(FFrame&, void* const)
native static final function TInventoryCustomItemsClear(out TInventory kInventory);

// Export UXGTacticalGameCoreNativeBase::execTInventoryCustomItemsFind(FFrame&, void* const)
native static final function int TInventoryCustomItemsFind(out TInventory kInventory, int iItem);

// Export UXGTacticalGameCoreNativeBase::execTInventoryHasItemType(FFrame&, void* const)
native static final function bool TInventoryHasItemType(const out TInventory kInventory, int iItem);

static final function string AbilityTypeToString(EAbility iAbilityType){}
static final function string PerkTypeToString(EPerkType ePerk){}
static final function string SoldierRankToString(ESoldierRanks eSoldierRank){}
static final function EGender RandomGender(){}
static final function bool IsMedalPerk(EPerkType ePerk){}
native simulated function int CalcSuppression();
native simulated function int CalcCritChance(int iWeapon, out TCharacter kShooter, out int aShooterStats[ECharacterStat], XGUnitNativeBase kTarget, XGUnitNativeBase kAttacker, int iTargetCoverValue, bool bHasHeightBonus, float fDistanceToTarget, bool bHasFlank, bool bReactionFire, int iWeaponBonus);
native simulated function int CalcPossibleDamage(int iWeapon, int iAbility, out TCharacter kCharacter, out int aCurrentStats[ECharacterStat], out int iTargetDefense, optional bool bOverload, optional bool bCritical, optional bool bHasHeightBonus, optional float fDistanceToTarget, optional bool bUseFlankBonus, optional bool bReactionFire);
native simulated function int GetArmorStatBonus(int iStat, int iArmor, TCharacter kCharacter);
native simulated function int GetWeaponStatBonus(int iStat, int iWeapon, const out TCharacter kCharacter);
native simulated function int CalcBaseHitChance(XGUnitNativeBase kShooter, XGUnitNativeBase kTarget, bool bReactionFire);
native simulated function int CalcStunChance(XGUnit kVictim, XGUnit kAttacker, XGWeapon kWeapon);
native simulated function int CalcRangeModForWeapon(int iWeapon, XGUnit kViewer, XGUnit kTarget);
native simulated function int CalcRangeModForWeaponAt(int iWeapon, XGUnit kViewer, XGUnit kTarget, Vector vViewerLoc);
native simulated function int GetAmmoCost(int iWeapon, int iAbility, bool bHasAmmoConservation, optional out TCharacter kCharacter, optional bool bReactionFire);
native simulated function int GetReactionAmmoCost(int iWeapon, const out TCharacter kCharacter, bool bHasAmmoConservation);
native simulated function bool CanMindControl(XGGameData.ECharacter eCharType);
native simulated function Vector GetRocketLauncherFirePos(XComUnitPawnNativeBase kPawn, Vector TargetLocation, bool bRocketShot);
native simulated function int CalcInternationalWillBonus();
native simulated function int CalcInternationalAimBonus();
native simulated function int CalcAimingAngleMod(XGUnitNativeBase FiringUnit, XGUnitNativeBase TargetUnit);
simulated event ReplicatedEvent(name VarName){}
