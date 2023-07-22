class LWCETargetingMethod_OverTheShoulder extends LWCETargetingMethod;

var protected int LastTarget;
var protected XGCameraView_AimingThirdPerson m_kCameraView;

var private XComPresentationLayer m_kPres;

function Init(LWCE_XGAbility kAbility, int TargetIndex)
{
    m_kPres = `BATTLE.PRES();

    m_kCameraView = `BATTLE.Spawn(class'XGCameraView_AimingThirdPerson');
    m_kCameraView.SetShooter(kAbility.m_kUnit.m_kPawn);

    if (kAbility.m_kUnit.IsInside())
    {
        m_kCameraView.SetIndoorAngle(true);
    }

    m_kPres.HideFriendlySquadStatistics();
    m_kPres.UIAbilityMenu();

    m_kPres.GetCamera().SetCurrentView(m_kCameraView);

    super.Init(kAbility, TargetIndex);
}

function Canceled()
{
    super.Canceled();

    // TODO this isn't moving the camera back to its old position
    m_kPres.PopTargetingStates();
    m_kPres.ShowFriendlySquadStatistics();
    m_kPres.GetCamera().ResetView(/* bCut */ false);
}

function Committed()
{
    super.Committed();

    // TODO: retain the camera if the ability wants to reuse it
    m_kPres.PopTargetingStates();
    m_kPres.ShowFriendlySquadStatistics();
    m_kPres.GetCamera().ResetView(/* bCut */ false);
}

function DirectSetTarget(int TargetIndex)
{
    `LWCE_LOG_CLS("Incoming index: " $ TargetIndex);
    TargetIndex = WrapTargetIndex(TargetIndex);
    `LWCE_LOG_CLS("Setting target to index " $ TargetIndex $ ": " $ m_kAbility.arrTargetOptions[TargetIndex].kTarget.kPrimaryTarget.m_kCharacter.GetName());

    NotifyTargetTargeted(LastTarget,  /* bIsTargeted */ false);
    NotifyTargetTargeted(TargetIndex, /* bIsTargeted */ true);

    // TODO: copy headshot-targeting logic from XGAction_Targeting
    m_kCameraView.SetTarget(m_kAbility.arrTargetOptions[TargetIndex].kTarget.kPrimaryTarget.m_kPawn.Location, m_kAbility.arrTargetOptions[TargetIndex].kTarget.kPrimaryTarget);
    m_kPres.GetCamera().SetCurrentView(m_kCameraView);

    LastTarget = TargetIndex;
}

function NextTarget()
{
    DirectSetTarget(LastTarget + 1);
}

function PreviousTarget()
{
    DirectSetTarget(LastTarget - 1);
}

protected function NotifyTargetTargeted(int TargetIndex, bool bIsTargeted)
{
	local XGUnit TargetUnit;

    if (TargetIndex == -1)
    {
        return;
    }

    TargetUnit = m_kAbility.arrTargetOptions[TargetIndex].kTarget.kPrimaryTarget;

	if (TargetUnit != None)
	{
        // TODO: adjust to EW's APIs
		// only have the target peek if he isn't peeking into the shooters tile. Otherwise they get really kissy.
		// setting the "bTargeting" flag will make the unit do the hold peek.
		// TargetUnit.IdleStateMachine.bTargeting = bIsTargeted && !FiringUnit.HasSameStepoutTile(TargetUnit);
		// TargetUnit.IdleStateMachine.CheckForStanceUpdate();
	}
}

defaultproperties
{
    LastTarget=-1
}