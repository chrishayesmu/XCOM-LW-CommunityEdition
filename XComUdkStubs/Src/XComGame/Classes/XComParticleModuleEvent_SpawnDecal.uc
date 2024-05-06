class XComParticleModuleEvent_SpawnDecal extends ParticleModuleEventSendToGame
    editinlinenew
    hidecategories(Object,Object);

var() editinline DecalCue Materials;
var() DecalProperties SpawnDecalProperties;
var() Vector DefaultNormal;

defaultproperties
{
    SpawnDecalProperties=(DecalWidthLow=200.0,DecalWidthHigh=200.0,DecalHeightLow=200.0,DecalHeightHigh=200.0,DecalDepth=200.0,DecalLifeSpan=0.0,DecalBackfaceAngle=0.0010,bUseRandomRotation=true,DecalBlendRange=(X=89.50,Y=180.0),SortOrder=0)
    DefaultNormal=(X=0.0,Y=0.0,Z=-1.0)
}