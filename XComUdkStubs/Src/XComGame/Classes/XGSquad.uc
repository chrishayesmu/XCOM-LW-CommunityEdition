class XGSquad extends XGSquadNativeBase
    notplaceable
    hidecategories(Navigation);

const MAX_SQUAD_VOLUMES = 16;

struct CheckpointRecord_XGSquad extends CheckpointRecord
{
    var XGDropshipCargoInfo m_kDropshipCargo;
    var int m_iBadge;
    var XGVolume m_aVolumes;
    var int m_iNumVolumes;
};

var XGVolume m_aVolumes[16];
var int m_iNumVolumes;
var XGDropshipCargoInfo m_kDropshipCargo;
var protected int m_iBadge;
var private array<XGUnit> m_arrSortedUnits;

delegate bool CheckUnitDelegate(XGUnit kUnit)
{
}

delegate VisitUnitDelegate(XGUnit kUnit)
{
}

defaultproperties
{
    m_clrColors=(R=255,G=0,B=0,A=128)
    m_iLeader=-1
    RemoteRole=ROLE_SimulatedProxy
    bTickIsDisabled=true
    bAlwaysRelevant=true
}