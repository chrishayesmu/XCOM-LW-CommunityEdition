class LWCE_UIUnitGermanMode_ShotInfo extends UIUnitGermanMode_ShotInfo;

simulated function UpdateDisplay()
{
    local LWCE_XGUnit kAttacker, kTarget;
    local XGAbility kAbility;
    local XGAbility_Targeted kAbilityTarget;
    local LWCE_XGAbility kCEAbility;
    local int iBonus, iHitChance, iCriticalChance, iNoCriticalChance;
    local XGAction_Targeting kTargetingAction;
    local TShotResult kResult;
    local TShotInfo kInfo;
    local string shotName, hitChance, critChance;

    kAttacker = LWCE_XGUnit(XComTacticalController(controllerRef).GetActiveUnit());
    kTargetingAction = XGAction_Targeting(kAttacker.GetAction());

    if (kTargetingAction == none)
    {
        return;
    }

    kAbility = kTargetingAction.m_kShot;
    kAbilityTarget = XGAbility_Targeted(kAbility);
    kCEAbility = LWCE_XGAbility(kAbility);
    iHitChance = -1;
    iCriticalChance = -1;
    iNoCriticalChance = 0;

    if (kTargetingAction != none && kTargetingAction.m_kShot != none)
    {
        kTarget = LWCE_XGUnit(kAbilityTarget.GetPrimaryTarget());

        if (kAbility.HasProperty(eProp_PsiRoll))
        {
            iBonus = kAttacker.GetSituationalWill(/* bIncludeBaseStat */ false, /* bIncludeNeuralDamping */ false, /* bIncludeCombatStims */ false) - kTarget.GetSituationalWill(false, true, false);

            if (kAbility.iType == eAbility_MindControl || kAbility.iType == eAbility_PsiControl)
            {
                iBonus += `GAMECORE.MIND_CONTROL_DIFFICULTY;
            }

            if (kAbility.iType == eAbility_PsiPanic)
            {
                iBonus = kAttacker.GetSituationalWill(/* bIncludeBaseStat */ false, /* bIncludeNeuralDamping */ false, /* bIncludeCombatStims */ false) - kTarget.GetSituationalWill(false, true, true);

                if (kAbilityTarget.GetPrimaryTarget().GetCharacter().HasUpgrade(ePerk_GeneMod_BrainDamping))
                {
                    iHitChance = 0;
                    iCriticalChance = 0;
                }
                else
                {
                    iBonus += `GAMECORE.EXALT_LOOT3;
                }

                iCriticalChance = `BATTLE.m_kDesc.m_iDifficulty;
                `BATTLE.m_kDesc.m_iDifficulty = 0;
                iHitChance = kAttacker.WillTestChance(0, iBonus, false, false, kAbilityTarget.GetPrimaryTarget());
                `BATTLE.m_kDesc.m_iDifficulty = iCriticalChance;
                iCriticalChance = 0;
            }
        }
        else if (kAbility.HasProperty(eProp_ScatterTarget))
        {
            iHitChance = kTargetingAction.m_kShot.GetScatterChance(VSize(kAttacker.Location - kTargetingAction.GetTargetLoc()));
            iCriticalChance = 0;
        }
        else
        {
            iHitChance = kTargetingAction.m_kShot.GetHitChance();
            iCriticalChance = kTargetingAction.m_kShot.GetCriticalChance();
        }
    }

    if (kAbility == none || kAbilityTarget == none)
    {
        AS_SetShotInfo("", "", "", "", "");
    }
    else
    {
        if (kCEAbility != none)
        {
            ProcessAbilityBreakdown(kCEAbility.arrTargetOptions[kCEAbility.m_iCurrentTargetIndex].kPreview);
        }
        else
        {
            kAbilityTarget.GetShotSummary(kResult, kInfo);
            ProcessModifiers(kInfo.arrHitBonusStrings, kInfo.arrHitBonusValues, false);
            ProcessModifiers(kInfo.arrHitPenaltyStrings, kInfo.arrHitPenaltyValues, false);
            ProcessModifiers(kInfo.arrCritBonusStrings, kInfo.arrCritBonusValues, true);
            ProcessModifiers(kInfo.arrCritPenaltyStrings, kInfo.arrCritPenaltyValues, true);
        }

        if (iCriticalChance > 0 && kTargetingAction.m_kShot.ShouldShowCritPercentage())
        {
            critChance = iCriticalChance $ "%";
        }
        else if (kTargetingAction.m_kShot.ShouldShowCritPercentage())
        {
            critChance = iNoCriticalChance $ "%";
        }

        if (XComPresentationLayer(controllerRef.m_Pres).GetTacticalHUD().m_kAbilityHUD.CheckForAvailability(kAbility))
        {
            if (iHitChance > -1 && kTargetingAction.m_kShot.ShouldShowPercentage())
            {
                hitChance = iHitChance $ "%";
            }

            shotName = kAbility.GetName();
        }

        if (iHitChance > -1 && kTargetingAction.m_kShot.ShouldShowPercentage())
        {
            AS_SetShotInfo(Caps(shotName), hitChance, m_sShotChanceLabel, critChance, m_sCriticalLabel);
        }
        else
        {
            AS_SetShotInfo("", "", "", "", "");
        }
    }
}

protected simulated function ProcessAbilityBreakdown(const LWCEAbilityUsageSummary kBreakdown)
{
    local int I, iValue;
    local string strLabel, StrValue;

    // Positive hit chance modifiers
    for (I = 0; I < kBreakdown.arrHitChanceModifiers.Length; I++)
    {
        if (kBreakdown.arrHitChanceModifiers[I].iValue <= 0.0f)
        {
            continue;
        }

        iValue = kBreakdown.arrHitChanceModifiers[I].iValue;
        strLabel = class'UIUtilities'.static.GetHTMLColoredText(kBreakdown.arrHitChanceModifiers[I].SourceFriendlyName, eUIState_Normal);
        StrValue = class'UIUtilities'.static.GetHTMLColoredText("+" $ iValue $ "%", eUIState_Normal);

        AS_AddRegularItem(strLabel, StrValue);
    }

    // Negative hit chance modifiers
    for (I = 0; I < kBreakdown.arrHitChanceModifiers.Length; I++)
    {
        if (kBreakdown.arrHitChanceModifiers[I].iValue >= 0.0f)
        {
            continue;
        }

        iValue = kBreakdown.arrHitChanceModifiers[I].iValue;
        strLabel = class'UIUtilities'.static.GetHTMLColoredText(kBreakdown.arrHitChanceModifiers[I].SourceFriendlyName, eUIState_Bad);
        StrValue = class'UIUtilities'.static.GetHTMLColoredText(iValue $ "%", eUIState_Bad);

        AS_AddRegularItem(strLabel, StrValue);
    }

    // Positive crit chance modifiers
    for (I = 0; I < kBreakdown.arrCritChanceModifiers.Length; I++)
    {
        if (kBreakdown.arrCritChanceModifiers[I].iValue <= 0.0f)
        {
            continue;
        }

        iValue = kBreakdown.arrCritChanceModifiers[I].iValue;
        strLabel = class'UIUtilities'.static.GetHTMLColoredText(kBreakdown.arrCritChanceModifiers[I].SourceFriendlyName, eUIState_Normal);
        StrValue = class'UIUtilities'.static.GetHTMLColoredText("+" $ iValue $ "%", eUIState_Normal);

        AS_AddCritItem(strLabel, StrValue);
    }

    // Negative crit chance modifiers
    for (I = 0; I < kBreakdown.arrCritChanceModifiers.Length; I++)
    {
        if (kBreakdown.arrCritChanceModifiers[I].iValue >= 0.0f)
        {
            continue;
        }

        iValue = kBreakdown.arrCritChanceModifiers[I].iValue;
        strLabel = class'UIUtilities'.static.GetHTMLColoredText(kBreakdown.arrCritChanceModifiers[I].SourceFriendlyName, eUIState_Bad);
        StrValue = class'UIUtilities'.static.GetHTMLColoredText(iValue $ "%", eUIState_Bad);

        AS_AddCritItem(strLabel, StrValue);
    }
}