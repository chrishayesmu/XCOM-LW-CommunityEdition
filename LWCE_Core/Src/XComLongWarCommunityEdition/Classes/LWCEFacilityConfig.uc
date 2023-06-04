class LWCEFacilityConfig extends Object
    dependson(LWCE_XGStrategyConfig)
    config(LWCEFacilities)
    abstract;

var config float fRushBuildTimeDivisor;
var config LWCE_TCostModifierConfig kRushBuildAlloysCostModifier;
var config LWCE_TCostModifierConfig kRushBuildCashCostModifier;
var config LWCE_TCostModifierConfig kRushBuildEleriumCostModifier;
var config LWCE_TCostModifierConfig kRushBuildMeldCostModifier;