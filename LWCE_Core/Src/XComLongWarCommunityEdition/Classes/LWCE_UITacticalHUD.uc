class LWCE_UITacticalHUD extends UITacticalHUD;

simulated function Init(XComTacticalController _controllerRef, UIFxsMovie _manager)
{
    BaseInit(_controllerRef, _manager);

    m_kInfoBox = Spawn(class'LWCE_UITacticalHUD_InfoPanel', self);
    m_kInfoBox.Init(controllerRef, manager, self);

    m_kAbilityHUD = Spawn(class'LWCE_UITacticalHUD_AbilityContainer', self);
    m_kAbilityHUD.s_name = 'theRightHUD';
    m_kAbilityHUD.Init(controllerRef, manager, self);

    m_kWeaponContainer = Spawn(class'LWCE_UITacticalHUD_WeaponContainer', self);
    m_kWeaponContainer.Init(_controllerRef, _manager, self);

    m_kStatsContainer = Spawn(class'UITacticalHUD_SoldierStatsContainer', self);
    m_kStatsContainer.Init(_controllerRef, _manager, self);

    m_kRadar = Spawn(class'LWCE_UITacticalHUD_Radar', self);
    m_kRadar.Init(_controllerRef, _manager, self);

    m_kObjectives = Spawn(class'UITacticalHUD_ObjectivesList', self);
    m_kObjectives.Init(_controllerRef, _manager, self);

    m_kPerks = Spawn(class'LWCE_UITacticalHUD_PerkContainer', self);
    m_kPerks.Init(_controllerRef, _manager, self);
}

simulated function CancelTargetingAction()
{
    `LWCE_LOG_CLS("CancelTargetingAction");
    LWCE_UITacticalHUD_AbilityContainer(m_kAbilityHUD).CancelTargeting();
}

simulated function OnFreeAimChange()
{
    ClearReticles();
    LWCE_CreateReticles(XGAbility_Targeted(m_kAbilityHUD.GetSelectedAbility()));
    m_kInfoBox.OnFreeAimChange();
    XComPresentationLayer(controllerRef.m_Pres).m_kSightlineHUD.RefreshSelectedEnemy();
}

simulated function bool OnUnrealCommand(int Cmd, int Arg)
{
    local bool bHandled;

    `LWCE_LOG_CLS("OnUnrealCommand, Cmd = " $ Cmd $ ", Arg = " $ Arg);

    if ((Arg & class'UI_FxsInput'.const.FXS_ACTION_PRESS) != 0)
    {
        m_kAbilityHUD.SetSelectionOnInputPress(Cmd);
    }

    if ((Arg & class'UI_FxsInput'.const.FXS_ACTION_RELEASE) == 0)
    {
        return false;
    }

    if (Cmd == class'UI_FxsInput'.const.FXS_BUTTON_L3 || Cmd == class'UI_FxsInput'.const.FXS_KEY_F1)
    {
        OpenGermanMode();
        return true;
    }

    bHandled = m_kAbilityHUD.OnUnrealCommand(Cmd, Arg);

    if (!m_isMenuRaised)
    {
        return bHandled;
    }

    if (!bHandled)
    {
        bHandled = m_kInfoBox.OnUnrealCommand(Cmd, Arg);
    }

    if (!bHandled)
    {
        switch (Cmd)
        {
            // Cases for changing current target are removed; now handled by LWCE_UITacticalHUD_AbilityContainer
            case class'UI_FxsInput'.const.FXS_BUTTON_LTRIGGER:
            case class'UI_FxsInput'.const.FXS_KEY_O:
                if (m_kAbilityHUD.GetSelectedAbility().IsOverheadCamera())
                {
                    bHandled = true;
                }
                else
                {
                    bHandled = false;
                }

                if (m_isMenuRaised && !bHandled)
                {
                    SetForceOverheadView();
                    bHandled = true;
                }

                break;
            case class'UI_FxsInput'.const.FXS_BUTTON_RTRIGGER:
            case class'UI_FxsInput'.const.FXS_KEY_ESCAPE:
            case class'UI_FxsInput'.const.FXS_R_MOUSE_DOWN:
                CancelTargetingAction();
                bHandled = true;
                break;
            case class'UI_FxsInput'.const.FXS_BUTTON_START:
                CancelTargetingAction();
                controllerRef.m_Pres.UIPauseMenu(`BATTLE.m_kDesc.m_bIsIronman);
                bHandled = true;
                break;
            default:
                bHandled = false;
                break;
        }
    }

    return bHandled;
}

simulated function RaiseTargetSystem()
{
    local XGUnit kUnit, kTarget;

    kUnit = XComTacticalController(controllerRef).GetActiveUnit();

    if (kUnit == none)
    {
        return;
    }

    m_bForceOverheadView = false;
    m_isMenuRaised = true;
    XComTacticalController(controllerRef).m_bInputInShotHUD = true;
    UpdateAbilityMenu(kUnit);
    controllerRef.m_Pres.PushState('State_EnemyArrows');

    if (m_kRadar != none)
    {
        m_kRadar.Hide();
    }

    if (m_kMouseControls != none)
    {
        m_kMouseControls.UpdateControls();
    }

    XComPresentationLayer(controllerRef.m_Pres).m_kSightlineHUD.RefreshSelectedEnemy();
}

simulated function RealizeTargettingReticules(out XGUnit kUnit)
{
    local XGAbility kDisplayedAbility;
    local bool isDefensiveMode;

    kDisplayedAbility = m_kAbilityHUD.GetDisplayedAbility();
    isDefensiveMode = LWCE_XGAbility(kDisplayedAbility) == none && kDisplayedAbility.GetCategory() != eAbilityType_Offensive && kDisplayedAbility.iType != eAbility_Overwatch;

    if (isDefensiveMode)
    {
        Invoke("ShowDefenseReticule");
    }
    else if (kDisplayedAbility == none || LWCE_XGAbility(kDisplayedAbility) != none || kDisplayedAbility.IsOverheadCamera() || m_bForceOverheadView)
    {
        Invoke("ShowOffenseReticule");
    }
    else
    {
        Invoke("ShowOvershoulderReticule");
    }

    ClearReticles();
    LWCE_CreateReticles(XGAbility_Targeted(m_kAbilityHUD.GetSelectedAbility()));
    XComPresentationLayer(Owner).m_kUnitFlagManager.RealizeTargetedStates();
}

protected function LWCE_CreateReticles(XGAbility_Targeted kAbility)
{
    local int iUnit;
    local ASValue myValue;
    local array<ASValue> myArray;
    local UITargetingReticle kReticle;
    local LWCE_XGAbility kCEAbility;

    if (kAbility.IsA('XGAbility_Grapple'))
    {
        return;
    }

    kCEAbility = LWCE_XGAbility(kAbility);

    if (kCEAbility != none)
    {
        for (iUnit = 0; iUnit < kAbility.GetNumTargets(); iUnit++)
        {
            if (kCEAbility.arrTargetOptions[iUnit].kTarget.kPrimaryTarget != none)
            {
                kReticle = Spawn(class'LWCE_UITargetingReticle', self);
                kReticle.Init(controllerRef, manager, self, iUnit, kCEAbility.arrTargetOptions[iUnit].kTarget.kPrimaryTarget);
                m_arrReticles.AddItem(kReticle);

                `LWCE_LOG_CLS("Reticle " $ iUnit $ " is pointed at unit " $ kCEAbility.arrTargetOptions[iUnit].kTarget.kPrimaryTarget);

                myValue.Type = AS_String;
                myValue.S = string(kReticle.s_name);
                myArray.AddItem(myValue);

                Invoke("AddReticle", myArray);
            }
        }
    }
    else if (kAbility.IsFreeAiming())
    {
        kReticle = Spawn(class'LWCE_UITargetingReticle', self);
        kReticle.Init(controllerRef, manager, self, 0, none);
        m_arrReticles.AddItem(kReticle);

        myValue.Type = AS_String;
        myValue.S = string(kReticle.s_name);
        myArray.AddItem(myValue);

        Invoke("AddReticle", myArray);
    }
    else
    {
        for (iUnit = 0; iUnit < EXGAbilityNumTargets_MAX; iUnit++)
        {
            if (kAbility.m_aTargets[iUnit].m_kTarget != none || iUnit == 0)
            {
                kReticle = Spawn(class'LWCE_UITargetingReticle', self);
                kReticle.Init(controllerRef, manager, self, iUnit, kAbility.m_aTargets[iUnit].m_kTarget);
                m_arrReticles.AddItem(kReticle);

                myValue.Type = AS_String;
                myValue.S = string(kReticle.s_name);
                myArray.AddItem(myValue);

                Invoke("AddReticle", myArray);
            }
            else
            {
                break;
            }
        }
    }
}