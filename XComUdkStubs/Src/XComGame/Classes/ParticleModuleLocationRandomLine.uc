class ParticleModuleLocationRandomLine extends ParticleModuleLocationRandomTemplate
    native(Particle)
    editinlinenew
    hidecategories(Object,Object,Object);

var() RawDistributionFloat LengthDistribution;
var() RawDistributionFloat DistancePerBucketDistribution;
var transient float fCurrentSegmentLength;
var transient array<float> BucketSizes;

// TODO defaultproperties