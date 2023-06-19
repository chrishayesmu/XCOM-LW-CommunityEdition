class LWCE_UITacticalHUD_AbilityContainer extends UITacticalHUD_AbilityContainer;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen)
{
    local int I;
    local UITacticalHUD_AbilityItem kItem;

    PanelInit(_controller, _manager, _screen);

    for (I = 0; I < 30; I++)
    {
        kItem = new class'LWCE_UITacticalHUD_AbilityItem';
        kItem.m_kContainer = self;
        kItem.m_kMovieMgr = _manager;
        kItem.m_kController = _controller;
        m_arrUIAbilityData.AddItem(kItem);
    }
}

simulated function bool OnAccept(optional string strOption = "")
{
    local XGUnit kUnit;
    local XGAction_Targeting kTargetingAction;
    local LWCE_XGAbility kCEAbility;
    local XGAbility kAbility;
    local XGAbility_Targeted kTargetAbility;

    ResetMouse();

    if (m_iCurrentIndex != m_iSelectionOnButtonDown && !manager.IsMouseActive())
    {
        return false;
    }

    kAbility = GetSelectedAbility();
    kCEAbility = LWCE_XGAbility(kAbility);

    `LWCE_LOG_CLS("OnAccept: selected ability is " $ kAbility);

    if (kCEAbility == none)
    {
        return false;
    }

    if (kCEAbility.LWCE_CheckAvailable() != 'AA_Success')
    {
        `LWCE_LOG_CLS("Ability is not available: " $ kCEAbility.LWCE_CheckAvailable());

        PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
        return true;
    }

    kCEAbility.Activate();
    return true;

    kTargetAbility = XGAbility_Targeted(kAbility);

    if (!kAbility.CheckAvailable() && kTargetAbility != none && !kTargetAbility.CanFreeAim())
    {
        PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
        return true;
    }

    kUnit = XComTacticalController(controllerRef).GetActiveUnit();
    kTargetingAction = XGAction_Targeting(kUnit.GetAction());

    if (!`BATTLE.IsTurnTimerCloseToExpiring())
    {
        if (kTargetAbility != none)
        {
            if (m_iUseOnlyAbility != -1 && m_iUseOnlyAbility != m_iCurrentIndex)
            {
                PlaySound(`SoundCue("SoundUI.NegativeSelection2Cue"), true);
                return true;
            }

            if (!kTargetingAction.CanBePerformed())
            {
                return true;
            }

            if (kTargetingAction.m_iSplashHitsFriendlyDestructibleCache > 0 && !kTargetingAction.m_bPleaseHitFriendlies)
            {
                HitFriendlyObjectDialogue();
                return true;
            }

            if (kTargetingAction.m_iSplashHitsFriendliesCache > 0 && !kTargetingAction.m_bPleaseHitFriendlies)
            {
                // 119 is Psychokinetic Strike, was SHIV Suppression in vanilla; not sure what it's doing here
                if (!kUnit.GetCharacter().HasUpgrade(119) && kAbility.GetType() != eAbility_MindMerge)
                {
                    HitFriendliesDialogue();
                    return true;
                }
            }

            if (!kTargetingAction.FireShot(kTargetAbility))
            {
                return true;
            }

            m_iUseOnlyAbility = -1;

            if (GetSelectedAbility().GetType() == eAbility_TakeCover || GetSelectedAbility().GetType() == eAbility_CivilianCover)
            {
                PlaySound(`SoundCue("SoundUI.HunkerDownCue"), true);
            }
        }
        else
        {
            m_arrAbilities[m_iCurrentIndex].ServerExecute();
            kTargetingAction.m_bSetShotDisabled = true;
        }
    }

    if (XComPresentationLayer(Owner.Owner).GetStateName() == 'State_EnemyArrows')
    {
        XComPresentationLayer(Owner.Owner).PopState();
    }

    if (XComPresentationLayer(Owner.Owner).GetStateName() == 'State_AbilityMenu')
    {
        XComPresentationLayer(Owner.Owner).PopState();
    }

    return true;
}