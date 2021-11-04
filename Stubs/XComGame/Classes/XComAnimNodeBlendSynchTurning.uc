class XComAnimNodeBlendSynchTurning extends AnimNodeBlendList
    native(Animation);
//completet stub

var bool m_bIsTurnZeroValid;
var float m_fPreviousTargetDirAngle;
// Export UXComAnimNodeBlendSynchTurning::execStartTurning(FFrame&, void* const)
native function StartTurning();

// Export UXComAnimNodeBlendSynchTurning::execFinishedTurning(FFrame&, void* const)
native function bool FinishedTurning();

// Export UXComAnimNodeBlendSynchTurning::execStopTurning(FFrame&, void* const)
native function StopTurning(optional bool bSetRotationToFocalPoint=true);
