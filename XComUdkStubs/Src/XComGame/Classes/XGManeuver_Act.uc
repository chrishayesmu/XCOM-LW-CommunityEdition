class XGManeuver_Act extends XGManeuver
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XGManeuver_Act extends CheckpointRecord
{
    var array<XGUnit> m_arrTargets;
};

var array<XGUnit> m_arrTargets;