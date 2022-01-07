class Highlander_XComTacticalInput extends XComTacticalInput;

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
}