class LWCEFacilityTemplate extends LWCEDataTemplate;

var config bool bCanDestroy; // Whether this facility can be torn down after construction.
var config int iMaxInstances; // The maximum number of this facility that can be built in XCOM HQ.
var config int iMaintenanceCost; // How much money is spent at the end of each month to maintain this facility.
var config int iPowerConsumed; // How much power this facility needs to operate. If negative, this facility
                               // produces power. 
var config LWCE_TCost kCost;
var config LWCE_TPrereqs kPrereqs;

var const localized string strName;       // The player-viewable name of the facility (singular).
var const localized string strNamePlural; // The player-viewable name of the facility (plural).
var const localized string strBriefSummary;       
