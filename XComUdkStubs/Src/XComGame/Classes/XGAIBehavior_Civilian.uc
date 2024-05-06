class XGAIBehavior_Civilian extends XGAIBehavior
    native(AI)
    notplaceable
    hidecategories(Navigation);

enum ETerrorStatus
{
    eTS_InDanger,
    eTS_Saved,
    eTS_Dead,
    eTS_MAX
};

struct CheckpointRecord_XGAIBehavior_Civilian extends CheckpointRecord
{
    var ETerrorStatus m_eTerrorStatus;
    var bool m_bDrawProximityRing;
};

var bool m_bRunToDropship;
var bool m_bIsAtDropship;
var bool m_bDrawProximityRing;
var int m_iMoveTimeStart;
var ETerrorStatus m_eTerrorStatus;

defaultproperties
{
    m_bSimultaneousMoving=true
}