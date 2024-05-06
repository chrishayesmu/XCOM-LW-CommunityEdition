class XGTacticalGameCoreNativeBase extends Actor
    abstract
    native(Core)
    dependson(XComWorldData)
    config(GameCore)
    notplaceable
    hidecategories(Navigation);

const SCREEN_PC_BUFFER = 0.25f;
const FLYING_MAXPATHCOST = 20;
const WEAPON_COOLDOWN_PER_TURN = 5;
const WEAPON_OVERHEAT_BASE = 0;
const GRENADE_TOUCH_RADIUS = 46.0f;
const FLUSH_MIN_DIST = 480;
const FLUSH_AIM_BONUS = 30;
const FLUSH_DMG_REDUCTION = 0.50f;
const FALLENCOMRADES_PENALTY = 5;
const BATTLEFATIGUE_PENALTY = 5;
const BATTLEFATIGUE_1 = 1.0f;
const BATTLEFATIGUE_2 = 0.51f;
const AIM_BONUS = 20;
const PRECISION_SHOT_DAMAGE_BONUS = 2;
const PRECISION_SHOT_CRITICAL_CHANCE_BONUS = 30;
const TELEKINETIC_FIELD_DEFENSE_BONUS = 40;
const MINDFRAY_MOBILITY_PENALTY = 0.5;
const BRING_EM_ON_DAMAGE_BONUS = 1;
const BRING_EM_ON_MAX_ENEMIES = 5;
const BUTTON_UP_SHOT_OFFENSE_MOD = -20;
const DANGER_ZONE_RADIUS_BONUS = 192;
const DAMN_GOOD_GROUND_OFFENSE_BONUS = 10;
const DAMN_GOOD_GROUND_DEFENSE_BONUS = 10;
const SNAP_SHOT_AIM_PENALTY = 10;
const DENSE_SMOKE_DEFENSE_BONUS = 20;
const SMOKE_BOMB_DEFENSE_BONUS = 20;
const COMBAT_DRUGS_CRITICAL_CHANCE_BONUS = 10;
const COMBAT_DRUGS_WILL_BONUS = 20;
const BASE_NUM_ROCKETS = 1;
const ROCKETEER_BONUS_ROCKETS = 1;
const BASE_SMOKE_BOMBS = 1;
const SMOKEANDMIRROR_BONUS_BOMBS = 2;
const EXALT_ELITE_MEDIC_SMOKE_BOMBS = 2;
const HEATAMMO_DMG_MULTIPLIER = 1.5f;
const TRACER_BEAMS_BONUS = 10;
const BASE_BATTLESCANNERS = 2;
const CHITIN_PLATING_DMG_MULT = 0.5f;
const COMBAT_STIM_DMG_MULT = 0.5f;
const COMBAT_STIM_WILL_BONUS = 40;
const COMBAT_STIM_MOBILITY_BONUS = 4;
const EXECUTIONER_AIM_BONUS = 10;
const EXECUTIONER_HP_MIN = 0.5f;
const BATTLE_SCANNER_DURATION = 2;
const AGGRESSION_CRIT_BONUS = 10;
const AGGRESSION_MAX_ENEMIES = 3;
const TACTICALSENSE_DEFENSE_BONUS = 5;
const TACTICALSENSE_MAX_ENEMIES = 4;
const CLOSECOMBATSPECIALIST_RANGE = 6;
const WILLTOSURVIVE_DMG_REDUCTION = 2;
const KILLERINSTINCT_CRIT_DMG_MULT = 0.5f;
const SHREDDER_ROCKET_DURATION = 4;
const FIELDMEDIC_CHARGES = 3;
const GRENADIER_CHARGES = 2;
const GRENADIER_DMG_BONUS = 1;
const PSIINSPIRED_WILL_BONUS = 30;
const REGENPHEROMONE_RANGE = 6;
const COVERTPOCKETS_CHARGES = 2;
const MP_STEALTH_CHARGES = 5;
const DOUBLETAP_COOLDOWN = 3;
const BLOODCALL_AIM_BONUS = 10;
const BLOODCALL_WILL_BONUS = 10;
const BLOODCALL_MOBILITY_BONUS = 4;
const MINDMERGE_CRIT_BONUS = 25;
const MINDMERGE_HP_BONUS = 1;
const MINDMERGE_MECHTOID_WHIPLASH_HP_DAMAGE = 3;
const SHIELD_DAMAGE_MODIFIER = 0.5f;
const LOW_AMMO_PERCENT = 23;
const SPREAD_THETA = 75;
const MAX_SPREAD_LENGTH = 576;
const DEATH_BLOSSOM_RANGE = 384;
const DEATH_BLOSSOM_COOLDOWN = 4;
const DEATH_BLOSSOM_DAMAGE_MIN = 4;
const DEATH_BLOSSOM_DAMAGE_MAX = 6;
const MINDFRAY_BASE_DMG = 5;
const FLAME_NUM_BURN_TURNS = 4;
const FLAME_MAX_SPREAD_HOPS = 1;
const FLAME_MAX_FIRES_FROM_EXPLOSION = 4;
const SMOKE_NUM_TURNS = 4;
const DENSE_SMOKE_RADIUS_MULT = 1.25f;
const POISONED_DAMAGE_PER_TURN = 1;
const POISONED_REACTION_PENALTY = 0.5f;
const POISONED_MOVEMENT_PENALTY = 0.25f;
const POISONED_INITIAL_DURATION = 2;
const POISONED_REMISSION_CHANCE_1 = 0.33f;
const POISONED_REMISSION_CHANCE_2 = 0.66f;
const POISON_ATTACK_CHANCE = 0.5f;
const POISON_NUM_TURNS = 4;
const RAPIDFIRE_AIM_PENALTY = 15;
const DISABLINGSHOT_AIM_PENALTY = 10;
const CHRYSSALID_SPAWN_HP_REDUCTION = 4;
const FLAME_UNIT_DOT = 2;
const ACID_UNIT_DOT = 6;
const FLAME_WORLD_DOT = 201;
const ACID_WORLD_DOT = 201;
const STATIC_HEIGHT_BONUS_Z = 192.0f;
const HEIGHT_OFF_BONUS = 20;
const HEARING_RADIUS = 40.0f;
const CRITICAL_BLEED_OUT = 3;
const BASE_CRITWOUND_CHANCE = 15;
const OTS_CRITICAL_WOUND_BONUS = 5;
const CRITWOUND_WILL_PENALTY = 15;
const LUCK_ROLL_BONUS = 5;
const CB_XP_BONUS = 0.25f;
const PANIC_TURNS = 1;
const PANIC_RANDOM_TURNS = 0;
const PANIC_BASE_VALUE = 30;
const MEDIKIT_HEAL_HP = 4;
const MEDIKIT_FOUNDRY_BONUS = 2;
const MEDIKIT_SAVIOR_BONUS = 4;
const REVIVE_HEALTH_AMOUNT = 0.33f;
const SPRINTER_MOBILITY_BONUS = 4;
const RAPIDREACTION_MIN_DIST = 192;
const TRACER_BEAM_DURATION = 1;
const CLUSTER_BOMB_PREVIEW_RADIUS = 432;
const MIN_TIME_ARC_HEIGHT = 3.0f;
const MAX_TIME_ARC_HEIGHT = 6.0f;
const MAX_ENGAGED_AI = 5;
const MIN_AI_TURN_LENGTH = 4;
const MAX_OVERMIND_REVEAL_TILES = 4;
const OVERLOAD_DAMAGE_DRONE = 3;
const DEATH_DAMAGE_CYBERDISC = 3;
const DEATH_DAMAGE_SECTOPOD = 5;
const DEATH_DAMAGE_ETHEREAL = 4;
const OVERLOAD_RADIUS_DRONE = 192.0f;
const DEATH_RADIUS_CYBERDISC = 192.0f;
const DEATH_RADIUS_SECTOPOD = 320.0f;
const DEATH_RADIUS_ETHEREAL = 144.0f;
const INTIMIDATE_CHANCE_MUTON = 33;
const INTIMIDATE_CHANCE_BERSERKER = 66;
const CC_RANGE = 3.0f;
const CC_INSTIGATOR_BASE = 20;
const CC_ASSAULT_BONUS = 10;
const CC_SECOND_MOVE_PENALTY = 20;
const CC_RUN_PATH_PCT = 50;
const RIFLE_I_MOB_BONUS = 2;
const RIFLE_II_SUPP_BONUS = 10;
const PISTOL_I_CRIT_BONUS = 25;
const PISTOL_II_DEF_BONUS = 15;
const HEAVY_I_OFF_BONUS = 10;
const HEAVY_II_OFF_BONUS = 20;
const SNIPER_I_OFF_BONUS = 10;
const SNIPER_II_CRIT_BONUS = 25;
const XP_KILL = 50;
const HP_PER_TICK = 1;
const HP_PULSE_PCT = 25;
const LOOT_RANGE = 3;
const LOOT_DESTRUCT_TIMER = 5;
const MIND_PROBE_INTEL = 10;
const NAV_INTEL = 5;
const COVER_DRAW_RADIUS = 1;
const JETPACK_FUEL_HOVER_COST = 1;
const MOVE_INTERVAL_REACTION_PROCESSING = 96.0f;
const SAFE_FROM_REACTION_FIRE_MIN_DIST_TO_DEST = 96.0f;
const REACTION_MINIMUM = 1;
const REACTION_BONUS_FOR_OVERWATCH = 20;
const REACTION_BONUS_FOR_DASH = 20;
const REACTION_FIRE_AMMO_COST_PERCENTAGE = 25;
const REACTION_FIRE_AMMO_COST_PERCENTAGE_HEAVY = 33;
const REPAIR_SHIV_HP = 6;
const STUN_I_HP_THRESHHOLD = 3;
const STUN_II_HP_THRESHHOLD = 6;
const STUN_BASE_CHANCE = 70;
const STUN_MAX_CHANCE = 95;
const STUN_MIN_CHANCE = 1;
const TIMEDILATION_APPROACHRATE = 15.0f;
const TIMEDILATION_MODE_NORMAL = 1.0f;
const TIMEDILATION_MODE_VICTIMOFOVERWATCH = 0.01f;
const TIMEDILATION_MODE_REACTIONFIRING = 0.4f;
const TIMEDILATION_MODE_TRIGGEREDPODACTIVATION = 0.0f;
const CYBERDISC_MIN_CLOSED_MOVE_DIST = 320.0f;
const CYBERDISC_MAX_FLIGHT_DURATION = 3;
const MAX_REPAIRS_PER_TURN = 1;
const DRONE_REPAIR_HP = 3;
const DRONE_COUNT_OVERRIDE = false;
const DRONES_PER_CYBERDISC = 1;
const DRONES_PER_SECTOPOD = 3;
const DRONE_MAX_FLIGHT_DURATION = 6;
const FLOATER_MAX_FLIGHT_DURATION = 3;
const HEAVY_FLOATER_MAX_FLIGHT_DURATION = 4;
const PSI_DRAIN_HP = 4;
const STRANGLE_COOLDOWN_POST_DEATH = 2;
const STRANGLE_COOLDOWN_POST_STRANGLE = 2;
const CATCHINGBREATH_MOVE_PENALTY = 75;
const CATCHINGBREATH_AIM_PENALTY = 50;
const RIFT_MAX_DISTANCE = 100;
const RIFT_DAMAGE_RADIUS = 6.75;
const RIFT_WILL_BALANCE = 20;
const RIFT_WILL_DMG_SLICE = 10;
const RIFT_START_DMG = 8;
const RIFT_END_DMG = 10;
const RIFT_START_DMG_MIN = 4;
const RIFT_END_DMG_MIN = 5;
const PSI_LANCE_WILL_BALANCE = 20;
const PSI_LANCE_WILL_DMG_SLICE = 10;
const PSI_LANCE_BASE_DMG = 7;
const PSI_LANCE_MIN_DMG = 2;
const PSI_LANCE_MAX_DMG = 20;
const TELEKINETIC_FIELD_RADIUS = 12.75;
const PSI_INSPIRE_FIELD_RADIUS = 3.75;
const SUPPRESSION_AIM_PENALTY = 30;
const CLOSEANDPERSONAL_MAX_DIST = 6;
const RAND_DMG_VARIANCE = 1.5f;
const WOUND_AIM_PENALTY = -15;
const WOUND_MOB_PENALTY = -2;
const GENEMOD_PUPILS_BONUS = 10;
const GENEMOD_DEPTHPERCEPTION_AIM = 5;
const GENEMOD_DEPTHPERCEPTION_CRIT = 5;
const GENEMOD_BONEMARROW_HP_REGEN = 2;
const GENEMOD_BRAINDAMPING_WILL = 20;
const GENEMOD_ADRENAL_AIM = 10;
const GENEMOD_ADRENAL_CRIT = 5;
const GENEMOD_ADRENAL_MOBILITY = 2;
const GENEMOD_MIMETICSKIN_CRIT = 30;
const GENEMOD_SECONDHEART_BLEEDOUT = 2;
const GENEMOD_ADRENALINESURGE_AIM = 10;
const GENEMOD_ADRENALINESURGE_CRIT = 10;
const GENEMOD_IRONSKIN_DAMAGE_MULT = 0.25f;
const GENEMOD_REGENPHEROMONES = 1;
const BARRAGE_DMG_REDUCTION = 0.66f;
const ELERIUM_FUEL_DMG_MULTIPLIER = 0.5f;
const KINETIC_STRIKE_MOBILITY = 4;
const FOUNDRY_SERVOMOTORS_MOBILITY = 3;
const FOUNDRY_SHAPEDARMOR_HP = 3;
const MIMICBEACON_CHARGES = 2;
const MIMICBEACON_DURATION = 2;
const MIMICBEACON_MAX_DIST_SQ = 8294400;
const REAPER_ROUNDS_CRIT_BONUS = 20;
const REAPER_ROUNDS_RANGE_PENALTY = 2;
const GHOST_CRIT_BONUS = 30;
const GHOSTGRENADE_CRIT_BONUS = 30;
const FLASHBANG_AIM_PENALTY = -50;
const FLASHBANG_MOVE_PENALTY = 0.50f;
const DAMAGECONTROL_DMG = 2;
const DAMAGECONTROL_TURNS = 2;
const AUTOTHREATASSESMENT_DEFENSE = 15;
const PLATFORMSTABILITY_AIM = 10;
const PLATFORMSTABILITY_CRIT = 10;
const SHOCKABSORBENTARMOR_DMG_MULT = 0.33f;
const SHOCKABSORBENTARMOR_TILES = 4;
const REPAIRSERVOS_HP_REGEN = 2;
const REPAIRSERVOS_HP_MAX = 6;
const ABSORPTIONFIELDS_DMG_LIMIT = 0.33f;
const BODYSHIELD_DEFENSE = 20;
const DISTORTIONFIELD_DEFENSE = 10;
const DISTORTIONFIELD_RADIUS = 432;
const DISTORTIONFIELD_HEIGHT = 384;
const SHIV_SENTINEL_HP = 2;
const CLOSECOMBAT_KINETIC_DMG_BONUS = 0.5f;
const NUM_CONFIG_CHARACTER_ABILITIES = 8;
const NUM_CONFIG_CHARACTER_PROPERTIES = 6;
const NUM_CONFIG_WEAPON_ABILITIES = 6;
const NUM_CONFIG_WEAPON_PROPERTIES = 6;
const NUM_CONFIG_ARMOR_ABILITIES = 4;
const NUM_CONFIG_ARMOR_PROPERTIES = 4;
const NATIVE_RADTODEG = 57.295779513082321600f;
const NATIVE_DEGTORAD = 0.017453292519943296f;
const FLANKINGTOLERANCE = 3.0f;
const OTS_LEADER_RANGE = 768;
const REINFORCEDARMOR_DAMAGE_MULT = 0.5f;
const TINVENTORY_MAX_LARGE_ITEMS = 16;
const TINVENTORY_MAX_SMALL_ITEMS = 16;
const TINVENTORY_MAX_CUSTOM_ITEMS = 16;
const RELATIVE_HEIGHT_BONUS_ZDIFF = 192.0f;
const RELATIVE_HEIGHT_BONUS_WEAPON_RANGE = 1.5f;
const MAX_SIGHTLINES = 10;

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
    ePerk_OTS_XP,
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
    ePerk_TracerBeams,
    ePerk_GeneMod_Adrenal,
    ePerk_FocusedSuppression,
    ePerk_ShredderRocket,
    ePerk_RapidReaction,
    ePerk_Grenadier,
    ePerk_DangerZone,
    ePerk_BulletSwarm,
    ePerk_ExtraConditioning,
    ePerk_GeneMod_BrainDamping,
    ePerk_GeneMod_BrainFeedback,
    ePerk_GeneMod_Pupils,
    ePerk_Sprinter,
    ePerk_Aggression,
    ePerk_TacticalSense,
    ePerk_CloseAndPersonal,
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
    ePerk_RifleSuppression_DEPRECATED,
    ePerk_GeneMod_MuscleFiber,
    ePerk_CombatDrugs,
    ePerk_DenseSmoke,
    ePerk_DeepPockets,
    ePerk_Sentinel,
    ePerk_Savior,
    ePerk_Revive,
    ePerk_HeightAdvantage,
    ePerk_Disabled_DEPRECATED,
    ePerk_ImmuneToDisable_DEPRECATED,
    ePerk_SuppressedActive,
    ePerk_CriticallyWounded,
    ePerk_Flying,
    ePerk_Stealth,
    ePerk_Poisoned,
    ePerk_CombatStimActive,
    ePerk_Implanted,
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
    ePerk_Gunslinger,
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
    ePerk_Foundry_PistolIII,
    ePerk_Foundry_AmmoConservation,
    ePerk_Foundry_AdvancedFlight,
    ePerk_Foundry_ArcThrowerII,
    ePerk_Foundry_MedikitII,
    ePerk_Foundry_CaptureDrone,
    ePerk_Foundry_SHIVHeal,
    ePerk_Foundry_SHIVSuppression,
    ePerk_Foundry_EleriumFuel,
    ePerk_Foundry_MECCloseCombat,
    ePerk_Foundry_AdvancedServomotors,
    ePerk_Foundry_ShapedArmor,
    ePerk_Foundry_SentinelDrone,
    ePerk_Foundry_AlienGrenades,
    ePerk_PlasmaBarrage,
    ePerk_SeekerStealth,
    ePerk_StealthGrenade,
    ePerk_ReaperRounds,
    ePerk_Disoriented,
    ePerk_Barrage,
    ePerk_AutoThreatAssessment,
    ePerk_AdvancedFireControl,
    ePerk_DamageControl,
    ePerk_XenobiologyOverlays,
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
    ePerk_CovertPockets,
    ePerk_CovertHacker,
    ePerk_Medal_UrbanA,
    ePerk_Medal_UrbanB,
    ePerk_Medal_DefenderA,
    ePerk_Medal_DefenderB,
    ePerk_Medal_InternationalA,
    ePerk_Medal_InternationalB,
    ePerk_Medal_CouncilA,
    ePerk_Medal_CouncilB,
    ePerk_Medal_TerraA,
    ePerk_Medal_TerraB,
    ePerk_Dazed,
    ePerk_OnlyForGermanModeStrings_AimingAnglesBonus,
    ePerk_CatchingBreath,
    ePerk_Foundry_TacticalRigging,
    ePerk_SeekerStrangle,
    ePerk_ReinforcedArmor,
    ePerk_MindMerge_Mechtoid,
    ePerk_Electropulse,
    ePerk_OTS_Leader_Bonus,
    ePerk_OTS_Leader_TheLeader,
    ePerk_MAX
};

struct native TWeapon
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

struct native TConfigWeapon extends TWeapon
{
    var EAbility ABILITIES[6];
    var EWeaponProperty Properties[6];
};

struct native TArmor
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

struct native TConfigArmor extends TArmor
{
    var EAbility ABILITIES[4];
    var EArmorProperty Properties[4];
};

struct native TInventory
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

struct native TCharacter
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

struct native TConfigCharacter extends TCharacter
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

struct native TAppearance
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

    structdefaultproperties
    {
        iHead=-1
        iHaircut=-1
        iBody=-1
        iBodyMaterial=-1
        iSkinColor=-1
        iEyeColor=-1
        iFlag=-1
        iArmorSkin=-1
        iVoice=-1
        iArmorDeco=-1
        iArmorTint=-1
    }
};

struct native TClass
{
    var string strName;
    var ESoldierClass eType;
    var int eTemplate;
    var EWeaponProperty eWeaponType;
    var int aAbilities[16];
    var int aAbilityUnlocks[16];
};

struct native TSoldier
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

struct native TVolume
{
    var EVolumeType eType;
    var int iDuration;
    var float fRadius;
    var float fHeight;
    var Color clrVolume;
    var int aEffects[EVolumeEffect];
};

struct native TAbility
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

struct native TConfigAbility
{
    var EAbilityEffect Effects[4];
    var EAbilityProperty Properties[8];
    var EAbilityDisplayProperty DisplayProperties[2];
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

struct TSightLineItemIcon
{
    var EItemType eIcon;
    var float fDistanceFromTarget;
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

struct native TCharacterBalance
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

struct native TItemBalance
{
    var EItemType eItem;
    var int iEng;
    var int iCash;
    var int iAlloys;
    var int iElerium;
    var int iTime;
};

struct native TTechBalance
{
    var ETechType eTech;
    var int iTime;
    var int iAlloys;
    var int iElerium;
    var int iNumFragments;
    var int iNumItems;
};

struct native TFoundryBalance
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

struct native TOTSBalance
{
    var EOTSTech eTech;
    var int iCash;
    var ESoldierRanks eRank;
};

struct native TFacilityBalance
{
    var EFacilityType eFacility;
    var int iTime;
    var int iCash;
    var int iAlloys;
    var int iElerium;
    var int iMaintenance;
    var int iPower;
};

struct native TContinentBalance
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

struct native TSoldierStatProgression
{
    var ESoldierRanks eRank;
    var ESoldierClass eClass;
    var int iHP;
    var int iAim;
    var int iDefense;
    var int iWill;
    var int iMobility;
};

struct native TConfigPerkWeapon
{
    var EPerkType ePerk;
    var EItemType eWeapon;
    var ESoldierClass ePadding;
    var ESoldierClass ePadding2;
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
var const localized string m_aRankNames[ESoldierRanks];
var const localized string m_aRankAbbr[ESoldierRanks];
var const localized string m_aPsiRankNames[EPsiRanks];
var const localized string m_aPsiRankAbbr[EPsiRanks];
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