class XGManeuver_Move extends XGManeuver
    notplaceable
    hidecategories(Navigation);

const IN_RANGE_DISTANCE = 640;

struct CheckpointRecord_XGManeuver_Move extends CheckpointRecord
{
    var Vector m_vLocation;
    var float m_fRange;
    var bool m_bReveal;
};

var Vector m_vLocation;
var float m_fRange;
var bool m_bReveal;