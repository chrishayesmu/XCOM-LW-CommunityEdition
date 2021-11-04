class XComProjectile_DeadProxy extends XComProjectile
    native(Weapon);
//complete stub

simulated function Explode(Vector HitLocation, Vector HitNormal);
singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp);
simulated event ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal);
simulated event Tick(float DeltaTime);
simulated event PostBeginPlay(){}
simulated event Destroyed();
