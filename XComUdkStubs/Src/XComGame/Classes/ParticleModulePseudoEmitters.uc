class ParticleModulePseudoEmitters extends ParticleModuleSpawnBase
    native(Particle)
    editinlinenew
    hidecategories(Object,Object,Object,Spawn,Burst);

enum ReadWriteOption
{
    eStoreLocations,
    eSpawnFromLocations,
    ReadWriteOption_MAX
};

var() ReadWriteOption m_ModuleOperations;
var(PseudoEmitter) name m_sEmitterName;
var(PseudoEmitter) float m_fActivationDelay;
var(PseudoEmitter) float m_fDuration;
var(PseudoEmitter) float m_fSpawnRate;
var native transient Pointer m_pEmitterWithStoredData;
var transient int m_iMinSpawningEmitterIndex;
var transient int m_iMaxSpawningEmitterIndex;

defaultproperties
{
    m_ModuleOperations=eSpawnFromLocations
    m_fActivationDelay=1.0
    m_fDuration=2.0
    m_fSpawnRate=1.0
    m_iMinSpawningEmitterIndex=-1
    m_iMaxSpawningEmitterIndex=-1
    bSpawnModule=true
}