class LWCE_XGMission_ShipLanded extends LWCE_XGMission;

struct CheckpointRecord_LWCE_XGMission_ShipLanded extends CheckpointRecord_LWCE_XGMission
{
    var LWCE_XGShip m_kShip;
};

var LWCE_XGShip m_kShip;

function name GetSubtype()
{
    return m_kShip.m_nmShipTemplate;
}