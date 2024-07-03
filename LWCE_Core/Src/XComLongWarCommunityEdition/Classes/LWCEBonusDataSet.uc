/// <summary>
/// TODO
/// </summary>
class LWCEBonusDataSet extends LWCEDataSet
    config(LWCEBonuses)
    dependson(LWCEBonusTemplate, LWCETypes);

var config array<int>  arrAirSuperiorityMaintenanceDiscount;
var config array<int>  arrAirSuperiorityShipPurchaseDiscount;
var config array<int>  arrAirSuperiorityShipWeaponPurchaseDiscount;
var config array<int>  arrArchitectsOfTheFutureMaintenanceDiscount;
var config array<int>  arrArchitectsOfTheFuturePurchaseDiscount;
var config array<int>  arrArmyOfTheSouthernCrossAimBonus;
var config array<int>  arrBaumeisterFacilityBuildTimeReduction;
var config array<int>  arrBountiesAbductionsCashBonus;
var config array<int>  arrCallToArmsGeneModFatigueReduction;
var config array<int>  arrCheyenneMountainExcavationDiscount;
var config array<int>  arrCyberwareMeldDiscount;
var config array<int>  arrDeusExCostReduction;
var config array<int>  arrDeusExTimeReduction;
var config array<int>  arrEagerToServeCostReduction;
var config array<int>  arrExpertiseResearchCreditBonus;
var config array<int>  arrFirstRecceDefenseBonus;
var config array<int>  arrForeignLegionNumberOfSoldiers;
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
var config array<int>  arrPowerToThePeopleMaintenanceDiscount;
var config array<int>  arrPowerToThePeoplePurchaseDiscount;
var config array<int>  arrQuaidOrsayCouncilRequestCooldownReduction;
var config array<int>  arrQuaidOrsayCouncilRequestShieldsBonus;
var config array<int>  arrQuaidOrsayExaltScanningCostReduction;
var config array<int>  arrRingOfFireAddedSteamVents;
var config array<int>  arrRoboticsAimBonus;
var config array<int>  arrRoscosmosSatelliteDiscount;
var config array<int>  arrSandhurstOTSRanksReduction;
var config array<int>  arrSpecialAirServiceAimBonus;
var config array<int>  arrSpecialWarfareSchoolDiscount;
var config array<int>  arrSpetznazHPBonus;
var config array<int>  arrSurvivalTrainingHPBonus;
var config array<int>  arrTaskForceArrowheadBonusWill;
var config array<int>  arrWealthOfNationsBonusFunding;
var config array<int>  arrWeHaveWaysResearchTimeReduction;
var config array<int>  arrXenologicalRemediesSalePriceBonus;

var const localized string m_strStartingCashBonus;

static function array<LWCEDataTemplate> CreateTemplates()
{
    local array<LWCEDataTemplate> arrTemplates;

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

static function OnPostTemplatesCreated()
{
    local LWCEItemTemplateManager kItemTemplateMgr;
    local LWCEShipTemplateManager kShipTemplateMgr;
    local LWCEArmorTemplate kArmorTemplate;
    local LWCEShipTemplate kShipTemplate;
    local array<LWCEShipTemplate> arrAllShipTemplates;
    local name nmTemplate;

    kItemTemplateMgr = `LWCE_ITEM_TEMPLATE_MGR;
    kShipTemplateMgr = `LWCE_SHIP_TEMPLATE_MGR;

    // Set up the Air Superiority bonus: a discount on ship maintenance
    // TODO: also set up a cost decrease for items that result in ships here
    arrAllShipTemplates = kShipTemplateMgr.GetAllShipTemplates();

    foreach arrAllShipTemplates(kShipTemplate)
    {
        kShipTemplate.arrMaintenanceCostFns.AddItem(AirSuperiority_DiscountMaintenance);
    }

    // Set up the Jungle Scouts bonus: an extra small item slot for certain armors
    foreach default.arrJungleScoutsCompatibleArmor(nmTemplate)
    {
        kArmorTemplate = kItemTemplateMgr.FindArmorTemplate(nmTemplate);

        // Getting a none template isn't wholly unexpected; some mods may ship config that would make them
        // compatible with other mods that may not be present, for example
        if (kArmorTemplate == none)
        {
            continue;
        }

        kArmorTemplate.arrSmallInventorySlotsFns.AddItem(JungleScouts_GetSmallInventorySlotsDelegate);
    }
}

static function int GetBonusValueInt(const out array<int> Values, int BonusLevel)
{
    local int Index;

    if (BonusLevel <= 0)
    {
        return 0;
    }

    Index = Clamp(BonusLevel - 1, 0, Values.Length - 1);

    return Values[Index];
}

static function AirSuperiority_DiscountMaintenance(out int iMaintenance, name nmShipTeam)
{
    local int iBonusLevel;
    local float fDiscount;

    iBonusLevel = `LWCE_BONUS_LEVEL('AirSuperiority');
    fDiscount = GetBonusValueInt(default.arrAirSuperiorityMaintenanceDiscount, iBonusLevel) / 100.0f;
    fDiscount = FClamp(fDiscount, 0.0f, 100.0f);

    iMaintenance *= (100.0f - fDiscount) / 100.0f;
}

static function LWCEBonusTemplate ArchitectsOfTheFuture()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'ArchitectsOfTheFuture');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('LWCEFacilityTemplate_GetCost', ArchitectsOfTheFuture_AdjustFacilityCost);
    Template.AddEvent('LWCEFacilityTemplate_GetMonthlyCost', ArchitectsOfTheFuture_AdjustFacilityMaintenance);

    return Template;
}

static function ArchitectsOfTheFuture_AdjustFacilityCost(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEFacilityTemplate kFacilityTemplate;
    local LWCEDataContainer kDataContainer;
    local LWCECost kCost;
    local int iBonusLevel;
    local float fDiscount;

    kFacilityTemplate = LWCEFacilityTemplate(EventSource);

    if (kFacilityTemplate.GetFacilityName() != 'Facility_Laboratory' && kFacilityTemplate.GetFacilityName() != 'Facility_Workshop')
    {
        return;
    }

    iBonusLevel = `LWCE_BONUS_LEVEL('ArchitectsOfTheFuture');
    fDiscount = GetBonusValueInt(default.arrArchitectsOfTheFuturePurchaseDiscount, iBonusLevel) / 100.0f;
    kDataContainer = LWCEDataContainer(EventData);
    kCost = LWCECost(kDataContainer.Data[0].Obj);
    kCost.iCash = kCost.iCash * (1.0f - fDiscount);
}

static function ArchitectsOfTheFuture_AdjustFacilityMaintenance(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEFacilityTemplate kFacilityTemplate;
    local LWCEDataContainer kDataContainer;
    local int iBonusLevel;
    local float fDiscount;

    kFacilityTemplate = LWCEFacilityTemplate(EventSource);

    if (kFacilityTemplate.GetFacilityName() != 'Facility_Laboratory' && kFacilityTemplate.GetFacilityName() != 'Facility_Workshop')
    {
        return;
    }

    iBonusLevel = `LWCE_BONUS_LEVEL('ArchitectsOfTheFuture');
    fDiscount = GetBonusValueInt(default.arrArchitectsOfTheFutureMaintenanceDiscount, iBonusLevel) / 100.0f;
    kDataContainer = LWCEDataContainer(EventData);
    kDataContainer.Data[0].I = kDataContainer.Data[0].I * (1.0f - fDiscount);
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

static function JungleScouts_GetSmallInventorySlotsDelegate(LWCE_XGStrategySoldier kSoldier, out int iNumSlots)
{
    if (`LWCE_BONUS_LEVEL('JungleScouts') <= 0)
    {
        return;
    }

    // Make sure we don't double dip if the player has the real Tactical Rigging project
    if (!kSoldier.HasPerk(`LW_PERK_ID(TacticalRigging)))
    {
        iNumSlots++;
    }
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
    Template.AddEvent('AfterInitializeSoldierStats', PatriaeSemperVigilis_AddWill);

    return Template;
}

static function PatriaeSemperVigilis_AddWill(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGStrategySoldier kSoldier;
    local LWCEDataContainer kDataContainer;
    local int iBonusLevel, iWillBonus;

    kDataContainer = LWCEDataContainer(EventData);
    kSoldier = LWCE_XGStrategySoldier(kDataContainer.Data[0].Obj);

    iBonusLevel = `LWCE_BONUS_LEVEL('PatriaeSemperVigilis');
    iWillBonus = GetBonusValueInt(default.arrPatriaeSemperVigilisWillBonus, iBonusLevel);

    kSoldier.m_kChar.aStats[eStat_Will] += iWillBonus;
}

static function LWCEBonusTemplate PaxNigeriana()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'PaxNigeriana');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('AfterInitializeSoldierStats', PaxNigeriana_AddMobility);

    return Template;
}

static function PaxNigeriana_AddMobility(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGStrategySoldier kSoldier;
    local LWCEDataContainer kDataContainer;
    local int iBonusLevel, iMobilityBonus;

    kDataContainer = LWCEDataContainer(EventData);
    kSoldier = LWCE_XGStrategySoldier(kDataContainer.Data[0].Obj);

    iBonusLevel = `LWCE_BONUS_LEVEL('PaxNigeriana');
    iMobilityBonus = GetBonusValueInt(default.arrPaxNigerianaMobilityBonus, iBonusLevel);

    kSoldier.m_kChar.aStats[eStat_Mobility] += iMobilityBonus;
}

static function LWCEBonusTemplate PerArduaAdAstra()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'PerArduaAdAstra');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('AfterInitializeSoldierStats', PerArduaAdAstra_AddToUnrolledStats);
    Template.AddEvent('BeforeInitializeSoldierStats', PerArduaAdAstra_AddToPointBuy);

    return Template;
}

static function PerArduaAdAstra_AddToPointBuy(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local int iBonusLevel, iExtraPoints;

    kDataContainer = LWCEDataContainer(EventData);

    iBonusLevel = `LWCE_BONUS_LEVEL('PerArduaAdAstra');
    iExtraPoints = GetBonusValueInt(default.arrPerArduaAdAstraStatRollsBonus, iBonusLevel);
    kDataContainer.Data[2].I += iExtraPoints;
}

static function PerArduaAdAstra_AddToUnrolledStats(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local int iBonusLevel;

    kDataContainer = LWCEDataContainer(EventData);

    // If point buy was used to roll stats, we don't want to change anything
    if (kDataContainer.Data[1].B)
    {
        return;
    }

    iBonusLevel = `LWCE_BONUS_LEVEL('PerArduaAdAstra');

    // TODO need a config with the stat changes for soldiers
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
    Template.AddEvent('CouncilRequestGenerated', QuaidOrsay_OnCouncilRequestGenerated);
    Template.AddEvent('CouncilRequestOnCooldown', QuaidOrsay_ReduceCouncilRequestCooldown);
    // TODO: hook into events for EXALT scans and council requests

    return Template;
}

static function QuaidOrsay_OnCouncilRequestGenerated(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local LWCE_XGFundingCouncil kFundingCouncil;
    local name nmRequest, nmRequestingCountry;
    local int iBonusLevel, iCooldownReductionPercentage, iShieldsIncreasePercentage;
    local int Index;

    kFundingCouncil = LWCE_XGFundingCouncil(EventSource);
    kDataContainer = LWCEDataContainer(EventData);

    iBonusLevel = `LWCE_BONUS_LEVEL('QuaidOrsay');
    iCooldownReductionPercentage = GetBonusValueInt(default.arrQuaidOrsayCouncilRequestCooldownReduction, iBonusLevel);
    iShieldsIncreasePercentage = GetBonusValueInt(default.arrQuaidOrsayCouncilRequestShieldsBonus, iBonusLevel);

    // First effect: reduce the time until the next request will occur
    kFundingCouncil.m_iSecondRequestCountdown *= (100 - iCooldownReductionPercentage) / 100.0f;

    // Second effect: increase the amount of country defense granted by the request
    nmRequest = kDataContainer.Data[0].Nm;
    nmRequestingCountry = kDataContainer.Data[1].Nm;

    for (Index = 0; Index < kFundingCouncil.m_arrCECurrentRequests.Length; Index++)
    {
        if (kFundingCouncil.m_arrCECurrentRequests[Index].nmRequest != nmRequest || kFundingCouncil.m_arrCECurrentRequests[Index].nmRequestingCountry != nmRequestingCountry)
        {
            continue;
        }

        kFundingCouncil.m_arrCECurrentRequests[Index].kReward.iCountryDefense *= (100 + iShieldsIncreasePercentage) / 100.0f;
        return;
    }

    // The request may have wound up in one of two places, so repeat the above loop with a different array
    for (Index = 0; Index < kFundingCouncil.m_arrCEPendingRequests.Length; Index++)
    {
        if (kFundingCouncil.m_arrCEPendingRequests[Index].nmRequest != nmRequest || kFundingCouncil.m_arrCEPendingRequests[Index].nmRequestingCountry != nmRequestingCountry)
        {
            continue;
        }

        kFundingCouncil.m_arrCEPendingRequests[Index].kReward.iCountryDefense *= (100 + iShieldsIncreasePercentage) / 100.0f;
        return;
    }
}

static function QuaidOrsay_ReduceCouncilRequestCooldown(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local int iBonusLevel, iCooldownReductionPercentage;

    iBonusLevel = `LWCE_BONUS_LEVEL('QuaidOrsay');
    iCooldownReductionPercentage = GetBonusValueInt(default.arrQuaidOrsayCouncilRequestCooldownReduction, iBonusLevel);

    kDataContainer = LWCEDataContainer(EventData);
    kDataContainer.Data[1].I *= (100 - iCooldownReductionPercentage) / 100.0f;
}

static function LWCEBonusTemplate RingOfFire()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'RingOfFire');

    Template.bRegisterInStrategy = true;
    Template.AddEvent('BeforeGenerateBaseTiles', RingOfFire_AdjustSteamVents);

    return Template;
}

static function RingOfFire_AdjustSteamVents(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local int iBonusLevel, iExtraVents;

    if (!LWCE_XGBase(EventSource).m_bIsPrimaryBase)
    {
        return;
    }

    iBonusLevel = `LWCE_BONUS_LEVEL('RingOfFire');
    iExtraVents = GetBonusValueInt(default.arrRingOfFireAddedSteamVents, iBonusLevel);

    kDataContainer = LWCEDataContainer(EventData);
    kDataContainer.Data[0].I += iExtraVents;
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
    Template.AddEvent('AfterInitializeSoldierStats', SpecialAirService_AddAim);

    return Template;
}

static function SpecialAirService_AddAim(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGStrategySoldier kSoldier;
    local LWCEDataContainer kDataContainer;
    local int iBonusLevel, iAimBonus;

    kDataContainer = LWCEDataContainer(EventData);
    kSoldier = LWCE_XGStrategySoldier(kDataContainer.Data[0].Obj);

    iBonusLevel = `LWCE_BONUS_LEVEL('SpecialAirService');
    iAimBonus = GetBonusValueInt(default.arrSpecialAirServiceAimBonus, iBonusLevel);

    kSoldier.m_kChar.aStats[eStat_Offense] += iAimBonus;
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
    Template.AddEvent('AfterInitializeSoldierStats', SurvivalTraining_AddHP);

    return Template;
}

static function SurvivalTraining_AddHP(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCE_XGStrategySoldier kSoldier;
    local LWCEDataContainer kDataContainer;
    local int iBonusLevel, iHPBonus;

    kDataContainer = LWCEDataContainer(EventData);
    kSoldier = LWCE_XGStrategySoldier(kDataContainer.Data[0].Obj);

    iBonusLevel = `LWCE_BONUS_LEVEL('SurvivalTraining');
    iHPBonus = GetBonusValueInt(default.arrSurvivalTrainingHPBonus, iBonusLevel);

    kSoldier.m_kChar.aStats[eStat_HP] += iHPBonus;
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
    Template.AddEvent('CalculateIncomeFromCountries', WealthOfNations_AdjustIncome);

    return Template;
}

static function WealthOfNations_AdjustIncome(Object EventData, Object EventSource, Name EventID, Object CallbackData)
{
    local LWCEDataContainer kDataContainer;
    local int iBonusLevel, iIncomeIncreasePercentage;

    kDataContainer = LWCEDataContainer(EventData);

    iBonusLevel = `LWCE_BONUS_LEVEL('WealthOfNations');
    iIncomeIncreasePercentage = GetBonusValueInt(default.arrWealthOfNationsBonusFunding, iBonusLevel);

    // The simplest way to do this bonus is to simply multiply the incoming data value by our percentage. This has pros and cons:
    // if a mod has made negative country incomes a possibility, this will also multiply those negatives. However, if we iterate the
    // countries and calculate the bonus ourselves, then Wealth of Nations won't be multiplicative with any other handlers of this event
    // which are changing funding. Since the latter case seems more likely, LWCE is going with the simple approach; any mod authors who
    // find this poses an issue should contact us for possible changes.
    kDataContainer.Data[1].I *= (100 + iIncomeIncreasePercentage) / 100.0f;
}

static function LWCEBonusTemplate WeHaveWays()
{
    local LWCEBonusTemplate Template;

    `CREATE_BONUS_TEMPLATE(Template, 'WeHaveWays');

    Template.bRegisterInStrategy = true;
    // TODO: hook into events for autopsy/interrogation times
    // TODO: if the bonus is gained during an applicable research, reduce time remaining

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