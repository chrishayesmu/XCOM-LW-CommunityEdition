class Highlander_XComTacticalInput extends XComTacticalInput;

simulated function bool ClickInterativeLevelActor(IMouseInteractionInterface MouseTarget)
{
    local XGUnit kActiveUnit;
    local XComInteractiveLevelActor kInteractiveLevelActor;

    kInteractiveLevelActor = XComInteractiveLevelActor(MouseTarget);
    `HL_LOG_CLS("ClickInterativeLevelActor: MouseTarget = " $ MouseTarget);

    if (kInteractiveLevelActor == none)
    {
        `HL_LOG_CLS("ClickInterativeLevelActor: no actor found, checking for fallback");

        if (XComMeldContainerActor(MouseTarget) != none)
        {
            // TODO: this fallback doesn't work, it seems like clicks go right through the Meld to the floor
            kInteractiveLevelActor = XComMeldContainerActor(MouseTarget).m_kInteractiveLevelActor;
        }

        if (kInteractiveLevelActor == none)
        {
            `HL_LOG_CLS("ClickInterativeLevelActor: still no actor found, returning");
            return false;
        }
    }

    kActiveUnit = GetActiveUnit();

    if (kActiveUnit == none)
    {
        `HL_LOG_CLS("ClickInterativeLevelActor: no active unit found");
        return false;
    }

    `HL_LOG_CLS("Performing interact");
    kActiveUnit.PerformInteract(kInteractiveLevelActor);
    return true;
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
                    // Highlander issue #11: for some reason this code path moved the active unit, even though that's not something
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

    function bool LMouse(int Actionmask)
    {
        local XGAction_Path kPathAction;
        local IMouseInteractionInterface MouseTarget;
        local XComUnitPawnNativeBase kPawn;
        local XGUnit kTargetedUnit;
        local bool bHandled;
        local XCom3DCursor CURSOR;

        bHandled = false;

        if (TestMouseConsumedByFlash())
        {
            CancelMousePathing();
            return false;
        }

        if ((Actionmask & class'UI_FxsInput'.const.FXS_ACTION_PRESS) != 0)
        {
            if (UseTouchInput())
            {
                m_fTouchDownTimer = 0.0;
                mCameraLocked = false;
                mDraggingCursor = false;
                mPressState = 1;
                mReleaseState = 0;
                MouseTarget = GetMouseInterfaceTarget();
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

                if (GetActiveUnit() == kTargetedUnit)
                {
                    CURSOR = XComTacticalController(Outer).GetCursor();

                    if (CURSOR != none)
                    {
                        mPrevioursLocation = SnapToGrid(kTargetedUnit.Location, mPrevioursTile);
                        mPathingState = 2;
                        mDraggingCursor = true;
                        mCameraLocked = true;
                    }
                }
            }
        }
        else if ((Actionmask & class'UI_FxsInput'.const.FXS_ACTION_RELEASE) != 0)
        {
            mCameraLocked = false;
            mDraggingCursor = false;
            mPressState = 0;
            mReleaseState = 1;
            m_fRightMouseHoldTime = 0.0;

            if (XComTacticalController(Outer).m_XGPlayer.IsInState('Active') && !UseTouchInput() || !XComTacticalTouchHandler(mTouchHandler).mMultipleTouches)
            {
                MouseTarget = GetMouseInterfaceTarget();

                if (NotEqual_InterfaceInterface(MouseTarget, none))
                {
                    bHandled = ClickSoldier(MouseTarget);

                    if (!bHandled)
                    {
                        bHandled = ClickUnitToTarget(MouseTarget);
                    }

                    if (!bHandled)
                    {
                        if (UseTouchInput())
                        {
                            MouseTarget = GetMouseInteractionTarget();

                            if (NotEqual_InterfaceInterface(MouseTarget, none))
                            {
                                bHandled = ClickInterativeLevelActor(MouseTarget);
                            }
                        }
                        else
                        {
                            bHandled = ClickInterativeLevelActor(MouseTarget);
                        }
                    }

                    if (!bHandled)
                    {
                        if (UseTouchInput())
                        {
                            bHandled = XComTacticalController(Outer).PerformAction();
                        }
                        else
                        {
                            kPathAction = XGAction_Path(GetActiveUnit().GetAction());

                            if (kPathAction != none && kPathAction.IsEmpty())
                            {
                                `BATTLE.InvalidPathSelection(GetActiveUnit());
                            }

                            // Highlander issue #21
                            //bHandled = XComTacticalController(Outer).PerformAction();
                        }
                    }
                }
            }
        }

        return bHandled;
    }
}