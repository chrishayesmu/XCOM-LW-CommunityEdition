class XGAction_CriticallyWounded extends XGAction
    notplaceable
    hidecategories(Navigation);

var float fTimeOut;
var bool m_bOnLoadGame;
var transient AnimNodeSequence tmpAnimSequence;

defaultproperties
{
    fTimeOut=5.0
    m_bReplicateFinalPawnLocation=true
    m_bShouldUpdateOvermind=true
}