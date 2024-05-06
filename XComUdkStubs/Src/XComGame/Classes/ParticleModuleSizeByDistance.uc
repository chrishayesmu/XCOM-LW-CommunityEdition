class ParticleModuleSizeByDistance extends ParticleModuleSizeBase
    native(Particle)
    editinlinenew
    hidecategories(Object,Object,Object);

var(Size) RawDistributionFloat SizeMultiplierVsDistance;
var(Size) RawDistributionFloat MaxDistanceVariable;
var(Size) float MaxDistance;

defaultproperties
{
    MaxDistance=40.0
    bUpdateModule=true
    bSupported3DDrawMode=true
}