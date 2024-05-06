class ParticleModuleLocationRandomTemplate extends ParticleModule
    abstract
    native(Particle)
    editinlinenew
    hidecategories(Object,Object);

var() bool bForceSpawnOnFloor;
var() bool bIgnoreNonAxisAlignedTiles;
var() bool bUseFlameThrowerTiles;
var() bool bUseBucketWeighting;
var() int iFloorTileSearchDown;
var() float fWeightScaleDown;
var() float fWeightScaleUp;
var transient array<float> BucketWeights;
var transient int iPreviousBucketSpawn;

defaultproperties
{
    iFloorTileSearchDown=1
    fWeightScaleDown=0.250
    fWeightScaleUp=2.0
    iPreviousBucketSpawn=-1
    bSpawnModule=true
}