class XGAction_FireCustom_KineticStrike extends Actor
    notplaceable
    hidecategories(Navigation);

var private name GenericStrikeStart_AnimName;
var private name GenericStrikeStop_AnimName;
var private name DestroyHighCover_AnimName;
var private name DestroyLowCover_AnimName;
var private name MecthoidKill_AnimName;
var private name BerserkerKill_AnimName;
var private name SectopodKill_AnimName;
var private XGUnit m_kUnit;
var private XComUnitPawn m_kPawn;
var private XGAction_Fire FireAction;
var private AnimNodeSequence FinishAnimNodeSequence;
var private Vector TargetLocation;
var private KineticStrikeAttackInfo AttackInfo;
var private ECharacter AttackCharacterType;
var private bool bWaitingToDestroyCover;
var private bool bWaitingToDamageUnit;
var private bool bCinematicStrike;
var private name RestoreAttackUnitState;

defaultproperties
{
    GenericStrikeStart_AnimName=AC_NO_GenericStrike_StartA
    GenericStrikeStop_AnimName=AC_NO_GenericStrike_StopA
    DestroyHighCover_AnimName=AC_NO_StrikeVsHighWall
    DestroyLowCover_AnimName=AC_NO_StrikeVsLowWall
    MecthoidKill_AnimName=AC_NO_StrikeVsMechtoid
    BerserkerKill_AnimName=AC_NO_StrikeVsBerserker
    SectopodKill_AnimName=AC_NO_StrikeVsSectopod
}