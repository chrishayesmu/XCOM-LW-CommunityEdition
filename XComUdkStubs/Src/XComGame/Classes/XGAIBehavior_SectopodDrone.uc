class XGAIBehavior_SectopodDrone extends XGAIBehavior_FlyingUnit
    notplaceable
    hidecategories(Navigation);

enum EDroneMode
{
    eDM_Repair,
    eDM_Attack,
    eDM_Overload,
    eDM_Scout,
    eDM_Escort,
    eDM_None,
    eDM_MAX
};

struct CheckpointRecord_XGAIBehavior_SectopodDrone extends CheckpointRecord
{
    var XGUnit m_kRepairTarget;
};

var XGUnit m_kRepairTarget;
var EDroneMode m_eDroneMode;

defaultproperties
{
    m_bShouldIgnoreCover=true
    m_bCanIgnoreCover=true
    m_bIgnoreOverwatchers=true
}