class XGVolume_DamageOverTimeReplicationInfo extends ReplicationInfo
    hidecategories(Navigation,Movement,Collision);
//complete stub

var repnotify DamageEvent m_kReplicatedDamageEvent;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kReplicatedDamageEvent;
}

simulated event ReplicatedEvent(name VarName){}
