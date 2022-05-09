class LWCE_XComTacticalInput extends XComTacticalInput;

function InitInputSystem()
{
    super.InitInputSystem();

    class'LWCE_UIKeybindingsPCScreen'.static.ApplyCustomKeybinds(self);
}

simulated function CancelMousePathing(optional bool bClearPathData = true)
{
    local XGAction_Path kPathAction;
    local XComPresentationLayer kPres;

    if (!UseTouchInput() && !XComTacticalController(Outer).IsMouseActive())
    {
        return;
    }

    m_fRightMouseHoldTime = 0.0;

    if (bClearPathData && GetActiveUnit() != none)
    {
        kPathAction = XGAction_Path(GetActiveUnit().GetAction());

        if (kPathAction != none)
        {
            kPathAction.m_bDoPathingTick = false;
            kPathAction.ClearPath();
            XComTacticalController(Outer).GetCursor().MoveToUnit(GetActiveUnit().GetPawn(), true);
        }
    }

    kPres = XComPresentationLayer(XComTacticalController(Outer).m_Pres);

    if (kPres != none)
    {
        kPres.GetActionIconMgr().ClearCoverIcons();
    }
}

state ActiveUnit_Firing
{
    ignores CancelFiring;

    event BeginState(name PrevStateName)
    {
        super.BeginState(PrevStateName);
    }

    event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
    }

    function bool RMouse(int Actionmask)
    {
        local UITacticalHUD kHUD;

        if ((Actionmask & class'UI_FxsInput'.const.FXS_ACTION_RELEASE) != 0)
        {
            kHUD = XComPresentationLayer(XComTacticalController(Outer).m_Pres).GetTacticalHUD();
            kHUD.CancelTargetingAction();
            return true;
        }

        // LWCE: the superclass function is missing a return; this is just to get rid of some error logging
        return false;
    }
}

state ActiveUnit_Moving
{
    function bool ClickSoldier(IMouseInteractionInterface MouseTarget)
    {
        local XComUnitPawnNativeBase kPawn;
        local XGUnit kTargetedUnit;
        local XGAction_Path kPathAction;
        local bool bChangeUnitSuccess, bHandled;

        kPawn = XComUnitPawnNativeBase(MouseTarget);

        if (kPawn == none)
        {
            return false;
        }

        kTargetedUnit = XGUnit(kPawn.GetGameUnit());

        if (kTargetedUnit == none)
        {
            return false;
        }

        bChangeUnitSuccess = false;
        bHandled = false;

        if (XComTacticalController(Outer).m_XGPlayer.m_eTeam == kTargetedUnit.m_eTeam)
        {
            if (GetActiveUnit() != kTargetedUnit)
            {
                if (!m_bLockUnitSelection)
                {
                    kTargetedUnit.m_bClickActivated = true;
                    bChangeUnitSuccess = XComTacticalController(Outer).m_XGPlayer.NextPreviousUnit(true,, kTargetedUnit);

                    if (!bChangeUnitSuccess)
                    {
                        kTargetedUnit.m_bClickActivated = false;
                    }

                    bHandled = bChangeUnitSuccess;
                }
                else
                {
                    Outer.PlaySound(`SoundCue("SoundUI.MenuCancelCue"), true);
                    bHandled = true;
                }
            }
            else
            {
                if (UseTouchInput())
                {
                    CancelMousePathing();
                }
                else
                {
                    // LWCE issue #11: for some reason this code path moved the active unit, even though that's not something
                    // the left mouse should ever do. It's hard to trigger without very quickly moving the mouse between an active
                    // unit and a pathable space, but still comes up occasionally.
                    //ClickToPath();
                }

                bHandled = true;
            }

            if (Outer.WorldInfo.NetMode != NM_Standalone && bChangeUnitSuccess)
            {
                kPathAction = XGAction_Path(GetActiveUnit().GetAction());

                if (kPathAction != none)
                {
                    mPathingState = 0;
                    kPathAction.m_bDoPathingTick = false;
                    kPathAction.ClearPath();
                }
            }
        }

        return bHandled;
    }
}