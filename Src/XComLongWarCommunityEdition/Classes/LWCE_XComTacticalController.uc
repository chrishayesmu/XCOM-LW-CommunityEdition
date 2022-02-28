class LWCE_XComTacticalController extends XComTacticalController;

reliable server function ServerPerformRaisingTargetWithFireAction(optional XGUnit kTargetedUnit = none, optional bool forceNewAction = false)
{
    local XGAction_Targeting kNewAction;
    local int I;

    if (`BATTLE.IsTurnTimerCloseToExpiring())
    {
        ClientFailedPerformingRaisingTargetWithFireAction();
        return;
    }

    if (m_kActiveUnit == none || m_kActiveUnit.IsPerformingAction())
    {
        ClientFailedPerformingRaisingTargetWithFireAction();
        return;
    }

    for (I = 0; I < m_kActiveUnit.GetSquad().GetNumMembers(); I++)
    {
        if (m_kActiveUnit.GetSquad().GetMemberAt(I).IsMoving())
        {
            ClientFailedPerformingRaisingTargetWithFireAction();
            return;
        }
    }

    kNewAction = XGAction_Targeting(m_kActiveUnit.GetAction());

    if (kNewAction != none && !forceNewAction)
    {
        return;
    }

    kNewAction = Spawn(class'LWCE_XGAction_Targeting', self);
    kNewAction.Init(m_kActiveUnit);
    kNewAction.SetInitialUnitTarget(kTargetedUnit);
    m_kActiveUnit.AddAction(kNewAction);
}

defaultproperties
{
    m_kPresentationLayerClass=class'LWCE_XComPresentationLayer'
    CheatClass=class'LWCE_XComTacticalCheatManager'
    InputClass=class'LWCE_XComTacticalInput'
}