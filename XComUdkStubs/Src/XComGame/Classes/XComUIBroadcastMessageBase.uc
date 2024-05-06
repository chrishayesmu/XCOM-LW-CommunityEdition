class XComUIBroadcastMessageBase extends Actor
    abstract
    notplaceable
    hidecategories(Navigation);

defaultproperties
{
    m_eTeam=eTeam_All
    RemoteRole=ROLE_SimulatedProxy
    bNetTemporary=true
    bOnlyRelevantToFriendlies=true
    LifeSpan=5.0
}