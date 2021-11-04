class XComDamageType extends DamageType
    native(Core);
//complete stub

var() bool bCausesFire;
var() bool bDamageUnits;

static function bool CausesRagDoll(XComUnitPawn ForPawn){}

static function bool CausesSurroundingAreaDamage(class<DamageType> inDamageType){}

static function bool DamageTypeSetsFires(class<DamageType> inDamageType, XComProjectile InProjectile, out int FireIntensity){}

native static final function bool DealDamage(out DamageEvent InDamageEvent);

native static final function bool DealDamageWithDamageFrame(out DamageEvent InDamageEvent);

static function DamageEvent CreateEvent(int InDamageAmount, Actor InstigatedByActor, Vector HurtOrigin, Vector Momentum, class<DamageType> inDamageType, optional TraceHitInfo TracedHitInfo, optional Actor InDamageCauser){}
static function DamageEvent CreateEventEx(Actor InstigatedByActor, Actor InDamageCauser, Actor InDamageTarget, float InDamageAmount, float InDamageRadius, class<DamageType> inDamageType, Vector Momentum, Vector HurtOrigin, optional Actor IgnoredActor, optional TraceHitInfo TracedHitInfo, optional bool bIsHit){}
