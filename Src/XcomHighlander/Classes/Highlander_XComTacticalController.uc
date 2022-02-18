class Highlander_XComTacticalController extends XComTacticalController;

reliable server function ServerPerformRaisingTargetWithFireAction(optional XGUnit kTargetedUnit = none, optional bool forceNewAction = false)
{
    local XGAction_Targeting kNewAction;
    local int I;

    `HL_LOG_CLS("ServerPerformRaisingTargetWithFireAction");

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

    kNewAction = Spawn(class'Highlander_XGAction_Targeting', self);
    kNewAction.Init(m_kActiveUnit);
    kNewAction.SetInitialUnitTarget(kTargetedUnit);
    m_kActiveUnit.AddAction(kNewAction);
}

defaultproperties
{
    m_kPresentationLayerClass=class'Highlander_XComPresentationLayer'
    CheatClass=class'Highlander_XComTacticalCheatManager'
    InputClass=class'Highlander_XComTacticalInput'
}