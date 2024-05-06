class XGAbility_ClusterBomb extends XGAbility_GameCore
    native(Core)
    dependson(XGInventoryNativeBase)
    notplaceable
    hidecategories(Navigation);

enum EFiringStage
{
    eFS_None,
    eFS_Targetting,
    eFS_Firing,
    eFS_Done,
    eFS_MAX
};

struct CheckpointRecord_XGAbility_ClusterBomb extends CheckpointRecord
{
    var EFiringStage m_eFiringStage;
    var Vector m_vTargetLocation;
    var ELocation m_eStoredEquipSlot;
    var ELocation m_eStoredReEquipSlot;
};

var EFiringStage m_eFiringStage;
var ELocation m_eStoredEquipSlot;
var ELocation m_eStoredReEquipSlot;
var bool m_bInitedStartPoint;
var Vector m_vStartPoint;
var Vector m_vMainTargetDir;