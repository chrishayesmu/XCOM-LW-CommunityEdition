class XGAction_FireCustom_KineticStrike extends Actor
    notplaceable
    hidecategories(Navigation);

var name GenericStrikeStart_AnimName;
var name GenericStrikeStop_AnimName;
var name DestroyHighCover_AnimName;
var name DestroyLowCover_AnimName;
var name MecthoidKill_AnimName;
var name BerserkerKill_AnimName;
var name SectopodKill_AnimName;
var XGUnit m_kUnit;
var XComUnitPawn m_kPawn;
var XGAction_Fire FireAction;
var AnimNodeSequence FinishAnimNodeSequence;
var Vector TargetLocation;
var KineticStrikeAttackInfo AttackInfo;
var ECharacter AttackCharacterType;
var bool bWaitingToDestroyCover;
var bool bWaitingToDamageUnit;
var bool bCinematicStrike;
var name RestoreAttackUnitState;

simulated function Init(){}
simulated function OnKineticStrikeAnimNotify(){}
simulated function DamageEnvironment(){}
function DamageUnit(XGUnit Target){}

auto state Idle
{
}
simulated state Firing
{
}