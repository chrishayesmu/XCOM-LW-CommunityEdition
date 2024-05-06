class XComLadder extends XComLevelActor
    native(Level)
    hidecategories(Navigation);

enum ELadderType
{
    eLadderType_Ladder,
    eLadderType_Pipe,
    eLadderType_AirLift,
    eLadderType_MAX
};

var() int LoopAnimations;
var() privatewrite deprecated float Depth;
var export editinline transient LineBatchComponent LineBatch;
var export editinline StaticMeshComponent StaticMesh;
var() ELadderType eType;
var export editinline ParticleSystemComponent AlienAirLiftPSC;
var privatewrite ParticleSystem AlienAirLiftUpFX;
var privatewrite ParticleSystem AlienAirLiftDownFX;