/// <summary>
/// Abstractly represents any kind of bonus, though LWCE itself just uses them for country and
/// continent bonuses. This type is deliberately made flexible so that mods can apply these bonuses
/// from other sources as well, if desired. The prerequisites for the bonus are deliberately not
/// part of this template. Decoupling the bonus's prerequisites and its effects have some benefits:
///
///   - Bonuses can be randomized (e.g. shuffling country bonuses at the start of the campaign)
///   - Bonuses can be moved around easily (e.g. changing a Second Wave option into a country starting bonus)
///
/// This extends LWCEEventListenerTemplate so that you can readily hook into all of the places where
/// the bonus's effects are needed.
/// </summary>
class LWCEBonusTemplate extends LWCEEventListenerTemplate
    config(LWCEBonuses)
    dependson(LWCETypes);

// TODO: move this struct to LWCE_XGBase or similar and use it for normal starting config too
struct LWCE_TStartingFacility
{
    var int X;
    var int Y;
    var name FacilityName;
};

// TODO add config for starting soldiers

var config int iBonusStartingCash;
var config array<LWCE_TStartingFacility> arrStartingFacilities;
var config array<name> arrStartingFoundryProjects;
var config array<LWCE_TItemQuantity> arrStartingItems;
var config array<name> arrStartingTechs;

var const localized string strName;
var const localized string strDescription;

/// <summary>
/// DO NOT CALL THIS FUNCTION.
///
/// Called by LWCE after the template is initially created, giving a chance for the template
/// to hook into events based on configured values. For example, a bonus which is configured to
/// grant starting items will need to register with the OnNewCampaignStarted event to do so.
///
/// You may override this function in subclasses if needed, but only do so if absolutely needed.
/// Most event registration should be handled identically to an LWCEEventListenerTemplate, within
/// the dataset which is creating the template. Only override this function to support event registration
/// that you can't know about at compile time (i.e. dependent on config values or other mods being installed).
/// Always call super.RegisterBonusEvents() when overriding.
/// </summary>
function RegisterBonusEvents()
{
    if (iBonusStartingCash > 0 || arrStartingFacilities.Length > 0 || arrStartingFoundryProjects.Length > 0 || arrStartingItems.Length > 0 || arrStartingTechs.Length > 0)
    {
        bRegisterInStrategy = true;
        AddEvent('OnNewCampaignStarted', OnCampaignStart);
    }

    // TODO
}

protected function OnCampaignStart(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGBase kBase;
    local LWCE_XGFacility_Engineering kEngineering;
    local LWCE_XGFacility_Labs kLabs;
    local LWCE_XGStorage kStorage;
    local LWCE_XGStrategy kStrategy;
    local int Index;

    kStrategy = LWCE_XGStrategy(EventSource);
    kBase = LWCE_XGBase(kStrategy.Base());
    kStorage = LWCE_XGStorage(kStrategy.STORAGE());
    kEngineering = LWCE_XGFacility_Engineering(kStrategy.ENGINEERING());
    kLabs = LWCE_XGFacility_Labs(kStrategy.LABS());

    kStrategy.AddResource(eResource_Money, iBonusStartingCash);

    for (Index = 0; Index < arrStartingFacilities.Length; Index++) {
        kBase.LWCE_SetFacility(arrStartingFacilities[Index].FacilityName, arrStartingFacilities[Index].X, arrStartingFacilities[Index].Y);
    }

    for (Index = 0; Index < arrStartingFoundryProjects.Length; Index++) {
        kEngineering.GiveFoundryProject(arrStartingFoundryProjects[Index]);
    }

    for (Index = 0; Index < arrStartingItems.Length; Index++) {
        kStorage.LWCE_AddItem(arrStartingItems[Index].ItemName, arrStartingItems[Index].iQuantity);
    }

    for (Index = 0; Index < arrStartingTechs.Length; Index++) {
        kLabs.GiveTech(arrStartingTechs[Index]);
    }
}