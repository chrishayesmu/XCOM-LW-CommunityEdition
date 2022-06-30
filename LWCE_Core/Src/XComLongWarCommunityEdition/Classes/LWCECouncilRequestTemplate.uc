/// <summary>
/// Data template to specify a request made by the Council.
///
/// TODO: move more of the request fulfillment/reward logic to the template, so that
/// mod subclasses can make more custom behavior for requests.
/// </summary>
class LWCECouncilRequestTemplate extends LWCEDataTemplate
    config(LWCEBaseStrategyGame);

struct LWCE_TRequestItemConfig
{
    var int iItemId;
    var bool bScaleForDynamicWar;
    var LWCE_TRange kQuantityRange;
    var LWCE_TRange kPerMonthScaling;
};

struct LWCE_TRequestRewardConfig
{
    var array<LWCE_TItemQuantity> arrItemRewards;
    var bool bCashForItems;
    var LWCE_TRange kCash;
    var LWCE_TRange kCountryDefense;
    var LWCE_TRange kEngineers;
    var LWCE_TRange kPanic;
    var LWCE_TRange kScientists;
    var LWCE_TRange kSoldiers;
};

var config EFCRequestType eType;
var config int iHoursToRespond;
var config int iCooldownInHours;

var config array<LWCE_TRequestItemConfig> arrRequestedItems;
var config LWCE_TPrereqs kPrereqs;

// Rewards
var config array<LWCE_TRequestRewardConfig> arrRewards;

// If true, don't validate this template. May be necessary for requests handled by mod code,
// as well as for our own deliberately invalid request type (as explained in the ini).
var config bool bSkipValidation;

// Localization
var const localized string strName;
var const localized string strIntro;
var const localized string strCompletion;
var const localized string strTickerSuccess;
var const localized string strTickerIgnore;

function name GetRequestName()
{
    return DataName;
}

function bool ValidateTemplate(out string strError)
{
    if (bSkipValidation)
    {
        return true;
    }

    if (eType == eFCRType_SellArtifacts && arrRequestedItems.Length == 0)
    {
        strError = "Must have requested items configured for eType=eFCRType_SellArtifacts";
        return false;
    }

    if (arrRewards.Length == 0)
    {
        strError = "No rewards configured for request";
        return false;
    }

    if (strName == "" || strIntro == "" || strCompletion == "" || strTickerSuccess == "" || strTickerIgnore == "")
    {
        strError = "One or more localization fields missing";
        return false;
    }

    if (iHoursToRespond <= 0)
    {
        strError = "iHoursToRespond must be a positive value";
        return false;
    }

	return super.ValidateTemplate(strError);
}