class SeqAct_ViewActiveUnit extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var Actor TargetActor;
var() bool bTrackToCursor;
var private InterpCurveFloat m_kSpeedCurve_Slow;

defaultproperties
{
    m_kSpeedCurve_Slow=(Points[0]=(InVal=0.0,OutVal=0.0), Points[1]=(InVal=32.0000000,OutVal=4.0000000),
                        Points(2)=(InVal=64.0000000,OutVal=16.0000000),
                        Points(3)=(InVal=128.0000000,OutVal=64.0000000),
                        Points(4)=(InVal=1024.0000000,OutVal=2048.0000000),
                        Points(5)=(InVal=2048.0000000,OutVal=4096.0000000),
                        InterpMethod=IMT_UseFixedTangentEvalAndNewAutoTangents)
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    ObjName="View Active Unit"
}