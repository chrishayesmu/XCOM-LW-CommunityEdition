class Highlander_UITacticalHUD_InfoPanel extends UITacticalHUD_InfoPanel;

simulated function Update(XGUnit kUnit, XGAbility kAbility)
{
    local XGAbility_Targeted kAbilityTarget;
    local int iTarget, iHitChance, iCriticalChance;
    local float fHitChance;
    local array<XGUnit> arrTargets;
    local XGAction_Targeting kTargetingAction;
    local TShotResult kResult;
    local TShotInfo kInfo;
    local XGInventory kInventory;
    local XGWeapon kActiveWeapon;
    local XGUnit kActiveUnit;
    local bool bEnableTimer;

    kAbilityTarget = XGAbility_Targeted(kAbility);
    kTargetingAction = XGAction_Targeting(kUnit.GetAction());
    bEnableTimer = false;
    iHitChance = -1;
    iCriticalChance = -1;

    if (kTargetingAction != none && kTargetingAction.m_kShot != none)
    {
        kTargetingAction.GetUIHitChance(iHitChance, iCriticalChance);

        if (kAbility.HasProperty(eProp_ScatterTarget))
        {
            bEnableTimer = true;
            m_kUnit = kUnit;
            m_kAbility = kAbility;
        }
    }

    SetCriticalChance("", "");

    if (kAbility == none || kAbilityTarget == none || kAbilityTarget.GetPrimaryTarget() == none)
    {
        AS_SetGermanModeButtonVisibility(false);
        AS_SetOKButtonVisibility(manager.IsTouchEnabled());
    }
    else if ( kAbilityTarget != none && (kAbilityTarget.IsFreeAiming() || kAbilityTarget.GetType() == eAbility_ShotOverload) )
    {
        AS_SetGermanModeButtonVisibility(false);
        AS_SetOKButtonVisibility(manager.IsTouchEnabled() || manager.IsMouseActive() && kAbilityTarget.GetType() == eAbility_ShotOverload);
    }
    else if (kAbilityTarget != none && kAbilityTarget.GetType() == eAbility_RunAndGun && kUnit.IsApplyingAbility(eAbility_RunAndGun))
    {
        AS_SetGermanModeButtonVisibility(manager.IsMouseActive());
        AS_SetOKButtonVisibility(false);
    }
    else
    {
        AS_SetGermanModeButtonVisibility(manager.IsMouseActive());
        AS_SetOKButtonVisibility(manager.IsTouchEnabled() || manager.IsMouseActive());
    }

    if (kAbility == none || kAbilityTarget == none)
    {
        SetIsAvailable(false);
        SetShotName("", "");
        kUnit.RemoveRangesOnSquad(kUnit.GetSquad());
        SetCriticalChance("", "");
    }
    else
    {
        SetIsAvailable(true);
        kAbilityTarget.GetShotSummary(kResult, kInfo);

        if (kTargetingAction != none && kTargetingAction.m_kShot != none)
        {
            if (kTargetingAction.m_kShot.ShouldShowCritPercentage())
            {
                SetCriticalChance(m_sCriticalLabel, string(Max(iCriticalChance, 0)) $ "%");
            }

            if (((iHitChance > -1) && kTargetingAction.m_kShot.ShouldShowPercentage()) && !kTargetingAction.m_kUnit.IsAbilityOnCooldown(kTargetingAction.m_kShot.iType))
            {
                if (kAbility.HasProperty(eProp_ScatterTarget))
                {
                    SetShotChance(m_sOverheatedHelp, (string(iHitChance / 10) $ ".") $ string(iHitChance % 10));
                }
                else
                {
                    SetShotChance(m_sShotChanceLabel, string(iHitChance) $ "%");
                }
            }
            else
            {
                SetShotChance("", "");
            }
        }
        else
        {
            SetShotChance("", "");
        }

        if (kTargetingAction != none && kTargetingAction.IsFreeAiming() && kTargetingAction.m_kShot.iType != eAbility_Launch && kTargetingAction.m_kShot.iType != eAbility_BullRush && kTargetingAction.m_kShot.iType != eAbility_Grapple)
        {
            SetShotName(m_sFreeAimingTitle $ ":" @ kAbility.GetName(), "");
        }
        else
        {
            SetShotName(kAbility.GetName(), "");
        }

        SetHelp(kAbility.GetHelpText());
        fHitChance = float(iHitChance) / float(100);

        if (kAbility.HasProperty(eProp_ScatterTarget))
        {
            fHitChance += float(1);
        }

        if (iHitChance > -1 && kTargetingAction != none && kTargetingAction.m_kShot.ShouldShowPercentage())
        {
            UITacticalHUD(screen).SetReticleAimPercentages(fHitChance, float(iCriticalChance) / float(100));
        }
        else
        {
            UITacticalHUD(screen).SetReticleAimPercentages(-1.0, -1.0);
        }

        if (!kUnit.GetPawn().RangeIndicator.HiddenGame)
        {
            kUnit.RemoveRanges();
        }

        switch (kAbilityTarget.GetType())
        {
            case eAbility_MedikitHeal:
                kUnit.DrawRangesForMedikit();
                break;
            case eAbility_Stabilize:
            case eAbility_Revive:
                kUnit.DrawRangesForRevive();
                break;
            case eAbility_RepairSHIV:
                kUnit.DrawRangesForRepairSHIV();
                break;
            case eAbility_ShotStun:
                kUnit.DrawRangesForShotStun();
                break;
            case eAbility_ShotDroneHack:
                kUnit.DrawRangesForDroneHack();
                break;
            case eAbility_MEC_KineticStrike:
                kUnit.DrawRangesForKineticStrike();
                break;
            case eAbility_MEC_Flamethrower:
                kUnit.DrawRangesForFlamethrower();
                break;
            case eAbility_ShotStandard:
                kUnit.DrawRangesForCloseAndPersonal();
                break;
            default:
                kUnit.RemoveRangesOnSquad(kUnit.GetSquad());
                kUnit.RemoveRangesOnSquad(`BATTLE.GetEnemyPlayer(kUnit.GetPlayer()).GetSquad());
                break;
        }

        kActiveUnit = XComTacticalController(controllerRef).GetActiveUnit();

        if (kTargetingAction != none && kTargetingAction.m_kShot != none)
        {
            kActiveWeapon = kTargetingAction.m_kShot.m_kWeapon;

            if (kActiveWeapon != none)
            {
                SetWeaponStats(`HL_TWEAPON_FROM_XG(kActiveWeapon).strName);
            }
        }
        else
        {
            kInventory = kActiveUnit.GetInventory();

            if (kInventory != none)
            {
                kActiveWeapon = kInventory.GetActiveWeapon();
                SetWeaponStats(`HL_TWEAPON_FROM_XG(kActiveWeapon).strName);
            }
        }

        if (!kAbilityTarget.IsRocketShot())
        {
            for (iTarget = 0; iTarget < 16; iTarget++)
            {
                if (kAbilityTarget.m_aTargets[iTarget].m_kTarget != none)
                {
                    arrTargets.AddItem(kAbilityTarget.m_aTargets[iTarget].m_kTarget);
                }
            }

            XComPresentationLayer(Owner.Owner).m_kUnitFlagManager.SetShotFlagInfo(arrTargets, kResult);
        }
    }

    if (bEnableTimer)
    {
        if (!IsTimerActive())
        {
            SetTimer(1.0, true);
        }
    }
    else
    {
        if (IsTimerActive())
        {
            ClearTimer();
        }
    }

    UpdateLayout();
}