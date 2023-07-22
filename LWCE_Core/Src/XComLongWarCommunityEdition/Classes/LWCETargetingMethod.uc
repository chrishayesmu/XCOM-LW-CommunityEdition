class LWCETargetingMethod extends Object
    abstract;

var protectedwrite LWCE_XGAbility m_kAbility;
var protectedwrite LWCE_XGUnit m_kFiringUnit;

var private XComEmitter m_kRadiusEmitter;

function Init(LWCE_XGAbility kAbility, int TargetIndex)
{
    m_kAbility = kAbility;
    m_kFiringUnit = LWCE_XGUnit(m_kAbility.m_kUnit);

    m_kRadiusEmitter = `BATTLE.Spawn(class'XComEmitter');
    // TODO: differentiate disc and sphere AOEs
    m_kRadiusEmitter.SetTemplate(ParticleSystem(DynamicLoadObject("UI_Range.Particles.BlastRadius_Shpere", class'ParticleSystem')));
    m_kRadiusEmitter.LifeSpan = 0.0;
    m_kRadiusEmitter.ParticleSystemComponent.DeactivateSystem();

    DirectSetTarget(TargetIndex);
}

/// <summary>
/// Called when the player chooses to cancel without using the ability.
/// </summary>
function Canceled()
{
    CleanUpActors();
}

/// <summary>
/// Called when the player confirms their choice to use the selected ability.
/// </summary>
function Committed()
{
    CleanUpActors();
}

function DirectSetTarget(int TargetIndex);
function NextTarget();
function PreviousTarget();

function bool GetAdditionalTargets(out LWCE_TAvailableTarget AdditionalTargets)
{
	return false;
}

protected function CleanUpActors()
{
    if (m_kRadiusEmitter != none)
    {
        m_kRadiusEmitter.Destroy();
        m_kRadiusEmitter = none;
    }
}

/// <summary>
/// If the given index is out of bounds for the ability's targets, wraps it around until
/// it's in range again.
/// </summary>
protected function int WrapTargetIndex(int Index)
{
    Index = Index % m_kAbility.arrTargetOptions.Length;

    if (Index < 0)
    {
        // Technically this might not be in bounds still, but if someone passes a value that negative, they deserve
        // to have things break on them
        Index = Index + m_kAbility.arrTargetOptions.Length;
    }

    return Index;
}