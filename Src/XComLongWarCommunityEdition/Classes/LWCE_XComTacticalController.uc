class LWCE_XComTacticalController extends XComTacticalController;

function InitInputSystem()
{
    super.InitInputSystem();

    class'LWCE_UIKeybindingsPCScreen'.static.ApplyCustomKeybinds(PlayerInput);
}

function ParsePath(XGUnit kUnit, optional bool bNoCost = false, optional bool bSpeak = false, optional XGAbility kAbility = none, optional bool bSpawnedAlienWalkIn = false, optional XComSpawnPoint_Alien kSpawnPt = none, optional bool bOverwatch = false)
{
    if (Role == ROLE_Authority)
    {
        `LWCE_VISHELPER.MoveHelpersOutOfTheWay();
    }

    if (class'LWCETacticalVisibilityHelper'.static.IsVisHelper(kUnit))
    {
        return;
    }

    super.ParsePath(kUnit, bNoCost, bSpeak, kAbility, bSpawnedAlienWalkIn, kSpawnPt, bOverwatch);
}

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