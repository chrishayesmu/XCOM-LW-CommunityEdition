class XComSeqAct_SetStormIntensity extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() StormIntensity_t m_eStormIntensity;
var() int m_RainSoundIntensity;
var() float m_fThunderClapProbability;
var() float m_fRainScale;

defaultproperties
{
    VariableLinks.Empty()
    ObjName="Set Storm Intensity"
}