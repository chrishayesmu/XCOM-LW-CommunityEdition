class LWCEBonusTag extends LWCELocalizeTag;

`define INTBONUSVALUE(arr) (string(class'LWCEBonusDataSet'.static.GetBonusValueInt(class'LWCEBonusDataSet'.default.`arr, BonusLevel)))

var LWCEBonusTemplate BonusTemplate;
var int BonusLevel;

function bool Expand(string InString, out string OutString)
{
    local Name TagName;

    TagName = name(InString);

    switch (TagName)
    {
        case 'AirSuperiorityMaintenanceDiscount':
            OutString = `INTBONUSVALUE(arrAirSuperiorityMaintenanceDiscount);
            break;
        case 'AirSuperiorityShipPurchaseDiscount':
            OutString = `INTBONUSVALUE(arrAirSuperiorityShipPurchaseDiscount);
            break;
        case 'AirSuperiorityShipWeaponPurchaseDiscount':
            OutString = `INTBONUSVALUE(arrAirSuperiorityShipWeaponPurchaseDiscount);
            break;
        case 'ArchitectsOfTheFutureMaintenanceDiscount':
            OutString = `INTBONUSVALUE(arrArchitectsOfTheFutureMaintenanceDiscount);
            break;
        case 'ArchitectsOfTheFuturePurchaseDiscount':
            OutString = `INTBONUSVALUE(arrArchitectsOfTheFuturePurchaseDiscount);
            break;
        case 'ArmyOfTheSouthernCrossAimBonus':
            OutString = `INTBONUSVALUE(arrArmyOfTheSouthernCrossAimBonus);
            break;
        case 'BaumeisterFacilityBuildTimeReduction':
            OutString = `INTBONUSVALUE(arrBaumeisterFacilityBuildTimeReduction);
            break;
        case 'BountiesAbductionsCashBonus':
            OutString = `INTBONUSVALUE(arrBountiesAbductionsCashBonus);
            break;
        case 'CallToArmsGeneModFatigueReduction':
            OutString = `INTBONUSVALUE(arrCallToArmsGeneModFatigueReduction);
            break;
        case 'CheyenneMountainExcavationDiscount':
            OutString = `INTBONUSVALUE(arrCheyenneMountainExcavationDiscount);
            break;
        case 'CyberwareMeldDiscount':
            OutString = `INTBONUSVALUE(arrCyberwareMeldDiscount);
            break;
        case 'DeusExCostReduction':
            OutString = `INTBONUSVALUE(arrDeusExCostReduction);
            break;
        case 'DeusExTimeReduction':
            OutString = `INTBONUSVALUE(arrDeusExTimeReduction);
            break;
        case 'EagerToServeCostReduction':
            OutString = `INTBONUSVALUE(arrEagerToServeCostReduction);
            break;
        case 'ExpertiseResearchCreditBonus':
            OutString = `INTBONUSVALUE(arrExpertiseResearchCreditBonus);
            break;
        case 'FirstRecceDefenseBonus':
            OutString = `INTBONUSVALUE(arrFirstRecceDefenseBonus);
            break;
        case 'ForeignLegionNumberOfSoldiers':
            OutString = `INTBONUSVALUE(arrForeignLegionNumberOfSoldiers);
            break;
        case 'GhostInTheMachineAimBonus':
            OutString = `INTBONUSVALUE(arrGhostInTheMachineAimBonus);
            break;
        case 'GiftOfOsirisFatigueReduction':
            OutString = `INTBONUSVALUE(arrGiftOfOsirisFatigueReduction);
            break;
        case 'IndependenceDayPanicReduction':
            OutString = `INTBONUSVALUE(arrIndependenceDayPanicReduction);
            break;
        case 'JaiVidwanLabAdjacencyBonus':
            OutString = `INTBONUSVALUE(arrJaiVidwanLabAdjacencyBonus);
            break;
        case 'LegacyOfUxmalPsiTrainingBonus':
            OutString = `INTBONUSVALUE(arrLegacyOfUxmalPsiTrainingBonus);
            break;
        case 'NeoPanzersDiscount':
            OutString = `INTBONUSVALUE(arrNeoPanzersDiscount);
            break;
        case 'NewWarfareDiscount':
            OutString = `INTBONUSVALUE(arrNewWarfareDiscount);
            break;
        case 'OldPathPsiTrainingTimeReduction':
            OutString = `INTBONUSVALUE(arrOldPathPsiTrainingTimeReduction);
            break;
        case 'PatriaeSemperVigilisWillBonus':
            OutString = `INTBONUSVALUE(arrPatriaeSemperVigilisWillBonus);
            break;
        case 'PaxNigerianaMobilityBonus':
            OutString = `INTBONUSVALUE(arrPaxNigerianaMobilityBonus);
            break;
        case 'PerArduaAdAstraStatRollsBonus':
            OutString = `INTBONUSVALUE(arrPerArduaAdAstraStatRollsBonus);
            break;
        case 'PowerToThePeopleMaintenanceDiscount':
            OutString = `INTBONUSVALUE(arrPowerToThePeopleMaintenanceDiscount);
            break;
        case 'PowerToThePeoplePurchaseDiscount':
            OutString = `INTBONUSVALUE(arrPowerToThePeoplePurchaseDiscount);
            break;
        case 'QuaidOrsayCouncilRequestCooldownReduction':
            OutString = `INTBONUSVALUE(arrQuaidOrsayCouncilRequestCooldownReduction);
            break;
        case 'QuaidOrsayCouncilRequestShieldsBonus':
            OutString = `INTBONUSVALUE(arrQuaidOrsayCouncilRequestShieldsBonus);
            break;
        case 'QuaidOrsayExaltScanningCostReduction':
            OutString = `INTBONUSVALUE(arrQuaidOrsayExaltScanningCostReduction);
            break;
        case 'RingOfFireAddedSteamVents':
            OutString = `INTBONUSVALUE(arrRingOfFireAddedSteamVents);
            break;
        case 'RoboticsAimBonus':
            OutString = `INTBONUSVALUE(arrRoboticsAimBonus);
            break;
        case 'RoscosmosSatelliteDiscount':
            OutString = `INTBONUSVALUE(arrRoscosmosSatelliteDiscount);
            break;
        case 'SandhurstOTSRanksReduction':
            OutString = `INTBONUSVALUE(arrSandhurstOTSRanksReduction);
            break;
        case 'SpecialAirServiceAimBonus':
            OutString = `INTBONUSVALUE(arrSpecialAirServiceAimBonus);
            break;
        case 'SpecialWarfareSchoolDiscount':
            OutString = `INTBONUSVALUE(arrSpecialWarfareSchoolDiscount);
            break;
        case 'SpetznazHPBonus':
            OutString = `INTBONUSVALUE(arrSpetznazHPBonus);
            break;
        case 'SurvivalTrainingHPBonus':
            OutString = `INTBONUSVALUE(arrSurvivalTrainingHPBonus);
            break;
        case 'TaskForceArrowheadBonusWill':
            OutString = `INTBONUSVALUE(arrTaskForceArrowheadBonusWill);
            break;
        case 'WealthOfNationsBonusFunding':
            OutString = `INTBONUSVALUE(arrWealthOfNationsBonusFunding);
            break;
        case 'WeHaveWaysResearchTimeReduction':
            OutString = `INTBONUSVALUE(arrWeHaveWaysResearchTimeReduction);
            break;
        case 'XenologicalRemediesSalePriceBonus':
            OutString = `INTBONUSVALUE(arrXenologicalRemediesSalePriceBonus);
            break;
        default:
            return false;
    }

    return true;
}

defaultproperties
{
    Tag="LWCEBonus"
}