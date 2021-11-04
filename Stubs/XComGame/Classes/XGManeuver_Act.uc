class XGManeuver_Act extends XGManeuver
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord_XGManeuver_Act extends CheckpointRecord
{
    var array<XGUnit> m_arrTargets;
};

var array<XGUnit> m_arrTargets;

function InitAct(EManeuverType eManeuver, array<XGUnit> arrTargets)
{}