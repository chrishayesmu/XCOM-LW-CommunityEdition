class XGAction_Turn extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialiReplicationData_XGAction_Turn
{
    var Vector m_vFacePoint;
    var bool m_bIgnoreMovingCursor;
    var bool m_bForceReplicate;
};

var transient Vector m_vFacePoint;
var transient Vector m_vFaceDir;
var bool m_bIgnoreMovingCursor;
var transient bool m_bInitialReplicationDataReceived_XGAction_Turn;
var repnotify transient InitialiReplicationData_XGAction_Turn m_kInitialReplicationData_XGAction_Turn;
var float m_fTurnTimer;

defaultproperties
{
    m_bBlocksInput=true
    m_bRequiresAccuratePositioning=true
}