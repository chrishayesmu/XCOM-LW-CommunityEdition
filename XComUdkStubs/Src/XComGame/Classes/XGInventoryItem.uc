class XGInventoryItem extends XGItem
    native(Core)
    notplaceable
    hidecategories(Navigation);

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

defaultproperties
{
    m_eEquipLocation=eSlot_RightHand
    m_eReserveLocation=eSlot_RightBack
    m_bSpawnEntity=true
}