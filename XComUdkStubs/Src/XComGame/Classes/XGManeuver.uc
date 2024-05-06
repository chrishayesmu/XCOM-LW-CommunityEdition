class XGManeuver extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var EManeuverType m_eManeuver;
    var bool m_bComplete;
    var bool m_bStarted;
    var bool m_bSuccess;
    var array<XGUnit> m_arrOnTask;
    var array<EManeuverStatus> m_arrStatus;
};

var EManeuverType m_eManeuver;
var bool m_bComplete;
var bool m_bStarted;
var bool m_bSuccess;
var array<XGUnit> m_arrOnTask;
var array<EManeuverStatus> m_arrStatus;