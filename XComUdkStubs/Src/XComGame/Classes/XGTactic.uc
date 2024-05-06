class XGTactic extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var XGPod m_kPod;
    var EPodTactic m_eTactic;
    var array<XGManeuver> m_arrManeuvers;
    var int m_iTurnsActive;
    var float m_fParameter;
    var string m_strName;
};

var XGPod m_kPod;
var EPodTactic m_eTactic;
var array<XGManeuver> m_arrManeuvers;
var int m_iTurnsActive;
var float m_fParameter;
var string m_strName;