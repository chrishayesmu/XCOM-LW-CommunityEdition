class XGVolumeMgr extends Actor
    native
    notplaceable
    hidecategories(Navigation);

const MAX_VOLUMES = 255;

struct CheckpointRecord
{
    var XGVolume m_aVolumes[255];
    var int m_iNumVolumes;
};

var XGVolume m_aVolumes[255];
var int m_iNumVolumes;
var bool m_bResolveSplashDamage;
var array<TVolume> m_arrTVolumes;
var array<XGVolume> m_arrDelayAddVolumes;

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bTickIsDisabled=true
    bAlwaysRelevant=true
}