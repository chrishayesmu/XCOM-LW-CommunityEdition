class LWCE_UITacticalHUD_AbilityContainer extends UITacticalHUD_AbilityContainer;

var private LWCETargetingMethod m_kTargetingMethod;

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

function CancelTargeting()
{
    local LWCETargetingMethod kTargetingMethod;

    `LWCE_LOG_CLS("CancelTargeting");

    kTargetingMethod = m_kTargetingMethod;
    m_kTargetingMethod = none;

    if (kTargetingMethod != none)
    {
        kTargetingMethod.Canceled();
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

    `LWCE_LOG_CLS("OnAccept: selected ability is " $ kCEAbility);

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

simulated function bool OnUnrealCommand(int ucmd, int Arg)
{
    local bool bHandled;
    local int iUIAbilityIndex;

    bHandled = true;

    if ((Arg & class'UI_FxsInput'.const.FXS_ACTION_RELEASE) == 0)
    {
        return false;
    }

    if (`BATTLE != none && `BATTLE.ProfileSettingsActivateMouse())
    {
        switch (ucmd)
        {
            case class'UI_FxsInput'.const.FXS_DPAD_UP:
            case class'UI_FxsInput'.const.FXS_DPAD_DOWN:
            case class'UI_FxsInput'.const.FXS_DPAD_LEFT:
            case class'UI_FxsInput'.const.FXS_DPAD_RIGHT:
                return false;
        }
    }

    switch (ucmd)
    {
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_X:
        case class'UI_FxsInput'.const.FXS_L_MOUSE_UP:
        case class'UI_FxsInput'.const.FXS_KEY_ENTER:
        case class'UI_FxsInput'.const.FXS_KEY_SPACEBAR:
            if (UITacticalHUD(Owner).IsMenuRaised())
            {
                OnAccept("");
            }
            else
            {
                bHandled = false;
            }

            break;
        case class'UI_FxsInput'.const.FXS_DPAD_LEFT:
        case class'UI_FxsInput'.const.FXS_ARROW_LEFT:
            if (UITacticalHUD(Owner).IsMenuRaised())
            {
                CycleAbilitySelection(-1);
            }
            else
            {
                bHandled = false;
            }

            break;
        case class'UI_FxsInput'.const.FXS_DPAD_RIGHT:
        case class'UI_FxsInput'.const.FXS_ARROW_RIGHT:
            if (UITacticalHUD(Owner).IsMenuRaised())
            {
                CycleAbilitySelection(1);
            }
            else
            {
                bHandled = false;
            }

            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_LBUMPER:
        case class'UI_FxsInput'.const.FXS_KEY_LEFT_SHIFT:
        case class'UI_FxsInput'.const.FXS_MOUSE_4:
        case class'UI_FxsInput'.const.FXS_KEY_Q:
            bHandled = SelectPreviousTarget();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_RBUMPER:
        case class'UI_FxsInput'.const.FXS_KEY_TAB:
        case class'UI_FxsInput'.const.FXS_MOUSE_5:
        case class'UI_FxsInput'.const.FXS_KEY_E:
            bHandled = SelectNextTarget();
            break;
        case class'UI_FxsInput'.const.FXS_BUTTON_PS3_SQUARE:
        case class'UI_FxsInput'.const.FXS_KEY_X:
            if (UITacticalHUD(Owner).IsMenuRaised())
            {
                OnCycleWeapons();
            }
            else
            {
                bHandled = false;
            }

            break;
        case class'UI_FxsInput'.const.FXS_KEY_1:
            LWCE_DirectPickAbility(0);
            break;
        case class'UI_FxsInput'.const.FXS_KEY_2:
            LWCE_DirectPickAbility(1);
            break;
        case class'UI_FxsInput'.const.FXS_KEY_3:
            LWCE_DirectPickAbility(2);
            break;
        case class'UI_FxsInput'.const.FXS_KEY_4:
            LWCE_DirectPickAbility(3);
            break;
        case class'UI_FxsInput'.const.FXS_KEY_5:
            LWCE_DirectPickAbility(4);
            break;
        case class'UI_FxsInput'.const.FXS_KEY_6:
            LWCE_DirectPickAbility(5);
            break;
        case class'UI_FxsInput'.const.FXS_KEY_7:
            LWCE_DirectPickAbility(6);
            break;
        case class'UI_FxsInput'.const.FXS_KEY_8:
            LWCE_DirectPickAbility(7);
            break;
        case class'UI_FxsInput'.const.FXS_KEY_9:
            LWCE_DirectPickAbility(8);
            break;
        case class'UI_FxsInput'.const.FXS_KEY:
            LWCE_DirectPickAbility(9);
            break;
        case class'UI_FxsInput'.const.FXS_KEY_K:
            if (UITacticalHUD(Owner).IsMenuRaised())
            {
                iUIAbilityIndex = FindAbilityByType(eAbility_TakeCover);

                if (iUIAbilityIndex > -1)
                {
                    LWCE_DirectPickAbility(iUIAbilityIndex);
                    PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
                }
            }
            else
            {
                bHandled = false;
            }

            break;
        default:
            bHandled = false;
            break;
    }

    return bHandled;
}

simulated function SetAbilityByIndex(int Index)
{
    local XGUnit kUnit;
    local LWCE_XGAbility kAbility;
    local ASValue myValue;
    local array<ASValue> myArray;

    if (Index < 0 || Index >= m_arrAbilities.Length || Index == m_iCurrentIndex)
    {
        return;
    }

    m_iCurrentIndex = Index;
    kUnit = XComTacticalController(controllerRef).GetActiveUnit();
    kAbility = LWCE_XGAbility(m_arrAbilities[Index]);

    if (m_kTargetingMethod != none)
    {
        m_kTargetingMethod.Canceled();
        m_kTargetingMethod = none;
    }

    m_kTargetingMethod = new kAbility.m_kTemplate.TargetingMethod;
    m_kTargetingMethod.Init(kAbility, 0); // TODO maybe not target index 0 if picking up from another ability with the same targeting method?

    myValue.Type = AS_String;
    myValue.S = string(m_iCurrentIndex);
    myArray.AddItem(myValue);
    Invoke("setFocus", myArray);

    UITacticalHUD(screen).m_kInfoBox.Update(kUnit, kAbility);
}

function bool SelectNextTarget()
{
    if (m_kTargetingMethod != none)
    {
        m_kTargetingMethod.NextTarget();
        return true;
    }

    return false;
}

function bool SelectPreviousTarget()
{
    if (m_kTargetingMethod != none)
    {
        m_kTargetingMethod.PreviousTarget();
        return true;
    }

    return false;
}

private function LWCE_DirectPickAbility(int Index)
{
    if (Index >= m_arrAbilities.Length)
    {
        PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
        return;
    }

    if (m_iMouseTargetedAbilityIndex != Index)
    {
        m_iMouseTargetedAbilityIndex = Index;

        SelectAbility(m_iMouseTargetedAbilityIndex);

        // TODO: see XComTacticalController.PerformRaisingTargetWithFireAction for logic about not activating while units move, etc

        PlaySound(`SoundCue("SoundUI.MenuSelectCue"), true);
    }
    else
    {
        OnAccept();
    }
}