class XComAlienPathHandler extends Actor
    notplaceable
    hidecategories(Navigation);

const DOOR_HANG_TIME_OUT_SECONDS = 12.0f;

var XComAlienPod m_kPod;
var float m_fPathingDistancePerTurn;
var int m_iLastVisitedTerminal;
var int m_iLastNode;
var bool m_bPartialPath;
var bool m_bHasBegunTrippedPatrol;
var float m_fDistanceRemaining;
var array<XGUnit> m_arrTrippedUnit;
var int m_iNextVisibleNode;
var int m_iCurrInteraction;
var int m_iWaitCounter;
var float m_fDoorHangTimer;

defaultproperties
{
    m_fPathingDistancePerTurn=30.0
    m_iNextVisibleNode=-1
    m_iCurrInteraction=-1
}