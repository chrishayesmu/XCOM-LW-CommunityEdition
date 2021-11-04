class XComMeldContainerSpawnPoint extends Actor
    hidecategories(Navigation)
    placeable;
//complete stub

enum EMeldContainerDifficulty
{
    eMeldContainerDifficulty_Easy,
    eMeldContainerDifficulty_Hard,
    eMeldContainerDifficulty_MAX
};

var() name m_nDisarmedRemoteEvent;
var() name m_nSelfDestructRemoteEvent;
var() name m_nDestroyedRemoteEvent;
var() EMeldContainerDifficulty m_eDifficulty;
var() int m_iDestroyedOnTurn;
var() int m_iSpawnGroup;
var() bool m_bBeginCountdownWhenSeen;

defaultproperties
{
    m_iDestroyedOnTurn=3
    Components(0)=none
    Components(1)=none
    bTickIsDisabled=true
    bMovable=false
    bCollideWhenPlacing=true
}