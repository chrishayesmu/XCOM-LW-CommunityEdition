class LWCEAbilityTag extends LWCELocalizeTag;

var XGAbility m_kAbility;

function bool Expand(string InString, out string OutString)
{
    local Name TagName;

    TagName = name(InString);

    switch (TagName)
    {
        case 'AdrenalineSurgeAimBonus':
            OutString = string(`LWCE_TACCFG(iAdrenalineSurgeAimBonus));
            break;
        case 'AdrenalineSurgeCritBonus':
            OutString = string(`LWCE_TACCFG(iAdrenalineSurgeCritChanceBonus));
            break;
        case 'AggressionCritBonusMax':
            OutString = string(`LWCE_TACCFG(iAggressionMaximumBonus));
            break;
        case 'AggressionCritBonusPerEnemy':
            OutString = string(`LWCE_TACCFG(iAggressionCritChanceBonusPerVisibleEnemy));
            break;
        case 'AutoThreatAssessBonus':
            OutString = string(`LWCE_TACCFG(iAutomatedThreatAssessmentDefenseBonus));
            break;
        case 'BattleScannerDuration':
            OutString = string(class'XGTacticalGameCoreNativeBase'.const.BATTLE_SCANNER_DURATION);
            break;
        case 'BloodCallCooldown':
            break;
        case 'BloodCallDuration':
            break;
        case 'BodyShieldDefense':
            OutString = string(-1 * `LWCE_TACCFG(iBodyShieldAimPenalty));
            break;
        case 'CalcSuppression':
            OutString = string(`LWCE_TACCFG(iSuppressionAimPenalty));
            break;
        case 'CatchingBreathAimPenalty':
            OutString = string(`LWCE_TACCFG(iCatchingBreathAimPenalty));
            break;
        case 'CatchingBreathMovePenalty':
            OutString = string(class'XGTacticalGameCoreNativeBase'.const.CATCHINGBREATH_MOVE_PENALTY);
            break;
        case 'ChitinPlatingHealthBonus':
            // TODO get item stats
            break;
        case 'CloseAndPersonalDist':
            OutString = string(int(class'XGTacticalGameCoreNativeBase'.const.CLOSEANDPERSONAL_MAX_DIST / 1.5));
            break;
        case 'CloseCombatKineticDamage':
            OutString = string(int(100 * class'XGTacticalGameCoreNativeBase'.const.CLOSECOMBAT_KINETIC_DMG_BONUS));
            break;
        case 'CollateralDamageReduction':
            OutString = "33"; // TODO configure
            break;
        case 'CombatDrugsWillBonus':
            OutString = string(`LWCE_TACCFG(iCombatDrugsWillBonus));
            break;
        case 'CouncilMedalEarnedStatBonus':
            break;
        case 'CouncilMedalFightBonus':
            break;
        case 'CouncilMedalFightTiles':
            break;
        case 'DamageControlTurns':
            OutString = string(class'XGTacticalGameCoreNativeBase'.const.DAMAGECONTROL_TURNS);
            break;
        case 'DamnGoodGroundAimBonus':
            OutString = string(`LWCE_TACCFG(iDamnGoodGroundAimBonus));
            break;
        case 'DamnGoodGroundDefenseBonus':
            OutString = string(`LWCE_TACCFG(iDamnGoodGroundDefenseBonus));
            break;
        case 'DeathBlossomCooldown':
            OutString = string(class'XGTacticalGameCoreNativeBase'.const.DEATH_BLOSSOM_COOLDOWN);
            break;
        case 'DenseSmokeDefenseBonus':
            OutString = string(`LWCE_TACCFG(iDenseSmokeDefenseBonus));
            break;
        case 'DisablingShotCooldown':
            break;
        case 'DisorientedAimPenalty':
            OutString = string(`LWCE_TACCFG(iDisorientedAimPenalty));
            break;
        case 'DistortionFieldDefense':
            OutString = string(`LWCE_TACCFG(iDistortionFieldDefenseBonus));
            break;
        case 'DoubleTapCooldown':
            break;
        case 'Duration':
            break;
        case 'EvasionDefenseBonus':
            OutString = string(`LWCE_TACCFG(iFlyingDefenseBonus));
            break;
        case 'ExecutionerAimBonus':
            break;
        case 'ExecutionerHealthThreshold':
            break;
        case 'FailIcon':
            break;
        case 'GeneModBrainDampingWill':
            OutString = string(`LWCE_TACCFG(iNeuralDampingWillBonus));
            break;
        case 'GeneModDepthPerceptionAim':
            OutString = string(`LWCE_TACCFG(iDepthPerceptionAimBonus));
            break;
        case 'GeneModDepthPerceptionCrit':
            OutString = string(`LWCE_TACCFG(iDepthPerceptionCritChanceBonus));
            break;
        case 'GeneModPupilsBonus':
            OutString = string(`LWCE_TACCFG(iHyperReactivePupilsAimBonus));
            break;
        case 'GrenadierCharges':
            break;
        case 'HardenedCritPenalty':
            OutString = string(m_kGameCore.GetHardenedCritBonus());
            break;
        case 'HeadshotCooldown':
            break;
        case 'HeadshotCritBonus':
            break;
        case 'InternationalAim':
            break;
        case 'InternationalAimCalc':
            break;
        case 'InternationalWill':
            break;
        case 'InternationalWillCalc':
            break;
        case 'KillerInstinctCritDamageBonus':
            break;
        case 'MindControlCooldown':
            break;
        case 'MindControlDuration':
            break;
        case 'MindMergeCritBonus':
            break;
        case 'MindMergeShieldDamage':
            break;
        case 'MindfrayCooldown':
            break;
        case 'MindfrayDuration':
            break;
        case 'Name':
            if (m_kAbility != none)
            {
                OutString = m_kAbility.GetName();
            }

            break;
        case 'NanoFiberHealth':
            break;
        case 'PlatformStabilityAim':
            OutString = string(`LWCE_TACCFG(iPlatformStabilityAimBonus));
            break;
        case 'PlatformStabilityAimRockets':
            OutString = string(`LWCE_TACCFG(iPlatformStabilityAimBonusForRockets));
            break;
        case 'PlatformStabilityCrit':
            OutString = string(`LWCE_TACCFG(iPlatformStabilityCritChanceBonus));
            break;
        case 'PossibleDamage':
            if (m_kAbility != none)
            {
                //OutString = string(m_kAbility.GetPossibleDamage());
            }

            break;
        case 'PsiArmorWillBonus':
            break;
        case 'PsiInspirationCooldown':
            break;
        case 'PsiInspirationDuration':
            break;
        case 'PsiInspirationWillBonus':
            break;
        case 'PsiPanicCooldown':
            break;
        case 'RapidFireAimPenalty':
            OutString = string(`LWCE_TACCFG(iRapidFireAimPenalty));
            break;
        case 'RegenPheromoneRegen':
            break;
        case 'ReviveHealthPercent':
            break;
        case 'RiftCooldown':
            break;
        case 'RocketeerExtraRockets':
            break;
        case 'RunAndGunCooldown':
            break;
        case 'SecondaryHeartBleedTimerBonus':
            break;
        case 'ShockAbsorbentArmorDmgReduction':
            OutString = string(int(100.0f * `LWCE_TACCFG(fShockAbsorbentArmorIncomingDamageMultiplier)));
            break;
        case 'ShockAbsorbentArmorTiles':
            OutString = string(`LWCE_TACCFG(fShockAbsorbentArmorRadius / 96.0f));
            break;
        case 'ShredderRocketDamageEffectDuration':
            break;
        case 'SmokeBombDefenseBonus':
            OutString = string(`LWCE_TACCFG(iSmokeGrenadeDefenseBonus));
            break;
        case 'SnapShotAimPenalty':
            OutString = string(`LWCE_TACCFG(iSnapShotAimPenalty));
            break;
        case 'StunHP':
            break;
        case 'TKFieldDefenseBonus':
            OutString = string(`LWCE_TACCFG(iTelekineticFieldDefenseBonus));
            break;
        case 'TacticalSenseDefenseBonusMax':
            OutString = string(`LWCE_TACCFG(iTacticalSenseMaximumBonus));
            break;
        case 'TacticalSenseDefenseBonusPerEnemy':
            OutString = string(`LWCE_TACCFG(iTacticalSenseDefenseBonusPerVisibleEnemy));
            break;
        case 'TelekineticFieldCooldown':
            break;
        case 'TerraDefense':
            OutString = string(`LWCE_TACCFG(iEspritDeCorpsDefenseBonus));
            break;
        case 'TerraWill':
            OutString = string(`LWCE_TACCFG(iEspritDeCorpsWillBonus));
            break;
        case 'TracerBeamsAimBonus':
            OutString = string(`LWCE_TACCFG(iHoloTargetingAimBonus));
            break;
        case 'UrbanAim':
            OutString = string(`LWCE_TACCFG(iSharpshooterAimBonus));
            break;
        case 'UrbanCrit':
            OutString = string(`LWCE_TACCFG(iSharpshooterCritChanceBonus));
            break;
        case 'UrbanDefense':
            OutString = string(`LWCE_TACCFG(iSemperVigilansDefenseBonus));
            break;
        case 'WeaponName':
            break;
    }

    if (OutString != "")
    {
        return true;
    }

    RestoreUnhandledTag(InString, OutString);
    return false;
}

function int GetAbilityDuration(int iAbility)
{
    // TODO
}

function int GetAbilityCooldown(int iAbility)
{
    // TODO
}

defaultproperties
{
    Tag="LWCEAbility"
}