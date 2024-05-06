class XComDamageType_Explosion extends XComDamageType
    native(Weapon)
    hidecategories(Object);

// TODO
defaultproperties
{
    bCausesFracture=true
    bKRadialImpulse=true
    KDamageImpulse=600.0
    KDeathUpKick=400.0
    KImpulseRadius=500.0
    RadialDamageImpulse=1000.0
    // DamagedFFWaveform=ForceFeedbackWaveform'Default__XComDamageType_Explosion.ForceFeedbackWaveform0'
    // KilledFFWaveform=ForceFeedbackWaveform'Default__XComDamageType_Explosion.ForceFeedbackWaveform1'
}