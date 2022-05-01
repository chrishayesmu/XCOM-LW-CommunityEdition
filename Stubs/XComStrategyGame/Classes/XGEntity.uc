class XGEntity extends Actor
    implements(IMouseInteractionInterface)
dependson(XGStrategyActor);
//complete stub

struct CheckpointRecord
{
    var XGStrategyActor m_kGameActor;
    var XGStrategyActorNativeBase.EEntityGraphic m_eEntityGraphic;
    var int m_iData;

};

var XGStrategyActor m_kGameActor;
var XGStrategyActorNativeBase.EEntityGraphic m_eEntityGraphic;
var int m_iData;
var export editinline ParticleSystemComponent PFX;

function ApplyCheckpointRecord() {}
function AssignGameActor(XGStrategyActor KActor, optional int iData) {}
function Vector2D GetCoords() {}
function Init(XGStrategyActorNativeBase.EEntityGraphic eGraphic) {}
function bool ShouldAllowMousePick(XGStrategyActorNativeBase.EEntityGraphic eGraphic) {}
function bool OnMouseEvent(int Cmd, int Actionmask, optional Vector MouseWorldOrigin, optional Vector MouseWorldDirection, optional Vector HitLocation) {}

defaultproperties
{
    begin object name=PFXComponent0 class=ParticleSystemComponent
        ReplacementPrimitive=none
    end object
    PFX=PFXComponent0

    begin object name=TraceComponent class=CylinderComponent
        CollisionHeight=8.0
        CollisionRadius=8.0
        ReplacementPrimitive=none
        HiddenGame=false
        CollideActors=true
    end object
    CollisionComponent=TraceComponent

    Components(0)=TraceComponent
    Components(1)=PFXComponent0
    bCollideActors=true
}