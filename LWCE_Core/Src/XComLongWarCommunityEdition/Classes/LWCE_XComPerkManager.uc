class LWCE_XComPerkManager extends XComPerkManager
    config(LWCEClasses)
    dependson(LWCETypes);

var config array<LWCE_TPerkTree> arrPsionicClassesCfg;
var config array<LWCE_TPerkTree> arrSoldierClassesCfg;

var array<LWCE_TPerkTree> arrPsionicClasses;
var array<LWCE_TPerkTree> arrSoldierClasses; // includes MECs

var array<LWCE_TPerk> m_arrCEPerks;

static function int BaseIDFromPerkName(name PerkName)
{
    switch (PerkName)
    {
        case 'SoShallYouFight':
            return ePerk_SoShallYouFight;
        case 'PrecisionShot':
            return ePerk_PrecisionShot;
        case 'Squadsight':
            return ePerk_SquadSight;
        case 'SecondaryHeart':
            return ePerk_GeneMod_SecondHeart;
        case 'LowProfile':
            return ePerk_LowProfile;
        case 'RunAndGun':
            return ePerk_RunAndGun;
        case 'AutopsyRequired':
            return ePerk_AutopsyRequired;
        case 'BattleScanner':
            return ePerk_BattleScanner;
        case 'DisablingShot':
            return ePerk_DisablingShot;
        case 'Opportunist':
            return ePerk_Opportunist;
        case 'Executioner':
            return ePerk_Executioner;
        case 'TODO':
            return ePerk_OTS_Leader;
        case 'DoubleTap':
            return ePerk_DoubleTap;
        case 'InTheZone':
            return ePerk_InTheZone;
        case 'DamnGoodGround':
            return ePerk_DamnGoodGround;
        case 'SnapShot':
            return ePerk_SnapShot;
        case 'WillToSurvive':
            return ePerk_WillToSurvive;
        case 'FireRocket':
            return ePerk_FireRocket;
        case 'HoloTargeting':
            return ePerk_HoloTargeting;
        case 'AdrenalNeurosympathy':
            return ePerk_GeneMod_Adrenal;
        case 'Suppression':
            return ePerk_FocusedSuppression;
        case 'ShredderAmmo':
            return ePerk_ShredderRocket;
        case 'RapidReaction':
            return ePerk_RapidReaction;
        case 'Grenadier':
            return ePerk_Grenadier;
        case 'DangerZone':
            return ePerk_DangerZone;
        case 'ReadyForAnything':
            return ePerk_ReadyForAnything;
        case 'ExtraConditioning':
            return ePerk_ExtraConditioning;
        case 'NeuralDamping':
            return ePerk_GeneMod_BrainDamping;
        case 'NeuralFeedback':
            return ePerk_GeneMod_BrainFeedback;
        case 'HyperReactivePupils':
            return ePerk_GeneMod_Pupils;
        case 'Sprinter':
            return ePerk_Sprinter;
        case 'Aggression':
            return ePerk_Aggression;
        case 'TacticalSense':
            return ePerk_TacticalSense;
        case 'CloseEncounters':
            return ePerk_CloseEncounters;
        case 'LightningReflexes':
            return ePerk_LightningReflexes;
        case 'RapidFire':
            return ePerk_RapidFire;
        case 'Flush':
            return ePerk_Flush;
        case 'DepthPerception':
            return ePerk_GeneMod_DepthPerception;
        case 'BringEmOn':
            return ePerk_BringEmOn;
        case 'CloseCombatSpecialist':
            return ePerk_CloseCombatSpecialist;
        case 'KillerInstinct':
            return ePerk_KillerInstinct;
        case 'BioelectricSkin':
            return ePerk_GeneMod_BioelectricSkin;
        case 'Resilience':
            return ePerk_Resilience;
        case 'SmokeGrenade':
            return ePerk_SmokeBomb;
        case 'AdaptiveBoneMarrow':
            return ePerk_GeneMod_BoneMarrow;
        case 'TODO':
            return ePerk_StunImmune;
        case 'CoveringFire':
            return ePerk_CoveringFire;
        case 'FieldMedic':
            return ePerk_FieldMedic;
        case 'Pyrokinesis':
            return ePerk_Pyrokinesis;
        case 'MuscleFiberDensity':
            return ePerk_GeneMod_MuscleFiber;
        case 'CombatDrugs':
            return ePerk_CombatDrugs;
        case 'DenseSmoke':
            return ePerk_DenseSmoke;
        case 'Packmaster':
            return ePerk_DeepPockets;
        case 'Sentinel':
            return ePerk_Sentinel;
        case 'Savior':
            return ePerk_Savior;
        case 'Revive':
            return ePerk_Revive;
        case 'ElevatedGround':
            return ePerk_HeightAdvantage;
        case 'LockNLoad':
            return ePerk_LockNLoad;
        case 'Sapper':
            return ePerk_Sapper;
        case 'Suppressed':
            return ePerk_SuppressedActive;
        case 'CriticallyWounded':
            return ePerk_CriticallyWounded;
        case 'Airborne':
            return ePerk_Flying;
        case 'Stealth':
            return ePerk_Stealth;
        case 'HEATWarheads':
            return ePerk_HEATWarheads;
        case 'CombatStimmed':
            return ePerk_CombatStimActive;
        case 'JavelinRockets':
            return ePerk_JavelinRockets;
        case 'Panicked':
            return ePerk_Panicked;
        case 'Mindfray':
            return ePerk_MindFray;
        case 'PsiPanic':
            return ePerk_PsiPanic;
        case 'PsiInspiration':
            return ePerk_PsiInspiration;
        case 'MindControl':
            return ePerk_MindControl;
        case 'TelekineticField':
            return ePerk_TelekineticField;
        case 'Rift':
            return ePerk_Rift;
        case 'MindMerge':
            return ePerk_MindMerge;
        case 'MindMerger':
            return ePerk_MindMerger;
        case 'Hardened':
            return ePerk_Hardened;
        case 'GreaterMindMerge':
            return ePerk_GreaterMindMerge;
        case 'GreaterMindMerger':
            return ePerk_GreaterMindMerger;
        case 'Evasion':
            return ePerk_Evade;
        case 'Launch':
            return ePerk_Launch;
        case 'Bombard':
            return ePerk_Bombard;
        case 'Leap':
            return ePerk_Leap;
        case 'AcidSpit':
            return ePerk_Plague;
        case 'VenomousClaws':
            return ePerk_Poison;
        case 'BloodCall':
            return ePerk_BloodCall;
        case 'Intimidate':
            return ePerk_Intimidate;
        case 'FallenComrades':
            return ePerk_FallenComrades;
        case 'Bloodlust':
            return ePerk_Bloodlust;
        case 'BullRush':
            return ePerk_BullRush;
        case 'HEATAmmo':
            return ePerk_HEATAmmo;
        case 'SmokeAndMirrors':
            return ePerk_SmokeAndMirrors;
        case 'ShockAndAwe':
            return ePerk_Rocketeer;
        case 'Mayhem':
            return ePerk_Mayhem;
        case 'Ranger':
            return ePerk_Ranger;
        case 'Concealment':
            return ePerk_GeneMod_MimeticSkin;
        case 'ClusterBomb':
            return ePerk_ClusterBomb;
        case 'PsiLance':
            return ePerk_PsiLance;
        case 'DeathBlossom':
            return ePerk_DeathBlossom;
        case 'Overload':
            return ePerk_Overload;
        case 'PsiControl':
            return ePerk_PsiControl;
        case 'PsiDrain':
            return ePerk_PsiDrain;
        case 'Repair':
            return ePerk_Repair;
        case 'CannonFire':
            return ePerk_CannonFire;
        case 'Implant':
            return ePerk_Implant;
        case 'ChryssalidSpawn':
            return ePerk_ChryssalidSpawn;
        case 'BattleFatigue':
            return ePerk_BattleFatigue;
        case 'RangeBonus':
            return ePerk_ItemRangeBonus;
        case 'RangePenalty':
            return ePerk_ItemRangePenalty;
        case 'TODO':
            return ePerk_Foundry_Scope;
        case 'TODO':
            return ePerk_Foundry_PistolI;
        case 'TODO':
            return ePerk_Foundry_PistolII;
        case 'TandemWarheads':
            return ePerk_TandemWarheads;
        case 'TODO':
            return ePerk_Foundry_AmmoConservation;
        case 'FireInTheHole':
            return ePerk_FireInTheHole;
        case 'TODO':
            return ePerk_Foundry_ArcThrowerII;
        case 'Deadeye':
            return ePerk_Deadeye;
        case 'TODO':
            return ePerk_Foundry_CaptureDrone;
        case 'TODO':
            return ePerk_Foundry_SHIVHeal;
        case 'PsychokineticStrike':
            return ePerk_PsychokineticStrike;
        case 'TODO':
            return ePerk_Foundry_EleriumFuel;
        case 'MECCloseCombat':
            return ePerk_Foundry_MECCloseCombat;
        case 'StayFrosty':
            return ePerk_Foundry_AdvancedServomotors;
        case 'ShapedArmor':
            return ePerk_Foundry_ShapedArmor;
        case 'SentinelModule':
            return ePerk_Foundry_SentinelDrone;
        case 'AlienGrenades':
            return ePerk_Foundry_AlienGrenades;
        case 'LightEmUp':
            return ePerk_LightEmUp;
        case 'SeekerStealth':
            return ePerk_SeekerStealth;
        case 'GhostMode':
            return ePerk_StealthGrenade;
        case 'ReaperPack':
            return ePerk_ReaperRounds;
        case 'Disoriented':
            return ePerk_Disoriented;
        case 'CollateralDamage':
            return ePerk_Barrage;
        case 'AutomatedThreatAssessment':
            return ePerk_AutoThreatAssessment;
        case 'AdvancedFireControl':
            return ePerk_AdvancedFireControl;
        case 'DamageControl':
            return ePerk_DamageControl;
        case 'VitalPointTargeting':
            return ePerk_VitalPointTargeting;
        case 'OneForAll':
            return ePerk_OneForAll;
        case 'JetbootModule':
            return ePerk_JetbootModule;
        case 'CombinedArms':
            return ePerk_ExpandedStorage;
        case 'RepairServos':
            return ePerk_RepairServos;
        case 'FortioresUna':
            return ePerk_Overdrive;
        case 'PlatformStability':
            return ePerk_PlatformStability;
        case 'AbsorptionFields':
            return ePerk_AbsorptionFields;
        case 'ShockAbsorbentArmor':
            return ePerk_ShockAbsorbentArmor;
        case 'ReactiveTargetingSensors':
            return ePerk_ReactiveTargetingSensors;
        case 'BodyShield':
            return ePerk_BodyShield;
        case 'DistortionField':
            return ePerk_DistortionField;
        case 'AdrenalineSurge':
            return ePerk_GeneMod_AdrenalineSurge;
        case 'IronSkin':
            return ePerk_GeneMod_IronSkin;
        case 'RegenBiofield':
            return ePerk_GeneMod_RegenPheromones;
        case 'FieldSurgeon':
            return ePerk_FieldSurgeon;
        case 'EXALTCommHack':
            return ePerk_CovertHacker;
        case 'SemperVigilans':
            return ePerk_Medal_UrbanA;
        case 'Sharpshooter':
            return ePerk_Sharpshooter;
        case 'Steadfast':
            return ePerk_Steadfast;
        case 'SmartMacrophages':
            return ePerk_SmartMacrophages;
        case 'LegioPatriaNostra':
            return ePerk_LegioPatriaNostra;
        case 'BandOfWarriors':
            return ePerk_BandOfWarriors;
        case 'SoOthersMayLive':
            return ePerk_SoOthersMayLive;
        case 'LoneWolf':
            return ePerk_LoneWolf;
        case 'EspritDeCorps':
            return ePerk_EspritDeCorps;
        case 'IntoTheBreach':
            return ePerk_IntoTheBreach;
        case 'Paramedic':
            return ePerk_Paramedic;
        case 'AimingAngles':
            return ePerk_AimingAnglesBonus;
        case 'CatchingBreath':
            return ePerk_CatchingBreath;
        case 'TacticalRigging':
            return ePerk_Foundry_TacticalRigging;
        case 'Strangle':
            return ePerk_SeekerStrangle;
        case 'HitAndRun':
            return ePerk_HitAndRun;
        case 'PsiShield':
            return ePerk_MindMerge_Mechtoid;
        case 'Electropulsed':
            return ePerk_Electropulse;
        case '':
            return ePerk_OTS_Leader_Bonus;
        case 'LeadByExample':
            return ePerk_OTS_Leader_TheLeader;
    }

    return ePerk_None;
}

static function name PerkNameFromBaseID(int iPerkId)
{
    switch (iPerkId)
    {
        case ePerk_SoShallYouFight:
            return 'SoShallYouFight';
        case ePerk_PrecisionShot:
            return 'PrecisionShot';
        case ePerk_SquadSight:
            return 'Squadsight';
        case ePerk_GeneMod_SecondHeart:
            return 'SecondaryHeart';
        case ePerk_LowProfile:
            return 'LowProfile';
        case ePerk_RunAndGun:
            return 'RunAndGun';
        case ePerk_AutopsyRequired:
            return 'AutopsyRequired';
        case ePerk_BattleScanner:
            return 'BattleScanner';
        case ePerk_DisablingShot:
            return 'DisablingShot';
        case ePerk_Opportunist:
            return 'Opportunist';
        case ePerk_Executioner:
            return 'Executioner';
        case ePerk_OTS_Leader:
            return 'TODO';
        case ePerk_DoubleTap:
            return 'DoubleTap';
        case ePerk_InTheZone:
            return 'InTheZone';
        case ePerk_DamnGoodGround:
            return 'DamnGoodGround';
        case ePerk_SnapShot:
            return 'SnapShot';
        case ePerk_WillToSurvive:
            return 'WillToSurvive';
        case ePerk_FireRocket:
            return 'FireRocket';
        case ePerk_HoloTargeting:
            return 'HoloTargeting';
        case ePerk_GeneMod_Adrenal:
            return 'AdrenalNeurosympathy';
        case ePerk_FocusedSuppression:
            return 'Suppression';
        case ePerk_ShredderRocket:
            return 'ShredderAmmo';
        case ePerk_RapidReaction:
            return 'RapidReaction';
        case ePerk_Grenadier:
            return 'Grenadier';
        case ePerk_DangerZone:
            return 'DangerZone';
        case ePerk_ReadyForAnything:
            return 'ReadyForAnything';
        case ePerk_ExtraConditioning:
            return 'ExtraConditioning';
        case ePerk_GeneMod_BrainDamping:
            return 'NeuralDamping';
        case ePerk_GeneMod_BrainFeedback:
            return 'NeuralFeedback';
        case ePerk_GeneMod_Pupils:
            return 'HyperReactivePupils';
        case ePerk_Sprinter:
            return 'Sprinter';
        case ePerk_Aggression:
            return 'Aggression';
        case ePerk_TacticalSense:
            return 'TacticalSense';
        case ePerk_CloseEncounters:
            return 'CloseEncounters';
        case ePerk_LightningReflexes:
            return 'LightningReflexes';
        case ePerk_RapidFire:
            return 'RapidFire';
        case ePerk_Flush:
            return 'Flush';
        case ePerk_GeneMod_DepthPerception:
            return 'DepthPerception';
        case ePerk_BringEmOn:
            return 'BringEmOn';
        case ePerk_CloseCombatSpecialist:
            return 'CloseCombatSpecialist';
        case ePerk_KillerInstinct:
            return 'KillerInstinct';
        case ePerk_GeneMod_BioelectricSkin:
            return 'BioelectricSkin';
        case ePerk_Resilience:
            return 'Resilience';
        case ePerk_SmokeBomb:
            return 'SmokeGrenade';
        case ePerk_GeneMod_BoneMarrow:
            return 'AdaptiveBoneMarrow';
        case ePerk_StunImmune: // only used to generate a random subclass in barracks
            return 'TODO';
        case ePerk_CoveringFire:
            return 'CoveringFire';
        case ePerk_FieldMedic:
            return 'FieldMedic';
        case ePerk_Pyrokinesis:
            return 'Pyrokinesis';
        case ePerk_GeneMod_MuscleFiber:
            return 'MuscleFiberDensity';
        case ePerk_CombatDrugs:
            return 'CombatDrugs';
        case ePerk_DenseSmoke:
            return 'DenseSmoke';
        case ePerk_DeepPockets:
            return 'Packmaster';
        case ePerk_Sentinel:
            return 'Sentinel';
        case ePerk_Savior:
            return 'Savior';
        case ePerk_Revive:
            return 'Revive';
        case ePerk_HeightAdvantage:
            return 'ElevatedGround';
        case ePerk_LockNLoad:
            return 'LockNLoad';
        case ePerk_Sapper:
            return 'Sapper';
        case ePerk_SuppressedActive:
            return 'Suppressed';
        case ePerk_CriticallyWounded:
            return 'CriticallyWounded';
        case ePerk_Flying:
            return 'Airborne';
        case ePerk_Stealth:
            return 'Stealth';
        case ePerk_HEATWarheads:
            return 'HEATWarheads';
        case ePerk_CombatStimActive:
            return 'CombatStimmed';
        case ePerk_JavelinRockets:
            return 'JavelinRockets';
        case ePerk_Panicked:
            return 'Panicked';
        case ePerk_MindFray:
            return 'Mindfray';
        case ePerk_PsiPanic:
            return 'PsiPanic';
        case ePerk_PsiInspiration:
            return 'PsiInspiration';
        case ePerk_MindControl:
            return 'MindControl';
        case ePerk_TelekineticField:
            return 'TelekineticField';
        case ePerk_Rift:
            return 'Rift';
        case ePerk_MindMerge:
            return 'MindMerge';
        case ePerk_MindMerger:
            return 'MindMerger';
        case ePerk_Hardened:
            return 'Hardened';
        case ePerk_GreaterMindMerge:
            return 'GreaterMindMerge';
        case ePerk_GreaterMindMerger:
            return 'GreaterMindMerger';
        case ePerk_Evade:
            return 'Evasion';
        case ePerk_Launch:
            return 'Launch';
        case ePerk_Bombard:
            return 'Bombard';
        case ePerk_Leap:
            return 'Leap';
        case ePerk_Plague:
            return 'AcidSpit';
        case ePerk_Poison:
            return 'VenomousClaws';
        case ePerk_BloodCall:
            return 'BloodCall';
        case ePerk_Intimidate:
            return 'Intimidate';
        case ePerk_FallenComrades:
            return 'FallenComrades';
        case ePerk_Bloodlust:
            return 'Bloodlust';
        case ePerk_BullRush:
            return 'BullRush';
        case ePerk_HEATAmmo:
            return 'HEATAmmo';
        case ePerk_SmokeAndMirrors:
            return 'SmokeAndMirrors';
        case ePerk_Rocketeer:
            return 'ShockAndAwe';
        case ePerk_Mayhem:
            return 'Mayhem';
        case ePerk_Ranger:
            return 'Ranger';
        case ePerk_GeneMod_MimeticSkin:
            return 'Concealment';
        case ePerk_ClusterBomb:
            return 'ClusterBomb';
        case ePerk_PsiLance:
            return 'PsiLance';
        case ePerk_DeathBlossom:
            return 'DeathBlossom';
        case ePerk_Overload:
            return 'Overload';
        case ePerk_PsiControl:
            return 'PsiControl';
        case ePerk_PsiDrain:
            return 'PsiDrain';
        case ePerk_Repair:
            return 'Repair';
        case ePerk_CannonFire:
            return 'CannonFire';
        case ePerk_Implant:
            return 'Implant';
        case ePerk_ChryssalidSpawn:
            return 'ChryssalidSpawn';
        case ePerk_BattleFatigue:
            return 'BattleFatigue';
        case ePerk_ItemRangeBonus:
            return 'RangeBonus';
        case ePerk_ItemRangePenalty:
            return 'RangePenalty';
        case ePerk_Foundry_Scope:
            return 'TODO';
        case ePerk_Foundry_PistolI:
            return 'TODO';
        case ePerk_Foundry_PistolII:
            return 'TODO';
        case ePerk_TandemWarheads:
            return 'TandemWarheads';
        case ePerk_Foundry_AmmoConservation:
            return 'TODO';
        case ePerk_FireInTheHole:
            return 'FireInTheHole';
        case ePerk_Foundry_ArcThrowerII:
            return 'TODO';
        case ePerk_Deadeye:
            return 'Deadeye';
        case ePerk_Foundry_CaptureDrone:
            return 'TODO';
        case ePerk_Foundry_SHIVHeal:
            return 'TODO';
        case ePerk_PsychokineticStrike:
            return 'PsychokineticStrike';
        case ePerk_Foundry_EleriumFuel:
            return 'TODO';
        case ePerk_Foundry_MECCloseCombat:
            return 'MECCloseCombat';
        case ePerk_Foundry_AdvancedServomotors:
            return 'StayFrosty';
        case ePerk_Foundry_ShapedArmor:
            return 'ShapedArmor';
        case ePerk_Foundry_SentinelDrone:
            return 'SentinelModule';
        case ePerk_Foundry_AlienGrenades:
            return 'AlienGrenades';
        case ePerk_LightEmUp:
            return 'LightEmUp';
        case ePerk_SeekerStealth:
            return 'SeekerStealth';
        case ePerk_StealthGrenade:
            return 'GhostMode';
        case ePerk_ReaperRounds:
            return 'ReaperPack';
        case ePerk_Disoriented:
            return 'Disoriented';
        case ePerk_Barrage:
            return 'CollateralDamage';
        case ePerk_AutoThreatAssessment:
            return 'AutomatedThreatAssessment';
        case ePerk_AdvancedFireControl:
            return 'AdvancedFireControl';
        case ePerk_DamageControl:
            return 'DamageControl';
        case ePerk_VitalPointTargeting:
            return 'VitalPointTargeting';
        case ePerk_OneForAll:
            return 'OneForAll';
        case ePerk_JetbootModule:
            return 'JetbootModule';
        case ePerk_ExpandedStorage:
            return 'CombinedArms';
        case ePerk_RepairServos:
            return 'RepairServos';
        case ePerk_Overdrive:
            return 'FortioresUna';
        case ePerk_PlatformStability:
            return 'PlatformStability';
        case ePerk_AbsorptionFields:
            return 'AbsorptionFields';
        case ePerk_ShockAbsorbentArmor:
            return 'ShockAbsorbentArmor';
        case ePerk_ReactiveTargetingSensors:
            return 'ReactiveTargetingSensors';
        case ePerk_BodyShield:
            return 'BodyShield';
        case ePerk_DistortionField:
            return 'DistortionField';
        case ePerk_GeneMod_AdrenalineSurge:
            return 'AdrenalineSurge';
        case ePerk_GeneMod_IronSkin:
            return 'IronSkin';
        case ePerk_GeneMod_RegenPheromones:
            return 'RegenBiofield';
        case ePerk_FieldSurgeon:
            return 'FieldSurgeon';
        case ePerk_CovertHacker:
            return 'EXALTCommHack';
        case ePerk_Medal_UrbanA:
            return 'SemperVigilans';
        case ePerk_Sharpshooter:
            return 'Sharpshooter';
        case ePerk_Steadfast:
            return 'Steadfast';
        case ePerk_SmartMacrophages:
            return 'SmartMacrophages';
        case ePerk_LegioPatriaNostra:
            return 'LegioPatriaNostra';
        case ePerk_BandOfWarriors:
            return 'BandOfWarriors';
        case ePerk_SoOthersMayLive:
            return 'SoOthersMayLive';
        case ePerk_LoneWolf:
            return 'LoneWolf';
        case ePerk_EspritDeCorps:
            return 'EspritDeCorps';
        case ePerk_IntoTheBreach:
            return 'IntoTheBreach';
        case ePerk_Paramedic:
            return 'Paramedic';
        case ePerk_AimingAnglesBonus:
            return 'AimingAngles';
        case ePerk_CatchingBreath:
            return 'CatchingBreath';
        case ePerk_Foundry_TacticalRigging:
            return 'TacticalRigging';
        case ePerk_SeekerStrangle:
            return 'Strangle';
        case ePerk_HitAndRun:
            return 'HitAndRun';
        case ePerk_MindMerge_Mechtoid:
            return 'PsiShield';
        case ePerk_Electropulse:
            return 'Electropulsed';
        case ePerk_OTS_Leader_Bonus:
            return '';
        case ePerk_OTS_Leader_TheLeader:
            return 'LeadByExample';
    }

    return '';
}

simulated function Init()
{
    BuildPerkTables();
    BuildPerkTrees();
    m_bInitialized = true;
}

simulated function BuildPerkTables()
{
    m_arrPerks.Length = 172;

    //             ID       Category      ImagePath                  bShowPerk   bIsGeneMod   bIsPsionic
    LWCE_BuildPerk(0,   ePerkCat_Passive, "Unknown",                   true,       false,       false);
    LWCE_BuildPerk(1,   ePerkCat_Passive, "StarHire",                  true,       false,       false);
    LWCE_BuildPerk(2,   ePerkCat_Active,  "PrecisionShot",             true,       false,       false);
    LWCE_BuildPerk(3,   ePerkCat_Passive, "SquadSight",                true,       false,       false);
    LWCE_BuildPerk(4,   ePerkCat_Passive, "SecondaryHeart",            true,       true,        false);
    LWCE_BuildPerk(5,   ePerkCat_Passive, "LowProfile",                true,       false,       false);
    LWCE_BuildPerk(6,   ePerkCat_Active,  "RunAndGun",                 true,       false,       false);
    LWCE_BuildPerk(7,   ePerkCat_Passive, "AutopsyRequired",           true,       false,       false);
    LWCE_BuildPerk(8,   ePerkCat_Active,  "CloseCyberdisc",            true,       false,       false);
    LWCE_BuildPerk(9,   ePerkCat_Active,  "DisablingShot",             true,       false,       false);
    LWCE_BuildPerk(10,  ePerkCat_Passive, "Opportunist",               true,       false,       false);
    LWCE_BuildPerk(11,  ePerkCat_Passive, "Executioner",               true,       false,       false);
    LWCE_BuildPerk(12,  ePerkCat_Passive, "LeadByExample",             false,      false,       false);
    LWCE_BuildPerk(13,  ePerkCat_Passive, "DoubleTap",                 true,       false,       false);
    LWCE_BuildPerk(14,  ePerkCat_Passive, "InTheZone",                 true,       false,       false);
    LWCE_BuildPerk(15,  ePerkCat_Passive, "DamnGoodGround",            true,       false,       false);
    LWCE_BuildPerk(16,  ePerkCat_Passive, "SnapShot",                  true,       false,       false);
    LWCE_BuildPerk(17,  ePerkCat_Passive, "WillToSurvive",             true,       false,       false);
    LWCE_BuildPerk(18,  ePerkCat_Active,  "FireRocket",                true,       false,       false);
    LWCE_BuildPerk(19,  ePerkCat_Passive, "TracerBeams",               true,       false,       false);
    LWCE_BuildPerk(20,  ePerkCat_Passive, "Adrenal",                   true,       true,        false);
    LWCE_BuildPerk(21,  ePerkCat_Active,  "Suppression",               true,       false,       false);
    LWCE_BuildPerk(22,  ePerkCat_Passive, "ShredderRocket",            true,       false,       false);
    LWCE_BuildPerk(23,  ePerkCat_Passive, "RapidReaction",             true,       false,       false);
    LWCE_BuildPerk(24,  ePerkCat_Passive, "Grenadier",                 true,       false,       false);
    LWCE_BuildPerk(25,  ePerkCat_Passive, "DangerZone",                true,       false,       false);
    LWCE_BuildPerk(26,  ePerkCat_Passive, "FireControl",               true,       false,       false);
    LWCE_BuildPerk(27,  ePerkCat_Passive, "ExtraConditioning",         true,       false,       false);
    LWCE_BuildPerk(28,  ePerkCat_Passive, "NeuralDamping",             true,       true,        false);
    LWCE_BuildPerk(29,  ePerkCat_Passive, "NeuralFeedback",            true,       false,       true);
    LWCE_BuildPerk(30,  ePerkCat_Passive, "ReactivePupils",            true,       true,        false);
    LWCE_BuildPerk(31,  ePerkCat_Passive, "Sprinter",                  true,       false,       false);
    LWCE_BuildPerk(32,  ePerkCat_Passive, "Aggression",                true,       false,       false);
    LWCE_BuildPerk(33,  ePerkCat_Passive, "TacticalSense",             true,       false,       false);
    LWCE_BuildPerk(34,  ePerkCat_Passive, "CloseAndPersonal",          true,       false,       false);
    LWCE_BuildPerk(35,  ePerkCat_Passive, "LightningReflexes",         true,       false,       false);
    LWCE_BuildPerk(36,  ePerkCat_Active,  "RapidFire",                 true,       false,       false);
    LWCE_BuildPerk(37,  ePerkCat_Active,  "Flush",                     true,       false,       false);
    LWCE_BuildPerk(38,  ePerkCat_Passive, "DepthPerception",           true,       true,        false);
    LWCE_BuildPerk(39,  ePerkCat_Passive, "BringEmOn",                 true,       false,       false);
    LWCE_BuildPerk(40,  ePerkCat_Passive, "CloseCombatSpecialist",     true,       false,       false);
    LWCE_BuildPerk(41,  ePerkCat_Passive, "KillerInstinct",            true,       false,       false);
    LWCE_BuildPerk(42,  ePerkCat_Passive, "BioelectricSkin",           true,       true,        false);
    LWCE_BuildPerk(43,  ePerkCat_Passive, "Resilience",                true,       false,       false);
    LWCE_BuildPerk(44,  ePerkCat_Active,  "SmokeBomb",                 true,       false,       false);
    LWCE_BuildPerk(45,  ePerkCat_Passive, "BattleFatigue",             true,       true,        false);
    LWCE_BuildPerk(46,  ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(47,  ePerkCat_Passive, "CoveringFire",              true,       false,       false);
    LWCE_BuildPerk(48,  ePerkCat_Passive, "FieldMedic",                true,       false,       false);
    LWCE_BuildPerk(49,  ePerkCat_Passive, "PsiLance",                  true,       false,       true);
    LWCE_BuildPerk(50,  ePerkCat_Passive, "MuscleDensity",             true,       true,        false);
    LWCE_BuildPerk(51,  ePerkCat_Passive, "CombatDrugs",               true,       false,       false);
    LWCE_BuildPerk(52,  ePerkCat_Passive, "DenseSmoke",                true,       false,       false);
    LWCE_BuildPerk(53,  ePerkCat_Passive, "ExpandedStorage",           true,       false,       false);
    LWCE_BuildPerk(54,  ePerkCat_Passive, "Sentinel",                  true,       false,       false);
    LWCE_BuildPerk(55,  ePerkCat_Passive, "Savior",                    true,       false,       false);
    LWCE_BuildPerk(56,  ePerkCat_Active,  "Revive",                    true,       false,       false);
    LWCE_BuildPerk(57,  ePerkCat_Passive, "HeightAdvantage",           true,       false,       false);
    LWCE_BuildPerk(58,  ePerkCat_Passive, "DeepPockets",               true,       false,       false);
    LWCE_BuildPerk(59,  ePerkCat_Passive, "AceInTheHole",              true,       false,       false);
    LWCE_BuildPerk(60,  ePerkCat_Passive, "SuppressedActive",          true,       false,       false);
    LWCE_BuildPerk(61,  ePerkCat_Passive, "CriticallyWounded",         true,       false,       false);
    LWCE_BuildPerk(62,  ePerkCat_Passive, "Flying",                    true,       false,       false);
    LWCE_BuildPerk(63,  ePerkCat_Passive, "Stealth",                   true,       false,       false);
    LWCE_BuildPerk(64,  ePerkCat_Passive, "HEATAmmo",                  true,       false,       false);
    LWCE_BuildPerk(65,  ePerkCat_Passive, "CombatStimsActive",         true,       false,       false);
    LWCE_BuildPerk(66,  ePerkCat_Passive, "DeathBlossom",              true,       false,       false);
    LWCE_BuildPerk(67,  ePerkCat_Passive, "Panicked",                  true,       false,       false);
    LWCE_BuildPerk(68,  ePerkCat_Active,  "PsiMindfray",               true,       false,       true);
    LWCE_BuildPerk(69,  ePerkCat_Active,  "PsiPanic",                  true,       false,       true);
    LWCE_BuildPerk(70,  ePerkCat_Active,  "PsiInspiration",            true,       false,       true);
    LWCE_BuildPerk(71,  ePerkCat_Active,  "PsiMindControl",            true,       false,       true);
    LWCE_BuildPerk(72,  ePerkCat_Active,  "PsiTelekineticField",       true,       false,       true);
    LWCE_BuildPerk(73,  ePerkCat_Active,  "PsiRift",                   true,       false,       true);
    LWCE_BuildPerk(74,  ePerkCat_Active,  "MindMerge",                 true,       false,       true);
    LWCE_BuildPerk(75,  ePerkCat_Active,  "MindMerge",                 true,       false,       true);
    LWCE_BuildPerk(76,  ePerkCat_Passive, "Harden",                    true,       false,       false);
    LWCE_BuildPerk(77,  ePerkCat_Active,  "MindMerge2",                true,       false,       true);
    LWCE_BuildPerk(78,  ePerkCat_Active,  "MindMerge2",                true,       false,       true);
    LWCE_BuildPerk(79,  ePerkCat_Active,  "Evasion",                   true,       false,       false);
    LWCE_BuildPerk(80,  ePerkCat_Active,  "Launch",                    true,       false,       false);
    LWCE_BuildPerk(81,  ePerkCat_Passive, "Bombard",                   true,       false,       false);
    LWCE_BuildPerk(82,  ePerkCat_Active,  "Leap",                      true,       false,       false);
    LWCE_BuildPerk(83,  ePerkCat_Active,  "PoisonSpit",                true,       false,       false);
    LWCE_BuildPerk(84,  ePerkCat_Active,  "PoisonSpit",                true,       false,       false);
    LWCE_BuildPerk(85,  ePerkCat_Active,  "Bloodcall",                 true,       false,       false);
    LWCE_BuildPerk(86,  ePerkCat_Active,  "Intimidate",                true,       false,       false);
    LWCE_BuildPerk(87,  ePerkCat_Passive, "FallenComrades",            true,       false,       false);
    LWCE_BuildPerk(88,  ePerkCat_Active,  "Bloodlust",                 true,       false,       false);
    LWCE_BuildPerk(89,  ePerkCat_Active,  "Bullrush",                  true,       false,       false);
    LWCE_BuildPerk(90,  ePerkCat_Passive, "HEATAmmo",                  true,       false,       false);
    LWCE_BuildPerk(91,  ePerkCat_Passive, "SmokeAndMirrors",           true,       false,       false);
    LWCE_BuildPerk(92,  ePerkCat_Passive, "Rocketeer",                 true,       false,       false);
    LWCE_BuildPerk(93,  ePerkCat_Passive, "Mayhem",                    true,       false,       false);
    LWCE_BuildPerk(94,  ePerkCat_Passive, "Gunslinger",                true,       false,       false);
    LWCE_BuildPerk(95,  ePerkCat_Passive, "MimeticSkin",               true,       false,       false);
    LWCE_BuildPerk(96,  ePerkCat_Active,  "ClusterBomb",               true,       false,       false);
    LWCE_BuildPerk(97,  ePerkCat_Active,  "PsiLance",                  true,       false,       true);
    LWCE_BuildPerk(98,  ePerkCat_Active,  "DeathBlossom",              true,       false,       false);
    LWCE_BuildPerk(99,  ePerkCat_Active,  "Overload",                  true,       false,       false);
    LWCE_BuildPerk(100, ePerkCat_Active,  "PsiMindControl",            true,       false,       true);
    LWCE_BuildPerk(101, ePerkCat_Active,  "PsiDrain",                  true,       false,       true);
    LWCE_BuildPerk(102, ePerkCat_Passive, "Repair",                    true,       false,       false);
    LWCE_BuildPerk(103, ePerkCat_Active,  "CannonFire",                true,       false,       false);
    LWCE_BuildPerk(104, ePerkCat_Passive, "Implant",                   true,       false,       false);
    LWCE_BuildPerk(105, ePerkCat_Passive, "Implant",                   true,       false,       false);
    LWCE_BuildPerk(106, ePerkCat_Passive, "BattleFatigue",             true,       false,       false);
    LWCE_BuildPerk(107, ePerkCat_Passive, "DONT_USE_ItemRangeBonus",   true,       false,       false);
    LWCE_BuildPerk(108, ePerkCat_Passive, "DONT_USE_ItemRangePenalty", true,       false,       false);
    LWCE_BuildPerk(109, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(110, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(111, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(112, ePerkCat_Passive, "Overload",                  true,       false,       false);
    LWCE_BuildPerk(113, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(114, ePerkCat_Passive, "ClusterBomb",               true,       false,       false);
    LWCE_BuildPerk(115, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(116, ePerkCat_Passive, "SentinelModule",            true,       false,       false);
    LWCE_BuildPerk(117, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(118, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(119, ePerkCat_Passive, "PsiDrain",                  true,       false,       true);
    LWCE_BuildPerk(120, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(121, ePerkCat_Passive, "MecCloseCombat",            true,       false,       false);
    LWCE_BuildPerk(122, ePerkCat_Passive, "AdrenalineSurge",           true,       false,       false);
    LWCE_BuildPerk(123, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(124, ePerkCat_Passive, "SentinelModule",            true,       false,       false);
    LWCE_BuildPerk(125, ePerkCat_Passive, "AlienGrenade",              false,      false,       false);
    LWCE_BuildPerk(126, ePerkCat_Passive, "BulletSwarm",               true,       false,       false);
    LWCE_BuildPerk(127, ePerkCat_Passive, "Stealth",                   true,       false,       false);
    LWCE_BuildPerk(128, ePerkCat_Passive, "Stealth",                   true,       false,       false);
    LWCE_BuildPerk(129, ePerkCat_Passive, "ReaperRounds",              true,       false,       false);
    LWCE_BuildPerk(130, ePerkCat_Passive, "Disoriented",               true,       false,       false);
    LWCE_BuildPerk(131, ePerkCat_Active,  "Barrage",                   true,       false,       false);
    LWCE_BuildPerk(132, ePerkCat_Passive, "ThreatAssesment",           true,       false,       false);
    LWCE_BuildPerk(133, ePerkCat_Passive, "FireControl",               true,       false,       false);
    LWCE_BuildPerk(134, ePerkCat_Passive, "DamageControl",             true,       false,       false);
    LWCE_BuildPerk(135, ePerkCat_Passive, "Xenobiology",               true,       false,       false);
    LWCE_BuildPerk(136, ePerkCat_Active,  "OneForAll",                 true,       false,       false);
    LWCE_BuildPerk(137, ePerkCat_Passive, "JetbootModule",             true,       false,       false);
    LWCE_BuildPerk(138, ePerkCat_Passive, "PlasmaBarrage",             true,       false,       false);
    LWCE_BuildPerk(139, ePerkCat_Passive, "RepairServos",              true,       false,       false);
    LWCE_BuildPerk(140, ePerkCat_Passive, "Overdrive",                 true,       false,       false);
    LWCE_BuildPerk(141, ePerkCat_Passive, "PlatformStability",         true,       false,       false);
    LWCE_BuildPerk(142, ePerkCat_Passive, "AbsorptionFields",          true,       false,       false);
    LWCE_BuildPerk(143, ePerkCat_Passive, "ShockArmor",                true,       false,       false);
    LWCE_BuildPerk(144, ePerkCat_Passive, "TargetingSensors",          true,       false,       false);
    LWCE_BuildPerk(145, ePerkCat_Passive, "BodyShield",                true,       false,       false);
    LWCE_BuildPerk(146, ePerkCat_Passive, "DistortionField",           true,       false,       true);
    LWCE_BuildPerk(147, ePerkCat_Passive, "AdrenalineSurge",           true,       false,       false);
    LWCE_BuildPerk(148, ePerkCat_Passive, "IronSkin",                  true,       true,        false);
    LWCE_BuildPerk(149, ePerkCat_Passive, "RegenPheromones",           true,       false,       true);
    LWCE_BuildPerk(150, ePerkCat_Passive, "BoneMarrow",                true,       false,       false);
    LWCE_BuildPerk(151, ePerkCat_Passive, "CommHack",                  true,       false,       false);
    LWCE_BuildPerk(152, ePerkCat_Passive, "UrbanDefense",              true,       false,       false);
    LWCE_BuildPerk(153, ePerkCat_Passive, "UrbanAim",                  true,       false,       false);
    LWCE_BuildPerk(154, ePerkCat_Passive, "DefendPanic",               true,       false,       false);
    LWCE_BuildPerk(155, ePerkCat_Passive, "RestorativeMist",           true,       true,        false);
    LWCE_BuildPerk(156, ePerkCat_Passive, "NationWill",                true,       false,       false);
    LWCE_BuildPerk(157, ePerkCat_Passive, "NationAim",                 true,       false,       false);
    LWCE_BuildPerk(158, ePerkCat_Passive, "HonorTerror",               true,       false,       false);
    LWCE_BuildPerk(159, ePerkCat_Passive, "HonorExalt",                true,       false,       false);
    LWCE_BuildPerk(160, ePerkCat_Passive, "StarWill",                  true,       false,       false);
    LWCE_BuildPerk(161, ePerkCat_Passive, "Dazed",                     true,       false,       false);
    LWCE_BuildPerk(162, ePerkCat_Passive, "DefendHealth",              true,       false,       false);
    LWCE_BuildPerk(163, ePerkCat_Passive, "DONT_USE_ItemRangeBonus",   true,       false,       false);
    LWCE_BuildPerk(164, ePerkCat_Passive, "Strangle",                  true,       false,       false);
    LWCE_BuildPerk(165, ePerkCat_Passive, "Unknown",                   false,      false,       false);
    LWCE_BuildPerk(166, ePerkCat_Passive, "Strangle",                  true,       false,       false);
    LWCE_BuildPerk(167, ePerkCat_Passive, "Leap",                      true,       false,       false);
    LWCE_BuildPerk(168, ePerkCat_Active,  "MindMerge",                 true,       false,       true);
    LWCE_BuildPerk(169, ePerkCat_Passive, "ElectroPulse",              true,       false,       false);
    LWCE_BuildPerk(170, ePerkCat_Passive, "LeadByExample",             true,       false,       false);
    LWCE_BuildPerk(171, ePerkCat_Passive, "LeadByExample",             true,       false,       false);

    `LWCE_MOD_LOADER.OnPerksBuilt(m_arrCEPerks);
}

simulated function BuildPerkTrees()
{
    local LWCE_TPerkTree kPerkTree;

    foreach arrPsionicClassesCfg(kPerkTree)
    {
        arrPsionicClasses.AddItem(kPerkTree);
    }

    foreach arrSoldierClassesCfg(kPerkTree)
    {
        arrSoldierClasses.AddItem(kPerkTree);
    }

    `LWCE_MOD_LOADER.OnPerkTreesBuilt(arrSoldierClasses, arrPsionicClasses);
}

simulated function LWCE_BuildPerk(int iPerkId, int iCategory, string strImage, bool bShowPerk, bool bIsGeneMod, bool bIsPsionic)
{
    local LWCE_TPerk kPerk;

    // We still need to call the superclass's BuildPerk to populate the base game perk array,
    // which is used in native code we can't easily modify
    BuildPerk(iPerkId, iCategory, strImage, bShowPerk);

    kPerk.iCategory = iCategory;
    kPerk.iPerkId = iPerkId;
    kPerk.Icon = strImage;
    kPerk.bIsGeneMod = bIsGeneMod;
    kPerk.bIsPsionic = bIsPsionic;
    kPerk.bShowPerk = bShowPerk;

    // For base game perks, pull their strings from localization
    if (iPerkId < ePerk_MAX)
    {
        SetPerkStrings(iPerkId);

        kPerk.strBonusDescription = m_arrPerks[iPerkId].strDescription[ePerkBuff_Bonus];
        kPerk.strBonusTitle = m_arrPerks[iPerkId].strName[ePerkBuff_Bonus];
        kPerk.strPassiveDescription = m_arrPerks[iPerkId].strDescription[ePerkBuff_Passive];
        kPerk.strPassiveTitle = m_arrPerks[iPerkId].strName[ePerkBuff_Passive];
        kPerk.strPenaltyDescription = m_arrPerks[iPerkId].strDescription[ePerkBuff_Penalty];
        kPerk.strPenaltyTitle = m_arrPerks[iPerkId].strName[ePerkBuff_Penalty];
    }

    m_arrCEPerks.AddItem(kPerk);
}

simulated function string GetBonusTitle(int iPerkId)
{
    return GetPerkName(iPerkId, ePerkBuff_Bonus);
}

simulated function string GetBriefSummary(int iPerkId)
{
    return GetPerkDescription(iPerkId, ePerkBuff_Passive);
}

simulated function string GetPenaltyTitle(int iPerkId)
{
    return GetPerkName(iPerkId, ePerkBuff_Penalty);
}

simulated function string GetPerkImage(int iPerk)
{
    local int Index;

    if (iPerk == 0)
    {
        return "";
    }

    if (iPerk == `LW_PERK_ID(IronSkin))
    {
        iPerk = `LW_PERK_ID(Concealment);
    }

    if (iPerk == `LW_PERK_ID(SmartMacrophages))
    {
        iPerk = `LW_PERK_ID(NeuralFeedback);
    }

    if (iPerk == `LW_PERK_ID(AdaptiveBoneMarrow))
    {
        iPerk = `LW_PERK_ID(FieldSurgeon);
    }

    Index = m_arrCEPerks.Find('iPerkId', iPerk);

    if (Index == INDEX_NONE)
    {
        return "";
    }

    return m_arrCEPerks[Index].Icon;
}

simulated function string GetPerkName(int iPerkId, optional EPerkBuffCategory perkCategory)
{
    local LWCE_TPerk kPerk;

    // For base game perks, we use the superclass data because it handles some tag localization for us
    if (iPerkId < ePerk_MAX)
    {
        return super.GetPerkName(iPerkId, perkCategory);
    }

    kPerk = LWCE_GetPerk(iPerkId);

    switch (perkCategory)
    {
        case ePerkBuff_Bonus:
            return kPerk.strBonusTitle;
        case ePerkBuff_Penalty:
            return kPerk.strPenaltyTitle;
        case ePerkBuff_Passive:
        default:
            return kPerk.strPassiveTitle;
    }
}

simulated function string GetPerkDescription(int iPerkId, optional EPerkBuffCategory perkCategory)
{
    local LWCE_TPerk kPerk;

    if (iPerkId == 0)
    {
        return "";
    }

    // For base game perks, we use the superclass data because it handles some tag localization for us
    if (iPerkId < ePerk_MAX)
    {
        if (m_arrPerks[iPerkId].strName[0] == "")
        {
            SetPerkStrings(iPerkId);
        }

        return m_arrPerks[iPerkId].strDescription[perkCategory];
    }
    else
    {
        kPerk = LWCE_GetPerk(iPerkId);

        switch (perkCategory)
        {
            case ePerkBuff_Bonus:
                return kPerk.strBonusDescription;
            case ePerkBuff_Penalty:
                return kPerk.strPenaltyDescription;
            case ePerkBuff_Passive:
            default:
                return kPerk.strPassiveDescription;
        }
    }
}

/// <summary>
/// Similar to GetPerkDescription, but provides an opportunity to use the context of which unit has
/// the buff in order to populate dynamic text for the buff's description.
/// </summary>
simulated function string GetDynamicPerkDescription(int iPerkId, LWCE_XGUnit kUnit, EPerkBuffCategory perkCategory)
{
    local string strText;

    switch (perkCategory)
    {
        case ePerkBuff_Bonus:
            strText = `LWCE_MOD_LOADER.GetDynamicBonusDescription(iPerkId, kUnit);
            break;
        case ePerkBuff_Penalty:
            strText = `LWCE_MOD_LOADER.GetDynamicPenaltyDescription(iPerkId, kUnit);
            break;
        case ePerkBuff_Passive:
        default:
            strText = GetPerkDescription(iPerkId, ePerkBuff_Passive); // Passives are never shown in context-sensitive areas
            break;
    }

    if (strText == "")
    {
        strText = GetPerkDescription(iPerkId, perkCategory);
    }

    return strText;
}

static function EPerkType GetMecPerkForClass(ESoldierClass eSoldier)
{
    `LWCE_LOG_DEPRECATED_CLS(GetMecPerkForClass);
    return ePerk_None;
}

/// <summary>
/// Returns the ID of the perk which the input class would receive for free if augmented into a MEC. If the
/// input class cannot be augmented, returns -1.
/// </summary>
function int LWCE_GetMecPerkForClass(int iSoldierClassId)
{
    local int iMecClassId;
    local LWCE_TPerkTree kPerkTree;
    local LWCE_XGFacility_Barracks kBarracks;

    kBarracks = `LWCE_BARRACKS;
    iMecClassId = kBarracks.GetResultingMecClass(iSoldierClassId);

    if (iMecClassId < 0)
    {
        return -1;
    }

    if (!TryFindMatchingTreeByClassId(kPerkTree, arrSoldierClasses, iMecClassId))
    {
        return -1;
    }

    return kPerkTree.arrPerkRows[0].arrPerkChoices[0].iPerkId;
}

function EPerkType GetPerkInTreePsi(int branch, int Option)
{
    `LWCE_LOG_CLS("ERROR: LWCE-incompatible function GetPerkInTreePsi was called. This needs to be replaced with LWCE_GetPerkInTree. Stack trace follows.");
    ScriptTrace();

    return ePerk_None;
}

function LWCE_TPerkTree GetTreeForClass(int iClassId, optional bool bIsPsiClass = false)
{
    local LWCE_TPerkTree kEmptyTree;
    local array<LWCE_TPerkTree> arrPossibleTrees;
    local int Index;

    arrPossibleTrees = bIsPsiClass ? arrPsionicClasses : arrSoldierClasses;
    Index = arrPossibleTrees.Find('iClassId', iClassId);

    if (Index != INDEX_NONE)
    {
        return arrPossibleTrees[Index];
    }

    kEmptyTree.iClassId = -100;
    return kEmptyTree;
}

function int GetNumColumnsInTreeRow(LWCE_XGStrategySoldier kSoldier, int iRow, optional bool bIsPsiTree = false)
{
    local LWCE_TPerkTree kTree;

    if (!TryFindMatchingTree(kTree, kSoldier, bIsPsiTree))
    {
        return 0;
    }

    if (kTree.arrPerkRows.Length <= iRow)
    {
        `LWCE_LOG_CLS("ERROR: perk tree doesn't have enough rows; requested row is " $ iRow);
        ScriptTrace();
        return 0;
    }

    if (kTree.arrPerkRows[iRow].arrPerkChoices.Length == 0)
    {
        `LWCE_LOG_CLS("Tree has no perks at requested rank.");
        return 0;
    }

    return kTree.arrPerkRows[iRow].arrPerkChoices.Length;
}

function int GetNumRowsInTree(LWCE_XGStrategySoldier kSoldier, optional bool bIsPsiTree = false)
{
    local LWCE_TPerkTree kTree;

    if (!TryFindMatchingTree(kTree, kSoldier, bIsPsiTree))
    {
        return 0;
    }

    return kTree.arrPerkRows.Length;
}

simulated function TPerk GetPerk(int iPerk)
{
    local TPerk kPerk;

    `LWCE_LOG_DEPRECATED_CLS(GetPerk);

    return kPerk;
}

simulated function LWCE_TPerk LWCE_GetPerk(int iPerkId)
{
    local int Index;
    local LWCE_TPerk kEmptyPerk;

    Index = m_arrCEPerks.Find('iPerkId', iPerkId);

    if (Index != INDEX_NONE)
    {
        return m_arrCEPerks[Index];
    }

    `LWCE_LOG_CLS("WARNING: did not find any perk with ID " $ iPerkId);

    return kEmptyPerk;
}

function EPerkType GetPerkInTree(ESoldierClass soldierClass, int branch, int Option, optional bool bIsPsiTree)
{
    `LWCE_LOG_DEPRECATED_CLS(GetPerkInTree);
    return 0;
}

function int LWCE_GetPerkInTree(LWCE_XGStrategySoldier kSoldier, int iRow, int iColumn, optional bool bIsPsiTree = false)
{
    local LWCE_TPerkTreeChoice kPerkChoice;

    if (!TryGetPerkChoiceInTree(kPerkChoice, kSoldier, iRow, iColumn, bIsPsiTree))
    {
        return 0;
    }

    return kPerkChoice.iPerkId;
}

function LWCE_TCharacterStats GetPerkStatChanges(LWCE_XGStrategySoldier kSoldier, int iRow, int iColumn, optional bool bIsPsiTree = false)
{
    local LWCE_TPerkTreeChoice kPerkChoice;
    local LWCE_TCharacterStats kStats;

    if (!TryGetPerkChoiceInTree(kPerkChoice, kSoldier, iRow, iColumn, bIsPsiTree))
    {
        return kStats;
    }

    return kPerkChoice.kStatChanges;
}

function GivePerk(XGUnit kUnit, int iPerkId)
{
    local LWCE_XGUnit kCEUnit;

    kCEUnit = LWCE_XGUnit(kUnit);

    if (kCEUnit.HasPerk(iPerkId))
    {
        return;
    }

    kCEUnit.GivePerk(iPerkId);

    if (XGBattle_SP(`BATTLE) != none)
    {
        switch (iPerkId)
        {
            case `LW_PERK_ID(FieldMedic):
                kUnit.SetMediKitCharges(3);
                break;
            case `LW_PERK_ID(ShockAndAwe):
                kUnit.SetRockets(2);
                break;
            case `LW_PERK_ID(ShredderAmmo):
                kUnit.SetShredderRockets(1);
                break;
            case `LW_PERK_ID(SmokeGrenade):
                kUnit.SetSmokeGrenadeCharges(3);
                break;
        }
    }
}

protected function bool TryFindMatchingTree(out LWCE_TPerkTree kMatchingTree, LWCE_XGStrategySoldier kSoldier, bool bIsPsiTree)
{
    local int iClassId;
    local array<LWCE_TPerkTree> arrTrees;

    iClassId = bIsPsiTree ? kSoldier.m_iPsionicClassId : kSoldier.m_kCEChar.iClassId;
    arrTrees = bIsPsiTree ? arrPsionicClasses : arrSoldierClasses;

    return TryFindMatchingTreeByClassId(kMatchingTree, arrTrees, iClassId);
}

protected function bool TryFindMatchingTreeByClassId(out LWCE_TPerkTree kMatchingTree, array<LWCE_TPerkTree> arrTrees, int iClassId)
{
    local bool bFoundTree;
    local LWCE_TPerkTree kTree;

    foreach arrTrees(kTree)
    {
        if (kTree.iClassId != iClassId)
        {
            continue;
        }

        if (bFoundTree)
        {
            `LWCE_LOG_CLS("WARNING: found multiple trees matching iClassId = " $ iClassId);
            ScriptTrace();
            continue;
        }

        kMatchingTree = kTree;
        bFoundTree = true;
    }

    if (!bFoundTree)
    {
        `LWCE_LOG_CLS("ERROR: did not find any tree matching iClassId = " $ iClassId);
        ScriptTrace();
        return false;
    }

    return true;
}

function bool TryGetPerkChoiceInTree(out LWCE_TPerkTreeChoice kPerkChoice, LWCE_XGStrategySoldier kSoldier, int iRow, int iColumn, optional bool bIsPsiTree = false)
{
    local LWCE_TPerkTree kTree;

    if (!TryFindMatchingTree(kTree, kSoldier, bIsPsiTree))
    {
        return false;
    }

    if (kTree.arrPerkRows.Length <= iRow)
    {
        `LWCE_LOG_CLS("ERROR: perk tree doesn't have enough rows; requested row is " $ iRow);
        ScriptTrace();
        return false;
    }

    if (kTree.arrPerkRows[iRow].arrPerkChoices.Length == 0)
    {
        `LWCE_LOG_CLS("Tree has no perks at requested rank.");
        return false;
    }

    if (kTree.arrPerkRows[iRow].arrPerkChoices.Length <= iColumn)
    {
        `LWCE_LOG_CLS("ERROR: perk tree row " $ iRow $ " doesn't have enough columns; requested column is " $ iColumn);
        ScriptTrace();
        return false;
    }

    kPerkChoice = kTree.arrPerkRows[iRow].arrPerkChoices[iColumn];
    return true;
}

static simulated function bool LWCE_HasAnyGeneMod(const out LWCE_TCharacter kChar)
{
    local LWCE_XComPerkManager kPerksMgr;
    local int Index;

    kPerksMgr = `LWCE_IS_STRAT_GAME ? `LWCE_PERKS_STRAT : `LWCE_PERKS_TAC;

    for (Index = 0; Index < kChar.arrPerks.Length; Index++)
    {
        if (kPerksMgr.LWCE_GetPerk(kChar.arrPerks[Index].Id).bIsGeneMod)
        {
            return true;
        }
    }

    return false;
}