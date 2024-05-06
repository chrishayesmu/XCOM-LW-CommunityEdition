class XGEnemyPod extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var array<XGEnemyUnit> m_arrMembers;
    var Vector m_vCoverDirection;
    var Vector m_vCenter;
    var float m_fRadius;
    var array<XGPod> m_arrFighting;
    var bool m_bCanSee;
    var int m_iTurnsSinceVisible;
};

var array<XGEnemyUnit> m_arrMembers;
var Vector m_vCoverDirection;
var Vector m_vCenter;
var float m_fRadius;
var array<XGPod> m_arrFighting;
var bool m_bCanSee;
var int m_iTurnsSinceVisible;

defaultproperties
{
    m_iTurnsSinceVisible=1000
}