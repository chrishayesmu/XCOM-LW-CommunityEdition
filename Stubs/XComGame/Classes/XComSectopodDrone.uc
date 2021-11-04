class XComSectopodDrone extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var() ParticleSystem OverloadParticleSystem;

simulated function SpawnOverloadParticles()
{
    WorldInfo.MyEmitterPool.SpawnEmitter(OverloadParticleSystem, Location, rotator(vect(0.0, 0.0, 1.0)));
}
