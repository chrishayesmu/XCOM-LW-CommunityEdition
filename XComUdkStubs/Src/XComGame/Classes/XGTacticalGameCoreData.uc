class XGTacticalGameCoreData extends Actor
    abstract
    native(Core)
    dependson(XGGameData)
    notplaceable
    hidecategories(Navigation);

const CRIT_DMG_MULT = 1.5;

enum EAbilityAvailableCode
{
    eAAvailable_OK,
    eAAvailable_ErrTargetNeutralized,
    eAAvailable_ErrRunAndGunLacksAmmo,
    eAAvailable_RunAndGunHelpMsgOneMove,
    eAAvailable_ErrNoMoveFire,
    eAAvailable_ErrOutofCover,
    eAAvailable_ErrCloseState,
    eAAvailable_ErrTargetEffectExist,
    eAAvailable_ErrLackAmmo,
    eAAvailable_ErrLInTheZoneOnlyPrimary,
    eAAvailable_ErrAlreadyFired,
    eAAvailable_ErrNoTargets,
    eAAvailable_ErrHeavyFiredStandardShotAlready,
    eAAvailable_ErrNoTargetsToHeal,
    eAAvailable_ErrNoTargetsToHealInRange,
    eAAvailable_ErrNoSHIVSToRepair,
    eAAvailable_ErrNoSHIVStoRepairInRange,
    eAAvailable_ErrLackCharges,
    eAAvailable_ErrLackMedikitCharges,
    eAAvailable_ErrAlreadyStabilized,
    eAAvailable_ErrCannotHealCriticalAlly,
    eAAvailable_ErrUnitDoesNotNeedHealing,
    eAAvailable_ErrRequiresPerks,
    eAAvailable_ErrOnCooldown,
    eAAvailable_ErrNoTargetsVisible,
    eAAvailable_ReadyForAnythingOverwatch,
    eAAvailable_ErrTargetIsPanicked,
    eAAvailable_ErrTargetIsAlreadyPsiLinked,
    eAAvailable_ErrAlreadyMindControlling,
    eAAvailable_ErrCannotMindControl,
    eAAvailable_ErrCannotPanic,
    eAAvailable_ErrCannotStunRobots,
    eAAvailable_ErrHackingForDronesOnly,
    eAAvailable_ErrFlyCantLandObstacle,
    eAAvailable_ErrNoFuel,
    eAAvailable_ErrLaunchInAir,
    eAAvailable_ErrLaunchIndoor,
    eAAvailable_ErrUnitAlreadyMindMerged,
    eAAvailable_ErrTargetAlreadyMindMerged,
    eAAvailable_ErrCasterFullHealth,
    eAAvailable_ErrNotWithMimeticSkin,
    eAAvailable_ErrJetbootNoMoves,
    eAAvailable_ErrCannotStrangle,
    eAAvailable_ErrCannotTargetStrangled,
    eAAvailable_ErrCannotStrangleBlocked,
    eAAvailable_ErrNoRunAndGunAfterCloseAndPersonal,
    eAAvailable_MAX
};

enum EAddAbilityCategory
{
    eAAC_Move,
    eAAC_Weapon,
    eAAC_PrimedWeapon,
    eAAC_Armor,
    eAAC_Character,
    eAAC_Loot,
    eAAC_Psi,
    eAAC_MAX
};

enum ETargetUnitType
{
    eTUT_NONE,
    eTUT_Enemy,
    eTUT_Civilian,
    eTUT_MAX
};

enum EAbility
{
    eAbility_NONE,
    eAbility_Move,
    eAbility_Fly,
    eAbility_FlyUp,
    eAbility_FlyDown,
    eAbility_Launch,
    eAbility_Grapple,
    eAbility_ShotStandard,
    eAbility_RapidFire,
    eAbility_ShotStun,
    eAbility_ShotDroneHack,
    eAbility_ShotOverload,
    eAbility_ShotFlush,
    eAbility_ShotSuppress,
    eAbility_ShotDamageCover,
    eAbility_FlashBang,
    eAbility_FragGrenade,
    eAbility_SmokeGrenade,
    eAbility_AlienGrenade,
    eAbility_RocketLauncher,
    eAbility_Aim,
    eAbility_Intimidate,
    eAbility_Overwatch,
    eAbility_Torch,
    eAbility_Plague,
    eAbility_Stabilize,
    eAbility_Revive,
    eAbility_TakeCover,
    eAbility_Ghost,
    eAbility_MedikitHeal,
    eAbility_RepairSHIV,
    eAbility_CombatStim,
    eAbility_EquipWeapon,
    eAbility_Reload,
    eAbility_MindMerge,
    eAbility_PsiLance,
    eAbility_PsiBoltII,
    eAbility_PsiBomb,
    eAbility_GreaterMindMerge,
    eAbility_PsiControl,
    eAbility_PsiPanic,
    eAbility_WarCry,
    eAbility_Berserk,
    eAbility_ReanimateAlly,
    eAbility_ReanimateEnemy,
    eAbility_PsiDrain,
    eAbility_PsiBless,
    eAbility_DoubleTap,
    eAbility_PrecisionShot,
    eAbility_DisablingShot,
    eAbility_SquadSight,
    eAbility_TooCloseForComfort,
    eAbility_ShredderRocket,
    eAbility_ShotMayhem,
    eAbility_RunAndGun,
    eAbility_BullRush,
    eAbility_BattleScanner,
    eAbility_Mindfray,
    eAbility_Rift,
    eAbility_TelekineticField,
    eAbility_MindControl,
    eAbility_PsiInspiration,
    eAbility_CloseCyberdisc,
    eAbility_DeathBlossom,
    eAbility_CannonFire,
    eAbility_ClusterBomb,
    eAbility_DestroyTerrain,
    eAbility_PsiInspired,
    eAbility_Repair,
    eAbility_HeatWave,
    eAbility_CivilianCover,
    eAbility_Bloodlust,
    eAbility_BloodCall,
    eAbility_MimeticSkin,
    eAbility_AdrenalNeurosympathy,
    eAbility_MimicBeacon,
    eAbility_GasGrenade,
    eAbility_GhostGrenade,
    eAbility_GhostGrenadeStealth,
    eAbility_NeedleGrenade,
    eAbility_MEC_Flamethrower,
    eAbility_MEC_KineticStrike,
    eAbility_MEC_ProximityMine,
    eAbility_JetbootModule,
    eAbility_MEC_Barrage,
    eAbility_MEC_OneForAll,
    eAbility_MEC_GrenadeLauncher,
    eAbility_MEC_RestorativeMist,
    eAbility_MEC_ElectroPulse,
    eAbility_MEC_RestorativeMistHealing,
    eAbility_Strangle,
    eAbility_Stealth,
    eAbility_ActivateStealthMP,
    eAbility_DeactivateStealthMP,
    eAbility_PsiReflect,
    eAbility_FlashBangDaze_DEPRECATED,
    eAbility_MAX
};

enum EAbilityType
{
    eAbilityType_None,
    eAbilityType_Offensive,
    eAbilityType_NonOffensive,
    eAbilityType_Passive,
    eAbilityType_MAX
};

enum EAbilityTarget
{
    eTarget_None,
    eTarget_Self,
    eTarget_SingleEnemy,
    eTarget_MultipleEnemies,
    eTarget_SingleAlly,
    eTarget_SingleAllyOrSelf,
    eTarget_MultipleAllies,
    eTarget_SectoidAllies,
    eTarget_Location,
    eTarget_SingleDeadAlly,
    eTarget_SingleDeadEnemy,
    eTarget_MutonAllies,
    eTarget_MAX
};

enum EAbilityRange
{
    eRange_None,
    eRange_Weapon,
    eRange_Sight,
    eRange_SquadSight,
    eRange_Loot,
    eRange_Unlimited,
    eRange_MAX
};

enum eWeaponRangeCat
{
    eWRC_Short,
    eWRC_Medium,
    eWRC_Long,
    eWRC_MAX
};

enum eShipFireRate
{
    eSFR_Slow,
    eSFR_Medium,
    eSFR_Rapid,
    eSFR_MAX
};

enum eGenericTriScale
{
    eGTS_Low,
    eGTS_Medium,
    eGTS_High,
    eGTS_MAX
};

enum EItemCard
{
    eItemCard_NONE,
    eItemCard_Armor,
    eItemCard_SoldierWeapon,
    eItemCard_ShipWeapon,
    eItemCard_EquippableItem,
    eItemCard_SHIV,
    eItemCard_MECArmor,
    eItemCard_GeneMod,
    eItemCard_Interceptor,
    eItemCard_InterceptorConsumable,
    eItemCard_Satellite,
    eItemCard_MPCharacter,
    EItemCard_MAX
};

enum EAbilityEffect
{
    eEffect_None,
    eEffect_Damage,
    eEffect_TargetStats,
    eEffect_Calm,
    eEffect_RunForCover,
    eEffect_Suppression,
    eEffect_Reaction,
    eEffect_Reload,
    eEffect_Stabilize,
    eEffect_Revive,
    eEffect_Hidden,
    eEffect_Move,
    eEffect_Panic,
    eEffect_Enslave,
    eEffect_Berserk,
    eEffect_FreeMove,
    eEffect_Volume,
    eEffect_ReanimateAlly,
    eEffect_ReanimateEnemy,
    eEffect_PsiDrain,
    eEffect_PsiBless,
    eEffect_Custom,
    eEffect_RunAndGun,
    eEffect_TacticalSense,
    eEffect_BringEmOn,
    eEffect_WillToSurvive,
    eEffect_DamnGoodGround,
    eEffect_Disable,
    eEffect_Disabled,
    eEffect_DoubleTap,
    eEffect_SmokeCoverage,
    eEffect_BleedingOut,
    eEffect_CombatDrugs,
    eEffect_DenseSmoke,
    eEffect_Mindfrayed,
    eEffect_Inspired,
    eEffect_Panicked,
    eEffect_Confused,
    eEffect_MindControlled,
    eEffect_TracerBeams,
    eEffect_Shredded,
    eEffect_Suppressed,
    eEffect_Poisoned,
    eEffect_OpenCyberdisc,
    eEffect_CloseCyberdisc,
    eEffect_Hacked,
    eEffect_Implanted,
    eEffect_Reflection,
    eEffect_CurePoison,
    eEffect_MimicBeacon,
    eEffect_Jetboots,
    eEffect_ProvideCover,
    eEffect_MAX
};

enum EAbilityProperty
{
    eProp_None,
    eProp_FireWeapon,
    eProp_Psionic,
    eProp_ConstantFire,
    eProp_OnProjectileImpact,
    eProp_LeaveCover,
    eProp_Delayed,
    eProp_CostMove,
    eProp_CostNone,
    eProp_DeadEye,
    eProp_NoLineOfSight,
    eProp_CustomRange,
    eProp_FreeAim,
    eProp_TraceWorld,
    eProp_Overheat,
    eProp_Killswitch,
    eProp_WeaponsSwitch,
    eProp_AbortWithShot,
    eProp_AbortWithWound,
    eProp_AbortWithAction,
    eProp_AbortWithMove,
    eProp_AbortOnDeath,
    eProp_PreventMove,
    eProp_Dispel,
    eProp_RequiresCover,
    eProp_TargetCritical,
    eProp_TargetNonRobotic,
    eProp_TargetRobotic,
    eProp_NoStack,
    eProp_IgnoreMoveLimits,
    eProp_NoHit,
    eProp_ExplodeImmediate,
    eProp_CustomExplode,
    eProp_PsiRoll,
    eProp_EnvironmentRoll,
    eProp_InvulnerableWorld,
    eProp_Reuse,
    eProp_Stun,
    eProp_RequiresUnflanked,
    eProp_CantReact,
    eProp_EnemiesCantReact,
    eProp_TargetCantReact,
    eProp_MultiShot_Targets_3,
    eProp_NoSwitchWeapons,
    eProp_Closed,
    eProp_Cooldown,
    eProp_ScatterTarget,
    eProp_CanFireTwice,
    eProp_IsAvailableIgnoresMangledTarget,
    eProp_PageFault,
    eProp_SPOnly,
    eProp_MPOnly,
    eProp_ConditionalAbortWithWound,
    eProp_MAX
};

enum ERandomSample
{
    eSample_Damage,
    eSample_CritDamage,
    eSample_CritDamageAlt,
    eSample_HitChance,
    eSample_CritChance,
    ERandomSample_MAX
};

enum ESoldierClass
{
    eSC_None,
    eSC_Sniper,
    eSC_HeavyWeapons,
    eSC_Support,
    eSC_Assault,
    eSC_Psi,
    eSC_Mec,
    eSC_MAX
};

enum EWeaponClass
{
    eWeaponClass_None,
    eWeaponClass_Assault,
    eWeaponClass_Shotgun,
    eWeaponClass_Heavy,
    eWeaponClass_Sniper,
    eWeaponClass_MAX
};

enum EMPTemplate
{
    eMPT_None,
    eMPT_AssaultCaptainOffense,
    eMPT_SniperCaptainAim,
    eMPT_SniperCaptainMobile,
    eMPT_HeavyCaptainBullets,
    eMPT_HeavyCaptainExplosive,
    eMPT_SupportCaptainSuppression,
    eMPT_SupportCaptainHealing,
    eMPT_SupportSquaddie,
    eMPT_AssaultSquaddie,
    eMPT_HeavySquaddie,
    eMPT_SniperSquaddie,
    eMPT_SupportColonel,
    eMPT_AssaultColonel,
    eMPT_HeavyColonel,
    eMPT_SniperColonel,
    eMPT_PsiSniperMajor,
    eMPT_PsiSupportMajor,
    eMPT_PsiAssaultMajor,
    eMPT_MECTemplate1,
    eMPT_MECTemplate2,
    eMPT_MECTemplate3,
    eMPT_MECTemplate4,
    eMPT_MECTemplate5,
    eMPT_MECTemplate6,
    eMPT_MECTemplate7,
    eMPT_MECTemplate8,
    EMPTemplate_MAX
};

enum EMPGeneModTemplateType
{
    EMPGMTT_None,
    EMPGMTT_GeneModTemplate1,
    EMPGMTT_GeneModTemplate2,
    EMPGMTT_GeneModTemplate3,
    EMPGMTT_GeneModTemplate4,
    EMPGMTT_GeneModTemplate5,
    EMPGMTT_GeneModTemplate6,
    EMPGMTT_MAX
};

enum EMPMECSuitTemplateType
{
    eMPMECSTT_None,
    eMPMECSTT_MECSuitTemplate1,
    eMPMECSTT_MECSuitTemplate2,
    eMPMECSTT_MECSuitTemplate3,
    eMPMECSTT_MECSuitTemplate4,
    eMPMECSTT_MECSuitTemplate5,
    eMPMECSTT_MECSuitTemplate6,
    eMPMECSTT_MECSuitTemplate7,
    eMPMECSTT_MECSuitTemplate8,
    eMPMECSTT_MAX
};

enum EAbilityDisplayProperty
{
    eDisplayProp_None,
    eDisplayProp_NonMenu,
    eDisplayProp_HideUnavailable,
    eDisplayProp_TopDownCamera,
    eDisplayProp_ProjectilePreview,
    eDisplayProp_AlwaysInRange,
    eDisplayProp_NoSplashRadius,
    eDisplayProp_CursorMoving,
    eDisplayProp_AlwaysVisible,
    eDisplayProp_Perk,
    eDisplayProp_AlienGlam,
    eDisplayProp_MarkDestruction,
    eDisplayProp_FriendliesHit,
    eDisplayProp_MAX
};

enum EStatApplicationType
{
    eStatApplication_Base,
    eStatApplication_Strategy,
    eStatApplication_Inventory,
    eStatApplication_MAX
};

enum ECharacterStat
{
    eStat_HP,
    eStat_Offense,
    eStat_Defense,
    eStat_Mobility,
    eStat_Strength,
    eStat_ShieldHP,
    eStat_CouncilMedalAccrued,
    eStat_Will,
    eStat_AppliedSuppression,
    eStat_LowCoverBonus,
    eStat_SightRadius,
    eStat_WeaponRange,
    eStat_Damage,
    eStat_CriticalShot,
    eStat_CriticalWoundChance,
    eStat_CriticalWoundsReceived,
    eStat_CloseCombat,
    eStat_FlightFuel,
    eStat_Reaction,
    eStat_MAX
};

enum EWeaponProperty
{
    eWP_None,
    eWP_Secondary,
    eWP_Pistol,
    eWP_AnyClass,
    eWP_Support,
    eWP_Rifle,
    eWP_Assault,
    eWP_Sniper,
    eWP_Heavy,
    eWP_Explosive,
    eWP_UnlimitedAmmo,
    eWP_Overheats,
    eWP_Psionic,
    eWP_Melee,
    eWP_Integrated,
    eWP_Encumber,
    eWP_MoveLimited,
    eWP_Backpack,
    eWP_NoReload,
    eWP_CantReact,
    eWP_Mec,
    eWP_MAX
};

enum EArmorProperty
{
    eAP_None,
    eAP_Tank,
    eAP_Grapple,
    eAP_Psi,
    eAP_LightWeaponLimited_DEPRECATED,
    eAP_BackpackLimited_DEPRECATED,
    eAP_AirEvade,
    eAP_FireImmunity,
    eAP_PoisonImmunity,
    eAP_MEC,
    eAP_MAX
};

enum ECharacterProperty
{
    eCP_None,
    eCP_Climb,
    eCP_Flight,
    eCP_Robotic,
    eCP_MeleeOnly,
    eCP_Hardened,
    eCP_CanGainXP,
    eCP_AirEvade,
    eCP_NoCover,
    eCP_PoisonImmunity,
    eCP_LargeUnit,
    eCP_Poisonous,
    eCP_DeathExplosion,
    eCP_DoubleOverwatch,
    eCP_MAX
};

enum EVolumeType
{
    eVolume_Suppression,
    eVolume_Smoke,
    eVolume_CombatDrugs,
    eVolume_Fire,
    eVolume_Proximity,
    eVolume_Spy,
    eVolume_FlashBang_DEPRECATED,
    eVolume_Poison,
    eVolume_Telekinetic,
    eVolume_Rift,
    eVolume_MAX
};

enum ESightLineEffect
{
    eSLE_None,
    eSLE_Flanking,
    eSLE_Disabled,
    eSLE_OutOfRange,
    eSLE_MAX
};

enum ESightLineSpecialIcon
{
    eSLSI_None,
    eSLSI_NoSee,
    eSLSI_Psionics,
    eSLSI_MAX
};

enum EVolumeEffect
{
    eVolumeEffect_None,
    eVolumeEffect_BlocksSight,
    eVolumeEffect_Suppression,
    eVolumeEffect_Burn,
    eVolumeEffect_AddSight,
    eVolumeEffect_ApplyAbility,
    eVolumeEffect_Poison,
    eVolumeEffect_TelekineticField,
    eVolumeEffect_Rift,
    eVolumeEffect_MAX
};

enum EXComPawnUpdateBuildingVisibilityType
{
    EPUBVT_None,
    EPUBVT_Unit,
    EPUBVT_Cursor,
    EPUBVT_LevelTrace,
    EPUBVT_POI,
    EPUBVT_MAX
};

enum EItemCardAbility
{
    eICA_NONE,
    eICA_Ghost,
    eICA_ArchangelFlight,
    eICA_Grapple,
    eICA_Cover,
    eICA_SHIVFlight,
    eICA_DestroyCover,
    eICA_MEC_Flamethrower,
    eICA_MEC_ProximityMine,
    eICA_MEC_KineticStrike,
    eICA_MEC_GrenadeLauncher,
    eICA_MEC_RestorativeMist,
    eICA_MEC_ElectroPulse,
    eICA_MAX
};

enum EUnitPawn_OpenCloseState
{
    eUP_None,
    eUP_Open,
    eUP_Close,
    eUP_MAX
};

struct TShivAbility
{
    var string strName;
    var string strDesc;
    var int iAbilityID;
};

struct TItemCard
{
    var string m_strName;
    var string m_strFlavorText;
    var int m_shipWpnRange;
    var int m_shipWpnArmorPen;
    var int m_shipWpnHitChance;
    var int m_shipWpnFireRate;
    var string m_strShivWeapon;
    var ECharacter m_eCharacter;
    var int m_iHealth;
    var int m_iWill;
    var int m_iAim;
    var int m_iDefense;
    var int m_iArmorHPBonus;
    var int m_iBaseCritChance;
    var int m_iBaseDamage;
    var int m_iBaseDamageMax;
    var int m_iCritDamage;
    var int m_iCritDamageMax;
    var float m_fireRate;
    var eWeaponRangeCat m_eRange;
    var EItemCard m_type;
    var EItemType m_item;
    var int m_iCharges;
    var array<int> m_perkTypes;
    var array<EAbility> m_abilities;
    var array<TShivAbility> m_abilitiesShiv;

    structdefaultproperties
    {
        m_strName="UNDEFINED"
    }
};