class LWCEBonusDataSet extends LWCEDataSet
    config(LWCEBonuses)
    dependson(LWCEBonusTemplate, LWCETypes);

var config array<int>  arrAirSuperiorityDiscount;
var config array<int>  arrArchitectsOfTheFutureDiscount;
var config array<int>  arrArmyOfTheSouthernCrossAimBonus;
var config array<int>  arrBaumeisterFacilityBuildTimeReduction;
var config array<int>  arrBountiesAbductionsCashBonus;
var config array<int>  arrCallToArmsGeneModFatigueReduction;
var config array<int>  arrCheyenneMountainExcavationDiscount;
var config array<int>  arrCyberwareMeldDiscount;
var config array<int>  arrDeusExCostReduction;
var config array<int>  arrDeusExTimeReduction;
var config array<int>  arrEagerToServeCostReduction;
var config array<int>  arrFirstRecceDefenseBonus;
var config array<int>  arrGhostInTheMachineAimBonus;
var config array<int>  arrGiftOfOsirisFatigueReduction;
var config array<int>  arrIndependenceDayPanicReduction;
var config array<int>  arrJaiVidwanLabAdjacencyBonus;
var config array<name> arrJungleScoutsCompatibleArmor;
var config array<int>  arrLegacyOfUxmalPsiTrainingBonus;
var config array<int>  arrNeoPanzersDiscount;
var config array<int>  arrNewWarfareDiscount;
var config array<int>  arrOldPathPsiTrainingTimeReduction;
var config array<int>  arrPatriaeSemperVigilisWillBonus;
var config array<int>  arrPaxNigerianaMobilityBonus;
var config array<int>  arrPerArduaAdAstraStatRollsBonus;
var config array<int>  arrPowerToThePeopleDiscount;
var config array<int>  arrQuaidOrsayCouncilRequestCooldownReduction;
var config array<int>  arrQuaidOrsayCouncilRequestShieldsBonus;
var config array<int>  arrQuaidOrsayExaltScanningCostReduction;
var config array<int>  arrRingOfFireAddedSteamVents;
var config array<int>  arrRoboticsAimBonus;
var config array<int>  arrRoscosmosSatelliteDiscount;
var config array<int>  arrSandhurstOTSRanksReduction;
var config array<int>  arrSpecialAirServiceAimBonus;
var config array<int>  arrSpecialWarfareSchoolDiscount;
var config array<int>  arrSpetznazBonusHP;
var config array<int>  arrSurvivalTrainingBonusHP;
var config array<int>  arrTaskForceArrowheadBonusWill;
var config array<int>  arrWealthOfNationsBonusFunding;
var config array<int>  arrWeHaveWaysResearchTimeReduction;
var config array<int>  arrXenologicalRemediesSalePriceBonus;


static function array<LWCEDataTemplate> CreateTemplates()
{
    local array<LWCEDataTemplate> arrTemplates;

    arrTemplates.AddItem(AirSuperiority());
    arrTemplates.AddItem(ArchitectsOfTheFuture());
    arrTemplates.AddItem(ArmyOfTheSouthernCross());
    arrTemplates.AddItem(Baumeister());
    arrTemplates.AddItem(Bounties());
    arrTemplates.AddItem(CallToArms());
    arrTemplates.AddItem(CheyenneMountain());
    arrTemplates.AddItem(Cyberware());
    arrTemplates.AddItem(DeusEx());
    arrTemplates.AddItem(EagerToServe());
    arrTemplates.AddItem(Expertise());
    arrTemplates.AddItem(FirstRecce());
    arrTemplates.AddItem(GhostInTheMachine());
    arrTemplates.AddItem(GiftOfOsiris());
    arrTemplates.AddItem(IndependenceDay());
    arrTemplates.AddItem(JaiVidwan());
    arrTemplates.AddItem(JungleScouts());
    arrTemplates.AddItem(LegacyOfUxmal());
    arrTemplates.AddItem(NeoPanzers());
    arrTemplates.AddItem(NewWarfare());
    arrTemplates.AddItem(TheOldPath());
    arrTemplates.AddItem(PatriaeSemperVigilis());
    arrTemplates.AddItem(PaxNigeriana());
    arrTemplates.AddItem(PerArduaAdAstra());
    arrTemplates.AddItem(PowerToThePeople());
    arrTemplates.AddItem(QuaidOrsay());
    arrTemplates.AddItem(RingOfFire());
    arrTemplates.AddItem(Robotics());
    arrTemplates.AddItem(Roscosmos());
    arrTemplates.AddItem(Sandhurst());
    arrTemplates.AddItem(SpecialAirService());
    arrTemplates.AddItem(SpecialWarfareSchool());
    arrTemplates.AddItem(Spetznaz());
    arrTemplates.AddItem(SurvivalTraining());
    arrTemplates.AddItem(TaskForceArrowhead());
    arrTemplates.AddItem(WealthOfNations());
    arrTemplates.AddItem(WeHaveWays());
    arrTemplates.AddItem(XenologicalRemedies());

    return arrTemplates;
}

static function int GetBonusValueInt(const out array<int> Values, int BonusLevel)
{
    local int Index;

    if (BonusLevel <= 0)
    {
        return 0;
    }

    Index = Min(BonusLevel - 1, Values.Length - 1);

    return Values[Index];
}

static function LWCEBonusTemplate AirSuperiority()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'AirSuperiority');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for aircraft purchase/build, aircraft weapons build, and aircraft maintenance

    return Template;
}

static function LWCEBonusTemplate ArchitectsOfTheFuture()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'ArchitectsOfTheFuture');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for labs/workshop build and maintenance costs

    return Template;
}

static function LWCEBonusTemplate ArmyOfTheSouthernCross()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'ArmyOfTheSouthernCross');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for unit promotion to gunner/rocketeer

    return Template;
}

static function LWCEBonusTemplate Baumeister()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'Baumeister');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for facility construction time

    return Template;
}

static function LWCEBonusTemplate Bounties()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'Bounties');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for abduction rewards

    return Template;
}

static function LWCEBonusTemplate CallToArms()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'CallToArms');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for fatigue calculation

    return Template;
}

static function LWCEBonusTemplate CheyenneMountain()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'CheyenneMountain');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for excavation costs

    return Template;
}

static function LWCEBonusTemplate Cyberware()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'Cyberware');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for MEC item meld costs

    return Template;
}

static function LWCEBonusTemplate DeusEx()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'DeusEx');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for gene mod costs

    return Template;
}

static function LWCEBonusTemplate EagerToServe()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'EagerToServe');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for soldier recruitment cost

    return Template;
}

static function LWCEBonusTemplate Expertise()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'Expertise');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for research credit bonuses

    return Template;
}

static function LWCEBonusTemplate FirstRecce()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'FirstRecce');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for stat bonuses for scouts/snipers

    return Template;
}

static function LWCEBonusTemplate GhostInTheMachine()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'GhostInTheMachine');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for SHIV aim bonuses

    return Template;
}

static function LWCEBonusTemplate GiftOfOsiris()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'GiftOfOsiris');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for fatigue calculations

    return Template;
}

static function LWCEBonusTemplate IndependenceDay()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'IndependenceDay');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for panic reduction after alien base assaults

    return Template;
}

static function LWCEBonusTemplate JaiVidwan()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'JaiVidwan');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for lab adjacency bonuses

    return Template;
}

static function LWCEBonusTemplate JungleScouts()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'JungleScouts');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for armor inventory slots

    return Template;
}

static function LWCEBonusTemplate LegacyOfUxmal()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'LegacyOfUxmal');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for psi training chances

    return Template;
}

static function LWCEBonusTemplate NeoPanzers()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'NeoPanzers');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for cost reductions for MEC/SHIV weapons

    return Template;
}

static function LWCEBonusTemplate NewWarfare()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'NewWarfare');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for cost reductions for Foundry projects

    return Template;
}

static function LWCEBonusTemplate TheOldPath()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'TheOldPath');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for reductions in psi training time

    return Template;
}

static function LWCEBonusTemplate PatriaeSemperVigilis()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'PatriaeSemperVigilis');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for unit bonus will

    return Template;
}

static function LWCEBonusTemplate PaxNigeriana()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'PaxNigeriana');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for unit bonus mobility

    return Template;
}

static function LWCEBonusTemplate PerArduaAdAstra()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'PerArduaAdAstra');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for unit bonus stat rolls

    return Template;
}

static function LWCEBonusTemplate PowerToThePeople()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'PowerToThePeople');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for power facility cost/maintenance reduction

    return Template;
}

static function LWCEBonusTemplate QuaidOrsay()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'QuaidOrsay');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for EXALT scans and council requests

    return Template;
}

static function LWCEBonusTemplate RingOfFire()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'RingOfFire');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for base steam vents

    return Template;
}

static function LWCEBonusTemplate Robotics()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'Robotics');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for unit bonus aim for SHIVs/MECs

    return Template;
}

static function LWCEBonusTemplate Roscosmos()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'Roscosmos');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for satellite cost

    return Template;
}

static function LWCEBonusTemplate Sandhurst()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'Sandhurst');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for OTS ranks

    return Template;
}

static function LWCEBonusTemplate SpecialAirService()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'SpecialAirService');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for unit bonus aim

    return Template;
}

static function LWCEBonusTemplate SpecialWarfareSchool()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'SpecialWarfareSchool');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for OTS project cost

    return Template;
}

static function LWCEBonusTemplate Spetznaz()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'Spetznaz');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for unit bonus HP for assaults and infantry

    return Template;
}

static function LWCEBonusTemplate SurvivalTraining()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'SurvivalTraining');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for unit bonus HP

    return Template;
}

static function LWCEBonusTemplate TaskForceArrowhead()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'TaskForceArrowhead');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for unit bonus will for engineers/medics

    return Template;
}

static function LWCEBonusTemplate WealthOfNations()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'WealthOfNations');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for monthly XCOM funding

    return Template;
}

static function LWCEBonusTemplate WeHaveWays()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'WeHaveWays');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for autopsy/interrogation times

    return Template;
}

static function LWCEBonusTemplate XenologicalRemedies()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'XenologicalRemedies');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for corpse sale prices

    return Template;
}