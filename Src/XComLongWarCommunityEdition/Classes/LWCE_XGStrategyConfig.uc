class LWCE_XGStrategyConfig extends Object
    config(LWCEBaseStrategyGame);

/******************************************************************************
 * This file contains miscellaneous config that is relevant to multiple classes,
 * or config that is around one central theme but is utilized in different places
 * (such as mission rewards).
 ******************************************************************************/

// Config for mission rewards
var config array<LWCE_TItemQuantity> AlienBaseAssaultRewards;

// Config for other mission parameters
var config int MissionGeoscapeDuration_Abduction;
var config int MissionGeoscapeDuration_AirBaseDefense;
var config int MissionGeoscapeDuration_Council; // TODO: not being used yet
var config int MissionGeoscapeDuration_CovertExtraction;
var config int MissionGeoscapeDuration_DataRecovery;
var config int MissionGeoscapeDuration_Terror;

var config int MissionGeoscapeDuration_CrashedAbductor;
var config int MissionGeoscapeDuration_CrashedAssaultCarrier;
var config int MissionGeoscapeDuration_CrashedBattleship;
var config int MissionGeoscapeDuration_CrashedDestroyer;
var config int MissionGeoscapeDuration_CrashedFighter;
var config int MissionGeoscapeDuration_CrashedHarvester;
var config int MissionGeoscapeDuration_CrashedOverseer;
var config int MissionGeoscapeDuration_CrashedRaider;
var config int MissionGeoscapeDuration_CrashedScout;
var config int MissionGeoscapeDuration_CrashedTerrorShip;
var config int MissionGeoscapeDuration_CrashedTransport;

var config int MissionGeoscapeDuration_LandedAbductor;
var config int MissionGeoscapeDuration_LandedAssaultCarrier;
var config int MissionGeoscapeDuration_LandedHarvester;
var config int MissionGeoscapeDuration_LandedRaider;
var config int MissionGeoscapeDuration_LandedScout;
var config int MissionGeoscapeDuration_LandedTerrorShip;
var config int MissionGeoscapeDuration_LandedTransport;