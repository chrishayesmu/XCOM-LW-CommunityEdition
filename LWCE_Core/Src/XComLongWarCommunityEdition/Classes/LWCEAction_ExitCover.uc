class LWCEAction_ExitCover extends LWCEAction;

var LWCE_XGUnit m_kTargetUnit;
var LWCE_XGUnit Unit;
var LWCE_XGAbility m_kAbility;
var XComUnitPawn UnitPawn;
var LWCE_TAbilityInputContext m_kInputContext;

var protected Vector m_vTarget;

var private bool bWaitForAnim;
var private bool bAimOffsetSet;
var private bool bGlamCamAttempted;
var private bool bGlamCamActivated;
var private int UseCoverDirectionIndex;
var private UnitPeekSide UsePeekSide;
var private int bCanSeeFromDefault;
var private XComAnimNodeCover UseCoverNode;
var private XComAnimNodeBlendByExitCoverType UseExitCoverNode;
var private AnimNodeSequence FinishAnimNodeSequence;
var privatewrite XComDestructibleActor WindowToBreak;
var private XComWeapon ShotWeapon;
var private float StartGlamCamTime;
var private InventoryOperation TempInvOperation;

function ForAbilityContext(const out LWCE_TAbilityInputContext kInputContext, const out LWCE_TAbilityResult kResult)
{
    m_kInputContext = kInputContext;
    m_kAbility = kInputContext.Ability;
    Unit = LWCE_XGUnit(kInputContext.Source);
    m_kTargetUnit = LWCE_XGUnit(kInputContext.PrimaryTarget);

    if (Unit != none)
    {
        UnitPawn = Unit.GetPawn();
    }
}

function bool NeedToChangeWeapons()
{
    if (m_kInputContext.Weapon != Unit.GetInventory().GetActiveWeapon())
    {
        Unit.m_eEquipSlot = m_kInputContext.Weapon.m_eSlot;
        return true;
    }

    return false;
}

state Executing
{
    simulated function SetUsedAnimNodes(float BlendTime)
    {
        UseCoverNode = XComAnimNodeCover(UnitPawn.ActionNode.Children[UnitPawn.ActionNode.ActiveChildIndex].Anim);

        if (UseCoverNode == none)
        {
            return;
        }

        if (Unit.bNeedsLowCoverStepOut)
        {
            if (Unit.m_eCoverState == eCS_LowLeft)
            {
                UseCoverNode.SetActiveChild(eAnimCover_HighLeft, BlendTime);
            }
            else if (Unit.m_eCoverState == eCS_LowRight)
            {
                UseCoverNode.SetActiveChild(eAnimCover_HighRight, BlendTime);
            }
        }

        UseExitCoverNode = XComAnimNodeBlendByExitCoverType(UseCoverNode.Children[UseCoverNode.ActiveChildIndex].Anim);

        if (UseExitCoverNode == none)
        {
            return;
        }
    }

    function bool UnitFacingMatchesDesiredDirection()
    {
        local Vector CurrentFacing, DesiredFacing;
        local float Dot;

        CurrentFacing = vector(Unit.Rotation);
        DesiredFacing = Normal(m_vTarget - UnitPawn.Location);
        Dot = NoZDot(CurrentFacing, DesiredFacing);
        return Dot > 0.70;
    }

    simulated event Tick(float DeltaT)
    {
        local XComUnitPawn TargetPawn;

        super.Tick(DeltaT);

        if (bAimOffsetSet)
        {
            if (FinishAnimNodeSequence.AnimSeq != none && FinishAnimNodeSequence.bPlaying && FinishAnimNodeSequence.CurrentTime > (FinishAnimNodeSequence.AnimSeq.SequenceLength * 0.50))
            {
                TargetPawn = m_kTargetUnit != none ? m_kTargetUnit.GetPawn() : none;

                if (TargetPawn != none && TargetPawn != UnitPawn)
                {
                    UnitPawn.SmoothAimAtTarget(DeltaT, m_vTarget + ((UnitPawn.TargetLoc - m_vTarget) * UnitPawn.AimAtTargetMissPercent), false);
                }
                else
                {
                    UnitPawn.SmoothAimAtTarget(DeltaT, m_vTarget, false);
                }
            }
        }

        if (!bGlamCamAttempted && StartGlamCamTime > 0.0 && FinishAnimNodeSequence.CurrentTime > StartGlamCamTime)
        {
            // TODO: GlamCam won't work without an XGAction
            bGlamCamAttempted = true;
            bGlamCamActivated = `BATTLE.m_kGlamMgr.TryGlamCam(none, true);
        }
    }

Begin:
    StartGlamCamTime = -1.0;

    Unit.IdleStateMachine.CheckForStanceUpdate();

    while (Unit.IdleStateMachine.IsEvaluatingStance())
    {
        Sleep(0.0);
    }

    if (!Unit.IdleStateMachine.IsDormant())
    {
        Unit.IdleStateMachine.GoDormant();
    }

    UnitPawn.EnableLeftHandIK(m_kAbility.m_kTemplate.UseLeftHandIK());

    // TODO: XGAction_ExitCover ends One For All here; use interrupts to do the same in LWCE

    Unit.RestoreLocation = UnitPawn.Location;
    Unit.LastCoverTypeUsed = Unit.GetExitCoverType(m_kTargetUnit, m_vTarget, UseCoverDirectionIndex, UsePeekSide, bCanSeeFromDefault);
    Unit.LastCoverState = Unit.m_eCoverState;
    WindowToBreak = Unit.ShouldBreakWindowBeforeFiring(m_kTargetUnit != none ? m_kTargetUnit.Location : m_vTarget, UseCoverDirectionIndex, UsePeekSide);

    if (WindowToBreak != none)
    {
        if (UnitPawn.MovementNode.ActiveChildIndex != eMoveType_Action)
        {
            UnitPawn.MovementNode.SetActiveChild(eMoveType_Action, 0.10);
        }

        if (Unit.CanUseCover())
        {
            UnitPawn.ActionNode.SetActiveChild(eAnimAction_BreakWindow, 0.10);
            FinishAnimNodeSequence = UnitPawn.ActionNode.GetTerminalSequence();
            FinishAnim(FinishAnimNodeSequence);
        }
        else
        {
            UnitPawn.BreakWindow();
        }
    }

    UnitPawn.SetSuppressionNodes(false, Unit.IdleStateMachine.BlendTime);
    UnitPawn.SetWeaponDownNodes(false, Unit.IdleStateMachine.BlendTime);

    if (Unit.LastCoverTypeUsed != eECTTU_UseTurnNode)
    {
        UnitPawn.EnableRMAInteractPhysics(true);
        UnitPawn.EnableRMA(true, true);
        UnitPawn.bSkipRotateToward = true;

        if (Unit.bNeedsLowCoverStepOut)
        {
            if (UnitPawn.MovementNode.ActiveChildIndex != eMoveType_Action)
            {
                UnitPawn.MovementNode.SetActiveChild(eMoveType_Action, Unit.IdleStateMachine.BlendTime);
            }

            if (UnitPawn.ActionNode.ActiveChildIndex != eAnimAction_Idle)
            {
                UnitPawn.ActionNode.SetActiveChild(eAnimAction_Idle, Unit.IdleStateMachine.BlendTime);
            }

            if (UnitPawn.IdleNode.ActiveChildIndex != eAnimIdle_Idle)
            {
                UnitPawn.IdleNode.SetActiveChild(eAnimIdle_Idle, Unit.IdleStateMachine.BlendTime);
            }

            UseCoverNode = XComAnimNodeCover(UnitPawn.IdleNode.Children[eAnimIdle_Idle].Anim);

            if (Unit.m_eCoverState == eCS_LowLeft)
            {
                UseCoverNode.SetActiveChild(eAnimCover_HighLeft, Unit.IdleStateMachine.BlendTime);
            }
            else if (Unit.m_eCoverState == eCS_LowRight)
            {
                UseCoverNode.SetActiveChild(eAnimCover_HighRight, Unit.IdleStateMachine.BlendTime);
            }

            Sleep(Unit.IdleStateMachine.BlendTime);
        }

        Unit.DisableMirroring();
        UnitPawn.MovementNode.SetActiveChild(eMoveType_Anim, 0.0);

        switch (Unit.m_eCoverState)
        {
            case eCS_HighRight:
                UnitPawn.MovementNode.SetAnimEnd(eAnim_Running2CoverLeftHighStop, RBA_Translate, RBA_Translate);
                break;
            case eCS_HighLeft:
                UnitPawn.MovementNode.SetAnimEnd(eAnim_Running2CoverRightHighStop, RBA_Translate, RBA_Translate);
                break;
            case eCS_LowRight:
                if (Unit.bNeedsLowCoverStepOut)
                {
                    UnitPawn.MovementNode.SetAnimEnd(eAnim_Running2CoverLeftHighStop, RBA_Translate, RBA_Translate);
                }
                else
                {
                    UnitPawn.MovementNode.SetAnimEnd(eAnim_Running2CoverLeftLowStop, RBA_Translate, RBA_Translate);
                }

                break;
            case eCS_LowLeft:
                if (Unit.bNeedsLowCoverStepOut)
                {
                    UnitPawn.MovementNode.SetAnimEnd(eAnim_Running2CoverRightHighStop, RBA_Translate, RBA_Translate);
                }
                else
                {
                    UnitPawn.MovementNode.SetAnimEnd(eAnim_Running2CoverRightLowStop, RBA_Translate, RBA_Translate);
                }

                break;
            default:
                if (UnitPawn.MovementNode.ActiveChildIndex != eMoveType_Action)
                {
                    UnitPawn.MovementNode.SetActiveChild(eMoveType_Action, Unit.IdleStateMachine.BlendTime);
                }

                break;
            }
    }

    if (Unit.m_eCoverState != eCS_None)
    {
        Unit.IdleStateMachine.ExitFromCover((m_kTargetUnit != none ? m_kTargetUnit.Location : m_vTarget) - UnitPawn.Location);

        while (Unit.IdleStateMachine.IsEvaluatingStance())
        {
            Sleep(0.0);
        }
    }

    UnitPawn.EnableRMAInteractPhysics(true);
    UnitPawn.EnableRMA(true, true);
    UnitPawn.bSkipRotateToward = true;

    if (UnitPawn.MovementNode.ActiveChildIndex != eMoveType_Stationary)
    {
        UnitPawn.MovementNode.SetActiveChild(eMoveType_Stationary, Unit.IdleStateMachine.BlendTime);
    }

    bWaitForAnim = false;
    Unit.bChangedWeapon = false;

    if (NeedToChangeWeapons())
    {
        Unit.InventoryOperations.Length = 0;
        TempInvOperation.Item = Unit.GetInventory().GetActiveWeapon();
        TempInvOperation.LocationFrom = Unit.GetInventory().GetActiveWeapon().m_eSlot;
        TempInvOperation.LocationTo = eSlot_RightSling;
        TempInvOperation.bUpdateGameInventory = true;
        Unit.PerformInventoryOperation(eAnimAction_Unequip, Unit.IdleStateMachine.BlendTime, TempInvOperation, true);

        if (Unit.m_eCoverState != eCS_None)
        {
            SetUsedAnimNodes(Unit.IdleStateMachine.BlendTime);

            if (Unit.LastCoverTypeUsed == eECTTU_UseTurnNode)
            {
                UseExitCoverNode.SetActiveChild(eECTTU_Zero, Unit.IdleStateMachine.BlendTime);
            }
            else
            {
                UseExitCoverNode.SetActiveChild(Unit.LastCoverTypeUsed, Unit.IdleStateMachine.BlendTime);
            }
        }

        FinishAnimNodeSequence = UnitPawn.ActionNode.GetTerminalSequence();
        Sleep(Unit.IdleStateMachine.BlendTime);
        FinishAnim(FinishAnimNodeSequence, true);

        TempInvOperation.Item = m_kInputContext.Weapon;
        TempInvOperation.LocationFrom = m_kInputContext.Weapon.m_eSlot;
        TempInvOperation.LocationTo = m_kInputContext.Weapon.m_eEquipLocation;
        TempInvOperation.bUpdateGameInventory = true;
        Unit.PerformInventoryOperation(eAnimaction_EquipNew, 0.0, TempInvOperation, true);

        XComWeapon(m_kInputContext.Weapon.m_kEntity).bPreviewAim = false;
        bWaitForAnim = true;
        Unit.bChangedWeapon = true;
    }
    else
    {
        if (Unit.LastCoverTypeUsed != eECTTU_UseTurnNode)
        {
            UnitPawn.ActionNode.SetActiveChild(6, Unit.IdleStateMachine.BlendTime);
        }

        // TODO: fix mec-specific logic
        if (Unit.GetCharacter().m_kChar.eClass == eSC_Mec)
        {
            Unit.PriorMecWeapon = Unit.GetInventory().GetActiveWeapon();
            Unit.GetInventory().SetActiveWeapon(m_kInputContext.Weapon);
        }
    }

    if (Unit.LastCoverTypeUsed != eECTTU_UseTurnNode)
    {
        SetUsedAnimNodes(Unit.bChangedWeapon ? 0.0 : Unit.IdleStateMachine.BlendTime);

        if (Unit.LastCoverTypeUsed != eECTTU_UseTurnNode)
        {
            if (UseExitCoverNode != none)
            {
                UseExitCoverNode.SetActiveChild(Unit.LastCoverTypeUsed, Unit.bChangedWeapon ? 0.0 : Unit.IdleStateMachine.BlendTime);
            }

            FinishAnimNodeSequence = UnitPawn.ActionNode.GetTerminalSequence();
            FinishAnimNodeSequence.ReplayAnim();
            bWaitForAnim = true;
        }

        Unit.bSteppingOutOfCover = Unit.LastCoverTypeUsed != eECTTU_UseTurnNode;
    }

    // TODO remove sectopod-specific logic
    if (Unit.LastCoverTypeUsed != eECTTU_UseTurnNode || Unit.GetCharacter().m_eType == ePawnType_Sectopod)
    {
        UnitPawn.ResetAimOffset();
        UnitPawn.ComputeAimOffsetToLocation(m_vTarget, Unit.LastCoverTypeUsed);
        bAimOffsetSet = true;
    }

    ShotWeapon = XComWeapon(m_kInputContext.Weapon.m_kEntity);

    if (ShotWeapon != none)
    {
        UnitPawn.UpdateAimProfile();
        AnimNodeSequence(UnitPawn.WeaponStateNode.Children[eAnimWeaponState_Fire].Anim).SetAnim(ShotWeapon.WeaponFireAnimSequenceName);
    }

    if (bWaitForAnim)
    {
        if (FinishAnimNodeSequence.AnimSeq != none)
        {
            StartGlamCamTime = FMax(FinishAnimNodeSequence.AnimSeq.SequenceLength - 0.50, 0.0);
        }
        else
        {
            StartGlamCamTime = 0.0;
        }

        FinishAnim(FinishAnimNodeSequence, false);
    }
    else if (m_kInputContext.Weapon.GameplayType() != eItem_MecKineticArm) // TODO remove GameplayType
    {
        // TODO glamcam won't work
        bGlamCamActivated = `BATTLE.m_kGlamMgr.TryGlamCam(none, true);
        Sleep(0.50);
    }

    UnitPawn.bSkipRotateToward = false;
    UnitPawn.EnableRMA(false, false);
    UnitPawn.EnableRMAInteractPhysics(false);
    Unit.RestoreHeading = vector(UnitPawn.Rotation);

    if (Unit.bChangedWeapon || (Unit.LastCoverTypeUsed == eECTTU_UseTurnNode && !UnitFacingMatchesDesiredDirection()))
    {
        Unit.IdleStateMachine.ForceHeading(Normal(m_vTarget - UnitPawn.Location));

        while (Unit.IdleStateMachine.IsEvaluatingStance())
        {
            Sleep(0.0);
        }

        UnitPawn.FocusFireBlendTime = 0.250;
    }
    else
    {
        switch (Unit.GetCharType())
        {
            case eChar_Sectoid:
            case eChar_Floater:
            case eChar_Thinman:
            case eChar_Muton:
            case eChar_SectoidCommander:
            case eChar_FloaterHeavy:
            case eChar_MutonElite:
                UnitPawn.FocusFireBlendTime = 0.0;
                break;
            default:
                if (Unit.LastCoverTypeUsed == eECTTU_UseTurnNode)
                {
                    UnitPawn.FocusFireBlendTime = 0.250;
                }
                else
                {
                    UnitPawn.FocusFireBlendTime = 0.0;
                }

                break;
        }
    }

    CompleteAction();
}