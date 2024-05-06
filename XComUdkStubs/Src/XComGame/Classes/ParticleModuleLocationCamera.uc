class ParticleModuleLocationCamera extends ParticleModuleLocationBase
    native(Particle)
    editinlinenew
    hidecategories(Object,Object,Object);

var Vector m_kOldLocation;
var() float CameraVectorOffset;
var() float VelocityCompensation;

defaultproperties
{
    bSpawnModule=true
}