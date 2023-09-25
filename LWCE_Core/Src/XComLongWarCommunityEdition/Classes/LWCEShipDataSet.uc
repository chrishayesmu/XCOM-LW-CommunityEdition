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
        kShipTemplate.arrModifyAimFn.AddItem(ModifyShipAim);
        kShipTemplate.arrModifyDamageFn.AddItem(ModifyShipDamage);
        kShipTemplate.arrModifyHealthFn.AddItem(ModifyShipHealth);
    }
}

// TODO: lots of stuff from this point on should be in config
static function int ModifyShipAim(int iBaseValue, int iValue, name nmShipTeam)
{
    if (nmShipTeam == class'LWCEShipTemplate'.const.SHIP_TEAM_ALIEN)
    {
        return iValue + 2 * GetAlienResearchIncrements();
    }
}

static function int ModifyShipDamage(int iBaseValue, int iValue, name nmShipTeam)
{
    if (nmShipTeam == class'LWCEShipTemplate'.const.SHIP_TEAM_ALIEN)
    {
        return iValue + 8 * GetAlienResearchIncrements();
    }
}

static function int ModifyShipHealth(int iBaseValue, int iValue, name nmShipTeam)
{
    if (nmShipTeam == class'LWCEShipTemplate'.const.SHIP_TEAM_ALIEN)
    {
        return iValue + 75 * GetAlienResearchIncrements();
    }
}

// UFOs all gain some base stats on a regular cadence. This function just calculates how many
// intervals have passed, and thus how many upgrades should be applied.
static protected function int GetAlienResearchIncrements()
{
    return Min(32, `LWCE_WORLD.STAT_GetStat(1) / 30);
}