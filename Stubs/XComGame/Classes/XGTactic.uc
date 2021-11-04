class XGTactic extends XGOvermindActor;
//complete stub

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

function Init(XGPod kPod, EPodTactic eTactic){}
function XGManeuver GetNextManeuver(){}
function bool IsComplete(){}
function AddMoveManeuver(EManeuverType eManeuver, Vector vLoc, optional bool bInsertFirst)
{}
function AddActManeuver(EManeuverType eManeuver, optional array<XGUnit> arrTargets, optional bool bInsertFirst)
{}
function EPodAnimation GetPodAnim()
{}
event Destroyed()
{}
function ClearManeuvers()
{}
function TTile GetVerifiedTile(Vector vDesiredPoint)
{}
DefaultProperties
{
}
