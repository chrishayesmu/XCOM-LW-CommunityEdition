class LWCEEnemyObjectiveDataSet extends LWCEDataSet
    dependson(LWCETypes)
    config(LWCEBaseStrategyAI);

var config int iBombingPanic;
var config array<LWCE_NameIntKVP> arrHarvestYieldByShipType;
var config array<LWCE_NameIntKVP> arrResearchYieldByShipType;

static function OnPostTemplatesCreated()
{
    local LWCEEnemyObjectiveTemplateManager kTemplateMgr;

    kTemplateMgr = `LWCE_ENEMY_OBJECTIVE_TEMPLATE_MGR;

    // Set up delegates for when an objective is successfully completed
    kTemplateMgr.FindEnemyObjectiveTemplate('Abduct').arrOnSuccessDelegates.AddItem(Abduct_OnObjectiveSuccessful);
    kTemplateMgr.FindEnemyObjectiveTemplate('AssaultXComAirBase').arrOnSuccessDelegates.AddItem(AssaultXComAirBase_OnObjectiveSuccessful);
    kTemplateMgr.FindEnemyObjectiveTemplate('AssaultXComHQ').arrOnSuccessDelegates.AddItem(AssaultXComHQ_OnObjectiveSuccessful);
    kTemplateMgr.FindEnemyObjectiveTemplate('Bomb').arrOnSuccessDelegates.AddItem(Bomb_OnObjectiveSuccessful);
    kTemplateMgr.FindEnemyObjectiveTemplate('CommandOverwatch').arrOnSuccessDelegates.AddItem(CommandOverwatch_OnObjectiveSuccessful);
    kTemplateMgr.FindEnemyObjectiveTemplate('Harvest').arrOnSuccessDelegates.AddItem(Harvest_OnObjectiveSuccessful);
    kTemplateMgr.FindEnemyObjectiveTemplate('Hunt').arrOnSuccessDelegates.AddItem(Hunt_OnObjectiveSuccessful);
    kTemplateMgr.FindEnemyObjectiveTemplate('Infiltrate').arrOnSuccessDelegates.AddItem(Infiltrate_OnObjectiveSuccessful);
    kTemplateMgr.FindEnemyObjectiveTemplate('Research').arrOnSuccessDelegates.AddItem(Research_OnObjectiveSuccessful);
    kTemplateMgr.FindEnemyObjectiveTemplate('Scout').arrOnSuccessDelegates.AddItem(Scout_OnObjectiveSuccessful);
    kTemplateMgr.FindEnemyObjectiveTemplate('Terrorize').arrOnSuccessDelegates.AddItem(Terrorize_OnObjectiveSuccessful);
}

static function Abduct_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    `LWCE_STRATEGY_AI.CheckForAbductionBlitz(kObj.m_arrSimultaneousObjs);
}

static function AssaultXComAirBase_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    `LWCE_STRATEGY_AI.LWCE_AIAddNewMission(14, kLastShip);
}

static function AssaultXComHQ_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    // Setting this will cause an HQ defense mission to start the next time the Geoscape isn't busy
    `LWCE_STRATEGY_AI.m_iHQAssaultCounter = 1;
}

static function Bomb_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    local LWCE_XComHQPresentationLayer kPres;
    local int iPanic;

    kPres = `LWCE_HQPRES;

    iPanic = default.iBombingPanic * kLastShip.GetHPPercentage();

    // TODO: need to stop this from stacking with the panic increase for ignoring a UFO
    `LWCE_XGCOUNTRY(kObj.m_nmCountryTarget).AddPanic(iPanic);

    if (kObj.m_eLatestMissionResult == eUMR_Undetected || kObj.m_eLatestMissionResult == eUMR_Detected || kObj.m_eLatestMissionResult == eUMR_Intercepted)
    {
        kPres.LWCE_Notify('CountryBombed', class'LWCEDataContainer'.static.NewName('NotifyData', kObj.m_nmCountryTarget));
    }

    if (kObj.m_eLatestMissionResult == eUMR_Undetected)
    {
        kPres.LWCE_Notify('ShipActivityOverCountry', class'LWCEDataContainer'.static.NewName('NotifyData', kObj.m_nmCountryTarget));
    }
}

static function CommandOverwatch_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    local LWCE_XGCountry kCountry;

    kCountry = `LWCE_XGCOUNTRY(kObj.m_nmCountryTarget);

    if (kCountry.LeftXCom() && kCountry.HasSatelliteCoverage())
    {
        `LWCE_STRATEGY_AI.LWCE_AddHuntTarget(kObj.m_nmCountryTarget);
    }
}

static function Harvest_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    local int iResources, Index;
    local LWCE_XGWorld kWorld;

    kWorld = `LWCE_WORLD;

    Index = default.arrHarvestYieldByShipType.Find('Key', kLastShip.m_nmShipTemplate);

    if (Index == INDEX_NONE)
    {
        `LWCE_LOG_ERROR("Ship type '" $ kLastShip.m_nmShipTemplate $ "' completed a Harvest mission, but has no entry in arrHarvestYieldByShipType!");
        return;
    }

    iResources = default.arrHarvestYieldByShipType[Index].Value + Rand(5);

    if (kWorld.IsOptionEnabled(9)) // Dynamic War
    {
        iResources /= class'XGTacticalGameCore'.default.SW_MARATHON;
    }

    kWorld.STAT_AddStat(19, iResources);
}

static function Hunt_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    local LWCE_XGHeadquarters kHQ;
    local LWCE_XGStrategyAI kAI;

    kHQ = `LWCE_HQ;
    kAI = `LWCE_STRATEGY_AI;

    if (kObj.FoundSatellite())
    {
        kAI.LWCE_OnSatelliteDestroyed(kObj.m_nmCountryTarget);
    }
    else
    {
        kHQ.SetSatelliteVisible(kObj.m_nmCountryTarget, false);
    }
}

static function Infiltrate_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    `LWCE_STRATEGY_AI.LWCE_SignPact(kLastShip, kObj.m_nmCountryTarget);
}

static function Research_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    local int iResearch, Index;
    local LWCE_XGWorld kWorld;

    kWorld = `LWCE_WORLD;

    Index = default.arrResearchYieldByShipType.Find('Key', kLastShip.m_nmShipTemplate);

    if (Index == INDEX_NONE)
    {
        `LWCE_LOG_ERROR("Ship type '" $ kLastShip.m_nmShipTemplate $ "' completed a Research mission, but has no entry in arrResearchYieldByShipType!");
        return;
    }

    iResearch = default.arrResearchYieldByShipType[Index].Value;

    kWorld.STAT_AddStat(2, iResearch);
}

static function Scout_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    local LWCE_XGStrategyAI kAI;

    kAI = `LWCE_STRATEGY_AI;

    // TODO move ShouldHunt into this class since it's no longer core to XGStrategyAI
    if (kAI.LWCE_ShouldHunt(kLastShip, kObj.m_nmCountryTarget, kObj.m_eLatestMissionResult))
    {
        kAI.LWCE_AddHuntTarget(kObj.m_nmCountryTarget);
    }
}

static function Terrorize_OnObjectiveSuccessful(LWCE_XGAlienObjective kObj, LWCE_XGShip kLastShip)
{
    `LWCE_STRATEGY_AI.LWCE_AIAddNewMission(eMission_TerrorSite, kLastShip);
}