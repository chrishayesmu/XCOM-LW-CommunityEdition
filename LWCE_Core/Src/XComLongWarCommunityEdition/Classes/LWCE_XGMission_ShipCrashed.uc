class LWCE_XGMission_ShipCrashed extends LWCE_XGMission;

struct CheckpointRecord_LWCE_XGMission_ShipCrash extends CheckpointRecord_LWCE_XGMission
{
    var name m_nmShipType;
    var LWCE_TObjective m_kShipObjective;
    var int m_iCounter;
};

var name m_nmShipType;
var LWCE_TObjective m_kShipObjective;
var int m_iCounter;

function name GetSubtype()
{
    return m_nmShipType;
}