class XComMeldContainerSpawnPoint extends Actor
    placeable
    hidecategories(Navigation);

enum EMeldContainerDifficulty
{
    eMeldContainerDifficulty_Easy,
    eMeldContainerDifficulty_Hard,
    eMeldContainerDifficulty_MAX
};

var() const name m_nDisarmedRemoteEvent;
var() const name m_nSelfDestructRemoteEvent;
var() const name m_nDestroyedRemoteEvent;
var() XComMeldContainerSpawnPoint.EMeldContainerDifficulty m_eDifficulty;
var() int m_iDestroyedOnTurn;
var() const int m_iSpawnGroup;
var() const bool m_bBeginCountdownWhenSeen;

defaultproperties
{
    m_iDestroyedOnTurn=3
    Components(0)=none
    Components(1)=none
    bTickIsDisabled=true
    bMovable=false
    bCollideWhenPlacing=true
}