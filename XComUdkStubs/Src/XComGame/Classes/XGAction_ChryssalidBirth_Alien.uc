class XGAction_ChryssalidBirth_Alien extends XGAction_MatineeControlled
    notplaceable
    hidecategories(Navigation);

enum eBirthActionStatus
{
    eBAS_None,
    eBAS_WaitForVictimAnimation,
    eBAS_WaitForGlamCam,
    eBAS_Completed,
    eBAS_MAX
};

struct InitialReplicationData_XGAction_ChryssalidBirth_Alien
{
    var XGUnit m_kHatchedFrom;
    var bool m_bHatchedFromNone;
};

var XGUnit m_kHatchedFrom;
var bool m_bGlamCamSuccess;
var private bool m_bInitialReplicationDataReceived_XGAction_ChryssalidBirth_Alien;
var XGAction_ChryssalidBirth_Alien.eBirthActionStatus m_eBirthActionStatus;
var private repnotify repretry InitialReplicationData_XGAction_ChryssalidBirth_Alien m_kInitialReplicationData_XGAction_ChryssalidBirth_Alien;

defaultproperties
{
    m_VariableLinkName="Cryssalid"
}