class XGInventoryItem extends XGItem
    native(Core)
	dependson(XGInventoryNativeBase);
//complete stub

struct CheckpointRecord_XGInventoryItem extends CheckpointRecord
{
    var ELocation m_eSlot;
    var EItemType m_eType;
    var XGUnit m_kOwner;
};

var ELocation m_eSlot;
var ELocation m_eReservedSlot;
var ELocation m_eEquipLocation;
var ELocation m_eReserveLocation;
var XGUnit m_kOwner;
var export editinline MeshComponent m_kMeshComponent;
var Actor m_kEntity;
var bool m_bSpawnEntity;

simulated function Init();
simulated event PreBeginPlay(){}
simulated function Actor CreateEntity(){}
simulated function AttachEntityMesh(Actor kEntity){};
simulated function bool IsGrenade(){}
simulated function bool IsRearBackPackItem(){}
