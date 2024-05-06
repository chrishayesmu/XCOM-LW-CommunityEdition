class XComDirectedTacticalExperience extends Actor
    native(Level)
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var array<string> PlaybackScript;
    var int CurrentSequence;
    var bool bEnabled;
    var bool m_bAllowFiring;
    var bool m_bAliensDealDamage;
    var array<int> m_arrButtonsBlocked;
    var bool m_bDisplayedOffscreenMessage;
};

var() bool bEnabled;
var bool m_bAllowFiring;
var bool m_bAliensDealDamage;
var bool m_bLoadedFromSaveEnabled;
var private bool m_bDisplayedOffscreenMessage;
var() array<string> PlaybackScript;
var int CurrentSequence;
var private transient int m_iInvalidClicks;
var private transient XGUnit m_kClickedUnit;
var private transient int m_iInvalidTurn;
var private transient Vector m_vCameraLookAt;
var int m_iNextSequenceOverride;
var array<int> m_arrButtonsBlocked;
var private transient float m_fTickTime;
var private transient XGUnit m_kPrevActiveUnit;

defaultproperties
{
    bEnabled=true
    m_bAllowFiring=true
    m_bAliensDealDamage=true
    CurrentSequence=-1
    m_iNextSequenceOverride=-1
}