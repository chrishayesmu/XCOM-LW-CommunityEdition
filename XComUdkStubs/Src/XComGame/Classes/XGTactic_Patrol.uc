class XGTactic_Patrol extends XGTactic
    notplaceable
    hidecategories(Navigation);

const OVERMIND_PATROL_PADDING = 144.0f;

struct CheckpointRecord_XGTactic_Patrol extends CheckpointRecord
{
    var int m_iBuilding;
    var TRect m_kPatrolRect;
    var bool m_bHorizontal;
    var bool m_bDirectionToggle;
};

var int m_iBuilding;
var TRect m_kPatrolRect;
var bool m_bHorizontal;
var bool m_bDirectionToggle;

defaultproperties
{
    m_strName="PATROL"
}