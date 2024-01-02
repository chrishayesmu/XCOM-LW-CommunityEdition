class LWCEShipDataSet extends LWCEDataSet
    dependson(LWCEShipTemplate, LWCETypes)
    config(LWCEShips);

/// Scheduled upgrades which apply to all ships, without needing to be repeated for every template.
var config array<config LWCE_TShipScheduledUpgrade> arrGlobalShipUpgrades;

static function OnPostTemplatesCreated()
{
    local LWCEShipTemplateManager kTemplateMgr;
    local array<LWCEShipTemplate> arrShipTemplates;
    local LWCEShipTemplate kShipTemplate;

    kTemplateMgr = `LWCE_SHIP_TEMPLATE_MGR;
    arrShipTemplates = kTemplateMgr.GetAllShipTemplates();

    foreach arrShipTemplates(kShipTemplate)
    {
        kShipTemplate.arrModifyStatsFns.AddItem(ModifyShipStats);
    }
}

// TODO: lots of stuff from this point on should be in config
static function ModifyShipStats(out LWCE_TShipStats kStats, name nmShipTeam)
{
    local LWCE_XGFacility_Engineering kEngineering;

    kEngineering = `LWCE_ENGINEERING;

    if (nmShipTeam == class'LWCEShipTemplate'.const.SHIP_TEAM_XCOM)
    {
        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ArmoredFighters'))
        {
            kStats.iHealth += 1000;
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_ImprovedAvionics'))
        {
            kStats.iAim += 10;
        }

        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_PenetratorWeapons'))
        {
            kStats.iArmorPen += 25;
        }

        // In LW 1.0 this is implemented as a malus to UFO aim, but with the addition of ship's having
        // a defense stat, we rewrite it to apply to XCOM's crafts instead
        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_UFOCountermeasures'))
        {
            kStats.iDefense += 15;
        }

        // TODO: when Sparrowhawks project is done, stingrays need to be added to existing ships
        if (kEngineering.LWCE_IsFoundryTechResearched('Foundry_WingtipSparrowhawks'))
        {
            // TODO: sparrowhawks should be their own special ship weapon instead of relying on special logic
            // within XGInterceptionEngagement to cut their damage in half
            kStats.arrWeapons.AddItem('Item_StingrayMissiles');
        }
    }
}